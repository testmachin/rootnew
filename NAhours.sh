#!/bin/bash
#echo "files are $(cat 2022-02-06.log | grep -c "bill-" | awk -F',' '{print $1}')"


arr4=( 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 )
for ((i=0;i<23;i++));
do
#echo "^${arr4[$i]}"
echo " "
echo "hour $i"
echo "  "
	start_time=$(cat billing.log-2022-02-13.log | awk -F ',' '/,/{print $3,$4}' | grep  "^${arr4[$i]}" | awk -F' ' '/ /{print $1}'|head -n 2 | tail -n 1)
	end_time=$(cat billing.log-2022-02-13.log | awk -F ',' '/,/{print $3,$4}' |grep "^${arr4[$i]}" | awk -F' ' '/ /{print $1}' | tail -n 1)
	Attempted=$(cat billing.log-2022-02-13.log | awk -F ',' '/,/{print $3,$4}'| grep "^${arr4[$i]}" | awk -F ' ' '/ /{print $2}'| wc -l)
  	Success=$(cat billing.log-2022-02-13.log | awk -F ',' '/,/{print $3,$4}' | grep "^${arr4[$i]}"| awk -F ' ' '/ /{print $2}' | grep -w '^1'| wc -l)
	time_out=$(cat billing.log-2022-02-13.log | awk -F ',' '/,/{print $3,$1}'| grep "^${arr4[$i]}"| awk -F ' ' '/ /{print $2}' | grep "ERR" | wc -l)
	Responses=$(cat billing.log-2022-02-13.log | awk -F ',' '/,/{print $3,$4}'| grep "^${arr4[$i]}" | awk -F' ' '/ /{print $2}' | sort -nr | uniq -c)
	Record_type=$i
echo "start_time : $start_time"
echo "end_time   : $end_time"
echo "Attempted  : $Attempted"
echo "success    : $Success"
echo "time_out    : $time_out"
echo "Responses   :$Responses"
echo "Record type : hour $Record_type"

user="root"
pass="laiba@1234"

/usr/bin/mysql -u$user -p$pass  summary -se "insert into hours_details (start_time,end_time,attempted,success,time_out,responses,record_type) values ('$start_time', '$end_time','$Attempted','$Success','$time_out','$Responses','hour $Record_type')"


echo "Data Inserted To DB"
echo "showing outputs in bash script"
/usr/bin/mysql -u$user -p$pass  summary -se  "select * from hours_details"

done

exit 0;




#attempted with in one hour
#zcat 2022-02-06.log.gz | awk -F ',' '/,/{print $3,$4}'| grep '^00:' | awk -F ' ' '/ /{print $2}'| wc -l
#sucess with in one hour
#zcat 2022-02-06.log.gz | awk -F ',' '/,/{print $3,$4}' | grep  '^00:'| awk -F ' ' '/ /{print $2}' | grep -w '^1'| wc -l
#timeout
#zcat 2022-02-06.log.gz | awk -F ',' '/,/{print $3,$4}'| grep '^00:'| awk -F ' ' '/ /{print $2}'| grep "ERR" | more
#responses
#zcat 2022-02-06.log.gz | awk -F ',' '/,/{print $3,$4}'| grep '^00:' | awk -F' ' '/ /{print $2}' | sort -nr | uniq -c


