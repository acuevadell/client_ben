#!/bin/bash

SECURE="UNSECURE"

mkdir results
echo "Test_Case,Tool,Time,Messages" >> results/times.csv

while IFS="," read -r Test_Case Production_Rate Environment Payload Size Messages Time
do
    python3 config_omb.py $Test_Case $Production_Rate $Payload $Size > workload_var.yaml
    echo "Executing $Test_Case in OMB"
    cd omb
    START_TIME=$(date +%s)
    ./bin/benchmark ../workload_var.yaml --drivers ./dell/driver.yaml > output.txt
    END_TIME=$(date +%s)
    EXECUTION_TIME=$((END_TIME - START_TIME - 60))
    result_file=$(ls *.json)
    echo -e "\tGet Messages Sent"
    MESSAGES=$(python3 ../messages.py $result_file)
    echo -e "\tMove result file to ../results/$Test_Case-OMB-$SECURE.json"
    mv $result_file "../results/$Test_Case-OMB-$SECURE.json"
    cd ../
    mv workload_var.yaml "results/$Test_Case-OMB-$SECURE.yaml"
    echo "$Test_Case,OMB,$EXECUTION_TIME,$MESSAGES" >> results/times.csv
    
    echo "Executing $Test_Case in PRB"
    python3 config_prb.py $Test_Case $Production_Rate $Payload $MESSAGES > config_var.yaml
    cd prb
    ./pravega-rust-benchmark ../config_var.yaml > output.txt
    echo -e "\tMove result file to ../results/$Test_Case-PRB-$SECURE.json"
    result_file=$(ls *.json)
    mv $result_file "../results/$Test_Case-PRB-$SECURE.json"
    cd ../
    mv config_var.yaml "results/$Test_Case-PRB-$SECURE.yaml"
    
    sleep 60
done < <(tail -n +2 test_case.csv)

