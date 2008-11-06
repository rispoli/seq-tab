:- op(140, fy, ~).				% not
:- op(160, xfy, [&, #, ->]).	% [and, or, implies]

expansion_rule(dneg, ~ ~A, [A]).

expansion_rule(conj, A & B, [A, B]).

expansion_rule(conj, ~(A # B), [~A, ~B]).

expansion_rule(conj, ~(A -> B), [A, ~B]).

expansion_rule(disj, ~(A & B), [~A, ~B]).

expansion_rule(disj, A # B, [A, B]).

expansion_rule(disj, A -> B, [~A, B]).

expansion_rule(none, A, [A]).
