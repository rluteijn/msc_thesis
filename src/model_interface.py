'''
Created on 25 nov. 2014

@author: rluteijn
'''
from expWorkbench import save_results, ema_logging, ParameterUncertainty,\
                         Outcome, ModelEnsemble
from connectors.netlogo import NetLogoModelStructureInterface

from analysis import plotting, plotting_util

import matplotlib.pyplot as plt


class PathOfWarModel(NetLogoModelStructureInterface):
    model_file = r'/Model 0.46B.nlogo'
    
    run_length = 300
    
    uncertainties = [
                     ParameterUncertainty ((0, 1), "SD-perception"),
                     ParameterUncertainty ((0, 10), "W1"),
                     ParameterUncertainty ((0, 10), "W2"),
                     ParameterUncertainty ((0, 10), "W3"),
                     ParameterUncertainty ((0, 10), "W4"),
                     ParameterUncertainty ((0, 10), "W5"),
                     ParameterUncertainty ((0, 0.5), "likelihoodofresourcespresent"),
                     ParameterUncertainty ((0, 0.5), "reparations-factor"),
                     ParameterUncertainty ((0, 0.5), "give-in-compensation"),
                     ParameterUncertainty ((0.1, 0.9), "attritionrate" ),  
                     ParameterUncertainty ((0, 1), "attitude-decrease-bargain" ),
                        ParameterUncertainty ((0, 1), "attitude-decrease-submitted" ),
                        ParameterUncertainty ((2, 4), "Threshold-major-power" ),
                        ParameterUncertainty ((0, 10), "SD-initial-trade-volume" ),
                        ParameterUncertainty ((5, 20), "memory-duration" ),
                        ParameterUncertainty ((0.009, 0.011), "mean-GDP-growth" ),
                        ParameterUncertainty ((0, 1), "SD-population-growth" ),
                        ParameterUncertainty ((0.9, 1.1), "mean-military-spending" ),
                        ParameterUncertainty ((0, 0.4), "random-pAttack" ),
                        ParameterUncertainty ((0, 10), "cost-of-new-trade" ),
                        ParameterUncertainty ((10, 100), "amount-of-states" ),
                        ParameterUncertainty ((0.009, 0.011), "SD-military-spending" ),
                        ParameterUncertainty ((0, 1), "attitude-decrease-friendly" ),
                        ParameterUncertainty ((30, 70), "SD-initial-military-capabilities" ),
                        ParameterUncertainty ((1, 10), "Max-initial-patch-population" ),
                        ParameterUncertainty ((0, 1), "SD-GDP-growth" ),
                        ParameterUncertainty ((0, 3), "Max-initial-GDPperCapita"),
                        ParameterUncertainty ((1, 10), "mean-initial-trade-volume" ),
                        ParameterUncertainty ((3, 10), "threshold-counter" ),
                        ParameterUncertainty ((0.9, 1.1), "mean-Perception" ),
                        ParameterUncertainty ((0, 1), "SD-tradevolume-growth" ),
                        ParameterUncertainty ((0.9, 1.1), "mean-tradevolume-growth" ),
                        ParameterUncertainty ((0.009, 0.011), "mean-population-growth" ),
                        ParameterUncertainty ((0, 1), "increased-mil-spending" ),
                        ##ParameterUncertainty ((0, 1), "give-in-compensation" ),
                        ParameterUncertainty ((0, 0.1), "interdependence-pAttack" ),
                        ParameterUncertainty ((0, 1), "attitude-decrease-war" ),
                        ParameterUncertainty ((50, 150), "mean-initial-military-capabilities" ),
                        ParameterUncertainty ((0, 10), "cost-per-distance" ),
      
                     ]
    
    outcomes = [
                Outcome("states", time=True ),
                Outcome("major-power-war-counter", time=True),
                Outcome("war-counter", time=True),
                ]

if __name__ == '__main__':
    ema_logging.log_to_stderr(ema_logging.INFO)
    
    wd = r'C:\Users\rluteijn\OneDrive\Afstudeer\Netlogo\Officiele modellen'
    name = 'testmodel'
    msi = PathOfWarModel(wd, name) ## waarom moet je hier een naam geven? zo te zien kan dit elke naam zijn die je maar wil...
    
    ensemble = ModelEnsemble()
    ensemble.add_model_structure(msi)
    ensemble.parallel =  True
    
    nr_runs = 100
    results = ensemble.perform_experiments(nr_runs)
    
    fn = r'./data/{} runs.bz2'.format(nr_runs)
    save_results(results, fn)
    
    plotting.lines(results, density=plotting_util.KDE)
    plt.show()
  
    