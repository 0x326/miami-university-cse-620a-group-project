% Title: Blackjack Modeled in a Dynamic Domain
%
% Input predicates:
%   - person(Person)
%   - player(Player)
%   - dealer(Dealer)
%
%   - holds(Fluent, 0)
%   - -holds(Fluent, 0)
%   - occurs(Action, Timestep)
%
% Output predicates:
%   - holds(game_end(Player, Hand, Result), Timestep)
%   - occurs(Action, Timestep)
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

1 { card_value(Card, CardValue) :
        CardValue = (1; 11) } 1 :-
    suit(CardSuit),
    Card = @str_format("{} of {}", CardRank, CardSuit),
    CardRank = ace.

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

max_card_count(CardCount) :-
    CardCount = #count{ Card :
        card(Card)
    }.

hand(1; 2).

game_result(Result) :-
    Result = (
        win;
        loss;
        push  % "tie"
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Statics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% person(Person)
% player(Player)
% dealer(Dealer)

person(X) :- player(X).
person(X) :- dealer(X).

% max_chip_count(MaxChipCount)
% deck_card(Card, Position)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fluents %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fluent(inertial, deck_position(Position)) :-
    max_card_count(CardCount),
    Position = 1..CardCount.

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

fluent(inertial, split_count(Player, SplitCount)) :-
    player(Player),
    MaxSplitCount = 3,
    SplitCount = 0..MaxSplitCount.

fluent(inertial, has_doubled_down(Player, Hand)) :-
    player(Player),
    hand(Hand).

fluent(inertial, has_stayed(Player, Hand)) :-
    player(Player),
    hand(Hand).

% ---------------------------------------------------------

fluent(defined, hand_score(Person, Hand, Score)) :-
    person(Person),
    hand(Hand),
    MaxScore = #sum{ CardValue, Card :
        card_value(Card, CardValue)
    },
    MaxScore <= 30,
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

action(split(Actor, Hand)) :-
    player(Actor),
    hand(Hand).

action(double_down(Actor, Hand)) :-
    player(Actor),
    hand(Hand).

action(end_game(Actor)) :-
    player(Actor).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Action descriptions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -deck_position(OtherPosition) if
%   deck_position(Position) if
%   OtherPosition != Position
-holds(deck_position(OtherPosition), Timestep) :-
    step(Timestep),
    holds(deck_position(Position), Timestep),
    max_card_count(CardCount),
    OtherPosition = 1..CardCount,
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
        card_value(Card, CardValue)
    },
    Score <= 30.

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

% -chip_count(Player, OtherChipCount) if
%   chip_count(Player, ChipCount)
%   OtherChipCount != ChipCount
-holds(chip_count(Player, OtherChipCount), Timestep) :-
    step(Timestep),
    holds(chip_count(Player, ChipCount), Timestep),
    max_chip_count(MaxChipCount),
    OtherChipCount = 0..MaxChipCount,
    OtherChipCount != ChipCount.

% ---------------------------------------------------------

% -current_bet(Player, Hand, OtherChipCount) if
%   current_bet(Player, Hand, ChipCount)
%   OtherChipCount != ChipCount
-holds(current_bet(Player, Hand, OtherChipCount), Timestep) :-
    step(Timestep),
    holds(current_bet(Player, Hand, ChipCount), Timestep),
    max_chip_count(MaxChipCount),
    OtherChipCount = 0..MaxChipCount,
    OtherChipCount != ChipCount.

% ---------------------------------------------------------

% impossible Action1, Action2 if
%   Action1 != Action2
-occurs(OtherAction, Timestep) :-
    step(Timestep),
    occurs(Action, Timestep),
    action(OtherAction),
    OtherAction != Action.

% ---------------------------------------------------------

% place_bet(Actor, ChipCount)
% causes current_bet(Actor, Hand, ChipCount)
% if
%   Hand = 1
holds(current_bet(Actor, Hand, ChipCount), Timestep + 1) :-
    step(Timestep),
    occurs(place_bet(Actor, ChipCount), Timestep),
    Hand = 1.

% place_bet(Actor, ChipCount)
% causes chip_count(Actor, NewChipCount)
% if
%   chip_count(Actor, OldChipCount)
%   NewChipCount = OldChipCount - ChipCount
holds(chip_count(Actor, NewChipCount), Timestep + 1) :-
    step(Timestep),
    occurs(place_bet(Actor, ChipCount), Timestep),
    holds(chip_count(Actor, OldChipCount), Timestep),
    NewChipCount = OldChipCount - ChipCount.

% impossible place_bet(Actor, ChipCount) if
%   current_bet(Actor, Hand, ChipCount)
%   ChipCount > 0
-occurs(place_bet(Actor, ChipCount), Timestep) :-
    step(Timestep),
    holds(current_bet(Actor, Hand, ChipCount), Timestep),
    ChipCount > 0.

