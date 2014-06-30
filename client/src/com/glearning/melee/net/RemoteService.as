package com.glearning.melee.net
{
	import com.glearning.melee.collections.collection;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import mx.collections.ItemResponder;
	import mx.core.mx_internal;
	import mx.messaging.ChannelSet;
	import mx.messaging.Consumer;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.events.MessageEvent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;

	use namespace flash_proxy;
	use namespace mx_internal;
	
	/**
	 * RemoteService is a remote procedure call service, 
	 * clients can connect a remote service on network,
	 * login/logout and call the remote procedures. 
	 * RemoteService is a singleton.
	 * 
	 * @author hanbing
	 * 
	 */
	public dynamic class RemoteService extends Proxy
	{
		
		protected var _remoteObj:RemoteObject;
		
		protected var _channelSet:ChannelSet;
		protected var _channel:AMFChannel;
		
		protected var _consumers:Dictionary = new Dictionary();
		public static var bol:Boolean = false;
		
		/**
		 * The singleton MySelf instance.
		 */
		public static function get instance():RemoteService
		{
			if(bol)
				collection.openLoading();
			bol = true;
			if (!_instance)
				_instance = new RemoteService();
				
			return _instance;
		}
		  
		private static var _instance:RemoteService = null;
		
		public function RemoteService()	{
		}
		

		public function connect( url:String, destination:String ):void {
			// Create the AMF Channel
			_channel = new AMFChannel("amf-channel", url);

			// Create a channel set and add your channel(s) to it
			_channelSet = new ChannelSet();
			_channelSet.addChannel(_channel);

			// Create a new remote object
			_remoteObj = new RemoteObject(destination);
			_remoteObj.showBusyCursor = true;
			_remoteObj.channelSet = _channelSet;
			
		}
				
		public function disconnect():void {
			_remoteObj.disconnect();
		}
		
		public function login( username:String, password:String ):void {
			_remoteObj.channelSet.login(username,password).addResponder(new MyItemResponder(defaultResultHandler, defaultFaultHandler,false));
		}
		
		public function logout():void {
			_remoteObj.channelSet.logout().addResponder(new MyItemResponder(defaultResultHandler, defaultFaultHandler,false));
		}

		private function defaultResultHandler( event:Event, token:AsyncToken ):void {
			trace( "Result from remote object", event.toString() );
		}
		
		public function defaultFaultHandler( event:FaultEvent, token:AsyncToken ):void {
            //Alert.show( "Fault: " + event.fault + " Msg: " + event.message );
            trace( "Fault: " + event.fault + " Msg: " + event.message );
		}
		
		private function getConsumerByTopic( topic:String ):Consumer {
			return this._consumers[topic];
		}
		
		/**
		 * 订阅topic频道的消息
		 */
		public function subscribe( topic:String, handler:Function ):void {
			if( getConsumerByTopic(topic) == null ) {
				this._consumers[ topic ] = new Consumer();
				getConsumerByTopic(topic).destination = topic;
				getConsumerByTopic(topic).channelSet = this._channelSet;
				getConsumerByTopic(topic).subscribe();
			}
			getConsumerByTopic(topic).addEventListener(MessageEvent.MESSAGE, handler, false, 0 , true);
		}
		
		/**
		 * 取消订阅topic频道的消息
		 */
		public function unsubscribe( topic:String ):void {
			if( getConsumerByTopic(topic) != null && getConsumerByTopic(topic).subscribed ) {
				getConsumerByTopic(topic).unsubscribe();
				delete this._consumers[topic];
			}
		}

	    //---------------------------------
	    //   Proxy methods
	    //---------------------------------
	    /**
	     * @private
	     */
	    override flash_proxy function getProperty(name:*):*
	    {
	        return _remoteObj.getOperation(getLocalName(name));
	    }
	
	    /**
	     * @private
	     */
	    override flash_proxy function setProperty(name:*, value:*):void
	    {
	        var message:String = "operationsNotAllowedInService";
	        throw new Error(message);
	    }
	
	    /**
	     * @private
	     */
	    override flash_proxy function callProperty(name:*, ... args:Array):*
	    {
	        return new CallHandle( _remoteObj.getOperation(getLocalName(name)).send.apply(null, args) );
	    }
	
	    //used to store the nextName values
	    private var nextNameArray:Array;
	    
	    /**
	     * @private
	     */
	    override flash_proxy function nextNameIndex(index:int):int
	    {
	        if (index == 0)
	        {
	            nextNameArray = [];
	            for (var op:String in _remoteObj._operations)
	            {
	                nextNameArray.push(op);    
	            }    
	        }
	        return index < nextNameArray.length ? index + 1 : 0;
	    }
	
	    /**
	     * @private
	     */
	    override flash_proxy function nextName(index:int):String
	    {
	        return nextNameArray[index-1];
	    }
	
	    /**
	     * @private
	     */
	    override flash_proxy function nextValue(index:int):*
	    {
	        return _remoteObj._operations[nextNameArray[index-1]];
	    }
	
	    mx_internal function getLocalName(name:Object):String
	    {
	    	return String(name);
	    }
	}
}

import mx.rpc.AsyncToken;
import com.glearning.melee.net.RemoteService;
import mx.collections.ItemResponder;
import mx.controls.Alert;
import com.glearning.melee.net.MyItemResponder;

class CallHandle
{
	
	private var _token:AsyncToken;
	
	public function CallHandle( token:AsyncToken ) {
		_token = token;
	}
	
	public function addHandlers( resultHandler:Function,type:Boolean = true, faultHandler:Function = null):void {
		if( faultHandler!=null ) {
			_token.addResponder(new MyItemResponder(resultHandler, RemoteService.instance.defaultFaultHandler,type, _token));
		} else {
			_token.addResponder(new MyItemResponder(resultHandler, faultHandler,type, _token));
		}
	}
}