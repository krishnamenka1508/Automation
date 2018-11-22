#!/bin/bash
#@author Jitendra Singh Bhadouria <jeetusb.singh@gmail.com>
#Create snapshot of previous day.

#as cron does not supply PATH env variable, it has to be explicitly defined for every command to run.
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games


echo "\n===BEGIN===\n"

echo "\nCurrent Time `date`\n"

snapshotIndex="filebeat-`date --date='30 days ago' '+%Y.%m.%d'`"

echo "\Deleting Snapshot $snapshotIndex\n"
curl -XDELETE 'http://localhost:9200/_snapshot/broccoli/'$snapshotIndex

echo "\n===End===\n"