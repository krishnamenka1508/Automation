#!/bin/bash
#@author Jitendra Singh Bhadouria <jeetusb.singh@gmail.com>
#Take Snapshot of index 25 days ago
#Delete Index, if snapshot successful 26 days ago.

#as cron does not supply PATH env variable, it has to be explicitly defined for every command to run.
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games


echo "\n===Start ES Snapshot script===\n"

echo "\nCurrent Time `date`\n"

set -x

snapshotIndex="filebeat-`date --date='13 days ago' '+%Y.%m.%d'`"
deleteIndex="filebeat-`date --date='14 days ago' '+%Y.%m.%d'`"

prevSnapshotStatus=`curl -XGET 'http://localhost:9200/_snapshot/broccoli/'$deleteIndex'?pretty' | jq '.snapshots[0].state'`
echo "\nPrevious Snapshot Status $prevSnapshotStatus\n"

#If previous snapshot is a success, delete index from Elasticsearch

if [ $prevSnapshotStatus = '"SUCCESS"' ];then
   echo "\nDeleting Index $deleteIndex\n"
   curl -XDELETE 'http://localhost:9200/'$deleteIndex'?pretty'
fi


currentSnapshotStatus=`curl -XGET 'http://localhost:9200/_snapshot/broccoli/'$snapshotIndex'?pretty' | jq '.snapshots[0].state'`
echo "\nCurrent Snapshot Status $currentSnapshotStatus\n"


#If currentsnapshot status is null, create snapshot

if [ $currentSnapshotStatus = null ];then
    echo "\nCreating Snapshot $snapshotIndex\n"
    curl -XPUT 'http://localhost:9200/_snapshot/broccoli/'$snapshotIndex'?pretty' -d '{"indices": "'$snapshotIndex'","ignore_unavailable": "true","include_global_state": false}'
fi

echo "\n===End ES Snapshot script===\n"