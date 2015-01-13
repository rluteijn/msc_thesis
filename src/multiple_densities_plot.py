'''
Created on 18 dec. 2014

@author: rluteijn
'''
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from expWorkbench import ema_logging, load_results, CategoricalUncertainty
from analysis.plotting import lines, KDE, envelopes
from analysis import plotting, plotting_util
from analysis.plotting import lines, KDE, kde_over_time, multiple_densities
from analysis.pairs_plotting import pairs_scatter
from analysis.plotting_util import plot_kde, ENVELOPE, ENV_LIN, VIOLIN
from string import index


ema_logging.log_to_stderr(ema_logging.INFO);

#load the data
fn = r'./data/500 runs.tar.gz'
experiments, outcomes = load_results(fn)
results = (experiments, outcomes)

fig, axesdict = multiple_densities(results, 
                       outcomes_to_show=["major-power-war-counter","war-counter", "polarity", "amount-conflicts", "power-transition-counter" ],
                       points_in_time=[100, 200, 300],## 500, 700, 800],
                       group_by = "coercion_on",
                       grouping_specifiers = [0,1],
                       density=KDE,
                       titles={},
                       ylabels={},
                       legend=True,
                       experiments_to_show=None,
                       plot_type=ENVELOPE,
                       log=False)

plt.show()