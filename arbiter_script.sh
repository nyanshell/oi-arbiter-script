#!/bin/bash
# Author : Gestalt Lur
# Version : 1
# TODO: * if not filename in testcase path, testcase name is xxx<number>.*
#         case insensitive
#       * strict compare
#       * memory limit
#       * time limit
# BUG: * multiple problem's data case in same file may cause error
if [ "$1" = "-h" ] || [ $# -lt 2 ]
then
    echo 'An algorithm contest judge tool'
    echo 'oi-arbiter-script Copyright (C) 2013 Gestalt Lur
          This program comes with ABSOLUTELY NO WARRANTY;
          This is free software, and you are welcome to redistribute it
          under certain conditions;'
    echo
    echo "
          FEATURE:
          auto detect input and standard answer file( default same with source code
          name, if it doesn't exist, use input*.in and output*.out, and case insensitive)
          DESCRIPTION:
          use to judge problem (unoffically) for the algorithm contest which 
          compete in Olympic Informatics rules
          ( just like : http://www.ioi2012.org/competition/rules/

          could only compile single .c/cpp/pas/( if gcc/g++/fpc exist ) 
          source code 
          file and compare it's output with file in <standard_output_path>

          test case should be something like:
                  <name><number>.in|out|ans ( case insensitive, input file end up with
          suffix 'in' while standard is 'out' or 'ans' )
          "
    echo 'USAGE:
         ./arbiter_script.sh <*.c/*.cpp/*.pas> <input_test_path> <standard_output_path>
         ./arbiter_script.sh <*.c/*.cpp/*.pas> <test_case_path>'
    echo
    echo "EXAMPLE:
          ./arbiter_script.sh source/code/path/source_code input/path/ std/path
          ./arbiter_script.sh source/code/path/source_code.cpp test/case/path/"
    exit 1
fi

#source code path & name
SOURCE_CODE=$1

if [ ! -f $SOURCE_CODE ]
then
    echo 'No such source code named' $SOURCE_CODE ', exit'
    exit 1
fi

SOURCE_CODE_NAME=$(ls $SOURCE_CODE | grep -P -o '[^/]+(?=\.(c|cpp|pas))')

#echo $SOURCE_CODE_NAME

INPUT_PATH=$2

if [ $# = 2 ]
then
    STDOUT_PATH=$2
else
    STDOUT_PATH=$3
fi

#find first testcase

REGEX_FIND_INPUT='('$SOURCE_CODE_NAME'|input)[[:digit:]]+\.in$'
REGEX_FIND_OUTPUT='('$SOURCE_CODE_NAME'|output|ans)[[:digit:]]+\.(ans|out)$'

i=0
INPUT_NAME=$(ls $INPUT_PATH*0.* 2>/dev/null | grep -E -i -m 1 $REGEX_FIND_INPUT )
OUTPUT_NAME=$(ls $STDOUT_PATH*0.* 2>/dev/null | grep -E -i -m 1 $REGEX_FIND_OUTPUT )

if [ ! $INPUT_NAME ]
then
    INPUT_NAME=$(ls $INPUT_PATH*1.* 2>/dev/null | grep -E -i -m 1 $REGEX_FIND_INPUT )
    i=1
fi

if [ ! $OUTPUT_NAME ]
then
    OUTPUT_NAME=$(ls $STDOUT_PATH*1.* 2>/dev/null | grep -E -i -m 1 $REGEX_FIND_OUTPUT )
    i=1
fi

echo $INPUT_NAME $OUTPUT_NAME

if [ ! $INPUT_NAME ] || [ ! $OUTPUT_NAME ]
then
    echo 'No input test case, exit'
    exit 1
fi

#compile source code and generate executable file
SOURCE_SUFFIX=$(ls $SOURCE_CODE | grep -E -o '(c|cpp|pas)$') 
PROG=$SOURCE_CODE_NAME$RANDOM

if [ $SOURCE_SUFFIX = "cpp" ]
then
    g++ -g $1 -o $PROG
elif [ $SOURCE_SUFFIX = "c" ]
then
    gcc -g $1 -o $PROG
elif [ $SOURCE_SUFFIX = "pas" ]
then
    fpc -g $1 # PASCAL compiler generate file same with it name
else
    echo "Cannot recognize source code, exit"
    exit 1
fi

# compare file
echo 'start comparing...'
while [ true ]
do
    echo 'comparing test case ' $i '...'
    TEMP_OUTPUT='/tmp/tmp.'$RANDOM'.out'

    ./$PROG < $INPUT_NAME > $TEMP_OUTPUT
    diff $TEMP_OUTPUT $OUTPUT_NAME

    rm $TEMP_OUTPUT
    
    i=$(($i+1))
    INPUT_NAME=$(ls $INPUT_PATH*$i.* 2>/dev/null | grep -E -i -m 1 $REGEX_FIND_INPUT )
    OUTPUT_NAME=$(ls $STDOUT_PATH*$i.* 2>/dev/null | grep -E -i -m 1 $REGEX_FIND_OUTPUT )
    if [ ! $INPUT_NAME ] || [ ! $OUTPUT_NAME ]
    then
        break
    fi
done

rm $PROG
echo 'done!'

exit 0