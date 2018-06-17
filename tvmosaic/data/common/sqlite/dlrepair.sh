#!/bin/sh

# $1 - path to sqlite executable
# $2 - path to recorder_database db

DUMP_FILE="dump_all.sql"
BACKUP_DIR="backup"

TIMESTAMP=`date +%s`

cd "$2"
mkdir $BACKUP_DIR

#delete old files (if any)
rm -f $DUMP_FILE

#export
"$1/sqlite3" recorder_database.db << EOF
.mode insert
.output dump_all.sql
.dump
.exit
EOF

#move recorder_database.db recorder_database_old.db
mv ./recorder_database.db $BACKUP_DIR/recorder_database_${TIMESTAMP}.db

#import data
"$1/sqlite3" recorder_database.db << EOF1
.read dump_all.sql
.exit
EOF1

rm -f $DUMP_FILE

