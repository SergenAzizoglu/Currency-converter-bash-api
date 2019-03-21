#!/bin/bash
# Sergen Azizoğlu 150140
from='EUR'
to='PLN'
date=''
help='false'

while getopts 'f:t:d:h' flag; do
  case "${flag}" in
  	f)  from="${OPTARG}" ;;
	t)	to="${OPTARG}"	;;
	h)  help='true'		;;
	d)	date="${OPTARG}" ;;
  esac
done

n=1
while [ $# -gt 0 ]
do
  case $1 in
    -*) shift;;
    *) eval "arg_$n=\$1"; n=$(( $n + 1 )) ;;
  esac
  shift
done


if [ $help == 'true' ]; then

	echo ""
	echo "~~~~~~~~~~~ HELP MENU ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo ""
	echo "If an option -f/--from is given, the following argument determines currency in which the value is given. "
	echo ""
	echo "If an option -t/--to is given, the following argument determines currency to which the script should convert."
	echo ""
	echo "If an option -d/--date is given, the following argument determines the date for the conversion."
	echo ""
	echo ""
	echo ""
	
fi

if [ -n "$from" ]; then
  	api_url="https://api.exchangeratesapi.io/latest?base=$from"
fi

if [ -n "$date" ]; then
  	api_url="https://api.exchangeratesapi.io/$date?base=$from"
fi

download_parse(){
	curl -s $api_url --output /tmp/converter.json

	json_data=$(jq . /tmp/converter.json)

	money2="$(jq ".rates.$to" <<< "$json_data")"
	echo $(echo "$money2*$arg_1" | bc)
}

download_parse

