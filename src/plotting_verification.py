'''
Created on 6 jan. 2015

@author: rluteijn
'''
import numpy as np
import matplotlib.pyplot as plt


from expWorkbench import ema_logging, load_results
from analysis import plotting, plotting_util
from analysis.plotting import lines, KDE, kde_over_time, multiple_densities, envelopes
from analysis.pairs_plotting import pairs_scatter, pairs_density
from analysis.plotting_util import plot_kde, ENVELOPE, ENV_LIN, VIOLIN, BOXPLOT,\
    plot_boxplots
    
import matplotlib as mpl 

ema_logging.log_to_stderr(ema_logging.INFO);

#load the data
fn = r'./data/1000 runs 5 jan.tar.gz'
experiments, outcomes = load_results(fn)
results = (experiments, outcomes)

# tr = {"count-1", "count-2", "count-3", "count-4", "count-5", "count-6", "count-7"}
tr = {}
fig = plt.figure(1, figsize=(9, 6))
ax = fig.add_subplot(111)

for key, value in outcomes.items():
    if key == "war-counter":
        tr[key] = value[:] #we want the end value
        bp = plot_boxplots(ax, (experiments, tr), log=False, group_labels=None)

# Create the boxplot
# bp = ax.boxplot(results)




plt.show()

