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
from analysis.plotting import lines, KDE, kde_over_time, multiple_densities, single_envelope
from analysis.pairs_plotting import pairs_scatter, pairs_lines, pairs_density
from analysis.plotting_util import plot_kde, ENVELOPE, ENV_LIN, plot_violinplot
from matplotlib.pyplot import violinplot


ema_logging.log_to_stderr(ema_logging.INFO);

#load the data
fn = r'./data/800 runs.tar.gz'
experiments, outcomes = load_results(fn)
results = (experiments, outcomes)



fig, axes = plot_violinplot('time', (experiments, 'war-counter'), log = False, group_labels=None) 


#tr = {}

#for key, value in outcomes.items():
#    if key == 'war-counter':
#        tr[key] = value[:,-1] #we want the end value
#        # we want the maximum value of the peak
#        tr['max'] = np.max(value)
#        tr['min'] = np.min(value)
#        tr['mean'] = np.mean(value)
 #       tr['SD'] = np.std(value)
    #if key == 'time':
     #   tr['Time'] = time
               
        #logical = value.T==np.max(value, axis=1)
        #tr['time of max'] = time[logical.T]
        
#fig, axes = lines((experiments, tr))
plt.show() 