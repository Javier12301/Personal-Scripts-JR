#!/bin/bash

# Author: Javier Ramírez ;v

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${redColour}[!] Saliendo${endColour}"
	tput cnorm; exit 1

}
function helpPanel(){
	echo -e "\n${yellowColour}[!] Uso: ./btcAnalyzer.sh${endColour}"
	for i in $(seq 1 80); do echo -ne "${redColour}-"; done; echo -ne "${endColour}"

	echo -e "\n\n\t${grayColour}[-e]${endColour}${yellowColour} Modo exploración${endColour}"
	echo -e "\t\t${purpleColour}unconfirmed_transactions${endColour}${yellowColour}:\t Listado de transacciones no confirmadas${endColour}"
	echo -e "\t\t${purpleColour}inspect${endColour}${yellowColour}:\t\t\t Inspeccionar hash de transicción${endColour}"
	echo -e "\t\t${purpleColour}address${endColour}${yellowColour}:\t\t\t Inspeccionar una transacción de dirección${endColour}"

	 echo -e "\n\t${grayColour}[-h]${endColour}${yellowColour} Mostrar el panel de ayuda${endColour}"
	 tput cnorm; exit 1
}

# Variables Globales
unconfirmed_transactions="https://www.blockchain.com/es/explorer/mempool/btc"
inspect_transaction_url="https://www.blockchain.com/es/explorer/transactions/btc/"
inspect_address_url="https://www.blockchain.com/es/explorer/addresses/btc/"

function unconfirmedTransactions(){
	echo '' > ut.tmp

	while [ "$(cat ut.tmp | wc -l)" == '1' ]; do
	    curl -s "$unconfirmed_transactions" | html2markdown > ut.tmp
	done

	hashes=$(cat ut.tmp | grep -Eo "btc/[a-zA-Z0-9./?=_%:-]*" | grep -Eo "/[a-zA-Z0-9./?=_%:-]*" | grep -Eo "[a-zA-Z0-9.?=_%:-]*")

	echo "Hash_Cantidad_Bitcoin_Tiempo" > ut.table

	for hash in $hashes; do
		echo "${hash}_$" >> ut.table 
	done


	tput cnorm


}

parametro_counter=0; while getopts e:h: parm ; do
	case $parm in
		e)
			exploration_mode=$OPTARG; let parametro_counter+=1;;

		h)
			helpPanel;;

		*)
			usage
			echo "invalid argument"
	esac
done

#Esconder Cursor
tput civis
if [ $parametro_counter -eq 0 ]; then
	helpPanel
else
	if [ "$(echo $exploration_mode)" == "unconfirmed_transactions" ]; then
		unconfirmedTransactions
	fi
fi






