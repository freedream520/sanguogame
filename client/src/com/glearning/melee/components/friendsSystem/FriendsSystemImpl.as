package com.glearning.melee.components.friendsSystem
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.model.FriendsSystemInfo;
	import com.glearning.melee.net.RemoteService;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class FriendsSystemImpl extends Canvas
	{

		//人数类型
		[Bindable]
		public var type:String = '好友';
		
		//当前人数
		[Bindable]
		public var count:int = 0;
		
		//总人数
		[Bindable]
		public var totleCount:int =20;
		
		public var friendsList:VBox;
		public var blackList:VBox;
		
		public var addFriend:LinkButton;
		public var addBlack:LinkButton;
		
		public var friendsTip:HBox;
		public var enemyTip:HBox;
		
		public var friends:LinkButton;
		public var enemys:LinkButton;
		public var select:LinkButton;
		
		public var friendsLists:DataGrid;
		public var blackLists:DataGrid;
		
		public function FriendsSystemImpl()
		{
			super();
		}
		
		//初始数据
		public function init():void{
			RemoteService.instance.getPlayerFrinds(collection.playerId,1).addHandlers(onResult);
		}
		
		//回调
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				totleCount = event.result['data']['friendCount'];
				count = event.result['data']['friends'].length;
				if(type == '好友'){
					if(event.result['data']['friends'].length != 0){
						hideFriend();
						if(event.result['data']['friends'].length >= 12){
							friendsLists.percentHeight = 100;
						}else{
							friendsLists.height = event.result['data']['friends'].length*30+25;
						}
						FriendsSystemInfo.instance.friendsListData = event.result['data']['friends'] as Array;
					}else{
						friendsLists.height = 25
						FriendsSystemInfo.instance.friendsListData = event.result['data']['friends'] as Array;
						showFriend()
					}
				}else{
					if(event.result['data']['friends'].length != 0){
						hideEnemy();
						if(event.result['data']['friends'].length >= 12){
							blackLists.percentHeight = 100;
						}else{
							blackLists.height = event.result['data']['friends'].length*30+25;
						}
						
						FriendsSystemInfo.instance.blackListData = event.result['data']['friends'] as Array;
					}else{
						blackLists.height = 25
						FriendsSystemInfo.instance.blackListData = event.result['data']['friends'] as Array;
						showEnemy();
					}
				}	
				
			}
		}
		
		//打开好友
		public function openFriendsList():void{
			type = '好友';
			friendsList.visible = true;
			blackList.visible = false;
			addFriend.visible = true;
			friends.styleName = 'roleClickButton';
		   	enemys.styleName = 'roleNoClickButton';
		   	select.styleName = 'roleNoClickButton';
			hideButton(addBlack);
			RemoteService.instance.getPlayerFrinds(collection.playerId,1).addHandlers(onResult);
		}
		
		//打开黑名单
		public function openBlackList():void{
			type = '仇敌';
			friendsList.visible = false;
			blackList.visible = true;
			addBlack.visible = true;
			hideButton(addFriend);
			friends.styleName = 'roleNoClickButton';
		   	enemys.styleName = 'roleClickButton';
		   	select.styleName = 'roleNoClickButton';
		   	RemoteService.instance.getPlayerFrinds(collection.playerId,2).addHandlers(onResult);
		}
		
		//查看玩家
		public function selectPlayer():void{
			var selectPalyer:SelectPlayerComponent = new SelectPlayerComponent();
			PopUpManager.addPopUp(selectPalyer,Application.application.canvas1,true);
			PopUpManager.centerPopUp(selectPalyer);	
		}
		
		//关闭
		public function close():void{
			PopUpManager.removePopUp(this);
			FriendsSystemInfo.instance.blackListData = [];
			FriendsSystemInfo.instance.friendsListData = [];
		}
		
		//隐藏添加按钮
		public function hideButton(button:LinkButton):void{
			button.visible = false;
			button.includeInLayout = false ;
		}
		
		//添加好友
		public function addFriendTip():void{
			var friendTip:AddFriendComponent = new AddFriendComponent();
			friendTip.obj = this;
			PopUpManager.addPopUp(friendTip,Application.application.canvas1,true);
			PopUpManager.centerPopUp(friendTip);	
		}
		
		//添加仇敌
		public function addEnemyTip():void{
			var enemyTip:AddEnemyComponent = new AddEnemyComponent();
			enemyTip.obj = this;
			PopUpManager.addPopUp(enemyTip,Application.application.canvas1,true);
			PopUpManager.centerPopUp(enemyTip);
		}
		
		//隐藏好友提示
		public function hideFriend():void{
			friendsTip.visible = false;
			friendsTip.includeInLayout = false ;
		}
		
		//显示好友提示
		public function showFriend():void{
			friendsTip.visible = true;
			friendsTip.includeInLayout = true ;
		}
		
		//隐藏仇敌提示
		public function hideEnemy():void{
			enemyTip.visible = false;
			enemyTip.includeInLayout = false ;
		}
		
		//显示仇敌提示
		public function showEnemy():void{
			enemyTip.visible = true;
			enemyTip.includeInLayout = true ;
		}
		
		//打开扩展
		public function openExtension():void{
			var extension:ExtensionComponent = new ExtensionComponent();
			extension.obj = this;
			extension.totleCount = totleCount;
			PopUpManager.addPopUp(extension,Application.application.canvas1,true);
			PopUpManager.centerPopUp(extension);
		}
		
	}
}