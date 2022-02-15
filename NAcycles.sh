#!/bin/bash

echo "files are $(cat billing.log-2022-02-13.log | grep -c "bill-" | awk -F',' '{print $1}')"
arr=( $(cat billing.log-2022-02-13.log | grep -n "bill-aaaa" | awk -F':' '{print $1}'))
total=$(cat billing.log-2022-02-13.log | grep -n "bill-aaaa" | awk -F':' '{print $1}'| wc -l)
last_line=$(cat billing.log-2022-02-13.log | wc -l)
echo "$last_line"
#sed -x
for ((i=0;i<$total;i++));
do
#echo ${arr[$i]}
echo "  "
#echo ${arr[$((i+1))]}
echo "cycle $i"
echo "  "


if [ $i -eq `expr $total - 1` ];

then

	start_time=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},$last_line\p |head -n 2 | tail -n 1 | awk -F',' '/,/{print $3}')
	end_time=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},$last_line\p | awk -F',' '/,/{print $3}'|tail -n 1)
	Attempted=$(cat billing.log-2022-02-13.log| sed -n ${arr[$i]},$last_line\p |awk -F ',' '/,/{print $4}'| wc -l)
	Success=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},$last_line\p | awk -F',' '/,/{print $4}' | grep -w '^1' | wc -l)
	timeout=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},$last_line\p | grep "ERR" | awk -F',' '/,/{print $1}'| wc -l)
	Responses=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},$last_line\p | awk -F',' '/,/{print $4}' | sort -nr | uniq -c)
        Record_type=$i
        Not_attempted=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},$last_line\p | grep "NA" | awk -F':' '{print $3}' | wc -l)
else

	start_time=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},${arr[$((i+1))]}p |head -n 2 | tail -n 1 | awk -F',' '/,/{print $3}')
	end_time=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},${arr[$((i+1))]}p | awk -F',' '/,/{print $3}'|tail -n 1)
	Attempted=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},${arr[$((i+1))]}p |awk -F ',' '/,/{print $4}'| wc -l)
	Success=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},${arr[$((i+1))]}p | awk -F',' '/,/{print $4}' | grep -w '^1' | wc -l)
	timeout=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},${arr[$((i+1))]}p | grep "ERR" | awk -F',' '/,/{print $1}'| wc -l)
	Responses=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},${arr[$((i+1))]}p | awk -F',' '/,/{print $4}' | sort -nr | uniq -c)
        Record_type=$i
        Not_attempted=$(cat billing.log-2022-02-13.log | sed -n ${arr[$i]},${arr[$((i+1))]}p |grep "NA" | awk -F':' '{print $3}' | wc -l)
	#sed +x
fi

echo "start_time : $start_time"
echo "end_time   : $end_time"
echo "Attempted  : $Attempted"
echo "success    : $Success"
echo "timeout    : $timeout"
echo "Responses   :$Responses"
echo "Not_attempted : $Not_attempted"
echo "Record_type : cycle $Record_type"
user="root"
pass="laiba@1234"

/usr/bin/mysql -u$user -p$pass  summary -se "insert into cycles_details (start_time,end_time,attempted,success,time_out,responses,record_type,Not_attempted) values ('$start_time', '$end_time','$Attempted','$Success','$timeout','$Responses','cycle $Record_type','$Not_attempted')"

echo "Data Inserted To DB"
echo "showing outputs in bash script"
/usr/bin/mysql -u$user -p$pass  summary -se  "select * from cycles_details"
done
exit 0;


