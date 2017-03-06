// Agent judge in project crush.mas2j

/* Initial beliefs and rules */
color(0,16).
color(N,C) :- color(N-1,C1) & C = C1*2.

chooseC(C) :- .time(_,_,S) & Exp = S mod 6 & color(Exp,C).

contiguas(X,X,Y1,Y2) :- size(N) & X >=0 & X < N & Y2 < N-1 & Y1 = Y2+1.
contiguas(X,X,Y1,Y2) :- Y2 > 0 & 0 <= X & X < N & Y1 = Y2-1.
contiguas(X1,X2,Y,Y) :- size(N) & 0 <= Y & Y < N & X2 < N-1 & X1 = X2+1.
contiguas(X1,X2,Y,Y) :-  X2 > 0 & 0 <= Y & Y < N & X1 = X2-1.

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	!iniciarTablero;
	//!iniciarJuego;
	.all_names(L);
	//.wait(100);
	if (.member(player,L)){
		.send(player,tell,canExchange);}
	else {
		.print("El agente player no existe mas.");
	};
	//.wait(1500)
	//!clearFile(4);
	//!clearNFile(5,2,4);
	//.wait(12000);
	//!clearNColumn(3,2,2);
	//?sizeof(N);
	//!clearColumn(N-1);
	!clearColor(64);
	
	
	
	moveSteaks; 
	// OJO el uso de esta función directamente en el tablero, no controla 
	// adecuadamente la colocación de las piezas especiales
	
	
	.print("Goodbye world.").

+!clearColor(C) : sizeof(N) <-
	for (.range(X,0,N)) {
		for (.range(Y,N,0,-1)) {
			if (steak(C,X,Y)) {
				.print("Intentamos eliminar fichas de color: ",C);
				deleteSteak(C,X,Y);
				put(X,Y,0,0);			}
		}
	}.

+!clearFile(Y) : sizeof(N) <-
	for (.range(X,0,N)) {
		if (steak(C,X,Y)) {
		-steak(C,X,Y)[source(percept)];
		deleteSteak(C,X,Y)};
		put(X,Y,0,0);	}.
	
+!clearNFile(N,X,Y) <-
	for (.range(I,0,N-1)) {
		if (steak(C,X+I,Y)) {
		-steak(C,X+I,Y)[source(percept)];
		deleteSteak(C,X+I,Y)};
		put(X+I,Y,0,0);	}.

+!clearNColumn(N,X,Y) <-
	for (.range(J,0,N-1)) {
		if (steak(C,X,Y+J)) {
		-steak(C,X,Y+J)[source(percept)];
		deleteSteak(C,X,Y+J)};
		put(X,Y+J,0,0);	}.
		
+!clearColumn(X) : sizeof(N) <-
	for (.range(Y,0,N)) {
		if (steak(C,X,Y)) {
		-steak(C,X,Y)[source(percept)];
		deleteSteak(C,X,Y)};
		put(X,Y,0,0);
	}.
	
+!iniciarTablero : sizeof(N) <-
	for (.range(Y,N,1,-1)) {
		for (.range(X,0,N)) {
			?chooseC(C);
			.wait(417);
			.print("Pongo ficha de color: ",C);
			put(X,Y,C,0);
		}
	};
	!initLastFile.

+!initLastFile : sizeof(N) <-
	for (.range(I,0,N,+3)) {
		for (.range(X,0,1)) {
			put(X+I,0,32,1)
		};
		put(2+I,0,64,3); // Indico que es una ficha normal
	};
	put(2,1,32,2);  // Indico que la ficha es un Catedro
	put(5,5,16,3);  // Indico que la ficha es un Gestor
	put(7,0,128,4); // Indico que la ficha es un Comprador
	put(8,0,128,1); // Indico que la ficha es un Investigador Principal
	//put(9,0,132,0)
	.

/* 
Con esta solucion de piezas especiales, debe ser el juez el que avise al 
"player" de la localización de las piezas especiales
*/

+accionIlegal(Ag) : amarilla(N) <- 
	if (N<3) {-+amarilla(N+1)}
	else {+trampa(Ag)}.
	
+accionIlegal(Ag) : not amarilla(N) <- +amarilla(1). // Controla si algun player intenta realizar un movimiento ilegal

+trampa(Ag) <- 
	.kill_agent(Ag);
	.print("He tenido que matar el agente", Ag, " por tramposo."). // Elimina al tramposo reiterado
	
+putSteak(X)[source(Source)] <-
	.print("He recibido de ", Source, " la solicitud de colocar un steak en: ", X);
	putB(X).

+exchange(X1,Y1,X2,Y2)[source(Source)]:
	steak(C1,X1,Y1) & steak(C2,X2,Y2) & contiguas(X1,X2,Y1,Y2) & not C1 == C2 
<-
	.print("He recibido de ", Source, " la solicitud de intercambiar un steak ", C1, " en: ", X1, ", ",Y1);
	.print("por un steak ", C2, " en: ", X2, ", ",Y2, " que voy a atender inmediatamente.");
	exchange(C1,X1,X2,C2,Y1,Y2);
	.print("Hecho el intercambio.").

+exchange(X1,Y1,X2,Y2)[source(Source)] <-
	.print("He recibido de ", Source, " la solicitud de intercambiar dos steak que no son viables");
	.send(Source,tell,tryAgain).

+pos(Ag,X,Y)[source(S)] <- -pos(Ag,X,Y)[source(S)].
