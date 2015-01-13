'''
Created on 25 nov. 2014

@author: rluteijn
'''
from expWorkbench import save_results, ema_logging, ParameterUncertainty,CategoricalUncertainty, \
                         Outcome, ModelEnsemble
from connectors.netlogo import NetLogoModelStructureInterface

class PathOfWarModel(NetLogoModelStructureInterface):
    model_file = r'/Model 0.62a.nlogo'
    
    run_length = 500
   
    uncertainties = [
#                         ParameterUncertainty ((0, 0.3), "SD-perception"),
#                         ParameterUncertainty ((5, 10), "uW1"),
#                         ParameterUncertainty ((5, 10), "uW2"),
#                         ParameterUncertainty ((1, 3), "uW3"),
#                         ParameterUncertainty ((1, 3), "uW4"),
#                         ParameterUncertainty ((1, 3), "uW5"),
#                         ParameterUncertainty ((0, 0.2), "likelihoodofresourcespresent"),
#                         ParameterUncertainty ((0, 0.5), "give-in-compensation"),
#                         ParameterUncertainty ((0, 0.5), "attitude-decrease-bargain"),
#                         ParameterUncertainty ((0, 0.5), "attitude-decrease-submitted"),
#                         ParameterUncertainty ((2.5, 3.5), "Threshold-major-power"),
#                         ParameterUncertainty ((0, 10), "SD-initial-trade-volume"),
#                         ParameterUncertainty ((1.009, 1.011), "mean-GDP-growth"),
#                         ParameterUncertainty ((0, 0.05), "SD-population-growth"),
#                         ParameterUncertainty ((0.9, 1.1), "mean-military-spending"),
#                         ParameterUncertainty ((0.01, 0.25), "random-pAttack"),
#                         ParameterUncertainty ((0, 10), "cost-of-new-trade"),
#                         ParameterUncertainty ((0, 0.1), "SD-military-spending"),
#                         ParameterUncertainty ((0, 1), "attitude-decrease-friendly"),
#                         ParameterUncertainty ((30, 70), "SD-initial-military-capabilities"),
#                         ParameterUncertainty ((1, 10), "Max-initial-patch-population"),
#                         ParameterUncertainty ((0, 0.05), "SD-GDP-growth"),
#                         ParameterUncertainty ((0, 3), "Max-initial-GDPperCapita"),
#                         ParameterUncertainty ((1, 10), "mean-initial-trade-volume"),
#                         ParameterUncertainty ((3, 10), "threshold-counter", integer=True),
#                         ParameterUncertainty ((0.9, 1.1), "mean-Perception"),
#                         ParameterUncertainty ((0, 0.1), "SD-tradevolume-growth"),
#                         ParameterUncertainty ((0.9, 1.1), "mean-tradevolume-growth"),
#                         ParameterUncertainty ((1.009, 1.011), "mean-population-growth"),
#                         ParameterUncertainty ((0, 1), "increased-mil-spending"),
#                         ParameterUncertainty ((0, 0.1), "interdependence-pAttack"),
#                         ParameterUncertainty ((0, 0.8), "attitude-decrease-war"),
#                         ParameterUncertainty ((50, 150), "mean-initial-military-capabilities"),
#                         ParameterUncertainty ((0, 10), "cost-per-distance"),
#                         ParameterUncertainty ((0.05, 0.15), "attitude-trade-increase" ),
#                         ParameterUncertainty ((3, 7), "threshold-dissatisfaction"),
#                         ParameterUncertainty ((0.1, 0.5), "distance-slope" ),
#                         ParameterUncertainty ((0.1, 0.5), "attitude-increase-alliance" ),
#                         ParameterUncertainty ((5, 20), "memory-length" , integer=True),
#                         ParameterUncertainty ((0.5, 0.7), "pWinning-factor" ),
#                         ParameterUncertainty ((0.1, 0.5), "water-percentage"),
#                         ParameterUncertainty ((0, 0.3), "attrition-1" ),
#                         ParameterUncertainty ((0, 0.3), "attrition-2" ),
#                         ParameterUncertainty ((0.1, 0.4), "attrition-3" ),
#                         ParameterUncertainty ((0.2, 0.5), "attrition-4" ),
#                         ParameterUncertainty ((0.4, 0.7), "attrition-5" ),
#                         ParameterUncertainty ((0.8, 1.2), "threshold-deescalate" ),
#                         ParameterUncertainty ((2.5, 3.5), "threshold-escalate" ),
#                         ParameterUncertainty ((0, 0.3), "reparations-1"),
#                         ParameterUncertainty ((0, 0.3), "reparations-2" ),
#                         ParameterUncertainty ((0.1, 0.4), "reparations-3" ),
#                         ParameterUncertainty ((0.2, 0.5), "reparations-4" ),
#                         ParameterUncertainty ((0.4, 0.7), "reparations-5" ),
#                         ParameterUncertainty ((0.01, 0.2), "population-GDP-factor" ),
#                         ParameterUncertainty ((0, 0.03), "inflection-point-deviation-zero" ),
#                         ParameterUncertainty ((3, 10), "Length_of_culture_list" ),
#                         ParameterUncertainty ((0, 0.3), "amount_of_ideology_change" ),
#                         CategoricalUncertainty ((0, 1), "coercion_on"),
                        ##CategoricalUncertainty ((10, 20, 30), "worldsize" ),
                        ##CategoricalUncertainty ((2, 200), "amount-of-states"),
                        ParameterUncertainty ((0.99, 1.01), "coercion_on", integer=True),
                    ]
    
    outcomes = [ 
                Outcome("states", time=True ),
                Outcome("major-power-war-counter", time=True),
                Outcome("war-counter", time=True),
                Outcome("polarity", time=True),
                Outcome("amount-conflicts", time=True),
                Outcome("power-transition-counter", time=True),                   
#                 Outcome("inflection-state1", time=True),
#                 Outcome("FPR-satisfaction-state1", time=True),
#                 Outcome("power-1", time=True),
#                 Outcome("interdependence-1", time=True),
#                 Outcome("amount-of-conflicts1", time=True),                 
#                 Outcome("conflict-no-interaction", time=True),
#                 Outcome("conflict-too-long", time=True),                  
#                 Outcome("states-missing-resources", time=True),
#                 Outcome("trade-severed", time=True),                  
#                 Outcome("count-1", time=True),
#                 Outcome("count-2", time=True),
#                 Outcome("count-3", time=True),
#                 Outcome("count-4", time=True),
#                 Outcome("count-5", time=True),
#                 Outcome("count-6", time=True),
#                 Outcome("count-7", time=True),                  
#                 Outcome("interact-1", time=True),  
#                 Outcome("interact-2", time=True),
#                 Outcome("interact-3", time=True),
#                 Outcome("interact-4", time=True),
#                 Outcome("interact-5", time=True),
#                 Outcome("interact-6", time=True),
#                 Outcome("interact-7", time=True),
#                 Outcome("interact-8", time=True),
#                 Outcome("interact-9", time=True),
#                 Outcome("interact-10", time=True),
#                 Outcome("interact-11", time=True),
#                 Outcome("interact-12", time=True),
#                 Outcome("interact-13", time=True),
#                 Outcome("interact-14", time=True),
#                 Outcome("interact-15", time=True),
#                 Outcome("interact-16", time=True),
#                 Outcome("interact-17", time=True),
#                 Outcome("interact-18", time=True),
#                 Outcome("interact-19", time=True),
#                 Outcome("interact-20", time=True),
#                 Outcome("interact-21", time=True),
#                 Outcome("interact-22", time=True),
#                 Outcome("interact-23", time=True),
#                 Outcome("inflection-1", time=True),
#                 Outcome("inflection-2", time=True),
#                 Outcome("inflection-3", time=True),
#                 Outcome("inflection-4", time=True),
#                 Outcome("inflection-5", time=True),
#                 Outcome("inflection-6", time=True),
#                 Outcome("inflection-7", time=True),
                ]

if __name__ == '__main__':
    ema_logging.log_to_stderr(ema_logging.INFO)
    
    wd = r'C:\Users\rluteijn\OneDrive\Afstudeer\Netlogo\Officiele modellen'
    name = 'testmodel'
    msi = PathOfWarModel(wd, name) 
    
    ensemble = ModelEnsemble()
    ensemble.add_model_structure(msi)
    ensemble.parallel =  True
    
    nr_runs = 100
    results = ensemble.perform_experiments(nr_runs, reporting_interval=1)
    
    fn = r'./data/{} runs 6 jan.tar.gz'.format(nr_runs)
    save_results(results, fn)  
