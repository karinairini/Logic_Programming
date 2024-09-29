l1([1,2,3,[4]]).
l2([[1],[2],[3],[4,5]]).
l3([[],2,3,4,[5,[6]],[7]]).
l4([[[[1]]],1,[1]]).
l5([1,[2],[[3]],[[[4]]],[5,[6,[7,[8,[9],10],11],12],13]]).
l6([alpha,2,[beta],[gamma,[8]]]).


max(A,B,A) :- A>B,!.
max(_,B,B).

depth([],1).
depth([H|T],R) :- atomic(H),!,depth(T,R).
depth([H|T],R) :- depth(H,R1),depth(T,R2),R3 is R1+1,max(R3,R2,R).

flatten([],[]).
flatten([H|T],[H|R]) :- atomic(H),!,flatten(T,R).
flatten([H|T],R) :- flatten(H,R1),flatten(T,R2),append(R1,R2,R).

skip1([],[]).
skip1([H|T],R) :- atomic(H),!,skip1(T,R).
skip1([H|T],[H|R]) :- skip1(T,R).

heads1([],[]).
heads1([H|T],[H|R]) :- atomic(H),!,skip1(T,T1),heads1(T1,R).
heads1([H|T],R) :- heads1(H,R1),heads1(T,R2),append(R1,R2,R).

heads2([],[],_).
heads2([H|T],[H|R],1) :- atomic(H),!,heads2(T,R,0).
heads2([H|T],R,0) :- atomic(H),!,heads2(T,R,0).
heads2([H|T],R,_) :- heads2(H,R1,1),heads2(T,R2,0),append(R1,R2,R).

heads2(L,R) :- heads2(L,R,1).

member1(X,L) :- flatten(L,L1),member(X,L1).

member2(X,[X|_]).
member2(X,[H|_]) :- member1(X,H).
member2(X,[_|T]) :- member1(X,T).

count_atomic([],0).
count_atomic([H|T],R) :- atomic(H),!,count_atomic(T,R1),R is R1+1 .
count_atomic([H|T],R) :- count_atomic(H,R1),count_atomic(T,R2),R is R1+R2 .

sum_atomic([],0).
sum_atomic([H|T],S) :- atomic(H),!,sum_atomic(T,S1),S is S1+H .
sum_atomic([H|T],S) :- sum_atomic(H,S1),sum_atomic(T,S2),S is S1+S2 .

member_determinist(X,[X|_]) :- !.
member_determinist(X,[H|_]) :- member_determinist(X,H),!.
member_determinist(X,[_|T]) :- member_determinist(X,T).

replace(_,_,[],[]).
replace(X,Y,[H|T],[H|R]) :- atomic(H),H\=X,!,replace(X,Y,T,R).
replace(X,Y,[H|T],[Y|R]) :- atomic(H),!,replace(X,Y,T,R).
replace(X,Y,[H|T],R) :- replace(X,Y,H,R1),replace(X,Y,T,R2),append([R1],R2,R).

lasts([],[]).
lasts([H],[H|_]) :- atomic(H).
lasts([H|T],R) :- atomic(H),!,lasts(T,R).
lasts([H|T],R) :- lasts(H,R1),lasts(T,R2),append(R1,R2,R),!.

len_con_depth([H|T],R,0) :- \+ atomic(H), len_con_depth(H,R1,0),len_con_depth(T,R2,0),append([R1],R2,R),!.
len_con_depth([H|T],R,L) :- atomic(H),!,L1 is L+1,len_con_depth(T,R,L1).
len_con_depth([H|T],[L|R],L) :- len_con_depth(H,R1,0),len_con_depth(T,R2,0),append([R1],R2,R).
len_con_depth([],[L],L).

len_con_depth(L,R) :- len_con_depth(L,R,0).

depth_con_depth([H|T],R,0) :- \+ atomic(H),depth_con_depth(H,R1,1),depth_con_depth(T,R2,0),append([R1],R2,R),!.
depth_con_depth([H|T],R,D) :- atomic(H),!,depth_con_depth(T,R,D).
depth_con_depth([H|T],[D|R],D) :- D1 is D+1,depth_con_depth(H,R1,D1),depth_con_depth(T,R2,D),append([R1],R2,R).
depth_con_depth([],[D],D).

depth_con_depth(L,R) :- depth_con_depth(L,R,0).