#!/bin/bash
# question_one_a.sh ------> Simple Shell Script To show what is defined in the menu
# Linux server / desktop.
# Author: Eleman hillary Banabas
# Date: 12/12/2017

# Define variables
LSB=/usr/bin/lsb_release

# Purpose: Display pause prompt
# $1-> Message (optional)
function pause(){
	local message="$@"
	[ -z $message ] && message="Press [Enter] key to continue..."
	read -p "$message" readEnterKey
}

# Purpose  - Display a menu on screen
function show_menu(){
    date
    echo "---------------------------"
    echo "   Main Menu"
    echo "---------------------------"
	echo "1. PC Information"
	echo "2. Who is online"
	echo "3. Free and used memory info"
        echo "4. Disk Space Usage"
        echo "5. Top memory eaters in term  memory"
        echo "6. System Load and Uptime"
	echo "7. exit"
}

# Purpose - Display header message
# $1 - message
function write_header(){
	local h="$@"
	echo "---------------------------------------------------------------"
	echo "     ${h}"
	echo "---------------------------------------------------------------"
}

# Purpose - Get info about your operating system
function os_info(){
	write_header " System information "
	echo "Operating system : $(uname)"
	[ -x $LSB ] && $LSB -a || echo "$LSB command is not insalled (set \$LSB variable)"


# Purpose - Get info about host such as dns, IP, and hostname

	local dnsips=$(sed -e '/^$/d' /etc/resolv.conf | awk '{if (tolower($1)=="nameserver") print $2}')
	write_header " Hostname and DNS information "
	echo "Hostname : $(hostname -s)"
	echo "DNS domain : $(hostname -d)"
	echo "Fully qualified domain name : $(hostname -f)"
	echo "Network address (IP) :  $(hostname -i)"
	echo "DNS name servers (DNS IP) : ${dnsips}"



# Purpose - Network inferface and routing info

	devices=$(netstat -i | cut -d" " -f1 | egrep -v "^Kernel|Iface|lo")
	write_header " Network information "
	echo "Total network interfaces found : $(wc -w <<<${devices})"

	echo "*** IP Addresses Information ***"
	ip -4 address show

	echo "***********************"
	echo "*** Network routing ***"
	echo "***********************"
	netstat -nr

	echo "**************************************"
	echo "*** Interface traffic information ***"
	echo "**************************************"
	netstat -i

	pause 
}

# Purpose - Display a list of users currently logged on 
#           display a list of receltly loggged in users   
function user_info(){
	local cmd="$1"
	case "$cmd" in 
		who) write_header " Who is online "; who -H; pause ;;
	esac 
}

function disk_space(){
        write_header "Disk Space"
        echo "****************************"
           echo "*** Disk Space Usage ***"
        echo "****************************"
        df
        pause
}

# Purpose - Display used and free memory info
function mem_info(){
	write_header " Free and used memory "
	free -m
    
    echo "*********************************"
	echo "*** Virtual memory statistics ***"
    echo "*********************************"
	vmstat
    pause
}

function top_eaters(){
    write_header "Top memory eating processes"

    echo "***********************************"
	echo "*** Top 6 memory eating process ***"
    echo "***********************************"	
	ps auxf | sort -nr -k 4 | head -6	
	pause
}

function load_uptime(){
      echo "***********************************"
        echo "*** System Load and Uptime ***"
      echo "***********************************"
       w
      echo "UpTime"
      uptime
      pause
      
}
# Purpose - Get input via the keyboard and make a decision using case..esac 
function read_input(){
	local c
	read -p "Enter your choice [ 1 - 7] " c
	case $c in
		1)	os_info ;;
		2)	user_info "who" ;;
		3)	mem_info ;;
                4)      disk_space;;
                5)      top_eaters;;
                6)      load_uptime;;
		7)	echo "Bye!"; exit 0 ;;
		*)	
			echo "Please select between 1 to 7 choice only."
			pause
	esac
}

# ignore CTRL+C, CTRL+Z and quit singles using the trap
trap '' SIGINT SIGQUIT SIGTSTP

# main logic
while true
do
	clear
 	show_menu	# display memu
 	read_input  # wait for user input
done
