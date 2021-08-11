#!/bin/bash
# "Include" functions in the script
source ${HOME}/testscripts/advtools.sh

declare -a equipment

echo "What is your name, adventurer?"

read adventurer

echo "Nice to meet you, $adventurer"

####

echo "Would you like to play a game? [y/n]"

read decision
if [[ "$decision" == "y" ]]
then
	echo "Great! Lets go!"
else
	echo "Sad to see you go, $adventurer!"
fi

####

pickEqp

listEqp
