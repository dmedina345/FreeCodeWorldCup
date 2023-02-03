#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#read file
TRUNCATE=$($PSQL "TRUNCATE TABLE games")
echo $TRUNCATE
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#ignore first line
if [[ $YEAR = 'year' ]]
then
echo First Line
else
#check if team already inserted
TEAM_ID1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
#if not insert
if [[ -z $TEAM_ID1 ]]
then
TEAMR=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
TEAM_ID1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
echo $TEAMR
fi
if [[ -z $TEAM_ID2 ]]
then
TEAMR=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
echo $TEAMR 2
fi
#insert games
GAMESR=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $TEAM_ID1, $TEAM_ID2, $WINNER_GOALS, $OPPONENT_GOALS)")
echo $GAMESR
fi
done
