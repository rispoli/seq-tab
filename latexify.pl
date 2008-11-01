:- [deduction_tree].

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

print_sequent(sequent(Gamma, Delta)) :-
	maplist(proposition2string, Gamma, Gamma_s),
	maplist(proposition2string, Delta, Delta_s),
	join(Gamma_s, ', ', Gamma_s_j),
	join(Delta_s, ', ', Delta_s_j),
	stringConcat([Gamma_s_j, ' \\vdash ', Delta_s_j, ' \\ \\ \\ ~n'], '', Sequent_s),
	format(Sequent_s).

print_tree([S, []]) :-
	print_sequent(S).

print_tree([Conclusion | [Premises]]) :-
	format('\\prooftree~n'),
	maplist(print_tree, Premises),
	format('\\justifies~n'),
	print_sequent(Conclusion),
	format('\\endprooftree~n').

latexify(Sequent, Filename) :-
	tell(Filename),
	format('\\documentclass{article}~n\\pagestyle{empty}~n\\usepackage{prooftree}~n\\usepackage{xspace,amssymb,amsfonts,amsmath,color}~n\\usepackage{mathptmx}~n\\begin{document}~n'),
	search_nodes(Sequent, Tree), !,
	print_tree(Tree),
	format('\\end{document}'),
	told.
