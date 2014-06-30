#coding:utf8
'''
Created on 2009-12-1


'''

from component.baseinfo.ItemBaseInfoComponent import ItemBaseInfoComponent
from component.attribute.ItemAttributeComponent import ItemAttributeComponent
from component.binding.ItemBindingComponent import ItemBindingComponent
from component.camp.ItemCampComponent import ItemCampComponent
from component.effect.ItemEffectComponent import ItemEffectComponent
from component.balloon.ItemBalloonComponent import ItemBalloonComponent
from component.finance.ItemFinanceComponent import ItemFinanceComponent
from component.level.ItemLevelComponent import ItemLevelComponent
from component.pack.ItemPackComponent import ItemPackComponent
from component.profession.ItemProfessionComponent import ItemProfessionComponent
from component.quest.ItemQuestComponent import ItemQuestComponent
from component.shop.ItemShopComponent import ItemShopComponent
from component.trade.ItemTradeComponent import ItemTradeComponent

class Item(object):
    '''
    物品类
    '''


    def __init__(self, id, name):
        '''
        Constructor
        '''
        self.baseInfo = ItemBaseInfoComponent(self, id, name)
        self.attribute = ItemAttributeComponent(self)
        self.binding = ItemBindingComponent(self)
        self.camp = ItemCampComponent(self)
        self.effect = ItemEffectComponent(self)
        self.balloon= ItemBalloonComponent(self)
        self.finance = ItemFinanceComponent(self)
        self.level = ItemLevelComponent(self)
        self.pack = ItemPackComponent(self)
        self.profession = ItemProfessionComponent(self)
        self.qtemplateInfo= ItemQuestComponent(self)
        self.shop = ItemShopComponent(self) 
        self.trade = ItemTradeComponent(self)
        
        
        
        