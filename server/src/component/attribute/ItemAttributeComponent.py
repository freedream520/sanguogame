#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 
from util.DataLoader import loader
from util import util

class ItemAttributeComponent(Component):
    '''
    attribute component for item
    '''


    def __init__(self,owner,selfExtrAttributes=-1,dropExtraAttributes='',durability=0,damage=0,defense=0):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._selfExtrAttributes = selfExtrAttributes #自身附加属性列表
        self._dropExtraAttributes = dropExtraAttributes
        self._durability = durability #当前耐久
        self._damage = damage #伤害（攻击）
        self._defense = defense #防御
        
        
    def getSelfExtraAttribute(self):
        return self._selfExtrAttributes
    
    def setSelfExtraAttribute(self,attributes):
        self._selfExtrAttributes = attributes
        
    def getDropExtraAttributes(self):
        return self._dropExtraAttributes
    
    def setDropExtraAttributes(self,attributes):
        self._dropExtraAttributes = attributes
    
    def getDurability(self):
        return self._durability
    
    def setDurability(self,durability):
        self._durability = durability
        
    def getDamage(self):
        return self._damage
    
    def setDamage(self,damage):
        self._damage = damage
    
    def getDefense(self):
        return self._defense
    
    def setDefense(self,defense):
        self._defense = defense
    
    def getExtraAttributeList(self):
        '''获取物品的附加属性列表'''
        selfExtraAttribute = self._selfExtrAttributes
        dropExtraAttribue= self._dropExtraAttributes
        extraAttributeList = []
        if selfExtraAttribute <>"-1":
            list = eval('['+selfExtraAttribute+']')
            for i in range( 0, len(list)):
                attributeInfo = loader.getById('extra_attributes', int(list[i]), '*')
                attributeInfo['attributeEffects'] = []
                if attributeInfo['effects']<>'-1' or attributeInfo['effects']<>u'-1':
                    effects = attributeInfo['effects'].split(';')
                    for effect in effects:
                        effect = int(effect)
                        description = loader.getById('effect', effect, ['description'])['description']
                        attributeInfo['attributeEffects'].append(description)
                else:
                    script = attributeInfo['script']
                    script = util.parseScript(script)
                    attributeInfo['attributeEffects'].append(script)
                extraAttributeList.append(attributeInfo)
#            attributeInfo = loader.getById('extra_attributes', int(selfExtraAttribute), '*')
#            attributeInfo['attributeEffects'] = []
#            if attributeInfo['effects']<>'-1' or attributeInfo['effects']<>u'-1':
#                effects = attributeInfo['effects'].split(';')
#                for effect in effects:
#                    effect = int(effect)
#                    description = loader.getById('effect', effect, ['description'])['description']
#                    attributeInfo['attributeEffects'].append(description)
#            else:
#                script = attributeInfo['script']
#                script = util.parseScript(script)
#                attributeInfo['attributeEffects'].append(script)
#            extraAttributeList.append(attributeInfo)
        elif dropExtraAttribue<>"-1":
            list = eval('['+dropExtraAttribue+']')
            for i in range( 0, len(list)):
                attributeInfo = loader.getById('extra_attributes', int(list[i]), '*')
                attributeInfo['attributeEffects'] = []
                if attributeInfo['effects']<>'-1' or attributeInfo['effects']<>u'-1':
                    effects = attributeInfo['effects'].split(';')
                    for effect in effects:
                        effect = int(effect)
                        description = loader.getById('effect', effect, ['description'])['description']
                        attributeInfo['attributeEffects'].append(description)
                else:
                    script = attributeInfo['script']
                    script = util.parseScript(script)
                    attributeInfo['attributeEffects'].append(script)
                extraAttributeList.append(attributeInfo)
                
        return extraAttributeList
        
