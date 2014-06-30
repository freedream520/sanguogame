package com.glearning.melee.components.mailSystem
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.model.MailInfo;
	import com.glearning.melee.net.RemoteService;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.components.utils.AutoTip;
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class MailSystemImpl extends Canvas
	{
		public var Announcement:LinkButton;
		public var systemMail:LinkButton;
		public var playerMail:LinkButton;
		public var Deal:LinkButton;
		
		public var allMail:LinkButton;
		public var matter:LinkButton;
		public var record:LinkButton;
		public var write:LinkButton;
		
		public var mailList:VBox;
		
		
		public function MailSystemImpl()
		{
			super();
		}
		
		//初始
		public function init():void{
			RemoteService.instance.mailList(collection.playerId).addHandlers(onResult);
		}
		
		
		//关闭
		public function close():void{
			PopUpManager.removePopUp(this);
			if(AutoTip._tip != null)
			{
				AutoTip._tip.visible = true;
			}
		}
		
		//所有邮件
		public function openMail():void{
			showButton(Announcement);
			showButton(systemMail);
			showButton(playerMail);
			hideButton(Deal);
			allMail.styleName = 'roleClickButton';
			matter.styleName = 'roleNoClickButton';
			record.styleName = 'roleNoClickButton';
			write.styleName = 'roleNoClickButton';
			allMailList();
		}
		
		//交易记录
		public function openAnnouncement():void{
			showButton(Announcement);
			showButton(systemMail);
			Announcement.visible = false;
			systemMail.visible = false;
			hideButton(playerMail);
			showButton(Deal);
			allMail.styleName = 'roleNoClickButton';
			matter.styleName = 'roleNoClickButton';
			record.styleName = 'roleClickButton';
			write.styleName = 'roleNoClickButton';
		}
		
		//事件簿
		public function openMatter():void{
			hideButton(Announcement);
			hideButton(systemMail);
			hideButton(playerMail);
			hideButton(Deal);
			allMail.styleName = 'roleNoClickButton';
			matter.styleName = 'roleClickButton';
			record.styleName = 'roleNoClickButton';
			write.styleName = 'roleNoClickButton';
			
		}
		
		//撰写信函
		public function openWrite():void{
			allMail.styleName = 'roleNoClickButton';
			matter.styleName = 'roleNoClickButton';
			record.styleName = 'roleNoClickButton';
			write.styleName = 'roleClickButton';
			var sendMail:SendMailComponent = new SendMailComponent();
			PopUpManager.addPopUp(sendMail,Application.application.canvas1,true);
			PopUpManager.centerPopUp(sendMail);	
		}
		
		//隐藏按钮
		public function hideButton(button:LinkButton):void{
			button.visible = false;
			button.includeInLayout = false ;
		}
		
		//显示按钮
		public function showButton(button:LinkButton):void{
			button.visible = true;
			button.includeInLayout = true ;
		}
		
		//系统公告
		public function announcementList():void{
			mailList.removeAllChildren();
			if(MailInfo.instance.announcementData.length == 0){
				var label:Label =new Label();
				label.text = '目前暂时没有任何该类型的信函';
				mailList.addChild(label);
			}else{
				for(var i:int=0;i<MailInfo.instance.announcementData.length;i++){
					var mail:MailComponent = new MailComponent();
					mail.mailData = MailInfo.instance.announcementData[i];
					mailList.addChild(mail);
				}
			}
			
		}
		
		//系统信函
		public function systemMailList():void{
			mailList.removeAllChildren();
			if(MailInfo.instance.systemMailData.length == 0){
				var label:Label =new Label();
				label.text = '目前暂时没有任何该类型的信函';
				mailList.addChild(label);
			}else{
				for(var i:int=0;i<MailInfo.instance.systemMailData.length;i++){
					var mail:MailComponent = new MailComponent();
					mail.mailData = MailInfo.instance.systemMailData[i];
					mailList.addChild(mail);
				}
			}
			
		}
		
		//玩家信函
		public function playerMailList():void{
			mailList.removeAllChildren();
			if(MailInfo.instance.playerMailData.length == 0){
				var label:Label = new Label();
				label.text = '目前暂时没有任何该类型的信函';
				mailList.addChild(label);
			}else{
				for(var i:int=0;i<MailInfo.instance.playerMailData.length;i++){
					var mail:MailComponent = new MailComponent();
					mail.mailData = MailInfo.instance.playerMailData[i];
					mailList.addChild(mail);
				}
			}
			
		}
		
		//所以信函
		private function allMailList():void{
			mailList.removeAllChildren();
			for(var i:int=0;i<MailInfo.instance.allMailData.length;i++){
				var mail:MailComponent = new MailComponent();
				mail.mailData = MailInfo.instance.allMailData[i];
				mailList.addChild(mail);
			}
		}
		
		//回调
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			MailInfo.instance.playerMailData.splice(0);
			MailInfo.instance.announcementData.splice(0);
			MailInfo.instance.systemMailData.splice(0);
			if(event.result['result'] == true){
				MailInfo.instance.allMailData = event.result['data']['mails'];
				var data:Array = event.result['data']['mails'];
				for(var i:int=0;i<data.length;i++){
					if(data[i]['type'] == '1'){	
						MailInfo.instance.systemMailData.push(data[i]);
					}else if(data[i]['type'] == '4'){		
						MailInfo.instance.announcementData.push(data[i]);
					}else if(data[i]['type'] == '2'){			
						MailInfo.instance.playerMailData.push(data[i]);
					}
					var mail:MailComponent = new MailComponent();
					mail.mailData = data[i];
					mailList.addChild(mail);
				}
			}
		}
		
		
	}
}