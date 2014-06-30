package com.glearning.melee.components.mailSystem
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.friendsSystem.AddEnemyComponent;
	import com.glearning.melee.components.friendsSystem.AddFriendComponent;
	import com.glearning.melee.components.peopleInformation.PeopleInformationComponent;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.MailInfo;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class MailImpl extends VBox
	{
		[Bindable]
		public var mailData:Object;
		
		[Bindable]
		public var type:String;
		
		[Bindable]
		public var dateTime:String;
		
		public var del:LinkButton;
		
		public var playerFrom:HBox;
		public var playerBtn:HBox;
		public var systemBtn:HBox;
		public var allBtn:HBox;
		public var isFriend:HBox;
		
		public var reference:Text;
		
		public var teamRequest:LinkButton;
		
		public function MailImpl()
		{
			super();
		}
		
		//初始
		public function init():void{
			if(mailData['type'] == '1'){
				type = '系统信函';
				if(mailData['systemType'] == 0){
					hideSystem();
				}
				hidePlayer();
			}else if(mailData['type'] == '4'){
				type = '系统公告';
				hideAll();
				hidePlayer();
			}else if(mailData['type'] == '2'){
				type = '玩家信函';
				hideSystem();
				if(mailData['isFriend'] != 0){
					hideFriend();
				}
			}
			var date:Date = mailData['sendTime'];
			dateTime = (date.monthUTC+1).toString()+'月'+date.dateUTC.toString()+'日 '+date.hoursUTC.toString()+':'+date.minutesUTC.toString();
			
			if(mailData['reference'] == ''){
				reference.visible = false;
				reference.includeInLayout = false;	
				
			}
		}
		
		//删除信函
		public function delMail():void{
			var tip:NormalTipComponent = new NormalTipComponent();
			PopUpManager.addPopUp(tip,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(tip);
	        tip.tipText.text = '确定要删除这个信函吗？';
	        tip.accept.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.deleteMail(collection.playerId,mailData['id']).addHandlers(onResult);PopUpManager.removePopUp(tip);});
		}
		
		//回调
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				if(mailData['type'] == '1'){
					delData(MailInfo.instance.systemMailData,mailData['id'])
				}else if(mailData['type'] == '4'){
					delData(MailInfo.instance.announcementData,mailData['id'])
				}else if(mailData['type'] == '2'){
					delData(MailInfo.instance.playerMailData,mailData['id'])
				}
				this.parent.removeChild(this);
			}else{
				var tip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = event.result['reason'];
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
			}
		}
		
		//删除记录
		private function delData(data:Array,idx:int):void{
			for(var i:int = 0;i<data.length;i++){
				if(data[i]['id'] == idx){
					data.splice(i,1);
				}
			}
		}
		
		//隐藏玩家信函组件
		private function hidePlayer():void{
			playerFrom.visible = false;
			playerFrom.includeInLayout = false;
			
			playerBtn.visible = false;
			playerBtn.includeInLayout = false;
		}
		
		//隐藏系统邮件组件
		private function hideSystem():void{
			systemBtn.visible = false;
			systemBtn.includeInLayout =false;
		}
		
		//隐藏所有邮件组件
		private function hideAll():void{
			allBtn.visible = false;
			allBtn.includeInLayout = false;
		}
		
		//隐藏好友相关组件
		private function hideFriend():void{
			isFriend.visible = false;
			isFriend.includeInLayout = false;
		}
		
		//加为好友
		public function addFriend():void{
			var friendTip:AddFriendComponent = new AddFriendComponent();
			PopUpManager.addPopUp(friendTip,Application.application.canvas1,true);
			PopUpManager.centerPopUp(friendTip);	
			friendTip.playerName.text = mailData['name'];
		}
		
		//加为仇敌
		public function addEnemy():void{
			var enemyTip:AddEnemyComponent = new AddEnemyComponent();
			PopUpManager.addPopUp(enemyTip,Application.application.canvas1,true);
			PopUpManager.centerPopUp(enemyTip);
			enemyTip.playerName.text = mailData['name'];
		}
		
		//回复
		public function reply():void{
			var replyMail:ReplyMailComponent = new ReplyMailComponent();
			replyMail.replyName = mailData['name'];
			replyMail.reference = mailData['content'];
			PopUpManager.addPopUp(replyMail,Application.application.canvas1,true);
			PopUpManager.centerPopUp(replyMail);
		}
		
		//查看玩家信息
		public function openPeople():void{
			var people:PeopleInformationComponent = new PeopleInformationComponent();
			people.peopleId = mailData.playerId;
			PopUpManager.addPopUp(people,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(people);
		}
			
	}
}