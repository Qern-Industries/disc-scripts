#!/bin/env bash

#Loop to constantly check if DVD is inserted or not
while :; do
   
   #Check if DVD inserted
   if [[ $(blkid /dev/sr0 > /dev/null; echo $?) == 0 ]]; then
       sleep 0.25
       echo "Disk is inserted"
       echo "Checking if DVD is already ripped"
                   
                   currentdvd=$(pre="LABEL=";tmp=$(blkid /dev/sr0 -o export | grep LABEL=) ; echo "${tmp#$pre}" | tr -cd [:alnum:] | tr [:upper:] [:lower:])
                   dvdrips=$(dir | tr -cd [:alnum:] | tr [:upper:] [:lower:])
                   
                      #See if current DVD has already been ripped
                      if [[ "$dvdrips" == *"$currentdvd"* ]]; then
                           echo "Already ripped."
                      else
                           echo "Not ripped, beginning ripping."
                      fi
       
       #Begin Backup
       dvdbackup -pvFMi /dev/sr0 -o ../Backups/
       
       #Eject DVD after Rip and Transcode
       echo "eject /dev/sr0"
   
   #Check if DVD isn't inserted
   elif [[ $(blkid /dev/sr0 > /dev/null; echo $?) == 2 ]]; then
       sleep 0.25
       
       #Eject DVD so user can insert
       echo "Disk is not inserted"
       
       
       
   #Exit if unexpected error
   else 
       sleep 0.25
       echo "Unexpected error, exiting"
       echo "Please open a Github issue."
       echo "Errorcode 0001
       eject -n /dev/sr0
       exit
   fi
done