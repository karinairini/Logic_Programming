% Predicatul woman/1
woman(ana).
woman(sara).
woman(ema).
woman(maria).
woman(carmen).
woman(dorina).
woman(irina).

% Predicatul man/1
man(andrei).
man(george).
man(alex).
man(marius).
man(mihai).
man(sergiu).

% Predicatul parent/2
parent(maria, ana). % maria este părintele anei
parent(george, ana). % george este părintele anei
parent(maria, andrei).
parent(george, andrei).
parent(marius, maria).
parent(dorina, maria).
parent(mihai, george).
parent(irina, george).
parent(mihai, carmen).
parent(irina, carmen).
parent(carmen, sara).
parent(carmen, ema).
parent(alex, sara).
parent(alex, ema).
parent(sergiu, mihai).

% Predicatul mother/2
mother(X,Y) :- woman(X), parent(X,Y).
% X este mama lui Y, daca X este femeie și X este părintele lui Y

% Predicatul father/2
father(X,Y) :- man(X), parent(X,Y).
% X este tatal lui Y, daca X este barbat si X este parintele lui Y

% Predicatul sibling/2
% X și Y sunt frați/surori dacă au același parinte și X diferit de Y
sibling(X,Y) :- parent(Z,X), parent(Z,Y), X\=Y.

% X și Y sunt frați/surori de mamă, dacă au aceeași mamă și X diferit de Y
siblingM(X,Y) :- mother(Z,X), mother(Z,Y), X\=Y.

% Predicatul sister/2
% X este sora lui Y dacă X este femeie și X și Y sunt frați/surori
sister(X,Y) :- sibling(X,Y), woman(X).

% X este sora de mamă lui Y dacă X este femeie și X și Y sunt frați/surori de mamă
sisterM(X,Y) :- siblingM(X,Y), woman(X).

% Predicatul aunt/2
% X este mătușa lui Y dacă este sora de mamă a lui Z și Z este părintele lui Y 
aunt(X,Y) :- sisterM(X,Z), parent(Z,Y).

brother(X,Y) :- sibling(X,Y), man(X).

brotherM(X,Y) :- siblingM(X,Y), man(X).

uncle(X,Y) :- brotherM(X,Z), parent(Z,Y).

grandmother(X,Y) :- woman(X), parent(X,Z), parent(Z,Y).

grandfather(X,Y) :- man(X), parent(X,Z), parent(Z,Y).

% D este descendent a ancestor-ului A, dacă A este părintele direct a lui D
descendent(D,A):- parent(A,D).
% sau există este o altă legătură de părinte-copil în arborele genealogic
descendent(D,A):- parent(P,D), descendent(P,A).

ancestor(A,D):- descendent(D,A).
