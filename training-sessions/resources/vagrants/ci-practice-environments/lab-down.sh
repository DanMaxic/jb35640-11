#!/bin/bash

vagrant status

echo -n "proceed to kill the lab?, type only \"YES\" to apply [ENTER]:"
read confirm
if [ "$confirm" = "YES" ]; then
    vagrant destroy -f
    if [ $? -eq 0 ]; then echo "###### LAB IS DEAD ######"; else echo "LAB KILL FAILED, EXITING"; exit 1; fi
    vagrant status
else
    echo "KILLING LABS CANCELLED, EXITING";
fi