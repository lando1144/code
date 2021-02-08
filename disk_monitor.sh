#!/bin/bash
disks=(`df |sed 1d | awk '{print $1,$5}'|tr -d %`)
len=${#disks[@]}
while ((1));do
 for ((i=1;i<=$len;i=i+2));do
    if [ ${disks[i]} -gt 60 ];then
        echo "${disks[$i-1]} ${disks[$i]}" >>disk_clear_file
        cd ~/red/server/run/bin
        ./ServeAdmin.sh restart all
    fi
 done
 sleep 3600
done
