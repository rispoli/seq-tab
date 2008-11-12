:- [deduction_tree].
:- [inference_rules_inf_tab].
:- [shared].

atom_n(~X) :-
	atom(X), !.

atom_n(X) :-
	atom(X).

axiom(Γ, []) :-
	one_sided_axiom(Γ, []).
