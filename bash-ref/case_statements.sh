#!/bin/bash

# basic syntax

#   case EXPRESSION in
#   PATTERN)
#       STATEMENTS
#   ;;
#   PATTERN)
#       STATEMENTS
#   ;;
#   PATTERN)
#       STATEMENTS
#   ;;
#   *)
#       STATEMENTS
#   ;;
# esac

# the PATTERN here could be regular expressions as well
# the last pattern is a catch all pattern
# if no PATTERN is matched in the case statement
#   status 0 is returned otherwise, the return status
#   is the exist_status of the executed commands

echo "Enter your name: "

read username

case $username in
bob)
    echo "You are the admin of this system"
;;
jane)
    echo "You are a general user of this system"
;;
batman)
    echo "I am Batman"
;;
*)
    echo "Such a user don't exist"
;;
esac