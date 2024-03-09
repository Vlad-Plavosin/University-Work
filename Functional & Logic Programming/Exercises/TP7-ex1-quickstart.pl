/*
PFL - Sheet TP7 - Beginning of exercise 1
By: Gonçalo Leão
*/

%%% a
male(frank).
male(jay).
male(javier).
male(merle).
male(phil).
male(mitchell).
male(joe).
male(manny).
male(bo).
male(dylan).
male(alex).
male(luke).
male(george).
male(rexford).
male(calhoun).
% ...

female(grace).
female(dede).
female(gloria).
female(barb).
female(claire).
female(haley).
female(poppy).
female(cameron).
female(lily).
female(pameron).
% ...


parent(grace,phil).
parent(frank,phil).

parent(dede,claire).
parent(jay,claire).
parent(dede,mitchell).
parent(jay,mitchell).

parent(jay,joe).
parent(gloria,joe).

parent(gloria,manny).
parent(javier,manny).

parent(barb,cameron).
parent(merle,cameron).
parent(barb,pameron).
parent(merle,pameron).

parent(phil,haley).
parent(phil,alex).
parent(phil,luke).
parent(claire,haley).
parent(claire,alex).
parent(claire,luke).

parent(dylan,george).
parent(dylan,poppy).
parent(haley,george).
parent(haley,poppy).

parent(mitchell,lily).
parent(mitchell,rexford).
parent(cameron,lily).
parent(cameron,rexford).

parent(bo,calhoun).
parent(pameron,calhoun).

father(X,Y) :- male(X), parent(X,Y).
grandparent(X,Y) :- parent(X,Z), parent(Z,Y).
grandmother(X,Y) :- female(X), grandparent(X,Y).
siblings(X,Y) :-
	parent(Z,X),
	parent(A,X),
	Z @< A,
	parent(Z,Y),
	parent(A,Y),
	X \= Y.
%married(Spouse1, Spouse2, Year).
married(jay,gloria,2008).
maried(jay,dede,1968).
divorced(jay,dede,2003).

are_married(X,Y,Year):-
	married(X,Y,Year1),
	Year1 =< Year,
	divorced(X,Y,Year2),
	Year2 >= Year.
are_married(X,Y,Year):-
	married(X,Y,Year1),
	Year1 =< Year,
	\+divorced(X,Y,_).

% ... The next facts for parent/2 correspond to the children of phil and claire