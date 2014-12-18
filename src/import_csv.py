'''
Created on 12 dec. 2014

@author: rluteijn
'''
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from pandas.io.parsers import read_csv

df = read_csv( 'data\experiments.csv')
print df
