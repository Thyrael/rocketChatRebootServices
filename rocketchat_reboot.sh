#!/bin/bash

####################################################################################
########################## Author : Baraffe Robin.  ################################
########################## Date : 23/04/2019        ################################
####################################################################################

# Script to reboot rocket chat services

LOG_DIR_PATH="rocketchatLogs/"
if [ ! -d "$LOG_DIR_PATH" ]; then
  mkdir $LOG_DIR_PATH
fi
cd $LOG_DIR_PATH

echo "$(date +%m%d%y%T)" >> rebootRocketChatLog.txt
echo 'Restarting rocket chat services .. ' >> rebootRocketChatLog.txt


service mongod stop &
# mongod process
PROCESS_ID=$!
wait $PROCESS_ID
echo 'Mongodb services are stopped.' >> rebootRocketChatLog.txt

service rocketchat stop &
# rocketchat process
PROCESS_ID=$!
wait $PROCESS_ID
echo 'Rocket chat services are stopped.' >> rebootRocketChatLog.txt

####################################################################################
########## At this point, mongod & rocket chat are stopped. ########################
####################################################################################

service mongod start &
# mongod process

MONGODB_PID="$(pgrep mongod)"
#if [ -z "$MONGODB_PID" ]; then
#  echo 'An error occured when starting mongodb services' >> rebootRocketChatLog.txt
#  exit 1
#fi

wait $MONGODB_PID
echo 'Mongodb services successfully rebooted.' >> rebootRocketChatLog.txt
service rocketchat start &
# rocketchat process

ROCKETCHAT_PID="$(ps -ax | grep -v grep | grep Rocket.Chat | awk '{print $1}')"
#if [ -z "$ROCKETCHAT_PID" ]; then
#  echo 'An error occured when starting rocketchat services' >> rebootRocketChatLog.txt
#  exit 1
#fi
echo 'Rocketchat services successfully rebooted.' >> rebootRocketChatLog.txt

echo 'Reboot successfully teminated.' >> rebootRocketChatLog.txt
