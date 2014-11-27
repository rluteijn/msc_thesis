'''
Created on 26 nov. 2014

@author: rluteijn
'''
import numpy as np
import matplotlib.pyplot as plt

from analysis import prim
from expWorkbench import ema_logging, load_results

ema_logging.log_to_stderr(ema_logging.INFO);

default_flow = 2

def classify (outcomes):
    ooi = "war-counter"
    outcome = outcomes[ooi]
    
    classes = np.zeros(outcome.shape[0])
    classes[outcome<1] = 1
    return classes

fn = r'./data/8 runs.bz2'
results = load_results(fn)

##prim_obj = prim.Prim(results, classify, mass_min=0, threshold=5)

# let's find a first box
##box1 = prim_obj.find_box()

# let's analyze the peeling trajectory
##box1.show_ppt()
##box1.show_tradeoff()

##box1.write_ppt_to_stdout()

# based on the peeling trajectory, we pick entry number 44
##box1.select(44)

# show the resulting box
##prim_obj.show_boxes()
##prim_obj.write_boxes_to_stdout()

##plt.show()