if [ $(uname) = 'Linux' ]; then

	# How to find out what IP addresses are connected to your server
	app-connected() {
		netstat -ntu | awk '{print $5}' | cut -d: -f1 -s | sort | uniq -c | sort -nk1 -r
	}

	db-processlist() {
		sudo mysql --skip-column-names --batch -e 'show processlist' | wc -l
	}

	mail-by-domain() {
		#sudo tail -10000 /var/log/exim_mainlog | grep "$1" | more
		sudo tail -10000 /var/log/exim_mainlog | grep "securedocument.eu" | more
	}

	explain() {
		if [ "$#" -eq 0 ]; then
			while read -p "Command: " cmd; do
				curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$cmd"
			done
			echo "Bye!"
		elif [ "$#" -eq 1 ]; then
			curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$1"
		else
			echo "Usage"
			echo "explain                  interactive mode."
			echo "explain 'cmd -o | ...'   one quoted command to explain it."
		fi
	}

	# DISK
	disk-dir-top-used() {
		du -h | perl -e 'sub h{%h=(K=>10,M=>20,G=>30);($n,$u)=shift=~/([0-9.]+)(\D)/;
return $n*2**$h{$u}}print sort{h($b)<=>h($a)}<>;' | head -10
	}

	# top memory use
	topmem() {
		ps axo rss,comm,pid |
			awk '{ proc_list[$2]++; proc_list[$2 "," 1] += $1; } \
				END { for (proc in proc_list) { printf("%d\t%s\n", \
				proc_list[proc "," 1],proc); }}' | sort -n | tail -n 10 | sort -rn |
			awk '{$1/=1024;printf "%.0fMB\t",$1}{print $2}'
	}

	topcpu() {
		echo ".: TOP MEM :."
		ps aux --width 30 --sort -rss | head

		echo ""
		echo ".: TOP CPU  :."
		ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10
	}

	swap_which_process_is_using() {
		(
			echo "COMM PID SWAP"
			for file in /proc/*/status; do awk '/^Pid|VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | grep kB | grep -wv "0 kB" | sort -k 3 -n -r
		) | column -t
	}

	# clear memory cache
	mem-clear-cache() {
		echo "Cleaning memory cache..."
		sync
		echo "To free pagecache:"
		echo 1 >/proc/sys/vm/drop_caches
		echo "To free dentries and inodes:"
		echo 2 >/proc/sys/vm/drop_caches
		echo "To free pagecache, dentries and inodes:"
		echo 3 >/proc/sys/vm/drop_caches
		echo ""
	}

	# Count files in current directory
	disk-inodes-finder() {
		find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -n
	}

	# Latest 5 modified files recursively...
	disk-latest-files() {
		find . -type f -printf '%T@ %TY-%Tm-%Td %TH:%TM:%.2TS %p\n' | sort -nr | head -n 15 | cut -f2- -d" "
	}

	function processof() {
		ps -U $1 -u $1 u
	}

	sysHelp() {
		# Display Help
		echo "Description of the system aliases."
		echo
		echo "sortcons                     - sort connection state"
		echo "explain                      - explain a command with its params"
		echo "dir-top-used                 - show storage used by dirs"
		echo "topmem                       - top process using mem"
		echo "topcpu                       - top process using cpu"
		echo "swap_which_process_is_using  - process using swap"
		echo "clear-cache                  - clear memory cache"
		echo "inodes-finder                - count files in current directory"
		echo "latest-files                 - latest 5 modified files recursively..."
		echo "processof                    - process of an user"
		echo
	}

	# Website traffic statistics (G)
	function retlog() {
		if [[ -z $1 ]]; then
			#echo '/var/log/nginx/access.log'
			echo '/usr/local/apache/logs/access_log'
		else
			echo $1
		fi
	}

	# Second concurrent
	http-request-sec() {
		awk '{if($9~/200|30|404/)COUNT[$4]++}END{for( a in COUNT) print a,COUNT[a]}' "${retlog}" | sort -k 2 -nr | head -n10
	}
	# Statistical http status.
	http-code() {
		awk '{counts[$(9)]+=1}; END {for(code in counts) print code, counts[code]}' "${retlog}"
	}
	# Statistical connections 404
	http-code-404() {
		awk '($9 ~/404/)' "${retlog}" | awk '{print $9,$7}' | sort
	}
	# top100 of Page lists the most time-consuming (more than 60 seconds) as well as the corresponding page number of occurrences
	http-page-consume() {
		awk '($NF > 60 && $7~/\.php/){print $7}' "${retlog}" | sort -n | uniq -c | sort -nr | head -100
		# if django website or other webiste make by no suffix language
		# awk '{print $7}' "$(retlog)" |sort -n|uniq -c|sort -nr|head -100
	}
	# top10 of gain access to the ip address
	http-access-ip() {
		awk '{counts[$(11)]+=1}; END {for(url in counts) print counts[url], url}' "${retlog}"
	}

	# top20 of Most Visited file or page
	http-visit-page() {
		awk '{print $11}' "${retlog}" | sort | uniq -c | sort -nr | head -20
	}

	# View all 80 Port Connections
	ip-port-80() {
		netstat -nat | grep -i ":80" | wc -l
	}

	# View all 443 Port Connections
	ip-port-443() {
		netstat -nat | grep -i ":443" | wc -l
	}

	# top20 of Find the number of requests on 80 port
	ip-request-80() {
		sudo netstat -anlp | grep 80 | grep tcp | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr | head -n20
	}

	# top20 of Find the number of requests on 80 port
	ip-request-443() {
		sudo netstat -anlp | grep 443 | grep tcp | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr | head -n20
	}

	# top20 of Using tcpdump port 80 access to view
	ip-dump-80() {
		sudo tcpdump -i eth0 -tnn dst port 80 -c 1000 | awk -F"." '{print $1"."$2"."$3"."$4}' | sort | uniq -c | sort -nr | head -20
	}

	# top20 of Find time_wait connection
	ip-timewait() {
		netstat -n | grep TIME_WAIT | awk '{print $5}' | sort | uniq -c | sort -rn | head -n20
	}

	# top20 of Find SYN connection
	ip-syn() {
		netstat -an | grep SYN | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr | head -n20
	}

	# Sort connection state
	ip-sort-cons() {
		if [ $(uname -r | egrep ^2) ]; then
			netstat -nat | awk '{print $6}' | sort | uniq -c | sort -n
		else
			ss -pan | awk '{print $1}' | grep -v State | sort | uniq -c | sort -rn
		fi
	}

	# Sort connection by state
	ip-sort-cons-by-state() {
		netstat -nat | awk '{print $6}' | sort | uniq -c | sort -rn
	}

	ip-conn-by() {
		#netstat -atun | awk '{print $5}' | cut -d: -f1 | sed -e '/^$/d' |egrep -v '[a-z]|[A-Z]'|sort | uniq -c | sort -n
		netstat -an | egrep ":80|:443" | egrep '^tcp' | grep -v LISTEN | awk '{print $5}' | egrep '([0-9]{1,3}\.){3}[0-9]{1,3}' | sed 's/^\(.*:\)\?\(\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\).*$/\2/' | sort | uniq -c | sort -nr | sed 's/::ffff://' | head
	}

	netHelp() {
		# Display Help
		echo "Description of the web aliases."
		echo "Some alises are using ${retlog} variable than define web log file, by"
		echo "default: /var/log/nginx/access.log"
		echo
		echo "http-request-sec   - second concurrent (use \${retlog})"
		echo "http-code          - statistical http status (use \${retlog})"
		echo "http-code-404      - statistical connections 404 (use \${retlog})"
		echo "http-page-consume  - pages list the most time-consuming (use \${retlog})"
		echo "http-access-ip     - top10 of gain access to the ip address (use \${retlog})"
		echo "http-visit-page    - top20 of Most Visited file or page (use \${retlog})"
		echo "ip-port-80         - view all 80 Port Connections"
		echo "ip-request-80      - top20 of Find the number of requests on 80 port"
		echo "ip-dump-80         - top20 of Using tcpdump port 80 access to view"
		echo "ip-timewait        - top20 of Find time_wait connection"
		echo "ip-syn             - top20 of Find SYN connection"
		echo "ip-sort-cons       - sort connection state"
		echo "ip-conn-by         - connection by ip address"
		echo
	}

fi
