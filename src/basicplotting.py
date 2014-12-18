'''
Created on 27 nov. 2014

@author: rluteijn
'''
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from expWorkbench import ema_logging, load_results, CategoricalUncertainty
from analysis.plotting import lines, KDE, envelopes
from analysis import plotting, plotting_util
from analysis.plotting import lines, KDE, kde_over_time, multiple_densities
from analysis.pairs_plotting import pairs_scatter, pairs_lines, pairs_density
from analysis.plotting_util import plot_kde, ENVELOPE, ENV_LIN, plot_violinplot


ema_logging.log_to_stderr(ema_logging.INFO);

#load the data
fn = r'./data/800 runs.tar.gz'
experiments, outcomes = load_results(fn)
results = (experiments, outcomes)

tr = {}

# get time and remove it from the dict
#time = outcomes.pop('TIME')

for key, value in outcomes.items():
    if key == 'war-counter':
        tr[key] = value[:,-1] #we want the end value
    else:
        # we want the maximum value of the peak
        max_peak = np.max(value, axis=1) 
        tr['max'] = max_peak
        
        # we want the time at which the maximum occurred
        # the code here is a bit obscure, I don't know why the transpose 
        # of value is needed. This however does produce the appropriate results
        #logical = value.T==np.max(value, axis=1)
        # tr['time of max'] = time[logical.T]
        
pairs_scatter((experiments, tr), filter_scalar=False)
pairs_lines((experiments, outcomes))
pairs_density((experiments, tr), filter_scalar=False)
plt.show() 