/*
Elizabeth Brooks 
Jonathan Mercer 


Project 2


*/

/*Clue Assistant Main*/
clueAssist :- 
	writeln('Please type all your responses in all lower-case and all two word cards should be joined together with an underscore.  '), 
	writeln('Like so: '), 
	writeln('kitchen ballroom conservatory billiard_room library study hall lounge dining_room'), 
	initializeGame, playerSuggestion.



/*Initialise Game Deck and Players*/
initializeGame :- initializeCards, initializeOurColor, initializeOurHand, initializePlayerOrder.

initializeCards :- initializeSuspects, initializeWeapons, initializeRooms.
initializeSuspects :- writeln('All suspects: '), 
	readln(X), 
	setSuspects(X).
initializeWeapons :- writeln('All weapons: '), 
	readln(X), 
	setWeapons(X).
initializeRooms :- writeln('All rooms: '), 
	readln(X), 
	setRooms(X).

initializeOurColor :- writeln('Your color: '), 
	readln(X), 
	setOurColor(X).
initializeOurHand :- writeln('Cards in your hand: '), 
	readln(X), 
	setOurHand(X).
initializePlayerOrder :- writeln('Player colors in order of play: '), readln(X), 
	setPlayerOrder(X).

/*Setters for initialization*/
setOurColor([C]) :- assertz(ourColor(C)).
setOurHand(Cards) :- assertz(ourHand(Cards)).
setPlayerOrder(Colors) :- assertz(playerOrder(Colors)).
setSuspects(Suspects) :- assertz(suspects(Suspects)).
setWeapons(Weapons) :- assertz(weapons(Weapons)).
setRooms(Rooms) :- assertz(rooms(Rooms)).




/*Player Suggestion Loop*/
playerSuggestion :- playerOrder([X|_]), playerSuggestion(X).

/*Our turn*/
playerSuggestion(CurrentPlayer) :- ourColor(CurrentPlayer), 
	nextPlayer(CurrentPlayer, NextPlayer),
	nl, 
	writeln('your turn'),
	possibleSuggestions, 
	promptOurSuggestion(Suggestion), answeredBy(Player), whatCard(NewCard), 
	promptPossibleAccusation,
	newTurn(CurrentPlayer, Suggestion, Player, NewCard),
	writeln('end turn'),
	playerSuggestion(NextPlayer).
/*Other player turn*/
playerSuggestion(CurrentPlayer) :- nextPlayer(CurrentPlayer, NextPlayer),
	nl,  
	write(CurrentPlayer), writeln('\'s turn'),
	promptPlayerSuggestion(CurrentPlayer, Suggestion), 
	answeredBy(Player), 
	newTurn(CurrentPlayer, Suggestion, Player), 
	writeln('end turn'),
	playerSuggestion(NextPlayer).




/*Input who answered the suggestion*/
answeredBy(Player) :- writeln('Who Answered (or the asker if none) (e.g. yellow): '), readln([Player]).

/*Input what card was shown to you*/
whatCard(Card) :- writeln('What Card: '), readln([Card]).

/*nextPlayer loops through playerOrder and returns next player*/
nextPlayer(CurrentPlayer, NextPlayer) :- 
	playerOrder([X|L]), findNextPlayer(X, [X|L], CurrentPlayer, NextPlayer).
/*findNextPlayer(FirstOfPlayerOrder, ListOfPlayerOrder, CurrentPlayer, NextPlayer)*/
findNextPlayer(NextPlayer,[CurrentPlayer], CurrentPlayer, NextPlayer).
findNextPlayer(_, [CurrentPlayer|[NextPlayer|_]], CurrentPlayer, NextPlayer).
findNextPlayer(X, [_|T1], CurrentPlayer, H2) :- 
	findNextPlayer(X, T1, CurrentPlayer, H2).





/*Our Turn Input Suggestion or Command*/
promptOurSuggestion(Y) :- writeln('Your suggestion (Suspect Room Weapon) or command (accuse), (suggest): '), readln(X), 
	promptOurSuggestionOptions(X, Y).

promptOurSuggestionOptions([suggest], Y) :- possibleSuggestions, 
	promptOurSuggestion(Y).
promptOurSuggestionOptions([accuse], Y) :- possibleAccusations, 
	promptOurAcusation, possibleSuggestions, promptOurSuggestion(Y).
promptOurSuggestionOptions(Y, Y).

