#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
# easy thing might be to just make a copy of this. think about DRYness later
  if [[ $opponent != "opponent" ]]; then
  # get major_id
    opponent_id=$($PSQL "SELECT name FROM teams WHERE name='$opponent'")

    # if not found
    if [[ -z $opponent_id ]]
    then
      # insert major
      insert_opponent_result=$($PSQL "INSERT INTO teams(name) VALUES('$opponent');")
      if [[ $insert_opponent_result == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $opponent
      fi

    fi
  fi

  if [[ $winner != "winner" ]]; then
  # get major_id
    winner_id=$($PSQL "SELECT name FROM teams WHERE name='$winner'")

    # if not found
    if [[ -z $winner_id ]]
    then
      # insert major
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$winner');")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $winner
      fi
      
    fi
  fi

done


cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do

  if [[ $opponent != "opponent" ]]; then

  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")

  # insert student
  # year round winner opponent winner_goals opponent_goals
  insert_game=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($year, '$round', $winner_goals, $opponent_goals, $winner_id, $opponent_id)")
    if [[ $insert_game == "INSERT 0 1" ]]
    then
      echo Inserted into games, $year
    fi

  fi
done