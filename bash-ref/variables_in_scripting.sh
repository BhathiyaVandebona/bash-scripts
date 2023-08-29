#!/bin/bash

# USUALLY UPPERCASE VARIABLE NAMES ARE DISCOURAGED
# THERE ARE USUALLY USED FOR ENV VARIABLES

# Variables are declared as follows
# (no spaces)

name="Bobby"

# To access the vaiable use the $var_name => $ sign
echo $name

# inside of the double quotes the shell will automatically
# expand the variables to their values but not inside of
# the single quotes
echo "Your name is: $name"

# this dollor can also be used to avoid name collisions
#
# say you have a variable named ls, same as the ls command
ls="This is the ls command"

# but when called to the ls
echo "This folder contains: "; ls ./  # this will execute the ls command not the $ls

# to get the variable value we have to use the $ sign
echo "This is the ls vaiable value $ls"

# capturing the output of a command
# this method of capturing the output => $() => is called the subshell method
# meaning the given command inside of the $(_command_) is run in the background
# and the output will be stored in the given variable

files_in_the_current_folder=$(ls ./) # this will capture the output of the ls command
                                    # and will store it in the  variable mentioned
echo  "This folder contains: $files_in_the_current_folder"

# the date command can be used to get the current time and date
# using subshell inside of a string
echo "This is the current data and time :$(date)"
