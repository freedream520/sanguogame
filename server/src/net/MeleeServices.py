#coding:utf8
'''
Created on 2009-11-30

'''

import sys
sys.path.append('../')
import time, datetime
import codecs, win32console
import MySQLdb
from ConfigParser import ConfigParser
from twisted.python import log
from util.DataLoader import loader
from twisted.internet import reactor
from net.MeleeSite import MeleeSiteFactory, root, static
from util.serverService import *

version = '0.0.0'

def serverConfig():
    import sys
    args = sys.argv
    settings = ConfigParser()
    gameSettings = {}
    def promptAndExit():
        usage = \
        '''
            -help:
            -config:
        '''
        print usage
        sys.exit()

    if len(args) > 1:
        command = args[1]
        if command == '-help':
            promptAndExit()
        elif command == '-config':
            try:
                filename = args[2]
                settings.read(filename)
            except:
                promptAndExit()
        else:
            promptAndExit()
    else:
        try:
            try:
                open('melee.ini', 'r')
            except Exception as e:
                print e
                raise
            settings.read('melee.ini')
        except:
            promptAndExit()

    try:
        try:
            gameSettings['game_server_data_dir'] = settings.get('Game', 'DataDir')
        except:
            gameSettings['game_server_data_dir'] = './data'

        gameSettings['web_server_port'] = settings.getint('web', 'web_port')
        gameSettings['web_server_host'] = settings.get('web', 'web_host')
        gameSettings['web_server_root_dir'] = settings.get('web', 'web_rootDir')
        #gameSettings['web_server_root_page'] = settings.get('web', 'web_rootPage')
        gameSettings['web_server_images_dir'] = settings.get('web', 'web_imagesDir')
        gameSettings['web_server_data_dir'] = settings.get('web', 'web_dataDir')

        gameSettings['db_server_host'] = settings.get('database', 'db_host')
        gameSettings['db_server_port'] = settings.getint('database', 'db_port')
        gameSettings['db_server_name'] = settings.get('database', 'db_name')
        gameSettings['db_server_user'] = settings.get('database', 'db_user')
        gameSettings['db_server_password'] = settings.get('database', 'db_password')

        try:
            gameSettings['log_twisted'] = settings.get('log', 'log_main')
        except:
            gameSettings['log_twisted'] = './mainErrors.log'
        try:
            gameSettings['log_amfast'] = settings.get('log', 'log_secondary')
        except:
            gameSettings['log_amfast'] = './secondaryErrors.log'

    except Exception as e:
        print e
        sys.exit()

    try:
        f = open('./version.txt', 'r')
        global version
        version = f.readline()
        f.close()
    except:
        log.msg('There is No file names version.txt in current Directory!')


    dbpool = MySQLdb.connect(host = gameSettings['db_server_host'],
                             user = gameSettings['db_server_user'],
                             passwd = gameSettings['db_server_password'],
                             port = gameSettings['db_server_port'],
                             db = gameSettings['db_server_name'],
                             charset = 'utf8')

    import util.util
    import util.dbaccess
    util.dbaccess.dbpool = dbpool
    util.util.dbpool = dbpool

    reload(sys)
    sys = sys
    sys.setdefaultencoding('utf-8')

    #print sys.getdefaultencoding()

    if sys.platform == 'win32':
        try:
            import win32console
        except:
            print "Python Win32 Extensions module is required.\n You can download it from https://sourceforge.net/projects/pywin32/ (x86 and x64 builds are available)\n"
            exit(-1)
        # win32console implementation  of SetConsoleCP does not return a value 
        # CP_UTF8 = 65001 
        win32console.SetConsoleCP(65001)
        if (win32console.GetConsoleCP() != 65001):
            raise Exception ("Cannot set console codepage to 65001 (UTF-8)")
        win32console.SetConsoleOutputCP(65001)
        if (win32console.GetConsoleOutputCP() != 65001):
            raise Exception ("Cannot set console output codepage to 65001 (UTF-8)")

    sys.stdout = codecs.getwriter('utf8')(sys.stdout)
    sys.stderr = codecs.getwriter('utf8')(sys.stderr)

    from zope.interface import implements

    class loogoo:
        implements(log.ILogObserver)
        def __init__(self):
            self.file = file(gameSettings['log_twisted'], 'w')
        def __call__(self, eventDict):
            if 'logLevel' in eventDict:
                level = eventDict['logLevel']
            elif eventDict['isError']:
                level = 'ERROR'
            else:
                level = 'INFO'
            text = log.textFromEventDict(eventDict)
            if text is None or level != 'ERROR':
                return
            self.file.write(str(level) + '\r\n' + text + '\r\n')
            self.file.flush()

    import amfast
    from logging import FileHandler
    amfast.logger.addHandler(FileHandler(gameSettings['log_amfast'], 'w'))

    log.addObserver(loogoo())
    log.startLogging(sys.stdout)

    #loader.read('./data')

    loader.read(gameSettings['game_server_data_dir'])

    root.addHost(gameSettings['web_server_host'], static.File(gameSettings['web_server_root_dir']))
    root.putChild('images', static.File(gameSettings['web_server_images_dir']))
    root.putChild('data', static.File(gameSettings['web_server_data_dir']))

    reactor.listenTCP(gameSettings['web_server_port'], MeleeSiteFactory(root))

    '''每天8点给所有玩家加90点活力'''
    '''每天8点玩家宿屋操作次数置0'''
    '''每天8点玩家进入副本次数置0'''
    currSeconds = time.time()
    hour = datetime.datetime.now().hour
    minute = datetime.datetime.now().minute
    second = datetime.datetime.now().second
    if hour >= 8:
        delta = (hour - 8) * 3600 + minute * 60 + second
        delta = 3600 * 24 - delta
    else:
        delta = (8 - hour - 1) * 3600 + (60 - minute) * 60 + (60 - second)
        delta = 3600 * 24 + delta
    reactor.callLater(delta, addEnergyPerDay)
    reactor.callLater(delta, resetPlayerRestCountPerDay)
    reactor.callLater(delta, resetPlayerEnterInstanceCount)

def serverStart():
    from twisted.internet import reactor
    reactor = reactor
    reactor.run()