% impossible place_bet(Actor, ChipCount) if
%   chip_count(Actor, AvailableChipCount)
%   ChipCount > AvailableChipCount
-occurs(place_bet(Actor, ChipCount), Timestep) :-
    step(Timestep),
    holds(chip_count(Actor, AvailableChipCount), Timestep),
    max_chip_count(MaxChipCount),
    ChipCount = 0..MaxChipCount,
    ChipCount > AvailableChipCount.

% ---------------------------------------------------------

% deal_card(Actor, Person, Hand)
% causes card_in_hand(Person, Hand, Card)
% if
%   deck_position(Position)
%   deck_card(Card, Position)
holds(card_in_hand(Person, Hand, Card), Timestep + 1) :-
    step(Timestep),
    occurs(deal_card(Actor, Person, Hand), Timestep),
    holds(deck_position(Position), Timestep),
    deck_card(Card, Position).

% deal_card(Actor, Person, Hand)
% causes -deck_card(Card, Position)
% if
%   deck_position(Position)
%   deck_card(Card, Position)
-holds(deck_card(Card, Position), Timestep + 1) :-
    step(Timestep),
    occurs(deal_card(Actor, Person, Hand), Timestep),
    deck_card(Card, Position),
    holds(deck_position(Position), Timestep).

% deal_card(Actor, Person, Hand)
% causes deck_position(Position + 1)
% if
%   deck_position(Position)
holds(deck_position(Position + 1), Timestep + 1) :-
    step(Timestep),
    occurs(deal_card(Actor, Person, Hand), Timestep),
    holds(deck_postion(Position), Timestep).

% ---------------------------------------------------------

% hit(Actor, Hand)
% causes card_in_hand(Actor, Hand, Card)
% if
%   deck_position(Position)
%   deck_card(Card, Position)
holds(card_in_hand(Actor, Hand, Card), Timestep + 1) :-
    step(Timestep),
    occurs(hit(Actor, Hand), Timestep),
    deck_card(Card, Position).

% hit(Actor, Hand)
% causes -deck_card(Card, Position)
% if
%   deck_position(Position)
%   deck_card(Card, Position)
-holds(deck_card(Card, Position), Timestep + 1) :-
    step(Timestep),
    occurs(hit(Actor, Hand), Timestep),
    holds(deck_position(Position), Timestep),
    deck_card(Card, Position).

% hit(Actor, Hand)
% causes deck_position(Position + 1)
% if
%   deck_position(Position)
holds(deck_position(Position + 1), Timestep + 1) :-
    step(Timestep),
    occurs(hit(Actor, Hand), Timestep),
    holds(deck_position(Position), Timestep).

% impossible hit(Actor, Hand) if
%   has_stayed(Actor, Hand)
-occurs(hit(Actor, Hand), Timestep) :-
    step(Timestep),
    occurs(has_stayed(Actor, Hand), Timestep).

% impossible hit(Actor, Hand) if
%   has_doubled_down(Actor, Hand)
-occurs(hit(Actor, Hand), Timestep) :-
    step(Timestep),
    occurs(has_doubled_down(Actor, Hand), Timestep).

% impossible hit(Actor, Hand) if
%   bust(Actor, Hand)
-occurs(hit(Actor, Hand), Timestep) :-
    step(Timestep),
    holds(bust(Actor, Hand), Timestep).

% ---------------------------------------------------------

% stand(Actor, Hand)
% causes has_stayed(Actor, Hand)
holds(has_stayed(Actor, Hand), Timestep + 1) :-
    step(Timestep),
    occurs(stand(Actor, Hand), Timestep).

% impossible stand(Actor, Hand) if
%   has_stayed(Actor, Hand)
-occurs(stand(Actor, Hand), Timestep) :-
    step(Timestep),
    holds(has_stayed(Actor, Hand), Timestep).

% ---------------------------------------------------------

% split(Actor, Hand)
% causes split_count(Actor, SplitCount + 1)
% if
%   split_count(Actor, SplitCount)
holds(split_count(Actor, SplitCount + 1), Timestep + 1) :-
    step(Timestep),
    occurs(split(Actor, Hand), Timestep),
    holds(split_count(Actor, SplitCount), Timestep).

% impossible split(Actor, Hand) if
%   card_in_hand(Actor, Hand, Card1)
%   card_in_hand(Actor, Hand, Card2)
%   card_in_hand(Actor, Hand, Card3)
%   Card1 != Card2
%   Card2 != Card3
-occurs(split(Actor, Hand), Timestep) :-
    step(Timestep),
    holds(card_in_hand(Actor, Hand, Card1), Timestep),
    holds(card_in_hand(Actor, Hand, Card2), Timestep),
    holds(card_in_hand(Actor, Hand, Card3), Timestep),
    Card1 != Card2,
    Card2 != Card3.

