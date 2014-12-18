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
from analysis.plotting_util import plot_kde, ENVELOPE, ENV_LIN

ema_logging.log_to_stderr(ema_logging.INFO);

#load the data
fn = r'./data/800 runs.tar.gz'
experiments, outcomes = load_results(fn)
results = (experiments, outcomes)

logical = experiments['random-pAttack'] == 0.05
new_experiments = experiments[ logical ]
new_results = {}
for key, value in outcomes.items():
    new_results[key] = value[logical]

results = (new_experiments, new_results)

plt.show()