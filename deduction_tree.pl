:- [inference_rules_inf].
:- [order].

is_empty([]).

axiom(Gamma, Delta) :-
	list_to_set(Gamma, G), list_to_set(Delta, D),
	intersection(G, D, I),
	maplist(atom, I),
	\+is_empty(I).

finished(Gamma, Delta) :-
   ( maplist(atom, Gamma), maplist(atom, Delta), ! );
   axiom(Gamma, Delta).

expand_premises([], []).

expand_premises([H | T], [T1 | T2]) :-
	search_nodes(H, T1),
	expand_premises(T, T2).

expand_r(Gamma, Lambda, [Principal | Delta], T) :-
	atom(Principal),
	append(Lambda, [Principal], Lambda1),
	expand_r(Gamma, Lambda1, Delta, T).

expand_r(Gamma, Lambda, [Principal | Delta], [sequent(Gamma, Lambda1), Premises_tree]) :-
	inference_rule(sequent(Gamma, [Lambda, Principal, Delta]), Premises),
	append(Lambda, [Principal | Delta], Lambda1),
	expand_premises(Premises, Premises_tree).

expand_l(Gamma, [], Lambda, T) :-
	order(r, Lambda, Lambda_o),
	expand_r(Gamma, [], Lambda_o, T).

expand_l(Gamma, [Principal | Delta], Lambda, T) :-
	atom(Principal),
	append(Gamma, [Principal], Gamma1),
	expand_l(Gamma1, Delta, Lambda, T).

expand_l(Gamma, [Principal | Delta], Lambda, [sequent(Gamma1, Lambda), Premises_tree]) :-
	inference_rule(sequent([Gamma, Principal, Delta], Lambda), Premises),
	append(Gamma, [Principal | Delta], Gamma1),
	expand_premises(Premises, Premises_tree).

search_nodes(sequent(Gamma, Lambda), [sequent(Gamma, Lambda), []]) :-
	finished(Gamma, Lambda), !.

search_nodes(sequent(Gamma, Lambda), T) :-
	order(l, Gamma, Gamma_o),
	expand_l([], Gamma_o, Lambda, T).

search_leaves([sequent(Gamma, Delta), []]) :-
	!, axiom(Gamma, Delta).

search_leaves([_ | [Premises]]) :-
	maplist(search_leaves, Premises).

search(Sequent) :-
	search_nodes(Sequent, Tree), !,
	search_leaves(Tree).
