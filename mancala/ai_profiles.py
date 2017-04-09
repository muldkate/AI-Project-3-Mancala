""" Module for Mancala AI Profiles. """

from random import choice
from sklearn.externals import joblib
from sklearn import svm
import time

try:
    from .mancala import Player, reverse_index
    from .constants import AI_NAME, P1_PITS, P2_PITS
except Exception: #ImportError
    from mancala import Player, reverse_index
    from constants import AI_NAME, P1_PITS, P2_PITS

class AIPlayer(Player):
    """ Base class for an AI Player """
    def __init__(self, number, board, name=AI_NAME, param_print_game_status=True):
        """ Initializes an AI profile. """
        self.print_game_status = param_print_game_status
        super(AIPlayer, self).__init__(number, board, name)

    @property
    def pits(self):
        """ Shortcut to AI pits. """
        if self.number == 1:
            return self.board.board[P1_PITS]
        else:
            return self.board.board[P2_PITS]
    @property
    def allpits(self):
        """ Returns all board pits """
        if self.number == 1:
            return self.board.board[P1_PITS] + self.board.board[P2_PITS]
        else:
            return self.board.board[P2_PITS] + self.board.board[P1_PITS]

    @property
    def eligible_moves(self):
        """ Returns a list of integers representing eligible moves. """
        eligible_moves = []
        for i in range(len(self.pits)):
            if not self.pits[i] == 0:
                eligible_moves.append(i)
        return eligible_moves

    @property
    def eligible_free_turns(self):
        """ Returns a list of indexes representing eligible free turns. """

        free_turn_indices = list(range(1, 7))
        free_turn_indices.reverse()

        elig_free_turns = []

        for i in range(0, 6):
            if self.pits[i] == free_turn_indices[i]:
                elig_free_turns.append(1)
            else:
                elig_free_turns.append(0)

        return elig_free_turns

class RandomAI(AIPlayer):
    """ AI Profile that randomly selects from eligible moves. """

    def get_next_move(self):
        """ Returns next AI move based on profile. """
        move = choice(self.eligible_moves)
        if self.print_game_status:
            print ("AI chose " + str(move))
        return move

class VectorAI(AIPlayer):
    """ AI Profile using a simple vector decision method. Optimize
        for free turns and captures. """

    def get_next_move(self):
        """ Use an reverse indices vector to optimize for free turns. """

        reverse_indices = list(range(0, 6))
        reverse_indices.reverse()

        # First optimize for free moves.
        for i in reverse_indices:
            if self.eligible_free_turns[i] == 1:
                if self.pits[i] == reverse_index(i) + 1:
                    if self.print_game_status:
                        print ("VectorAI, mode 1, playing: " + str(i))
                    return i
        # Then clear out inefficient pits.
        for i in reverse_indices:
            if self.pits[i] > reverse_index(i) + 1:
                if self.print_game_status:
                    print ("VectorAI, mode 2, playing: " + str(i))
                return i
        # Finally, select a random eligible move.
        if self.print_game_status:
            print ("VectorAI, mode 3, playing an eligible move.")
        return choice(self.eligible_moves)

class LeftmostAI(AIPlayer):
    """ AI Profile that always chooses the first legal move when scanning from the left. """

    def get_next_move(self):
        """ Use an reverse indices vector to optimize for free turns. """
        move = min(self.eligible_moves)
        print(self.allpits)
        if self.print_game_status:
            print ("AI chose " + str(move))
        return move

class RightmostAI(AIPlayer):
    """ AI Profile that always chooses the first legal move when scanning from the right. """

    def get_next_move(self):
        move = max(self.eligible_moves)
        if self.print_game_status:
            print ("AI chose " + str(move))
        return move

class MLAI(AIPlayer):
    """ Machine Learning bot """
    def get_next_move(self):
        clf = joblib.load('model.pkl')
        move = clf.predict(self.allpits)
        print("Move is " + str(move[0]))
        if self.print_game_status:
            if int(move[0]) in self.eligible_moves:
                print("AI going with model")
                print("AI chose: " + str(move[0] + 1))
                return int(move[0])
            else:
                print("AI going with rand")
                move = choice(self.eligible_moves)
                print("AI chose: " + str(move))
                return move
