oi-arbiter
==========
*An algorithm contest judge tool*

          oi-arbiter-script Copyright (C) 2013 Gestalt Lur

          This program comes with ABSOLUTELY NO WARRANTY;

          This is free software, and you are welcome to redistribute it

          under certain conditions;'

FEATURE
-------
          auto detect input and standard answer file( default same with 
          
          source code
          
          name, if it doesn't exist, use input*.in and output*.out, and 
          
          case insensitive)
          
DESCRIPTION
-----------
          use to judge problem (unoffically) for the algorithm contest which 
          
          compete in Olympic Informatics rules
          
          ( just like : http://www.ioi2012.org/competition/rules/

          could only compile single .c/cpp/pas/( if gcc/g++/fpc exist ) 
          
          source code file and compare it's output with 
          
          file in <standard_output_path>

          test case should be something like:
                  
                  <name><number>.in|out|ans 
                  
                  ( case insensitive, input file end up with
          
          suffix 'in' while standard is 'out' or 'ans' )
          
USAGE
-----
         ./arbiter_script.sh <*.c/*.cpp/*.pas> <input_test_path> <standard_output_path>
         
         ./arbiter_script.sh <*.c/*.cpp/*.pas> <test_case_path>

EXAMPLE
-------
          ./arbiter_script.sh source/code/path/source_code input/path/ std/path
          ./arbiter_script.sh source/code/path/source_code.cpp test/case/path/
