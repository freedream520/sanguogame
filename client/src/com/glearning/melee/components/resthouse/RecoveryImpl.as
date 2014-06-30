package com.glearning.melee.components.resthouse
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.PayMoneyComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class RecoveryImpl extends Canvas
	{
		public var sleeping:Label;
		public var sleep:Label;
		public var shallowSleep:Label;
		public var rest:Label;
		public var coin:Label;
		public var money:int = 0;
		public var payMoney:PayMoneyComponent;
		public var payType:String = '';
		public var payNum:int;
		
		public function RecoveryImpl()
		{
			super();
		}
		
		public function updata():void{
			if(MySelf.instance.level <= 10){
				coin.htmlText = '免费';
			}else{
				money = (MySelf.instance.level - 10)*40+480;
				coin.htmlText = '<font color="#ff0000">'+money+'</font>铜币';
			}
			rest.htmlText = '<font color="#ff0000">'+MySelf.instance.rest.toString()+'</font>次';
			shallowSleep.htmlText = '<font color="#ff0000">'+MySelf.instance.shallowSleep.toString()+'</font>次';
			sleep.htmlText = '<font color="#ff0000">'+MySelf.instance.sleep.toString()+'</font>次';
			sleeping.htmlText = '<font color="#ff0000">'+MySelf.instance.sleeping.toString()+'</font>次';
		}
		
		//恢复HP/MP
		public function setHpMp():void{
			if(MySelf.instance.hp == MySelf.instance.maxHp && MySelf.instance.mp == MySelf.instance.maxMp)
			{
				collection.errorEvent('您无需再进行补给了',null);
			}else
			{
				RemoteService.instance.restOperate(collection.playerId,'meal','coin',money).addHandlers(onRestOperate);
			}
			
		}
		
		//恢复活力
		public function setEnergy(idx:int,type:String):void{
			payType = type;
			payNum = idx;
			payMoney = new PayMoneyComponent();
			payMoney.amount = idx.toString();
			payMoney.description = '恢复活力吗？';
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
			RemoteService.instance.restOperate(collection.playerId,payType,type,payNum).addHandlers(onRestOperate);
			PopUpManager.removePopUp(payMoney);
		}
		
		public function onRestOperate(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				MySelf.instance.coin = event.result['data']['coin'];
				MySelf.instance.coupon = event.result['data']['coupon'];
				MySelf.instance.gold = event.result['data']['gold'];
				MySelf.instance.hp = event.result['data']['hp'];
				MySelf.instance.mp = event.result['data']['mp'];
				MySelf.instance.energy = event.result['data']['energy'];
				switch(event.result['data']['type']){
					case 'nap':
						MySelf.instance.rest = event.result['data']['count'];
						break;
					case 'lightSleep':
						MySelf.instance.shallowSleep = event.result['data']['count'];
						break;
					case 'peacefulSleep':
						MySelf.instance.sleep = event.result['data']['count'];				
						break;
					case 'spoor':
						MySelf.instance.sleeping = event.result['data']['count'];
						break;
					
				}
				updata();
				Application.application.baseAvatar.update(); 
			}else{
				collection.errorEvent(event.result['reason'],null);
				
			}
			
		}
		
	}
}