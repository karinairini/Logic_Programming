% cmmdc prin scaderi repetate
cmmdc1(X,X,X).
cmmdc1(X,Y,Z) :- X>Y, Diff is X-Y, cmmdc1(Diff,Y,Z).
cmmdc1(X,Y,Z) :- X<Y, Diff is Y-X, cmmdc1(X,Diff,Z).

% cmmds prin impartiri repetate
cmmdc2(X,0,X).
cmmdc2(X,Y,Z) :- Rest is X mod Y, cmmdc2(Y,Rest,Z).

% factorial prin recursivitate inapoi - inmultim pe revenire
fact_bwd(0,1).
fact_bwd(N,F) :- N>0, N1 is N-1, fact_bwd(N1,F1), F is N*F1.

% factorial prin recursivitate inainte - inmultim, apoi mergem pe urmatorul apel
fact_fwd(0,Acc,F) :- F=Acc.
fact_fwd(N,Acc,F) :- N>0, N1 is N-1, Acc1 is Acc*N, fact_fwd(N1,Acc1,F).

% cmmmc = produs/cmmdc
cmmmc(X,Y,Z) :- cmmdc1(X,Y,R), Z1 is X*Y, Z is Z1/R.

% ecuatii de gradul 2
delta(A,B,C,D) :- D is B*B-(4 * A*C).
rad_delta(D,Z) :- Z is sqrt(D).
solve(A,B,C,X) :- delta(A,B,C,D), D>0, rad_delta(D,U), X is (-B + U)/(2*A).
solve(A,B,C,X) :- delta(A,B,C,D), D>0, rad_delta(D,U), X is (B+U)/(2*A).
solve(A,B,C,X) :- delta(A,B,C,D), D=0, X is (-B)/(2*A).

% ridicare la putere prin recursivitate inainte
pow_fwd(_,0,Acc,Acc).
pow_fwd(X,Y,Acc,Z) :- Y>0, Y1 is Y-1, Acc1 is Acc*X, pow_fwd(X,Y1,Acc1,Z).

power_fwd(X,Y,Z):- pow_fwd(X,Y,1,Z).

% ridicare la putere prin recursivitate inapoi
power_bwd(_,0,1).
power_bwd(X,Y,Z) :- Y>0, Y1 is Y-1, power_bwd(X,Y1,Z1), Z is X*Z1.

% fibonacci cu doua apeluri recursive
fib(0,Z) :- Z=0.
fib(1,Z) :- Z=1.
fib(N,Z) :- N>0, N1 is N-1, N2 is N-2, fib(N1,Z1), fib(N2,Z2), Z is Z1+Z2.

% fibonacci cu un singur apel recursiv - trimit informatiile necesare pentru numarul urmator
fib1(0,A,_,A).
fib1(N,A,B,X) :- N>0, N1 is N-1, Sum is A+B, fib1(N1,B,Sum,X).

fib1(N,X) :- fib1(N,0,1,X).

% verificare laturi triunghi
triangle(A,B,C) :- SAB is A+B, SAC is A+C, SBC is B+C, SAB>C, SAC>B, SBC>A.

% for pentru suma numerelor mai mici decat un numar dat
for(Inter,Inter,0).
for(Inter,Out,In) :-
	In>0,
	NewIn is In-1,
	Intermediate is Inter+In,
	for(Intermediate,Out,NewIn).
	
% for pentru suma numerelor mai mici decat un numar dat, dar cu recursivitate ianpoi
for_bwd(0,0).
for_bwd(In,Out) :- 
	In>0,
	NewIn is In-1,
	for_bwd(NewIn,Out1),
	Out is Out1+In.

% bucla while 
while(Low,High,Sum) :- while(Low,High,0,Sum).

while(High,High,Acc,Acc).

while(Low,High,Acc,Sum) :-
    Low<High,
    Acc1 is Acc+Low,
    Low1 is Low+1,
	while(Low1,High,Acc1,Sum).

% bucla do while
dowhile(Low,High,Sum) :- dowhile(Low,High,0,Sum).

dowhile(High,High,Acc,Acc).

dowhile(Low,High,Acc,Sum) :-
	Acc1 is Acc+Low,
	Low1 is Low+1,
	while(Low1,High,Acc1,Sum),
	Low<High.