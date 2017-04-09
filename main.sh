DIR=$PWD/PETC
AUT=0
INF=1

while getopts d:siIA option
do
        case "${option}"
        in
                d) DIR=${OPTARG};;
                s) INF=0;;
		i) INF=1;;
                I) INF=2;;
                A) AUT=1
		   INF=0
		;;
        esac
done

read -p "Se escribiran las series temporales en $DIR. Introduzca s para continuar." resp
if [ "$resp" != "s" ]
then
	printf "Ejecucion cancelada. \n"
	exit
fi

# Comprobacion directorio
if [ -d $DIR ]
then
	read -p "El directorio especificado ( $DIR ) ya existe. Espere errores si no lo borra: Si alguna serie se comenzo a escribir se seguira escribiendo en ella. ¿Quiere borrarlo? (s/n) (cualquier otro para cancelar)." resp
	case $resp in
    		s|S )
        		printf "Se ha borrado $DIR. \n"
			rm -r $DIR
			mkdir $DIR
    		;;
    		n|N )
        		printf "Se sobreescribira en $DIR. \n"
    		;;
		*)
			printf "Ejecucion cancelada. \n"
			exit
		;;
	esac
else
	mkdir $DIR
fi

# Comprobacion directorio temp
if [ -d temp ]
then
        read -p "El directorio temp ya existe, posiblemente de una ejecucion anterior. Espere errores si no lo borra.  ¿Quiere borrarlo? (s/n) (cualquier otro para cancelar) " resp
        case $resp in
                s|S )
                        printf "Se ha borrado temp. \n"
                        rm -r temp
                        mkdir temp
                ;;
                n|N )
                        printf "Se sobreescribira en temp. \n"
                ;;
                *)
                        printf "Ejecucion cancelada. \n"
			exit
		;;
        esac
else
        mkdir temp
fi


if [ $INF == 1 ] || [ $INF == 2 ]
then
	printf "Descargando archivos... \n"
fi
bash gen_urls.sh
bash descarga_zips.sh

if [ $INF == 1 ] || [ $INF == 2 ]
then
        printf "Generando estructura de directorios... \n"
fi
bash gen_codigos.sh $DIR
bash gen_dirs.sh $DIR

if [ $INF == 1 ] || [ $INF == 2 ]
then
        printf "Desempaquetando archivos y generando series temporales... \n"
fi
bash gestion_zips.sh $DIR
