package com.glearning.melee.components
{
	import com.glearning.melee.components.mailSystem.SendMailComponent;
	
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.core.Application;
	import mx.managers.PopUpManager;

	public class EmailOrTalkImpl extends HBox
	{
		public var emailReadType:Image;

		public function EmailOrTalkImpl()
		{
			super();
		}		
			
	
		override public function set data(value:Object):void {
			super.data = value;

			if(emailReadType == null)
			 emailReadType=new Image();

			if (value.isOnLine == true) {

			emailReadType.source ='images/talk.gif';
			   } else {
			emailReadType.source = 'images/record.gif';
			   }
		}
		public function MailOrTalk():void{
			if (data.isOnLine == true) {
				Application.application.chatWindow.enableChatTo();
				Application.application.chatWindow.nameInput.text = data.nickname;
			} else {
				var sendMail:SendMailComponent = new SendMailComponent();
				PopUpManager.addPopUp(sendMail,Application.application.canvas1,true);
				PopUpManager.centerPopUp(sendMail);	
				sendMail.playerName.text = data.nickname;
		   	}
		}
	}
}