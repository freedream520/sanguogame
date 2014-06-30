#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''
from component.Component import Component 

class ItemPackComponent(Component):
    '''
    pack component for item
    '''


    def __init__(self,owner,stack=10,sizeX=1,sizeY=1):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._stack = stack #可叠加数:'-1:不可叠加1~999:可叠加的数值
        self._width = sizeX #宽度
        self._height = sizeY #高度

        
    def getStack(self):
        return self._stack
    
    def setStack(self,stack):
        self._stack = stack
    
    def getWidth(self):
        return self._width
    
    def setWidth(self,width):
        self._width = width
    
    def getHeight(self):
        return self._height
    
    def setHeight(self,height):
        self._height = height