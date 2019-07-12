%--------------- BASE DE DATOS ---------------%
% seDiceQue(afirmacion, circunstancia).
seDiceQue(laTierraEstaSobreElefantes, historica(iii, dc, india)).
seDiceQue(romuloYRemoFundaronRoma, historica(vii, ac, europa)).
%politica(año)
seDiceQue(joseHaceObraPublica, politica(2003)).
seDiceQue(elSegundoSemestreVaASerMejor, politica(2015)).
seDiceQue(mauriPagaSusImpuestos, politica(2015)).
%universitaria(nombreDelMes, materia)
seDiceQue(elTPLoHicimosEntreTodos,universitaria(junio,pdep)).
seDiceQue(laClaseLaTeniaPreparada,universitaria(abril,pdep)).

%refutacion(afirmacion, acontecimiento, momento).
refutacion(laTierraEstaSobreElefantes, viajeDeMagallanes, xvi).
refutacion(joseHaceObraPublica, revoleoGuitaEnConvento,2016).
refutacion(mauriPagaSusImpuestos, offShoreEnPanama, 2016).
refutacion(elTPLoHicimosEntreTodos, unoSoloAproboParcial,julio).
refutacion(laClaseLaTeniaPreparada, elEjemploNoFunciona,abril).

% romano2arabigo(Siglo Romano,Antes/Despues de Cristo,Siglo Arabigo).
romano2arabigo(iii,dc,3).
romano2arabigo(vii,ac,-7).
romano2arabigo(xvi,dc,16).

% PERIODO PRESIDENCIAL
periodo(4).

% meses
meses([enero,febrero,marzo,abril,mayo,junio,julio,agosto,septiembre,octubre,noviembre,diciembre]).

mesSeguido(enero,febrero).
mesSeguido(febrero,marzo).
mesSeguido(marzo,abril).
mesSeguido(abril,mayo).
mesSeguido(mayo,junio).
mesSeguido(junio,julio).
mesSeguido(julio,agosto).
mesSeguido(agosto,septiembre).
mesSeguido(septiembre,octubre).
mesSeguido(octubre,noviembre).
mesSeguido(noviembre,diciembre).
mesSeguido(diciembre,enero).

%--------------- PUNTO UNO ---------------%
mentira(Afirmacion,Circunstancia,Refutacion):-
    seDiceQue(Afirmacion,Circunstancia),
    refutacion(Afirmacion,_,Refutacion).

%--------------- PUNTO DOS ---------------%

tienePatasCortas(historica(TiempoR,AcDc,_),Refutacion):-
    %seDiceQue(Hecho,historica(TiempoR,AcDc,_)),
    romano2arabigo(TiempoR,AcDc,Tiempo1),
    romano2arabigo(Refutacion,dc,Tiempo2),
    Tiempo is Tiempo2 - Tiempo1,
    Tiempo < 10.

%--------------- PUNTO TRES ---------------%
tienePatasCortas(politica(Anio),Refutacion):-
    %seDiceQue(Hecho,politica(Anio)),
    periodo(Periodo),
    Periodo1 is Refutacion - Anio,
    Periodo1 >= Periodo.

tienePatasCortas(universitaria(Refutacion,_),Refutacion).
   % seDiceQue(Hecho,universitaria(Refutacion,_)).
    
tienePatasCortas(universitaria(Mes,_),Refutacion):-
   % seDiceQue(Hecho,universitaria(Mes)),
    mesSeguido(Mes,Refutacion).

laMentiraTienePatasCortas(Hecho):-
    mentira(Hecho,Circunstancia,Refutacion),
    tienePatasCortas(Circunstancia,Refutacion).
        
%--------------- PUNTO CUATRO ---------------%
cantidadMentiras(Cantidad):-
    findall(Afirmacion,mentira(Afirmacion,_,_),ListMentiras),
    length(ListMentiras,Cantidad).

cantidadMentirasConPatasCortas(CantidadPatasCortas):-
    findall(Afirmacion,laMentiraTienePatasCortas(Afirmacion),ListMentirasConPatasCortas),
    length(ListMentirasConPatasCortas,CantidadPatasCortas).
    
confiabilidadRefranPobre:-
    laMentiraTienePatasCortas(Afirmacion1),
    laMentiraTienePatasCortas(Afirmacion2),
    Afirmacion1\=Afirmacion2.

confiabilidadRefranAceptable:-
    cantidadMentiras(CantidadTotal),
    cantidadMentirasConPatasCortas(CantidadToalPatasCortas),
    CantidadToalPatasCortas > CantidadTotal.

confiabilidadRefranExcelente:-
    forall(mentira(Afirmacion,_,Refutacion),tienePatasCortas(Afirmacion,Refutacion)).


