#!/bin/bash

hash="1f22aa08acc027588ba1b848d48f6e2bbaff79b99600a8d5b9fd49f35e20b0c0"

eliminar_fecha=$(cat ut.tmp | grep "$hash" -B 1 | grep "hash *" | grep -Eo ":[0-9]*.*" | grep -o '[0-9].*' | grep -m3 -o '[0-9].*' | grep -Eo '[0-9][0-9]*:')

bash_original=$(cat ut.tmp | grep "$hash" -B 1 | grep "hash *" | grep -Eo ":[0-9]*.*" | grep -o '[0-9].*' | grep -m3 -o '[0-9].*' | grep -v $eliminar_fecha)

bitcoin=$(cat ut.tmp | grep "$hash" -B 1 | grep "hash *" | grep -Eo ":[0-9]*.*" | grep -o '[0-9].*' | grep -m3 -o '[0-9].*' | grep -Eo "[$eliminar_fecha]*[0-9]*.[0-9]*" | grep -Eo ":[0-9]*.*" | grep -Eo "[0-9].*" | cut -c 3-13)

echo $bitcoin"BTC"



