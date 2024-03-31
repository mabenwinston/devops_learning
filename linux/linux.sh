# -----------------------------------------------------------SED COMMAND--------------------------------------------------------------------------------
#The caret sign followed by the number sign (^#) indicates the beginning of a line. whereas (^$) represents blank lines.


sed 's/unix/linux/' file1.txt      ----> To Replace or substitute a string only first occurrence of the pattern in a line

sed 's/unix/linux/2' file1.txt     ----> Replacing the 2nd occurrence of a pattern in a line

sed 's/unix/linux/g' file1.txt     ----> Replacing all the occurrence of the pattern in a line

sed 's/unix/linux/3g' file1.txt    ----> Replacing from 3rd occurrence to all occurrences in a line 

echo "Welcome To The Geek Stuff" | sed 's/\(\b[A-Z]\)/\(\1\)/g'  ----> Parenthesize first character of each word >>(W)elcome (T)o (T)he (G)eek (S)tuff

sed '3 s/unix/linux/' file1.txt    ----> Replacing string on a specific line number i.e, 3rd line only

sed 's/unix/linux/p' file1.txt     ----> Duplicating the replaced line with /p flag

sed -n 's/unix/linux/p' file1.txt  ----> Printing only the replaced lines

sed '1,3 s/unix/linux/' file1.txt  ----> Replacing string on a range of lines from all 1st occurences of 1 to 3rd line

sed '2,$ s/unix/linux/' file1.txt  ----> Here "$" indicates the last line in the file. So the command replaces the text from 2nd line to last line in the file

sed '5d' filename.txt ----> To Delete a particular line say 5 in this example

sed '$d' filename.txt ----> To Delete a last line

sed '3,6d' filename.txt ----> To Delete line from range x to y

sed '12,$d' filename.txt ----> To Delete from 12th to last line

sed '/abc/d' filename.txt ----> To Delete pattern matching line here ex----> abc is the pattern

# File Spacing 

sed G file.txt ----> Insert one blank line after each line

sed 'G;G' file.txt ----> To insert two blank lines

sed '/^$/d;G' file.txt ----> Delete blank lines and insert one blank line after each line

sed '/properties/{x;p;x;}' file.txt ----> Insert a black line above every line which matches "properties"

sed '/properties/G' file.txt ----> Insert a blank line below every line which matches “properties”

sed 's/^/     /' file.txt ----> Insert 5 spaces to the left of every lines

# Numbering lines 

sed = file.txt | sed 'N;s/\n/\t/' ----> Number each line of a file (left alignment). **=** is used to number the line. \t is used for tab between them.

sed = file.txt | sed 'N; s/^/     /; s/ *\(.\{4,\}\)\n/\1  /' ----> Number each line of a file (number on left, right-aligned).

sed '/./=' file.txt | sed '/./N; s/\n/ /' ---->  Number each line of file, only if line is not blank 

# Deleting lines 

sed '5d' file.txt  ----> Delete a particular line 5th here

sed '$d' file1.txt ----> Delete the last line 

sed '3,5d' file.txt ----> Delete line from range 3 to 5.

sed '2,$d' file.txt ----> Delete from 2nd to last line 

sed '/life/d' file.txt ---->  Delete the pattern matching line 'life'

sed '3~2d' file.txt ----> Delete lines starting from 3rd line and every 2nd line from there

sed '/easy/,+2d' file.txt ---->  Delete the lines which matches the pattern 'easy' and 2nd lines after to that

sed '/^$/d' file.txt ----> Delete blank Lines 

sed -i '/^/d' file.txt ----> Delete or clear all lines

sed -i '/^#/d;/^$/d' file.txt ----> Delete empty lines or those begins with “#” 

# View/Print the files 

sed -n '2,5p' file.txt ----> Viewing a file from x to y range(2-5 range)

sed '2,4d' file.txt ---->  View the entire file except the given range 

sed -n '4'p file.txt ----> Print nth line of the file(here 4th line)