% impossible split(Actor, Hand) if
%   has_split(Actor, Hand)
%   card_in_hand(Actor, Hand, Card1)
%   card_in_hand(Actor, Hand, Card2)
%   Card1 != Card2
%   card_rank(Card1, Rank1)
%   card_rank(Card2, Rank2)
%   Rank1 != Rank2
-occurs(split(Actor, Hand), Timestep) :-
    step(Timestep),
    holds(has_split(Actor, Hand), Timestep),
    holds(card_in_hand(Actor, Hand, Card1), Timestep),
    holds(card_in_hand(Actor, Hand, Card2), Timestep),
    Card1 != Card2,
    card_rank(Card1, Rank1),
    card_rank(Card2, Rank2),
    Rank1 != Rank2.

% impossible split(Actor, Hand) if
%   has_split(Actor, Hand)
-occurs(split(Actor, Hand), Timestep) :-
    step(Timestep),
    holds(has_split(Actor, Hand), Timestep).

% split(Actor, Hand)
% causes current_bet(Actor, Hand, NewChipCount)
% if
%   current_bet(Actor, Hand, ChipCount)
%   NewChipCount = (ChipCount / 2) + (ChipCount \ 2)
holds(current_bet(Actor, Hand, NewChipCount), Timestep + 1) :-
    step(Timestep),
    occurs(split(Actor, Hand), Timestep),
    holds(current_bet(Actor, Hand, ChipCount), Timestep),
    NewChipCount = (ChipCount / 2) + (ChipCount \ 2).

% split(Actor, Hand)
% causes current_bet(Actor, Hand + 1, NewChipCount)
% if
%   current_bet(Actor, Hand, ChipCount)
%   NewChipCount = ChipCount / 2
holds(current_bet(Actor, Hand + 1, NewChipCount), Timestep + 1) :-
    step(Timestep),
    occurs(split(Actor, Hand), Timestep),
    holds(current_bet(Actor, Hand, ChipCount), Timestep),
    NewChipCount = ChipCount / 2.

% split(Actor, Hand)
% causes -card_in_hand(Person, Hand, Card2)
% if
%   card_in_hand(Person, Hand, Card1)
%   card_in_hand(Person, Hand, Card2)
%   Card1 < Card2
-holds(card_in_hand(Person, Hand, Card2), Timestep + 1) :-
    step(Timestep),
    occurs(split(Actor, Hand), Timestep),
    holds(card_in_hand(Person, Hand, Card1), Timestep),
    holds(card_in_hand(Person, Hand, Card2), Timestep),
    Card1 < Card2.

% split(Actor, Hand)
% causes card_in_hand(Person, Hand + 1, Card2)
% if
%   card_in_hand(Person, Hand, Card1)
%   card_in_hand(Person, Hand, Card2)
%   Card1 < Card2
holds(card_in_hand(Person, Hand + 1, Card2), Timestep + 1) :-
    step(Timestep),
    occurs(split(Actor, Hand), Timestep),
    holds(card_in_hand(Person, Hand, Card1), Timestep),
    holds(card_in_hand(Person, Hand, Card2), Timestep),
    Card1 < Card2.

% ---------------------------------------------------------

% -split_count(Player, OtherSplitCount) if
%   split_count(Player, SplitCount)
%   OtherSplitCount != SplitCount
-holds(split_count(Player, OtherSplitCount), Timestep) :-
    step(Timestep),
    holds(split_count(Player, SplitCount), Timestep),
    MaxSplitCount = 3,
    OtherSplitCount = 0..MaxSplitCount,
    OtherSplitCount != SplitCount.

% ---------------------------------------------------------

% double_down(Actor, Hand)
% causes has_doubled_down(Actor, Hand)
holds(has_doubled_down(Actor, Hand), Timestep + 1) :-
    step(Timestep),
    occurs(double_down(Actor, Hand), Timestep).

% impossible double_down(Actor, Hand) if
%   has_doubled_down(Actor, Hand)
-occurs(double_down(Actor, Hand), Timestep) :-
    step(Timestep),
    holds(has_doubled_down(Actor, Hand), Timestep).

% double_down(Actor, Hand)
% causes current_bet(Actor, Hand, NewChipCount)
% if
%   current_bet(Actor, Hand, ChipCount)
%   NewChipCount = 2 * ChipCount
holds(current_bet(Actor, Hand, NewChipCount), Timestep + 1) :-
    step(Timestep),
    occurs(double_down(Actor, Hand), Timestep),
    holds(current_bet(Actor, Hand, ChipCount), Timestep),
    NewChipCount = 2 * ChipCount.

% ---------------------------------------------------------

% end_game(Actor)
% causes
% if
%   game_end(Actor, Hand, Result)
%   Result = win

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Optiminization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#maximize{ ChipCount, Player :
    holds(chip_count(Player, ChipCount), max_timestep)
}.
