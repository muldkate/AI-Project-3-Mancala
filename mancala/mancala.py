""" Mancala app. """

try:
    from .constants import DEFAULT_NAME, P1_PITS, P2_PITS, P1_STORE, P2_STORE
    from .board import Board, InvalidMove
except Exception: #ImportError
    from constants import DEFAULT_NAME, P1_PITS, P2_PITS, P1_STORE, P2_STORE
    from board import Board, InvalidMove

import sys


class Player(object):
    """ A player of Mancala. """

    def __init__(self, number=None, board=None, name=DEFAULT_NAME, param_print_game_status=True):
        self.name = name
        self.number = number
        self.board = board

    def __str__(self):
        return "Player: %s" % self.name

    def get_name(self):
        """ Returns player name. """
        return self.name
    

class Match(object):
    num_turns = 0
    winner_num_pieces = -999
    finished_first = -999
    winner = -999

    """ A match of Mancala has two Players and a Board.

    Match tracks current turn.

    """

    def __init__(self, player1_type=Player, player2_type=Player, param_print_game_status=True, filename="default.txt", param_matchgroup=0, training=None):
        """ Initializes a new match. """
        self.board = Board(param_print_game_status=param_print_game_status)
        if training:
            self.players = [player1_type(1, self.board, self, player1_type.__name__), training]
            training.number = 2
            training.board = self.board
            training.match = self
        else:
            self.players = [player1_type(1, self.board, self, player1_type.__name__, param_print_game_status=param_print_game_status), player2_type(2, self.board, self, player2_type.__name__, param_print_game_status=param_print_game_status)]
        self.player1 = self.players[0]
        self.player1_name = player1_type.__name__
        self.player2 = self.players[1]
        if training:
            self.player2_name = player2_type.__name__
        else:
            self.player2_name = "GA_Iteration"
        self.current_turn = self.player1
        self.print_game_status = param_print_game_status
        # Variables for gathering statistics
        self.filename = filename
        self.winner = -999
        self.finished_first = -999
        self.winner_num_pieces = -999
        self.num_turns = 0
        self.matchgroup = param_matchgroup

    def write_game_stats(self): 
        #print (self.player1_name + ' vs ' + self.player2_name + ' Finished First: ' + str(self.finished_first) 
        #    + ' Winner: ' + str(self.winner) +' Winner # Pieces: ' + str(self.winner_num_pieces) 
        #    + ' # Turns : ' + str(self.num_turns))
        file = open(self.filename, "a")
        # Write to file with ',' as separator
        # player1name, player2name, finished_first_player_name, winner_player_name, winner_num_pieces, num_turns
        file.write(str(self.matchgroup) + ',') 
        file.write(self.player1_name + ',')
        file.write(self.player2_name + ',')
        file.write(str(self.finished_first) + ',')
        file.write(str(self.winner) +',')
        file.write(str(self.winner_num_pieces) + ',')
        file.write(str(self.num_turns))
        # End observation
        file.write('\n')
        file.close()

    def handle_next_move(self):
        """ Shows board and handles next move. """
        # Increment the number of turns played, a turn is always taken
        self.num_turns = self.num_turns + 1
        if self.print_game_status == True:
            print (self.board.textify_board())

        next_move = self.current_turn.get_next_move()
        try:
            self.board.board, free_move_earned = self.board._move_stones(self.current_turn.number, next_move)
        except InvalidMove:
            # Check whether game was won by AI.
            #if self._check_for_winner():
            #    print ("finished")
                #sys.exit()
            if self.current_turn.__class__ == HumanPlayer and self.print_game_status == True:
                print ("Please select a move with stones you can move.")
            self.handle_next_move()

        # Check whether game was won.
        if self._check_for_winner():
            #print ("finished")
            return True
            #sys.exit()

        # Check whether free move was earned
        if free_move_earned:
            self.handle_next_move()
        else:
            self._swap_current_turn()
            self.handle_next_move()


    def _swap_current_turn(self):
        """ Swaps current turn to the other player. """
        if self.current_turn == self.player1:
            self.current_turn = self.player2
            return self.player2
        else:
            self.current_turn = self.player1
            return self.player1

    def _check_for_winner(self):
        """ Checks for winner. Announces the win."""
        if set(self.board.board[P1_PITS]) == set([0]):
            self.board.board = self.board.gather_remaining(self.player2.number)
            if self.print_game_status:
                print ("Player 1 finished! %s: %d to %s: %d turns: %d" % (self.player1_name, self.board.board[P1_STORE][0], self.player2.name, self.board.board[P2_STORE][0], self.num_turns))
            self.finished_first = 1
            if self.board.board[P1_STORE][0] > self.board.board[P2_STORE][0]:
                self.winner = 1
                self.winner_num_pieces = self.board.board[P1_STORE][0]
            elif self.board.board[P2_STORE][0] > self.board.board[P1_STORE][0]:
                self.winner = 2
                self.winner_num_pieces = self.board.board[P2_STORE][0]
            else:
                self.winner = 0
                self.winner_num_pieces = self.board.board[P2_STORE][0]
            self.write_game_stats()
            return True
        elif set(self.board.board[P2_PITS]) == set([0]):
            self.board.board = self.board.gather_remaining(self.player1.number)
            if self.print_game_status:
                print ("Player 2 finished! %s: %d to %s: %d  turns: %d" % (self.player1_name, self.board.board[P1_STORE][0], self.player2.name, self.board.board[P2_STORE][0], self.num_turns))
            self.finished_first = 2
            if self.board.board[P1_STORE][0] > self.board.board[P2_STORE][0]:
                self.winner = 1
                self.winner_num_pieces = self.board.board[P1_STORE][0]
            elif self.board.board[P2_STORE][0] > self.board.board[P1_STORE][0]:
                self.winner = 2
                self.winner_num_pieces = self.board.board[P2_STORE][0]
            else:
                self.winner = 0
                self.winner_num_pieces = self.board.board[P2_STORE][0]
            self.write_game_stats()            
            return True
        else:
            return False

class HumanPlayer(Player):
    """ A human player. """

    def __init__(self, number, board, name=None, param_print_game_status = True):
        super(HumanPlayer, self).__init__(number, board)
        if name:
            self.name = name
        else:
            self.name = self.get_human_name()

    def get_human_name(self):
        """ Asks human players to specify their name. """
        return input("Please input your name: ")

    def get_next_move(self):
        """ Gets next move from a human player. """
        value = input("Please input your next move (1 to 6): ")
        return int(value) - 1

def reverse_index(index):
    """ Returns the mirror index to the one given. """
    rev_index = list(range(0, 6))
    rev_index.reverse()
    return rev_index[index]
