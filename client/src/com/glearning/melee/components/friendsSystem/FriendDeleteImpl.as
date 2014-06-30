package com.glearning.melee.components.friendsSystem
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.FriendsSystemInfo;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class FriendDeleteImpl extends LinkButton
	{
		public var tip:NormalTipComponent;
		
		public function FriendDeleteImpl()
		{
			super();
		}
		
		override public function set data(value:Object):void {
			super.data = value;
		}
		
		public function del():void{
			tip = new NormalTipComponent();
			PopUpManager.addPopUp(tip,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(tip);
	        tip.tipText.text = '确定要删除该人物吗？';
	        tip.accept.addEventListener(MouseEvent.CLICK,OkDelete);
		}
		
		private function OkDelete(e:MouseEvent):void{
			PopUpManager.removePopUp(tip);
			RemoteService.instance.removePlayerFriend(collection.playerId,data.friendId).addHandlers(onResult);
		}
		
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true)
			{
				if(data.type == 1){
					this.parentDocument.count -= 1;
					if( this.parentDocument.count == 0){
						this.parentDocument.friendsLists.height = 25;
						this.parentDocument.showFriend();
					}
					for(var i:int = 0;i<FriendsSystemInfo.instance.friendsListData.length;i++){
						if(FriendsSystemInfo.instance.friendsListData[i]['friendId'] == event.result['friendId']){
							FriendsSystemInfo.instance.friendsListData.splice(i,1);
						}
					}
					this.parentDocument.friendsLists.dataProvider = FriendsSystemInfo.instance.friendsListData;
					
					if(FriendsSystemInfo.instance.friendsListData.length >= 12){
						this.parentDocument.friendsLists.percentHeight = 100;
					}else{
						this.parentDocument.friendsLists.height = FriendsSystemInfo.instance.friendsListData.length*30+25;
					}
				}else{
					this.parentDocument.count -= 1;
					if( this.parentDocument.count == 0){
						this.parentDocument.blackLists.height = 25;
						this.parentDocument.showEnemy();
					}
					for(var j:int = 0;j<FriendsSystemInfo.instance.blackListData.length;j++){
						if(FriendsSystemInfo.instance.blackListData[j]['friendId'] == event.result['friendId']){
							FriendsSystemInfo.instance.blackListData.splice(j,1);
						}
					}
					this.parentDocument.blackLists.dataProvider = FriendsSystemInfo.instance.blackListData;
					
					if(FriendsSystemInfo.instance.blackListData.length >= 12){
						this.parentDocument.blackLists.percentHeight = 100;
					}else{
						this.parentDocument.blackLists.height = FriendsSystemInfo.instance.blackListData.length*30+25;
					}
				}

			}else{
				var tip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = event.result['reason'];
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
			}
		}
	}
}