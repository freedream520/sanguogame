#coding:utf8
'''
Created on 2010-3-11

@author: wudepeng
'''
from component.Component import Component
from util import dbaccess
from net.MeleeSite import pushMessage

from core.team import Team
from core.teamsManager import TeamsManager
from core.playersManager import PlayersManager
from test.test_iterlen import len

class CharacterTeamComponent(Component):
    '''
    CharacterTeamComponent
    '''

    def __init__(self, owner):
        '''
        Constructor for character team component
        '''
        Component.__init__(self, owner)
        self._team = TeamsManager().getMyTeamByID(0)

    def setMyTeam(self, id):
        team = TeamsManager().getMyTeamByID(id)
        if team is not None:
            self._team = team
            return
        team = Team(id)
        if team.getID() == 0 and id != 0:
            if team.isIllegalTeam():
                team.disband()
            team = TeamsManager().getMyTeamByID(0)
        self._team = team

    def getMyTeamID(self):
        return self._team.getID()

    def launchAddTeamMember(self, member, memberType = 1):
        '''发起组队邀请'''
#        myTeamID = self._team.getID()
#        myLeaderID = self._team.getTeamLeaderID()
        if self.amITeamMember(): #该玩家在某个已经存在的队伍中
            #assert(myLeaderID != None) 
            #队伍必定有队长（断言）
            if not self.amITeamLeader():#队长不是自己
                return {'result':False, 'reason':"您不是队长，无权邀请"}
            else:
                if self._team.isFullCommission():
                    return {'result':False, 'reason':"队伍人数已满"}
                else:
                    if self._team.hasMember(member.baseInfo.id, member.getType()):
                        return {'result':False, 'reason':'该玩家已经在队伍中'}
                    #else:
        if member.teamcom.amITeamMember():
            return {"result":False, 'reason':"对方已经在另外一个队伍中了"}
        pushMessage(str(member.baseInfo.id), self._owner.baseInfo.getNickName() + "向您发起组队邀请")
        return {"result":True, 'reason':None}

    def updateCharacterTeamInfomation(self):
        if self._team.getID() != 0 and self._team.getMembersNum() <= 1:
            self._team = TeamsManager().getMyTeamByID(0)
        dbaccess.updateCharacterTeamInfo(self._owner.baseInfo.id, self._team.getID())

    def joinToOtherTeam(self, body):
        if self._team.getID() != 0:
            return {"result":False, "reason":"您必须先离开当前的队伍"}
        if body.teamcom.getMyTeamID() == 0:
            newteam = TeamsManager().createNewTeam()
            TeamsManager().addTeam(newteam)
            body.teamcom.setMyTeam(newteam.getID())

    def rebuildMyTeam(self):
        newTeam = TeamsManager().createNewTeam()
        TeamsManager().addTeam(newTeam)
        self._team = newTeam
        self._team.addMember(self._owner.baseInfo.id)
        self._team.setTeamLeaderID(self._owner.baseInfo.id)

    def addCharacterIntoMyTeam(self, player):
        return self._team.addMember(player.baseInfo.id, player.getType())

    def resetMyTeam(self, id):
        otherTeam = TeamsManager().getMyTeamByID(id)
        if otherTeam is not None:
            self._team = otherTeam

    def getMyTeamInfomation(self):
        return self._team.getAllMembersInfomation()

    def amITeamLeader(self):
        return self._team.getTeamLeaderID() == self._owner.baseInfo.id

    def getTeamLeaderID(self):
        return self._team.getTeamLeaderID()

    def amITeamMember(self):
        return self.getMyTeamID() != 0

    def disbandTeam(self):
        return self._team.disband()

    def kickoutMember(self, memberID, memberType):
        if not self.amITeamLeader():
            return False, "不是队长不能T人"
        return self._team.dropMember(memberID, memberType)

    def queueMembers(self, sl):
        if not self.amITeamLeader():
            return False, "不是队长不能排序  charactercomponent 434"
        return self._team.doQueue(sl)

    def resetTeamLeader(self, player):
        if not self.amITeamLeader():
            return False, "不是队长转让队长职务， characterTeamcomponent.py 439"
        if self._owner.baseInfo.id == player.baseInfo.id:
            return False, "当前玩家已经是队长"
        return self._team.setTeamLeaderID(player.baseInfo.id)

    def leave(self):
        #玩家离队
        if not self.amITeamMember():
            return False, "你不在队伍中，无法执行离队任务 characterTeamcomponent.py 447"
        if self.amITeamLeader():
            self.disbandTeam()
            return True, 'disband'
        return self._team.lose(self._owner.baseInfo.id, 1)

    def isMyTeamIllegal(self):
        return self._team.isIllegalTeam()

    def updateTeamInfo(self):
        return self._team.update()

    def getPCNumbersInTeam(self):
        return self._team.getPCNumber()

    def getNPCNumbersInTeam(self):
        return self._team.getNPCNumber()

    def hasNPCMembersInTeam(self):
        return self._team.hasNPCMembers()

    def hasMemberInTeamWithID(self, playerID, playerType = 1):
        return self._team.hasMember(playerID, playerType)

    def battleToSinglePC(self, enemy, battleType = 1, timeLimit = 1800):
        timeLeft = timeLimit
        dataList = []
        infoFighter = []
        infoEnemy = [enemy.getCommonValues_delta().copy()]
        fighterWin = False
        for item in self.getMyTeamInfomation():
            if item['type'] == 1: #PlayerCharacter object
                player = PlayersManager().getPlayerByID(item['id'])
                if player is None:
                    player = PlayersManager().createPlayerByID(item['id'])
                data = player.battle.fightTo(enemy, battleType, timeLeft)
                dataList.append(data)
                timeLeft -= data['overTime']
                if data["winner"] != enemy.getBaseID():
                    fighterWin = True
                    break
                infoFighter.append(player.getCommonValues_delta().copy())
            elif item["type"] == 2:
                pass

        overTime = 0
        HPMPDelta = []
        result = []

        startTime = 0
        uL = dataList[-1]['battleEventProcessList'][-1]
        for i in dataList:
            i['battleEventProcessList'].pop(0)
            i['battleEventProcessList'].pop(-1)
            for e in i['battleEventProcessList']:
                e[0] += startTime
            for d in i["MPHPDelta"]:
                d["time"] += startTime
            result += i['battleEventProcessList']
            HPMPDelta += i["MPHPDelta"]
            startTime += i["overTime"]

        # create end event
        if fighterWin:
            battleResult_set = []
            result_i = [] #{}
            for i in range(len(infoFighter)):
                battleResult_set.append({'id':infoFighter[i]['id'], 'battleResult':result_i[i]})

            event = [overTime, 2, -1, battleResult_set]

        import datetime
        result.insert(0, [0, 1, -1, [infoFighter, infoEnemy, str(datetime.datetime.now())]])
        data = {}
        data['battleType'] = battleType
        data['maxTime'] = timeLimit
        data['timeLimit'] = timeLimit
        data['battleEventProcessList'] = result
        data['MPHPDelta'] = HPMPDelta#记录每秒玩家双方hp/mp增量
        data['overTime'] = overTime
        return data
        return
