:- [qsort].

order(Formulae, Formulae_o) :-
	qsort(order_p, Formulae, Formulae_q),
	list_to_set(Formulae_q, Formulae_o).

order_p(_, ~(_ & _)).
order_p(_, _ # _).
order_p(_, _ -> _).
order_p(~(_ & _), _) :- !, fail.
order_p(_ # _, _) :- !, fail.
order_p(_ -> _, _) :- !, fail.
order_p(A, B) :- A @=< B.
