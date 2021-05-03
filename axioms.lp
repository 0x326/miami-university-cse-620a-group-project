% fluent(inertial, Fluent)
% fluent(defined, Fluent)
% aciton(Action)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Inertia axiom %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(Fluent, Timestep + 1) :-
    step(Timestep),
    fluent(inertial, Fluent),
    holds(Fluent, Timestep),
    not -holds(Fluent, Timestep + 1).

-holds(Fluent, Timestep + 1) :-
    step(Timestep),
    fluent(inertial, Fluent),
    -holds(Fluent, Timestep),
    not holds(Fluent, Timestep + 1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Closed-world assumption for defined fluents %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-holds(Fluent, Timestep) :-
    step(Timestep),
    fluent(defined, Fluent),
    not holds(Fluent, Timestep).

holds(Fluent, Timestep) :-
    step(Timestep),
    fluent(defined_negative, Fluent),
    not -holds(Fluent, Timestep).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Closed-world assumption for actions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-occurs(Action, Timestep) :-
    step(Timestep),
    action(Action),
    not occurs(Action, Timestep).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Timestep %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

step(Timestep) :-
    Timestep = 0..max_timestep.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Awareness Axiom %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(Fluent, Timestep) | -holds(Fluent, Timestep) :-
    fluent(inertial, Fluent),
    Timestep = 0.
