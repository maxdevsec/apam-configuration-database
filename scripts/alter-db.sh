#!/bin/bash

saPasswordArg=$1



/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $saPasswordArg -i ./alter-db.sql -o alter-output.txt