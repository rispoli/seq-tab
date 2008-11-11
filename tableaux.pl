:- [expansion_rules].
:- [order_tableaux].
:- [shared].

negate_formulae([], []).

negate_formulae([H | T], [~H | T_n]) :-
	negate_formulae(T, T_n).

is_closed(Path, ~P) :-
	!, member(P, Path).

is_closed(Path, P) :-
	!, member(~P, Path).

tableaux(disj, H, H_e, T, New_path, [H | Tree]) :-
	H_e = [Left , Right],
	order([Left | T], Left_o),
	tableaux(New_path, Left_o, Tree_l),
	order([Right | T], Right_o),
	tableaux(New_path, Right_o, Tree_r),
	Tree = [[Tree_l , Tree_r]].

tableaux(none, H, _, T, New_path, Tree) :-
	To_expand_o = T,
	tableaux(New_path, To_expand_o, Tree_t),
	append([H], Tree_t, Tree).

tableaux(_, H, H_e, T, New_path, Tree) :-
	append(T, H_e, To_expand),
	order(To_expand, To_expand_o),
	tableaux(New_path, To_expand_o, Tree_t),
	append([H], Tree_t, Tree).

tableaux(_, [], []).

tableaux(Expanded, [H | _], [H]) :-
	maplist(dneg_e, Expanded, Expanded_d),
	is_closed(Expanded_d, H).

tableaux(Expanded, [H | T], Tree) :-
	expansion_rule(Classification, H, H_e),
	append(Expanded, [H], New_path),
	tableaux(Classification, H, H_e, T, New_path, Tree).

paths_closed(Path, [P]) :-
	!, maplist(dneg_e, Path, Path_d),
	is_closed(Path_d, P).

paths_closed(Path, [L, R]) :-
	paths_closed(Path, L),
	paths_closed(Path, R), !.

paths_closed(Path, [H , T]) :-
	!, append(Path, [H], New_path),
	paths_closed(New_path, T).

paths_closed(Path, [H | T]) :-
	!, append(Path, [H], New_path),
	paths_closed(New_path, T).

tableaux(Set) :-
	negate_formulae(Set, Set_n),
	order(Set_n, Set_n_o),
	tableaux([], Set_n_o, Tree), !,
	paths_closed([], Tree).
