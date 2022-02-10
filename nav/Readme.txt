  -= Description =-
  This is a nav command used
for a convenient navigation inside
a bash shell.


  In order to work need to
chmod a+x installnav.bash
  and
sudo cp nav.bash /usr/bin/nav
  and create shell alias:
alias nv=". nav"
  or just call:
. nav


  -= Use =-
Call nav in the terminal.
A list of files in the current directory
will appear.
use arrow keys or
 _______
|   w   |
| a s d |
|_______|

to navigate up/down in the list.
Moveback to go up a folder.
Move forward to enter the next folder.

press h to see more options

press f to see only folders and not files

press x to exit


  -= Setting up =-
  To install call:
       chmod a+x installnav.bash
       sudo ./installnav.bash
as a superuser. nav.bash has to be in the
same folder as install.bash.
If does not work, then call:
       sudo bash install.bash
And then manually make an alias:
       alias nav=". nav"
  To configure:
In the beginning of nav.bash one can find
following variables:
  NofRowsToDisplay - maximum number of rows
                     (files or folders) to display
                     at a time;
  HIDE_FILES       - (1 or 0) by default either
                     (1) hide files or show only folders
                     or
                     (0) show both: files and folders;
  SHOW_HELP        - (0 or 1) by default either
                     (1) show help menu or (0) hide it.
 
  -= Problems =-
Bug [1]: Does not work well when file or folder names have [SPACE] in
them. File named "qwe rty.txt" will be interpreted as two files:
"qwe" and "rty.txt"
Bug [2]: When going to / multiple times, get addresses like ///home
