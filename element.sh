#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius 
    FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id)
    WHERE atomic_number=$1")
    if [[ -z $ELEMENT ]]
    then
      echo "I could not find that element in the database."
    else
      echo $ELEMENT | while IFS="|" read NUMBER ELEMENT SYMBOL ISMETAL MASS MELTING BOILING
      do
        echo "The element with atomic number $NUMBER is $ELEMENT ($SYMBOL). It's a $ISMETAL, with a mass of $MASS amu. $ELEMENT has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  else
    # if the argument is a symbol
    if [[ $1 =~ ^[A-Z]$ || $1 =~ ^[A-Z][a-z]$ ]]
    then
      ELEMENT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius 
      FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id)
      WHERE symbol='$1'")
      echo $ELEMENT | while IFS="|" read NUMBER ELEMENT SYMBOL ISMETAL MASS MELTING BOILING
      do
        echo "The element with atomic number $NUMBER is $ELEMENT ($SYMBOL). It's a $ISMETAL, with a mass of $MASS amu. $ELEMENT has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    else
      if [[ $1 ]]
      then
        ELEMENT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius 
        FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id)
        WHERE name='$1'")
        if [[ ! -z $ELEMENT ]]
        then
          echo $ELEMENT | while IFS="|" read NUMBER ELEMENT SYMBOL ISMETAL MASS MELTING BOILING
          do
            echo "The element with atomic number $NUMBER is $ELEMENT ($SYMBOL). It's a $ISMETAL, with a mass of $MASS amu. $ELEMENT has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
          done
        else
          echo "I could not find that element in the database."
        fi
      fi
    fi
  fi
fi
