#!/bin/bash
# Bash Menu Script Example

# User menu instructions, displays the options that can be selected
echo " "
echo "Welcome to my Interactive Script!"
echo "Please review the user options below..."
echo " "

# User prompt message and user options 
PS3='Please enter a numbered (1-6) choice: '
options=("Create a TODO Log" 
         "Merge Log" 
         "File Type Count"
         "Delete Temporary Files"
         "BONUS"
         "Quit")

# Case chosen based on user selected option from 'options'
select option in "${options[@]}"
do
    case $option in
        
        # CREATING A TODO LOG
        "Create a TODO Log")
            # add a file called todo.log if not already existing
            touch todo.log

            # search all files, find all lines with #TODO tag and add it to todo.log
            # ignores searching through the todo.log file with the --exclude flag
            find . -type f | grep --exclude=todo.log -ir "#TODO" > todo.log

            # user notification message
            echo " ";
            echo "You chose choice 1 - $option!";
            echo "All #TODO messages added to todo.log succesfully";
            echo " ";;

        # CREATING A MERGE LOG
        "Merge Log")

            echo " ";
            echo "You chose choice 2 - $option!"
            echo " ";;

        # COUNTING THE NUMBER OF FILES
        "File Type Count")

            echo " ";
            echo "You chose choice $REPLY - $option!";
            echo " ";;

        # DELETING TEMPORARY FILES
        "Delete Temporary Files")
   
            echo " ";
            echo "You chose choice $REPLY - $option!";
            echo " ";;

        # BONUS FEATURE??!!
        "BONUS")

            echo " ";
            echo "You chose choice $REPLY - $option!";
            echo " ";;
 
        # QUIT / SCRIPT TERMINATION 
        "Quit")
 
            echo " ";
            echo "The script has terminated...";
            echo "Have a nice day! ";
            echo " ";
            break;;

        # Illegal option selected (anything other than 1-6)
        *) echo "Invalid option $REPLY";
           echo " ";;
    esac
done
