#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

MENU(){
SERVICES=$($PSQL "select service_id, name from services")

  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED
  SELECTION=$($PSQL"select service_id from services where service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SELECTION ]]
  then
    echo -e "\nI could not find that service. What would you like today?"
    MENU
    return
  fi

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  PHONE=$($PSQL"select phone from customers where phone='$CUSTOMER_PHONE'" | xargs)
  SERVICE=$($PSQL"select name from services where service_id =$SERVICE_ID_SELECTED" | xargs)
  if [[ -z $PHONE ]]
  then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?"
  read SERVICE_TIME

  NEWCUSTOMER=$($PSQL"insert into customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") > /dev/null

  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'" | xargs)
  NEW_APPOINTMENT=$($PSQL "insert into appointments(service_id, customer_id, time) values($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  exit 0
    else
    NAME=$($PSQL"select name from customers where phone='$CUSTOMER_PHONE'" | xargs)
    echo -e "\nWhat time would you like your $SERVICE, $NAME?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    ANOTHER_APPOINTMENT=$($PSQL "insert into appointments(service_id, customer_id, time) values('$SERVICE_ID_SELECTED', '$CUSTOMER_ID', '$SERVICE_TIME')") > /dev/null
    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $NAME."
    exit 0
  fi
}

MENU