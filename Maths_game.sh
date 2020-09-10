#!/bin/bash     #<<<<  This is known as the Bash Shebang and tells  


# Arithmatic Game 
#

########## Initialize global variables

# Assignment not equality

NUMBER=0
NUMBER1=0
NUMBER2=0
CORRECT_ANSWER=0
ANSWER=0
CORRECT=0
MAX_TRIES=3

########## Write Functions

# FUNCTION NAME (VARIABLES) {ACTION}

function generate_question(){
    generate_numbers                                    # Run generate numbers
    determine_operation                                 # determin the operation, plus, multiple etc
    QUESTION="$NUMBER1 $OPERATION $NUMBER2"             # Create a question
}

function generate_numbers(){
    generate_number                                     # Generate 1st number
    NUMBER1=$NUMBER                                     # assign the first number to a variable called NUMBER1
    generate_number                                     # Generate a 2nd  number
    NUMBER2=$NUMBER                                     # assign the 2nd number to a variable called NUMBER2
}

function generate_number(){                             # generates the first random number from the internal random number generator
    NUMBER=$((RANDOM%10+1))                     
}

function determine_operation(){                         # generates a random number out of 3 and uses it to choose a operand
    RAND=$((RANDOM%3))
    case $RAND in 
        1) OPERATION='*';;
        2) OPERATION='+';;
        3) OPERATION='-';;
    esac
}

function calculate_answer(){                           
    CORRECT_ANSWER="$(echo "$QUESTION" | bc )"
}

function check_answer(){
    if [ $ANSWER -eq $CORRECT_ANSWER 2>/dev/null ] ; then
        echo "Correct!"
        CORRECT=1
        if [ $TRY -ne 1 ] ; then
            write_to_the_log
        fi 
    
    else
        
        if [ $TRY -eq $MAX_TRIES ]; then
            TRY=$(($MAX_TRIES + 1))
            write_to_the_log
            echo ----------------------------------------
            echo "The correct answer was $CORRECT_ANSWER"
            echo "Let's try the next one (press the ENTER button)"
            read
        else
            TRY=$(($TRY +1))
            echo "Please try again... ( Attempt: $TRY )"
        fi
    fi        
}

function init_log(){
    echo "---------- Log for $(date +%d-%m-%Y'  '%H:%M)" >> Arithmatic-Game-logfile.txt
}

function write_to_the_log(){
    if [ $TRY -le $MAX_TRIES ]; then
        echo "Answer to $QUESTION ($CORRECT_ANSWER) given in $TRY tries" >> Arithmatic-Game-logfile.txt
    else
        echo "Answer to $QUESTION ($CORRECT_ANSWER) not given" >> Arithmatic-Game-logfile.txt
    fi
}

########## Put it all together

init_log

while true
do 
    CORRECT=0
    TRY=1
    
    generate_question
    calculate_answer
    
    echo "How much is $QUESTION ? ( attempt $TRY)"
    while [ $CORRECT -ne 1 ] && [ $TRY -le $MAX_TRIES ]
    do 
        read ANSWER
        check_answer
    done
done
exit 0
