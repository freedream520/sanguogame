package com.glearning.melee.components.ProcedureHall
{
	import com.glearning.melee.components.task.GoldTaskNpcComponent;
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.net.RemoteService;
	import com.glearning.melee.collections.collection;
	import mx.core.Application;
	import mx.containers.Canvas;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class ProcedureHallPanleImpl extends Canvas
	{
		public var placeId:int;
		public var hang:HangComponent;
		public var taskNpc:GoldTaskNpcComponent;
		
		public function ProcedureHallPanleImpl()
		{
			super();
		}
		
		public function closeProcedureHall():void{
			Application.application.currentState = collection.currentPosition;
			if(hang.timeUtil != null){
				hang.timeUtil.timer.stop();
			}
		}
		
		public function init():void{
			RemoteService.instance.getLobbyInfo(collection.playerId,placeId).addHandlers( onGetLobbyInfo );
		}
		
		public function onGetLobbyInfo(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				taskNpc.npcImage = event.result['data']['npcInfo']['image'];
				taskNpc.npcId = event.result['data']['npcInfo']['id'];
				taskNpc.npcName = event.result['data']['npcInfo']['name'];
				taskNpc.npcPic.source = event.result['data']['npcInfo']['image'];
				taskNpc.talkInfo = event.result['data']['npcInfo']['dialogContent'];
				taskNpc.npcTalk.text = '斯大丈夫也，于乱世，非嘘叹苟且，而应以天下为己任！精悍其身，运筹帷幄，造福于万民！此乃铁血真汉子！';
				if(event.result['data']['lobbyInfo'] == null){
					hang.init();
				}
				else{
					hang.init(event.result['data']['lobbyInfo']['seconds']);
				}
					
			}
			
		}
		
	}
}