sed -n '4,6'p file.txt ---->  Print lines from xth line to yth line.

sed -n '$'p file.txt ---->  Print only the last line

sed -n /every/p file.txt ----> Print the line only which matches the pattern

sed -n '/everyone/,5p' file.txt ----> Print lines which matches the pattern i.e from input to 5th line. 

sed -n '1,/everyone/p' file.txt --->  Prints lines from input, up-to line which matches the pattern. If pattern not found then print up-to end of the file.

sed -n '/learn/,+2p' file.txt ----> Print the lines which matches the pattern up-to the next xth(2nd here) lines

# Replacement with the sed command 

sed -i 's/^/delete/' file.txt ----> sed command to append a word at beginning of every line

sed -i 's/$/:8080/' file.txt ----> sed command to append a word at end of every line

sed 's/life/leaves/' file.txt ----> Change the first occurrence of the pattern

sed 's/to/two/2' file.txt ----> Replacing the nth (2nd) occurrence of a pattern in a line

sed 's/life/learn/g' file.txt ----> Replacing all the occurrence of the pattern in a line.  

sed 's/to/TWO/2g' file.txt   ----> Replace pattern from nth(2nd here) occurrence to all occurrences in a line.
sed -n 's/to/TWO/p' file.txt ---->  Print only the replaced lines, then use “-n” option along with “/p” print flag to display only the replaced lines 
sed 's/to/TWO/p' file.txt ----> Print the replaced lines twice, then only use “/p” print flag without “-n” option-  

sed '3 s/every/each/' file.txt     ----> Replacing pattern on a specific line number. Here, “m” is the line number. 
sed -n '3 s/every/each/p' file.txt ----> Print only the replaced lines

sed '2,5 s/to/TWO/' file.txt -----> Replace string on a defined range of lines (2 to 5)
sed '2,$ s/to/TWO/' file.txt ----->  "$" can be used in place of "5" if we wish to change the pattern up-to last line in the file. 

sed 's/life/Love/i' file.txt    ----> Replace pattern in order to ignore character case (beginning with uppercase or lowercase)
sed 's/[Ll]ife/Love/g' file.txt ----> Replace pattern in order to ignore character case (beginning with uppercase or lowercase)

sed 's/  */ /g' filename ----> To replace multiple spaces with a single space

sed '/is/ s/live/love/' file.txt ---->  Replace one pattern followed by the another pattern

sed -i '5!s/life/love/' file.txt -----> Replace a pattern with other except in the 5th line

# PRACTICAL SED COMMANDS

sed -n '5,10p' file.txt ----> Viewing a range of lines of a document

sed '20,35d' file.txt ----> Viewing the entire file except a given range

sed -n -e '5,7p' -e '10,13p' file.txt ----> Viewing non-consecutive lines and ranges

sed 's/version/story/g' file.txt ----> To replace every instance of the word version with story in file.txt

sed 's/version/story/gi' file.txt ---->  Using gi instead of g in order to ignore character case

ip route show | sed 's/  */ /g'  ----> To replace multiple blank spaces with a single space

sed '30,40 s/version/story/g' file.txt ----> Replacing words or characters inside a range

sed '/^#\|^$\| *#/d' httpd.conf ----> To remove empty lines or those beginning with "#" from the Apache configuration file

sed 's/[Zz]ip/rar/g' file.txt ---> To replace a word beginning with uppercase or lowercase with another word.

sed -n '/^Jul  1/ p' /var/log/secure ----> Viewing lines containing with a given pattern "Jul 1" at the beginning of each line

sed -i 's/\r//' file.txt ----> Emulating dos2unix with inline editing

sed -i'.orig' 's/this/that/gi' file.txt ----> In-place editing and backing up original file

sed '/services/ s/start/stop/g' file.txt ----> Replace start with stop only if the word services is found in the same line

sed -i 's/that/this/gi;s/line/verse/gi' file.txt ----> Performing two or more substitutions at once

sed -i "567 -r file1.xml" file2.xml ----> Append the lines after 567 from file1.txt to file2.txt 



