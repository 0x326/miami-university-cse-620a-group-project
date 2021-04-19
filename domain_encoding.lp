%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Domains %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% person(Person)
% player(Player)
% dealer(Dealer)

% card_value(CardValue)
% card_suit(CardSuit)
% card((CardSuit, CardValue))

card((CardSuit, CardValue)) :-
    card_suit(CardSuit),
    card_value(CardValue).

hand(1; 2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Statics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

person(Person) :-
    Person = (
        "Alice";
        "Bob"
    ).

dealer(Delar)

agent(Person) :-
    person(Person),
    Person = "Alice".

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fluents %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fluent(inertial, deck_card(Card, Position)) :-
    card(Card),
    position(Position).

fluent(inertial, card_in_hand(Player, Hand, Card)) :-
    player(Player),
    hand(Hand),
    card(Card).

fluent(defined, hand_score(Person, Hand, Score)) :-
    person(Person),
    hand(Hand),
    MaxScore = #sum{ CardValue, CardSuit :
        card_suit(CardSuit),
        card_value(CardValue)
    },
    Score = 0..MaxScore.

fluent(defined, bust(Player, Hand)) :-
    player(Player),
    hand(Hand).

fluent(defined, game_end(Player, Hand, Result)) :-
    player(Player),
    hand(Hand),
    Result = (
        win;
        loss;
        push  % "tie"
    ).

fluent(inertial, chip_count(Player, ChipCount)) :-
    player(Player),
    max_chip_count(MaxChipCount),
    ChipCount = 0..MaxChipCount.

fluent(inertial, current_bet(Player, Hand, ChipCount)) :-
    player(Player),
    hand(Hand),
    max_chip_count(MaxChipCount),
    ChipCount = 0..MaxChipCount.

fluent(inertial, have_split(Player)) :-
    player(Player).

fluent(inertial, have_double_downed(Player, Hand)) :-
    player(Player),
    hand(Hand).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Actions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

action(place_bet(Actor)) :-
    player(Actor).

action(hit(Actor, Hand)) :-
    player(Actor),
    hand(Hand).

action(stand(Actor, Hand)) :-
    player(Actor),
    hand(Hand).

action(split(Actor)) :-
    player(Actor).

action(double_down(Actor)) :-
    player(Actor).

action(deal_card(Actor, Player, Hand)) :-
    dealer(Actor),
    player(Player),
    hand(Hand).

action(deal_card(Actor, Actor, Hand)) :-
    dealer(Actor),
    hand(Hand),
    Hand = 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Action descriptions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -deck_card(Card, OtherPosition) if
%   deck_card(Card, Position),
%   OtherPosition != Position

% -card_in_hand(Player, OtherHand, Card) if
%   card_in_hand(Player, Hand, Card),
%   OtherHand != Hand

% -card_in_hand(OtherPlayer, OtherHand, Card) if
%   card_in_hand(Player, Hand, Card),
%   OtherPlayer != Player

% (AL-like rule)
%
% hand_score(Player, Hand, Score) if
%   #sum{ card_in_hand(Player, Hand, Card) }
holds(hand_score(Person, Hand, Score), Timestep) :-
    step(Timestep),
    person(Person),
    hand(Hand),
    Score = #sum{ CardValue, CardSuit :
        holds(card_in_hand(Person, Hand, (CardSuit, CardValue)), Timestep)
    }.

% bust(Person, Hand) if
%   hand_score(Person, Hand, Score),
%   Score > 21.
holds(bust(Person, Hand), Timestep) :-
    step(Timestep),
    person(Person),
    hand(Hand),
    holds(hand_score(Person, Hand, Score), Timestep),
    Score > 21.

% game_end(Player, Hand, win) if
%   bust(Dealer, DealerHand),
%   -bust(Player, Hand)

% game_end(Player, Hand, win) if
%   -bst
%   hand_score(Player, Hand, Score)
%   bust(Dealer, DealerHand),
%   -bust(Player, Hand)
