#coding:utf8
'''
Created on 2009-12-1

@author: hanbing
'''

from component.baseinfo.SceneBaseInfoComponent import SceneBaseInfoComponent
from component.camp.SceneCampComponent import SceneCampComponent
from component.balloon.SceneBalloonComponent import SceneBalloonComponent
from component.instance.SceneInstanceComponent import SceneInstanceComponent
from component.level.SceneLevelComponent import SceneLevelComponent
from component.profession.SceneProfessionComponent import SceneProfessionComponent
from component.shop.SceneShopComponent import SceneShopComponent
from component.team.SceneTeamComponent import SceneTeamComponent

class Scene(object):
    '''
    场景类
    '''


    def __init__(self, id, name):
        '''
        Constructor
        '''
        self.baseInfo = SceneBaseInfoComponent(self,id,name)
        self.camp = SceneCampComponent(self)
        self.balloon= SceneBalloonComponent(self)
        self.instance = SceneInstanceComponent(self)
        self.level = SceneLevelComponent(self)
        self.profession = SceneProfessionComponent(self)
        self.shop = SceneShopComponent(self)
        self.team = SceneTeamComponent(self)
        
        
        
        
    
        