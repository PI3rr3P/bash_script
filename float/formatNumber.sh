#!/bin/bash

function pass
{
	echo -e "Not yet implemented"
}

function whatFormat
{
	local number=$1
	if [[ $number =~ .*[E]+ ]]; then
		echo "exponential"
	elif [[ $number =~ .*[.]+ ]]; then
		echo "flot"
	elif [[ $number =~ .*[@#]+ ]]; then
		echo "internal"
	else
		echo "error"
	fi
	return 0
}

function split
{
	local string=$1
	local splitted=""
	for (( i=0; i < ${#string}; i++ ))
	do
		if (( i == 0)); then
			splitted="('${string:$i:1}'"
		else
			splitted+=" '${string:$i:1}'"
		fi
	done
	echo "${splitted})"
	return 0
}

function getDAD
{
	# digit must be formatted
	# get digit after dot
	local -a formatted=$(split $1)
	local dad=""
	local start=false
	for char in "${formatted[@]}"
	do
		if [[ ${start} == true ]]; then
			dad+="${char}"
		elif [[ ${char} == "@" ]]; then
			start=true
		elif [[ ${char} == "#" ]]; then
			break
		fi
	done
	echo $dad
	return 0
}

function getPOW
{
	# digit must be formatted
	# get power if the number is exponential-formatted
	local -a formatted=$(split $1)
	local pow=""
	local start=false
	for char in "${formatted[@]}"
	do
		if [[ ${start} == true ]]; then
			pow="${pow}${char}"
		elif [[ ${char} == "#" ]]; then
			start=true
		fi
	done
	if [[ $pow == "" ]]; then
		echo "0"
	else
		echo $pow
	fi
	return 0
}

function getNUM
{
	local -a formatted=$(split $1)
	local number=""
	for char in "${formatted[@]}"
	do
		if [[ $char != '@' ]] && [[ $char != '#' ]]; then
			number+="$char"
		else
			break
		fi
	done
	echo $number
	return 0
}

function format_ToInternal
{
	local number=$1
	local currentFormalt=$(whatFormat $number)
	if [[ $currentFormat == "exponential" ]]; then
		if [[ $number =~ [+]+ ]]; then # remove + in E+0x if exponential
			number=${number//'+'}
		fi
		format_Expo_To_Internal $number
	elif [[ $currentFormat == "flot" ]]; then
		format_Float_To_Internal $number
	else
		echo $currentFormat
	fi
	return 0
}

function format_Float_To_Internal
{
	local -a string=$(split $1)
	local float=""
	local -i dad=0
	local start_dad=false
	for char in "${string[@]}"
	do
		if [[ $start_dad == true ]]; then
			dad=$((dad + 1))
		fi
		if [[ $char == '.' ]]; then
			start_dad=true
		else
			float+="${char}"
		fi
	done
	echo "${float}@${dad}"
	return 0
}

function format_Expo_To_Internal
{
	local -a string=(${1//'E'/' '})
	local formatted=''
	formatted+=$(format_Float_To_Internal ${string[0]})
	formatted+="#${string[1]}"
	echo ${formatted}
}

function unformat
{
	pass
}

function unformat_Internal_To_Dot
{
	pass
}

function unformat_Internal_To_Exp
{
	pass
}