'''
Created on 20 jan. 2015

@author: rluteijn
'''
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import scipy as sc
import pandas as pa

from expWorkbench import ema_logging, load_results, CategoricalUncertainty
from analysis import plotting, plotting_util
from analysis.plotting import lines, KDE, kde_over_time, multiple_densities, envelopes
from analysis.pairs_plotting import pairs_scatter
from analysis.plotting_util import plot_kde, ENVELOPE, ENV_LIN, VIOLIN

ema_logging.log_to_stderr(ema_logging.INFO);

#load the data
fn = r'C:\Users\rluteijn\Documents\GitHub\msc_thesis\src\data\500 runs 19 jan.tar.gz'
experiments, outcomes = load_results(fn)
results = (experiments, outcomes)

fig, axesdict = pairs_scatter(results, 
                  outcomes_to_show = [
                    "Output-Inflection-point-end1",
                    "Output-Inflection-point-end2",
                    "Output-FPR-end1",
                    "Output-FPR-end2",
                    "Output-Power-end1",
                    "Output-Power-end2",
                    "Output-Interdependence-end1end2",
                    "Output-Conflict-level-end1end2",
                    ],
                  group_by = None,
                  grouping_specifiers = None,
                  ylabels = {},
                  legend=True,
                  point_in_time=-1,
                  filter_scalar=True
                  )
plt.show()