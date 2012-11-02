:- op(140, fy, ~).                % not
:- op(160, xfy, [&, #, ->]).    % [and, or, implies]

% ∧: left
inference_rule(sequent([Γ, A & B, Δ], Λ), [sequent(Θ, Λ)], '(\\land L)') :-
    append(Γ, [A, B | Δ], Θ).

% ∧: right
inference_rule(sequent(Γ, [Δ, A & B, Λ]), [sequent(Γ, Θ), sequent(Γ, Σ)], '(\\land R)') :-
    append(Δ, [A | Λ], Θ),
    append(Δ, [B | Λ], Σ).

% ∨: left
inference_rule(sequent([Γ, A # B, Δ], Λ), [sequent(Θ, Λ), sequent(Σ, Λ)], '(\\lor L)') :-
    append(Γ, [A | Δ], Θ),
    append(Γ, [B | Δ], Σ).

% ∨: right
inference_rule(sequent(Γ, [Δ, A # B, Λ]), [sequent(Γ, Θ)], '(\\lor R)') :-
    append(Δ, [A, B | Λ], Θ).

% →: left
inference_rule(sequent([Γ, A -> B, Δ], Λ), [sequent(Θ, [A | Λ]), sequent([B | Θ], Λ)], '(\\to L)') :-
    append(Γ, Δ, Θ).

% →: right
inference_rule(sequent(Γ, [Δ, A -> B, Λ]), [sequent([A | Γ], [B | Θ])], '(\\to R)') :-
    append(Δ, Λ, Θ).

% ¬: left
inference_rule(sequent([Γ, ~A, Δ], Λ), [sequent(Θ, [A | Λ])], '(\\lnot L)') :-
    append(Γ, Δ, Θ).

% ¬: right
inference_rule(sequent(Γ, [Δ, ~A, Λ]), [sequent([A | Γ], Θ)], '(\\lnot R)') :-
    append(Δ, Λ, Θ).
