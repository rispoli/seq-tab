:- op(140, fy, ~).				% not
:- op(160, xfy, [&, #, ->]).	% [and, or, implies]

% ∧: left
inference_rule(sequent([Γ, A & B, Δ], Λ), [sequent(Θ, Λ)]) :-
	append(Γ, [A, B | Δ], Θ).

% ∧: right
inference_rule(sequent(Γ, [Δ, A & B, Λ]), [sequent(Γ, Θ), sequent(Γ, Σ)]) :-
	append(Δ, [A | Λ], Θ),
	append(Δ, [B | Λ], Σ).

% ∨: left
inference_rule(sequent([Γ, A # B, Δ], Λ), [sequent(Θ, Λ), sequent(Σ, Λ)]) :-
	append(Γ, [A | Δ], Θ),
	append(Γ, [B | Δ], Σ).

% ∨: right
inference_rule(sequent(Γ, [Δ, A # B, Λ]), [sequent(Γ, Θ)]) :-
	append(Δ, [A, B | Λ], Θ).

% →: left
inference_rule(sequent([Γ, A -> B, Δ], Λ), [sequent(Θ, [A | Λ]), sequent([B | Θ], Λ)]) :-
	append(Γ, Δ, Θ).

% →: right
inference_rule(sequent(Γ, [Δ, A -> B, Λ]), [sequent([A | Γ], [B | Θ])]) :-
	append(Δ, Λ, Θ).

% ¬: left
inference_rule(sequent([Γ, ~A, Δ], Λ), [sequent(Θ, [A | Λ])]) :-
	append(Γ, Δ, Θ).

% ¬: right
inference_rule(sequent(Γ, [Δ, ~A, Λ]), [sequent([A | Γ], Θ)]) :-
	append(Δ, Λ, Θ).
