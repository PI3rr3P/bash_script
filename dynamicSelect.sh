#!/bin/bash

function _formatLineOption
{
	local line=$1
	local sizePrevLine=$2
	local formatedLine=${line}
	local addSpace=""
	local addBackSpace=""
	local diffSize=0
	local space=' '
	if [[ ${#line} -lt $sizePrevLine ]]; then
		diffSize=$(( $sizePrevLine - ${#line} ))
		for (( i=0; i < $diffSize ; i++ ))
		do
			addSpace="$addSpace${space}"
			addBackSpace="${addBackSpace}\b"
		done
	fi
	echo "$formatedLine${addSpace}$addBackSpace"
	return 0
}

function _dynamicSelect
{
	# external parameter
	local -a choiceList=$1
	choiceList=(${choiceList})
	local cmdName=$2
	local -n choice=$3
	# internal parameter
	local -i currentIndex=0
	local -i sizePrevLine=0
	local -i size=${#choiceList}
	size=$(( size - 1 ))
	local resumeChoiseLoop=true
	local firstLoop=true
	local action=""
	local line=""
	while [[ $resumeChoiseLoop == true ]]
	do
		# print one choice
		line="\t\033[36;1m${cmdName}\033[0m ${choiceList[$currentIndex]}"
		formatedLine=$(_formatLineOption "${line}" "${sizePrevLine}")
		if [[ $firstLoop == false ]]; then
			echo -en "\r${formatedLine}"
		else
			echo -en "${line}"
		fi
		# read answer
		read -s -n 1 action
		case $action in
			e)	choice="";
				resumeChoiseLoop=false;
				;;
			a)	choice=${choiceList[$currentIndex]}
				resumeChoiseLoop=false;
				echo -e ""
				;;
			z)	currentIndex=$(( currentIndex + 1 ));
				if (( currentIndex > size )); then
					currentIndex=0
				fi
				;;
			*|?) echo -e "option (e) to exit, (a) to select, (z) to go next";
				;;
		esac
		# for next loop
		firstLoop=false
		sizePrevLine=${#line}
	done
	return 0
}