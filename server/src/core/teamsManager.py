#coding:utf8
'''
Created on 2010-3-11

@author: zhaoxionghui
'''

from singleton import Singleton
from team import Team
from util import dbaccess

class TeamsManager:
    '''
    TeamsManager
    '''
    __metaclass__ = Singleton

    def __init__(self):
        self.teams = []
        self.teams.append(Team(0))

    def getMyTeamByID(self, id):
        for i in self.teams:
            if i.getID() == id:
                return i
        return None

    def createNewTeam(self):
        id = dbaccess.createNewTeam()
        team = Team(id)
        return team

    def addTeam(self, team):
        if self.teams.count(team) == 0:
            self.teams.append(team)

    def update(self):
        pass
