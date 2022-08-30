# -*- coding: utf-8 -*-
"""
Created on Sun Jun  5 20:55:30 2022

@author: Bealliant
"""
import numpy as np
import numpy.random as rd
import sys
from plot_boundary import plot_scatters
import math 

hospitals = np.loadtxt("cities.txt")
R = 6371

class AFish():
    
    def __init__(self, fish_num=100, try_num = 5):
        '''
            Initialization:
            *    wdir : load the .txt file to get the positions of the cities
            *    center : Allow Users to Designate the initial point of searching
           
            We can know that the range of both the longitude and the magnitude is 
           Approximately 6. The whole area is devided into 10K parts (100*100).
           So the scale of one grid is 0.08 * 0.08. 
           Let's say one fish can move half size of one grid. And can see twice 
           the size of a grid. 
           
       *    visual_distance = 10km
       *    visual = 0.10 degree
       *    
       *    step = 5
            
        ''' 
        
        self.longi = rd.random([1])*8 + 100                 
        self.magni = rd.random([1])*8 + 26
        self.fish_loca = np.concatenate((self.longi,self.magni))
        
        self.potential_loca_swarm = self.fish_loca
        self.potential_loca_follow = self.fish_loca
        self.potential_loca = self.fish_loca
        
        self.fish_num = fish_num
        
        self.step = 0.04
        self.visual_dist = 10        #判断距离的visual是采用已有的经纬度定位的方法
        self.visual = 0.30
        self.theta = 0.8
        self.try_num = try_num
        
        self.bulletin = np.zeros((1,2))
    
    def hav(self,theta):
        '''
            Haversine Formula
            $hav(\theta) = sin{^2}(\frac{\theta}{2})$
        '''
        theta = theta  * np.pi/180
        return np.sin(theta/2)**2
    
    def cos(self,theta):
        # input : theta -> degrees
        # output : cos(theta)
        return np.cos(theta*np.pi/180)
    
    def sin(self,theta):
        # input : theta -> degrees
        # output : sin(theta)
        return np.sin(theta*np.pi /180)
    
    
    def distance_Calc(self,center,cities = hospitals):
        '''
        d = 2r*asin(hav(lamda1-lambda2)+cos(lamda1)cos(lamda2)hav(\delta \phai))
        Attention : 为了方便鱼群算法的执行，将距离的变量变成了负号，追求“越大越好”
        '''
        try:
            return 2*R *np.arcsin(np.sqrt(self.hav(cities[:,1]-center[1]) +\
                                     self.cos(center[1])*self.cos(cities[:,1])*self.hav(cities[:,0]-center[0])))

        except IndexError:
            return 2*R *np.arcsin(np.sqrt(self.hav(cities[:,1]-center[0,1]) +\
                                     self.cos(center[0,1])*self.cos(cities[:,1])*self.hav(cities[:,0]-center[0,0])))
            
