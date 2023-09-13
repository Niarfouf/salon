#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -c"

# Bonjour et annonce du salon
echo -e "\n~~~~~ Welmcome to my Salon ~~~~~\n"
# liste services 1) service 2) service etc avec id a la place du chiffre
MAIN_MENU() {
  echo What service do you need?
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
# input avec choix du service $SERVICE_ID_SELECTED
read SERVICE_ID_SELECTED
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
if [[ ! $SERVICE_ID_SELECTED =~ [1-3] ]]
# si mauvais choix liste à nouveau
then 
  MAIN_MENU
else 
  # input téléphone $CUSTOMER_PHONE
  echo "What is your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # si pas client input nom $CUSTOMER_NAME et ajout client $CUSTOMER_PHONE + $CUSTOMER_NAME
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
  # input heure de RDV $SERVICE_TIME
  echo -e "\nWhat time do you want your appointment?"
  read SERVICE_TIME
  # ajout dans appointments avec customer_id, service_id, time si deja client ou pas client
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  # après ajout output message : I have put you down for a <service> at <time>, <name>.
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
}
MAIN_MENU