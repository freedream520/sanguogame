package com.glearning.melee.components.friendsSystem
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.net.RemoteService;
	
	import mx.controls.LinkButton;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class SheildedMailImpl extends LinkButton
	{
		public var isSheildedMail:LinkButton;
		
		public function SheildedMailImpl()
		{
			super();
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			if (data.isSheildedMail == 0) {
				this.label = '未屏蔽';
			} else {
				this.label = '已屏蔽';
			}
		}
		
		public function sheildedMail():void{
			if (data.isSheildedMail == 0) {
				RemoteService.instance.updataIsSheildedMail(collection.playerId,data.friendId,true).addHandlers(onResult);
			} else {
				RemoteService.instance.updataIsSheildedMail(collection.playerId,data.friendId,false).addHandlers(onResult);
			}
		}
		
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				if (data.isSheildedMail == 0) {
					this.label = '已屏蔽';
					data.isSheildedMail = 1;
				} else {
					this.label = '未屏蔽';
					data.isSheildedMail = 0;
				}
			}
		}
	}
}