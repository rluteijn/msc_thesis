'''
Created on 18 dec. 2014

@author: rluteijn
'''
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from expWorkbench import ema_logging, load_results, save_results
from analysis.plotting import lines, KDE, envelopes
from analysis import plotting, plotting_util
from analysis.plotting import lines, KDE, kde_over_time, multiple_densities
from analysis.pairs_plotting import pairs_scatter
from analysis.plotting_util import plot_kde, ENVELOPE, ENV_LIN

ema_logging.log_to_stderr(ema_logging.INFO);

#load the data
fn = r'C:\Users\rluteijn\Documents\GitHub\msc_thesis\src\data\500 runs 19 jan.tar.gz'
experiments, outcomes = load_results(fn)
results = (experiments, outcomes)

outcome1 = outcomes["Output-FPR-end1"]
outcome1 = outcome1[0]
value1 = 0
logical = outcome1 > value1
temp_experiments = experiments[logical]
temp_outcomes = {key:value[logical] for key, value in outcomes.iteritems()}
 
print 'number of selected cases: {}'.format(np.sum(logical))
 
results1 = (temp_experiments, temp_outcomes)
 
fn = r'./data/revised.tar.gz'
save_results(results1, fn)
# 
