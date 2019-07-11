%--------------- BASE DE DATOS ---------------%
% CIUDAD Y CANT HABITANTES
ciudad(bariloche,10000000).
ciudad(chapelco,0).
ciudad(posadas,8000000).
ciudad(tandil,5000000).
ciudad(crespo,4000000).
ciudad(cataratas,500).
ciudad(rosario,6000000).

% RUTA: CIUDAD1, CIUDAD2 Y LA DISTANCIA ENTRE ELLOS
ruta(bariloche,chapelco,296).
ruta(chapelco,bariloche,296).
ruta(bariloche,posadas,2480).
ruta(posadas,bariloche,2480).
ruta(tandil,posadas,1319).
ruta(posadas,tandil,1319).
ruta(crespo,bariloche,1786).
ruta(bariloche,crespo,1786).
ruta(crespo,posadas,761).
ruta(posadas,crespo,761).
ruta(tandil,bariloche,1342).
ruta(bariloche,tandil,1342).
ruta(chapelco,posadas,990).
ruta(posadas,chapelco,990).

% TRANSACCION: VENDEDOR, COMPRADOR, PRODUCTO(PRODUCTO,CANT), MEDIO DE TRANSPORTE
%transaccion(bariloche,posadas,producto(zapatillas,400),avion).
transaccion(bariloche,rosario,producto(zapatillas,400),avion).
transaccion(bariloche,chapelco,producto(manaos,5000),tren(60,100)).
transaccion(crespo,posadas,producto(maiz,800),camion(fiat)).
transaccion(posadas,crespo,producto(piedras,500),camion(mercedes)).
transaccion(tandil,bariloche,producto(salame,300),avion).
transaccion(chapelco,posadas,producto(camperas,50),tren(60,100)).
transaccion(rosario,crespo,producto(zapatillas,400),barco).

% TRANSPORTE 
% AVIONES
medioTransporte(avion).
% TREN: CANT. VAGONES, CAPACIDAD.
medioTransporte(tren(60,100)).
% CAMION: MARCA
medioTransporte(camion(mercedes)).
medioTransporte(camion(fiat)).
% BARCOS
medioTrasnporte(barco).

% PRECIO DEL PRODUCTO: PRODUCTO, PRECIO 
costoProducto(zapatillas,3000).
costoProducto(manaos,45).
costoProducto(maiz,100).
costoProducto(piedras,15000).
costoProducto(salame,40).
costoProducto(camperas,200).

%--------------- PUNTO UNO ---------------%
costoPedido(producto(Nombre,Cant),Costo):-
    costoProducto(Nombre,CostoUnidades),
    Costo is CostoUnidades * Cant.

costoTransporte(tren(CVagon,_),C1,C2,CostoProd,CostoTransporte):-
    ruta(C1,C2,Distancia),
    CostoTransporte is CostoProd * (CVagon+1) * Distancia.

costoTransporte(avion,_,_,CostoProd,CostoTransporte):-
    CostoTransporte is CostoProd * 1000.

costoTransporte(camion(mercedes),C1,C2,_,CostoTransporte):-
    ruta(C1,C2,Distancia),
    CostoTransporte is Distancia.

costoTransporte(camion(Marca),_,_,CostoProd,CostoTransporte):-
    Marca \= mercedes,
    CostoTransporte is CostoProd * 10.

costoTransporte(barco,_,_,CostProd,CostoTransporte):-
    CostoTransporte is CostProd * 50.

costoProductoPuntual(Vendedor, Comprador,Producto, CostoTotal):-
    transaccion(Vendedor,Comprador,Producto,Transporte),
    costoPedido(Producto,CostoPedido),
    costoTransporte(Transporte,Vendedor,Comprador,CostoPedido,CostoTransporte),
    CostoTotal is CostoPedido + CostoTransporte.

%--------------- PUNTO DOS ---------------%
cantVentasPorCiudad(Ciudad,Ventas):-
    costoProductoPuntual(Ciudad,_,_,_),
    findall(Costo,costoProductoPuntual(Ciudad,_,_,Costo),ListVentas),
    length(ListVentas, Ventas).
    
cantComprasPorCiudad(Ciudad,Compras):-
    costoProductoPuntual(_,Ciudad,_,_),
    findall(Costo,costoProductoPuntual(_,Ciudad,_,Costo),ListCompras),
    length(ListCompras,Compras).

saldoComercial(Ciudad,Saldo):-
    cantVentasPorCiudad(Ciudad,Ventas),
    cantComprasPorCiudad(Ciudad,Compras),
    Saldo is Ventas - Compras.

%--------------- PUNTO TRES ---------------%
ciudadFantasma(Ciudad):-
    ciudad(Ciudad,Habitantes),
    Habitantes<1000000,
    not(ruta(Ciudad,_,_)).
% cataratas

productoVende(Ciudad,producto,vendedor,ListVenta):-
    costoProductoPuntual(Ciudad,_,_,_),
    findall(Producto,costoProductoPuntual(Ciudad,_,Producto,_),ListVenta).

productoCompra(Ciudad,producto,comprador,ListCompra):-
    costoProductoPuntual(_,Ciudad,_,_),
    findall(Producto,costoProductoPuntual(_,Ciudad,Producto,_),ListCompra).

ciudadDeTransito(Ciudad):-
    productoCompra(Ciudad,producto,comprador,ProductosCompra),
    productoVende(Ciudad,producto,vendedor,ProductosVenta),
    ProductosCompra == ProductosVenta.
% rosario para zapatillas

productosDistintos(cosroProducto(Prod1,_),costoProducto(Prod2,_)):-
    Prod1 \= Prod2.

ciudadMonopolica(Ciudad):-
    transaccion(Ciudad,_,Producto,_),
    forall((transaccion(Ciudad1,_,Producto1,_),Ciudad \= Ciudad1),productosDistintos(Producto,Producto1)).
% bariloche, chapelco, posadas, crespo y tandil

%--------------- PUNTO CUATRO ---------------%
distanciaTotal(Ciudad1,Ciudad3,DistanciaTotal):-
    ruta(Ciudad1,Ciudad2,DistanciaMedia),
    ruta(Ciudad2,Ciudad3,DistanciaFinal),
    DistanciaTotal is DistanciaMedia + DistanciaFinal.

%--------------- PUNTO CINCO ---------------%
% SE AGREGO EL BARCO Y TODO FUNCIONA CORRECTAMENTE.

%--------------- PUNTO SEIS ---------------%
/*  CIUDAD FANTASMA => CATARATAS
    CIUDAD DE TRANSITO => ROSARIO
    CIUDAD MONOPOLICA => BARILOCHE, CHAPELCO, POSADAS, CRESPO Y TANDIL.
*/

%--------------- PUNTO SIETE ---------------%
/*  TODOS LOS PREDICADOS SON INVERSIBLES, YA QUE PARA CADA UNO DE LOS ARGUMENTOS
    SE PUEDE CONSULTAR CON VARIABLES PARA QUE NOS MUESTRE EL CONJUNTO DE RESULTADOS
    QUE QUEREMOS SABER.
*/

%--------------- PUNTO OCHO ---------------%
/*  