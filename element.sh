#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if not arg
if [[ -z $1 ]]
then
  # echo to provide an argument
  echo Please provide an element as an argument.
# if arg
else
  # if number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # get element_id with arg's number
    ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
    #if not found
    if [[ -z $ELEMENT_ID ]]
    then
      # echo that it is not found
      echo "I could not find that element in the database."
      exit
    fi
  else
    # get element_id with query on symbol
    ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1';")
    # if not found    
    if [[ -z $ELEMENT_ID ]]
    then
      # get element_id with query on name
      ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1';")   
      # if not found    
      if [[ -z $ELEMENT_ID ]]
        then
        # echo that it is not found
        echo "I could not find that element in the database."
        exit
      fi
    fi
  fi

  # get infos from element and properties with query
  ELEMENT_INFOS=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$ELEMENT_ID")
  echo "$ELEMENT_INFOS" | if IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MPC BPC TYPE
  then
    # echo result
     echo "The element with atomic number $ELEMENT_ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    # Last argument :  : The result of the test is OK !!!!!
  fi
fi