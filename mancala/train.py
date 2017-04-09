""" Training of genetic algorithm """

import sys
from functools import partial

from deap import algorithms, base, creator, gp, tools

from ai_profiles import AIPlayer, LeftmostAI, RandomAI, VectorAI
from mancala import Match, Player, reverse_index


# from ga_bot import GeneticAlgorithmAI

def if_then_else(condition, out1, out2):
    out1() if condition() else out2()
    
class Train(AIPlayer):
    def take_free_turns(self):
        free_moves = eligible_free_turns()
        if len(eligible_moves) > 0:
            return free_moves
        return 0

    def if_moves(self, out1, out2):
        return partial(if_then_else, self.eligible_moves(), out1, out2)
        
    def __init__(self):
        # Run a simulation with same GA and board
        self.match = Match(player1_type=RandomAI, player2_type=Train, param_print_game_status=False, param_matchgroup=1)
        # self.match.board = self.board
        self.match.handle_next_move()


train = Train()

print("starting")
pset = gp.PrimitiveSet("MAIN", 0)
pset.addPrimitive()
pset.addTerminal(train.take_free_turns)

creator.create("FitnessMax", base.Fitness, weights=(1.0,))
creator.create("Individual", gp.PrimitiveTree,
                fitness=creator.FitnessMax)

toolbox = base.Toolbox()
toolbox.register("expr_init", gp.genFull, pset=pset, min_=1, max_=2)
toolbox.register("individual", tools.initIterate,
                    creator.Individual, toolbox.expr_init)
toolbox.register("population", tools.initRepeat,
                    list, toolbox.individual)

def evaluate_move(move):
    possible_move = gp.compile(move, pset)
    # Consider this move a success if we are winner, maximizes number of pieces
    possible_move()
    if train.match.winner == 2:
        return train.match.winner_num_pieces
    return 0

toolbox.register("evaluate", evaluate_move)
toolbox.register("select", tools.selTournament, tournsize=7)
toolbox.register("mate", gp.cxOnePoint)
toolbox.register("expr_mut", gp.genFull, min_=0, max_=2)
toolbox.register("mutate", gp.mutUniform,
                    expr=toolbox.expr_mut, pset=pset)
        
def main():
    # Run 'breeding'
    pop = toolbox.population(n=5)
    hof = tools.HallOfFame(3)
    stats = tools.Statistics(lambda ind: ind.fitness.values)
    stats.register("avg", numpy.mean)
    stats.register("std", numpy.std)
    stats.register("min", numpy.min)
    stats.register("max", numpy.max)
    print("done")
    algorithms.eaSimple(pop, toolbox, 0.5, 0.2, 40, stats, halloffame=hof)

    orig_stdout = sys.stdout
    sys.stdout = open('genetic_algorithm/out.txt', 'a')
    # print 'Eligible moves: ', self.eligible_moves()
    print('Pits: ', self.pits)
    print('Board: ', self.board.textify_board())
    print('GA: ', tools.selBest(pop, 1))
    sys.close()
    sys.stdout = orig_stdout

    print(pop, hof, stats)

if __name__ == '__main__':
    main()
