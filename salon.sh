#!/bin/bash


PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~ Welcome to The Hair Salon ~~~\n"

MAIN_MENU () {
  
  echo "Which salon service are you looking to book?"
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED 

  case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINTMENT ;;
    2) MAKE_APPOINTMENT ;;
    3) MAKE_APPOINTMENT ;;
    *) MAIN_MENU "Please choose a service from the list" ;;
  esac
}

MAKE_APPOINTMENT () {
  # prompt phone number - CUSTOMER_PHONE
  echo -e "\nPlease enter your phone number."
  read CUSTOMER_PHONE
  CUSTOMER_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # if no number
  if [[ -z $CUSTOMER_NUMBER ]]
  then
      # a name if they are not already a customer - CUSTOMER_NAME
      echo -e "\nPlease enter your name."
      read CUSTOMER_NAME
      INSERT_PHONE_NAME=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi
      

# time - SERVICE_TIME
  echo -e "\nWhat time would you like to schedule the appointment for?"
  read SERVICE_TIME
  

  #get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a$CUSTOMER_SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
}


MAIN_MENU


