append1([H|T],L2,[H|R]) :- append1(T,L2,R).
append1([],L2,L2).

perm(L,[H|R]) :- append1(A,[H|T],L),append1(A,T,L1),perm(L1,R).
perm([],[]).

is_sorted([H1,H2|T]) :- H1=<H2,!,is_sorted([H2|T]).
is_sorted([_]).

perm_sort(L,R) :- perm(L,R),is_sorted(R),!.

delete1(X,[X|T],T) :- !.
delete1(X,[H|T],[H|R]) :- delete1(X,T,R).
delete1(_,[],[]).

delete2(X,[X|T],T).
delete2(X,[H|T],[H|R]) :- delete2(X,T,R).

min2([H|T],M) :- min2(T,M),M<H,!.
min2([H|_],H).

sel_sort(L,[M|R]) :- min2(L,M),delete1(M,L,L1),sel_sort(L1,R).
sel_sort([],[]).

max2([H|T],M) :- max2(T,M),M>H,!.
max2([H|_],H).

sel_sort_max(L,[M|R]) :- max2(L,M),delete1(M,L,L1),sel_sort_max(L1,R).
sel_sort_max([],[]).

ins_sort([H|T],R) :- ins_sort(T,R1), insert_ord(H,R1,R).
ins_sort([],[]).

insert_ord(X,[H|T],[H|R]) :- X>H,!,insert_ord(X,T,R).
insert_ord(X,T,[X|T]).

bubble_sort(L,R) :- one_pass(L,R1,F),nonvar(F),!,bubble_sort(R1,R).
bubble_sort(L,L).

one_pass([H1,H2|T],[H2|R],F) :- H1>H2,!,F=1,one_pass([H1|T],R,F).
one_pass([H1|T],[H1|R],F) :- one_pass(T,R,F).
one_pass([],[],_).

quick_sort([H|T],R) :-
	partition(H,T,Sm,Lg),
	quick_sort(Sm,SmS),
	quick_sort(Lg,LgS),
	append1(SmS,[H|LgS],R).
quick_sort([],[]).

partition(P,[X|T],[X|Sm],Lg) :- X<P,!,partition(P,T,Sm,Lg).
partition(P,[X|T],Sm,[X|Lg]) :- partition(P,T,Sm,Lg).
partition(_,[],[],[]).

length1([_|T],Len) :- length1(T,Len1),Len is Len1+1.
length1([],0).

split(L,L1,L2) :-
	length1(L,Len),
	Len>1,
	K is Len/2,
	splitK(L,K,L1,L2).

splitK([H|T],K,[H|L1],L2) :- K>0,!,K1 is K-1,splitK(T,K1,L1,L2).
splitK(T,_,[],T).

merge1([H1|T1],[H2|T2],[H1|R]) :- H1<H2,!,merge1(T1,[H2|T2],R).
merge1([H1|T1],[H2|T2],[H2|R]) :- merge1([H1|T1],T2,R).
merge1([],L,L).
merge1(L,[],L).

merge_sort(L,R) :-
	split(L,L1,L2),
	merge_sort(L1,R1),
	merge_sort(L2,R2),
	merge1(R1,R2,R).

merge_sort([H],[H]).
merge_sort([],[]).

bubble_sort_fixed(L,K,R) :- K>0,one_pass(L,R1,F),nonvar(F),!,K1 is K-1,bubble_sort_fixed(R1,K1,R).
bubble_sort_fixed(L,_,L).

sort_chars_ins_sort([H|T],R) :- sort_chars_ins_sort(T,R1),insert_ord_chars(H,R1,R).
sort_chars_ins_sort([],[]).

insert_ord_chars(X,[H|T],[H|R]) :- char_code(X,A1),char_code(H,A2),A1>A2,!,insert_ord_chars(X,T,R).
insert_ord_chars(X,T,[X|T]).

min_chars([H|T],M) :- min_chars(T,M),char_code(M,A1),char_code(H,A2),A1<A2,!.
min_chars([H|_],H).

sort_chars_sel_sort(L,[M|R]) :- min_chars(L,M),delete1(M,L,L1),sort_chars_sel_sort(L1,R).
sort_chars_sel_sort([],[]).

sort_lens_ins_sort([H|T],R) :- sort_lens_ins_sort(T,R1),insert_ord_lens(H,R1,R).
sort_lens_ins_sort([],[]).

insert_ord_lens(X,[H|T],[H|R]) :- length1(X,L1),length1(H,L2),L1>L2,!,insert_ord_lens(X,T,R).
insert_ord_lens(X,T,[X|T]).

min_lens([H|T],M) :- min_lens(T,M),length1(M,L1),length1(H,L2),L1<L2,!.
min_lens([H|_],H).

sort_lens_sel_sort(L,[M|R]) :- min_lens(L,M),delete1(M,L,L1),sort_lens_sel_sort(L1,R).
sort_lens_sel_sort([],[]).

member1(X,[X|_]).
member1(X,[_|T]) :- member1(X,T).

perm1(L,[H|R]) :- member1(H,L),delete1(H,L,L1),perm1(L1,R).
perm1([],[]).

perm2([H|T],R) :- perm2(T,R1),delete2(H,R,R1).
perm2([],[]).

ins_sort_fwd(L,R) :- ins_sort_fwd(L,[],R).
ins_sort_fwd([H|T],Acc,R) :- insert_ord_fwd(H,Acc,[],R1),ins_sort_fwd(T,R1,R).
ins_sort_fwd([],Acc,Acc).

% Acc1 = [], Acc2 va fi lista peste care am trecut, Acc lista ramasa
insert_ord_fwd(X,[H|Acc],Acc1,R) :- X<H,!,append1(Acc1,[H],Acc2),insert_ord_fwd(X,Acc,Acc2,R).
% inseram elementul dupa lista peste care am trecut, lista deja ordonata, elementul si lista neparcursa
insert_ord_fwd(X,Acc,Acc2,R) :- append1(Acc2,[X|Acc],R).