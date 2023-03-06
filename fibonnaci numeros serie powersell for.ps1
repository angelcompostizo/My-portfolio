#La serie de fibonacci es aquella serie que empieza en 0 y 1 y su siguiente numero suma los 2 anteriores.
#Necesitamos un bucle primero para mostrar los 20 primeros números, así que hacemos un bucle for hasta 20
#luego aplicamos el numero de fibonnaci sumando los 2 números anteriores
#cambiamos los valores de los números al numero sumado y el anterior y los metemos en el bucle
#mostramos el numero en pantalla.

$num1= 0
$num2= 1



for ($int=1 ; $int -le 20; $int++) {

$fibonacci = $num1 + $num2
$num1 = $num2
$num2 = $fibonacci


$fibonacci

}

