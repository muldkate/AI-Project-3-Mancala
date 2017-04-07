import numpy as np
from sklearn import svm
from sklearn.externals import joblib

a = open('games_data.txt', 'r')
b = open('games_targets.txt', 'r')
data = np.loadtxt(a)
targets = np.loadtxt(b)
clf = svm.SVC()
print("Creating a model...")
clf.fit(data, targets)
print("Model complete.")
print("Saving model to model.pkl")
joblib.dump(clf, 'model.pkl')
print("Model saved")
#TODO: Play with SVC() Parameters
#TODO: Store model
#TODO: Cross validation
#TODO: Persistant model
