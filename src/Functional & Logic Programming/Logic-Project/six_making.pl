:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(system)).

%these functions are for building the initial matrix with variable size
build_board(_,0,_,B,B).
build_board(W,H,Board,FB,FFB):-
	H > 0,
	build_row(W,Board,B1),
	H1 is H-1,
	append(FB,[B1],FB1),
	build_board(W,H1,Board,FB1,FFB).

build_row(0,B,B).
build_row(W,Board,FB):-
	W > 0,
	append(Board,[[]],B1),
	W1 is W - 1,
	build_row(W1,B1,FB).

/*Initializes the count of disks per color*/
initialize_count(W, H, N):-
	H > W, N is 4*(H-1).
initialize_count(W, H, N):-
	W >= H, N is 4*(W-1).
	
%checks if a tile has exactly 6 pieces, if so the game is over
game_over(Tile,B):-
	length(Tile,6),
	Tile = [_,_,_,_,_|R],
	display_game(B),
	write('Winner is '),print(R),nl,
	throw('Match Over!').
game_over(Tile,_):-
	length(Tile,N),
	N<6.
 
/*Checks if a move is valid for each type of tower*/
valid_move_pawn(B,I,J,NI,NJ,1):- NI is I+1,NJ is J,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_pawn(B,I,J,NI,NJ,1):- NI is I,NJ is J-1,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_pawn(B,I,J,NI,NJ,1):- NI is I,NJ is J+1,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_pawn(B,I,J,NI,NJ,1):- NI is I-1,NJ is J,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_pawn(_,_,_,_,_,0).


valid_move_rook(B,I,J,I,NJ,1):- J \= NJ,replace_m_n(B, I, NJ,O, _, _),length(O,N),N>0.
valid_move_rook(B,I,J,NI,J,1):- I \= NI,replace_m_n(B, NI, J,O, _, _),length(O,N),N>0.
valid_move_rook(_,_,_,_,_,0).

valid_move_knight(B,I,J,NI,NJ,1):- NI is I+2,NJ is J+1,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_knight(B,I,J,NI,NJ,1):- NI is I+2,NJ is J-1,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_knight(B,I,J,NI,NJ,1):- NI is I-2,NJ is J+1,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_knight(B,I,J,NI,NJ,1):- NI is I-2,NJ is J-1,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_knight(B,I,J,NI,NJ,1):- NI is I+1,NJ is J-2,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_knight(B,I,J,NI,NJ,1):- NI is I+1,NJ is J+2,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_knight(B,I,J,NI,NJ,1):- NI is I-1,NJ is J-2,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_knight(B,I,J,NI,NJ,1):- NI is I-1,NJ is J+2,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_knight(_,_,_,_,_,0).

absolute(A,B,T):-
	A < B,
	T is B - A.
absolute(A,B,T):-
	A >= B,
	T is A - B.

valid_move_bishop(B,I,J,NI,NJ,1):- absolute(I,NI,T),I\=NI,NJ is J + T,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_bishop(B,I,J,NI,NJ,1):- absolute(I,NI,T),I\=NI,NJ is J - T,replace_m_n(B, NI, NJ,O, _, _),length(O,N),N>0.
valid_move_bishop(_,_,_,_,_,0).

%these functions are for checking if a move is valid, the last argument is 1 if yes, 0 if no
validate_move(FullBoard,1,I,J,NI,NJ,AuxList,UpdatedList):-
    valid_move_pawn(FullBoard,I,J,NI,NJ,1),
	append(AuxList,[[I,J,NI,NJ]],UpdatedList).
validate_move(_,1,_,_,_,_,AuxList,AuxList).
validate_move(FullBoard,2,I,J,NI,NJ,AuxList,UpdatedList):-
    valid_move_rook(FullBoard,I,J,NI,NJ, 1),
	append(AuxList,[[I,J,NI,NJ]],UpdatedList).
