#!/bin/bash

#### Color ####
NON="\033[m"  # unsets color to term's fg color
EMK="\033[1;30m"
EMR="\033[1;31m"
EMG="\033[1;32m"
EMY="\033[1;33m"
EMB="\033[1;34m"
EMM="\033[1;35m"
EMC="\033[1;36m"
EMW="\033[1;37m"

#### MOTD ####
motd=${EMY}"Welcome! Laszlo"${NON} #SAY SOMETHING

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
echo -ne "${EMG}$(df -g | grep disk1 | awk '{print $3}')${NON} / "
echo -e "${EMR}$(df -g | grep disk1 | awk '{print $2}')${NON} GB\n"

#### WEATHER ####
KEY="" #Your API key at http://opendata.cwb.gov.tw/usages
wfile="/tmp/weather"
intervals=5400		# Second Time to to update file content
timeout=2		# Timeout in N seconds
DATAID="F-D0047-009"
district="竹東鎮"
# 新竹縣未來2天天氣預報 F-D0047-009
# district:峨眉鄉 關西鎮 芎林鄉 湖口鄉 新豐鄉 新埔鎮 橫山鄉 北埔鄉 寶山鄉 五峰鄉 尖石鄉 竹東鎮 竹北市
# 新竹市未來2天天氣預報 F-D0047-053
# district:北區 香山區 東區
# 台北市未來2天天氣預報 F-D0047-061
# district:南港區 大安區 內湖區 大同區 文山區 士林區 松山區 萬華區 中正區 信義區 中山區 北投區
# Data List http://opendata.cwb.gov.tw/datalist

[ ! -e ${wfile} ] && touch ${wfile} # Create file
[ ! -s ${wfile} -o $(($(date +%s)-$(stat -f "%m" ${wfile}))) -gt $intervals ] && \
curl -m ${timeout} -s "https://opendata.cwb.gov.tw/opendataapi?dataid=${DATAID}&authorizationkey=${KEY}" | sed 's/xmlns=".*"//g' > ${wfile}
# If file is empty or not latest. Each dataset is at 3 hour intervals and then get Latest Dataset

if [ ! -z $(tail -n 1 ${wfile} | grep "cwbopendata") ];then # Check file's completeness or interrupted
	locations=$(xmllint --xpath 'string(//locationsName)' ${wfile})
	location=$(xmllint --xpath 'string(//location/locationName[text()="'${district}'"])' ${wfile})
	weather=$(xmllint --xpath 'string(//location/locationName[text()="'${district}'"]/following-sibling::weatherElement[11]/time[1]/elementValue/value)' ${wfile})
	echo -e "${EMW}[${locations}${location}]${NON}  " && echo -ne ${weather}"\n" | sed 's/ //g'
else # If not complete
	echo -e "Weather Information Timeout\n"
	> ${wfile} # eraser content
fi

#END