#        return self.R *2*np.arcsin(self.diff_hav(self.cities[:,:1], center) +\
    
    def Y(self,center):
        '''
            The Object Function.
            Return the Tolerance Score\Food Abundance of the point named CENTER
        '''
        return self.distance_Calc(center).sum()*-1 + 20000
    
    def Pray(self):
        '随机寻找目标函数较大的解'
        for _ in range(self.try_num):
            pin = self.fish_loca + rd.random([1,2]) * self.visual
            if self.Y(pin) > self.Y(self.fish_loca):
                self.potential_loca = self.fish_loca + self.step * (pin - self.fish_loca) / self.visual
                self.fish_loca = self.potential_loca
                break
                
    def update(self):
        '''
            To Execute the comparison between potential coordinates and Updating.
            将这个鱼的potential坐标更新到汇总的矩阵X之中'
        '''
        self.Swarm()
        self.Follow()
        
        if self.Y(self.potential_loca_follow) > self.Y(self.fish_loca) and\
            self.Y(self.potential_loca_follow) > self.Y(self.potential_loca_swarm):
                self.fish_loca = self.potential_loca_follow
                
        elif self.Y(self.potential_loca_swarm) > self.Y(self.fish_loca):
            self.fish_loca = self.potential_loca_swarm
        
        else:
            self.Pray()
        
        self.potential_loca = self.fish_loca
        self.potential_loca_follow = self.fish_loca
        self.potential_loca_swarm = self.fish_loca
        
        
    def find(self, position):
        '''
            return a numpy array that find the surrounding points of A within a range of self.visual_dist
            The original Point A is EXCLUDED.
        '''
        
        dist = self.distance_Calc(center = position, cities = X)
        #nearby_list = np.where(dist<=self.visual_dist and dist > 0.1)
        #return nearby_list
        
        return_list = []
        
        for i,ele in enumerate(dist):
            if ele <self.visual_dist and ele > 0.001 :
                return_list.append(i)
        
        return return_list
        
    def Swarm(self):
        '执行这个鱼的个体的聚群行为'
        nearby_list = self.find(self.fish_loca)
        if len(nearby_list) == 0:
            self.potential_loca_swarm = self.fish_loca
            return 
        
        center = np.mean(X[nearby_list], axis = 0)
        if len(nearby_list)/self.fish_num <= self.theta:
            # 拥挤度满足要求
            if self.Y(center)>=self.Y(self.potential_loca) :
                delta_Coordi = center - self.fish_loca
                delta_Coordi = delta_Coordi /np.linalg.norm(delta_Coordi)
                self.potential_loca_swarm = self.potential_loca + self.step * delta_Coordi
    
    def Follow(self):
        '执行这个鱼的个体的追尾行为'
        nearby_list = self.find(self.fish_loca)
        nearby_score_list = []
        try:
            for i,fish in enumerate(nearby_list):
                nearby_score_list.append(self.Y(X[fish]))
        
            nearby_max_score = max(nearby_score_list)
            nearby_max_score_num = nearby_score_list.index(nearby_max_score)
        
            nearby_max_score_index = nearby_list[nearby_max_score_num]
            
            '''
                From the Point Xi we find the Xj in its nearby region when Y reach its high.
                Again we should use find to Investigate 
                if the Congestion Index of the Point Xj satisfies the request.
            '''
        
            nearby_list_j = self.find(X[nearby_max_score_index,:])
            
            if self.Y(X[nearby_max_score_index,:]) > self.Y(self.fish_loca) and\
                len(nearby_list_j)/self.fish_num < self.theta :
                    delta_Coordi = X[nearby_max_score_index,:] - self.fish_loca
                    delta_Coordi = delta_Coordi/np.linalg.norm(delta_Coordi)
                    self.potential_loca_follow = delta_Coordi * self.step
        
        except ValueError:
            self.potential_loca_follow = self.fish_loca
        
      
        
                
        
    def Bulletin(self):
        pass
    
    
X = np.empty([500,2])

'''
    The 500*2 Matrix X stores the positional coordinates of all fish identities.
'''

        
class AFSA(AFish):
    '''             
                Hypder-Parameter Settings: 
                
                *    epoch : Times of Iteration, Defaulat is 1000
                *    fish_num : number of fishes in an ant group.
                *    fish_loca : randomized locations of each fish in the group.
    '''    
    def __init__(self, fish_num = 100, epoch = 100):
        self.epoch = epoch
        self.fish_num = fish_num
        self.fish_list = []
        self.maxpos = np.empty([1,2])
        self.maxscore = -5000
        
        for _ in range(fish_num):
            temp_fish = AFish()
            self.fish_list.append(temp_fish)
       
        
    def register(self):
        for i,temp_fish in enumerate(self.fish_list):
            if self.Y(temp_fish.fish_loca) > self.maxscore :
                self.maxscore = self.Y(temp_fish.fish_loca)
                self.maxpos = temp_fish.fish_loca
            
            X[i,:] = temp_fish.fish_loca

    def optimize(self):
        list_m = []
        self.register()
        for i in range(self.epoch):
            print(i,'    ',self.maxpos) 
            for afish in self.fish_list:
                afish.update()
            self.register()
            list_m.append(self.maxscore)
        
        return list_m
        
    
k = AFSA()
list_out = k.optimize()
plot_scatters(hospitals,'r')
plot_scatters(k.maxpos,'b')


