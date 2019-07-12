%--------------- BASE DE DATOS ---------------%

% perro(tamaño)
mascota(pepa, perro(mediano)).
mascota(frida, perro(grande)).
% gato(sexo, cantidad de personas que lo acariciaron)
mascota(piru, gato(macho,15)).
mascota(kali, gato(macho,3)).
mascota(olivia, gato(hembra,16)).
mascota(mambo, gato(macho,2)).
mascota(abril, gato(hembra,4)).
mascota(quinchin, gato(macho,0)).
% tortuga(carácter)
mascota(buenaventura, tortuga(agresiva)).
mascota(severino, tortuga(agresiva)).
mascota(simon, tortuga(tranquila)).

%--------------- PUNTO UNO ---------------%
% a) duenio(Nombre,Mascota,Adopcion/Compra/Regalaron,Anio )
duenio(martin,pepa,adopto,2014).
duenio(martin,olivia,adopto,2014).
duenio(martin,frida,adopto,2015).
duenio(martin,kali,adopto,2016).
duenio(martin,piru,compro,2010).
duenio(constanza,abril,regalaron,2006).
duenio(constanza,mambo,adopto,2015).
duenio(hector,abril,adopto,2015).
duenio(hector,mambo,adopto,2015).
duenio(hector,buenaventura,adopto,1971).
duenio(hector,severino,adopto,2007).
duenio(hector,simon,adopto,2016).
duenio(hector,abril,compro,2006).
duenio(silvio,quinchin,regalaron,1990).

/* b)   Da falso ya que cualquier hecho que no este en la base de datos se 
        la programacion logica lo toma como que es falso ya que solo lo 
        verdadero se encuentra en la base
*/

%--------------- PUNTO DOS ---------------%
comprometidos(Persona1,Persona2):-
    duenio(Persona1,Mascota,_,Anio1),
    duenio(Persona2,Mascota,_,Anio2),
    Persona1\=Persona2,
    Anio1==Anio2.

%--------------- PUNTO TRES ---------------%
locoDeLosGatos(Persona):-
    duenio(Persona,_,_,_),
    forall(duenio(Persona,Mascota,_,_),mascota(Mascota,gato(_,_))).
   
%--------------- PUNTO CUATRO ---------------%
mascotaChapita(Mascota):-
    mascota(Mascota,perro(chico)).
mascotaChapita(Mascota):-
    mascota(Mascota,tortuga(_)).
mascotaChapita(Mascota):-
    mascota(Mascota,gato(_,CantCaricias)),
    CantCaricias<10.

puedeDormir(Persona):-
    duenio(Persona,_,_,_),
    forall(duenio(Persona,Mascota,_,_),not(mascotaChapita(Mascota))).

%--------------- PUNTO CINCO ---------------%
% a)
crisisNerviosa(Persona,Anio):-
    duenio(Persona,Mascota1,_,Anio1),
    duenio(Persona,Mascota2,_,Anio2),
    mascotaChapita(Mascota1),
    mascotaChapita(Mascota2),
    Mascota1 \= Mascota2,
    Anio1 < Anio2,
    Anio is Anio2+1.

% b) Es inversible ya que podemos realizar consultas con variables y no con,
%   hechos conocidos.

%--------------- PUNTO SEIS ---------------%
mascotaDominante(Alfa,Beta):-
    mascota(Alfa,gato(_,_)),
    mascota(Beta,perro(_)).

mascotaDominante(Alfa,Beta):-
    mascota(Alfa,perro(grande)),
    mascota(Beta,perro(chico)).

mascotaDominante(Alfa,Beta):-
    mascotaChapita(Alfa),
    not(mascotaChapita(Beta)).

mascotaDominante(Alfa,Beta):-
    mascota(Alfa,tortuga(agresiva)),
    mascota(Beta,_).

mascotaAlfa(Persona,Mascota):-
    duenio(Persona,Mascota,_,_),
    forall(duenio(Persona,Mascota,_,_),mascotaDominante(Mascota,Mascota)).

%--------------- PUNTO SIETE ---------------%
cantMascotasCompradas(Persona,CantComprados):-
    duenio(Persona,_,_,_),
    findall(compro,duenio(Persona,_,compro,_),ListComprados),
    length(ListComprados, CantComprados).
cantiMascotasAdoptadas(Persona,CantAdoptados):-
    duenio(Persona,_,_,_),
    findall(adoptado,duenio(Persona,_,adoptado,_),ListAdoptados),
    length(ListAdoptados, CantAdoptados).

materialista(Persona):-
    cantMascotasCompradas(Persona,CantCompradas),
    cantiMascotasAdoptadas(Persona,CantAdoptadas),
    CantCompradas > CantAdoptadas.

materialista(Persona):-
    not(duenio(Persona,_,_,_)).