validate_move(_,2,_,_,_,_,AuxList,AuxList).
validate_move(FullBoard,3,I,J,NI,NJ,AuxList,UpdatedList):-
    valid_move_knight(FullBoard,I,J,NI,NJ,1),
	append(AuxList,[[I,J,NI,NJ]],UpdatedList).
validate_move(_,3,_,_,_,_,AuxList,AuxList).
validate_move(FullBoard,4,I,J,NI,NJ,AuxList,UpdatedList):-
    valid_move_bishop(FullBoard,I,J,NI,NJ,1),
	append(AuxList,[[I,J,NI,NJ]],UpdatedList).
validate_move(_,4,_,_,_,_,AuxList,AuxList).
validate_move(FullBoard,5,I,J,NI,NJ,AuxList,UpdatedList):-
	valid_move_bishop(FullBoard,I,J,NI,NJ,1),
	append(AuxList,[[I,J,NI,NJ]],UpdatedList).
validate_move(FullBoard,5,I,J,NI,NJ,AuxList,UpdatedList):-
	valid_move_rook(FullBoard,I,J,NI,NJ,1),
	append(AuxList,[[I,J,NI,NJ]],UpdatedList).
validate_move(_,5,_,_,_,_,AuxList,AuxList).

%these are the functions for getting possible moves from a specific tile
get_moves(N,FullBoard,MovesList,R,C):-
	get_moves_recursive(FullBoard,N,[],MovesList,FullBoard,R,C,0,0).
get_moves_recursive(_,_,L,L,[],_,_,_,_).
get_moves_recursive(FullBoard,N,AuxList,FinalList,[H|T],R,C,R1,C1):-
	get_moves_recursive_2(FullBoard,N,H,AuxList,NewRowList,R,C,R1,C1),
	R2 is R1 + 1,
	get_moves_recursive(FullBoard,N,NewRowList,FinalList,T,R,C,R2,0).

get_moves_recursive_2(_,_,[],L,L,_,_,_,_).
get_moves_recursive_2(FullBoard,N,Row,AuxList,NewRowList,R,C,R1,C1):-
	C2 is C1 + 1,
	Row = [_|T],%this is where will check if fits
	validate_move(FullBoard,N,R,C,R1,C1,AuxList,UpdatedList),
	get_moves_recursive_2(FullBoard,N,T,UpdatedList,NewRowList,R,C,R1,C2).
%these function return a list of all possible moves in the current state
valid_moves(Board,List):-
	valid_moves_aux(Board,Board,[],List,0,0).

valid_moves_aux(_,[],L,L,_,_).
valid_moves_aux(FullBoard,[H|T],AuxList,List,R,C):-
	valid_moves_row(FullBoard,H,AuxList,NewRowList,List,R,C),
	R1 is R+1,
	valid_moves_aux(FullBoard,T,NewRowList,List,R1,0).
valid_moves_row(_,[],L,L,_,_,_).
valid_moves_row(FullBoard,[H|T],AuxList,NewRowList,List,R,C):-
	length(H,N),
	valid_moves_tile(FullBoard,AuxList,NewList,N,R,C),
	C1 is C+1,
	valid_moves_row(FullBoard,T,NewList,NewRowList,List,R,C1).
 valid_moves_tile(_,AuxList,NewList,0,R,C):-
	 append(AuxList,[[100,100,R,C]],NewList).
valid_moves_tile(Board,AuxList,NewList,N,R,C):-
	N \= 0,
	get_moves(N,Board,MovesList,R,C),
	append(AuxList,MovesList,NewList).



%these functions are necessary to print the board nicely
display_game([H|T]):-
	length(H,N),
	write(' |'),
	print_top(N,N),
	print_matrix([H|T],0).
print_top(_,0):- nl.
print_top(C,N):-
	N > 0,
	DisplayN is C - N,
	write('   '),write(DisplayN),write('  |'),
	N1 is N-1,
	print_top(C,N1).
