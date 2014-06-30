#coding:utf8
'''
Created on 2009-10-12
Melee 项目的网页访问站点
@author: hanbing
'''

from amfast.remoting import Service, CallableTarget, ExtCallableTarget
from amfast.remoting.channel import SecurityError
from amfast.remoting.twisted_channel import TwistedChannelSet, TwistedChannel
from twisted.web import static, vhost
from twisted.web.server import Site
import amfast
import logging
import sys

service = Service('MeleeService')

def checkCredentials(user, password):

    if user != 'correct':
        raise SecurityError(u'用户名错.')

    if password != 'correct':
        raise SecurityError(u'密码错.')

    return True

def ServiceFunction(fn):
    service.mapTarget(ExtCallableTarget(fn, fn.__name__, secure = True))

def setup_channel_set(channel_set):
    """Configures an amfast.remoting.channel.ChannelSet object."""

    # Send log messages to STDOUT
    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(logging.DEBUG)
    amfast.logger.addHandler(handler)

    # Map service targets to controller methods
    channel_set.service_mapper.mapService(service)
    channel_set.checkCredentials = checkCredentials

# If the code is completely asynchronous,
# you can use the dummy_threading module
# to avoid RLock overhead.
import dummy_threading
dummy_threading = dummy_threading
amfast.mutex_cls = dummy_threading.RLock

# Setup ChannelSet
channel_set = TwistedChannelSet(notify_connections = True)
rpc_channel = TwistedChannel('rpc')
channel_set.mapChannel(rpc_channel)

def pushMessage(topic, msg):
    channel_set.publishObject(msg, topic)

from ServiceFunctions import *
setup_channel_set(channel_set)

root = vhost.NameVirtualHost()
#root.addHost("192.168.1.17", static.File("E:\\melee\\code\\client\\bin-debug"))
root.putChild('services', rpc_channel)
#root.putChild('images', static.File("E:\\melee\\program\\server\\melee\\public\\image"))
#root.putChild('data', static.File("E:\\melee\\program\\server\\melee\\public\\data"))

static = static
MeleeSiteFactory = Site
