'''
Created on 29 dec. 2014

@author: rluteijn
'''
from expWorkbench import save_results, ema_logging, ParameterUncertainty,CategoricalUncertainty, \
                         Outcome, ModelEnsemble
from connectors.netlogo import NetLogoModelStructureInterface

class PathOfWarModel(NetLogoModelStructureInterface):
    model_file = r'/Model 0.64 no graphs.nlogo'
    
    run_length = 1
   
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
                        ParameterUncertainty ((2, 140), "amount-of-states", integer=True),
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
                        ParameterUncertainty ((5, 20), "memory-length" , integer=True),
                        ParameterUncertainty ((0.5, 0.7), "pWinning-factor" ),
                        ParameterUncertainty ((0.05, 0.50), "water-percentage"),
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
                        ParameterUncertainty ((3, 10), "Length_of_culture_list" ),
                        ParameterUncertainty ((0, 0.3), "amount_of_ideology_change" ),
                        
                        #CategoricalUncertainty ((0, 1), "coercion_on"),
                        CategoricalUncertainty ((10, 20, 30), "worldsize" ),
                    ]
    
    outcomes = [ ## globals may be imported directly
                Outcome("Polarity", time=True),
                Outcome("def-patches-water ", time=True),
                Outcome("should-patches-water ", time=True),
                Outcome("min-GDPpercapita ", time=True),
                Outcome("max-GDPpercapita ", time=True),
                Outcome("amount-capitals ", time=True),
                Outcome("min-state ", time=True),
                Outcome("max-state ", time=True),
                Outcome("unassigned-patches ", time=True),
                Outcome("min-patch-population ", time=True),
                Outcome("max-patch-population ", time=True),
                Outcome("min-patch-GDPperCapita ", time=True),
                Outcome("max-patch-GDPperCapita ", time=True),
                Outcome("min-GDPpercapita-growth ", time=True),
                Outcome("max-GDPpercapita-growth ", time=True),
                Outcome("min-Population-growth ", time=True),
                Outcome("max-Population-growth", time=True),
                Outcome("min-economic-size ", time=True),
                Outcome("max-economic-size ", time=True),
                Outcome("should-patches-resources", time=True),
                Outcome("def-patches-resources", time=True),
                Outcome("max-GDP ", time=True),
                Outcome("min-GDP ", time=True),
                Outcome("max-Population ", time=True),
                Outcome("min-Population ", time=True),
                Outcome("max-MilitaryCapabilities ", time=True),
                Outcome("min-MilitaryCapabilities ", time=True),
                Outcome("max-MilitarySpending ", time=True),
                Outcome("min-MilitarySpending ", time=True),
                Outcome("min-tradepartners ", time=True),
                Outcome("max-tradepartners ", time=True),
                Outcome("min-DiplomaticRelations ", time=True),
                Outcome("max-DiplomaticRelations ", time=True),
                Outcome("min-friendly-states ", time=True),
                Outcome("max-friendly-states ", time=True),
                ]

if __name__ == '__main__':
    ema_logging.log_to_stderr(ema_logging.INFO)
    
    wd = r'C:\Users\rluteijn\OneDrive\Afstudeer\Netlogo\Officiele modellen'
    name = 'testmodel'
    msi = PathOfWarModel(wd, name) 
    
    ensemble = ModelEnsemble()
    ensemble.add_model_structure(msi)
    ensemble.parallel =  True
    
    nr_runs = 3000
    results = ensemble.perform_experiments(nr_runs, reporting_interval=1000)
    
    fn = r'./data/{} runs setup verification 7 jan.tar.gz'.format(nr_runs)
    save_results(results, fn)  
