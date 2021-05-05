%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Domains %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Statics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

player("Bob").
dealer("Ray").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial observations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A shuffled deck of cards
holds(deck_card("six of hearts", 1), 0).
holds(deck_card("eight of clubs", 2), 0).
holds(deck_card("four of diamonds", 3), 0).
holds(deck_card("three of hearts", 4), 0).
holds(deck_card("five of clubs", 5), 0).
holds(deck_card("ten of clubs", 6), 0).
holds(deck_card("seven of spades", 7), 0).
holds(deck_card("jack of spades", 8), 0).
holds(deck_card("five of hearts", 9), 0).
holds(deck_card("nine of spades", 10), 0).
holds(deck_card("seven of diamonds", 11), 0).
holds(deck_card("two of hearts", 12), 0).
holds(deck_card("jack of diamonds", 13), 0).
holds(deck_card("nine of diamonds", 14), 0).
holds(deck_card("ace of diamonds", 15), 0).
holds(deck_card("six of clubs", 16), 0).
holds(deck_card("four of spades", 17), 0).
holds(deck_card("seven of hearts", 18), 0).
holds(deck_card("king of spades", 19), 0).
holds(deck_card("ace of clubs", 20), 0).
holds(deck_card("jack of hearts", 21), 0).
holds(deck_card("five of diamonds", 22), 0).
holds(deck_card("ten of spades", 23), 0).
holds(deck_card("three of clubs", 24), 0).
holds(deck_card("three of spades", 25), 0).
holds(deck_card("two of clubs", 26), 0).
holds(deck_card("four of hearts", 27), 0).
holds(deck_card("queen of clubs", 28), 0).
holds(deck_card("king of hearts", 29), 0).
holds(deck_card("jack of clubs", 30), 0).
holds(deck_card("king of clubs", 31), 0).
holds(deck_card("seven of clubs", 32), 0).
holds(deck_card("ten of hearts", 33), 0).
holds(deck_card("queen of hearts", 34), 0).
holds(deck_card("four of clubs", 35), 0).
holds(deck_card("ace of spades", 36), 0).
holds(deck_card("nine of clubs", 37), 0).
holds(deck_card("eight of hearts", 38), 0).
holds(deck_card("king of diamonds", 39), 0).
holds(deck_card("two of diamonds", 40), 0).
holds(deck_card("six of diamonds", 41), 0).
holds(deck_card("five of spades", 42), 0).
holds(deck_card("eight of diamonds", 43), 0).
holds(deck_card("queen of spades", 44), 0).
holds(deck_card("ace of hearts", 45), 0).
holds(deck_card("queen of diamonds", 46), 0).
holds(deck_card("ten of diamonds", 47), 0).
holds(deck_card("three of diamonds", 48), 0).
holds(deck_card("six of spades", 49), 0).
holds(deck_card("eight of spades", 50), 0).
holds(deck_card("two of spades", 51), 0).
holds(deck_card("nine of hearts", 52), 0).

-holds(card_in_hand(Person, Hand, Card), 0) :-
    person(Person),
    hand(Hand),
    card(Card).

holds(chip_count("Bob", 20), 0).
holds(current_bet("Bob", Hand, 0), 0) :-
    hand(Hand).

holds(split_count("Bob", 0), 0).

-holds(has_doubled_down("Bob", Hand), 0) :-
    hand(Hand).

-holds(has_stayed("Bob", Hand), 0) :-
    hand(Hand).

occurs(place_bet("Bob", 10), 0).

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Gameplay %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#show holds/2.
