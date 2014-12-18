'''
Created on 25 nov. 2014

@author: rluteijn
'''
from expWorkbench import save_results, ema_logging, ParameterUncertainty,CategoricalUncertainty, \
                         Outcome, ModelEnsemble
from connectors.netlogo import NetLogoModelStructureInterface

from analysis import plotting, plotting_util

import matplotlib.pyplot as plt
import time
import numpy as np


class PathOfWarModel(NetLogoModelStructureInterface):
    model_file = r'/Model 0.57.nlogo'
    
    run_length = 300
    replications = 5
    
    uncertainties = [
                    ParameterUncertainty ((0, 0.3), "SD-perception"),
                    ParameterUncertainty ((5, 10), "uW1"),
                    ParameterUncertainty ((5, 10), "uW2"),
                    ParameterUncertainty ((1, 3), "uW3"),
                    ParameterUncertainty ((1, 3), "uW4"),
                    ParameterUncertainty ((1, 3), "uW5"),
                    ParameterUncertainty ((0, 0.2), "likelihoodofresourcespresent"),
                    ParameterUncertainty ((0.1, 0.5), "reparations-factor"),
                    ParameterUncertainty ((0, 0.5), "give-in-compensation"),
                    ParameterUncertainty ((0.1, 0.5), "attritionrate"),
                    ParameterUncertainty ((0, 0.5), "attitude-decrease-bargain"),
                    ParameterUncertainty ((0, 0.5), "attitude-decrease-submitted"),
                    ParameterUncertainty ((2.5, 3.5), "Threshold-major-power"),
                    ParameterUncertainty ((0, 10), "SD-initial-trade-volume"),
                    ParameterUncertainty ((5, 20), "memory-duration", integer=True),
                    ParameterUncertainty ((1.009, 1.011), "mean-GDP-growth"),
                    ParameterUncertainty ((0, 0.05), "SD-population-growth"),
                    ParameterUncertainty ((0.9, 1.1), "mean-military-spending"),
                    ParameterUncertainty ((0.01, 0.25), "random-pAttack"),
                    ParameterUncertainty ((0, 10), "cost-of-new-trade"),
                    ##ParameterUncertainty ((10, 30), "amount-of-states", integer=True),
                    ParameterUncertainty ((0, 0.1), "SD-military-spending"),
                    ParameterUncertainty ((0, 1), "attitude-decrease-friendly"),
                    ParameterUncertainty ((30, 70), "SD-initial-military-capabilities"),
                    ParameterUncertainty ((1, 10), "Max-initial-patch-population"),
                    ParameterUncertainty ((0, 0.05), "SD-GDP-growth"),
                    ParameterUncertainty ((0, 3), "Max-initial-GDPperCapita"),
                    ParameterUncertainty ((1, 10), "mean-initial-trade-volume"),
                    ParameterUncertainty ((3, 10), "threshold-counter", integer=True),
                    ParameterUncertainty ((0.9, 1.1), "mean-Perception"),
                    ParameterUncertainty ((0, 0.1), "SD-tradevolume-growth"),
                    ParameterUncertainty ((0.9, 1.1), "mean-tradevolume-growth"),
                    ParameterUncertainty ((1.009, 1.011), "mean-population-growth"),
                    ParameterUncertainty ((0, 1), "increased-mil-spending"),
                    ##ParameterUncertainty ((0, 1), "give-in-compensation"),
                    ParameterUncertainty ((0, 0.1), "interdependence-pAttack"),
                    ParameterUncertainty ((0, 0.8), "attitude-decrease-war"),
                    ParameterUncertainty ((50, 150), "mean-initial-military-capabilities"),
                    ParameterUncertainty ((0, 10), "cost-per-distance"),                    
                    ParameterUncertainty ((0.05, 0.15), "attitude-trade-increase" ), 
                    ParameterUncertainty ((3, 7), "threshold-dissatisfaction"),
                    ParameterUncertainty ((0.1, 0.5), "distance-slope" ),
                    ParameterUncertainty ((0.1, 0.5), "attitude-increase-alliance" ),
                    ParameterUncertainty ((5, 20), "memory-length" , integer=True),
                    ParameterUncertainty ((0.5, 0.7), "pWinning-factor" ),
                    ParameterUncertainty ((0.1, 0.5), "water-percentage"),
                    
                    CategoricalUncertainty ((0, 1), "coercion_on"),
                    CategoricalUncertainty ((10, 20, 30), "worldsize" ),
                    ]
    
    outcomes = [ ## globals may be imported directly
                Outcome("states", time=True ),
                Outcome("major-power-war-counter", time=True),
                Outcome("war-counter", time=True),
                Outcome("polarity", time=True),
                Outcome("mean-interdependence", time=True),
                Outcome("mean-PFR-satisfaction", time=True),   
                Outcome("amount-conflicts", time=True),
                Outcome("power-transition-counter", time=True),          
                ]

if __name__ == '__main__':
    ema_logging.log_to_stderr(ema_logging.INFO)
    
    wd = r'C:\Users\rluteijn\OneDrive\Afstudeer\Netlogo\Officiele modellen'
    name = 'testmodel'
    msi = PathOfWarModel(wd, name) 
    
    ensemble = ModelEnsemble()
    ensemble.add_model_structure(msi)
    ensemble.parallel =  True
    
    nr_runs = 5
    results = ensemble.perform_experiments(nr_runs, reporting_interval=1)
    
    fn = r'./data/{} runs.tar.gz'.format(nr_runs)
    save_results(results, fn)  
