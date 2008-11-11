:- [inference_rules_inf].
:- [order].

is_empty([]).

atom_n(X) :-
	atom(X).

axiom(Γ, Δ) :-
	list_to_set(Γ, G), list_to_set(Δ, D),
	intersection(G, D, I),
	maplist(atom_n, I),
	\+is_empty(I).

finished(Γ, Δ) :-
   ( maplist(atom_n, Γ), maplist(atom_n, Δ), ! );
   axiom(Γ, Δ).

expand_premises([], []).

expand_premises([H | T], [T1 | T2]) :-
	search_nodes(H, T1),
	expand_premises(T, T2).

expand_r(Γ, Λ, [Principal | Δ], T) :-
	atom_n(Principal),
	append(Λ, [Principal], Λ1),
	expand_r(Γ, Λ1, Δ, T).

expand_r(Γ, Λ, [Principal | Δ], [sequent(Γ, Λ1), Premises_tree]) :-
	inference_rule(sequent(Γ, [Λ, Principal, Δ]), Premises),
	append(Λ, [Principal | Δ], Λ1),
	expand_premises(Premises, Premises_tree).

expand_l(Γ, [], Λ, T) :-
	order(r, Λ, Λ_o),
	expand_r(Γ, [], Λ_o, T).

expand_l(Γ, [Principal | Δ], Λ, T) :-
	atom_n(Principal),
	append(Γ, [Principal], Γ1),
	expand_l(Γ1, Δ, Λ, T).

expand_l(Γ, [Principal | Δ], Λ, [sequent(Γ1, Λ), Premises_tree]) :-
	inference_rule(sequent([Γ, Principal, Δ], Λ), Premises),
	append(Γ, [Principal | Δ], Γ1),
	expand_premises(Premises, Premises_tree).

search_nodes(sequent(Γ, Λ), [sequent(Γ, Λ), []]) :-
	finished(Γ, Λ), !.

search_nodes(sequent(Γ, Λ), T) :-
	order(l, Γ, Γ_o),
	expand_l([], Γ_o, Λ, T).

search_leaves([sequent(Γ, Δ), []]) :-
	!, axiom(Γ, Δ).

search_leaves([_ | [Premises]]) :-
	maplist(search_leaves, Premises).

search(Sequent) :-
	search_nodes(Sequent, Tree), !,
	search_leaves(Tree).
