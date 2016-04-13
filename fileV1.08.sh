#!/bin/bash

# Γεώργιος Κιρμιτσάκης
# Γεώργιος Κύρος
# Βασίλης Μαρτίδης

# Closing all processes of crhomium if they exist
initialazeF(){
	pidIn=`ps aux | grep chromium | grep -v root | grep -v grep | grep -v defunct | awk '{print $2}'` 
	if [ $? -eq "0" ]; then 
		for i in $pidIn;do kill -9 $i;done #closing all processes
	fi
}
# Parsing from file "url.in" on path $path/ the urls
openBrowserF(){
	if [ -f "$path/url.in" ]; 
	then
		echo " "
	else
		echo "Could not find \"url.in\" file, generating costume file . . ."
		echo "www.yandex.com" >$path/url.in
		echo "pileas.csd.auth.gr" >>$path/url.in
		echo "elearning.auth.gr" >>$path/url.in
		echo "webmail.auth.gr" >>$path/url.in
		echo "sis.auth.gr" >>$path/url.in
		echo "it.auth.gr/el" >>$path/url.in
		echo "pileas.csd.auth.gr" >>$path/url.in
		echo "delab.csd.auth.gr" >>$path/url.in
		echo "ss64.com/bash/" >>$path/url.in
		echo "askubuntu.com" >>$path/url.in
		echo " "
	fi
	echo "=== Opening urls ==="
	while read line;
	do
		chromium-browser $line 2> /dev/null  & sleep $loulaSleep
#		pinakasMePidA=()
#		counterPinakaMePidI=0
#		pinakopoihshF		
#		echo loula: ${pinakasMePidA[*]}
	done <$path/url.in
	sleep $(($loulaSleep*6))
	closeAllProcessesF
}
# Filling an array with the pids of chromium sorted by time
pinakopoihshF(){
	for pidPi in `ps aux --sort=start_time | grep chromium | grep -v root | grep -v grep | grep -v defunct | awk '{print $2}'`;	
	do
		pinakasMePidA[counterPinakaMePidI]=$pidPi
		counterPinakaMePidI=$((counterPinakaMePidI+1)) 
	done
}
# Terminating a process from chromium that started last
closeProcessF(){
	echo Array is: ${pinakasMePidA[*]}
	echo Killing: ${pinakasMePidA[$counterPinakaMePidI-1]}
	if ps -p ${pinakasMePidA[$counterPinakaMePidI-1]} > /dev/null ;
	then
		kill -9 ${pinakasMePidA[$counterPinakaMePidI-1]}
	fi	
	sleep $loulaSleep
}
# checks if chromium process exist
checkIfChromiumProcessExistF(){
	if ps aux | grep -v grep | grep -v defunct | grep chromium > /dev/null
	then
		booleanForIfChromiumProcessExistI=0
	else
		booleanForIfChromiumProcessExistI=1
	fi
}
# Loop for writing the statistics of the processes of chromium every ~0.5 seconds
katagrafhStatistikwnF(){
	echo "" >$path/dataAll.out
	echo "" >$path/dataMemory.out
	echo "" >$path/dataThreads.out
	echo "" >$path/dataSwitches.out
	time1=$(echo "scale=1; 0.0" | bc)
	time2=$(echo "scale=1; 0.5" | bc)
	checkIfChromiumProcessExistF
	while [ $booleanForIfChromiumProcessExistI -eq "0" ]; 
	do
		loulaNewOrderF &
		sleep 0.5
		time1=$(echo "scale=1; $time1+$time2" | bc)
		checkIfChromiumProcessExistF
	done
}
# Computing and writing of the statistics on file "data.out" 
loulaNewOrderF(){
	pinakasTisLoulasA=()	
	counterPinakaMePidI=0
	pinakasMePidA=()
	pinakopoihshF
#	now1=$(date +"%3N") #Time
# This loop opens the "status" file of pids and stores them in an array. 
	for (( i=0 ; $i < $counterPinakaMePidI ; i=$i+1 ));
	do
		if [ -f "/proc/${pinakasMePidA[$i]}/status" ]; then
			pinakasTisLoulasA[$i]=`cat /proc/${pinakasMePidA[$i]}/status`" "+"loula 23" > /dev/null 2>&1
		fi  > /dev/null 2>&1
	done
#	echo ${pinakasTisLoulasA[*]}

#	now2=$(date +"%3N") #Time
#	now3=$(($now2-$now1)) #Time
#	echo TIME: $now3

	processesOfCromiumI=`pgrep -c chromium`

	MaximumThreadsOfCromiumI=0
	MesoPlithosThreadsI=0
	MaximumMemoryOfChromiumI=0
	SunolikoMemoryOfChromiumI=0
	MesoPlithosVolSwi=0
	MesoPlithosNonVolSwi=0
	
	tempForThreadsA=0
	tempForMemoryA=0
	tempForVolSwiA=0	
	tempForNonVolSwiA=0
# This loop helps to compute the statistics and writing into the data.out file.
	for (( i=0 ; $i < $counterPinakaMePidI ; i=$i+1 ));
	do
		if [ -f "/proc/${pinakasMePidA[$i]}/status" ]; then
			tempForThreadsA=$(awk 'NR==24 {print $2}' <<< "$pinakasTisLoulasA[$i]")
			tempForMemoryA=$(awk 'NR==17 {print $2}' <<<  "$pinakasTisLoulasA[$i]")
			tempForVolSwiA=$(awk 'NR==40 {print $2}' <<<  "$pinakasTisLoulasA[$i]")
			tempForNonVolSwiA=$(awk 'NR==41 {print $2}' <<< "$pinakasTisLoulasA[$i]")
			MesoPlithosThreadsI=$((tempForThreadsA+MesoPlithosThreadsI))
			if (( $tempForThreadsA > $MaximumThreadsOfCromiumI ));
			then
				MaximumThreadsOfCromiumI=$tempForThreadsA
			fi
			SunolikoMemoryOfChromiumI=$((tempForMemoryA+SunolikoMemoryOfChromiumI))
			if (( $tempForMemoryA > $MaximumMemoryOfChromiumI ));
			then
				MaximumMemoryOfChromiumI=$tempForMemoryA
			fi
			MesoPlithosVolSwi=$((tempForVolSwiA+MesoPlithosVolSwi))
			MesoPlithosNonVolSwi=$((tempForNonVolSwiA+MesoPlithosNonVolSwi))
		fi
	done
	if (( $processesOfCromiumI != 0 ));
	then
		MesoPlithosThreadsI=$(echo "scale=2; $MesoPlithosThreadsI/$processesOfCromiumI" | bc)
		MesoPlithosVolSwi=$(echo "scale=2; $MesoPlithosVolSwi/$processesOfCromiumI" | bc)
		MesoPlithosNonVolSwi=$(echo "scale=2; $MesoPlithosNonVolSwi/$processesOfCromiumI" | bc)
	else
		MesoPlithosThreadsI=0
		MesoPlithosVolSwi=0
		MesoPlithosNonVolSwi=0
	fi
	echo "$time1 $processesOfCromiumI $MaximumThreadsOfCromiumI $MesoPlithosThreadsI $(echo "scale=2; $SunolikoMemoryOfChromiumI/1024" | bc) $(echo "scale=2; $MaximumMemoryOfChromiumI/1024" | bc) $(echo "scale=2; $MesoPlithosVolSwi/100"| bc) $(echo "scale=2;$MesoPlithosNonVolSwi/100" | bc)" >>$path/dataAll.out
   echo "$time1 $processesOfCromiumI $MaximumThreadsOfCromiumI $MesoPlithosThreadsI" >>$path/dataThreads.out
   echo "$time1 $(echo "scale=2; $SunolikoMemoryOfChromiumI/1024" | bc) $(echo "scale=2; $MaximumMemoryOfChromiumI/1024" | bc)" >>$path/dataMemory.out
   echo "$time1 $(echo "scale=2; $MesoPlithosVolSwi/10"| bc) $(echo "scale=2;$MesoPlithosNonVolSwi/10" | bc)" >>$path/dataSwitches.out
}

