:- [tableaux].
:- [shared].

get_fun(&, ' &and; ').

get_fun(#, ' &or; ').

get_fun(->, ' &rarr; ').

print_node(A, A_s) :-
	atom(A), !,
	string_concat('', A, A_s).

print_node(~A, A_s) :-
	print_node(A, A_p),
	stringConcat(['&not;', A_p], '', A_s), !.

print_node(A, A_s) :-
	A =.. [F | Args],
	get_fun(F, F_s),
	maplist(print_node, Args, [L, R]),
	stringConcat(['(', L, F_s, R, ')'], '', A_s), !.

new_id(N) :-
	retract(n_id(N0)),
	N is N0 + 1,
	assert(n_id(N)).

is_closed(Path, ~P, N) :-
	!, member(assoc(N, P), Path).

is_closed(Path, P, N) :-
	!, member(assoc(N, ~P), Path).

print_back_arrow(Path, P, My_id) :-
	maplist(dneg_e, Path, Path_d),
	is_closed(Path_d, P, Closed_id),
	format('\t~d -> ~d [ arrowtail = "normal", color = "red" ];~n', [My_id, Closed_id]).

print_back_arrow(_, _, _).

print_tree(_, [], _) :- !.

print_tree(Path, [P], Parent_id) :-
	new_id(My_id), !,
	print_node(P, P_s),
	format('\t~d [ label = "~s" ];~n', [My_id, P_s]),
	format('\t~d -> ~d;~n', [Parent_id, My_id]),
	print_back_arrow(Path, P, My_id).

print_tree(Path, [L, R], Parent_id) :-
	print_tree(Path, L, Parent_id),
	print_tree(Path, R, Parent_id), !.

print_tree(Path, [H , T], Parent_id) :-
	is_list(T),
	new_id(My_id), !,
	append(Path, [assoc(My_id, H)], New_path),
	print_node(H, H_s),
	format('\t~d [ label = "~s" ];~n', [My_id, H_s]),
	format('\t~d -> ~d;~n', [Parent_id, My_id]),
	print_tree(New_path, T, My_id).

print_tree(Path, [H | T], Parent_id) :-
	new_id(My_id), !,
	append(Path, [assoc(My_id, H)], New_path),
	print_node(H, H_s),
	format('\t~d [ label = "~s" ];~n', [My_id, H_s]),
	format('\t~d -> ~d;~n', [Parent_id, My_id]),
	print_tree(New_path, T, My_id).

dottify(Set, Filename) :-
	tell(Filename),
	format('digraph G {~n'),
	maplist(print_node, Set, Set_s),
	join(Set_s, ', ', Set_s_j),
	format('\tlabel = "{~s}";~n', Set_s_j),
	format('\tnode [ shape = "plaintext" ];~n'),
	negate_formulae(Set, Set_n),
	order(Set_n, Set_n_o),
	tableaux([], Set_n_o, [Root | Tree]), !,
	retractall(n_id(_)),
	assert(n_id(0)),
	print_node(Root, Root_s),
	format('\t~d [ label = "~s" ];~n', [0, Root_s]),
	print_tree([assoc(0, Root)], Tree, 0),
	format('}'),
	told.
