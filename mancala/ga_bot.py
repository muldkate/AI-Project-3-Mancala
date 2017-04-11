""" Genetic Algorithm bot """

import sys
from functools import partial

from deap import algorithms, base, creator, gp, tools

import primitives
from ai_profiles import AIPlayer, RandomAI
from constants import P1_PITS, P2_PITS
from mancala import Match, Player, reverse_index
from random import choice


def if_then_else(condition, out1, out2):    
    out1() if condition() else out2()

def if_then_else_eligible(condition, out1, out2):    
    out1() if condition() else out2()

class GeneticAlgorithmAI(AIPlayer):
    won = False
    moves = -999
    finished_first = -999
    winner_num_pieces = -999
    
    def __reset(self):
        self.number = 1 # change to be random number
        self.board = None

    def empty_rightmost(self):
        # print(max(self.eligible_moves))
        return max(self.eligible_moves)

    def empty_leftmost(self):
        # print(max(self.eligible_moves))
        return min(self.eligible_moves)

    def make_strategy_opening_decisions(self):
        # strategy: starting game best move
        if self.match.num_turns == 0:
            # print(self.pits[2])
            return 2
        # strategy: prevent other playing from making same move
        if self.match.num_turns == 1:
            # print(self.pits[5])
            return 5
    
   # def make_strategy_decisions(self):


    def first_hole(self):
        if 0 in self.eligible_moves:
            return 0
        return choice(self.eligible_free_turns)

    def second_hole(self):
        if 1 in self.eligible_moves:
            return 1
        return choice(self.eligible_free_turns)

    def third_hole(self):
        if 2 in self.eligible_moves:
            return 2
        return choice(self.eligible_free_turns)
        
    def fourth_hole(self):
        if 3 in self.eligible_moves:
            return 3
        return choice(self.eligible_free_turns)
        
    def fifth_hole(self):
        if 4 in self.eligible_moves:
            return 4
        return choice(self.eligible_free_turns)
        
    def sixth_hole(self):
        if 5 in self.eligible_moves:
            return 5
        return choice(self.eligible_free_turns)

    def free_turn_available(self):
        free_moves = self.eligible_free_turns
        if len(free_moves) > 0:
            return True
        return False
    
    def random(self):
        x = choice(self.eligible_moves)
        # print(x)
        return x
    
    def large_pit(self):
        for pit in self.eligible_moves:
            if self.pits[pit] > 7:
                return True
        return False

    routine = random

    def if_free_turn(self, out1, out2):
        return partial(primitives.if_then_else, self.free_turn_available, out1, out2)
    
    def if_pit_is_large(self, out1, out2):
        return partial(primitives.if_then_else, self.large_pit, out1, out2 )

    # def if_eligible_move(self, out1, out2):
       #  return partial(primitives.if_then_else, eligible_move, ) 

    def get_next_move(self):
        result = self.routine()
        # print(result)
        if not result:
            result = choice(self.eligible_moves)
        return result
    
    def update(self, number, board, match):
        self.number = number
        self.board = board
        self.match = match

    def run(self, routine):
        self.__reset()      
        self.routine = routine
        self.match = Match(player1_type=RandomAI, player2_type=GeneticAlgorithmAI, param_print_game_status=False, param_matchgroup=2, training=self)
        self.num_turns = self.match.num_turns
        self.match.handle_next_move()
        self.won = self.match.winner == self.number
        self.finished_first = self.match.finished_first
        self.winner_num_pieces = self.match.winner_num_pieces
