%member1(X,[H|T]) :- H=X.
%member1(X,[H|T]) :- member1(X,T).

member2(X,[X|_]).
member2(X,[_|T]) :- member2(X,T).

%append1(L1,L2,R) :- R=L2.
%append1([H|T],L2,R) :- append1(T,L2,CoadaR), R=[H|CoadaR].

append2(_,L2,L2).
append2([H|T],L2,[H|CoadaR]) :- append2(T,L2,CoadaR).

delete1(X,[X|T],T).
delete1(X,[H|T],[H|R]) :- delete1(X,T,R).
delete1(_,[],[]).

delete_all(X,[X|T],R) :- delete_all(X,T,R).
delete_all(X,[H|T],[H|R]) :- X\=H, delete_all(X,T,R).
delete_all(_,[],[]).

add_first(X,L,R) :- R=[X|L].
add_fisrt(X,L,[X|L]).

append3([H|T],L2,L3,[H|Ri]) :- append3(T,L2,L3,Ri).
append3([],[H|T],L3,[H|Ri]) :- append3([],T,L3,Ri).
append3([],[],L3,L3).

append3_2(L1,L2,L3,R) :- append2(L2,L3,R1), append2(L1,R1,R).

sum_bwd([H|T],S) :- sum_bwd(T,S1), S is S1+H.
sum_bwd([],0).

sum_fwd(L,S) :- sum_fwd_handler(L,0,S).
sum_fwd_handler([H|T],Acc,S) :- Acc1 is Acc+H, sum_fwd_handler(T,Acc1,S).
sum_fwd_handler([],Acc,Acc).

separate_parity_bwd([],[],[]).
separate_parity_bwd([H|T],[H|E],O) :- H mod 2 =:= 0, separate_parity_bwd(T,E,O).
separate_parity_bwd([H|T],E,[H|O]) :- H mod 2 =:= 1, separate_parity_bwd(T,E,O).

separate_parity(L,E,O) :- separate_parity_fwd(L,[],[],E,O).
separate_parity_fwd([],AccE,AccO,AccE,AccO).
separate_parity_fwd([H|T],AccE,AccO,E,O) :- H mod 2 =:= 0, AccE1=[H|AccE], separate_parity_fwd(T,AccE1,AccO,E,O).
separate_parity_fwd([H|T],AccE,AccO,E,O) :- H mod 2 =:= 1, AccO1=[H|AccO], separate_parity_fwd(T,AccE,AccO1,E,O).

replace_all(X,Y,[X|T],[Y|R]) :- replace_all(X,Y,T,R).
replace_all(X,Y,[H|T],[H|R]) :- X\=H, replace_all(X,Y,T,R).
replace_all(_,_,[],[]). 

% element cu element, sterge aparitiile din lista folosind delete_all de unde rezulta lista R1
% se apeleaza recursiv pe lista R1 pentru a continua stergerea duplicatelor
% se adauga elementele pe revenire in R
remove_duplicates([H|T],[H|R]) :- delete_all(H, T, R1), remove_duplicates(R1, R).
remove_duplicates([],[]).

drop_k(L,X,R) :- drop_k_handler(L,X,1,R). % initializam pozitia curenta I cu 1
% daca pozitia curenta este multiplu de X, il stergem adica trecem la urmatorul element si apelam din nou cu pozitia curenta
drop_k_handler([_|T],X,I,R) :- I mod X =:= 0, I1 is I+1, drop_k_handler(T,X,I1,R).
% daca pozitia curenta nu este multiplu de X, trecem la urmatorul element, apelam din nou cu pozitia curenta, iar pe revenire adauga la rezultat
drop_k_handler([H|T],X,I,[H|R]) :- I1 is I+1, drop_k_handler(T,X,I1,R).
drop_k_handler([],_,_,[]).

% daca sunt 2 elemente consecutive egale, se sterge si se continua stergerea elementului respectiv prin apelul recursiv
remove_consecutive_duplicates([H,H|T],R) :- remove_consecutive_duplicates([H|T],R).
% daca sunt 2 elemente consecutive care nu sunt egale, se adauga elementul curent la rezultat si se continua cu stergerea duplicatelor lui H2
remove_consecutive_duplicates([H1,H2|T],[H1|R]) :- H1\=H2, remove_consecutive_duplicates([H2|T],R).
remove_consecutive_duplicates([X],[X]).
remove_consecutive_duplicates([],[]).

% daca sunt 2 elemente consecutive egale, se creeaza o sublista D cu secventa aparitiilor consecutive ale lui H, care se adauga la rezultat
% dupa ce se adauga noua aparitie a elementului, dupa se apeleaza recursiv pentru restul listei, urmatoarele aparitii adaugandu-se la D
pack_consecutive_duplicates([H,H|T],[[H|D]|R]) :- pack_consecutive_duplicates([H|T],[D|R]).
% daca nu sunt 2 elemente consecutive egale, se pune H1 la rezultat avand o singura aparitie consecutiva curenta, apoi se apeleaza recursiv
% pentru aparitiile lui H2 care se vor adauga la R
pack_consecutive_duplicates([H1,H2|T],[[H1]|R]) :- H1\=H2, pack_consecutive_duplicates([H2|T],R).
pack_consecutive_duplicates([X],[[X]]).
pack_consecutive_duplicates([],[]).
