#coding:utf8

from singleton import Singleton
#from core.Character import PlayerCharacter, Monster

class PlayersManager:

    __metaclass__ = Singleton

    def __init__(self):
        self._players = {}

    def addPlayer(self, player):
        if self._players.has_key(player.baseInfo.id):
            raise Exception("系统记录冲突")
        self._players[player.baseInfo.id] = player

    def getPlayerByID(self, id):
        try:
            player = self._players[id]
            if player:
                player.sync()
            return player
        except:
            return None

    def getPlayerByNickname(self, nickname):
        for k in self._players.values():
            if k.baseInfo.getNickName() == nickname:
                return k
        return None

    def createPlayerByID(self, id):
        pass
 #       return PlayerCharacter(id)

    def createMonsterByID(self, id):
        pass
 #       return Monster(id)

    def update(self, time):
        for k, v in self._players.items():
            v.update(time)
            if v.isOnLine():
                pass
            else:
                v.archiveInfo()
                del self._players[k]

    def dropPlayer(self, player):
        key = None
        for k, v in self._players.items():
            if player is v:
                key = k
        if key is not None:
            del self._players[key]

    def dropPlayerByID(self, id):
        try:
            del self._players[id]
        except:
            pass