print_matrix([],_).
print_matrix([H|T],N) :- 
	write(N),write('|'),
	N1 is N +1,
	print_row(H), nl, 
	print_matrix(T,N1).

print_row([]).
print_row([H|T]) :- 
	print_cell(H,6),
	write('|'),
	print_row(T).
print_cell([],0).
print_cell([],N):-
	N >0,
	write(' '),
	N1 is N-1,
	print_cell([],N1).
print_cell([H|T],N):-
	N>0,
	write(H),
	N1 is N-1,
	print_cell(T,N1).

%essential functions used for both replacing a tile and just getting its value
replace_nth(N, OldElem, NewElem, List, List2) :-
    length(L1, N),
    append(L1, [OldElem|Rest], List),
    append(L1, [NewElem|Rest], List2).
replace_m_n(Matrix, I, J,OldValue, NewValue, NewMatrix) :-
    replace_nth(I, Old1, New1, Matrix, NewMatrix),
    replace_nth(J, OldValue, NewValue, Old1, New1).

%the generic place function for all types of players, takes board,color and position and returns new board and color
place_function_input(Board,Color,Count,NewCount,Board1,Color1,O1,O2,O1N,O2N):-
	Count > 0,
	NewCount is Count -1,
	write('Input row'), nl,
	read(R),
	write('Input column'), nl,
	read(C),
	place_function(Board,Color,Board1,Color1,R,C,O1,O2,O1N,O2N).
place_function(Board,Color,Board1,Color1,R,C,O1,O2,O1N,O2N):-
	valid_moves(Board,List),
	member([100,100,R,C],List),
	replace_m_n(Board,R,C,_,[Color],Board1),
	change_color(Color,Color1),
	O1N = O2,O2N = O1.
place_function(Board,Color,Board,Color,_,_,O1,O2,O1N,O2N):- O1N = O1,O2N = O2,write('Tile is full!'),nl.

%the next three functions use recursion to move N pieces from Allpieces to V2, keep the rest in V1
split_pieces(AllPieces,N,V1,V2):-
	length(AllPieces,Count),
	Count1 is Count - N,
	split_pieces_aux([],AllPieces,Count1,V1,V2).

split_pieces_aux(F,F1,0,F,F1).
split_pieces_aux(NewPieces,[H|T],N,V1,V2):-
	N > 0,
	N1 is N-1,
	append(NewPieces,[H],NP2),
	split_pieces_aux(NP2,T,N1,V1,V2).
%move function for player input
move_function_input(Board,Color,Board2,Color1,O1,O2,O1N,O2N):-
	write('Input original row'), nl,
	read(R),
	write('Input original column'), nl,
	read(C),
	write('Input destination row'), nl,
	read(R1),
	write('Input destination column'), nl,
	read(C1),
	write('Input amount of pieces'), nl,
	read(N),
	move_function(Board,Color,Board2,Color1,R,C,R1,C1,N,O1,O2,O1N,O2N).
%the generic move function for all types of players, takes board,color, starting position, ending position and number of pieces and returns new board and color
move_function(Board,Color,Board2,Color1,R,C,R1,C1,N,O1,O2,O1N,O2N):-
	valid_moves(Board,List),
	member([R,C,R1,C1],List),
	replace_m_n(Board,R,C,OldValue,_,_),
	replace_m_n(Board,R1,C1,OldValue2,_,_),
	split_pieces(OldValue,N,KeptPieces,MovedPieces),
	append(OldValue2,MovedPieces,FinalValue),
	replace_m_n(Board,R1,C1,_,FinalValue,Board1),
	replace_m_n(Board1,R,C,_,KeptPieces,Board2),
	game_over(FinalValue,Board2),
	change_color(Color,Color1),
	O1N = O2, O2N = O1.
move_function(Board,Color,Board,Color,_,_,_,_,_,O1,O2,O1N,O2N):-
	O1N = O1, O2N = O2,
	write('Move not allowed!'),nl.
