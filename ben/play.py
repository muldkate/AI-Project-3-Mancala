""" Main script to begin playing a match of Mancala. """


try:
    from .mancala import Match
    from .mancala import HumanPlayer
    from .ai_profiles import VectorAI
except Exception: #ImportError
    from mancala import Match
    from mancala import HumanPlayer
    from ai_profiles import VectorAI


def main():
    """ Script to begin a match of Mancala. """
    #print("Welcome to Mancala!")
    match = Match(player1_type=VectorAI, player2_type=RandomAI)
    match.handle_next_move()

if __name__ == '__main__':
    main()
