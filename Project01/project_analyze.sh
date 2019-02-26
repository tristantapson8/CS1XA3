#!/bin/bash
# Interactive Bash Menu Script

# Start by going to root directory (CS1XA3)
cd ..

# User menu instructions, displays the options that can be selected
echo " "
echo "Welcome to my Interactive Script!"
echo "Please review the user options below..."
echo "To use a feature, type in the corresponding number,"
echo "and simply press enter!"
echo " "

# User prompt message and user options 
PS3='Please enter a numbered (1-9) choice: '
options=("TODO Log" 
         "Merge Log" 
         "File Type Count"
         "Delete Temporary Files"
         "Check the Weather"
         "Compile Error Log"
         "Repository Status"
         "Help"
         "Quit")

# Case chosen based on user selected option from 'options'
select option in "${options[@]}"
do
    case $option in
        
        # ------ CREATING A TODO LOG ------
        "TODO Log")

            # add an empty file called todo.log to home dir (CS1XA3), if not already existing
            > todo.log

            # search all files, find all lines with #TODO tag and add it to todo.log
            # ignores searching through the todo.log file with the --exclude flag
            find . -type f | grep --exclude=todo.log -ir "#TODO" > todo.log

            # user notification messages
            echo " ";
            echo "You chose option $REPLY - $option!";
            echo "Created file <todo.log> in home directory.";
            echo "All #TODO messages added to todo.log successfully.";
            echo " ";;

        # ------ CREATING A MERGE LOG ------
        "Merge Log")

            # add an empty file called merge.log to home dir (CS1XA3), if not already existing
            > merge.log   

            # search all git commit message, find all with 'merge' ignoring case
            # sensitivity and add the commit hashes to merge.log
            git log --oneline | grep -i "merge" | cut -d' ' -f1 > merge.log

            # user notification messages
            echo " ";
            echo "You chose option $REPLY - $option!";
            echo "Created file <merge.log> in home directory.";
            echo "All commit hashes added to merge.log successfully.";
            echo " ";;

        # ------ COUNTING THE NUMBER OF FILES ------
        "File Type Count")

            # assign number of .<extension_name> files to a variable, and output the
            # total count using word count and echo
            HTML=`find . -name "*.html" | wc -l`
            JAVASCRIPT=`find . -name "*.js" | wc -l`
            CSS=`find . -name "*.css" | wc -l`
            HASKELL=`find . -name "*.hs" | wc -l`
            BSH=`find . -name "*.sh" | wc -l`

            # user notification messages
            echo " ";
            echo "You chose option $REPLY - $option!";
            echo "--- File Count ---";
            echo "html: $HTML";
            echo "javascript: $JAVASCRIPT";
            echo "css: $CSS";
            echo "haskell: $HASKELL";
            echo "bash: $BSH";
            echo " ";;

        # ------ DELETING TEMPORARY FILES ------
        "Delete Temporary Files")

            # user notification message  
            echo " ";
            echo "You chose option $REPLY - $option!";
            echo " ";

            # find all untracked files with the .tmp extension and delete them
            # all untracked files are listed before the deletion of files with the 
            # .tmp extension
            echo "Listing all untracked files before deletion(s):";
            find . -name "*.tmp" -type f -delete | git ls-files . --exclude-standard --others
            
            # user notification message
            echo " ";
            echo "All untracked .tmp files deleted successfully.";

            # all untracked files are listed after the deletion of files with the
            # .tmp exntension to show successful deletion(s)
            echo " ";
            echo "Listing all untracked files after deletion(s):";
            git ls-files . --exclude-standard --others
            echo " ";;

        # ------ BONUS FEATURE 1 - CHECKING THE WEATHER ------
        "Check the Weather")

            # user notification message
            echo " ";
            echo "You chose option $REPLY - $option!";

            # using curl example from  https://www.makeuseof.com/tag/get-curly-10-useful-things-can-curl/
            # displays a visual of the weather at current location over the next 3 days 
            curl wttr.in
            echo " ";;

        # ------ COMPILE ERROR LOG ------
        "Compile Error Log")

            # user notification messages
            echo " ";
            echo "You chose option $REPLY - $option!";
            echo "Created file <compile_fail.log> in home directory.";

            # add an empty file called compile_fail.log to home dir (CS1XA3), if not already existing
            > compile_fail.log
 
            # finding all bad haskell files
            # find all files with the .hs extension, and append the errored file(s) to compile_fail.log
            echo " ";
            echo "Haskell error(s) found: ";
            find . -name "*.hs" -exec ghc -fno-code {} \; >> compile_fail.log
       
            # finding all bad python files
            # find all files with the .py extension, assign it to variable PY  
            PY=`find . -name "*.py" -type f`
        
            echo " ";
            echo "Python error(s) found:";
            echo " ";

            # iterate through all found .py files, and append the errored file(s) to compile_fail.log
            for file in $PY; do
               if python $file; then
                  : # do nothing if no error is found
               else
                  echo "$file" >> compile_fail.log
               fi
            done                                   
            echo " ";;

        # ------ BONUS FEATURE 2 - REPOSITORY STATUS ------
        "Repository Status")

            # user notifcation message
            echo " ";
            echo "You chose option $REPLY - $option!";
            echo " ";

            # variables for local and remote host 
            $(git fetch origin) 
            LOC=$(git rev-parse origin/master)
            REM=$(git rev-parse master)
       
            # checks if the local host and the remote host are syncronized 
            if [ $LOC == $REM ]; then
               
               # user notification messages for local and remote host synchronization
               echo "Your local repository is up to date with the remote!";
               echo "No git pull needed - begin working as intended.";
            else 

               # user notifcation messages for unsynchronized local and remote hosts
               echo "Your local repository is NOT up to date with the remote.";
               echo "Consider doing a GIT PULL before starting your work!";
               echo "Changes on remote found below: ";
               echo " ";
           
               # displays all new files/commits found in the remote host
               git whatchanged origin/master -n 1
            fi
            echo " ";;

        # ------ HELP MENU IF USER FORGETS FEATURES ------
        "Help")

            # user notification message
            echo " ";
            echo "You chose option $REPLY - $option!";
            echo " ";

            # feature menu re-displayed via echo within the terminal
            echo "Please review the user options below... AGAIN!"; 
            echo "To use a feature, type in the corresponding number,";
            echo "and simply press enter!";
            echo " ";
            echo "1) TODO Log                6) Compile Error Log";
            echo "2) Merge Log               7) Repository Status";
            echo "3) File Type Count         8) Help";
            echo "4) Delete Temporary Files  9) Quit";
            echo "5) Check the Weather";
            echo " ";;
 
        # ------ QUIT / SCRIPT TERMINATION ------
        "Quit")
  
            # user notification messages   
            echo " ";
            echo "The script has been terminated...";
            echo "Have a nice day! ";
            echo " ";

            # terminate the script
            break;;

        # Illegal option selected (anything other than 1-9)
        *) echo "Invalid option!";
           echo " ";;
    esac
done
