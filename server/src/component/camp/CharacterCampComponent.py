#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component
from util.DataLoader import loader

class CharacterCampComponent(Component):
    '''
    camp component for character
    '''


    def __init__(self, owner):
        '''
        Constructor
        '''
        Component.__init__(self, owner)
        self._camp = 0 #玩家所属阵营

    def getCamp(self):
        return self._camp

    def setCamp(self, camp):
        self._camp = camp

    def getCampName(self):
        camp = self._camp
        if camp == -1:
            return "中立"
        result = loader.getById('camp', camp, ['name'])['name']
        if result:
            return result
        else:
            return ""
