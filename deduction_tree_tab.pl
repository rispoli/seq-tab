:- [deduction_tree].
:- [shared].

atom_n(~X) :-
	atom(X), !.

atom_n(X) :-
	atom(X).

axiom_m([], [], []).

axiom_m([~H | T], G, [H | D]) :-
	!, axiom_m(T, G, D).

axiom_m([H | T], [H | G], D) :-
	axiom_m(T, G, D).

axiom(Γ, []) :-
	list_to_set(Γ, G),
	maplist(dneg_e, G, G_dne),
	axiom_m(G_dne, G_dne_m, D),
	intersection(G_dne_m, D, I),
	maplist(atom_n, I),
	\+is_empty(I).
