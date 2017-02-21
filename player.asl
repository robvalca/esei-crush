// Agent player in project conecta4.mas2j

/* Initial beliefs and rules */

/* Initial goals */

//!start.

/* Plans */
+canExchange <- !start.

+!start : size(N) <- 
	?select(Mov,steakBlue(X,Y));
	-select(Mov,steakBlue(X,Y));
	if (Mov==left) {
		.send(judge,tell,exchange(X,Y,X-1,Y));
		.print("cambiamos pieza azul en: ", X,", ",Y," por roja a la izquierda");
	} else {
		.send(judge,tell,exchange(X,Y,X,Y+1));
		.print("cambiamos pieza azul en: ", X,", ",Y," por roja debajo");
	};
	.wait(5000);
	?select(Mov1,steakRed(X1,Y1));
	-select(Mov1,steakRed(X1,Y1));
	if (Mov1==left) {
		.send(judge,tell,exchange(X1,Y1,X1-1,Y1));
		.print("cambiamos pieza roja en: ", X1,", ",Y1," por azul a la izquierda");
	} else {
		.send(judge,tell,exchange(X1,Y1,X1,Y1+1));
		.print("cambiamos pieza roja en: ", X1,", ",Y1," por azul debajo");
	}.
	//.send(judge,tell,exchange(0,N-2,1,N-1)).

+tryAgain <-
	.wait(3000);
	?select(Mov1,steakRed(X1,Y1));
	-select(Mov1,steakRed(X1,Y1));
	if (Mov1==left) {
		.send(judge,tell,exchange(X1,Y1,X1-1,Y1));
		.print("cambiamos pieza roja en: ", X1,", ",Y1," por azul a la izquierda");
	} else {
		.send(judge,tell,exchange(X1,Y1,X1,Y1+1));
		.print("cambiamos pieza roja en: ", X1,", ",Y1," por azul debajo");
	}.

+steak(Color,X,Y) : size(N)  <- 
	-steak(Color,X,Y)[source(percept)];
	if (Color==16) {
		+steakRed(X,Y);
		.print("Se ha colocado un circulito rojo en: ", X, ", ",Y,".");
		};
	if (Color==32) {
		+steakBlue(X,Y);
		.print("Se ha colocado un circulito azul en: ", X, ", ",Y,".");
		};
	if (Color==64) {
		+steakGreen(X,Y);
		.print("Se ha colocado un circulito verde en: ", X, ", ",Y,".");
		};
	if (Color==128) {
		+steakCyan(X,Y);
		.print("Se ha colocado un circulito cyan en: ", X, ", ",Y,".");
		};
	if (Color==256) {
		+steakPink(X,Y);
		.print("Se ha colocado un circulito rosa en: ", X, ", ",Y,".");
		};
	if (Color==512) {
		+steakGray(X,Y);
		.print("Se ha colocado un circulito gris en: ", X, ", ",Y,".");
		};
	?esElegible(Color,X,Y).

+?esElegible(16,X,Y) : size(N) <-
		if ((N-1 > Y+1) & not steakRed(X,Y+1)) {
			+select(down,steakRed(X,Y));
			};
		if ((0 < X-1) & not steakRed(X-1,Y)) {
			+select(left,steakRed(X,Y));}.
			
+?esElegible(32,X,Y) : size(N) <-
		if ((N-1 > Y+1) & not steakBlue(X,Y+1)) {
			+select(down,steakBlue(X,Y));
			};
		if ((0 < X-1) & not steakBlue(X-1,Y)) {
			+select(left,steakBlue(X,Y));}.
			
+?esElegible(64,X,Y) : size(N) <-
		if ((N-1 > Y+1) & not steakGreen(X,Y+1)) {
			+select(down,steakGreen(X,Y));
			};
		if ((0 < X-1) & not steakGreen(X-1,Y)) {
			+select(left,steakGreen(X,Y));}.
			
+?esElegible(128,X,Y) : size(N) <-
		if ((N-1 > Y+1) & not steakCyan(X,Y+1)) {
			+select(down,steakCyan(X,Y));
			};
		if ((0 < X-1) & not steakCyan(X-1,Y)) {
			+select(left,steakCyan(X,Y));}.
			
+?esElegible(256,X,Y) : size(N) <-
		if ((N-1 > Y+1) & not steakPink(X,Y+1)) {
			+select(down,steakPink(X,Y));
			};
		if ((0 < X-1) & not steakPink(X-1,Y)) {
			+select(left,steakPink(X,Y));}.
			
+?esElegible(512,X,Y) : size(N) <-
		if ((N-1 > Y+1) & not steakGray(X,Y+1)) {
			+select(down,steakGray(X,Y));
			};
		if ((0 < X-1) & not steakGray(X-1,Y)) {
			+select(left,steakGray(X,Y));}.


+steak(16,X,Y) : size(N) <- 
	-steak(16,X,Y)[source(percept)];
	+steakRed(X,Y);
	.print("Se ha colocado un circulito rojo en: ", X, ", ",Y,".");
		if ((N-1 > Y+1) & not steakRed(X,Y+1)) {
			+select(down,steakRed(X,Y));
		};
		if ((0 < X-1) & not steakRed(X-1,Y)) {
			+select(left,steakRed(X,Y));
		};
	.print("BC Player actualizada.").


