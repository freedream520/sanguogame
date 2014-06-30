#coding:utf8
'''
Created on 2009-12-3

@author: wudepeng
'''

class ExtraAttribute:
    '''
        附加属性
    '''


    def __init__(self,type=0,level=0,effectAppended=0):
        '''
        Constructor
        '''
        self._type = type #种类
        self._level = level #级别
        self._effectAppended = effectAppended #效果加成
        
    def getType(self):
        return self._type
    
    def setType(self,type):
        self._type = type
    
    def getLevel(self):
        return self._level
    
    def setLevel(self,level):
        self._level = level
        
    def getEffectAppended(self):
        return self._effectAppended
    
    def setEffectAppended(self,effectAppended):
        self._effectAppended = effectAppended
        