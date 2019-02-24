
## How to Use
* This script is a user prompted interactive script.
  The user simply runs the script like any other via ./
  and proceeds to follow instructions. The user is prompted
  for a number (1-9) depending on which feature they want to
  use, and the script does said feature; 1-8 will be features
  assigned according to the assignment outline, 9 to terminate
  the script. To use a feature, just enter the number according
  to the feature you wish to use, and then press enter.

* NOTE: all logs are placed in the CS1XA3 directory after
  the specified log feature is used during script run time.

## Features
### 1 - TODO Log
* All #TODO tags are place into a file called todo.log in the CS1XA3
  directory with the accompanying file name.

### 2 - Merge Log
* All commit messages mentioning the word "merge" have their corresponding
  hashes placed into a file called merge.log in the CS1XA3 directory

### 3 - File Type Count
* Counts the number of HTML, Javascript, Python, Haskell, and Bash files
  via recursive decent from the home directory (CS1XA3), and dislays the
  count of each.

### 4 - Delete Temporary Files
* Lists all untracked files, and then deletes them if they have the .tmp
  extension. Before and after deletion(s) are displayed to the user to verify
  that the feature is working as intended.

### 5 - Check the Weather (Boonus Feature 1)
* Using curl, gives the user the weather forecast of the next 3 days in their
  local area

### 6 - Compile Error Log 
* Finds all haskell & python files via recursive decent from the home directory
  (CS1XA3) containing errors and places the file name in compile_fail.log, which
  is also placed into the home directory. During script run time, the user gets
  feedback within the terminal as to what these errors are.

### 7 - Repository Status (Bonus Feature 2)
* As the TAs/Instructors are going to be modifying our git repos, I figured it 
  would be a good idea to implement this feature! Its intended purpose is to be
  used before a user sits down to work, and notifies them if any changes have been
  made to their remote repo via comparison to the local repo. After doing so, it 
  recommends a git pull, and displays all the changed made in the remote repository.

### 8 - Help Menu
* Simple display as to what feature correseponds to what number. This is displayed
  initially when the script is first ran, however if the user forgets they can always
  go back to it with this feature.

### 9 - Quit
* Terminates the script, with a goodbye message.
