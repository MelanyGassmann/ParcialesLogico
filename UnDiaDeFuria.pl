%--------------- BASE DE DATOS ---------------%

% COTIZACION(MONEDA,HORA,COTIZACION).
cotizacion(dolar,8,43).
cotizacion(lira,8,41).
cotizacion(dolar,9,43.5).
cotizacion(lira,9,39).
cotizacion(patacon,9,200).
cotizacion(dolar,10,43.8).
cotizacion(lira,10,38).
cotizacion(patacon,10,200).

% TRANSACCION(NOMBRE,HORA,CANTIDAD,MONEDA)
transaccion(juanCarlos,8,1000,dolar).
transaccion(juanCarlos,9,1000,lira).
transaccion(ypf,10,100005349503495035930,dolar).
transaccion(fabio,8,1,dolar).

% cuenta(Persona, Pesos, Banco).
cuenta(juanCarlos, 100, hete).
cuenta(juanCarlos, 2000, nejo).
cuenta(ypf, 10000000, nejo).
cuenta(fabio,100000000,hete).

% persona(Persona,Situación)
persona(juanCarlos, laburante(colectivero, rioNegro)).
persona(romina, laburante(docente,santaFe)).
persona(julian, juez).
persona(ypf, empresa(5000)).
persona(fabio,laburante(quimico,buenosAires)).

% salario(Persona,Salario)
salario(juanCarlos,30000).
salario(romina,5000).
salario(fabio,15000).

%--------------- PUNTO UNO ---------------%
diferenciaHorarios(HoraActual,HoraAnterior,DiferenciaHora):-
    cotizacion(Moneda,HoraActual,_),
    cotizacion(Moneda,HoraAnterior,_),
    DiferenciaHora is HoraActual-HoraAnterior.

horarioAnterior(Moneda,HoraActual,HoraAnterior):-
    cotizacion(Moneda,HoraActual,_),
    cotizacion(Moneda,HoraAnterior,_),
    HoraActual>HoraAnterior.

diferenciaHora(Moneda,HoraActual,HoraAnterior,Diferencia):-
    horarioAnterior(Moneda,HoraActual,HoraAnterior),
    diferenciaHorarios(HoraActual,HoraAnterior,Diferencia).

variacionHoraria(Moneda,HoraActual,HoraAnterior):-
    diferenciaHora(Moneda,HoraActual,HoraAnterior,Diferencia1),
    forall((diferenciaHora(Moneda,HoraActual,HoraAnterior2,Diferencia2),HoraAnterior\=HoraAnterior2),Diferencia1<Diferencia2).

variacionDeLaCotizacion(Moneda,HoraActual,Variacion):-
    cotizacion(Moneda,HoraActual,CotizacionActual),
    variacionHoraria(Moneda,HoraActual,HoraAnterior),
    cotizacion(Moneda,HoraAnterior,CotizacionAnterior),
    Variacion is CotizacionActual - CotizacionAnterior.

ultimaHora(Moneda,UltimaHora):-
    cotizacion(Moneda,UltimaHora,_),
    forall(cotizacion(Moneda,UltimaHora1,_),UltimaHora>=UltimaHora1).

cierreDeMoneda(Moneda,Cierre):-
    cotizacion(Moneda,Hora,Cierre),
    ultimaHora(Moneda,Hora).

%--------------- PUNTO DOS ---------------%
masDeUnaMoneda(Persona):-
    transaccion(Persona,_,_,Moneda),
    transaccion(Persona,_,_,Moneda1),
    Moneda\=Moneda1.

monedaSinTransaccion(Moneda):-
    cotizacion(Moneda,_,_),
    not(transaccion(_,_,_,Moneda)).

transaccionMayor(Persona):-
    transaccion(Persona,_,Monto,_),
    Monto>1000000.

conversorAPesos(Hora,Monto,Moneda,CantPesos):-
    transaccion(Persona,Hora,Monto,Moneda),
    cotizacion(Moneda,Hora,Cotizacion),
    CantPesos is Cotizacion * Monto.

totalQueCambioUnaPersona(Persona,Total):-
    transaccion(Persona,_,_,_),
    findall(CantPesos,(transaccion(Persona,Hora,Monto,Moneda),conversorAPesos(Hora,Monto,Moneda,CantPesos)),ListConversiones),
    sumlist(ListConversiones, Total).

%--------------- PUNTO TRES ---------------%
superaDeclaracion(Persona,CantPesos):-
    cuenta(Persona,Monto,_),
    CantPesos>Monto.
transaccionSuperiorALoDeclarado(Persona):-
    transaccion(Persona,Hora,Monto,Moneda),
    forall((transaccion(Persona,Hora,Monto,Moneda), conversorAPesos(Hora,Monto,Moneda,CantPesos)),superaDeclaracion(Persona,CantPesos)).
    
permitidoPorLaburante(Persona,Permitido):-
    salario(Persona,Salario),
    Permitido is Salario * 0.1.
    

transaccionSuperiorALoPermitido(Persona):-
    persona(Persona,laburante(_,buenosAires)),
    permitidoPorLaburante(Persona,Permitido),
    PermitidoTotal is Permitido + 500,
    totalQueCambioUnaPersona(Persona,Total),
    Total>PermitidoTotal.

transaccionSuperiorALoPermitido(Persona):-
    not(persona(Persona,laburante(_,buenosAires))),
    permitidoPorLaburante(Persona,PermitidoTotal),
    totalQueCambioUnaPersona(Persona,Total),
    Total>PermitidoTotal.

transaccionSuperiorALoDeclarado(Persona):-
    persona(Persona,empresa(CantEmpleados)),
    Permitido is CantEmpleados * 1000,
    totalQueCambioUnaPersona(Persona,Total),
    Total>Permitido.

    

