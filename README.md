# Verified Tic-Tac-Toe (Dafny)

A formally verified implementation of Tic-Tac-Toe written in Dafny with the constraints:
* Turn alternation
* Valid moves: a player can only place a piece on an empty square within the bounds of the 3x3 grid
* Board state persistence: when a move is made, the rest of the board remains unchanged 
* Win condition: predicate evaluates rows, columns, and diagonals to detect a win
