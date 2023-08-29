#!/bin/bash

# using if-else conditional branching

number=100

# conditional evaluation
# in the if statements the spaces are a must
# here the -eq means equal, there are more such conditions
if [ $number -eq 200 ]
then
    echo "The number is equal to 200"
else 
    echo "The number is not equal to 200"
fi

# to check the negation, (negate the output of the condition)
# you can add a ! or use the -ne
if [ ! $number -eq 200 ]
then
    echo "The number is equal to 200"
else 
    echo "The number is not equal to 200"
fi

# to check whether if a file exists or not
# the following can be used

# the -f option, we don't need to specify the
# -eq or any other operator
if [ -f ./text.txt ]
then
    echo "The file exists"
else 
    echo "The file does not exists"
fi

# to check for a direcotry you can use the -d
if [ -f ./text ]
then
    echo "The directory exists"
else 
    echo "The directory does not exists"
fi

# to check whether a command exists or not and installing it using a script
program=top

if [ -f  /usr/bin/$program ]
then
    echo "The command exists, and running the command"
else 
    echo "The command doesn't exists installing the command"
    sudo apt update && sudo apt install -y $program
fi

# you can run the command like this, uncomment the line
# /usr/bin/$program

# another way of doing the same thing
# you can use a command called command to call linux commands from the shell scripts
program=top

# this command is a command called the test command
# this is the command that is being executed for testing
# conditions that [ ] behind the scenes translates to this test command
# for more information about the test command use the man pages

if command -v $program 
then
    echo "The command exists, and running the command"
else 
    echo "The command doesn't exists installing the command"
    sudo apt update && sudo apt install -y $program
fi

$program