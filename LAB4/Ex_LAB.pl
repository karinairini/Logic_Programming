member1(X,[X|_]) :- !.
member1(X,[_|T]) :- member1(X,T).

intersect([],_,[]).
intersect([H|T],L2,[H|R]) :- member1(H,L2),!,intersect(T,L2,R).
intersect([_|T],L2,R) :- intersect(T,L2,R).

diff([],_,[]).
diff([H|T],L2,R) :- member1(H,L2),!,diff(T,L2,R).
diff([H|T],L2,[H|R]) :- diff(T,L2,R).

union([],L,L).
union([H|T],L2,R) :- member(H,L2),!,union(T,L2,R).
union([H|T],L2,[H|R]) :- union(T,L2,R).

min_fwd([],Mp,Mp).
min_fwd([H|T],Mp,M) :- H<Mp,!,min_fwd(T,H,M).
min_fwd([_|T],Mp,M) :- min_fwd(T,Mp,M).

min_fwd_pretty([H|T],M) :- min_fwd(T,H,M).

min2([H|T],M) :- min2(T,M),M<H,!.
min2([H|_],H).

max_fwd([],Mp,Mp).
max_fwd([H|T],Mp,M) :- H>Mp,!,max_fwd(T,H,M).
max_fwd([_|T],Mp,M) :- max_fwd(T,Mp,M).

max_fwd_pretty([H|T],M) :- max_fwd(T,H,M).

max2([H|T],M) :- max2(T,M),M>H,!.
max2([H|_],H).

delete1(_,[],[]).
delete1(X,[X|T],T) :- !.
delete1(X,[H|T],[H|R]) :- delete1(X,T,R).

delete_all(_,[],[]).
delete_all(X,[X|T],R) :- !,delete_all(X,T,R).
delete_all(X,[H|T],[H|R]) :- delete_all(X,T,R).

del_min1(L,R) :- min2(L,M), delete_all(M,L,R).

del_max1(L,R) :- max2(L,M), delete_all(M,L,R).

%del_min(L,Mp,M,R)
del_min2([],Mp,Mp,[]).
del_min2([H|T],Mp,M,[H|R]) :- H=<Mp,del_min2(T,H,M,R),M\=H,!.
del_min2([H|T],Mp,M,R) :- H=<Mp,!,del_min2(T,H,M,R).
del_min2([H|T],Mp,M,[H|R]) :- del_min2(T,Mp,M,R).

del_min_h([H|T],R) :- del_min2([H|T],H,_,R).

%del_max(L,Mp,M,R)
del_max2([],Mp,Mp,[]).
del_max2([H|T],Mp,M,[H|R]) :- H>=Mp,del_max2(T,H,M,R),M\=H,!.
del_max2([H|T],Mp,M,R) :- H>=Mp,!,del_max2(T,H,M,R).
del_max2([H|T],Mp,M,[H|R]) :- del_max2(T,Mp,M,R).

del_max_h([H|T],R) :- del_max2([H|T],H,_,R).

length_bwd([],0).
length_bwd([_|T],Len) :- length_bwd(T,Len1), Len is Len1+1.

length_fwd([],Acc,Acc).
length_fwd([_|T],Acc,Len) :- Acc1 is Acc+1, length_fwd(T,Acc1,Len).

append1([],L2,L2).
append1([H|T],L2,[H|R]) :- append1(T,L2,R).

reverse_bwd([],[]).
reverse_bwd([H|T],R) :- reverse_bwd(T,Rcoada), append1(Rcoada,[H],R).

reverse_fwd([],Acc,Acc).
reverse_fwd([H|T],Acc,R) :- Acc1=[H|Acc],reverse_fwd(T,Acc1,R).
reverse_fwd_pretty(L,R) :- reverse_fwd(L,[],R).

% Atunci cand ajung la lista vida, initalizez rezultatul la lista vida
reverse_k([],_,[]).
% Cand ajung la indicele de la care trebuie sa inversez, continui pe lista, iar pe revenire invers adaug elementele la rezultat
reverse_k([H|T],K,R) :- K=0,!,reverse_k(T,K,R_reverse),append1(R_reverse,[H],R).
% Inca nu am ajuns la al k-lea indice de la care invers, scad indicele, continui pe lista, iar pe revenire adaug elementele la rezultat
reverse_k([H|T],K,[H|R]) :- K1 is K-1, reverse_k(T,K1,R).

