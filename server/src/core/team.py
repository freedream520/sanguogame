#coding:utf8
'''
Created on 2010-3-11

@author: zhaoxionghui
'''

from util import dbaccess

class Team:

    MAXMEMBERSNUMBER = 3

    def __init__(self, id):
        self._id = id
        self.__teamLeader = None
        self._members = []
        self.update()

    def getID(self):
        return self._id

    def isTeamMember(self):
        return self._id != 0

    def getMembersNum(self):
        return len(self._members)

    def getAllMembersInfomation(self):
        ret = []
        for item in self._members:
            ret.append(type(item)(item))
        return ret

    def getAllMemberObjects(self):
        #objs = []
        for item in self._members:
            if item["type"] == 2:#NPC info
                pass
            elif item["type"] == 1: #players info
                pass
            else:
                pass

    def isFullCommission(self):
        return self.getMembersNum() >= self.MAXMEMBERSNUMBER

    def getTeamLeaderID(self):
        return self.__teamLeader

    def setTeamLeaderID(self, leaderID):
        if self.__teamLeader == leaderID:
            return False, "当前玩家已经是队长"
        result, reason = dbaccess.setTeamLeader(self._id, leaderID)
        if result:
            self.update()
        else:
            print reason
        return result, reason

    def hasMember(self, playerID, playerType = 1):
        for item in self._members:
            if item['id'] == playerID and item["type"] == playerType:
                return True
        return False

    def addMember(self, playerID, playerType = 1):
        if self.isFullCommission():
            return False, "队伍已经满员"
        playerInfo = {"id":playerID, "type":playerType}
        result, reason = dbaccess.addTeamMember(self._id, playerInfo)
        if result:
            self.update()
        else:
            print "DB error :add one to DB error", reason
        return result, reason

    def dropMember(self, playerID, playerType = 1):
        '''从队伍中删除指定的队员'''
        member = None
        for i in self._members:
            if i["id"] == playerID and i["type"] == playerType:
                member = i
        if member is None:
            return False, "PlayerID=%d playerType=%d is not in this team !" % (playerID, playerType)
        result, reason = dbaccess.kickOneOutTeam(self._id, playerID)
        self.update()
        return result, reason

    def hasNPCMembers(self):
        for member in self._members:
            if member["type"] == 2:
                return True
        return False

    def hasPCMembers(self):
        for member in self._members:
            if member["type"] == 1:
                return True
        return False

    def getNPCNumber(self):
        count = 0
        for member in self._members:
            if member["type"] == 2:
                count += 1
        return count

    def getPCNumber(self):
        count = 0
        for member in self._members:
            if member["type"] == 1:
                count += 1
        return count

    def isIllegalTeam(self):
        npccount = self.getNPCNumber()
        pccount = self.getPCNumber()
        if npccount > 1:
            return True
        if pccount <= 1:
            return True
        return False

    def update(self):
        id = self._id
        if id != 0:
            info = dbaccess.getTeamInfomation(id)
            if info:
                self.__teamLeader = info["leader"]
                self._members = []
                for i in range(1, len(info)):
                    member = {"id":info[i][0], "type":info[i][1]}
                    if member["id"] != 0:
                        self._members.append(member)
            else:
                #dbacess.createNewTeam
                self._id = 0
                print '''raise Exception("数据库中无该队伍信息 db has no team with id %d" % id)'''
                pass

    def disband(self):
        ret = self.getAllMembersInfomation()
        dbaccess.disbandTeam(self._id)
        return ret

    def doQueue(self, lst): #[mem1id, mem2id, mem3id]
        assert len(lst) == self.getMembersNum()
        try:
            new = []
            for j in range(len(lst)):
                new.append([i for i in self._members if i["id"] == lst[j]][0])
            self._members = list(new)
            result, reason = dbaccess.sortTeamMembers(self._id, new)
            self.update()
            return result, reason
        except:
            pass
        return False, "some id is not in this team"

    def lose(self, id, type):
        assert id != self.__teamLeader and self.__teamLeader is not None
        exist = False
        for i in self._members:
            if i["id"] == id and i["type"] == type:
                exist = True
                break
        if not exist:
            return False, "id 标识的角色不再队伍中， team.py 169"
        result, reason = dbaccess.kickOneOutTeam(self._id, id)
        self.update()
        return result, reason

