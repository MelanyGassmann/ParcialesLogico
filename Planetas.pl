%---------- BASE DE DATOS ----------%

% NOMBRE, DUENIO, POBLACION
planeta(neptuno,loki,1000).
planeta(mercurio,floki,0).
planeta(tierra,ragnar,2400).

% HABITANTE, PLANETA Y TRABAJO
habitante(luke,neptuno,[monje,granjero]).
habitante(maul,neptuno,[granjero,rebelde]).
habitante(lola,tierra,[panadero]).
habitante(flopy,tierra,[granjero]).
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
    findall(Habitante,(habitante(Habitante,Planeta,_),esMonje(Habitante)),ListMonjes),
    length(ListMonjes,CantMonjes),
    Consumo is (CantHab - CantMonjes)*2.

%---------- PUNTO CUATRO ----------%
esGranjero(Habitante):-
    habitante(Habitante,_,Trabajo),
    member(granjero,Trabajo).

produccionDeComida(Produccion,Planeta):-
    planeta(Planeta,_,_),
    findall(Habitante,(habitante(Habitante,Planeta,_),esGranjero(Habitante)),ListGranjeros),
    length(ListGranjeros,CantGranjeros),
    Produccion is CantGranjeros * 10.

%---------- PUNTO CINCO ----------%
planetaConPerdida(Planeta):-
    planeta(Planeta,_,_),
    forall((consumoDeComida(Consumo,Planeta),produccionDeComida(Produccion,Planeta)),Consumo>Produccion).
   
%---------- PUNTO SEIS ----------%    
estaAlHorno(Emperador):-
    planeta(Planeta,Emperador,_),
    forall((consumoDeComida(Consumo,Planeta),produccionDeComida(Produccion,Planeta)),Consumo > 2*Produccion).

%---------- SEGUNDA PARTE ----------%

%---------- BASE DE DATOS ----------%    
% TIPO DE PLANETA
tipoPlaneta(tierra,continental([a,b,c,d])).
tipoPlaneta(neptuno,artico).
tipoPlaneta(mercurio,gaseoso([10,20,40])).

%---------- PUNTO UNO ----------%
existeRebelde2(Planeta,Habitante):-
    habitante(Habitante,Planeta,Trabajo),
    member(rebelde,Trabajo).

crisisPlanetaria2(Emperador):-
    planeta(_,Emperador,_),
    forall(planeta(Planeta,Emperador,_),existeRebelde(Planeta,_)).

%---------- PUNTO DOS ----------%
sonVagos2(Habitante):-
    habitante(Habitante,_,Trabajo),
    length(Trabajo,Cant),
    Cant<2.
    
deberiaDestruir2(Emperador,Planeta):-
    planeta(Planeta,Emperador,_),
    forall(habitante(Habitante,Planeta,_),sonVagos(Habitante)).

%---------- PUNTO TRES ----------%
consumoDeComidaPorPlaneta(Consumo,Planeta):-
    planeta(Planeta,_,_),
    tipoPlaneta(Planeta,Tipo),
    consumo(Tipo,Consumo).

consumo(artico,1).

consumo(continental(_),Consumo):-
    consumo(artico,ConsumoA),
    Consumo is ConsumoA/2.

consumo(gaseoso(Hidrogeno,Helio,_),Consumo):-
    Consumo is Hidrogeno * Helio.

%---------- PUNTO CUATRO ----------%
produccionDeComidaPorPlaneta(Produccion,Planeta):-
    planeta(Planeta,_,Poblacion),
    tipoPlaneta(Planeta,Tipo),
    produccion(Tipo,Produccion,Poblacion).

produccion(artico,1,_).

produccion(continental(Continentes),Produccion,Poblacion):-
    length(Continentes,CantContinentes),
    Produccion is CantContinentes * Poblacion.

produccion(gaseoso(Hidrogeno,Helio,_),Produccion,_):-
    Produccion is (Helio*30) - (Hidrogeno*5).


%---------- PUNTO CINCO ----------%
planetaConPerdida2(Planeta):-
    planeta(Planeta,_,_),
    forall((consumoDeComidaPorPlaneta(Consumo,Planeta),produccionDeComidaPorPlaneta(Produccion,Planeta)),Consumo>Produccion).
   
%---------- PUNTO SEIS ----------%    
estaAlHorno2(Emperador):-
    planeta(Planeta,Emperador,_),
    forall((consumoDeComidaPorPlaneta(Consumo,Planeta),produccionDeComidaPorPlaneta(Produccion,Planeta)),Consumo > 2*Produccion).

