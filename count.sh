#!/bin/bash
echo "DATE"
echo '2022-02-06.log.gz' | awk -F '[.]' '{print $1}'
echo "----------------------------"
echo "start time=$(head -n 2 2022-02-06-R.log | tail -n 1 | awk -F',' '/,/{print $3}')"
echo "end time=$(tail -n 2 2022-02-06-R.log | awk -F',' '/,/{print $3}')"
echo "RECORD TYPE"
echo 2022-02-06.log.gz | awk -F '[.]' '{print $2}'
echo "ATTEMPTED"
zcat 2022-02-06.log.gz | grep '[1]' | awk -F',' '/,/{print $4}' |sort -nr | uniq -c
echo "TIME OUT"
echo "ERR=$(zcat 2022-02-06.log.gz | grep "ERR" | awk -F',' '/,/{print $1}'| wc -l)"
echo "BASE COUNT CYCLES"
arr=( $(zcat 2022-02-06.log.gz | grep -nm2 "bill-aaaa" | awk -F':' '{print $1}'))

total=$(zcat 2022-02-06.log.gz | grep -nm2 "bill-aaaa" | awk -F':' '{print $1}'| wc -l)

for ((i=0;i<$total;i++));
do
echo ${arr[$i]}
echo ${arr[$((i+1))]}
zcat 2022-02-06.log.gz|sed -n ${arr[$i]},${arr[$((i+1))]}p|awk -F ',' '/,/{print $1}'|sort -nr|uniq -c
exit 0;
done
