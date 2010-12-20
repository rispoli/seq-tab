:- [deduction_tree].

functor2string(&, ' \\land ').

functor2string(#, ' \\lor ').

functor2string(->, ' \\to ').

proposition2string(~A, String) :-
	proposition2string(A, A_s),
	string_concat('\\lnot ', A_s, String).

proposition2string(B_op, String) :-
	B_op =.. [Functor | Arguments],
	maplist(proposition2string, Arguments, [A_s, B_s]),
	functor2string(Functor, Functor_s),
	stringConcat(['(', A_s, Functor_s, B_s, ')'], '', String).

proposition2string(A, A) :-
	atom(A).

print_sequent(sequent(Γ, Δ)) :-
	maplist(proposition2string, Γ, Γ_s),
	maplist(proposition2string, Δ, Δ_s),
	join(Γ_s, ', ', Γ_s_j),
	join(Δ_s, ', ', Δ_s_j),
	stringConcat([Γ_s_j, ' \\vdash ', Δ_s_j, ' \\ \\ \\ ~n'], '', Sequent_s),
	format(Sequent_s).

print_tree(([S, []], '')) :-
	print_sequent(S).

print_tree(([S, []], Rule)) :-
	format('\\prooftree~n'),
	format('\\justifies~n'),
	print_sequent(S),
	format('\\using~n'),
	stringConcat([Rule, '~n'], '', Rule_n),
	format(Rule_n),
	format('\\endprooftree~n').

print_tree(([Conclusion | [Premises]], Rule)) :-
	format('\\prooftree~n'),
	maplist(print_tree, Premises),
	format('\\justifies~n'),
	print_sequent(Conclusion),
	format('\\using~n'),
	stringConcat([Rule, '~n'], '', Rule_n),
	format(Rule_n),
	format('\\endprooftree~n').

latexify(Sequent, Filename) :-
	tell(Filename),
	format('\\documentclass{article}~n\\pagestyle{empty}~n\\usepackage{prooftree}~n\\usepackage{xspace,amssymb,amsfonts,amsmath,color}~n\\usepackage{mathptmx}~n\\begin{document}~n\\begin{displaymath}~n'),
	search_nodes(Sequent, Tree), !,
	print_tree(Tree),
	format('\\end{displaymath}~n\\end{document}'),
	told.
