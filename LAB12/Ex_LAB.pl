replace_even([H|T],R) :- replace_even([H|T],H,R).
replace_even(L,_,_) :- var(L),!.
replace_even([H|T],H1,[H1|R]) :- H mod 2 =:= 0,!,replace_even(T,H1,R).
replace_even([H|T],H1,[H|R]) :- replace_even(T,H1,R).

tree1(t(6,t(4,t(2,t(1,_,_),_),t(5,_,_)),t(11,t(8,_,t(9,_,_)),t(13,_,_)))). 

replace_with_list(t(K,L,R),NT) :- replace_with_list(L,NL,[K]), replace_with_list(R,NR,[K]), NT = t([K],NL,NR).
replace_with_list(T,nil,_) :- var(T),!.
replace_with_list(t(K,L,R),NT,F) :- replace_with_list(L,NL,[K|F]), replace_with_list(R,NR,[K|F]), NT = t([K|F],NL,NR).

reverse(N,R) :- reverse(N,0,R).
reverse(0,Acc,Acc) :- !.
reverse(N,Acc,R) :- D is N mod 10, Acc1 is Acc*10+D, N1 is N//10, reverse(N1,Acc1,R).

count_lists([],1).
count_lists([H|T],R) :- atomic(H), !, count_lists(T,R).
count_lists([H|T],R) :- count_lists(H,R1), count_lists(T,R2), R is R1+R2.

to_binary(N,R) :- to_binary(N,[],R).
to_binary(0,Acc,Acc) :- !.
to_binary(N,Acc,R) :- B is N mod 2, N1 is N//2, Acc1=[B|Acc], to_binary(N1,Acc1,R).

sum([],0).
sum([H|T],S) :- sum(T,S1), S is S1+H.

numbers([],[]).
numbers([H|T],[HP2|R]) :- H mod 2 =:= 0, !, HP2 is H*H, numbers(T,R).
numbers([H|T],[H2|R]) :- H2 is H*2, numbers(T,R).

separate_parity([],[],[]).
separate_parity([H|T],[H|E],O) :- H mod 2 =:= 0, !, separate_parity(T,E,O).
separate_parity([H|T],E,[H|O]) :- separate_parity(T,E,O).

replace_all(_,_,[],[]).
replace_all(X,Y,[H|T],[H|R]) :- H\=X, !, replace_all(X,Y,T,R).
replace_all(X,Y,[_|T],[Y|R]) :- replace_all(X,Y,T,R).

