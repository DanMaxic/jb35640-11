#!/bin/bash

vagrant validate
if [ $? -eq 0 ]; then echo "###### VAGRANT VALIDATION PASSED######"; else echo "VAGRANT VALIDATION FAILED, EXITING"; exit 1; fi

vagrant status


echo -n "proceed to load the lab?, type only \"YES\" to apply [ENTER]:"
read confirm
if [ "$confirm" = "YES" ]; then
    vagrant up
    if [ $? -eq 0 ]; then echo "###### LAB IS READY ######"; else echo "LAB LOAD FAILED, EXITING"; exit 1; fi
    vagrant port
else
    echo "LOADING LABS CANCELLED, EXITING";
fi