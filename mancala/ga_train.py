""" Training of genetic algorithm """

import sys
from functools import partial

from deap import algorithms, base, creator, gp, tools

from ai_profiles import AIPlayer, LeftmostAI, RandomAI, VectorAI
from mancala import Match, Player
from ga_bot import GeneticAlgorithmAI
from docopt import docopt
# import pygraphviz as pgv
import primitives
import numpy

ai_player = GeneticAlgorithmAI(2, None, None, GeneticAlgorithmAI.__name__)

print("starting...")
pset = gp.PrimitiveSet("MAIN", 0)
pset.addPrimitive(ai_player.if_free_turn, 2)
pset.addPrimitive(ai_player.if_pit_is_large, 2)
pset.addTerminal(ai_player.make_strategy_opening_decisions)
pset.addTerminal(ai_player.empty_rightmost)
pset.addTerminal(ai_player.empty_leftmost)
pset.addTerminal(ai_player.first_hole)
pset.addTerminal(ai_player.second_hole)
pset.addTerminal(ai_player.third_hole)
pset.addTerminal(ai_player.fourth_hole)
pset.addTerminal(ai_player.fifth_hole)
pset.addTerminal(ai_player.sixth_hole)
pset.addPrimitive(primitives.seq2, 2)
pset.addPrimitive(primitives.seq3, 3)

creator.create("FitnessMax", base.Fitness, weights=(1.0, -.3, .4))
creator.create("Individual", gp.PrimitiveTree, fitness=creator.FitnessMax)

toolbox = base.Toolbox()
toolbox.register("expr_init", gp.genFull, pset=pset, min_=1, max_=2)
toolbox.register("individual", tools.initIterate, creator.Individual, toolbox.expr_init)
toolbox.register("population", tools.initRepeat, list, toolbox.individual)

def evaluate_move(move):
    possible_move = gp.compile(move, pset)
    ai_player.run(possible_move)
    num_pieces = ai_player.winner_num_pieces if ai_player.won else 0.0
    return 1.0 if ai_player.won else 0.0, ai_player.num_turns, ai_player.winner_num_pieces

toolbox.register("evaluate", evaluate_move)
toolbox.register("select", tools.selTournament, tournsize=7)
toolbox.register("mate", gp.cxOnePoint)
toolbox.register("expr_mut", gp.genFull, min_=0, max_=2)
toolbox.register("mutate", gp.mutUniform, expr=toolbox.expr_mut, pset=pset)
        
def main():
    # Run 'breeding'
    pop = toolbox.population(n=300)
    hof = tools.HallOfFame(1)
    orig_stdout = sys.stdout
    f = open('ga_history.txt', 'w')
    sys.stdout = f
    print('stats')
    stats = tools.Statistics(lambda ind: ind.fitness.values)
    stats.register("avg", numpy.mean)
    stats.register("std", numpy.std)
    stats.register("min", numpy.min)
    stats.register("max", numpy.max)
    algorithms.eaSimple(pop, toolbox, 0.5, 0.2, 40, stats, halloffame=hof)
    expr = gp.genFull(pset, min_=1, max_=3)
    tree = gp.PrimitiveTree(expr)
    print('Tree')
    print(str(tree))
    # print 'Eligible moves: ', self.eligible_moves()
    #print('Pits: ', self.pits)
    #print('Board: ', self.board.textify_board())
    # print(pop, hof, stats)
    f.close()
    sys.stdout = orig_stdout
    # function = gp.compile(hof, pset)
    # print(function)
    print("done")
    # print(pop, hof, stats)
    return pop, hof, stats

if __name__ == '__main__':
    #args = docopt(usage, argv=None, help=True, version=None, options_first=False)
    pop, hof, stats = main()
    #nodes, edges, labels = gp.graph(hof[0])

    #g = pgv.AGraph()
    #g.add_nodes_from(nodes)
    #g.add_edges_from(edges)
    #g.layout(prog='dot')

    #for i in nodes:
    #    n = g.get_node(i)
    #    n.attr['label'] = labels[i]

    #g.draw('tree.pdf')

