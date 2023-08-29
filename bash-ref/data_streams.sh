#!/bin/bash

# data streams => STDIN, STDOUT, and STDERROR

# stream id 0 stands for STDIN
# stream id 1 stands for STDOUT
# stream id 2 stands for STDERROR

# using standards input to read input

echo "Please enter your name: "
read username
echo "Hello, $username"

# redirecting output

# to get all the errors except the details, when running a command
# to redirect > , to append the redirected output to a file use >>

# find all the files in the /etc directory and log the errors occurred file running this command
find /etc -type f 1> ./content_log.txt 2> ./error_log.txt