#!/bin/bash

saPasswordArg=$1
appPasswordArg=$2


/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $saPasswordArg -i ./initialize.sql -o output.txt

/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $saPasswordArg -i ./create-database.sql -o create-output.txt

echo :setvar appPassword $appPasswordArg > initialize-users.sql

cat initialize-users-template.sql >> initialize-users.sql

/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $saPasswordArg -i ./initialize-users.sql -o user-output.txt 

/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $saPasswordArg -i ./initialize-data.sql -o data-output.txt

