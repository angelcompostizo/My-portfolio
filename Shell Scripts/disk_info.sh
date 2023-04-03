#!/bin/bash

# Muestra info de discos del sistema
echo "Disk information:"
df -h

# Mira cual es el FS mas ocupado
most_used_fs=$(df -h | awk '{if($5 ~ /%/) print $0}' | sort -n -r -k 5 | head -n 1 | awk '{print $NF}')

# Muestra el FS mas ocupado
echo "The most used file system is: $most_used_fs"

# determina el espacio de almacenamiento para el FS mas lleno
storage_left=$(df -h | grep $most_used_fs | awk '{print $4}')

# muestra el espacio disponible de almacenamiento para el fs mas lleno
echo "Available storage space for $most_used_fs: $storage_left"

# Pregunta al usuario si desea borrar archivos para liberar espacio o montar mas espacio en el fs mas lleno.
read -p "Do you want to delete files to free up space, or mount more space in $most_used_fs? [delete/mount/exit]: " answer

if [ "$answer" == "delete" ]; then
  # Pide al usuario el path de el archivo o el directorio que quiere borrar
  read -p "Enter the path of the file or directory to delete: " $path_to_delete
  
  # Borra archivos del directorio
  sudo rm -rf $path_to_delete
  echo "$path_to_delete has been deleted."
elif [ "$answer" == "mount" ]; then
  # Pide al usuario el directorio en que montar nuevo espacio
  read -p "Enter the path to mount the new space: " $path_to_mount
  
  # Pide al usuario el tamaño del nuevo fs a montar
  read -p "Enter the size of the new space (e.g. 1G): " $size_of_space
  
  # Monta el nuevo FS en el espacio indicado
  sudo mount -t tmpfs -o size=$size_of_space tmpfs $path_to_mount
  echo "New space has been mounted at $path_to_mount."
else
  echo "No changes have been made."
fi
