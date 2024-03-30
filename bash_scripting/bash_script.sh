#----------------------------------------------------------INTRODUCTION-------------------------------------------------------------------------------------#

Shell scripts are Interpreted and not compiled
$ cat /etc/shells - Gives different shells the os supports
Bash stands for Bourne shell
$ which bash - Shows where bash is located
$ touch hello.sh - Create a shell script file
Open this script file in vi editor and write the program
$ ./hello.sh - Run the script file

1]. First hello world program
#!/bin/bash
echo "Hello world"

#------------------------------------------------------VARIABLES & COMMENTS------------------------------------------------------------------------------#

In unix there are 2 types of variables
System variables - These variables are pre-defined created and maintained by linux os(Upper case)
User defined variables - These are created by the user(Lower case)

1] System variables:
#!/bin/bash
echo "Hello world"  #this is a comment
echo $BASH
echo $BASH_VERSION
echo $HOME
echo $PWD

2]. User variables:
#!/bin/bash
echo "Hello world"   #this is a comment

echo Our shell name is $BASH
echo Our shell version name is $BASH_VERSION
echo Our home directory is $HOME
echo Our current working directory is $PWD

name = Maben
echo The name is $name

#-------------------------------------------------------------USER INPUT-------------------------------------------------------------------------------------#

To get input from user use read command
Then the input will be saved in some variable
Multiple user input can be taken
read -p falg allows to have user input on same line
read -sp flag is for silent, it hides the input for password
read -a read multiple inputs and store in a array
read is used if no variable is declared then input is stored in a in-built variable called $REPLY

1]. Single user input
#! /bin/bash

echo "Enter name: "
read name
echo "The name entered is $name"

2]. Multiple user input
#! /bin/bash

echo "Enter name: "
read name1 name2 name3
echo "The name entered is: $name1 , $name2 , $name3"

3]. Enter the input on same line
#! /bin/bash

read -p 'username : ' user_var
echo "username : $user_var"

4]. Make the input silent for password
#! /bin/bash

read -p 'username : ' user_var
read -sp 'password : ' pass_var
echo
echo "username : $user_var"
echo "password is : $pass_var"

5]. Read multiple input and store in an array
#! /bin/bash

echo "Enter the names : "
read -a names
echo "Names : ${names[0]}, ${names[1]}"

6]. Read a variable using $REPLY
#! /bin/bash

echo "Enter the name : "
read
echo "Name : $REPLY"

#------------------------------------------------------------PASS ARGUMENT-----------------------------------------------------------------------------------#

The passesd argument will be stored in $1 $2 $3.... so on
$0 which is the 0th index will have the name of the script file
If args=("$@") is used then 0th index will be the 1st argument passed not the script name
$@ - default variable that prints the argument passed
$# - default variable that prints the number of argument passed
$? - Status of last executed command ( ex: exit 1 )

1]. Print the user input as argument passed along with the $0 - script name
#! /bin/bash

echo $0 $1 $2 $3

2]. Print the arguments passed using the default variable $@
#! /bin/bash

args=("$@")
echo ${args[0]} ${args[1} ${args[2]}

3]. Print the number arguments using default variable $#
#! /bin/bash

args=("$@")

echo $@
echo $#


#-------------------------------------------------------------------------------------IF STATEMENT----------------------------------------------------------------------------------#

