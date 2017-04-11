""" Main script to begin playing a match of Mancala. """

import sys

try:
    from .mancala import Match
    from .mancala import HumanPlayer
    from .ai_profiles import VectorAI
    from .ai_profiles import *
except Exception: #ImportError
    from mancala import Match
    from mancala import HumanPlayer
    from ai_profiles import VectorAI
    from ai_profiles import *


def main():
    """ Script to begin a match of Mancala. """
    #print("Welcome to Mancala!")
    #running vs vector multiple times
    #match = Match(player1_type=VectorAI, player2_type=VectorAI)
    #match.handle_next_move()
    #match = Match(player1_type=VectorAI, player2_type=VectorAI)
    #match.handle_next_move()
    #match = Match(player1_type=VectorAI, player2_type=VectorAI)
    #match.handle_next_move()

    opponents = [RandomAI, RightmostAI, LeftmostAI]

    for o in opponents:
        match = Match(player1_type=VectorAI, player2_type=o)
        match.handle_next_move()

if __name__ == '__main__':
    main()
