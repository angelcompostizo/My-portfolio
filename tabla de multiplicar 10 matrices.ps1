#tenemos que pintar las tablas asi que tenemos que controlar las filas y las columnas mostradas
#necesitaremos una variable para las filas y columnas y almacenarlos en una matriz vacia (array)
#Se puede crear una matriz vacía mediante el cmdlet @().
#despues de tener el indice de la columna de la matriz necesitaremos otro bucle para pasarle datos de columna
#despues añadirle los valores al array de la matriz 
#por ultimo tenemos que mostrar el array en forma de tabla uniendo valores en el array matriz con -Join 
#Nota: el operador (+=)	Aumenta el valor de una variable por el valor especificado, siendo util en este caso ya que manejamos arrays y  debemos pasarle las posiciones.
#Nota2: como es hasta el valor 10, las filas y las columnas tendran bucles for por valor maximo menor o igual a 10.
#Nota3 el uso de -Join "`t" es para mostrarlo tabulado (tabulado horizontal), es un caracter especial de powershell.



for ($fila = 1; $fila -le 10; $fila++) {

$matriz=@()

for($columna =1;$columna -le 10;$columna++) {

$matriz += $fila * $columna
}

 $matriz -join "`t"


}
