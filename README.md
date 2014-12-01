# Authors
### Elizabeth Brooks
### Jonathan Mercer

# Cool things we did
* * *
## Keeping track of cards people don't have

We keep a list of cards that we know each player does not have. We populate this list by keeping inferring that three suggested cards "passed" a player based on the player order. For example. Suppose the play order was as follows

> **yellow red purple green white blue**

and **red** suggests cards **A B C** and **white** says she has one of the cards, our system infers that **purple** and **green** must not have  those three suggested cards. 

Throughout the game, if all players don't have the card **D** for example. Our system will tell the player that they should accuse with **D**. 

* * *
## Listing cards people might have

We keep track of cards players might have. This is inferred based on the following list operations: 
> suspects_might_have[] = Suspect[] - Known_suspects[] - player_don't_have[]

We then sum up the list of **might haves** letting the user choose to suggest a card that most people might have. For example

> **white 5, green 0, purple 3, red 2, blue 5**

In this case, the best suggestions are **white** or **blue**