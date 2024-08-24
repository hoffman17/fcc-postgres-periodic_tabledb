#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

USER_INPUT=$1

if [[ -z $USER_INPUT ]]
then
  echo Please provide an element as an argument.
else
  if [[ $USER_INPUT =~ ^[0-9]+$ ]]
  then
    ELEMENT_RESULT=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, types.*, elements.*  from properties INNER JOIN types ON properties.type_id = types.type_id INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.atomic_number = $USER_INPUT")
    
    echo "$ELEMENT_RESULT" | while IFS="|" read ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID TYPE ATOMIC_NUMBER SYMBOL ELEMENT_NAME
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done

  # user input is a one or two letter string
  elif [[ $USER_INPUT =~ ^.{1,2}$ ]]
  then
    # get element by symbol
    SYMBOL_RESULT=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, types.*, elements.*  from properties INNER JOIN types ON properties.type_id = types.type_id INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.symbol = '$USER_INPUT'")
    
    # if no element found by symbol
    if [[ -z $SYMBOL_RESULT ]]
    then
      echo I could not find that element in the database.
    else
      # display result
      echo "$SYMBOL_RESULT" | while IFS="|" read ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID TYPE ATOMIC_NUMBER SYMBOL ELEMENT_NAME
      do
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi

  # user input is a string
  elif [[ $USER_INPUT =~ [a-z]$ ]]
  then
    # get element by name
    NAME_RESULT=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, types.*, elements.*  from properties INNER JOIN types ON properties.type_id = types.type_id INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.name = '$USER_INPUT'")

    # if no element found by name
    if [[ -z $NAME_RESULT ]]
    then
      echo I could not find that element in the database.
    else
      #display result
      echo "$NAME_RESULT" | while IFS="|" read ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID TYPE ATOMIC_NUMBER SYMBOL ELEMENT_NAME
      do
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done

    fi
  fi
fi
