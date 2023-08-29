#!/bin/bash

# createing functions

# single line version
#       function_name () {commands;}

# multi-line version
#       function_name () {
#           commands
#       }

# using the function keyword to create functions

# single line version
#       function function_name { commands; }

# multi line version
#       function function_name {
#           commands
#       }

# in bash all variables, by default are defined as global even if they are declared inside of a function

# to declare local variables inside of a function boby
# the local keyword can be used 

# examples

hello_world_multi_line () {
    echo "Hello, World" # this could be something like this as well => echo "Hello, World";
}

# calling the function =>
hello_world_multi_line

hello_world_single_line () { echo "Hello, World"; }

hello_world_single_line

# variable scopes
var_1=0
var_2=1
var_3='T' # this is a character

function scopes {
    local var_local='C'
    
    # this will change the var_2 global variable
    var_2='D' # data types don't matter
    echo "var_local is a local variable: $var_local" 
}

echo "var_2 before the function call: $var_2"
scopes
echo "var_2 after the function call: $var_2"

# returning values form functions

# Unlike functions in “real” programming languages,
# Bash functions don’t allow you to return a value when called.
# When a bash function completes, its return value is the status of the
# last statement executed in the function, 0 for success and non-zero
# decimal number in the 1 - 255 range for failure.

# The return status can be specified by using the return keyword,
# and it is assigned to the variable $?. The return statement terminates the
# function. You can think of it as the function’s exit status .

function test_return {
    echo "Some result"
    return 0 # this will set the exit code of the function and will terminate the function
}

test_return
echo "This is the return code of the test_return function : $?"

# to actually return a value from a function you can do the following

function return_value_method_1 {
    result=100000
}

return_value_method_1
echo "This is what the return_value_method_1 function returned: $result" 

# another method to return values from functions
# is Another, better option to return a value from a
# function is to send the value to stdout using echo
# or printf like shown below:

function return_value_method_2 {
    local function_result="Some result: 100"
    echo "$function_result"
}

echo "This is what the return_value_method_2 function returned: $(return_value_method_2)"

# passing arguments to functions
# To pass any number of argumentsto the bash function
# simply put them right after the function’s name,
# separated by a space. It is a good practice to double-quote
# the arguments to avoid the misparsing of an argument with
# spaces in it.

# The passed parameters are $1, $2, $3 … $n, corresponding
# to the position of the parameter after the function’s name.

# The $0 variable is reserved for the function’s name.

# The $# variable holds the number of positional parameters/arguments
# passed to the function.

# The $* and $@ variables hold all positional parameters/arguments
# passed to the function.

#       When double-quoted, "$*" expands to a single string separated
#       by space (the first character of IFS) - "$1 $2 $n".

#       When double-quoted, "$@" expands to separate strings - "$1" "$2" "$n".

#       When not double-quoted, $* and $@ are the same

# exmaples

function testing_parameters {
    echo "first parameter passed: $1"
    echo "second parameter passed: $2"
    echo "number of parameter passed: $#"
    echo "getting all the parameters at once using the *: $*"
    echo "getting all the parameters at once using the @: $@"
}

testing_parameters 10 20 30 40 "hello" 'A'

