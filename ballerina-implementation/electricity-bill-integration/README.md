# Project Setup Instructions

## Requirements

- **Ballerina**: Install the [latest Ballerina version](https://ballerina.io/downloads/)  
  _OR_  
  - Use a [WSO2 Choreo account](https://wso2.com/choreo/)

- **MySQL Database**:  
  Ensure a running instance of MySQL with access credentials.

## Local Development Setup

If running the project locally, create a file named `config.toml` in the project root with the following content:

```toml
dbHost = "<your-mysql-host>"
dbUser = "avndmin"
dbPassword = "<your-mysql-password>"
dbName = "<your-database-name>"
dbPort = "<your-mysql-port>"
