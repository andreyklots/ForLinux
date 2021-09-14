#!/bin/bash

#----------INITIAL-SETTINGS---------#
# How many lines to display
NofRowsToDisplay=7
# Hide files and show only folders
HIDE_FILES=0
# Hide or show help manu
SHOW_HELP=0
#------------------------------------#




# Function that makes list from folder
# $1 - folder address
# $2 - [--show-all || --hide-files] show only folders or all files
# $3 - grep options. Function calls: ls $1 | grep $3
function mkDirList { 
    mkDirList_Files=$(ls $1 | grep "$3")
    mkDirList_List0=($mkDirList_Files)
    result=()
    for s in "${mkDirList_List0[@]}"
    do
        if [[ -d $s || "$2" == "--show-all" ]]
       	then
	    result=("${result[@]}" "$s")
        fi
    done
    #result="${result[@]}"
}

# Function that prints the list
# Syntaxis: showList $CURSOR ${LIST[@]}
# $CURSOR - position of the cursor
# $LIST - list that needs to be displayed 
function showList {
    Arr=${@}
    showList_COUNTER=$((0))
    showList_NofLinesPrinted=$((0))
    for s in $Arr
    do
	if (( $showList_COUNTER == 0 ))
	then
		showList_CURSOR=$(($s+0))
	else
		# check if cursor should be in this line
		if (( $showList_COUNTER == $showList_CURSOR  ))
		then
		     showList_CUR_SHAPE="->"
		else
		     showList_CUR_SHAPE="  "
		fi

		# check if it's file or directory
		if [[ -d $s  ]]
		then
		    showList_FILE_OR_DIR="DIR"
		    tput setaf 2
		else
		    showList_FILE_OR_DIR="   "
		    tput setaf 1
		fi
	        
		# show $NofRowsToDisplay of folders where the cursor is
		showList_MinRow=$(($showList_CURSOR/$NofRowsToDisplay*$NofRowsToDisplay))
		showList_MaxRow=$(($showList_CURSOR/$NofRowsToDisplay*$NofRowsToDisplay+$NofRowsToDisplay))
		if (( $showList_COUNTER >= $showList_MinRow && $showList_COUNTER < $showList_MaxRow ))
	        then
		    echo "$showList_CUR_SHAPE $showList_FILE_OR_DIR $showList_COUNTER | $s"
                    showList_NofLinesPrinted=$(($showList_NofLinesPrinted+1))
		fi
	fi

	showList_COUNTER=$(($showList_COUNTER+1))
    done
    tput sgr0
}








CURRENT_WD=$(pwd)
#remember original working directory
MyORIGINAL_WD=$(pwd)
# cursor position
MyCURSOR=$((1))
# variable identified that the utility just started
JUST_STARTED=1

# Need to define number of lines in the displayed menu
NofMenuLines=7

# list of files and folders
result=()


# answer to key input
ans=" "
while [[ "$ans" != "x" ]]
do 
    
    ### Move cursor
    # Move up
    if [[ "$ans" == "w" || "$ans" == "A" ]]
    then
	 if (( $MyCURSOR > 1 ))
	 then
             MyCURSOR=$(( $MyCURSOR - 1  ))
	 fi
    fi
    # Move down
    if [[ "$ans" == "s" || "$ans" == "B" ]]
    then
	 if (( $MyCURSOR < ${#result[@]} ))
	 then
             MyCURSOR=$(( $MyCURSOR + 1  ))
	 fi
    fi
    # Jump to line
    if [[ "$ans" == "n" || "$ans" == "N" ]]
    then 
         echo ""
	 tput setaf 1
         echo "JUMP TO ENTRY #:"
	 tput sgr0
         read MyCURSOR
    fi


    ### Navigate
    # Move forward - to next folder
    if [[ "$ans" == "d" || "$ans" == "C"  ]]
    then
	 NEW_WD="$CURRENT_WD/${result[$(($MyCURSOR-1))]}"
	 if [[ -d $NEW_WD ]]
         then
             cd $NEW_WD
             CURRENT_WD=$NEW_WD
             PWD=$NEW_WD
             MyCURSOR=$((1))
         fi
    fi
    # Move back
    if [[ "$ans" == "a" || "$ans" == "D" ]]
    then
         cd ..
         CURRENT_WD=$(pwd)
         MyCURSOR=$((1))
    fi
    # Move to original folder
    if [[ "$ans" == "o" || "$ans" == "O" ]]
    then
        CURRENT_WD=$MyORIGINAL_WD
	cd $MyORIGINAL_WD
    fi
    # Show only folders 0 or 1
    if [[ "$ans" == "f" || "$ans" == "F" ]]
    then
        HIDE_FILES=$(( !$HIDE_FILES  ))
    fi
    # Show help 0 or 1
    if [[ "$ans" == "h" || "$ans" == "H" ]]
    then
        SHOW_HELP=$(( !$SHOW_HELP  ))
	# clear correct number of lines
	if (( !$SHOW_HELP  ))
        then
            tput cuu $(($NofMenuLines))
            tput dl $(($NofMenuLines))
	else
	    tput cud $(($NofMenuLines))
	fi
    fi


    ### call command
    if [[ "$ans" == "c" ]]
    then
        tput setaf 1
        echo ""
        echo "ENTER YOUR COMMAND:"
        tput sgr0
        read USER_COMMAND
        tput setaf 1
        echo "___...oooOOOooo...___"
        tput sgr0
	$USER_COMMAND $CURRENT_WD/${result[$(($MyCURSOR-1))]}
        tput setaf 1 
        echo ""
        echo "___...oooOOOooo...___"
        echo "PRESS ANY KEY TO GO BACK"
        tput sgr0
        read -n1
        echo ""
	JUST_STARTED=1
    fi

    ### implement grep command
    if [[ "$ans" == "g" ]]
    then
        tput setaf 1
	echo "ENTER GREP PARAMETERS:"
	tput sgr0
	read MyGREP_ATTR
    fi


    # Clear space
    NofExtraLines=$((2+2+$NofMenuLines*$SHOW_HELP))
    if (( $JUST_STARTED ))
    then
        JUST_STARTED=0
    else
        tput cuu $(($showList_NofLinesPrinted+$NofExtraLines))
        tput dl $(($showList_NofLinesPrinted+$NofExtraLines+1))
    fi


    # Print list
    if (( $HIDE_FILES ))
    then
        mkDirList $CURRENT_WD --hide $MyGREP_ATTR
    else
        mkDirList $CURRENT_WD --show-all $MyGREP_ATTR
    fi

    tput setaf 5
    echo ""    
    echo "_____[f]olders-only_____[h]help_____e[x]it"
    tput sgr0
    showList $MyCURSOR ${result[@]}
 

    # Print menu
    if (( $SHOW_HELP ))
    then
    tput setaf 4
        echo " ___________________________________________________ "
        echo "| w/s - move up/down     | a/d - next/prev folder   |"
        echo "| n - move cursor to #   | f - hide non-folders ($HIDE_FILES) |"
        echo "| o - to original folder | c - call command         |"
        echo "| h - show help ($SHOW_HELP)      | g - | grep '$MyGREP_ATTR' "
      	echo "| x - exit               |                          |"
        echo "|________________________|__________________________|"
    fi
    tput setaf 5
    echo "_________________________________[CURSOR = $MyCURSOR]"
    tput setaf 6
    echo "CURRENT DIR: $CURRENT_WD"
    tput sgr0



    read -n1  ans
    tput el1

done    
echo ""

