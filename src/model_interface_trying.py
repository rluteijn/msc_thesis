'''
Created on 15 jan. 2015

@author: rluteijn
'''

import numpy as np
import os

from expWorkbench import save_results, ema_logging, ParameterUncertainty,CategoricalUncertainty, \
                         Outcome, ModelEnsemble
from connectors.netlogo import NetLogoModelStructureInterface
from expWorkbench.ema_exceptions import CaseError

class PathOfWarModel(NetLogoModelStructureInterface):
    model_file = r'/Model 0.66a.nlogo'
    
    run_length = 500
    replications = 10
   
    uncertainties = [
                        ParameterUncertainty ((0, 0.3), "SD-perception"),
                        ParameterUncertainty ((1, 10), "uW1"),
                        ParameterUncertainty ((1, 10), "uW2"),
                        ParameterUncertainty ((1, 10), "uW3"),
                        ParameterUncertainty ((1, 10), "uW4"),
                        ParameterUncertainty ((1, 10), "uW5"),
                        ParameterUncertainty ((0, 0.2), "likelihoodofresourcespresent"),
                        ParameterUncertainty ((0, 0.5), "give-in-compensation"),
                        ParameterUncertainty ((0, 0.5), "attitude-decrease-bargain"),
                        ParameterUncertainty ((0, 0.5), "attitude-decrease-submitted"),
                        ParameterUncertainty ((2.5, 3.5), "Threshold-major-power"),
                        ParameterUncertainty ((0, 10), "SD-initial-trade-volume"),
                        ParameterUncertainty ((1.009, 1.011), "mean-GDP-growth"),
                        ParameterUncertainty ((0, 0.05), "SD-population-growth"),
                        ParameterUncertainty ((0.9, 1.1), "mean-military-spending"),
                        ParameterUncertainty ((0.01, 0.25), "random-pAttack"),
                        ParameterUncertainty ((0, 10), "cost-of-new-trade"),
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
                        ParameterUncertainty ((0, 0.1), "interdependence-pAttack"),
                        ParameterUncertainty ((0, 0.8), "attitude-decrease-war"),
                        ParameterUncertainty ((50, 150), "mean-initial-military-capabilities"),
                        ParameterUncertainty ((0, 10), "cost-per-distance"),
                        ParameterUncertainty ((0.05, 0.15), "attitude-trade-increase" ),
                        ParameterUncertainty ((3, 7), "threshold-dissatisfaction"),
                        ParameterUncertainty ((0.1, 0.5), "distance-slope" ),
                        ParameterUncertainty ((0.1, 0.5), "attitude-increase-alliance" ),
                        ParameterUncertainty ((2, 20), "memory-length" , integer=True),
                        ParameterUncertainty ((0.5, 0.7), "pWinning-factor" ),
                        ParameterUncertainty ((0.1, 0.5), "water-percentage"),
                        ParameterUncertainty ((0, 0.3), "attrition-1" ),
                        ParameterUncertainty ((0, 0.3), "attrition-2" ),
                        ParameterUncertainty ((0.1, 0.4), "attrition-3" ),
                        ParameterUncertainty ((0.2, 0.5), "attrition-4" ),
                        ParameterUncertainty ((0.4, 0.7), "attrition-5" ),
                        ParameterUncertainty ((0.8, 1.2), "threshold-deescalate" ),
                        ParameterUncertainty ((2.5, 3.5), "threshold-escalate" ),
                        ParameterUncertainty ((0, 0.3), "reparations-1"),
                        ParameterUncertainty ((0, 0.3), "reparations-2" ),
                        ParameterUncertainty ((0.1, 0.4), "reparations-3" ),
                        ParameterUncertainty ((0.2, 0.5), "reparations-4" ),
                        ParameterUncertainty ((0.4, 0.7), "reparations-5" ),
                        ParameterUncertainty ((0.01, 0.2), "population-GDP-factor" ),
                        ParameterUncertainty ((0, 0.03), "inflection-point-deviation-zero" ),
                        ParameterUncertainty ((3, 10), "Length_of_culture_list", integer = True ),
                        ParameterUncertainty ((0, 0.3), "amount_of_ideology_change" ),
#                         CategoricalUncertainty ((0, 1), "coercion_on"),
                        ParameterUncertainty ((0, 1), "FPR-impact"),
                        ##CategoricalUncertainty ((10, 20, 30), "worldsize" ),
                        ##CategoricalUncertainty ((2, 200), "amount-of-states"),
                    ]
    
    outcomes = [ 
                Outcome("Output-Inflection-point-end1", time=True),
                Outcome("Output-Inflection-point-end2", time=True),
                Outcome("Output-FPR-end1", time=True),
                Outcome("Output-FPR-end2", time=True),
                Outcome("Output-Power-end1", time=True),
                Outcome("Output-Power-end2", time=True),
                Outcome("Output-Interdependence-end1end2", time=True),
                Outcome("Output-Conflict-level-end1end2", time=True),
   
#                 Outcome("output-polarisation", time=True ),
#                 Outcome("output-polarisation2", time=True ),
#                 Outcome("output-polarisation3", time=True ),
#                 Outcome("output-polarisation4", time=True ),
#                 Outcome("output-polarisation5", time=True ),
#                 Outcome("output-polarisation6", time=True ),

                Outcome("states", time=True ),
                Outcome("major-power-war-counter", time=True),
                Outcome("war-counter", time=True),
                Outcome("polarity", time=True),
                Outcome("amount-conflicts", time=True),
                Outcome("power-transition-counter", time=True),                 

                ]
    
    def run_model(self, case):           
        temp_output = {}  
        for _ in range(self.replications):
            NetLogoModelStructureInterface.run_model(self, case)
            
            output = self.retrieve_output()
               
            for key, value in output.iteritems():
                try:
                    temp_output[key].append(value)
                except KeyError:
                    temp_output[key] = [value]
           
        self.output = {}
        for key, value in temp_output.iteritems():
            value = np.asarray(value)
            self.output[key] = value
            
    def _handle_outcomes(self, fns):                  
        for key, value in fns.iteritems():
            if key in self.normal_handling: # voor "normale" globals werkt dit
                with open(value) as fh:    
                    result = fh.readline()
                    result = result.strip()
                    result = result.split()
                    result = [float(entry) for entry in result]
                    self.output[key] = np.asarray(result)
            elif key in self.once_handling:
                with open(value) as fh:
                    result = fh.readline() # lees line die bestaat uit nullen en een list 
                    result = result.strip() #spaties weghalen
                    result = result.split() # splitsen op elementen: nullen en een list
                    results = np.zeros((self.run_length*6,)) # lege array maken
                    for i, entry in enumerate(result): # voor elk element in de lijst result nu het volgende uitvoeren:
                        entry = entry.strip() # spaties weghalen, welke alleen in de lijst nog zitten eventueel
                        entry = entry.strip('[')# haakje weghalen, welke alleen in de lijst nog zitten eventueel
                        entry = entry.strip(']')# haakje weghalen, welke alleen in de lijst nog zitten eventueel
                        entry = entry.split() #lijst splitsen? --> wat doet dit met andere elementen?
                         
                        for j, item in enumerate(entry): 
                         
                            if item:
                                item = float(item)
                            else:
                                item = 0
                            results[j] = item
                    self.output[key] = results
            else:
                raise CaseError('no hander specified for {}'.format(key), {})
             
        for value in fns.values():
            ema_logging.debug('value: {}'.format(value))
             
            try:
                os.remove(value)
            except WindowsError:
                pass

 
    normal_handling = set([
                            "states",
                            "major-power-war-counter",
                            "war-counter",
                            "polarity",
                            "amount-conflicts",
                            "power-transition-counter",
                            ])
 
    once_handling = set ([ 
                            "Output-Inflection-point-end1",
                            "Output-Inflection-point-end2",
                            "Output-FPR-end1",
                            "Output-FPR-end2",
                            "Output-Power-end1",
                            "Output-Power-end2",
                            "Output-Interdependence-end1end2",
                            "Output-Conflict-level-end1end2",                            
#                             "output-polarisation",
#                             "output-polarisation2",
#                             "output-polarisation3",
#                             "output-polarisation4",
#                             "output-polarisation5",
#                             "output-polarisation6",
                            ])                    

if __name__ == '__main__':
    ema_logging.log_to_stderr(ema_logging.INFO)
    
    wd = r'./model'
    name = 'testmodel'
    msi = PathOfWarModel(wd, name) 
#     msi.run_length = 200
    ensemble = ModelEnsemble()
    ensemble.add_model_structure(msi)
    ensemble.parallel =  True
    
    nr_runs = 500
    results = ensemble.perform_experiments(nr_runs, reporting_interval=1)
    
    fn = r'./data/{} runs 19 jan.tar.gz'.format(nr_runs)
    save_results(results, fn)  
