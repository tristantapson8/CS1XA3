#!/bin/bash
# Interactive Bash Menu Script

# Start by going to root directory (CS1XA3)
cd ..

# User menu instructions, displays the options that can be selected
echo " "
echo "Welcome to my Interactive Script!"
echo "Please review the user options below..."
echo " "

# User prompt message and user options 
PS3='Please enter a numbered (1-6) choice: '
options=("TODO Log" 
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
        "TODO Log")
            # add a file called todo.log if not already existing
            touch todo.log

            # search all files, find all lines with #TODO tag and add it to todo.log
            # ignores searching through the todo.log file with the --exclude flag
            find . -type f | grep --exclude=todo.log -ir "#TODO" > todo.log

            # user notification messages
            echo " ";
            echo "You chose option 1 - $option!";
            echo "Created file <todo.log>";
            echo "All #TODO messages added to todo.log successfully.";
            echo " ";;

        # CREATING A MERGE LOG
        "Merge Log")
            # add a file called merge.log if not already existing
            touch merge.log   

            # search all git commit message, find all with 'merge' ignoring case
            # sensitivity and add the commit hashes to merge.log
            git log --oneline | grep -i "merge" | cut -d' ' -f1 > merge.log

            # user notification messages
            echo " ";
            echo "You chose option 2 - $option!";
            echo "Created file <merge.log>";
            echo "All commit hashes added to merge.log successfully.";
            echo " ";;

        # COUNTING THE NUMBER OF FILES
        "File Type Count")

            # assign number of .<extension" files to a variable, and output the
            # count using word count and echo
            HTML=`find . -name "*.html" | wc -l`
            JAVASCRIPT=`find . -name "*.js" | wc -l`
            CSS=`find . -name "*.css" | wc -l`
            HASKELL=`find . -name "*.hs" | wc -l`
            BSH=`find . -name "*.sh" | wc -l`

            # user notification messages
            echo " ";
            echo "You chose option 3 - $option!";
            echo "--- File Count ---";
            echo "html: $HTML";
            echo "javascript: $JAVASCRIPT";
            echo "css: $CSS";
            echo "haskell: $HASKELL";
            echo "bash: $BSH";
            echo " ";;

        # DELETING TEMPORARY FILES
        "Delete Temporary Files")
            # user notification message  
            echo " ";
            echo "You chose option 4 - $option!"
            echo " ";

            # find all untracked files with the .tmp extension and delete them
            # all untracked files are listed before the deletion of files with the 
            # .tmp extension
            echo "Listing all untracked files before deletion(s):"
            find . -name "*.tmp" -type f -delete | git ls-files . --exclude-standard --others
            
            # user notification message
            echo " ";
            echo "All untracked .tmp files deleted successfully.";

            # all untracked files are listed after the deletion of files with the
            # .tmp exntension to show successful deletion(s)
            echo " ";
            echo "Listing all untracked files after deletion(s):"
            git ls-files . --exclude-standard --others
            echo " ";;

        # BONUS FEATURE ??!!
        "BONUS")

            echo " ";
            echo "You chose option 5 - $option!";
            echo "Feature is still under production...";
            echo " ";;
 
        # QUIT / SCRIPT TERMINATION 
        "Quit")
 
            echo " ";
            echo "The script has been terminated...";
            echo "Have a nice day! ";
            echo " ";
            break;;

        # Illegal option selected (anything other than 1-6)
        *) echo "Invalid option!";
           echo " ";;
    esac
done
