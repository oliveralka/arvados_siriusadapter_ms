#!/bin/bash

# split sirius internal .ms file after n compound entries
# first argument = file 
# second argument = number of compounds counted for split

echo "$1"
echo "$2"

awk '/>compound/ { delim++ } { file = sprintf("%s.ms", int(delim / '$2')); print >> file; }' $1 
