package com.glearning.melee.components.friendsSystem
{
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.components.prompts.PayMoneyComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	import com.glearning.melee.collections.collection;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class ExtensionImpl extends Canvas
	{
		//总人数
		[Bindable]
		public var totleCount:int =20;
		
		//扩充费用
		[Bindable]
		public var extensionGold:int = 0;
		
		public var extensionCount:TextInput;
		
		public var payMoney:PayMoneyComponent;
		
		public var obj:FriendsSystemImpl;
		
		public function ExtensionImpl()
		{
			super();
		}
		
		//关闭
		public function close():void{
			PopUpManager.removePopUp(this);
		}
		
		//扩展费用计算
		public  function setExtensionGold():void{
			var str:* = extensionCount.text;
			if(isNaN(str) == false){
				extensionGold = int(extensionCount.text) * 2;		
			}
		}
		
		//确定
		public function ok():void{
			var str:* = extensionCount.text;
			var tip:NormalTipComponent = new NormalTipComponent();
			if(isNaN(str)){
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = '扩建容量格式有误，请重新填写！';
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
			}else{
				payMoney = new PayMoneyComponent();
				payMoney.amount = extensionGold.toString();
				payMoney.description = '扩建好友名录吗？';
				PopUpManager.addPopUp(payMoney,Application.application.canvas1,true);
				PopUpManager.centerPopUp(payMoney);
				payMoney.payMoneyOK.addEventListener(MouseEvent.CLICK,payMoneyOK);
				
			}
			if(extensionCount.text == ''){
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = '请填写扩建容量！';
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
			}
		}
		
		
		public function payMoneyOK(e:MouseEvent):void{
			var type:String = '';
			if(payMoney.gold.selected == true){
				type = 'gold';
			}else{
				type = 'coupon';
			}
			RemoteService.instance.expandPlayerFriendCount(collection.playerId,int(extensionCount.text),type,extensionGold).addHandlers(onResult);
			PopUpManager.removePopUp(payMoney);
		}
		
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			var tip:NormalTipComponent = new NormalTipComponent();
			if(event.result['result'] == true){
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = '恭喜，您的名录已经扩建成功！';
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});	
		        obj.totleCount = event.result['data']['friendCount'];
		        MySelf.instance.gold = event.result['data']['gold'];
		        MySelf.instance.coupon = event.result['data']['coupon'];
		        close();
		        
			}else{

				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text =  event.result['reason'];
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});	
			}
			
		}
	}
}