% Cand mai este un sigur element, reultatul este [H,NbAp]
rle_encode1([H|[]],NbAp,[[H,NbAp]]).
% Cand sunt 2 elemente consecutive egale, se incrementeaza numarul de aparitii consecutive, se continua pe lista cu acelasi element 
% si numarul nou de aparitii
rle_encode1([H,H|T],NbAp,R) :- !,NbApNew is NbAp+1,rle_encode1([H|T],NbApNew,R).
% Cand nu sunt 2 elemente consecutive egale, se adauga rezultatul de pana acum la rezultat cu numarul de aparitii curent aferent lui
% se continua pe lista cu elementul urmator, numarul de aparitii fiind resetat la 1
rle_encode1([H1,H2|T],NbAp,[[H1,NbAp]|R]) :- rle_encode1([H2|T],1,R).

rle_encode_h1(L,R) :- rle_encode1(L,1,R).

% Cand este un singur element cu o aparitie, adauga elementul simplu
% Clauza care acopera cazul in care nu mai urmeaza elemente dupa, celelalte acorperind doar cand cel putin 2 elemente in lista
rle_encode2([H|[]],1,[H]) :- !.
rle_encode2([H|[]],NbAp,[[H,NbAp]]).
rle_encode2([H,H|T],NbAp,R) :- !,NbApNew is NbAp+1,rle_encode2([H|T],NbApNew,R).
% Cand nu sunt 2 elemente consecutive egale si numarul de aparitii ale elementului curent este diferit de 1
% se continua pe lista cu urmatorul element, iar pe revenire, se adauga elementul cu numarul de aparitii la rezultat
rle_encode2([H1,H2|T],NbAp,[[H1,NbAp]|R]) :- NbAp\=1,!,rle_encode2([H2|T],1,R).
% Cand nu sunt 2 elemente consecutive egale si numarul de aparitii ale elementului curent este 1, se continua pe lista
% cu urmatorul element, iar pe revenire, se adauga doar elementul la rezultat
rle_encode2([H1,H2|T],_,[H1|R]) :- rle_encode2([H2|T],1,R).

rle_encode_h2(L,R) :- rle_encode2(L,1,R).

% Generez o lista vida cu K elemente L2, L2+L1=L => L2 o sa fie primele K elemente din lista, L1 restul elementelor
% apoi la L1 (ultimele elemete) adaug L2 (primele k elemente)
rotate_left(L,K,R) :- length_bwd(L2,K),append1(L2,L1,L),append1(L1,L2,R),!.

% Generez o lista vida cu K elemente L2, L1+L2=L => L2 o sa fie ultimele K elemente din lista, L1 primele elemente
% apoi L2 (ultimele k elemente) adaug L1 (primele elemente)
rotate_right(L,K,R) :- length_bwd(L2,K),append1(L1,L2,L),append1(L2,L1,R),!.

replicate(_,0,[]).
replicate(X,NbAp,[X|R]) :- NbApNew is NbAp-1,replicate(X,NbApNew,R).

rle_decode([],[]).
rle_decode([[X,NbAp]|T],R) :- replicate(X,NbAp,R1),rle_decode(T,R2),append1(R1,R2,R).

take_k(_,0,[]).
take_k([H|T],K,[H|R]) :- Knew is K-1,take_k(T,Knew,R).

take_nth1([H|_],CurrentN,CurrentN,H).
take_nth1([_|T],N,CurrentN,R) :- CurrentNNew is CurrentN+1, take_nth1(T,N,CurrentNNew,R).

take_nth_pretty1(L,N,R) :- take_nth1(L,N,1,R).

take_nth2([H|_],1,H).
take_nth2([_|T],N,R) :- NNew is N-1, take_nth2(T,NNew,R).

% Calculez lungimea listei curente, iau un indice cu random_between, iau elementul de la pozitia random, il sterg din lista
% scad numarul de elemente pe care trebuie sa le iau, merg pe lista rezultata dupa stergere cu noul numar de elemente, iar pe
% revenire adaug elementele
rnd_select(_,0,[]).
rnd_select(L,K,R) :-
	length_bwd(L,Len),
    random_between(1,Len,Random),
    take_nth2(L,Random,Element),
    delete1(Element,L,NewL),
    Knew is K-1,
    rnd_select(NewL,Knew,R1),
    R=[Element|R1].