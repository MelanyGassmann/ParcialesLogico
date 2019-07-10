%relaciona una provincia con su ciudad
provincia(buenosAires,arrecifes).
provincia(buenosAires,carmenDeAreco).
provincia(buenosAires,chacabuco).
provincia(buenosAires,ezeiza).
provincia(buenosAires,pergamino).
provincia(sanJuan,bellaVista).
provincia(sanJuan,jachal).
provincia(sanJuan,rodeo).
provincia(laRioja,chepes).
provincia(sanLuis,quines).
provincia(sanLuis,merlo).
provincia(cordoba,rioCuarto).
provincia(santaFe,venadoTuerto).

%Horario en cada ciudad
horario(arrecifes,1744).
horario(carmenDeAreco,1744).
horario(chacabuco,1743).
horario(ezeiza,1744).
horario(pergamino,1744).
horario(bellaVista,1741).
horario(jachal,1741).
horario(rodeo,1741).
horario(chapes,1742).
horario(quines,1742).
horario(merlo,1742).
horario(rioCuarto,1742).
horario(venadoTuerto,1743).

%Altura en cada ciudad
altura(arrecifes,25).
altura(carmenDeAreco,21).
altura(chacabuco,26).
altura(ezeiza,09).
altura(pergamino,29).
altura(bellaVista,115).
altura(jachal,111).
altura(rodeo,115).
altura(chapes,89).
altura(quines,78).
altura(merlo,71).
altura(rioCuarto,63).
altura(venadoTuerto,41).

%Duracion en cada ciudad en segundos
duarcion(arrecifes,40).
duarcion(carmenDeAreco,90).
duarcion(chacabuco,127).
duarcion(ezeiza,61).
duarcion(pergamino,56).
duarcion(bellaVista,147).
duarcion(jachal,99).
duarcion(rodeo,136).
duarcion(chapes,123).
duarcion(quines,133).
duarcion(merlo,139).
duarcion(rioCuarto,114).
duarcion(venadoTuerto,131).

%servicios que tiene una ciudad
servicios(bellaVista,telescopio).
servicios(chepes,telescopio).
servicios(ezeiza,telescopio).
servicios(chacabuco,reposerasPublicas).
servicios(arrecifes,reposerasPublicas).
servicios(chepes,reposerasPublicas).
servicios(venadoTuerto,reposerasPublicas).
servicios(quines,observatorioAtronomico).
servicios(quines,lentesDeSol).
servicios(rodeo,lentesDeSol).
servicios(rioCuarto,lentesDeSol).
servicios(merlo,lentesDeSol).

%----------  PRIMER PUNTO  ----------%
alturaMayorADiez(Lugar):-
    altura(Lugar,Altura),
    Altura>100.

comienzoTardio(Lugar):-
    horario(Lugar,Hora),
    Hora>1742.

%----------  SEGUNDO PUNTO  ----------%
sinServicio(Lugar):-
    provincia(_,Lugar),
    not(servicios(Lugar,_)).

%----------  TERCER PUNTO  ----------%
masDeUnaCiudad(Provincia):-
    provincia(Provincia,Ciudad1),
    provincia(Provincia,Ciudad2),
    Ciudad1\=Ciudad2.

unicaCiudad(Provincia):-
    provincia(Provincia,_),
    not(masDeUnaCiudad(Provincia)).

%----------  CUARTO PUNTO  ----------%
mayorDuracion(Lugar):-
    duarcion(Lugar,Duracion1),
    forall((duarcion(Lugar1,Duracion2),Lugar\=Lugar1),Duracion1>Duracion2).

%----------  QUINTO PUNTO  ----------%
/*promedioPais(Prom):-
    provincia(Provincia,_),
    findall(Provincia,duracion(Provincia,Duracion),Total),
*/