Integer comparison
-eq : is equal to : if [ "$a" -eq "$b" ]
-ne : is not equal to : if [ "$a" -ne "$b" ]
-gt : is greater than : if [ "$a" -gt "$b" ]
-ge : is greater than or equal to : if [ "$a" -ge "$b" ]
-lt : is less than :if [ "$a" -lt "$b" ]
-le : is less than or equla to : if [ "$a" -le "$b" ]
<  : is less than : (("$a > "$b"))
<= : is less than or equal to : (("$a <= "$b"))
>  : is greater than : (("$a > "$b"))
>= : is greater than or equal to : (("$a >= "$b"))

String comparison
=  : is equal to : if [ "$a" = "$b" ]
== : is equal to : if [ "$a" == "$b" ]
!= : is not equal to : if [ "$a" != "$b" ]
<  : is less than, in ASCII alphabetical order : if [[ "$a" < "$b" ]]
>  : is less than, in ASCII alphabetical order : if [[ "$a" > "$b" ]]
-z : string is null or has zero length


1]. if statement with integer "-eq" comparision
#! /bin/bash

count=10
if [ $count -eq 10 ]
then
    echo "condition is true"
fi

2]. if statement with integer " > " comparision
#! /bin/bash

count=10
if (( $count > 8 ))
then
    echo "condition is true"
fi

3]. if statement with string "==" comparison
#! /bin/bash

word=abc
if [ $word == "abc" ]
then
    echo "condition is true"
fi

4]. if-else statement with string " < " comparison
#! /bin/bash

word=a
if [[ $word < "b" ]]
then
    echo "condition is true"
else
    echo "condition is false"
fi

5]. if-elif-else statement
#! /bin/bash

word=a
if [[ $word == "b" ]]
then
    echo "condition b is true"
elif [[ $word == "a" ]]
then
    echo "condition a is true"
else
    echo "condition is false"
fi

#-------------------------------------------------------------------------------FILE TEST OPERATORS------------------------------------------------------------------------#

There are 2 types file 
1. Character special - normal file that contains text or data
2. Block special - binary file that has image, videos etc
\c and -e flag together in echo commandin keeps the cursor on same line while taking user input
-e = In if statement checks for the file name
-f  = In if statement checks whether the file exist and its regular file or not
-d = In if statement checks for directory
-b = In if statement flag for block special type of file
-c = In if statement flag for character special type of file.
-s = In if statement check whether empty or not
-r = In if statement check whether the file has read permission
-w = In if statement check whether the file has write permission
-x = In if statement check whether the file has execute permission

1]. To search file name using if statement 
#! /bin/bash

echo -e "Enter the name of file : \c"
read file_name

if [ -e file_name ]
then
    echo "$file_name found"
else
    echo "$file_name not found"
fi

2]. To search for a file exist and is regular file or not
#! /bin/bash

echo -e "Enter the name of file : \c"
read file_name

if [ -f file_name ]
then
    echo "$file_name found"
else
    echo "$file_name not found"
fi

3]. To search for a directory
#! /bin/bash

echo -e "Enter the name of directory : \c"
read dir_name

if [ -d dir_name ]
then
    echo "$dir_name found"
else
    echo "$dir_name not found"
fi

4]. To check whether a file is empty or not
#! /bin/bash

echo -e "Enter the name of file : \c"
read file_name

if [ -s file_name ]
then
    echo "$file_name not empty"
else
    echo "$file_name empty"
fi

#-------------------------------------------------------------------------------------APPEND OUTPUT TO END OF TEXT FILE------------------------------------------------------------#

Steps to make a script that appends the output to the end of text file
Take the file name as a user input
Check whether the file exists or not
If exists then check if it has write permission
So if the file has write permission then append it using cat command

#! /bin/bash

echo -e "Enter the name of file : \c"
read file_name

if [ -f file_name ]
then
	if [ -w $file_name ]
	then
	    echo "Type some text or data. To quit press Ctrl+d."
	    cat >> $file_name
	else
	    echo "The file does not have write permission"
	fi
else
    echo "$file_name empty"
fi

#---------------------------------------------------------------AND OPERATOR---------------------------------------------------------------------------------#

There are 3 ways of using AND operator
&& - is called the AND operator
-a can be used instead of  && operator

1]. Use of && operator
#! /bin/bash
 age=25

if [ $age -gt 18 ] && [ $age -lt 30 ]
then
     echo "valid age"
else
     echo "age not valid"
fi

2]. Use of -a to replace && operator
#! /bin/bash

 age=25

if [ $age -gt 18 -a $age -lt 30 ]
then
     echo "valid age"
else
     echo "age not valid"
fi

3]. Another way of using && operator
#! /bin/bash
 age=25

if [[ $age -gt 18 && $age -lt 30 ]]
then
     echo "valid age"
else
     echo "age not valid"
fi

#-----------------------------------------------------------------OR OPERATOR---------------------------------------------------------------------------------#

The OR operator can be used in 3 ways
| | - is called the OR operator
-o can be used instead of | | 

1]. Use of OR operator
#! /bin/bash
 age=60

if [ $age -gt 18 ] || [ $age -lt 30 ]
then
     echo "valid age"
else
     echo "age not valid"
fi

2]. Use of -o to replace | | operator
#! /bin/bash
 age=25

if [ $age -gt 18 -o $age -lt 30 ]
then
     echo "valid age"
else
     echo "age not valid"
fi

3]. Another way of using OR operator
#! /bin/bash
 age=25

if [[ $age -gt 18 || $age -lt 30 ]]
then
     echo "valid age"
