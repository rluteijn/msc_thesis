'''
Created on 16 dec. 2014

@author: rluteijn
'''

from expWorkbench import save_results, ema_logging, CategoricalUncertainty,\
                         Outcome, ModelEnsemble
from connectors.netlogo import NetLogoModelStructureInterface

class PathOfWarModel(NetLogoModelStructureInterface):
    model_file = r'/Model 0.57.nlogo'    
    run_length = 300
    
    uncertainties = [
					#CategoricalUncertainty ((0.1, 0.2), "SD-perception"),
					#CategoricalUncertainty ((5, 12), "memory-duration"),	
                    #CategoricalUncertainty ((0.05, 0.15), "random-pAttack"),
                    
                    CategoricalUncertainty ((3, 6), "threshold-dissatisfaction"),						
                    ]
    
    outcomes = [ ## globals may be imported directly
                Outcome("states", time=True ),
                Outcome("major-power-war-counter", time=True),
                Outcome("war-counter", time=True),
                Outcome("polarity", time=True),
                #Outcome("mean-interdependence", time=True),
                #Outcome("mean-PFR-satisfaction", time=True),   
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
    
    nr_runs = 200
    results = ensemble.perform_experiments(nr_runs, reporting_interval=1)
    
    fn = r'./data/{} runs.tar.gz'.format(nr_runs)
    save_results(results, fn)  
