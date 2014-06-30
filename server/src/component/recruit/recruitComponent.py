#coding:utf8
'''
Created on 2010-3-11

@author: zhaoxionghui
'''

from component.Component import Component
from util.DataLoader import loader
from util import dbaccess

def parse(text):
    ret = []
    if text is None or text == '':
        return ret
    members = text.split(';')
    for member in members:
        if member == '':
            continue
        item = member.split(',')
        if len(item) != 2:
            continue
        try:
            ret.append({"id":int(item[0]), "state":int(item[1])})
        except:
            continue
    return ret

def pack(lst):
    text = ''
    for item in lst:
        unit = ''
        try:
            unit = ','.join((str(item["id"]), str(item["state"])))
        except:
            continue
        if unit != '':
            unit += ";"
        text += unit
    return text

class RecruitComponent(Component):

    def __init__(self, owner):
        Component.__init__(self, owner)
        self._npc_mem_ids = []

    def init(self, text):
        self._npc_mem_ids = parse(text)

    def getRecruitedMembers(self):
        if len(self._npc_mem_ids) > 0:
            return list(self._npc_mem_ids)
        return None

    def setNPCState(self, id, state = 0):
        '''
            id, NPC`s ID
            state, NPC`s state: 0-> stand, 1->fight 
        '''
        value = None
        for i in self._npc_mem_ids:
            if i["id"] == id:
                value = i
                break
        if value is None:
            return
        value["state"] = state
        self.update(True)

    def getTeamMemberNPCInfo(self):
        data = []
        for i in self._npc_mem_ids:
            if i["state"] == 1:
                data.append(self.queryNPCWuJiangInfo(i["id"]))


    def addWuJiangInGenerals(self, npcid):
        self._npc_mem_ids.append({"id":npcid, "state":0})
        self.update(True)

    def removeWuJiangInGenerals(self, npcid):
        value = None
        for i in self._npc_mem_ids:
            if npcid == i["id"]:
                value = i
                break
        if value is None:
            return False, "No item in Generals recruitComponent.py removeWuJiangInGenerals"
        else:
            try:
                self._npc_mem_ids.remove(value)
            except:
                return False, "list remove Error recruitComponent.py removeWuJiangInGenerals"
            self.update(True)
            return True, None

    def update(self, commit = False):
        if commit is True:
            if dbaccess.updatePlayerRecruitedNPCMembersInfo(self._owner.baseInfo.id, pack(self._npc_mem_ids)):
                return
            else:
                raise "update function Error recruitcomponent.py"
        text = dbaccess.getPlayerRecruitedNPCMembersInfo(self._owner.baseInfo.id)
        self.init(text)

    @staticmethod
    def queryTaskNPCInfo(taskID):
        allnpc = loader.getById('quest_template', taskID, ['generalsID'])
        if allnpc:
            allnpc = [allnpc]
            data = []
            for i in allnpc:
                info = loader.getById('generals', i['generalsID'], '*')
                if info:
                    data.append(info)
            return data
        return None

    @staticmethod
    def queryNPCWuJiangInfo(id):
        info = loader.getById('generals', id, '*')
        if info:
            return info
        return None
