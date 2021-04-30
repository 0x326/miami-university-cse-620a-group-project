% Title: Blackjack Modeled in a Dynamic Domain
%
% Input predicates:
%   - person(Person)
%   - player(Player)
%   - dealer(Dealer)
%
%   - obs(Fluent, 0)
%   - -obs(Fluent, 0)
%   - hpd(Action, Timestep)
%
% Output predicates:
%   - holds(game_end(Player, Hand, Result), Timestep)
%
% KRR methodology:
%   - dynamic domains

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Domains %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% person(Person)
% player(Player)
% dealer(Dealer)

% suit(Suit)
% rank(Rank)
% card(Card)

% card_rank(Card, CardRank)
% card_suit(Card, CardSuit)
% card_value(Card, CardValue)

suit(Suit) :-
    Suit = (
        spades;
        hearts;
        diamonds;
        clubs
    ).

rank(Rank) :-
    Rank = (
        ace;
        two;
        three;
        four;
        five;
        six;
        seven;
        eight;
        nine;
        ten;
        jack;
        queen;
        king
    ).

card(Card) :-
    suit(CardSuit),
    rank(CardRank),
    Card = @str_format("{} of {}", CardRank, CardSuit).

card_suit(Card, CardSuit) :-
    suit(CardSuit),
    rank(CardRank),
    Card = @str_format("{} of {}", CardRank, CardSuit).

card_rank(Card, CardRank) :-
    suit(CardSuit),
    rank(CardRank),
    Card = @str_format("{} of {}", CardRank, CardSuit).

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = ace,
    CardValue = (1; 11).

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = two,
    CardValue = 2.

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = three,
    CardValue = 3.

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = four,
    CardValue = 4.

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = five,
    CardValue = 5.

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = six,
    CardValue = 6.

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = seven,
    CardValue = 7.

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = eight,
    CardValue = 8.

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = nine,
    CardValue = 9.

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = ten,
    CardValue = 10.

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = jack,
    CardValue = 10.

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = queen,
    CardValue = 10.

card_value(Card, CardValue) :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = king,
    CardValue = 10.

hand(1; 2).

game_result(Result) :-
    Result = (
        win;
        loss;
        push  % "tie"
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Statics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

person(Person) :-
    Person = (
        "Alice";
        "Bob"
    ).

% dealer(Dealer)

agent(Person) :-
    person(Person),
    Person = "Alice".

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fluents %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fluent(inertial, deck_card(Card, Position)) :-
    card(Card),
    position(Position).

fluent(inertial, card_in_hand(Person, Hand, Card)) :-
    person(Person),
    hand(Hand),
    card(Card).

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

% ---------------------------------------------------------

fluent(defined, hand_score(Person, Hand, Score)) :-
    person(Person),
    hand(Hand),
    MaxScore = #sum{ CardValue, CardSuit :
        card_suit(CardSuit),
        card_value(CardValue)
    },
    Score = 0..MaxScore.

fluent(defined, bust(Person, Hand)) :-
    person(Person),
    hand(Hand).

fluent(defined, black_jack(Person, Hand)) :-
    person(Person),
    hand(Hand).

fluent(defined, game_end(Player, Hand, Result)) :-
    player(Player),
    hand(Hand),
    game_result(Result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Actions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

action(deal_card(Actor, Player, Hand)) :-
    dealer(Actor),
    player(Player),
    hand(Hand).

action(deal_card(Actor, Actor, Hand)) :-
    dealer(Actor),
    hand(Hand),
    Hand = 1.

action(place_bet(Actor, ChipCount)) :-
    player(Actor),
    max_chip_count(MaxChipCount),
    ChipCount = 0..MaxChipCount.

action(hit(Actor, Hand)) :-
    person(Actor),
    hand(Hand).

action(stand(Actor, Hand)) :-
    player(Actor),
    hand(Hand).

action(split(Actor)) :-
    player(Actor).

action(double_down(Actor, Hand)) :-
    player(Actor),
    hand(Hand).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Action descriptions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -deck_card(Card, OtherPosition) if
%   deck_card(Card, Position),
%   OtherPosition != Position
-holds(deck_card(Card, OtherPosition), Timestep) :-
    step(Timestep),
    holds(deck_card(Card, Position), Timestep),
    position(OtherPosition),
    OtherPosition != Position.

% ---------------------------------------------------------

% -card_in_hand(Person, OtherHand, Card) if
%   card_in_hand(Person, Hand, Card),
%   OtherHand != Hand
-holds(card_in_hand(Person, OtherHand, Card), Timestep) :-
    step(Timestep),
    holds(card_in_hand(Person, Hand, Card), Timestep),
    hand(OtherHand),
    OtherHand != Hand.

% -card_in_hand(OtherPerson, OtherHand, Card) if
%   card_in_hand(Person, Hand, Card),
%   OtherPerson != Person
-holds(card_in_hand(OtherPerson, OtherHand, Card), Timestep) :-
    step(Timestep),
    holds(card_in_hand(Person, Hand, Card), Timestep),
    player(OtherPerson),
    hand(OtherHand),
    OtherPerson != Person.

% ---------------------------------------------------------

% (AL-like rule)
%
% hand_score(Person, Hand, Score) if
%   #sum{ card_in_hand(Person, Hand, Card) }
holds(hand_score(Person, Hand, Score), Timestep) :-
    step(Timestep),
    person(Person),
    hand(Hand),
    Score = #sum{ CardValue, Card :
        holds(card_in_hand(Person, Hand, Card), Timestep),
        card_value(CardValue)
    }.

