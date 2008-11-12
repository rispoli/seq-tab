stringConcat([], Output, Output).

stringConcat([Head|Tail], TempString, Output) :-
	string_concat(TempString, Head, TempString1),
	stringConcat(Tail, TempString1, Output).

join(List, Separator, Output) :-
	innerJoin(List, Separator, '', Output).

innerJoin([], _, _, '').

innerJoin([Last], _, TempString, Output) :-
	string_concat(TempString, Last, Output).

innerJoin([Head | Tail], Separator, TempString, Output) :-
	stringConcat([Head, Separator], TempString, TempString1),
	innerJoin(Tail, Separator, TempString1, Output).

dneg_e(~ ~A, A_d) :-
	!, dneg_e(A, A_d).

dneg_e(A, A).

one_sided_axiom_m([], [], []).

one_sided_axiom_m([~H | T], G, [H | D]) :-
	!, one_sided_axiom_m(T, G, D).

one_sided_axiom_m([H | T], [H | G], D) :-
	one_sided_axiom_m(T, G, D).

one_sided_axiom(Γ, []) :-
	list_to_set(Γ, G),
	maplist(dneg_e, G, G_dne),
	one_sided_axiom_m(G_dne, G_dne_m, D),
	intersection(G_dne_m, D, I),
	maplist(atom_n, I),
	\+is_empty(I).
