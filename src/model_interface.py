'''
Created on 25 nov. 2014

@author: rluteijn
'''
from expWorkbench import save_results, ema_logging, ParameterUncertainty,\
                         Outcome, ModelEnsemble
from connectors.netlogo import NetLogoModelStructureInterface

class PathOfWarModel(NetLogoModelStructureInterface):
    model_file = 'name.nlogo'
    
    uncertainties = []
    
    outcomes = []


if __name__ == '__main__':
    ema_logging.log_to_stderr(ema_logging.INFO)
    
    model = PathOfWarModel(r'./model/')
    
    ensemble = ModelEnsemble()
    ensemble.add_model_structure(model)
    
    nr_runs = 100
    results = ensemble.perform_experiments(nr_runs,  reporting_interval=10)