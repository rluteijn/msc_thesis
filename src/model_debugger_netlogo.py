'''
Created on 12 feb. 2015

@author: rluteijn
'''
import csv

pathToExistingModel = r"C:\Users\rluteijn\Documents\GitHub\msc_thesis\src\model\kopie model.nlogo"
pathToNewModel  = r"C:\Users\rluteijn\Documents\GitHub\msc_thesis\src\model\kopie model2.nlogo"
newModel = open(pathToNewModel, 'w') 

variables = ["FPR-impact","Length_of_culture_list","SD-GDP-growth","SD-military-spending","SD-perception","SD-population-growth","SD-tradevolume-growth","Threshold-major-power","amount_of_ideology_change","attitude-decrease-bargain","attitude-decrease-friendly","attitude-decrease-submitted","attitude-decrease-war","attitude-increase-alliance","attitude-trade-increase","attrition-1","attrition-2","attrition-3","attrition-4","attrition-5","cost-of-new-trade","cost-per-distance","distance-slope","give-in-compensation","increased-mil-spending","inflection-point-deviation-zero","interdependence-pAttack","likelihoodofresourcespresent","mean-GDP-growth","mean-Perception","mean-military-spending","mean-population-growth","mean-tradevolume-growth","memory-length","pWinning-factor","population-GDP-factor","random-pAttack","reparations-1","reparations-2","reparations-3","reparations-4","reparations-5","seed","threshold-counter","threshold-deescalate","threshold-dissatisfaction","threshold-escalate","threshold-force","uW1","uW2","uW3","uW4","uW5","water-percentage"]
data = []
case = 310

file = csv.reader(open(r"C:\Users\rluteijn\Documents\GitHub\msc_thesis\src\experiments.csv"))
for i, line in enumerate(file):
    if i == (case + 1): #offset to compensate for excel file starting at 1 and a header row
        data = line
        print data

tijdelijk = False
settedValues = []
for line in open(pathToExistingModel): 
    if (tijdelijk == True):
        tijdelijk = False
    else:
        for entry in variables:
            if line.startswith(entry) == True:   # find a line that starts with variable name     
                newModel.write(line) # write this line to new file
                position = variables.index(entry) # identify input for variable
                replacement = data[position]
                replacement = str(replacement) # convert to string
                temp = replacement
                tijdelijk = True # prevent the code from writing also the old value
                newModel.write(temp) # write new input to new model
                newModel.write('\n')
                exit
        if (tijdelijk != True):                      
            newModel.write(line) 