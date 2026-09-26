type Player = int
predicate ValidPlayer(p: Player) {
  p == 1 || p == 2 // 1 = Player X, 2 = Player O
}

class TicTacToe {
  var board: array<int>
  var currentTurn: int

  // Initialize an empty 9-element board
  constructor Init()
  ensures fresh(board)
  ensures board.Length == 9
  ensures forall i :: 0 <= i < 9 ==> board[i] == 0
  ensures currentTurn == 1
  {
    board := new int[9](i => 0);
    currentTurn := 1;
  }

  // Check if player p has won
  predicate IsWin(p: int)
  reads this, board
  requires board.Length == 9
  {
    // Rows
       (board[0] == p && board[1] == p && board[2] == p)
    || (board[3] == p && board[4] == p && board[5] == p)
    || (board[6] == p && board[7] == p && board[8] == p)
    // Columns
    || (board[0] == p && board[3] == p && board[6] == p)
    || (board[1] == p && board[4] == p && board[7] == p)
    || (board[2] == p && board[5] == p && board[8] == p)
    // Diagonals
    || (board[0] == p && board[4] == p && board[8] == p)
    || (board[2] == p && board[4] == p && board[6] == p)
  }

  // Make a move with verification contract
  method PlayMove(p: int, pos: int)
  modifies this, this.board
  requires board.Length == 9
  requires 0 <= pos < 9
  requires ValidPlayer(p)
  requires board[pos] == 0
  requires p == currentTurn

  ensures board == old(board)
  ensures board[pos] == p
  ensures forall i :: 0 <= i < 9 && i != pos ==> board[i] == old(board[i])
  ensures currentTurn == if p == 1 then 2 else 1
  {
    board[pos] := p;
    // Swap the turn
    if currentTurn == 1 {
      currentTurn := 2;
    } else {
      currentTurn := 1;
    }
  }

  // Helper to print a single cell
  method PrintCell(c: int) {
    if c == 0 { print "   "; }
    else if c == 1 { print " X "; }
    else if c == 2 { print " O "; }
  }

  // Print the entire board (visualization purposes)
  method PrintBoard()
  requires board.Length == 9
  {
    print "\n";
    PrintCell(board[0]); print "|"; PrintCell(board[1]); print "|"; PrintCell(board[2]); print "\n";
    print "-----------\n";
    PrintCell(board[3]); print "|"; PrintCell(board[4]); print "|"; PrintCell(board[5]); print "\n";
    print "-----------\n";
    PrintCell(board[6]); print "|"; PrintCell(board[7]); print "|"; PrintCell(board[8]); print "\n\n";
  }
}

method Main() {
  var game := new TicTacToe.Init();
  // Sample game!
  print "Game started!\n\n";
  game.PlayMove(1, 4);
  game.PrintBoard();
  game.PlayMove(2, 0);
  game.PrintBoard();
  game.PlayMove(1, 2);
  game.PrintBoard();
  game.PlayMove(2, 1);
  game.PrintBoard();
  game.PlayMove(1, 6);
  game.PrintBoard();
  var xWon := game.IsWin(1);
  var oWon := game.IsWin(2);
  print "Did Player 1 (X) win? ", xWon, "\n";
  print "Did Player 2 (O) win? ", oWon, "\n";
  assert game.board[2] == 1 && game.board[4] == 1 && game.board[6] == 1;
  assert game.IsWin(1);
}
