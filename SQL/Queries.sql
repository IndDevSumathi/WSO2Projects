CREATE TABLE EB_Bill_Service (`id` int NOT NULL AUTO_INCREMENT,uid varchar(100),dueAmount int,duePending varchar(10), PRIMARY KEY (`id`),UNIQUE (`uid`));
ALTER table EB_Bill_Service add billRefNo bigint;
INSERT INTO EB_Bill_Service(uid,dueAmount,duePending) VALUES ('vipul_id', 1500,'YES');
INSERT INTO EB_Bill_Service(uid,dueAmount,duePending) VALUES ('rahul_id', 3000,'YES');
INSERT INTO EB_Bill_Service(uid,dueAmount,duePending) VALUES ('sumathi_id', 3000,'NO');
SELECT * from EB_Bill_Service;
CREATE TABLE MPesa_Account_Info (`id` int NOT NULL AUTO_INCREMENT,accNum bigint,accHolderName varchar(100),balance bigint, PRIMARY KEY (`id`),UNIQUE (`accNum`));
INSERT INTO MPesa_Account_Info(accNum,accHolderName,balance) VALUES (67890,'Vipul',35000);
INSERT INTO MPesa_Account_Info(accNum,accHolderName,balance) VALUES (12345,'Sumathi',20000);
INSERT INTO MPesa_Account_Info(accNum,accHolderName,balance) VALUES (87654,'Rahul',45000);
SELECT * from MPesa_Account_Info;

update MPesa_Account_Info set balance = '35000' where accNum = 67890;
update EB_Bill_Service set duePending = 'YES' where uid = 'vipul_id';