/*Percentage Not Known (Accusation Certainty)*/
possibleAccusations :- 
	suspectsNotKnown(X), roomsNotKnown(Y), weaponsNotKnown(Z), 
	printAccusationSuspects(X), 
	printAccusationRooms(Y), 
	printAccusationWeapons(Z).

/*Print Suspects, Rooms, and Weapons not known otherwise the items we know is in the envelope*/
printAccusationSuspects(_) :- 
	envelopeSuspect([S]), 
	write(S), writeln(' is in the evelope!').
printAccusationSuspects(X) :- 
	writeln('Suspects Not Known: '), 
	writeList(X).

printAccusationRooms(_) :- 
	envelopeRoom([R]), 
	write(R), writeln(' is in the evelope!').
printAccusationRooms(Y) :- 
	writeln('Rooms Not Known: '), 
	writeList(Y).

printAccusationWeapons(_) :- 
	envelopeWeapon([W]), 
	write(W), writeln(' is in the evelope!').
printAccusationWeapons(Z) :- 
	writeln('Weapons Not Known: '),
	writeList(Z).



writeList([H1]) :-  write('     '), writeln(H1).
writeList([H2|T2]) :- write('     '), writeln(H2), writeList(T2).

/*Our Turn Input Accusation (Attempt or Not)*/
promptOurAcusation :- writeln('Did You Accuse (y/n): '), readln(X), responseToAccuse(X).
responseToAccuse([y]) :- !, writeln('The game is over.  Press ctrl+c, ctrl+c, then \'e\' to quit!'), nl, nl, nl, readln(_).
responseToAccuse([n]).




/*List Possible Suggestions*/
possibleSuggestions :- writeln('Your Possible Suggestions: '), 
	printPossibleSuggetions.

/*Prints the list of all possible Suspects, Rooms, and Weapons wth counts*/
printPossibleSuggetions :- 
	writeln('(card, number of players who might have that card)'), 
	nl, 
	writeln('Suspects other players might have:'), 
	write('     '),
	printPossibleSuspects,
	nl, nl,
	writeln('Rooms other players might have:'),
	write('     '),
	printPossibleRooms,
	nl, nl, 
	writeln('Weapons other players might have:'),
	write('     '),
	printPossibleWeapons,
	nl, nl.

/*Wrapper for printPossibleSuggetions*/
printPossibleSuspects :- 
	countPlayerMightHaveSuspects(SuspectsCountList),
	printPossibleSuggetions(SuspectsCountList).
printPossibleRooms :- 
	countPlayerMightHaveRooms(RoomsCountList), 
	printPossibleSuggetions(RoomsCountList).
printPossibleWeapons :- 
	countPlayerMightHaveWeapons(WeaponsCountList),
	printPossibleSuggetions(WeaponsCountList).

/*Prints list of card count tupples*/
printPossibleSuggetions([Card, Count]) :- 
	write(Card), write(' '), write(Count).
printPossibleSuggetions([[Card, Count]|TL]) :- 
	write(Card), write(' '), write(Count), write(', '), 
	printPossibleSuggetions(TL).

/*TODO: count goes to zero on all counts when using na suggestions*/
/*Wrapper for countPlayerMightHave*/
countPlayerMightHaveSuspects(List) :- 
	suspects(Suspects), 
	countPlayerMightHave(Suspects, List).
countPlayerMightHaveRooms(List) :- 
	rooms(Rooms), 
	countPlayerMightHave(Rooms, List).
countPlayerMightHaveWeapons(List) :- 
	weapons(Weapons),
	countPlayerMightHave(Weapons, List).

/*Constructs might have for every card of list given (Suspects, Rooms, or Weapons)*/
countPlayerMightHave([Card], [Card, Count]) :- 
	countPlayerMightHaveCard(Card, Count).
countPlayerMightHave([Card|TC], [[Card, Count]|TL]) :- 
	countPlayerMightHaveCard(Card, Count), 
	countPlayerMightHave(TC, TL).

/*Count the players that have that Card*/
countPlayerMightHaveCard(Card, FinalCount) :- 
	playerOrder(Players), 
	countPlayerMightHaveCard(Players, Card, PlayersThatHaveCard),
	length(PlayersThatHaveCard, FinalCount).

/*Lists players that have that Card*/
countPlayerMightHaveCard([Player], Card, [Player]) :- 
	mightHave(Player, Card).
countPlayerMightHaveCard([_], _, []).
countPlayerMightHaveCard([Player|ROPlayers], Card, [Player|ROCount]) :- 
	mightHave(Player, Card), 
	countPlayerMightHaveCard(ROPlayers, Card, ROCount).
