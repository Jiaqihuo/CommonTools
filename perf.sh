#!/bin/bash

#python3 ../../scripts/perf.py -t gm --file gmCpu -d GMItTest.GMItTest_000_rn2sn_0001_req256_stride0_0x100000_rd_rn1_c1_ost_512/esllog/ -c 0 -b 0

RUN_FILE_LIST="perf_list.log"
if [ $# -gt 0 ]
then
        RUN_FILE_LIST=$1
fi
echo "$RUN_FILE_LIST"

case_list=()

if [ "$RUN_FILE_LIST" != "" ]
then
    case_list=()
    while read line; do
        if [ ${line:0:1} != "#" ]
        then
            case_list+=( "$line" )
        fi
    done < $RUN_FILE_LIST
fi

log_file=perf_res_bw.log.$RUN_FILE_LIST
rm -f $log_file

for i in "${case_list[@]}"  
do
    echo "$i"
    ./systemTester --gtest_filter=$i >> perf_trace.log
    python3 ../scripts/perf.py -t gm_task --task traffic -d logs/$i/esllog/ -c 0 -b 0 -m ring >> $log_file
    python3 ../scripts/perf.py -t nn --task traffic -d logs/$i/esllog/ -c 0 -b 0 -m ring #  >> $log_file
    # python3 ../scripts/perf.py -t ts -d logs/$i/esllog/ -c 0 -b 0 -m ring >> perf_res_ts.log
done

# \grep "rd\|wr" $log_file | awk '{if(NR%6!=0)ORS=" ";else ORS="\n"}1' | sed "s/.. : \+//g" | tee tmp.$RUN_FILE_LIST
# awk -F " " '{print $1+$2}' tmp.$RUN_FILE_LIST

