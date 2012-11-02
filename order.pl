:- [qsort].

order(l, L, L_o) :-
    qsort(order_l, L, L_o).

order(r, L, L_o) :-
    qsort(order_r, L, L_o).

%left
order_l(_, _ # _).
order_l(_, _ -> _).
order_l(_ # _, _) :- !, fail.
order_l(_ -> _, _) :- !, fail.
order_l(A, B) :- A @=< B.

%right
order_r(_, _ & _).
order_r(_ & _, _) :- !, fail.
order_r(A, B) :- A @=< B.
