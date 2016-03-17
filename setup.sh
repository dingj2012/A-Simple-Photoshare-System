#!/bin/bash

DBNAME=$USER

echo "create tables..."
psql -d $DBNAME -f table.dss -a

echo "load tables..."
echo "part"
zcat part.data.gz | psql -d $DBNAME -c "copy part from stdin delimiter '|'"
echo "supplier"
zcat supplier.data.gz | psql -d $DBNAME -c "copy supplier from stdin delimiter '|'"
echo "partsupp"
zcat partsupp.data.gz | psql -d $DBNAME -c "copy partsupp from stdin delimiter '|'"
echo "update statistics"
psql -d $DBNAME -c "vacuum"
psql -d $DBNAME -c "analyze"

echo "Database is ready for use"
