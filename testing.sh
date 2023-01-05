#!/bin/bash

nombre=""

function prueba(){
	hash="$1" 

	eliminar_fecha=$(cat ut.tmp | grep "$hash" -B 1 | grep "hash *" | grep -Eo ":[0-9]*.*" | grep -o '[0-9].*' | grep -m3 -o '[0-9].*' | grep -Eo '[0-9][0-9]*:')

	bash_original=$(cat ut.tmp | grep "$hash" -B 1 | grep "hash *" | grep -Eo ":[0-9]*.*" | grep -o '[0-9].*' | grep -m3 -o '[0-9].*' | grep -v $eliminar_fecha)

	bitcoin=$(cat ut.tmp | grep "$hash" -B 1 | grep "hash *" | grep -Eo ":[0-9]*.*" | grep -o '[0-9].*' | grep -m3 -o '[0-9].*' | grep -Eo "[$eliminar_fecha]*[0-9]*.[0-9]*" | grep -Eo ":[0-9]*.*" | grep -Eo "[0-9].*" | cut -c 3-13)


}

prueba "ef4f548a905f64ceda05c1e603c449ea1b4d0741992305ebbe7fccf9fcf03c9c" && echo $bitcoin "BTC"


