package com.glearning.melee.components.peopleInformation
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.friendsSystem.AddFriendComponent;
	import com.glearning.melee.components.mailSystem.SendMailComponent;
	import com.glearning.melee.components.packages.EquipmentSlotPackageComponent;
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	import com.glearning.melee.net.RemoteService;
	
	import mx.containers.Canvas;
	import mx.controls.ProgressBar;
	import mx.core.Application;
	import mx.events.ToolTipEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class PeopleInformationImpl extends Canvas
	{
		[Bindable]
		public var peopleData:Object;
		
		public var people:EquipmentSlotPackageComponent;
		public var peopleId:int; 
		
		public var hp:ProgressBar;
		public var mp:ProgressBar;
		public var str:ProgressBar;
		public var dex:ProgressBar;
		public var vit:ProgressBar;
		
		public function PeopleInformationImpl()
		{
			super();
		}
		
		//关闭
		public function close():void{
			PopUpManager.removePopUp(this);
		}
		
		//初始
		public function init():void{
			people.bol = false;
			people.peoplePackage(peopleId);
			RemoteService.instance.getOtherPlayerInfo(collection.playerId,peopleId).addHandlers(onResult);
		}
		
		//回调
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			peopleData = event.result;
			if(peopleData.camp == 1){
				peopleData.camp = '魏国';
			}else if(peopleData.camp == 2){
				peopleData.camp = '蜀国';
			}else if(peopleData.camp == 3){
				peopleData.camp = '吴国';
			}else if(peopleData.camp == 9){
				peopleData.camp = '中立';
			}else{
				peopleData.camp = '在野';
			}
			hp.setProgress(peopleData.hp/peopleData.maxHp*100,100);        	
        	mp.setProgress(peopleData.mp/peopleData.maxMp*100,100); 
        	str.setProgress((peopleData.baseStr+peopleData.manualStr)/(peopleData.manualStr+peopleData.level -1)*100,100);
	    	dex.setProgress((peopleData.baseDex+peopleData.manualDex)/(peopleData.manualDex+peopleData.level -1)*100,100);
	    	vit.setProgress((peopleData.baseVit+peopleData.manualVit)/(peopleData.manualVit+peopleData.level -1)*100,100);
		}
		
		//加好友
		public function openFriend():void{
			var friendTip:AddFriendComponent = new AddFriendComponent();
			PopUpManager.addPopUp(friendTip,Application.application.canvas1,true);
			PopUpManager.centerPopUp(friendTip);	
			friendTip.playerName.text = peopleData.nickName;
		}
		
		//发送信函
		public function openMail():void{
			var sendMail:SendMailComponent = new SendMailComponent();
			PopUpManager.addPopUp(sendMail,Application.application.canvas1,true);
			PopUpManager.centerPopUp(sendMail);	
			sendMail.playerName.text = peopleData.nickName;
		}
		
		//即使聊天
		public function toTalk():void{
			Application.application.chatWindow.enableChatTo();
			Application.application.chatWindow.nameInput.text = peopleData.nickName;
		}
		
		public function createCustomToolTip(event:ToolTipEvent):void { 
  
             var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();  
             toolTip.progressId = event.target.id;             
             toolTip.otherInit(1,peopleData);
             event.toolTip = toolTip; 
         }
         
         public function hp_mp_Tip(event:ToolTipEvent):void { 
  
             var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();  
             toolTip.progressId = event.target.id;             
             toolTip.otherInit(2,peopleData);
             event.toolTip = toolTip; 
         }
         
         public function otherTip(event:ToolTipEvent):void { 
  
             var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();  
             toolTip.progressId = event.target.id;             
             toolTip.otherInit(3,peopleData);
             event.toolTip = toolTip; 
         } 
	}
}