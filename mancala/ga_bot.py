""" Genetic Algorithm bot """

import sys
from functools import partial

from deap import algorithms, base, creator, gp, tools

import primitives
from ai_profiles import AIPlayer, RandomAI
from constants import P1_PITS, P2_PITS
from mancala import Match, Player, reverse_index


def if_then_else(condition, out1, out2):    
    out1() if condition() else out2()

class GeneticAlgorithmAI(AIPlayer):
    won = False
    moves = -999
    finished_first = -999
    winner_num_pieces = -999

    """ Base class for an AI Player """
   # def __init__(self, number, board, match):
    #    super(AIPlayer, self).__init__(number, board)
    
    def __reset(self):
        self.number = 1 # change to be random number
        self.board = None

    def empty_rightmost(self):
        return max(self.eligible_moves)

    def make_strategy_decisions(self):
        # strategy: starting game best move
        if self.match.num_turns == 0:
            return self.pits[2]
        # strategy: prevent other playing from making same move
        if self.match.num_turns == 1:
            return self.pits[5]

    def free_turn_available(self):
        free_moves = self.eligible_free_turns()
        if len(free_moves) > 0:
            return True
        return False
    
    def random(self):
        return choice(self.eligible_moves)

    routine = None

    def if_free_turn(self, out1, out2):
        return partial(primitives.if_then_else, self.free_turn_available, out1, out2)

    def get_next_move(self):
        return self.routine
    
    def update(self, number, board, match):
        self.number = number
        self.board = board
        self.match = match

    def run(self, routine):
        self.__reset()      
        self.routine = routine
        self.match = Match(player1_type=RandomAI, player2_type=GeneticAlgorithmAI, param_print_game_status=False, param_matchgroup=2, training=self)
        self.match.handle_next_move()
        self.won = self.match.winner == self.number
        self.finished_first = self.match.finished_first
        self.winner_num_pieces = self.match.winner_num_pieces
