#!/bin/bash
while [[ "$choice" != "q" ]]
do

        echo "Pick an equipment";
        echo "s - spade";
        echo "b - bread"; echo

	local choice

        read choice

        case "$choice" in
                [Ss] )
                        echo "Spade"
                        equipment+=(spade)
                        ;;
                [Bb] )
                        echo "Bread"
                        equipment+=(bread)
                        ;;
                [Qq] ) ;;
                *    )
                        echo "Not proper choice"
                        ;;
        esac
done