--------------------------------------------------------------------GREP COMMAND-------------------------------------------------------------------------------
##OPTIONS WITH GREP COMMAND

-c   ----> This prints only a count of the lines that match a pattern
-h   ----> Display the matched lines, but do not display the filenames.
-i   ----> Ignores, case sensitivity for matching
-r   ----> To search recursively in dir and sub dirs
-l   ----> Displays list of a filenames only.
-n   ----> Display the matched lines and their line numbers.
-v   ----> This prints out all the lines that do not matches the pattern
-e   ----> Specifies expression with this option. Can use multiple times.
-f   ----> Takes patterns from file, one per line and then search in another file for that pattern(the search string can be passed line after line)
-E   ----> Treats pattern as an extended regular expression (Multiple search string can be passed)
-w   ----> Match whole word
-o   ----> Print only the matched parts of a matching line, with each such part on a separate output line.
-x   ----> Select only those matches that exactly match the whole line.
-A n ----> Prints searched line and n lines after the result.
-B n ----> Prints searched line and n line before the result.
-C n ----> Prints searched line and n lines after before the result.

##Rules to create patterns

xy|pq   ----> Mathes for xy and pq in all files
^xyz    ----> Matches with the line starting with "xyz"
xyz$    ----> Matches with line ending with "xyz"
^$      ----> Search for empty lines
\	    ----> To remove the special purpose of any symbol ( ex - grep -E "/^|/$" file.txt)
.	    ----> Matches any one character (ex - grep -E "t..s" file.txt)
\.	    ----> To match dot with dot present in a file
\b 	    ----> Match the empty string at the edge of the words
?	    ----> The preceeding character is optional and will be matched only once
*	    ----> The preceeding character will be matched zero or more times
+	    ----> The preceeding character will be matched one or more times
[xyz]   ----> Matches for the lines which are having x or y or z
[a-d]   ----> Equal to [abcd] matches for line having a/b/c/d
[a-ds-z]----> Search for a to d and then s to z
^[xy]   ----> Print lines starting with x and y
[^xy]   ----> Search other than x and y
xf{4}   ----> Search for x and followed by f(4 times ex- ffff)
xf{3,4} ----> Search for x and also f (occuring 3 or 4 times)

grep -E [xyz] file.txt ----> To search for x/y/z

grep -E "t..s" file.txt ----> Search for string starting with 't' and ending with 's' [ex----> this]

grep -E "^$" file.txt ----> To serch for empty lines in file.txt

grep -E "\." file.txt ----> Search for lines with dot(.) in file.txt

grep -E "line/b" file.txt ----> Match the string "line" and a space after that.

grep -E "/bline/b" file.txt ----> Match the string "line" having space in begining and end.

grep -E "YB+" file.txt ----> After 'Y' the preceeding string 'B' should be present once and max any no.of times

grep -E "YB?" file.txt ----> The preceeding string 'B' is optional to be searched and will be searched for max one time occurence

grep -E "YB*" file.txt ----> The preceeding string 'B' to be searched zero or more times occurence

grep -wn "</CONFIG_HELPER>" configHelper.xml ----> Display line number along with the searched string
	
grep -i "UNix" file1.txt ----> Case insensitive search, The -i option enables to search for a string case insensitively 

grep -c "unix" file1.txt ---->  Displaying the count of number of matches 

grep -l "unix" * ----> Display the file names that matches the patterns

grep -w "unix" file1.txt ----> Checking for the whole words in a file

grep -o "unix" file1.txt ----> Displaying only the matched pattern

grep -n "unix" file1.txt ----> Show line number while displaying the output

grep -v "unix" file1.txt ----> Display the lines that are not matched with the specified search string pattern.

grep "^unix" file1.txt ---->  Matching the lines that start with a string, The ^ regular expression pattern specifies the start of a line.

grep "os$" file1.txt ---->  Matching the lines that end with a string. The $ regular expression pattern specifies the end of a line

