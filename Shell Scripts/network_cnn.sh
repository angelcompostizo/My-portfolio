#!/bin/bash

# pie al usuario buscar el puerto
read -p "Introduzca el puerto a buscar: " $port_number

# muestra las conexiones del puerto
echo "conexiones usando el puerto: $port_number:"
sudo lsof -i :$port_number

# le pide al usuario si desea matar el proceso usando el puerto
read -p "Deseas matar el proceso que esta usando ese puerto? [y/n]: " answer

if [ "$answer" == "y" ]; then

  # le pide al usuario el PID del proceso a matar
  read -p "Teclea el Process ID que desea finalizar: " process_id
  
  # mata el proceso
  sudo kill $process_id
  echo "El proceso $process_id ha sido finalizado."
else
  echo "No se ha matado ningun proceso"
fi
