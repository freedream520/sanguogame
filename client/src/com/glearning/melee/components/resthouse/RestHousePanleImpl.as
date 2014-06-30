package com.glearning.melee.components.resthouse
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.task.GoldTaskNpcComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class RestHousePanleImpl extends Canvas
	{
		public var placeId:int;
		public var taskNpc:GoldTaskNpcComponent;
		public var restHouse:RecoveryComponent;
		
		public function RestHousePanleImpl()
		{
			super();
		}
		
		public function closeRestHouse():void{
			Application.application.currentState = collection.currentPosition;
		}
		
		public function init():void{
			RemoteService.instance.getRestRoomInfo(collection.playerId,placeId).addHandlers( onGetRestRoomInfo );
		}
		
		public function onGetRestRoomInfo(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				taskNpc.npcImage = event.result['data']['npcInfo']['image'];
				taskNpc.npcId = event.result['data']['npcInfo']['id'];
				taskNpc.npcName = event.result['data']['npcInfo']['name'];
				taskNpc.npcPic.source = event.result['data']['npcInfo']['image'];
				taskNpc.talkInfo = event.result['data']['npcInfo']['dialogContent'];
				taskNpc.npcTalk.text = '欢迎莅临我们的小屋～一星级的价格，五星级的享受，人人都是VIP服务～价目表如下，欢迎享受家的感觉。';
				MySelf.instance.rest = event.result['data']['countList'][0];
				MySelf.instance.shallowSleep = event.result['data']['countList'][1];
				MySelf.instance.sleep = event.result['data']['countList'][2];
				MySelf.instance.sleeping = event.result['data']['countList'][3];
				restHouse.updata();
			}
		}
	}
}