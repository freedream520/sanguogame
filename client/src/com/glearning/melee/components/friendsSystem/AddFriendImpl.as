package com.glearning.melee.components.friendsSystem
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.FriendsSystemInfo;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	
	public class AddFriendImpl extends Canvas
	{
		public var playerName:TextInput;
		public var obj:FriendsSystemImpl;
		public var content:TextArea;
		
		public function AddFriendImpl()
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
		        tip.tipText.text = '请填写要加为好友的人物名称！';
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
			}else{
				//请求服务器添加好友
				var str:String = '';
				if(content.text == ''){
					str = '【'+MySelf.instance.nickName+'】将您添加为好友。'
				}else{
					str = '【'+MySelf.instance.nickName+'】将您添加为好友。并留言:'+content.text;
				}
				RemoteService.instance.addPlayerFriend(collection.playerId,playerName.text,1,false,str).addHandlers(onResult);
			}
		}
		
		//回调
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			var tip:NormalTipComponent = new NormalTipComponent();
			if(event.result['result'] == true){
				if(obj != null){
					FriendsSystemInfo.instance.friendsListData.push(event.result['data']['newFriend']);
					obj.hideFriend();
					obj.friendsLists.dataProvider = FriendsSystemInfo.instance.friendsListData;
					if(FriendsSystemInfo.instance.friendsListData.length >= 12){
						obj.friendsLists.percentHeight = 100;
					}else{
						obj.friendsLists.height = FriendsSystemInfo.instance.friendsListData.length*30+25;
					}
					obj.count += 1; 
				}
				
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = '您已经成功将【'+playerName.text+'】添加为好友!';
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