# Trexei mexri na termatistoun ola ta processes tou chromium
closeAllProcessesF(){	
	echo " "
	echo "=== Closing processes ==="
	checkIfChromiumProcessExistF
	while [ $booleanForIfChromiumProcessExistI -eq "0" ]; do
		pinakasMePidA=()
		counterPinakaMePidI=0
		pinakopoihshF
		closeProcessF
		checkIfChromiumProcessExistF
	done
}

clear
path=$(cd "$(dirname "$0")";pwd)
echo Γεώργιος Κιρμιτσάκης
echo Γεώργιος Κύρος
echo Βασίλης  Μαρτίδης
echo " "
loulaSleep=1 #5 default value
initialazeF
booleanForIfChromiumProcessExistI=0
katagrafhStatistikwnF &
openBrowserF &
wait
echo " "
echo "=== Generating statistics ==="
a=$(dpkg -l | grep gnuplot | awk '{print $1}')
if [ -z "$a" ];
then
	echo You dont have \"gnuplot\" installed. Do you want to intall it? \(y\/n\)
	read $loula
	if	[ $loula -eq "y" ];
	then
	   sudo  apt-get update 
		sleep 1
		sudo apt-get install gnuplot-x11 -y
	else
		echo The script can not produce graphs, program \"gnuplot\" missing.		
	fi