grep –e "Agarwal" –e "Aggarwal" –e "Agrawal" file1.txt ----> Specifies expression with -e option. Can use multiple times.

grep –f pattern.txt  file1.txt  ----> The pattern.txt file has "Agarwal" "Aggarwal" "Agrawal" string, which is searched in file1.txt

grep -E "unix|linux|bash|shell" file.txt ----> The 4 search string is searched in file.txt one by one

grep -iRL "GCS19C" /home/rmbadm  ---> Search recursively for a pattern in the directory and display the file names

grep -A 1 "UNIX" file.txt ----> Prints searched line and 1 line after that result

grep -B 2 "UNIX" file.txt ----> Prints searched line and 2 line before that result

grep -A 1 "UNIX" file.txt ----> Prints searched line, then 1 line after that result and 1 line before the result.

grep -r "unix" * ----> To search recursevely in present dir and its sub dirs

grep -l "unix" * ----> Display the file names only for the searched pattern

grep -h "unix" * ----> Hide file names and display only the matched pattern

grep -irw 'SECGDEFF' . --exclude-dir={Bancslib,lib}

grep -Irw --exclude=webServiceClient.properties 'SECGDEFF' .



---------------------------------------------------------------------AWK COMMAND-------------------------------------------------------------------------------

awk -F ":" '{print $3}'


---------------------------------------------------------------------CUT COMMAND-------------------------------------------------------------------------------

#1 -b(byte)----> To extract the specific bytes, separated by comma. Range specified using the (-). Tabs and backspaces are treated like as a character of 1 byte.
 
cut -b 1,2,3 state.txt   ----> List without ranges
cut -b 1-3,5-7 state.txt ----> List with ranges
cut -b 1- state.txt      ----> In this, "1-" indicate from 1st byte to end byte of a line
cut -b -3 state.txt		 ----> In this, "-3" indicate from 1st byte to 3rd byte of a line

---------------------------------------------------------------------------------------------------------------------------------------------------------------

#<<<<<<<<<<<<<--------------------------------------------------LS command---------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>#

