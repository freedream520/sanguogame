package com.glearning.melee.components.prompts
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.utils.AutoTip;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class DeathImpl extends Canvas
	{
		public var charge:Label;
		public var coin:int;
		public var payMoney:PayMoneyComponent;
		
		public function DeathImpl()
		{
			super();
			this.addEventListener(FlexEvent.INITIALIZE,init);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,completeEvent);
		}
		
		public function completeEvent(event:FlexEvent):void
		{
			 if(AutoTip._tip !=null)
				AutoTip._tip.visible = false;
		}
		
		public function init(event:FlexEvent):void{
			if(MySelf.instance.level <= 10){
				charge.text = '免费';
			}else{
				coin = (MySelf.instance.level - 10)*120 + 480;
				charge.htmlText = coin.toString()+'铜币';
			}			
				
		}
		
		//回城复活
		public function toCity():void{
			RemoteService.instance.reliveInTown(collection.playerId).addHandlers(onRelive);
					
		}
		
		//原地复活
		public function situResurrection():void{
			
			RemoteService.instance.reliveInCurrentPlace(collection.playerId,coin).addHandlers(onRelive);
		}
		
		//黄金复活
		public function toMoney():void{
			payMoney = new PayMoneyComponent();
			payMoney.amount = '2';
			payMoney.description = '立即复活吗？';
			PopUpManager.addPopUp(payMoney,Application.application.canvas1,true);
			PopUpManager.centerPopUp(payMoney);
			payMoney.payMoneyOK.addEventListener(MouseEvent.CLICK,payMoneyOK);
		}
		
		public function payMoneyOK(event:MouseEvent):void{
			var type:String = '';
			if(payMoney.gold.selected == true){
				type = 'gold';
			}else{
				type = 'coupon';
			}
			RemoteService.instance.reliveOnUsingGold(collection.playerId,type,2).addHandlers(onRelive);
			PopUpManager.removePopUp(payMoney);
		}
		
		public function onRelive(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				MySelf.instance.coin = event.result['data']['coin'];
				MySelf.instance.coupon = event.result['data']['coupon'];
				MySelf.instance.gold = event.result['data']['gold'];
				MySelf.instance.hp = event.result['data']['hp'];
				MySelf.instance.mp = event.result['data']['mp'];
				MySelf.instance.status = event.result['data']['status'];
				Application.application.baseAvatar.update();
				if(event.result['data']['type'] == 2){
					RemoteService.instance.enterPlace(collection.playerId,MySelf.instance.town).addHandlers( collection.setEnterPlace );
				}
				if(MySelf.instance.isNewPlayer == 1)
				{
					RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(Application.application.loadPlayerResult);
				}
			}else{
				var tip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = event.result['reason'];
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
			}
			closeDeath();
		}
		
		//关闭
		public function closeDeath():void{
			PopUpManager.removePopUp(this);
		}
	}
}