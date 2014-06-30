package com.glearning.melee.components.friendsSystem
{
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.FriendsSystemInfo;
	import com.glearning.melee.net.RemoteService;
	import com.glearning.melee.collections.collection;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.CheckBox;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class AddEnemyImpl extends Canvas
	{
		public var playerName:TextInput;
		public var isCheck:CheckBox;
		public var obj:FriendsSystemImpl;
		
		public function AddEnemyImpl()
		{
			super();
		}
		
		//关闭
		public function close():void{
			PopUpManager.removePopUp(this);
		}
		
		//确定
		public function ok():void{
			if(playerName.text == ''){
				var tip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = '请填写要加为仇敌的人物名称！';
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
			}else{
				if(isCheck.selected == true){
					RemoteService.instance.addPlayerFriend(collection.playerId,playerName.text,2,true,'').addHandlers(onResult);
				}else{
					RemoteService.instance.addPlayerFriend(collection.playerId,playerName.text,2,false,'').addHandlers(onResult);
				}
				//请求服务器添加仇敌
			}
		}
		
		//回调
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			var tip:NormalTipComponent = new NormalTipComponent();
			if(event.result['result'] == true){
				if(obj != null){
					FriendsSystemInfo.instance.blackListData.push(event.result['data']['newFriend']);
					obj.hideEnemy();
					obj.blackLists.dataProvider = FriendsSystemInfo.instance.blackListData;
					if(FriendsSystemInfo.instance.blackListData.length >= 12){
						obj.blackLists.percentHeight = 100;
					}else{
						obj.blackLists.height = FriendsSystemInfo.instance.blackListData.length*30+25;
					}
					obj.count += 1; 
				}
				
				
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = '您已经成功将【'+playerName.text+'】添加为仇敌!';
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
				PopUpManager.removePopUp(this);
			}else{
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = event.result['reason'];
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
			}
		}
		
	}
}