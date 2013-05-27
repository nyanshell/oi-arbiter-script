#!/bin/bash
# Author : Gestalt Lur
# Version : 1
# *.c *.cpp *.pas
# ./arbiter_script.sh <source_code> <testcase_input_path> <test_answer_output_path>
# ./arbiter script.sh <source_code> <testcase_input_and_answer_path> 
# $1 $2 $3
# usage example:
#       aribiter_script.sh ./input ./output
# TODO: if not filename in testcase path, testcase name is input.* & output.out
#       case insensitive
if [ "$1" = "-h" ] || [ $# -lt 2 ]
then
    echo 'show the help usage of this script'
    exit 1
fi

#source code path & name
SOURCE_CODE=$1
if [ -f $SOURCE_CODE ]
then
    echo 'No such input source code'
    exit 1
fi

#source code name
SOURCE_CODE_NAME=$(ls $SOURCE_CODE | grep -P -o '.+(?=\.(c|cpp|pas))')

INPUT_FILE=$2

if [ $# = 2 ]
then
    ANS_FILE=$2
else
    ANS_FILE=$3
fi

#check if test case number start from 0
$i=0
POSSIBLE_FILENAME=$($INPUT_FILE$i.*)

for $FILE in $POSSIBLE_FILENAME
do
    test -r $FILE && FOUND_INPUT=true && break
done

#test case number start from 1
if [ !$FOUND_INPUT = false ]
then
    i=$(($i+1))
    POSSIBLE_FILENAME=$($INPUT_FILE$i.*)
    for $FILE in $POSSIBLE_FILENAME
    do
        test -r $FILE && FOUND_INPUT=true && break
    done
fi

if [ !$FOUND_INPUT = false ]
then
    echo 'No input test case, exit'
    exit 1
fi

#compile source code
SOURCE_SUFFIX=$(ls $SOURCE_CODE_NAME | grep -E -o '(c|cpp|pas)') 

if [ $SOURCE_SUFFIX = "cpp" ]
then
    g++ -g $1 -o $PROG_NAME
elif [ $SOURCE_SUFFIX = "c" ]
    gcc -g $1 -o $PROG_NAME
elif [ $SOURCE_SUFFIX = "pas" ]
    fpc -g $1 # PASCAL compiler generate file same with it name
else
    echo "Cannot recognize source code, exit"
    exit 0
fi

# compare file
while [ -r $INPUT_FILE$i ]
do
    $PROG_NAME < $INPUT_FILE$i > /tmp/$TEMP_OUT
    diff /tmp/$TEMP_OUT $ANS_FILE$i
    i=$(($i+1))
done

rm $TEMP_OUT $FILE_NAME

exit 0