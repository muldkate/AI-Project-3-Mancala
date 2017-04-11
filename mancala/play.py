""" Main script to begin playing a match of Mancala. """


try:
    from .mancala import Match
    from .mancala import HumanPlayer
    from .ai_profiles import VectorAI
    from .ai_profiles import RandomAI
    from .ai_profiles import LeftmostAI
    from .ai_profiles import MLAI
except Exception: #ImportError
    from mancala import Match
    from mancala import HumanPlayer
    from ai_profiles import VectorAI
    from ai_profiles import RandomAI
    from ai_profiles import LeftmostAI
    from ai_profiles import MLAI

def main():
    """ Script to begin a match of Mancala. """
    print ("Welcome to Mancala!")

    # (optional) dynamic player types
    match = Match(player1_type=HumanPlayer, player2_type=LeftmostAI, param_print_game_status=True)

    match.handle_next_move()
   

if __name__ == '__main__':
    main()
