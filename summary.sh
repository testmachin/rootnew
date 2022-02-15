
date=$(ls billing.log-2022-02-13.log | cut -d '-' -f2-4| cut -d '.' -f1)
start_time=$(cat billing.log-2022-02-13.log |head -n 2 | tail -n 1 | awk -F',' '/,/{print $3}')
end_time=$(cat billing.log-2022-02-13.log | awk -F',' '/,/{print $3}'|tail -n 1)
Record_type=$(echo "summary")
arr=( $(cat billing.log-2022-02-13.log | grep -nm2 "bill-aaaa" | awk -F':' '{print $1}'))
total=$(cat billing.log-2022-02-13.log | grep -nm1 "bill-aaaa" | awk -F':' '{print $1}'| wc -l)
for ((i=0;i<$total;i++));

do
base_count=$(cat billing.log-2022-02-13.log| sed -n ${arr[$i]},${arr[$((i+1))]}p |awk -F ',' '/,/{print $1}'| wc -l)
done
arrfn=( $(cat billing.log-2022-02-13.log | grep "bill-aaaa" | awk -F',' '{print $2}'| wc -l))
cycles=${arrfn[@]}

attempted=$(cat billing.log-2022-02-13.log | awk -F',' '/,/{print $4}'| wc -l)
success=$(cat billing.log-2022-02-13.log | awk -F',' '/,/{print $4}' | grep -w '^-1' | wc -l)
time_out=$(cat billing.log-2022-02-13.log | grep "ERR" | awk -F',' '/,/{print $1}'| wc -l)
Not_attempted=$(cat billing.log-2022-02-13.log | grep "NA" | awk -F':' '/:/{print $3}'| sort -nr | uniq -c| wc -l)

echo "date        : $date"
echo "start_time  : $start_time"
echo "end_time    : $end_time"
echo "Record_type : $Record_type"
echo "base_counts : $base_count"
echo "cycles      : $cycles"
echo "attempted   : $attempted"
echo "success     : $success"
echo "timeout     : $time_out"
echo "Not_attempted : $Not_attempted"
user="root"
pass="laiba@1234"
/usr/bin/mysql -u$user  -p$pass  summary -se "insert into summary (date,start_time,end_time,record_type,base_counts,cycles,attempted,sucess,time_out,not_attempted)  values ('$date','$start_time','$end_time','$Record_type','$base_count','$cycles','$attempted','$success','$time_out','$Not_attempted')"


/usr/bin/mysql -u$user -p$pass  summary -se "select * from summary"
echo "Data Inserted To DB"
exit 0;

