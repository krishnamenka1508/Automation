#!/bin/bash
#@author Jitendra Singh Bhadouria <jeetusb.singh@gmail.com>
#Create snapshot of previous day.

#as cron does not supply PATH env variable, it has to be explicitly defined for every command to run.
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

echo "Begin"

date
current=$(df --output=pcent /dev/mapper/vg-lv1 | tail -1 | sed 's/%//g')
threshold=80
days=20

while [ $current -gt $threshold ]
do
echo "current disk usage "$current"%";
deleteIndex="filebeat-`date --date=$days' days ago' '+%Y.%m.%d'`"
echo "deleteIndex="$deleteIndex
curl -XDELETE 'http://localhost:9200/'$deleteIndex'?pretty'
current=$(df --output=pcent /dev/mapper/vg-lv1 | tail -1 | sed 's/%//g')
days=`expr $days - 1`;

if [ $days -lt 2 ]
then
break
fi

done

echo "End"