#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
}

echo "Welcom to my salon, how can I help you?"


#Do a loop while the selection is not one of the 5 services
while true; do
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in 
    1|2|3|4|5)
      break ;;
    *)
      echo -e "\nI could not find that service. What would you like today?" ;;
  esac
done

#get the service name
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
echo "You selected service number $SERVICE_ID_SELECTED: $SERVICE_NAME"

#Get customer info with phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

#check if customer exists
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

#if customer doesn't exist
if [[ -z $CUSTOMER_NAME ]]
then
  # get new customer name
  echo -e "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  # insert new customer
  INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone, name) 
          VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
fi

# get customer_id
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

echo "Welcome in My Salon $CUSTOMER_NAME, your customer ID is $CUSTOMER_ID, and your phone number is $CUSTOMER_PHONE"

#get the time of the appointment
echo -e "\nWhat time would you like your cut, '$CUSTOMER_NAME'"
read SERVICE_TIME

INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) 
          VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")

echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
