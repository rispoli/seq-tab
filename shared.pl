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
