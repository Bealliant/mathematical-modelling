# -*- coding: utf-8 -*-
"""
Created on Sun Jun  5 20:46:31 2022

@author: Bealliant
"""

from plot_boundary import plot_scatters
import numpy as np
from AFSA import *

cities = np.loadtxt("cities.txt")
plot_scatters(cities,'r')

k = AFSA()
k.optimize()