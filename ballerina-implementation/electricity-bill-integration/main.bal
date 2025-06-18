import ballerina/http;
import ballerina/log;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/time;

listener http:Listener electicitybill = new (port = 8080);

configurable string dbHost = ?;
configurable string dbUser = ?;
configurable string dbPassword = ?;
configurable string dbName = ?;
configurable int dbPort = ?;

final mysql:Client dbClient = check new (
    host = dbHost,
    user = dbUser,
    password = dbPassword,
    database = dbName,
    port = dbPort
);

service / on electicitybill {
    resource function post pay(@http:Payload BillPaymentRequest payload) returns error|BillPaymentResponse {
        log:printInfo("Received payment request" + payload.toString());

        BillDetails|error queryResult = dbClient->queryRow(
            `SELECT dueAmount, duePending FROM EB_Bill_Service WHERE uid = ${payload.uid}`
        );

        if (queryResult is error) {
            log:printError("Error querying the database", 'error = queryResult);
            return error("Failed to retrieve bill details");
        }

        MPesaAccount|error mPesaResult = dbClient->queryRow(
            `SELECT balance FROM MPesa_Account_Info WHERE accNum = ${payload.acc_num}`
        );

        if (mPesaResult is error) {
            log:printError("Error querying MPesa account", 'error = mPesaResult);
            return error("Failed to retrieve MPesa account details");
        }

        if mPesaResult.balance < queryResult.dueAmount {
            log:printError("Insufficient MPesa balance");
            return error("Insufficient MPesa balance for payment");
        }

        int newBalance = mPesaResult.balance - queryResult.dueAmount;
        // Generate a numeric reference number using timestamp
        int billRefNo = time:utcNow()[0]; // Using timestamp as reference number

        transaction {
            sql:ExecutionResult _ = check dbClient->execute(
                `UPDATE MPesa_Account_Info SET balance = ${newBalance} WHERE accNum = ${payload.acc_num}`
            );

            sql:ExecutionResult _ = check dbClient->execute(
                `UPDATE EB_Bill_Service SET duePending = 'NO', billRefNo = ${billRefNo} WHERE uid = ${payload.uid}`
            );
            check commit;
        } on fail error e {
            log:printError("Transaction failed", 'error = e);
            return error("Transaction failed: " + e.message());
        }

        BillPaymentResponse response = {
            status: "SUCCESS",
            billRefNo: billRefNo
        };

        


        return response;
    }
}