else
     echo "age not valid"
fi

#------------------------------------------------------------ARTHMETIC OPERATION----------------------------------------------------------------------------#

To perform arthmetic operation the syntax $(( num1 + num2 )) should be followed
Alternate way to perform arthmetic operation is $(expr $num1 + $num2 )
While using expr the multiplication symbol “ * ” should be combined with escape character “\*”

1]. To perform arthmetic operation on 2 numbers
#! /bin/bash

num1=20
num2=5

echo $(( num1 + num2 ))
echo $(( num1 - num2 ))
echo $(( num1 * num2 ))
echo $(( num1 / num2 ))
echo $(( num1 % num2 ))

2]. To perform arthmetic operation using expr
#! /bin/bash

num1=20
num2=5

echo $(expr $num1 + $num2 )
echo $(expr $num1 - $num2 )
echo $(expr $num1 \* $num2 )
echo $(expr $num1 / $num2 )
echo $(expr $num1 % $num2 )

#---------------------------------------------------------FLOATING POINT MATH OPERATION------------------------------------------------------------------#

bc - To perform floating point or decimal arthmetic operation 
For division operation we have to set the scale. If upto 2 decimal places then scale=2
To calculate square root we have to call the math library using -l

1]. To perform floating point operation using bc 
#! /bin/bash

num1=20.5
num2=5

echo "20.5+5" | bc
echo "20.5-5" | bc
echo "20.5*5" | bc
echo "scale=2;20.5/5" | bc
echo "20.5%5" | bc

2]. To find square root of a number and power of a number
#! /bin/bash

num=4
echo “scale=2;sqrt($num)” | bc -l
echo “scale=2;3^3” | bc -l

#---------------------------------------------------------CASE STATEMENT------------------------------------------------------------------------------#

* - asterisk means wildcard which matches any text, or default condition of any length
? - Special character having single length, taken input from user
$ LANG=C - set env varaible to if capital letter dont work

1]. Use of case statement
#! /bin/bash

vehicle=$1

case $vehicle in
	“car” )
	      echo “Rent of $vehicle is 100 dollar” ;;
	“van” )
	      echo “Rent of $vehicle is 80 dollar” ;;
	“bicycle” )
	      echo “Rent of $vehicle is 5 dollar” ;;
	“truck” )
	      echo “Rent of $vehicle is 150 dollar” ;;
	* )
	      echo “Unknown vehicle” ;;
esac


2]. User input case statement
#! /bin/bash

echo -e “Enter some character : \c”
read value

case $value in
	[a-z] )
	      echo “User entered $value a to z” ;;
	[A-Z] )
	      echo “User entered $value A to Z” ;;
	[0-9] )
	      echo “User entered $value 0 to 9” ;;
	? )
	      echo “User entered $value is Special character” ;;
	* )
	      echo “Unknown input” ;;
esac

#--------------------------------------------------------ARRAY VARIABLES-------------------------------------------------------------------------------#

Bash supports simple 1-D arrays. Example: array_name=('ubuntu' 'windows' 'kali')
${array_name[@]} - Prints all the array elements.
${array_name[1]} - Prints the 2nd index element of the array
${!array_name[@]} - Prints only the index numbers respectively from the array
${#array_name[@]} - Prints the length of the array
array_name[2]='mac' - Adds a element to the 3rd  index of the array
unset array_name[2] - Deletes or removes the 3rd index element from the array
string=abcdefghij - All elements are stored in single index that is 0.

1]. Example for array variables
#! /bin/bash

os=('ubuntu' 'windows' 'kali')

os[3]='mac'
unset os[2]
echo “${os[@]}”
echo “${os[1]}”
echo “${!os[@]}”
echo “${#os[@]}”

string=abcdefghij
echo “${string[@]}”
echo “${string[0]}”
echo “${string[1]}”
echo “${!string[@]}”
echo “${#string[@]}”

#----------------------------------------------------------WHILE LOOPS---------------------------------------------------------------------------------------#

While loop is executed when a condition is True
Any of the below increments can be used to increment declared value, the result remains the same
n=$(( n+1 )) - Increments the n value
(( ++n )) - Pre increment the n value
(( n++ )) - Post increment the n value
sleep 2 - Gives a pause of 2 seconds before or after printing
genome-terminal & - Opens the genome terminal
xterm & - Opens the terminal 

1]. Print 1-10 numbers using WHILE loop
#! /bin/bash

n=1
while [ $n -le 10 ]
do
     echo "$n"
     n=$(( n+1 ))
done

2]. Alternate way of printing 1-10  numbers
#! /bin/bash

