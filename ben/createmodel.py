import numpy as np
from sklearn import svm

a = open('games_data.txt', 'r')
b = open('games_targets.txt', 'r')
data = np.loadtxt(a)
targets = np.loadtxt(b)
clf = svm.SVC()
#TODO: Play with SVC() Parameters
#TODO: Store model
#TODO: Cross validation
#TODO: Persistant model