% ---------------------------------------------------------

% bust(Person, Hand) if
%   hand_score(Person, Hand, Score),
%   Score > 21.
holds(bust(Person, Hand), Timestep) :-
    step(Timestep),
    person(Person),
    hand(Hand),
    holds(hand_score(Person, Hand, Score), Timestep),
    Score > 21.

% ---------------------------------------------------------

% black_jack(Person, Hand) if
%   card_in_hand(Person, Hand, Ace)
%   card_in_hand(Person, Hand, Card)
%   card_rank(Ace, AceRank)
%   card_value(Card, CardValue)
%   AceRank = ace
%   CardValue = 10
holds(black_jack(Person, Hand), Timestep) :-
    step(Timestep),
    holds(card_in_hand(Person, Hand, Ace), Timestep),
    holds(card_in_hand(Person, Hand, Card), Timestep),
    card_rank(Ace, AceRank),
    card_value(Card, CardValue),
    AceRank = ace,
    CardValue = 10.

% ---------------------------------------------------------

% -game_end(Player, Hand, OtherResult) if
%   game_end(Player, Hand, Result)
%   OtherResult != Result
-holds(game_end(Player, Hand, OtherResult), Timestep) :-
    step(Timestep),
    holds(game_end(Player, Hand, Result), Timestep),
    game_result(OtherResult),
    OtherResult != Result.

% ---------------------------------------------------------

% game_end(Player, Hand, lose) if
%   bust(Player, Hand)
holds(game_end(Player, Hand, lose), Timestep) :-
    step(Timestep),
    holds(bust(Player, Hand), Timestep).

% game_end(Player, PlayerHand, lose) if
%   hand_score(Player, PlayerHand, PlayerScore)
%   hand_score(Dealer, DealerHand, DealerScore)
%   dealer(Dealer)
%   PlayerScore < DealerScore
holds(game_end(Player, PlayerHand, lose), Timestep) :-
    step(Timestep),
    holds(hand_score(Player, PlayerHand, PlayerScore), Timestep),
    holds(hand_score(Dealer, DealerHand, DealerScore), Timestep),
    player(Player),
    dealer(Dealer),
    PlayerScore < DealerScore.

% ---------------------------------------------------------

% game_end(Player, PlayerHand, push) if
%   hand_score(Player, PlayerHand, PlayerScore)
%   hand_score(Dealer, DealerHand, DealerScore)
%   dealer(Dealer)
%   PlayerScore = DealerScore
holds(game_end(Player, PlayerHand, push), Timestep) :-
    step(Timestep),
    holds(hand_score(Player, PlayerHand, PlayerScore), Timestep),
    holds(hand_score(Dealer, DealerHand, DealerScore), Timestep),
    player(Player),
    dealer(Dealer),
    PlayerScore = DealerScore.

% -game_end(Player, PlayerHand, push) if
%   hand_score(Player, PlayerHand, PlayerScore)
%   hand_score(Dealer, DealerHand, DealerScore)
%   dealer(Dealer)
%   PlayerScore != DealerScore
-holds(game_end(Player, PlayerHand, push), Timestep) :-
    step(Timestep),
    holds(hand_score(Player, PlayerHand, PlayerScore), Timestep),
    holds(hand_score(Dealer, DealerHand, DealerScore), Timestep),
    player(Player),
    dealer(Dealer),
    PlayerScore != DealerScore.

% ---------------------------------------------------------

% game_end(Player, PlayerHand, win) if
%   black_jack(Player, PlayerHand)
%   -black_jack(Dealer, DealerHand)
holds(game_end(Player, PlayerHand, win), Timestep) :-
    step(Timestep),
    holds(black_jack(Player, PlayerHand), Timestep),
    -holds(black_jack(Dealer, DealerHand), Timestep).

% game_end(Player, Hand, win) if
%   bust(Dealer, DealerHand),
%   -bust(Player, Hand)
holds(game_end(Player, Hand, win), Timestep) :-
    step(Timestep),
    holds(bust(Dealer, DealerHand), Timestep),
    -holds(bust(Player, Hand), Timestep).

% ---------------------------------------------------------
