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

def main(player1=None, player2=None):
    """ Script to begin a match of Mancala. """
    print ("Welcome to Mancala!")

    # (optional) dynamic player types
    if player1 is None:
        player1 = RandomAI
    if player2 is None:
        player2 = LeftmostAI

    match = Match(player1_type=player1, player2_type=player2, param_print_game_status=True)
    match.handle_next_move()
   

if __name__ == '__main__':
    main()
