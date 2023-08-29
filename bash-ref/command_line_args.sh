#!/bin/bash

# just like in function we can use the $1 ... $n 
# variables to get arguments passed to the script

# with this you can provide conditional branching for your scripts
# based on the arguments that the user provided you can execute
# different blocks of codes

# incase if the users don't provide any arguments this will still exceute but $1 will be nothing
# to prevent the users from doing this, check the number of arguements

if [ $# -ne 1 ]
then
    echo "Please enter an argument and try again" 

    echo "Usage: ./script_name arg_1 arg_2"
    exit 1 # provide a non-zero exit code since the user messed up
fi


echo "This is the first argument that you entered: $1"