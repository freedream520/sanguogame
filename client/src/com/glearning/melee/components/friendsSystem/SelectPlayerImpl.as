package com.glearning.melee.components.friendsSystem
{
	import com.glearning.melee.components.prompts.NormalTipComponent;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class SelectPlayerImpl extends Canvas
	{
		public var playerName:TextInput;
		
		public function SelectPlayerImpl()
		{
			super();
		}
		
		//关闭
		public function close():void{
			PopUpManager.removePopUp(this);
		}
		
		//查看
		public function ok():void{
			if(playerName.text == ''){
				var tip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = '请填写要查看的人物名称！';
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
			}else{
				
			}
		}
		
		//回调
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			
		}
	}
}