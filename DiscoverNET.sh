#!/bin/bash

clear
echo ""

Banner (){
echo "#######################"
echo "## IoT Alive Scanner ##"
echo "#######################"
echo ""
}

Banner

if [ "$1" == "" ]; then
	echo "	[-] - Use mode => $0 <API_Key>"
else
	while true
	do
		Exec_Hour=$(date | cut -d " " -f4) # Em alguns casos pode ser -f5 o campo.
		# Time definition - Está funcionando - Adequar hora do servidor.
		if [ "$Exec_Hour" == "00:00:00" ] || [ "$Exec_Hour" == "08:00:00" ] || [ "$Exec_Hour" == "16:00:00" ] || [ "$Exec_Hour" == "$2" ]; then
			Shodan_Start=$(shodan init $1)
			if [ "$Shodan_Start" == "Successfully initialized" ]; then
				echo "	[+] Shodan start ..."
				for Target_Query in $(cat Target_Query.txt); do
					echo "		[+] Search by $Target_Query ..."
					shodan search $Target_Query --fields ip_str country:BR 2> /dev/null >> Shodan_IPList.txt
				done
					for IP in $(cat Shodan_IPList.txt); do
						Port=$(shodan host $IP --format tsv | cut -d " " -f5,6)
						echo "	[+] IP => $IP"
						echo "	[+] Ports:"
						echo "		$Port"
						echo ""
						echo ""
						echo ""
					done
					# Apenas para listar IPs - cat Shodan_IPList.txt
					# Versão final -  tail -f Shodan_IPList.txt
			else
				echo "	[-] Shodan failure ..."
				exit
			fi
		else
			echo "	[-] - Wait time to execute ..." >> /dev/null
		fi
	done
fi

# Criar regra de detecção.
# Equipamento exposto para a Internet mapeado pelo Shodan.