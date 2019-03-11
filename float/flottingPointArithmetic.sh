#!/bin/bash
# first version

# dAD = digit After Dot
# when number too large ${#interger[@]} > MAX_DIGIT
# try to do the math with and without dot

#Use for futur test before operation
readonly MAX_INT=$((2**63-1))
readonly STR_MAX_INT=$(echo $MAX_INT)
readonly MAX_DIGIT=${#STR_MAX_INT}

function to_int
{
	local string=$1
	local integer=${string//'.'/}
	string=(${string//'.'/' '})
	declare -i dAD=${#string[1]}
	if [[ ${string[0]} =~ [0]? ]]; then # remove leading zero 
		for ((i=0; i < ${#integer}; i++))
		do # the interger is the rest of the string without preceeding zeros
			if [[ ${integer:$i:1} != '0' ]]; then
				integer=${integer:$i}
				break
			fi
		done
	fi
	echo ${integer} ${dAD}
}

function to_strArray
{
	# request string
	local string=$1
	# output
	declare -a array
	# processing
	for ((i=0; i < ${#string}; i++))
	do
		array+=("${string:$i:1}")
	done
	echo "${array[@]}"
}

function catZeros
{
	local string=$1
	declare -i nbZeros=$2
	for ((i=0; i < $nbZeros; i++))
	do
		string+="0"
	done
	echo $string
}

function to_strFloat
{

	declare -a integer=($(to_strArray $1))
	declare -i dAD=${2:-0}
	# local variable declaration
	local string=""
	# processing
	# adding zero (if under unit)
	if (( ${#integer[@]} - 1 - $dAD < 0 ));then
		string+="0."
		for ((i = 1; i < $dAD + 1 - ${#integer[@]}; i++))
		do
			string+="0"
		done
	fi
	# set the dot
	for (( i=0; i < ${#integer[@]}; i++ ))
	do
		string+="${integer[i]}"
		if (( $i == ${#integer[@]} - 1 - $dAD )); then
			string+="."
			if (( $dAD == 0 )); then
				string+="0"
			fi
		fi
	done
	echo $string
}

function add
{
	local s_1=$1 #string contain float
	local s_2=$2 #string contain float
	declare -i int_1
	declare -i dAD_1
	read -r int_1 dAD_1 <<< $(to_int $s_1) 
	declare -i int_2 
	declare -i dAD_2
	read -r int_2 dAD_2 <<< $(to_int $s_2)
	declare -i max_dAD=$dAD_1
	if (( $dAD_2 > $dAD_1 )); then
	 	max_dAD=$dAD_2
	 	local diff=$(( dAD_2 - dAD_1 ))
		int_1=$( catZeros $int_1 $diff )
	else
		max_dAD=$dAD_1
		local diff=$(($dAD_1 - $dAD_2))
		int_2=$( catZeros $int_2 $diff )
	fi
	result=$(( int_1 + int_2 ))
	echo $(to_strFloat ${result} ${max_dAD})
}

function sub
{
	local s_1=$1 #string contain float
	local s_2=$2 #string contain float
	declare -i int_1
	declare -i dAD_1
	read -r int_1 dAD_1 <<< $(to_int $s_1) 
	declare -i int_2 
	declare -i dAD_2
	read -r int_2 dAD_2 <<< $(to_int $s_2)
	declare -i max_dAD=$dAD_1
	if (( $dAD_2 > $dAD_1 )); then
	 	max_dAD=$dAD_2
	 	local diff=$(( dAD_2 -  dAD_1 ))
		int_1=$( catZeros $int_1 $diff )
	else
		max_dAD=$dAD_1
		local diff=$(( dAD_1 -  dAD_2 ))
		int_2=$( catZeros $int_2 $diff )
	fi
	result=$(( int_1 - int_2 ))
	echo $(to_strFloat ${result} ${max_dAD})
}

function mult
{
	local s_1=$1 #string contain float
	local s_2=$2 #string contain float
	declare -i int_1
	declare -i dAD_1
	read -r int_1 dAD_1 <<< $(to_int $s_1) 
	declare -i int_2 
	declare -i dAD_2
	read -r int_2 dAD_2 <<< $(to_int $s_2)
	declare -i sum_dAD=$(( dAD_1 + dAD_2 ))
	result=$(( int_1 * int_2 ))
	echo $(to_strFloat ${result} ${sum_dAD})
}

function divide
{
	declare -i numerator=$1
	declare -i denominator=$2
	declare -i recursionDepth=${3:-0}
	local quotient=$(( numerator / denominator ))
	local remainder=$(( numerator % denominator ))
	local sub_quotient=""
	if (( $recursionDepth < 12 )) && (( $remainder > 0 )); then
		recursion=$(($recursionDepth + 1))
		remainder="${remainder}0"
		sub_quotient=$( divide $remainder $denominator $recursion )
	fi
	if (( ${recursionDepth} == 0 )); then
		quotient="${quotient}."
		if [[ ${sub_quotient} == "" ]]; then
			sub_quotient="0"
		fi
	fi
	quotient="${quotient}${sub_quotient}"
	echo "${quotient}"
}

function div
{
	local s_1=$1 #string containing float
	local s_2=$2 #string containing float
	declare -i int_1
	declare -i dAD_1
	read -r int_1 dAD_1 <<< $(to_int $s_1) 
	declare -i int_2 
	declare -i dAD_2
	read -r int_2 dAD_2 <<< $(to_int $s_2)
	declare -i max_dAD=$dAD_1
	declare -i sub_dAD=$(( dAD_1 - dAD_2 ))
	if (( $dAD_2 > $dAD_1 )); then
	 	max_dAD=$dAD_2
	 	local diff=$(( dAD_2 - dAD_1 ))
		int_1=$( catZeros $int_1 $diff )
	else
		max_dAD=$dAD_1
		local diff=$(( dAD_1 - dAD_2 ))
		int_2=$( catZeros $int_2 $diff )
	fi
	result=$( divide $int_1 $int_2 )
	echo "${result}"
}

function power_int
{
	local int=$1
	declare -i exponent=$2
	local res=0
	if (( exponent < 0 )); then
		int=$( div 1.0 ${int} )
		exponent=$(( -1 * exponent ))
		res=$(power_int ${int} ${exponent})
	elif (( exponent == 0 )); then
		res=1
	elif (( exponent % 2 == 0 )); then
		int=$(( int * int ))
		exponent=$(( exponent / 2 ))
		res=$( power_int ${int} ${exponent} )
	else
		exponent=$(( (exponent - 1) / 2 ))
		int2=$((int * int))
		res=$( power_int $int2 $exponent )
		res=$(( int * res ))
	fi
	echo ${res}
}

function sqrt
{
	# use continuous fraction
	echo "not implemented yet"
}

function op
{
	#echo -e "not yet implemented"
	for arg in "$@"
	do
		echo -e "$arg"
	done
	# operation=$2
	# case ${operation} in
	# 	'+') ;;
	# 	'-') ;;
	# 	'*') ;;
	# 	'/') ;;
	#	'//') ;;
	# 	'%') ;;
	#	'^') ;;
	#	'exp') ;;
	#	'ln') ;;
	# 	?)
	# esac
}