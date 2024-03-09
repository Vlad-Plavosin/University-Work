:-use_module(library(lists)).
invert(L1,L2):-
	inv_aux(L1,[],L2).
inv_aux([],L,L).
inv_aux(L1,LAux,L2):-
	L1 = [H|T],
	NLAux = [H|LAux],
	inv_aux(T,NLAux,L2).
pascal(N,Lines):-
	paux(1,N,[],Lines).
	
paux(N,N,L,L).
paux(C,N,L,Lines):-
	C1 is C +1,
	paux(C1,N,L,Lines).
max(A,B,C,O):-
	C>A,
	C>B,
	!,
	O = C.
max(A,B,C,O):-
	B>A,
	B>C,
	!,
	O = B.
max(A,B,C,O):-
	A>C,
	A>B,
	!,
	O = B.
	
%class(Course, ClassType, DayOfWeek, Time, Duration)
class(pfl, t, '2 Tue', 15, 2).
class(pfl, tp, '2 Tue', 10.5, 2).
class(lbaw, t, '3 Wed', 10.5, 2).
class(lbaw, tp, '3 Wed', 8.5, 2).
class(ipc, t, '4 Thu', 14.5, 1.5).
class(ipc, tp, '4 Thu', 16, 1.5).
class(fsi, t, '1 Mon', 10.5, 2).
class(fsi, tp, '5 Fri', 8.5, 2).
class(rc, t, '5 Fri', 10.5, 2).
class(rc, tp, '1 Mon', 8.5, 2).

same_day(C1,C2):-
	class(C1,_,B,_,_),
	class(C2,_,B,_,_).
schedule:-
	setof(C-A-D-B-E,class(C,A,D,B,E),L),
	write(L).

%flight(origin, destination, company, code, hour, duration)
flight(porto, lisbon, tap, tp1949, 1615, 60).
flight(lisbon, madrid, tap, tp1018, 1805, 75).
flight(lisbon, paris, tap, tp440, 1810, 150).
flight(lisbon, london, tap, tp1366, 1955, 165).
flight(london, lisbon, tap, tp1361, 1630, 160).
flight(porto, madrid, iberia, ib3095, 1640, 80).
flight(madrid, porto, iberia, ib3094, 1545, 80).
flight(madrid, lisbon, iberia, ib3106, 1945, 80).
flight(madrid, paris, iberia, ib3444, 1640, 125).
flight(madrid, london, iberia, ib3166, 1550, 145).
flight(london, madrid, iberia, ib3163, 1030, 140).
flight(porto, frankfurt, lufthansa, lh1177, 1230, 165).

:- dynamic male/1,female/1,male/2,female/2.
add_person('female',N):-
	assert(female(N)).
	add_person('male',N):-
	assert(male(N)).
updateb:-
	male(X),
	write(X),nl,
	updateaux(X).
updateaux(X):-
	read(N),
	integer(N),
	retract(male(X)),
	assert(male(X,N)).
updateaux(_):-
	write('failed'),nl.
getlongest:-
	flight(_,_,_,Id,_,T),
	\+(flight(_,_,_,_,_,T1), T1 > T),
	write(Id,nl).
	
predX([],0).
predX([X|Xs],N):-
    X =.. [_|T],
    length(T,2),
    !,
    predX(Xs,N1),
    N is N1 + 1.
predX([_|Xs],N):-
    predX(Xs,N).
	
edge(a,b).
edge(a,c).
edge(a,d).
edge(b,e).
edge(b,f).
edge(c,b).
edge(c,d).
edge(c,e).
edge(d,a).
edge(d,e).
edge(d,f).
edge(e,f).
sfp(Origin, Destination, ProhibitedNodes, Path):-
	member(Origin,ProhibitedNodes),
	fail.
sfp(Origin, Destination, ProhibitedNodes, Path):-
	member(Destination,ProhibitedNodes),
	fail.
sfp(Origin, Destination, ProhibitedNodes, Path):-
	path_rec([Origin],Destination,ProhibitedNodes,Path),
	\+((path_rec([Origin],Destination,ProhibitedNodes,Path1), length(Path1,N1),length(Path,N),N1 < N)).

path_rec([Destination|T],Destination,_,[Destination|T]).
path_rec([H|T],Destination,ProhibitedNodes,Path):-
	
	edge(H,A),
	\+member(A,[H|T]),
	\+member(A,ProhibitedNodes),
	path_rec([A,H|T],Destination,ProhibitedNodes,Path).
	