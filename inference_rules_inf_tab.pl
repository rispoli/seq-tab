:- op(140, fy, ~).				% not
:- op(160, xfy, [&, #, ->]).	% [and, or, implies]

% ∧: left
inference_rule(sequent([Γ, A & B, Δ], []), [sequent(Θ, [])]) :-
	append(Γ, [A, B | Δ], Θ).

% ∧: right
inference_rule(sequent([Δ, ~(A & B), Λ], []), [sequent(Θ, []), sequent(Σ, [])]) :-
	append(Δ, [~A | Λ], Θ),
	append(Δ, [~B | Λ], Σ).

% ∨: left
inference_rule(sequent([Γ, A # B, Δ], []), [sequent(Θ, []), sequent(Σ, [])]) :-
	append(Γ, [A | Δ], Θ),
	append(Γ, [B | Δ], Σ).

% ∨: right
inference_rule(sequent([Δ, ~(A # B), Λ], []), [sequent(Θ, [])]) :-
	append(Δ, [~A, ~B | Λ], Θ).

% →: left
inference_rule(sequent([Γ, A -> B, Δ], []), [sequent([~A | Θ], []), sequent([B | Θ], [])]) :-
	append(Γ, Δ, Θ).

% →: right
inference_rule(sequent([Δ, ~(A -> B), Λ], []), [sequent([A, ~B | Θ], [])]) :-
	append(Δ, Λ, Θ).

% ¬¬ elimination
inference_rule(sequent([Γ, ~ ~A, Δ], []), [sequent(Θ, [])]) :-
	append(Γ, [A | Δ], Θ).
