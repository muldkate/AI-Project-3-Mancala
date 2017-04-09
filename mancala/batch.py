""" Main script to begin playing a match of Mancala. """


try:
    from .mancala import Match
    from .mancala import HumanPlayer
    from .ai_profiles import RandomAI
    from .ai_profiles import VectorAI
    from .ai_profiles import LeftmostAI
    from .ai_profiles import RightmostAI
except Exception: #ImportError
    from mancala import Match
    from mancala import HumanPlayer
    from ai_profiles import RandomAI
    from ai_profiles import VectorAI
    from ai_profiles import LeftmostAI
    from ai_profiles import RightmostAI


def main():
    """ Script to run a matchs of Mancala. """
    num_matches = 1000
    matchlist = [
        [ RandomAI, RandomAI ],
        #[ VectorAI, RandomAI ],
        #[ VectorAI, VectorAI ],
        #[ LeftmostAI, RandomAI ],
        #[ LeftmostAI, VectorAI ],
        #[ LeftmostAI, LeftmostAI ],
		#[ RightmostAI, RandomAI ],
        #[ RightmostAI, VectorAI ],
        #[ RightmostAI, LeftmostAI ],
        #[ RightmostAI, RightmostAI ]
    ]

    x=0
    while x < len(matchlist):
       
        print ("Running " + str(num_matches) + " matches: " + matchlist[x][0].__name__ + " vs " + matchlist[x][1].__name__)
        counter = 0 
    
        while counter < num_matches:
            counter = counter + 1
            match = Match(player1_type=matchlist[x][0], player2_type=matchlist[x][1], param_print_game_status=False, param_matchgroup=x)
            match.handle_next_move()

        if matchlist[x][0] != matchlist[x][1]:
            print ("Running " + str(num_matches) + " matches: " + matchlist[x][1].__name__ + " vs " + matchlist[x][0].__name__)
            counter = 0

            while counter < num_matches:
                counter = counter + 1
                match = Match(player1_type=matchlist[x][1], player2_type=matchlist[x][0], param_print_game_status=False, param_matchgroup=x)
                match.handle_next_move()
        x = x+1
    
    print ("Matches Finished")    

if __name__ == '__main__':
    main()
