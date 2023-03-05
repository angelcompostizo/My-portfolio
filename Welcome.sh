#!/bin/bash

echo "Welcome to Ubuntu Systems, We gonna have great time "
read -p "Please Tell me your name :3 " name

greeting[0]="Hello how are you?"
greeting[1]="Greetings"
greeting[2]="How are you doing?"
greeting[3]="Hey there,having fun?"
greeting[4]="Are you enjoy Terminal?"

size=${#greeting[@]}
index=$(($RANDOM % $size))

echo ${greeting[$index]} $name




