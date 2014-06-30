package com.glearning.melee.components.mailSystem
{
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.net.RemoteService;
	import com.glearning.melee.collections.collection;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class SendMailImpl extends Canvas
	{
		public var playerName:TextInput;
		public var content:TextArea;
		
		public function SendMailImpl()
		{
			super();
		}
		
		//关闭
		public function close():void{
			PopUpManager.removePopUp(this);
		}
		
		//发送邮件
		public function sendMail():void{
			if(playerName.text == ''){
				tip('请填写发信对象人物名称！');
			}else if(content.text == ''){
				tip('请填写信函内容！');
			}else{
				RemoteService.instance.addMail(collection.playerId,playerName.text,content.text,'').addHandlers(onResult);
			}
		}
		
		//提示框
		public function tip(str:String):void{
			var tip:NormalTipComponent = new NormalTipComponent();
			PopUpManager.addPopUp(tip,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(tip);
	        tip.hideButton();
	        tip.tipText.text = str;
	        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
		}
		
		//回调
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			close();
			tip(event.result['reason']);
		}
	}
}