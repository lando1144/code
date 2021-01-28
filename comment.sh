#!/bin/bash

#最好用非公司出口IP跑
X_UA=V%3D1%26PN%3DWebApp%26LANG%3Dzh_CN%26VN_CODE%3D3%26VN%3D0.1.0%26LOC%3DCN%26PLT%3DPC%26UID%3Dac17e64b-e063-42ff-bf8b-86b235254146
PAGE_SIZE=10
START_INDEX=0
END_PAGE=$((START_INDEX+PAGE_SIZE*2)) #END_PAGE 小于0表示拉取全部
APP_ID_ARR=(70056 2318 139301) #游戏ID
LOG_FILE="./"

for appid in ${APP_ID_ARR[@]};do
    echo > "${LOG_FILE}${appid}.data"
    if [ $END_PAGE -lt 0 ];then
        END_PAGE=`curl -s "https://www.taptap.com/webapiv2/review/v2/by-app?app_id=${appid}&from=0&limit=1&order=update&page=1&X-UA=${X_UA}"  | jq '.data.total'`
        echo 
    fi
    for (( i=0; i<END_PAGE; i=i+PAGE_SIZE ));do  
        data=`curl -s "https://www.taptap.com/webapiv2/review/v2/by-app?app_id=${appid}&from=${i}&limit=${PAGE_SIZE}&order=update&page=1&X-UA=${X_UA}" `
        echo $data | jq --compact-output ' .data.list[].moment |  {"name":.author.user.name , "score":.extended_entities.reviews[0].score , "played_tips": .extended_entities.reviews[0].played_tips ,"raw_text":.extended_entities.reviews[0].contents.raw_text} '  >> "${LOG_FILE}${appid}.data"
    done
done

