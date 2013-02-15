#!/bin/bash
#This is a script to parse hping
#logs in order to determine if there
#was any TCP packet loss across the network
#Joey Krejci 2_2013


clear

echo "Type the hping logfile you want to parse, then hit Return:"
read file
rev << EOF
$file
EOF

green='\e[0;32m'
nc='\e[0m' # No Color
average=`cat $file | grep "rtt"| cut -d"=" -f6 | awk '{ SUM += $1} END { print"Average RTT = " SUM/NR }'`
packets=`cat $file | grep packets`


echo -e "${green} $packets ${nc}"
echo -e "${green} $average ${nc}"



percent=`cat $file | grep packets | cut -d" " -f7` | sed 's/%//'
subject="Packet Loss Alert"
to="youremail@example.com"
message="/tmp/packetlossalert.txt"
#the "0" here represents zero packet loss
if [[ $percent -ne 0 ]]; then
echo "All clear"
else
echo "View log, we lost some packets on `date +"%m%d-%H:%M"`" > $message
echo "`cat $file | grep packets`">> $message
mail -s "$subject" "$to" < $message
fi