n=1
while (( $n <= 10 ))
do
     echo "$n"
     n=$(( n++ ))
done

3]. Using sleep with WHILE loops
#! /bin/bash

n=1
while (( $n <= 10 ))
do
     echo "$n"
     n=$(( n++ ))
     sleep 1
done

4]. Open any terminal using WHILE loop
#! /bin/bash

n=1
while [ $n -le 3 ]
do
     echo "$n"
     n=$(( n++ ))
     genome-terminal &
done

#! /bin/bash

n=1
while [ $n -le 3 ]
do
     echo "$n"
     n=$(( n++ ))
     xterm &
done

#--------------------------------------------------------READ FILE CONTENT USING WHILE LOOP-------------------------------------------------------------#

1. Input redirection using "<" at script end
read p - The content of the hello.sh file to be read is redirected to this variable "p"

#! /bin/bash

while read p
do
     echo $p
done < hello.sh

2. Read file in a single variable and then print it
cat hello.sh | while read p - Read the file content using cat and then redirect to variable p.

#! /bin/bash

cat hello.sh | while read p
do
     echo $p
done

3. Read files that contain special character using IFS - Internal feild seperator
IFS=  - Give a space after equals to in IFS
read -r line - The -r flag prevents back slash or escapes being interpreted
Instaed of file name hello.sh, the file path can also be given as input redirection
#! /bin/bash 

while IFS=  read -r line
do
     echo $line
done < hello.sh

UNTIL LOOPS

Until loop is executed when a condition is false

1]. Until loop to print numbers 1 to 10
#! /bin/bash

n=1

until [ $n -gt 10 ]
do
	echo $n
	n=$(( n++ ))
done

#----------------------------------------------------------FOR LOOP-------------------------------------------------------------------------------------#
There are various syntax to use for loop

1]. Using variables as input to print numbers
{1..10} - Used to specify range from 1 to 10
{1..10..2} - Increments in by 2 values from 1 to 10
-d - This flag is used to check for directory
-f - This flag is used to check for files

#! /bin/bash

for i in 1 2 3 4 5
do
     echo $i
done

#! /bin/bash

for i in {1..10}
do
     echo $i
done

#! /bin/bash

for i in {1..10..2}
do
     echo $i
done

2]. Using expression to print numbers
#! /bin/bash

for (( i=0; i<5; i++ ))
do
     echo $i
done

3]. Using a linux command as input
#! /bin/bash

for command in ls pwd date
do
     echo "----------------$command----------------"
     $command
done

4].Using file and directory name as input
#! /bin/bash

for item in *
do
     if [ -d $item ]
     then
            echo $item
     fi
done

#! /bin/bash

for item in *
do
     if [ -f $item ]
     then
            echo $item
     fi
done

#-------------------------------------------------------SELECT LOOP-----------------------------------------------------------------------------------#

Select loop allows to generate easy menus


1]. Use of select loop
#! /bin/bash

select name in mark john tom ben
do
      echo "$name selected"
done

2]. Select loop with case statement
#! /bin/bash

select name in mark john tom ben
do
     case $name in
     mark)
            echo mark selected ;;
     john)
            echo john selected ;;
     tom)
            echo tom selected ;;
     ben)
            echo ben selected ;;
     *)
            echo "Echo please provide the number between 1..4"
     esac
done

#----------------------------------------------------BREAK AND CONTINUE STATEMENT---------------------------------------------------------------------#

break - Used to terminate a loop
continue - Used to skip a execution

1]. Use of break statement to print number upto 5
#! /bin/bash

for (( i=1 ; i<=10 ; i++ ))
do
     if [ $i -gt 5 ]
     then
           break
     fi
     echo "$i"
done

2]. Use of continue statement to skip 3 or 5.
#! /bin/bash

for (( i=1 ; i<=10 ; i++ ))
do
     if [ $i -eq 3 -o $i -eq 6 ]
     then
           continue
     fi
     echo "$i"
done


#-------------------------------------------------------FUNCTIONS---------------------------------------------------------------------------------------------#


Syntax of using Function by declaring it in 2 ways.
After declaring the Function it must be called also
Multiple arguments can be passed and called in a function

1]. Use of Function in 2 ways
#!/bin/bash
function name(){
	echo "Hello"
}

