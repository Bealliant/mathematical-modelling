# -*- coding: utf-8 -*-
"""
Created on Sun Jun  4 22:46:31 2022

@author: Bealliant
"""
import numpy as np

hospitals = np.loadtxt("cities.txt")

def plot_scatters(x,*args):
    
    '''
    
    input: -> numpy matrix, [[Longitude,Latitude], ...]
           
    function plot_boundary will draw the scatter plot on the map.       
    
    '''

    import warnings
    
    from mpl_toolkits.basemap import Basemap
    import matplotlib.pyplot as plt
    from matplotlib.patches import Polygon
    
    
    warnings.filterwarnings('ignore')

    
    
    fig = plt.figure(figsize=(16, 9))
    
    ax = plt.gca()   # 获取当前绘图区的坐标系
    bmap = Basemap(llcrnrlon=97,llcrnrlat=25,urcrnrlon=110,urcrnrlat=36,
                projection='lcc',lat_1=33,lat_2=45,lon_0=120)
    
    # bmap.etopo()
    bmap.bluemarble()
    
    # 画省
    shp_info = bmap.readshapefile('Basemap_Package\gadm36_CHN_1','states',drawbounds=False)
    
    
    for info, shp in zip(bmap.states_info, bmap.states):
        proid = info['NAME_1'] # NAME_1代表各省的拼音
        
        if 'Sichuan' in proid:
            poly = Polygon(shp,facecolor='w',edgecolor='b', lw=0.2)
            ax.add_patch(poly)
    # 画市
    bmap.readshapefile(shapefile='Basemap_Package\gadm36_CHN_2',
                    name='citys',
                    drawbounds=True) # 市
    
    for info, shp in zip(bmap.citys_info, bmap.citys):
        
        proid = info['NAME_2']  # NAME_2 代表各市的拼音
        
    
        if "Chengdu" in proid:
            poly = Polygon(shp,
                           facecolor='r',alpha=0.3,
                           lw=3)
            ax.add_patch(poly)
    
    x1 = []
    y1 = []
    x=[]
    y=[]
        
    try:
        for k,v in x:
            x1.append(k)
            y1.append(v)
    except TypeError:
        k,v = x
        x1.append(k)
        y1.append(v)
       
    longi1,lati1=bmap(x1,y1)
    bmap.scatter(longi1,lati1,marker='o',facecolor= args)#c=range(len(wechatPos)),cmap=plt.cm.viridis
    
    for k,v in hospitals:
        x.append(k)
        y.append(v)
        
    longi,lati = bmap(x,y)
    bmap.scatter(longi,lati,marker='x',facecolor= 'b')#c=range(len(wechatPos)),cmap=plt.cm.viridis
    bmap.drawcoastlines()
    bmap.drawcountries()
    
    # plt.savefig('fig_province.png', dpi=100, bbox_inches='tight')
    plt.show()
    
   

        
  

    

x = np.array([[104.61379529 , 30.12607128]])
plot_scatters(x,'r')