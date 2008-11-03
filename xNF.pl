:- [deduction_tree].

% cnf(sequent([], [(~p->q)->(~r->s)]), X).
% dnf(sequent([(~p->q)->(~r->s)],[]),X).

xnf_search_leaves([Sequent, []], Sequent).

xnf_search_leaves([_ | [Premises]], Leaves) :-
	maplist(xnf_search_leaves, Premises, Leaves).

move_propositions(cnf, [sequent([], P)], [P]).

move_propositions(cnf, [sequent([], P) | Sequents], [P | Sequents_m]) :-
	move_propositions(cnf, Sequents, Sequents_m).

move_propositions(cnf, [sequent([H_p | T_p], P) | Sequents], Sequents_m) :-
	move_propositions(cnf, [sequent(T_p, [~H_p | P]) | Sequents], Sequents_m).

move_propositions(dnf, [sequent(P, [])], [P]).

move_propositions(dnf, [sequent(P, []) | Sequents], [P | Sequents_m]) :-
	move_propositions(dnf, Sequents, Sequents_m).

move_propositions(dnf, [sequent(P, [H_p | T_p]) | Sequents], Sequents_m) :-
	move_propositions(dnf, [sequent([~H_p | P], T_p) | Sequents], Sequents_m).

conj([T], T).

conj([H | T], (H & T_d)) :-
	conj(T, T_d).

disj([T], T).

disj([H | T], (H # T_d)) :-
	disj(T, T_d).

xj(XNF_l, XNF, cnf) :-
	maplist(disj, XNF_l, XNF_l_d),
	conj(XNF_l_d, XNF).

xj(XNF_l, XNF, dnf) :-
	maplist(conj, XNF_l, XNF_l_c),
	disj(XNF_l_c, XNF).

xnf(Sequent, XNF, Form) :-
	search_nodes(Sequent, Tree), !,
	xnf_search_leaves(Tree, XNF_n),
	flatten(XNF_n, XNF_f),
	move_propositions(Form, XNF_f, XNF_m),
	xj(XNF_m, XNF, Form).

cnf(Sequent, CNF) :-
	xnf(Sequent, CNF, cnf).

dnf(Sequent, DNF) :-
	xnf(Sequent, DNF, dnf).
