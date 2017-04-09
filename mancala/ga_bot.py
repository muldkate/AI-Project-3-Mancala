""" Genetic Algorithm bot """

from deap import algorithms, base, creator, tools, gp
from mancala import Player, reverse_index, Match
from constants import P1_PITS, P2_PITS
from ai_profiles import AIPlayer, RandomAI, GeneticAlgorithmAI
import sys

# class Train():
#     def __init__(self):
#         self.topic = 0
#         self.isProcessing = false
    

    
#     def run(self, routine):
#         self._reset()
#         while self.isProcessing:
#             routine()

class GeneticAlgorithmAI(AIPlayer):
    
    def get_next_move(self):  
        # Initialize GA      
        pset = gp.PrimitiveSet("MAIN", 0)
        
        creator.create("FitnessMax", base.Fitness, weights=(1.0,))
        creator.create("Individual", gp.PrimitiveTree, fitness=creator.FitnessMax)

        toolbox = base.Toolbox()
        # Attribute generator
        toolbox.register("expr_init", gp.genFull, pset=pset, min_=1, max_=2)
        # Structure initializers
        toolbox.register("individual", tools.initIterate, creator.Individual, toolbox.expr_init)
        toolbox.register("population", tools.initRepeat, list, toolbox.individual)

        toolbox.register("evaluate", evaluate_move)
        toolbox.register("select", tools.selTournament, tournsize=7)
        toolbox.register("mate", gp.cxOnePoint)
        toolbox.register("expr_mut", gp.genFull, min_=0, max_=2)
        toolbox.register("mutate", gp.mutUniform, expr=toolbox.expr_mut, pset=pset)
        
        # Run 'breeding'
        pop = toolbox.population(n=300)
        hof = tools.HallOfFame(3)
        stats = tools.Statistics(lambda ind: ind.fitness.values)
        stats.register("avg", numpy.mean)
        stats.register("std", numpy.std)
        stats.register("min", numpy.min)
        stats.register("max", numpy.max)
        
        algorithms.eaSimple(pop, toolbox, 0.5, 0.2, 40, stats, halloffame=hof)
        
        orig_stdout = sys.stdout
        sys.stdout = open('./genetic_algorithm/out.txt', 'a')
        #print 'Eligible moves: ', self.eligible_moves()
        print('Pits: ', self.pits)
        print('Board: ', self.board.textify_board())
        print('GA: ', tools.selBest(pop, 1))
        sys.close()     
        sys.stdout = orig_stdout

        return pop, hof, stats

        def evaluate_move(move):
            possible_move = gp.compile(move, pset)
            # Run a simulation with same GA and board
            match = Match(player1_type=RandomAI, player2_type=self, param_print_game_status=False, param_matchgroup=x)
            match.board = self.board
            match.handle_next_move()
            # Consider this move a success if we are winner, maximizes number of pieces
            if match.winner == 2:
                return match.winner_num_pieces
            return 0

        # move = choice(self.eligible_moves)
        # if self.print_game_status:
        #     print("AI chose " + str(move))
        # return move

    def take_free_turns(self):
        free_moves = eligible_free_turns()
        if len(eligible_moves) > 0:
            return free_moves
        return 0
    