#!/bin/bash

# references => https://www.redhat.com/sysadmin/bash-scripting-loops

# looping

# while loops

loop_controller=0

 # can be rewritten as while [ $loop_controller -le 10 ];do as well
while [ $loop_controller -le 10 ]
do
    echo $loop_controller
    loop_controller=$(( $loop_controller + 1 )) # when reassigning don't use the $ sign for the variables
    sleep 0.5 # this will pause the loop for some time (number of seconds by default)
done

# can check any loop condition you want in the loop condition

# for loop 

# general syntax
# for <variable name> in <a list of items>;do <some command> $<variable name>;done;

# here the list of items can be anything that returns a space or newline-separated list.

# the {} can be used to mention ranges
# can be rewritten as for $var in {1..10};do  as well
for var in {1..10}
do
    echo $var
done

# looping through a list
for var in bob jane hanz miller firmino alisson brie 
do
    echo $var
done

# renaming files using a for loop
#           for i in $(ls *.pdf); do
#               mv $i $(basename $i .pdf)_$(date +%Y%m%d).pdf
#           done

# in this file renaming loop there is a command named 'basename' which 
# will give you the basename of the file => ex : /etc/shadow => basename => shadow

# combining interations (nested loop like thing but not exactly)
for i in {ca,us}-{0..3};do echo $i;done

# the output would look something like this => 
#   ca-0
#   ca-1
#   ca-2
#   ca-3
#   us-0
#   us-1
#   us-2
#   us-3
# this could be very useful in lots of file operations

# nesting loops => example of copying the files form the ssh client to the host
for i in file{1..3}
do
    for x in web{0..3}
    do
        echo "Copying $i to server $x"
        # scp $i $x # uncomment this in actual case
    done
done