countPlayerMightHaveCard([_|ROPlayers], Card, ROCount) :- 
	countPlayerMightHaveCard(ROPlayers, Card, ROCount).




/*Other Player Turn Input Suggestion or Command*/
 promptPlayerSuggestion(Player, Suggestion) :-  
	write(Player), writeln('\'s suggestion (Suspect Room Weapon): '), readln(Suggestion).





/*Deals with accusations after suggesting something*/
promptPossibleAccusation :- 
	writeln('Do you want to accuse (y/n): '), 
	readln(X), 
	promptPossibleAccusation(X).
promptPossibleAccusation([y]) :- possibleAccusations, 
	promptOurAcusation.
promptPossibleAccusation([n]).
promptPossibleAccusation(_).




/*Initialized Parameters*/

/*ourColor(Color).*/
/*ourHand(Cards).*/
/*playerOrder(Colors).*/
/*suspects(Suspects).*/
/*weapons(Weapons).*/
/*rooms(Rooms).*/

/*Turn*/

/*turn(OurColour, Suggestion, Responder, Card).*/
/*turn(CurrentPlayer, Suggestion, Responder).*/

/*Make new turn from suggestion and results*/
newTurn(CurrentPlayer, Suggestion, Player, NewCard) :- 
	assertz(turn(CurrentPlayer, Suggestion, Player, NewCard)).
newTurn(CurrentPlayer, Suggestion, Player) :- 
	assertz(turn(CurrentPlayer, Suggestion, Player)).

/*Cards Kown to Us*/
cardsKnown(Z) :- clause(turn(_,_,_,_),true), !, ourHand(X), findall(Y, turn(_,_,_,Y), L), append(X, L, Z).
cardsKnown(Z) :- ourHand(Z).

suspectsKnown(Z) :- cardsKnown(X), suspects(Y), intersection(X, Y, Z).
roomsKnown(Z) :- cardsKnown(X), rooms(Y), intersection(X, Y, Z).
weaponsKnown(Z) :- cardsKnown(X), weapons(Y), intersection(X, Y, Z).

/*Cards Not Known to Us*/
cardsNotKnown(Z) :- allCards(All), cardsKnown(Known),
	subtract(All, Known, Z).

suspectsNotKnown(Unkown) :- suspects(Suspects), suspectsKnown(Known), 
	subtract(Suspects, Known, Unkown).
roomsNotKnown(Unkown) :- rooms(Rooms), roomsKnown(Known), 
	subtract(Rooms, Known, Unkown).
weaponsNotKnown(Unkown) :- weapons(Weapons), weaponsKnown(Known), 
	subtract(Weapons, Known, Unkown).

/*All Cards in Game*/
allCards(All) :- 
	suspects(Suspects), 
	rooms(Rooms),
	weapons(Weapons),
	flatten([Suspects, Rooms, Weapons], All).




/*List of lists of Players' have, dontHave, and mightHave cards*/
/*PlayerList = [Have, DontHave, MightHave]*/
/*AllPlayerList = [PlayerList|T] in OrderOfPlay*/
allPlayers(AllPlayers) :- playerOrder(Players), 
	allPlayers(Players, AllPlayers).
allPlayers([Player|ROPlayers], [[Have, DontHave, MightHave]|T]) :- 
	playerHave(Player, Have),
	playerDontHave(Player, DontHave),
	playerMightHave(Player, MightHave),
	allPlayers(ROPlayers, T).

playerHave(Player, Have) :- 
	setof(X, have(Player, X), Have).
playerDontHave(Player, DontHave) :- 
	setof(X, dontHave(Player, X), DontHave).
playerMightHave(Player, MightHave) :- 
	setof(X, mightHave(Player, X), MightHave).



/*Find a card a player has, doesn't have, might have*/
have(Player, Card) :- ourColor(Player), 
	ourHand(Hand), member(Card, Hand).
have(Player, Card) :- clause(turn(_,_,_,_),true), !, 
	turn(_,_,Player,Card).

dontHave(Player, Card) :- ourColor(Player), !,  
	ourHand(Hand), 
	allCards(All),
	subtract(All, Hand, CardsNotHand),
	member(Card, CardsNotHand).
dontHave(Player, Card) :- clause(turn(_,_,_,_),true),
	legalSuggestion(Suggestion),   
	playerOrder(OrderOfPlay),
	turn(Asked,Suggestion,na,_),
	select(Asked, OrderOfPlay, BtwnPlayers),
	member(Player, BtwnPlayers),
	member(Card, Suggestion).
