# parcialRatatoullie

rata(remy,mostaza).
rata(emile,bar).
rata(django,pizzeria).

cocina(linguini,ratatouille,8).
cocina(linguini,sopa,5).
cocina(colette,ratatouille,9).
cocina(colette,salmonAsado,9).
cocina(horst,ensaladaRusa,8).
cocina(horst,ratatouille,8).

trabajaEn(gusteaus,linguini).
trabajaEn(gusteaus,colette).
trabajaEn(gusteaus,skinner).
trabajaEn(gusteaus,horst).
trabajaEn(cafeDe2Moulins,amelie).
 
esUnRestaurante(Restaurante):-
    rata(_,Restaurante).
esUnRestaurante(Restaurante):-
    trabajaEn(Restaurante,_).
%-------------------- PUNTO UNO --------------------%
inspeccionSatisfactoria(Restaurante):-
    esUnRestaurante(Restaurante),
     not(rata(_,Restaurante)).

%-------------------- PUNTO DOS --------------------%
chef(Empleado,Restaurante):-
    trabajaEn(Restaurante,Empleado),
    cocina(Empleado,_,_).

%-------------------- PUNTO TRES --------------------%
chefcito(Rata):-
    rata(Rata,Restaurante),
    trabajaEn(Restaurante,linguini).

%-------------------- PUNTO CUATRO --------------------%
cocinaBien(remy,_).
cocinaBien(Empleado,Plato):-
    cocina(Empleado,Plato,Experiencia),
    Experiencia > 7.

%-------------------- PUNTO CINCO --------------------%
/*mayorExperiencia(Plato,Restaurante,Experiencia):-
    cocina(Empleado1,Plato,Experiencia1),
    trabajaEn(Restaurante,Empleado1),
    forall(cocina(Empleado1,Plato,Experiencia1),Experiencia>=Experiencia1).

encargadoDe(Empleado,Plato,Restaurante):-
    cocina(Empleado,Plato,Experiencia),
    trabajaEn(Restaurante,Empleado),
    mayorExperiencia(Plato,Restaurante,Experiencia).
*/

otroChef(Plato,Restaurante,Experiencia):-
    cocina(Empleado,Plato,Experiencia),
    trabajaEn(Restaurante,Empleado).

encargadoDe(Empleado,Plato,Restaurante):-
    cocina(Empleado,Plato,Experiencia),
    trabajaEn(Restaurante,Empleado),
    forall(otroChef(Plato,Restaurante,OtraExp),Experiencia>=OtraExp).

%-------------------- CARGA BASE DE DATOS --------------------%
plato(ensaladaRusa, entrada([papa,zanahoria,arvejas,huevo,mayonesa])).
plato(bifeDeChorizo,principal(pure,20)).
plato(frutillasConCrema,postre(265)).
guarnicion(papasFritas,50).
guarnicion(pure,20).
guarnicion(ensalada,0).

%-------------------- PUNTO SEIS --------------------%
caloriasDeEntrada(Entrada,CantCalorias):-
    plato(Entrada,entrada(Lista)),
    length(Lista, CantIngredientes),
    CantCalorias is CantIngredientes * 15.
    
saludable(Entrada):-
    caloriasDeEntrada(Entrada,CantCalorias), 
    CantCalorias < 75.

caloriasDePrincipal(Principal,CantCalorias):-
    plato(Principal,principal(Guarnicion,MinCoccion)),
    guarnicion(Guarnicion,Min),
    CantCalorias is (MinCoccion + Min) * 5.

saludable(Principal):-
    caloriasDePrincipal(Principal,CantCalorias),
    CantCalorias < 75.

saludable(Postre):-
    plato(Postre,postre(CantCalorias)),
    CantCalorias < 75.

%-------------------- PUNTO SIETE --------------------%
especialistaEn(ratatouille,Restaurante):-
    trabajaEn(Restaurante,Empleado),
    forall(cocina(Empleado,ratatouille,Restaurante),cocinaBien(Empleado,ratatouille)).

/*especialistaEn(ratatouille,Restaurante):-
    forall(chef(Empleado,Restaurante),cocinaBien(Empleado,ratatouille)).
*/
criticaPositiva(Restaurante,antonEgo):-
    inspeccionSatisfactoria(Restaurante),
    especialistaEn(ratatouille,Restaurante).

/*
masDeTresChef(Restaurante):-
    trabajaEn(Restaurante,_),
    findall(_,trabajaEn(Restaurante,Empleados),L),
    length(L,Empleados),
    Empleados>3.
criticaPositiva(Restaurante,christophe):-
    inspeccionSatisfactoria(Restaurante),
    masDeTresChef(Restaurante).
*/
/*

platosSaludables(Restaurante):-
    cocina(Empleado,Plato,Restaurante),
    forall(cocina(Empleado,Plato,Restaurante),saludable(Plato)).

%entradasConZanahoria(Restaurante).
    
cirticaPositiva(Restaurante,cormillot):-
    inspeccionSatisfactoria(Restaurante),
    platosSaludables(Restaurante).
 %   entradasConZanahoria(Plato).
*/