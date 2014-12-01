# Authors
### Elizabeth Brooks 51655108
### Jonathan Mercer 22179121
# Launching clueAssist

1. download swipl on your system
* launch terminal
* navigate to the folder with **project2.pl**
* type in swipl
* type **[project2].**
* type **clueAssist.**

* * *
# Setting up the board
1. Enter all suspects like so
> **yellow red purple green white blue**
* Enter all weapons like so
> **knife rope lead_pipe wrench candlestick pistol**
* Enter all rooms like so
> **kitchen ballroom conservatory billiard_room library study hall lounge dining_room**
* Enter all cards in your hand like so
> **green kitchen knife**
* Enter players in order of play. Order matters
> **yellow red purple green white blue**

* * *
# When it's other players' turn
1. The other players will have suggestions. Write down the suggestions in the order of suspect, room, and weapon like so
> **white hall rope**
* Note down who answered that player's suggestion like so
> **blue**

Keep looping noting down information on other player's turn until it's finally your turn

* * *
# When it's your turn
## Choosing whether to accuse or suggest
* *Suggesting*: Use the list of possible suggestions that's given. Suggest the cards with the largest number beside them. For example **kitchen 5** is a better suggestion than **hall 2** The criteria for a good suggestions is 1) suggest cards that you  for sure don't know. 2) suggest cards where the most number of players say they don't have that card

* *Accusing*: Use the list given for your accusations. If clueAssist knows for sure what's in the envelope clueAssist will tell you about it otherwise you'll be given a list of cards you still don't know


## Your turn; Suggest

1. Give a suggestion like so
> **blue hall rope**
2. Write down who answered like so
> **yellow**
3. Write down what card they showed you
> **rope**

## Your turn; Accuse
1. Type **accuse** when it's your turn
2. Pick one from the list. The smaller the list the greater the change it's in the envelope. If clueAssist knows for sure what's in the envelope, clueAssist will tell you. 







 