%simple function to switch colors
change_color('b','w').
change_color('w','b').
%function check_action verifies player input and proceeds to the place or move function or ends the game
check_action(0,_,_,_,_,_,_):-
	throw('Match Stopped!').
check_action(1,Board,'w',WCount,BCount,O1,O2):-
	place_function_input(Board,'w',WCount,NewCount,Board1,Color1,O1,O2,O1N,O2N),
	make_move(Board1,Color1,NewCount,BCount,O1N,O2N).
check_action(1,Board,'b',WCount,BCount,O1,O2):-
	place_function_input(Board,'b',BCount,NewCount,Board1,Color1,O1,O2,O1N,O2N),
	make_move(Board1,Color1,WCount,NewCount,O1N,O2N).
check_action(2,Board,Color,WCount,BCount,O1,O2):-
	move_function_input(Board,Color,Board1,Color1,O1,O2,O1N,O2N),
	make_move(Board1,Color1,WCount,BCount,O1N,O2N).
%function check_dumb_bot_action routes the choice of the dumb bot to the generic version of either the move or place function
check_dumb_bot_action([100,_,NI,NJ],Board,'w',WCount,BCount,O1,O2):-
	place_function(Board,'w',Board1,Color1,NI,NJ,_,_,_,_),
	NewCount is WCount - 1,
	write('Dumb Bot placed piece on Row '),write(NI),write(' Column '),write(NJ),nl,
	make_move(Board1,Color1,NewCount,BCount,O2,O1).
check_dumb_bot_action([100,_,NI,NJ],Board,'b',WCount,BCount,O1,O2):-
	place_function(Board,'b',Board1,Color1,NI,NJ,_,_,_,_),
	NewCount is BCount - 1,
	write('Dumb Bot placed piece on Row '),write(NI),write(' Column '),write(NJ),nl,
	make_move(Board1,Color1,WCount,NewCount,O2,O1).
check_dumb_bot_action([I,J,NI,NJ],Board,Color,WCount,NewCount,O1,O2):-
	replace_m_n(Board,I,J,OldValue,_,_),
	length(OldValue,N),
	N1 is N+1,
	random(1,N1,N2),
	move_function(Board,Color,Board1,Color1,I,J,NI,NJ,N2,_,_,_,_),
	write('Dumb Bot moved '),write(N2),write(' pieces from Row '),write(I),write(' Column '),write(J),write(' to Row '),write(NI),write(' Column '),write(NJ),nl,
	make_move(Board1,Color1,WCount,NewCount,O2,O1).
%function check_smart_bot_action routes the choice of the smart bot to it's equivalent in do_smart_bot_action
check_smart_bot_action(Board,Color,WCount,BCount,O2):-
	valid_moves(Board,List),
	evaluate_moves(Board,[],List,RatedList,Color),
	sort(RatedList,[H|_]),
	do_smart_bot_action(Board,Color,WCount,BCount,H,O2).
%function check_dumb_bot_action routes the choice of the dumb bot to the generic version of either the move or place function
do_smart_bot_action(Board,'w',WCount,BCount,H,O2):-
	H = [_,A,_,C,D],
	A = 100,
	place_function(Board,'w',Board1,Color1,C,D,_,_,_,_),
	write('Smart Bot placed piece on Row '),write(C),write(' Column '),write(D),nl,
	NewCount is WCount - 1,
	make_move(Board1,Color1,NewCount,BCount,O2,3).
do_smart_bot_action(Board,'b',WCount,BCount,H,O2):-
	H = [_,A,_,C,D],
	A = 100,
	place_function(Board,'b',Board1,Color1,C,D,_,_,_,_),
	write('Smart Bot placed piece on Row '),write(C),write(' Column '),write(D),nl,
	NewCount is BCount - 1,
	make_move(Board1,Color1,WCount,NewCount,O2,3).
