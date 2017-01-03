#!/bin/bash

#Color

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

# MOTD
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

#DISK USAGE
echo -n "已用空間 " 
echo -ne "$EMG$(df -g | grep disk1 | awk '{print $3}')$G$NON / "
echo -e "$EMR$(df -g | grep disk1 | awk '{print $2}')$R$NON GB\n"

#WEATHER
KEY="" #Your API key at http://opendata.cwb.gov.tw/usages
wfile="/tmp/weather"
DATAID1="F-D0047-009" 	# 新竹縣未來2天天氣預報 location:
DATAID2="F-D0047-053" 	# 新竹市未來2天天氣預報 location:1 北區 2 香山區 3 東區
DATAID3="F-D0047-053" 	# 台北市未來2天天氣預報 location:
localID=3		# Choose above DATAID's locationID

if [ $(($(date +%s)-$(stat -f "%m" $wfile))) -gt 21600 ];then #172800 secs = 2 days to update file content
	curl -s "http://opendata.cwb.gov.tw/opendataapi?dataid=${DATAID3}&authorizationkey=${KEY}" | tail -n +27 | sed '$ d' > $wfile #paser dataset and delete last tag
fi

locations=$(xmllint --xpath 'string(//locationsName)' $wfile)
location=$(xmllint --xpath 'string(//location['${localID}']/locationName)' $wfile)
endtime=$(xmllint --xpath '//location['${localID}']/weatherElement[10]/time[1]/endTime/text()' $wfile)
weather=$(xmllint --xpath 'string(//location['${localID}']/weatherElement[10]/time[1]/elementValue/value)' $wfile)
echo -e "["${locations}${location}"]  " && echo -e ${weather}"\n" | sed 's/ //g'

#END
