#const max_timestep = 10.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Domains %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

max_chip_count(MaxChipCount) :-
    MaxChipCount = 10.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Statics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

player("Bob").
dealer("Ray").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial observations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A shuffled deck of cards
deck_card("ten of spades", 1).
deck_card("five of spades", 2).
deck_card("eight of spades", 3).
deck_card("three of spades", 4).
deck_card("jack of spades", 5).
deck_card("six of hearts", 6).
deck_card("eight of clubs", 7).
deck_card("four of diamonds", 8).
deck_card("three of hearts", 9).
deck_card("five of clubs", 10).
deck_card("ten of clubs", 11).
deck_card("seven of spades", 12).
deck_card("five of hearts", 13).
deck_card("nine of spades", 14).
deck_card("seven of diamonds", 15).
deck_card("two of hearts", 16).
deck_card("jack of diamonds", 17).
deck_card("nine of diamonds", 18).
deck_card("ace of diamonds", 19).
deck_card("six of clubs", 20).
deck_card("four of spades", 21).
deck_card("seven of hearts", 22).
deck_card("king of spades", 23).
deck_card("ace of clubs", 24).
deck_card("jack of hearts", 25).
deck_card("five of diamonds", 26).
deck_card("three of clubs", 27).
deck_card("two of clubs", 28).
deck_card("four of hearts", 29).
deck_card("queen of clubs", 30).
deck_card("king of hearts", 31).
deck_card("jack of clubs", 32).
deck_card("king of clubs", 33).
deck_card("seven of clubs", 34).
deck_card("ten of hearts", 35).
deck_card("queen of hearts", 36).
deck_card("four of clubs", 37).
deck_card("ace of spades", 38).
deck_card("nine of clubs", 39).
deck_card("eight of hearts", 40).
deck_card("king of diamonds", 41).
deck_card("two of diamonds", 42).
deck_card("six of diamonds", 43).
deck_card("eight of diamonds", 44).
deck_card("queen of spades", 45).
deck_card("ace of hearts", 46).
deck_card("queen of diamonds", 47).
deck_card("ten of diamonds", 48).
deck_card("three of diamonds", 49).
deck_card("six of spades", 50).
deck_card("two of spades", 51).
deck_card("nine of hearts", 52).

holds(deck_position(Position), Timestep) :-
    Timestep = 0,
    Position = 1.

-holds(card_in_hand(Person, Hand, Card), Timestep) :-
    Timestep = 0,
    person(Person),
    person_hand(Person, Hand),
    card(Card).

holds(chip_count(Player, ChipCount), Timestep) :-
    Timestep = 0,
    Player = "Bob",
    ChipCount = 20.

holds(current_bet(Player, Hand, ChipCount), Timestep) :-
    Timestep = 0,
    Player = "Bob",
    ChipCount = 0,
    person_hand(Player, Hand).

holds(split_count(Player, SplitCount), Timestep) :-
    Timestep = 0,
    Player = "Bob",
    SplitCount = 0.

-holds(has_doubled_down(Player, Hand), Timestep) :-
    Timestep = 0,
    Player = "Bob",
    person_hand(Player, Hand).

-holds(has_stayed(Player, Hand), Timestep) :-
    Timestep = 0,
    Player = "Bob",
    person_hand(Player, Hand).

% ---------------------------------------------------------

occurs(place_bet(Actor, ChipCount), Timestep) :-
    Timestep = 0,
    Actor = "Bob",
    ChipCount = 10.

occurs(deal_card(Actor, Player, Hand), Timestep) :-
    Timestep = 1,
    Actor = "Ray",
    Player = "Bob",
    Hand = 1.

occurs(deal_card(Actor, Player, Hand), Timestep) :-
    Timestep = 2,
    Actor = "Ray",
    Player = "Bob",
    Hand = 1.

occurs(deal_card(Actor, Player, Hand), Timestep) :-
    Timestep = 3,
    Actor = "Ray",
    Player = "Ray",
    Hand = 1.

occurs(hit(Actor, Hand), Timestep) :-
    Timestep = 4,
    Actor = "Bob",
    Hand = 1.

occurs(deal_card(Actor, Player, Hand), Timestep) :-
    Timestep = 5,
    Actor = "Ray",
    Player = "Ray",
    Hand = 1.

occurs(end_game(Actor), Timestep) :-
    Timestep = 6,
    Actor = "Bob".
