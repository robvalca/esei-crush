// Agent judge in project crush.mas2j

/* Initial beliefs and rules */
color(0).

contiguas(X,X,Y1,Y2) :- size(N) & Y2< N-1 & Y1 = Y2+1.
contiguas(X,X,Y1,Y2) :- Y2 > 1 & Y1 = Y2-1.
contiguas(X1,X2,Y,Y) :- size(N) & X2< N-1 & X1 = X2+1.
contiguas(X,X,Y1,Y2) :-  X1 = X2+1.

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	!iniciarTablero;
	//!iniciarJuego;
	.all_names(L);
	if (.member(player,L)){
		.send(player,tell,canExchange);}
	else {
		.print("El agente player no existe mas.");
	}. //.print("hello world.").

+!iniciarTablero : size(N) <-
	for (.range(X,0,N-1)) {
		for (.range(Y,0,N-1)) {
		?color(C);
		//-color(C);
		if (color(C) & (C < 5)) {
			-+color(C+1);
		} else {
			-+color(0)
		};
		.print("Pongo ficha de color: ",C);
		put(C,X);
		}
	}.


+trampa(Ag) <- 
	.kill_agent(Ag);
	.print("He tenido que matar el agente", Ag, " por tramposo.").
	
+putSteak(X)[source(Source)] <-
	.print("He recibido de ", Source, " la solicitud de colocar un steak en: ", X);
	putB(X).

+exchange(X1,Y1,X2,Y2)[source(Source)]: steak(C1,X1,Y1) & steak(C2,X2,Y2) &
										contiguas(X1,X2,Y1,Y2) & not C1 == C2 <-
	.print("He recibido de ", Source, " la solicitud de intercambiar un steak ", C1, " en: ", X1, ", ",Y1);
	.print("Por un steak ", C2, " en: ", X2, ", ",Y2, " que voy a atender inmediatamente.");
	.wait(1000);
	if (C1==32) {
		changetoR(X1,Y1);
		changetoB(X2,Y2);
	} else {
		changetoB(X1,Y1);
		changetoR(X2,Y2)
	}.

+exchange(X1,Y1,X2,Y2)[source(Source)] <-
	.print("He recibido de ", Source, " la solicitud de intercambiar dos steak que no son viables");
	.send(Source,tell,tryAgain).

