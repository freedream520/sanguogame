package com.glearning.melee.components.mailSystem
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.net.RemoteService;
	import mx.core.Application;
	import flash.events.MouseEvent;
	import mx.containers.Canvas;
	import mx.controls.TextArea;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class ReplyMailImpl extends Canvas
	{
		[Bindable]
		public var replyName:String;
		
		[Bindable]
		public var reference:String;
		
		public var content:TextArea;
		
		public function ReplyMailImpl()
		{
			super();
		}
		
		//关闭
		public function close():void{
			PopUpManager.removePopUp(this);
		}
		
		//发送邮件
		public function sendMail():void{
			RemoteService.instance.addMail(collection.playerId,replyName,content.text,reference).addHandlers(onResult);
		}
		
		//回调
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			close();
			var tip:NormalTipComponent = new NormalTipComponent();
			PopUpManager.addPopUp(tip,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(tip);
	        tip.hideButton();
	        tip.tipText.text = event.result['reason'];
	        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
		}
		
	}
}