else
	
	if [ -f "$path/myscript.gp" ]; 
	then
		echo " "
	else
		echo "Could not find \"myscript.gp\" file, generating costume file . . ."
		echo "set xlabel \"time from start (s)\"" >$path/myscript.gp
		echo "set ylabel \"count\"" >>$path/myscript.gp
		echo "set autoscale" >>$path/myscript.gp
		echo "set term png" >>$path/myscript.gp
		echo "set output \"$path/testAll.png\"" >>$path/myscript.gp
		echo "plot \"$path/dataAll.out\" using 1:2 with lines title \"Number of Processes of chromium\", \"$path/dataAll.out\" using 1:3 with lines title \"Maximum Threads Of Cromium\", \"$path/dataAll.out\" using 1:4 with lines title \"Meso Plithos Threads\", \"$path/dataAll.out\" using 1:5 with lines title \"Sunoliko Memory Of Chromium (RSS)\", \"$path/dataAll.out\" using 1:6 with lines title \"Maximum Memory Of Chromium (RSS)\", \"$path/dataAll.out\" using 1:7 with lines title \"Meso Plithos Voluntary Switches\", \"$path/dataAll.out\"  using 1:8 with lines title \"Meso Plithos Non Voluntary Switches\"" >>$path/myscript.gp
	
		echo "set xlabel \"time from start (s)\"" >>$path/myscript.gp
		echo "set ylabel \"count\"" >>$path/myscript.gp
		echo "set autoscale" >>$path/myscript.gp
		echo "set term png" >>$path/myscript.gp
		echo "set output \"$path/testMemory.png\"" >>$path/myscript.gp
		echo "plot \"$path/dataMemory.out\" using 1:2 with lines title \"Sunoliko Memory Of Chromium (RSS)\", \"$path/dataMemory.out\" using 1:3 with lines title \"Maximum Memory Of Chromium (RSS)\"" >>$path/myscript.gp

		echo "set xlabel \"time from start (s)\"" >>$path/myscript.gp
		echo "set ylabel \"count\"" >>$path/myscript.gp
		echo "set autoscale" >>$path/myscript.gp
		echo "set term png" >>$path/myscript.gp
		echo "set output \"$path/testThreads.png\"" >>$path/myscript.gp
		echo "plot \"$path/dataThreads.out\" using 1:2 with lines title \"Number of Processes of chromium\", \"$path/dataThreads.out\" using 1:3 with lines title \"Maximum Threads Of Cromium\", \"$path/dataThreads.out\" using 1:4 with lines title \"Meso Plithos Threads\"" >>$path/myscript.gp

		echo "set xlabel \"time from start (s)\"" >>$path/myscript.gp
		echo "set ylabel \"count\"" >>$path/myscript.gp
		echo "set autoscale" >>$path/myscript.gp
		echo "set term png" >>$path/myscript.gp
		echo "set output \"$path/testSwitches.png\"" >>$path/myscript.gp
		echo "plot \"$path/dataSwitches.out\" using 1:2 with lines title \"Meso Plithos Voluntary Switches\", \"$path/dataSwitches.out\"  using 1:3 with lines title \"Meso Plithos Non Voluntary Switches\"" >>$path/myscript.gp
	fi
	gnuplot $path/myscript.gp
	sleep 3
	echo " "
	echo "The script has finished, the photos of the statistics have been generated in \"$path/\" folder"
fi