dontHave(Player, Card) :- clause(turn(_,_,_),true),  
	legalSuggestion(Suggestion), 
	playerOrder(OrderOfPlay),
	turn(Asked,Suggestion,na),
	select(Asked, OrderOfPlay, BtwnPlayers),
	member(Player, BtwnPlayers),
	member(Card, Suggestion).

dontHave(Player, Card) :- clause(turn(_,_,_,_),true), 
	legalSuggestion(Suggestion), 
	turn(Asked,Suggestion,Answered,_),
	inbetweenPlayers(Asked, Answered, BtwnPlayers),
	member(Player, BtwnPlayers),
	member(Card, Suggestion).
dontHave(Player, Card) :- clause(turn(_,_,_),true), 
	legalSuggestion(Suggestion),  
	turn(Asked,Suggestion,Answered),
	inbetweenPlayers(Asked, Answered, BtwnPlayers),
	member(Player, BtwnPlayers), 
	member(Card, Suggestion).
dontHave(_, Card) :- ourHand(Hand), member(Card, Hand).

/*mightHave not finding yellow for red*/
mightHave(Player, Card) :- allCards(All), cardsNotKnown(NotKnown),
	member(Card, All),
	member(Card, NotKnown),
	playerDontHave(Player, DontHave),
	subtract(All, DontHave, Z),
	member(Card, Z).

legalSuggestion([Suspect,Room,Weapon]) :- 
	suspects(Suspects), member(Suspect, Suspects), 
	rooms(Rooms), member(Room, Rooms), 
	weapons(Weapons), member(Weapon, Weapons).


/*Find players between (in order of play) the asker and answerer*/
inbetweenPlayers(Asked, Answered, []) :- 
	nextPlayer(Asked, Answered), !.
inbetweenPlayers(Asked, Answered, [NextPlayer|BtwnPlayers]) :- 
	nextPlayer(Asked, NextPlayer),
	inbetweenPlayers(NextPlayer, Answered, BtwnPlayers).


/*TODO: this doesnt work*/
/*Envelope List*/
/*Envelope Suspect*/
envelopeSuspect(Suspect) :- playerOrder(OrderOfPlay), suspects(Suspects),
	envelopeSuspect(OrderOfPlay, Suspects, Suspect).
envelopeSuspect([Player], Suspects, L) :- 
	playerDontHave(Player, Z),
	intersection(Z, Suspects, L).
envelopeSuspect([_], _, []).
envelopeSuspect([Player|ROPlayers], Suspects, CurrentIntersect) :- 
	playerDontHave(Player, Z),
	intersection(Z, Suspects, L),
	envelopeSuspect(ROPlayers, Suspects, NewIntersect),
	intersection(L, CurrentIntersect, NewIntersect).
envelopeSuspect([_|ROPlayers], Suspects, L) :- 
	envelopeSuspect(ROPlayers, Suspects, L).
/*Envelope Room*/
envelopeRoom(Room) :- playerOrder(OrderOfPlay), rooms(Rooms),
	envelopeRoom(OrderOfPlay, Rooms, Room).
envelopeRoom([Player], Rooms, L) :- 
	playerDontHave(Player, Z),
	intersection(Z, Rooms, L).
envelopeRoom([_], _, []).
envelopeRoom([Player|ROPlayers], Rooms, CurrentIntersect) :- 
	playerDontHave(Player, Z),
	intersection(Z, Rooms, L),
	envelopeRoom(ROPlayers, Rooms, NewIntersect),
	intersection(L, CurrentIntersect, NewIntersect).
envelopeRoom([_|ROPlayers], Rooms, L) :- 
	envelopeRoom(ROPlayers, Rooms, L).
/*Envelope Weapon*/
envelopeWeapon(Weapon) :- playerOrder(OrderOfPlay), weapons(Weapons),
	envelopeWeapon(OrderOfPlay, Weapons, Weapon).
envelopeWeapon([Player], Weapons, L) :- 
	playerDontHave(Player, Z),
	intersection(Z, Weapons, L).
envelopeWeapon([_], _, []).
envelopeWeapon([Player|ROPlayers], Weapons, CurrentIntersect) :- 
	playerDontHave(Player, Z),
	intersection(Z, Weapons, L),
	envelopeWeapon(ROPlayers, Weapons, NewIntersect),
	intersection(L, CurrentIntersect, NewIntersect).
envelopeWeapon([_|ROPlayers], Weapons, L) :- 
	envelopeWeapon(ROPlayers, Weapons, L).








