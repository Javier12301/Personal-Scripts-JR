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
#####################################TABLAS S4VITAR
function printTable(){

    local -r delimiter="${1}"
    local -r data="$(removeEmptyLines "${2}")"

    if [[ "${delimiter}" != '' && "$(isEmptyString "${data}")" = 'false' ]]
    then
        local -r numberOfLines="$(wc -l <<< "${data}")"

        if [[ "${numberOfLines}" -gt '0' ]]
        then
            local table=''
            local i=1

            for ((i = 1; i <= "${numberOfLines}"; i = i + 1))
            do
                local line=''
                line="$(sed "${i}q;d" <<< "${data}")"

                local numberOfColumns='0'
                numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<< "${line}")"

                if [[ "${i}" -eq '1' ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi

                table="${table}\n"

                local j=1

                for ((j = 1; j <= "${numberOfColumns}"; j = j + 1))
                do
                    table="${table}$(printf '#| %s' "$(cut -d "${delimiter}" -f "${j}" <<< "${line}")")"
                done

                table="${table}#|\n"

                if [[ "${i}" -eq '1' ]] || [[ "${numberOfLines}" -gt '1' && "${i}" -eq "${numberOfLines}" ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
            done

            if [[ "$(isEmptyString "${table}")" = 'false' ]]
            then
                echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1'
            fi
        fi
    fi
}

function removeEmptyLines(){

    local -r content="${1}"
    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString(){

    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString(){

    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
}

function trimString(){

    local -r string="${1}"
    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}


###############################TABLAS S4VITAR

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
	echo $hashes
	echo "Hash_Cantidad_Bitcoin_Tiempo" > ut.table

	for hash in $hashes; do
		echo " ${hash}_$(cat ut.tmp | grep "$hashes" | grep -Eo 'BTC[\$a-zA-Z0-9./?=_,%:-]*' | grep -Eo '[\$0-9,.]*' " >> ut.table
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






