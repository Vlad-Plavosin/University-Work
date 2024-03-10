s(1).
s(2):-!.
s(3).

print_n(0,_).

print_n(N,S):-
	N > 0;
	N1 is N-1,
	write(S),
	print_n(N1,S).

read_number(X):-
	readnaux(0,false,X).
	
readnaux(Acc,_,X):-
	get_code(C),
	C >= 48,
	C =< 57,
	!,
	Acc1 is 10*Acc + (C-48),
	readnaux(Acc1,true,X).
readnaux(X,true,X).