do_smart_bot_action(Board,Color,WCount,BCount,H,O2):-
	H = [V,A,B,C,D],
	A \= 100,
	replace_m_n(Board,A,B,OldValue,_,_),
	length(OldValue,N),
	move_function(Board,Color,Board1,Color1,A,B,C,D,N,_,_,_,_),
	write('Smart Bot moved '),write(N),write(' pieces from Row '),write(A),write(' Column '),write(B),write(' to Row '),write(C),
	write(' Column '),write(D),write(' with value '),write(V),nl,
	make_move(Board1,Color1,WCount,BCount,O2,3).
%recursive function that returns in RatedList a copy of the original list but with evaluation of the move at the start
evaluate_moves(_,L,[],L,_).
evaluate_moves(Board,AuxList,List,RatedList,Color):-
	List = [H|T],
	value(Board,H,M,Color),
	append(AuxList,[M],NewList),
	evaluate_moves(Board,NewList,T,RatedList,Color).
%function value determines the value of a move and adding it to the start of H, returning it in M
value(Board,H,M,Color):-
	H = [A,B,C,D],
	replace_m_n(Board,A,B,OldValue,_,_),
	replace_m_n(Board,C,D,OldValue2,_,_),
	length(OldValue,N),
	nth1(N,OldValue,Color),
	length(OldValue2,N2),
	6 is N + N2,
	%write('win'),write(H),nl,
	append([1],H,M).
value(_,H,M,_):- H = [100|_], append([10],H,M).
value(Board,H,M,Color):-
	H = [A,B,_,_],
	replace_m_n(Board,A,B,OldValue,_,_),
	length(OldValue,N),
	nth1(N,OldValue,Top),
	Top \= Color,
	%write('bad'),write(H),nl,
	append([20],H,M).
value(Board,H,M,Color):-
	H = [A,B,C,D],
	replace_m_n(Board,A,B,OldValue,_,_),
	replace_m_n(Board,C,D,NewValue,_,_),
	length(OldValue,N),
	length(NewValue,N1),
	 V is 10 - N1 - N,
	6 > N + N1,
	nth1(N,OldValue,Top),
	Top = Color,
	%write('good'),write(H),nl,
	append([V],H,M).
%this is the main function for taking turns, split into three: one for the player and one for each bot
make_move(Board,Color,WCount,BCount,1,O2):-
	display_game(Board),
	write('Current color is: '),write(Color),nl,
	write('Input 0 to end match'), nl,
	write('Input 1 for adding a piece'), nl,
	write('Input 2 for moving a piece'), nl,
	write('W/B piece count is: '),write(WCount),write('/'),write(BCount),nl,
	read(I),
	check_action(I,Board,Color,WCount,BCount,1,O2).
make_move(Board,Color,WCount,BCount,2,O2):-
	sleep(1),
	display_game(Board),
	valid_moves(Board,List),
	length(List,N),
	random(0,N,N1),
	nth0(N1,List,N2),
	check_dumb_bot_action(N2,Board,Color,WCount,BCount,2,O2).
make_move(Board,Color,WCount,BCount,3,O2):-
	sleep(1),
	display_game(Board),
	check_smart_bot_action(Board,Color,WCount,BCount,O2).

%input function to choose opponents
get_opponents(O1,O2):-
	write('Choose first player:'), nl,
	write('Input 1 for human'), nl,
	write('Input 2 for dumb bot'), nl,
	write('Input 3 for smart bot'), nl,
	read(O1),
	write('Choose second player:'), nl,
	write('Input 1 for human'), nl,
	write('Input 2 for dumb bot'), nl,
	write('Input 3 for smart bot'), nl,
	read(O2),
	O1<4,0 < O1,0 < O2,O2<4.

% this is the main predicate	
play:-
	write('Starting Match!'), nl,
	get_opponents(O1,O2),
	write('Input board width'), nl,
	read(W),
	write('Input board height'), nl,
	read(H),
	build_board(W,H,[],[],Board),
	initialize_count(W,H,N),
	make_move(Board,'w',N,N,O1,O2).