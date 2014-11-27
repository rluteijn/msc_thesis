'''
Created on 27 nov. 2014

@author: rluteijn
'''
import numpy as np
import matplotlib.pyplot as plt

from expWorkbench import ema_logging, load_results
##from analysis.plotting import lines, KDE, envelopes
from analysis import plotting, plotting_util

ema_logging.log_to_stderr(ema_logging.INFO);

#load the data
fn = r'./data/100_runs.bz2'
experiments, outcomes = load_results(fn)

results = (experiments, outcomes)

plotting.lines(results, density=plotting_util.KDE)
plt.show() 
