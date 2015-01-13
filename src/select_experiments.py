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

def group_results(results, unc, value):
    logical = experiments[unc] = value
    temp_exp = experiments[logical]
    temp_out = {}
    for key, value in outcomes.items():
        temp_out[key] = value[logical]
        return temp_exp, temp_out

unc = 'random-pAttack'
#unc = "SD-perception"
#unc = "random-pAttack"
values = set(experiments[unc])


for entry in values:
    temp_res  = group_results(results, unc, entry)
    fig, axesdict = multiple_densities(results, 
                           outcomes_to_show=["war-counter", "amount-conflicts", "power-transition-counter" ],
                           points_in_time=[100, 200, 300],
                           #group_by = 'memory-duration',
                           #grouping_specifiers = None,
                           density=KDE,
                           titles={},
                           ylabels={},
                           legend=True,
                           experiments_to_show=None,
                           plot_type=ENV_LIN,
                           log=False)
    
    plt.show()