%---------- BASE DE DATOS ----------%

% NOMBRE, DUENIO, POBLACION
planeta(neptuno,loki,1000).
planeta(mercurio,floki,0).
planeta(tierra,ragnar,2400).

% HABITANTE, PLANETA Y TRABAJO
habitante(luke,neptuno,[monje,transportador]).
habitante(maul,neptuno,[cultivador,rebelde]).
habitante(lola,tierra,[panadero]).
habitante(flopy,tierra,[]).
habitante(leia,mercurio,[rebelde]).

%---------- PUNTO UNO ----------%
existeRebelde(Planeta,Habitante):-
    habitante(Habitante,Planeta,Trabajo),
    member(rebelde,Trabajo).

crisisPlanetaria(Emperador):-
    planeta(_,Emperador,_),
    forall(planeta(Planeta,Emperador,_),existeRebelde(Planeta,_)).

%---------- PUNTO DOS ----------%
sonVagos(Habitante):-
    habitante(Habitante,_,Trabajo),
    length(Trabajo,Cant),
    Cant<2.
    
deberiaDestruir(Emperador,Planeta):-
    planeta(Planeta,Emperador,_),
    forall(habitante(Habitante,Planeta,_),sonVagos(Habitante)).

%---------- PUNTO TRES ----------%
esMonje(Habitante):-
    habitante(Habitante,_,Trabajo),
    member(monje,Trabajo).

consumoDeComida(Consumo,Planeta):-
    planeta(Planeta,_,CantHab),
    forall(habitante(Habitante,Planeta,_),not(esMonje(Habitante))),
    Consumo is CantHab*2.

consumoDeComida(Consumo,Planeta):-
    planeta(Planeta,_,CantHab),
    habitante(Habitante,Planeta,_),
    findall(Habitante,(habitante(Habitante,Planeta,_),esMonje(Habitante)),ListMonjes),
    length(ListMonjes,CantMonjes),
    Consumo is (CantHab - CantMonjes)*2.

%---------- PUNTO CUATRO ----------%
produccionDeComida(Produccion,Planeta):-
    