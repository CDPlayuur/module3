#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate games, teams restart identity")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
      if [[ -z $WINNER_ID ]]
      then
        INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values ('$WINNER')")
      fi
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
      if [[ -z $OPPONENT_ID ]]
      then
        INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values ('$OPPONENT')")
      fi

      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

      INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo "Succesfully inserted game: $WINNER vs $OPPONENT"
      fi 
  fi
done



    # TEAM=$($PSQL "select name from teams where name='$TEAM'")
    # if [[ -z $WINNER ]]
    # then
    #   INSERT_TEAM=$($PSQL "insert into teams(name) values ($WINNER)")
    #   INSERT_TEAM=$($PSQL "insert into teams(name) values ($OPPONENT)")
    #     if [[ $INSERT_TEAM_ID == "Insert 0 1" ]]
    #     then
    #       echo Successfully inserted into team: $TEAM
    #     fi
    # fi