ls 	----> List the files in the directory
ls Documents/ ----> List  all files in document dir
ls / ----> Shows the content of root dir
ls .. ----> Shows 1 step back dir structure content
ls ../.. ----> Shows 2 step back dir structure content
ls -l ----> Shows files in long format
ls -a ----> Shows the hidden files
ls -al ----> Gives hidden files and Long list combined
ls -lS ---->  Sorts dir or files by size and display
ls -ls ----> Sorts files by name and display
ls Documents/*.html ----> Lists out all files of html extension
ls Documents/*.* ----> List out all files
ls -ld Documents/ ----> To check permission or details of dir
ls -ls > doc.txt ----> Stores the dir content in doc.txt file
ls -d ---->  List only the directory
ls -R ----> Shows the dir structure

#<<<<<<<<<<<<<--------------------------------------------------CD command---------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>#

cd / ----> Change of dir to root
cd ~ ----> Return to home directory
cd .. ----> Go 1 folder back or parent dir
cd ../.. ----> Go 2 folder/dir back
cd Documents ----> 	Go to Documents dir or relative path
cd home/maben/Documents/ ----> Absolute path
cd My\ books or $ cd “My books” ----> Navigate to folder that has space in between 

#<<<<<<<<<<<<<--------------------------------------------------CAT command---------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>#

cat ----> To echo out whatever input is given or typed
cat list.txt ----> Display the content of file list.txt
cat list1.txt list2.txt ----> Display both the file together
cat -b list.txt ----> Add line num to non-blank line
cat -n list.txt ----> Add line num to blank lines also
cat -s list.txt ----> Squezes multiple blank lines to single line
cat -E list.txt ----> Add $ to every end of lines
cat > test.txt ----> Redirect the output to test.txt file
cat >> test.txt ----> Apend the file without overwriting
cat list1.txt list2.txt > out.txt ----> Redirect the files
cat list1.txt >> list2.txt ----> Copy from one file to other
cat .bash_history ----> Shows history of commands executed

#<<<<<<<<<<<<<--------------------------------------------------MKDIR command---------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>#


mkdir Document ----> Creates dir called document
mkdir Document/Tool ----> Creates sub dir under Document
mkdir -p Marks/name ----> Create dir and sub dir that does not exist
mkdir -p Marks/{John, Tom, Bob} ----> Create 3 sub dir in Marks dir


#<<<<<<<<<<<<<--------------------------------------------------RM command---------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>#


rm -rf Documents ----> Removes the Document dir and folders in it
rm -r home/user ----> Removes the user dir only or files in it
rm -rv Marks ----> (v - verbose) display details while remove Marks dir.

#<<<<<<<<<<<<<--------------------------------------------------CP command---------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>#


-n 1 – tells xargs to use at most one argument per command line and send to the cp command. 
-v   – enables verbose mode to show details of the copy operation. 
-g   – progress-bar 

cp file1.txt file2.txt ----> Copy from file 1 to file 2 if file2.txt does not exist then cp command will create it
cp file1.txt dir1 ----> Copy file to directory
cp file1.txt file2.txt dir2 ----> Copy multiple files to dir2
cp -i file1.txt file2.txt dir1 ----> Asks for overwrite permisssion if same file exsist.
cp -R dir1 dir2 ----> Copy dir1 to dir2
cp -v /home/aaronkilik/bin/sys_info.sh /home/aaronkilik/test ----> Copy sys_info.sh to test folder
echo /home/aaronkilik/test/ /home/aaronkilik/tmp | xargs -n 1 cp -v /home/aaronkilik/bin/sys_info.sh ---->  Copy sys_info.sh to multiple folders test and temp

#<<<<<<<<<<<<<--------------------------------------------------MV command---------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>#


mv file1.txt file2.txt ----> Move file from one to another
mv file3.txt dir/ ----> Move file to dir
mv dir1 dir2 ----> Move dir1 inside dir2
mv -v file3.txt dir3 ----> Move file to dir (v- verbose)
mv -i file1.txt file2.txt dir1 ----> Ask overide permission if file exists

#<<<<<<<<<<<<<--------------------------------------------------TAR command---------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>#


c - create tar file
v - verbose
f – Specify file name ( If  'f' flag is not used then the zip file is created)
z - .gz or gzip format file

tar -cvf test.tar test ----> Create tar file (original file name – test, created file name – test.tar)
tar -xvf test ----> Extract the tar file or uncompress
tar -czvf test.tar.gz test ----> Creates gzip or .gz file (gun zip file)
tar -xzvf test.tar.gz ----> Uncompress the gz file

 
#<<<<<<<<<<<<<--------------------------------------------------find command---------------------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>#

# Part I – Basic Find Commands for Finding Files with Names 
find . -name bpmn.txt ----> Find all the files whose name is tecmint.txt in a current working directory. 
find /home -name bpmn.txt ----> Find all the files under /home directory with the name tecmint.txt
find /home -iname bpmn.txt ----> Find all the files whose name is tecmint.txt and contains both capital and small letters in /home directory 
find . -type f -name log4j.jar ----> Find all jar files whose name is log4j.jar in a current working directory. 
find . -type f -name "*.jar" ----> Find all jar files in a directory. 
find . -type f -exec grep -l "RMBFI" {} \; ----> Search for RMBFI in all files 

# Part II – Find Files Based on their Permissions 
find . -type f -perm 0777 -print ----> Find all the files whose permissions are 777 
find / -type f ! -perm 777 ----> Find all the files without permission 777. 
find / -perm 2644 ----> Find all the SGID bit files whose permissions are set to 644. 
find / -perm 1551 ----> Find all the Sticky Bit set files whose permission is 551 
find / -perm /u=s ----> Find all SUID set files. 
find / -perm /g=s ----> Find all SGID set files. 
find / -perm /u=r ----> Find all Read-Only files.
find / -perm /a=x ----> Find all Executable files 
find / -type f -perm 0777 -print -exec chmod 644 {} \; ----> Find all 777 permission files and use the chmod command to set permissions to 644. 
find / -type d -perm 777 -print -exec chmod 755 {} \; ----> Find all 777 permission directories and use the chmod command to set permissions to 755. 
find . -type f -name "log2.txt" -exec rm -f {} \; ----> To find a single file called log2.txt and remove it. 
find . -type f -name "*.txt" -exec rm -f {} \; ----> To find and remove multiple files such as .jar or .txt, then use.
find /home0 -type f -empty ----> To find all empty files under a certain path.  
find /tmp -type d -empty ----> To file all empty directories under a certain path. 
find /tmp -type f -name ".*" ----> To find all hidden files, use the below command. 

# Part III – Search Files Based On Owners and Groups 
find / -user rmbadm -name log.txt ----> To find all or single files called log.txt under / root directory of owner rmbadm. 
find /home -user rmbadm ----> To find all files that belong to user Tecmint under /home directory. 
find /home -group developer ----> To find all files that belong to the group Developer under /home directory. 
find /home -user rmbadm -iname "*.txt" ----> To find all .txt files of user rmbadm under /home directory. 

# Part IV – Find Files and Directories Based on Date and Time 

-mtime +n  for greater than n days,
-mtime -n  for less than n days,
-mtime n   for exactly n days.


find . -type f -name *.jar -mtime 50 ----> To find all the jar files which are modified 50 days back. 
find . -type f -atime 50 ----> To find all the files which are accessed 50 days back. 
find . -type f -mtime +50 –mtime -100 ----> To find all the files which are modified more than 50 days back and less than 100 days. 
find . -type f -cmin -60 ----> To find all the files which are changed in the last 1 hour. 
find . -type f -mmin -60 ----> To find all the files which are modified in the last 1 hour 
find . -type f -amin -60 ----> To find all the files which are accessed in the last 1 hour. 

# Part V – Find Files and Directories Based on Size 
find / -size 50M ----> To find all 50MB files, use. 
find / -size +50M -size -100M ----> To find all the files which are greater than 50MB and less than 100MB. 
find / -type f -size +100M -exec rm -f {} \; ----> To find all 100MB files and delete them using one single command. 
find / -type f -name *.jar -size +10M -exec rm {} \; ----> Find all jar files with more than 10MB and delete them using one single command. 

# Part VI - Find command with sed & grep
find . -type f -exec sed -i 's/GSC19C/BSF19C/g' {} \; ----> Replace GSC19C with BSF19C
find . -iname "*.jar" -exec dirname {} \; | sort -u   ----> Find all directories with jar files
find . -iname "*.jar" | wc -l	----> Find all jar files a display the count
find . -type f -exec grep -i "GSC19C" {} \;  ----> Grep for GSC19C in all files

# Part VII - Advanced FIND Command
find . -type f \( -name "*.xml" -o -name "*.properties" \) ! -name Install_Scripts
find . -type f \( -name "*.properties" -o -name "*.xml" \) -exec grep -ilw "\#${name}\#" {} \;
find / -type f -name 'file*' -exec mv {} {}_renamed \;
find /tmp/dir1/ -type f -exec chown root:root {} \; -exec chmod o+x {} \;
find /tmp/ -type f -mtime +5 -exec ls -l {} \; ---> List files 5days old
find . -mtime -7 \( -name '*.jpg' -o -name '*.png' \) ----> Files modified in past 7 days
find /tmp -type d -empty ---> Find empty dir
----------------------------------------------------------------------------------------------------------------------------------------------------------------


rsync -arvz --exclude 'SI_HOME' --exclude 'BATCH_HOME' --exclude 'BC' $STAGE/${tenant}/STATIC/* $Server_Conn:${Env_Home_Path}/ > /dev/null 2>&1

echo $line|cpio -pdm --quiet ${STAGE}/BO/STATIC/ > /dev/null 2>&1