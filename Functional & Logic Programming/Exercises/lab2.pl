factorial(0,1).
factorial(N,F) :-
write(N),nl,
	N > 0,
	N1 is N-1,
	factorial(N1,F1),
	F is N*F1.
	
factorial2(N,F):-
	fact2aux(N,1,F).
	
fact2aux(0,F,F).
fact2aux(N,Acc,F):-
	N>0,
	Acc1 is Acc * N, 
	N1 is N-1,
	fact2aux(N1,Acc1,F).
	
pow_rec(X,1,X).
pow_rec(X,Y,P):-
	Y > 0,
	Y mod 2 =:=1,
	Y1 is Y-1,
	pow_rec(X,Y1,P1),
	P is X*P1.
pow_rec(X,Y,P):-
	Y > 0,
	Y mod 2 =:=0,
	Y1 is Y//2,
	pow_rec(X,Y1,P1),
	P is P1*P1.
	
pow_rec_tail(X,Y,P):-
	pow_aux(X,1,Y,P).

pow_aux(_,Acc,0,Acc).
pow_aux(X,Acc,Y,P):-
	Y>0,
	Acc1 is Acc * X,
	Y1 is Y-1.
	pow_aux(X,Acc1,Y1,P).