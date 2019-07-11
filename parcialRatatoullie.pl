# parcialRatatoullie

rata(remy,mostaza).
rata(emile,bar).
rata(django,pizzeria).

cocina(linguini,ratatouille,8).
cocina(linguini,sopa,5).
cocina(colette,ratatouille,9).
cocina(colette,salmonAsado,8).
cocina(horst,ensaladaRusa,8).
cocina(horst,ratatouille,9).

trabajaEn(gusteaus,linguini).
trabajaEn(gusteaus,colette).
trabajaEn(gusteaus,skinner).
trabajaEn(gusteaus,horst).
trabajaEn(cafeDe2Moulins,amelie).

%-------------------- CARGA BASE DE DATOS --------------------%
plato(ensaladaRusa, entrada([papa,zanahoria,arvejas,huevo,mayonesa])).
plato(bifeDeChorizo,principal(pure,20)).
plato(frutillasConCrema,postre(265)).
guarnicion(papasFritas,50).
guarnicion(pure,20).
guarnicion(ensalada,0).

%-------------------- PUNTO UNO --------------------%
esUnRestaurante(Restaurante):-
    rata(_,Restaurante).

esUnRestaurante(Restaurante):-
    trabajaEn(Restaurante,_).

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
otroChef(Plato,Restaurante,Experiencia):-
    cocina(Empleado,Plato,Experiencia),
    trabajaEn(Restaurante,Empleado).

encargadoDe(Empleado,Plato,Restaurante):-
    cocina(Empleado,Plato,Experiencia),
    trabajaEn(Restaurante,Empleado),
    forall(otroChef(Plato,Restaurante,OtraExp),Experiencia>=OtraExp).

%-------------------- PUNTO SEIS --------------------%
caloriasDeEntrada(Entrada,CantCalorias):-
    plato(Entrada,entrada(Lista)),
    length(Lista, CantIngredientes),
    CantCalorias is CantIngredientes * 15.
    
caloriasDePrincipal(Principal,CantCalorias):-
    plato(Principal,principal(Guarnicion,MinCoccion)),
    guarnicion(Guarnicion,Min),
    CantCalorias is (MinCoccion + Min) * 5.

saludable(Entrada):-
    caloriasDeEntrada(Entrada,CantCalorias), 
    CantCalorias < 500.

saludable(Principal):-
    caloriasDePrincipal(Principal,CantCalorias),
    CantCalorias < 75.

saludable(Postre):-
    plato(Postre,postre(CantCalorias)),
    CantCalorias < 75.

%-------------------- PUNTO SIETE --------------------%
especialistaEn(ratatouille,Restaurante):-
    chef(Empleado,Restaurante),
    forall(chef(Empleado,Restaurante),cocinaBien(Empleado,ratatouille)).

masDeTresChef(Restaurante):-
    trabajaEn(Restaurante,_),
    findall(Empleados,trabajaEn(Restaurante,Empleados),ListEmpleados),
    length(ListEmpleados,CantEmpleados),
    CantEmpleados>3.

platosSaludables(Restaurante):-
    cocina(Empleado,Plato,Restaurante),
    forall(cocina(Empleado,Plato,Restaurante),saludable(Plato)).

entradasConZanahoria(Restaurante):-
    cocina(_,Plato,Restaurante),
    plato(Plato,Entrada),
    member(zanahoria,Entrada).

criticaPositiva(Restaurante,antonEgo):-
    inspeccionSatisfactoria(Restaurante),
    especialistaEn(ratatouille,Restaurante).

criticaPositiva(Restaurante,christophe):-
    inspeccionSatisfactoria(Restaurante),
    masDeTresChef(Restaurante).
    
cirticaPositiva(Restaurante,cormillot):-
    inspeccionSatisfactoria(Restaurante),
    platosSaludables(Restaurante),
    entradasConZanahoria(Restaurante).
