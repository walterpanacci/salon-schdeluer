#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
MAIN_MENU () {
SERVICES=$($PSQL "SELECT * FROM services");
echo -e "\nHere are the services we offer:"
echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
    do
      echo "$SERVICE_ID) $SERVICE"
    done
    echo -e "\nWhich one would you like to pick?"
read SERVICE_ID_SELECTED

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then
      MAIN_MENU
fi
CHOOSEN_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $CHOOSEN_SERVICE ]]
then 
MAIN_MENU
else SERVICE_MENU $SERVICE_ID_SELECTED

fi

}

SERVICE_MENU () {
echo "Service Choosen: $1"
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$1")
echo -e "\nPlease enter your phone number"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
then 
echo -e "Please enter your name"
read CUSTOMER_NAME
CUSTOMER_INSERTED_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
fi
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
echo -e "\nPlease enter the service time"
read SERVICE_TIME
echo $CUSTOMER_ID
APPOINTMENT_INSERTED_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $1, '$SERVICE_TIME')")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