name () {
     exit
}

Hello
quit

2]. Using Arguments in Function
#!/bin/bash
function print(){
	echo $1
}

quit () {
     exit
}

print Hello
print World
print Again
quit

#!/bin/bash
function print(){
	echo $1 $2 $3
}

quit () {
     exit
}

print Hello World Again
quit

#----------------------------------------------------------LOCAL VARIABLE----------------------------------------------------------------------------------#

By default every variable declared in the script is a global variable and can be accessed from anywhere in the script
local - This keyword can be used to declare variables as local

1]. Example for global variable
#!/bin/bash

function print(){
	name=$1
	echo "The name is $name"
}
name="Tom"
echo "The name is $name"
print Max
 
2]. Example for local variable
#!/bin/bash

function print(){
	local name=$1
	echo "The name is $name"
}
name="Tom"
echo "The name is $name"
print Max

#-----------------------------------------------------FUNCTION EXAMPLE----------------------------------------------------------------------------------#

[[ -f  "$file" ]] - Check if a file exist or not
[[ -f  "$file" ]] && return 0 || return 1 - checks if the 1st condition in bracket is true or false. If false then return 0 after the && is executed. If true then return 1 is executed.
$0 - Is the script name
[[ $# -eq 0 ]] - Gives the number of argument
[[ $# -eq 0 ]] && usage - Checks if no.of argument passed is 0. If true then usage function is run

#!/bin/bash

usage() {
      echo "You need to provide an argument : "
      echo "usage : $0 file_name"
}

is_file_exist() {
      local file="$1"
      [[ -f  "$file" ]] && return 0 || return 1
}

[[ $# -eq 0 ]] && usage

if (( is_file_exist "$1" ))
then
       echo "File found"
else
       echo "File not found"
fi

#-----------------------------------------------------READONLY COMMAND#--------------------------------------------------------------------------------#


readonly - This command is used to make the variable readonly and not executable
readonly -f - This command is used to make the function readonly

1]. Use of readonly command
#!/bin/bash

var=31
readonly var
var=50
echo "var => $var"

hello() {
     echo "Hello world"
}

readonly -f hello

#----------------------------------------------------SIGNALS & TRAPS-------------------------------------------------------------------------------------#


$$ - Gives the PID of the script itself
CTRL+C - Is called the Interupt signal and in signal term its called SIGINT
CTRL+Z - Is called suspend signal and in signal term its called SIGTSTP
$ kill -9 4232 - Killing a PID manually, also called SIGKILL
$ man 7 signal - Command shows all signal information
trap - When this command is used the execution of script is not interupted by CTRL+C or CTRL+Z
SIGKILL and SIGSTOP signal cannot be traped or caught using trap command

1]. Use of trap command to catch SIGINT signal
#!/bin/bash
trap "echo Exit signal is detected" SIGINT

echo "pid is $$"
while (( COUNT < 10 ))
do
     sleep 10
     (( COUNT ++ ))
     echo $COUNT
done
exit 0

0 - Sucess or exit signal
2 - SIGINT signal
15 - SIGTERM signal
9 - SIGKILL signal

2]. Program to delete a file when a signal is detected ( ex: $kill -15 <PID> )
#!/bin/bash
file=/home0/u114080/file.txt
trap "rm -f $file && echo file deleted exit" 0 2 15

echo "pid is $$"
while (( COUNT < 10 ))
do
     sleep 10
     (( COUNT ++ ))
     echo $COUNT
done
exit 0
#-----------------------------------------------DEBUG BASH SCRIPT--------------------------------------------------------------------------------------------#

$ bash -x ./test.sh - If the below is to be run in debug mode then use "bash -x" before the script while running
-x = Can be used inside the script to run in debug mode after "#!/bin/bash"
set -x - This can also be used to debug

1]. Use of -x to debug
#!/bin/bash -x
file=/home0/u114080/file.txt
trap "rm -f $file && echo file deleted exit" 0 2 15

echo "pid is $$"
while (( COUNT < 10 ))
do
     sleep 10
     (( COUNT ++ ))
     echo $COUNT
done
exit 0

2]. Use of set -x to debug
#!/bin/bash
set -x

file=/home0/u114080/file.txt
trap "rm -f $file && echo file deleted exit" 0 2 15

set -x
echo "pid is $$"
while (( COUNT < 10 ))
do
     sleep 10
     (( COUNT ++ ))
     echo $COUNT
done
exit 0
