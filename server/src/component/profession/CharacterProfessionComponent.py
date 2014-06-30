#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component

from util.DataLoader import loader

class CharacterProfessionComponent(Component):
    '''
    classdocs
    '''


    def __init__(self, owner):
        '''
        Constructor
        '''
        Component.__init__(self, owner)
        self._profession = 1 #职业
        self._professionStage = 0 #职业阶段
        self._professionPosition = 0 #职位
        self.info = loader.getById('profession', self._profession, '*') # 从数据表中读出的该职业的配置信息

    def getProfession(self):
        return self._profession

    def setProfession(self, profession):
        self._profession = profession

    def getProfessionPosition(self):
        return self._professionPosition

    def setProfessionPosition(self, professionPosition):
        self._professionPosition = professionPosition

    def getProfessionStage(self):
        return self._professionStage

    def setProfessionStage(self, stage):
        self._professionStage = stage

    def getProfessionName(self):
        '''得到职业名称'''
        return self.info['name']

    def getProfessionDescription(self):
        '''得到职业描述'''
        return self.info['description']

    def getAllProfessionStage(self):
        '''得到当前职业所有的职业阶段'''
        return self.info['stageName'].splite(';')

    def getProfessionStageName(self):
        '''得到职业阶段的名称'''
        allStages = self.getAllProfessionStage()
        index = self.getProfessionStage() - 1
        if index < 0:
            index = 0
        return allStages[index]

    def getProfessionFigure(self):
        '''得到玩家形象'''
        genderName = ['None', 'Male', 'Female']
        campName = ['None', 'Wei', 'Shu', 'Wu']

        figureAttrName = 'figure'
        figureAttrName += genderName[ self._owner.baseInfo.getGender() ]
        figureAttrName += str( self.getProfessionStage() )
        figureAttrName += campName[ self._owner.camp.getCamp() ]
        return self.info[figureAttrName]
    
