#!/bin/bash

#### Color ####
NON="\033[0m"  # unsets color to term's fg color
K="\033[0;30m"  # black
R="\033[0;31m"  # red
G="\033[0;32m"  # green
Y="\033[0;33m"  # yellow
B="\033[0;34m"  # blue
M="\033[0;35m"  # magenta
C="\033[0;36m"  # cyan
W="\033[0;37m"  # white

# emphasized (bolded) colors
EMK="\033[1;30m"
EMR="\033[1;31m"
EMG="\033[1;32m"
EMY="\033[1;33m"
EMB="\033[1;34m"
EMM="\033[1;35m"
EMC="\033[1;36m"
EMW="\033[1;37m"

#### MOTD ####
motd="${EMY}Welcome! Laszlo${Y}${NON}" #SAY SOMETHING

echo -e "  _________________\n" \
	"< $motd >\n" \
	" -----------------\n" \
	"   \\ \n" \
	"    \\ \n" \
	"        .--.\n" \
	"       |o_o |\n" \
	"       |:_/ |\n" \
	"      //   \ \ \n" \
	"     (|     | )\n" \
	"    /'\_   _/\`\ \n" \
	"    \___)=(___/\n" \
	""

#### DISK USAGE ####
echo -n "已用空間 " 
echo -ne "$EMG$(df -g | grep disk1 | awk '{print $3}')$G$NON / "
echo -e "$EMR$(df -g | grep disk1 | awk '{print $2}')$R$NON GB\n"

#WEATHER
KEY="" # Your API key at http://opendata.cwb.gov.tw/usages
wfile="/tmp/weather"
DATAID1="F-D0047-009" 	# 新竹縣未來2天天氣預報
#location:1 五峰鄉 2 峨眉鄉 3 尖石鄉 4 寶山鄉 5 新豐鄉 6 北埔鄉 7 橫山鄉 8 關西鎮 9 竹東鎮 10 湖口鄉 11 芎林鄉 12 竹北市 13 新埔鎮
DATAID2="F-D0047-053" 	# 新竹市未來2天天氣預報 location:1 北區 2 香山區 3 東區
DATAID3="F-D0047-053" 	# 台北市未來2天天氣預報 location:
localID=3		# Choose above DATAID's locationID
intervals=5400		# Second Time to to update file content
pingtest="168.95.1.1"	# Test Network Connection

if ! $( ping -q -c 1 -W 1 ${pingtest} > /dev/null 2>&1);then
	echo -e "Network is unreachable!\n"
else
	if [ ! -e $wfile ];then # Create file
		touch $wfile
	else
		if [ -z $(tail -n 1 $wfile | grep "</dataset>") ];then # Check file's completeness or interrupted
			rm $wfile && touch $wfile
		fi
	fi
	if [ ! -s $wfile -o $(($(date +%s)-$(stat -f "%m" $wfile))) -gt $intervals ];then #each dataset is at 3 hour intervals
		curl -s "http://opendata.cwb.gov.tw/opendataapi?dataid=${DATAID2}&authorizationkey=${KEY}" | tail -n +27 | sed '$ d' > $wfile #paser dataset and delete last tag
	fi
	locations=$(xmllint --xpath 'string(//locationsName)' $wfile)
	location=$(xmllint --xpath 'string(//location['${localID}']/locationName)' $wfile)
	#endtime=$(xmllint --xpath '//location['${localID}']/weatherElement[10]/time[1]/endTime/text()' $wfile)
	weather=$(xmllint --xpath 'string(//location['${localID}']/weatherElement[10]/time[1]/elementValue/value)' $wfile)
	echo -e "["${locations}${location}"]  " && echo -e ${weather}"\n" | sed 's/ //g'
fi

#END
