% fluent(inertial, Fluent)
% fluent(defined, Fluent)
% aciton(Action)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Inertia axiom %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(Fluent, Timestep + 1) :-
    fluent(inertial, Fluent),
    holds(Fluent, Timestep),
    not -holds(Fluent, Timestep + 1).

-holds(Fluent, Timestep + 1) :-
    fluent(inertial, Fluent),
    -holds(Fluent, Timestep),
    not holds(Fluent, Timestep + 1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Closed-world assumption for defined fluents %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-holds(Fluent, Timestep) :-
    fluent(defined, Fluent),
    not holds(Fluent, Timestep).

holds(Fluent, Timestep) :-
    fluent(defined_negative, Fluent),
    not -holds(Fluent, Timestep).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Closed-world assumption for actions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-occurs(Action, Timestep) :-
    action(Action),
    not occurs(Action, Timestep).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Timestep %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

step(Timestep) :-
    Timestep = 0..max_timestep.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Awareness Axiom %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(Fluent, Timestep) | -holds(Fluent, Timestep) :-
    fluent(inertial, Fluent),
    Timestep = 0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Reality Check Axioms %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-
    observed(Fluent, Timestep),
    Timestep <= current_Timestep,
    -holds(Fluent, Timestep).

:-
    -observed(Fluent, Timestep),
    Timestep <= current_Timestep,
    holds(Fluent, Timestep).
