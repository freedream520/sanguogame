package com.glearning.melee.components.warehouseSystem
{
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	import com.glearning.melee.collections.collection;
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class DepositImpl extends Canvas
	{
		public var momey:TextInput;
		public var tip:Label;
		public function DepositImpl()
		{
			super();
		}
		
		//关闭
		public function close():void{
			PopUpManager.removePopUp(this);
		}
		
		//确定
		public function ok():void{
			var str:* = momey.text;
			if(isNaN(str) == false){
				if(uint(momey.text) > MySelf.instance.coin){
					tip.text ='存入的钱大于您本身现有的钱，请重新输入！';
				}else{
					RemoteService.instance.depositMoney(collection.playerId,momey.text,1).addHandlers( onResult );
				}	
			}else{
				tip.text ='请输入数字！';
			}
		}
		
		//回调
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				MySelf.instance.coin = event.result['coin'];
				MySelf.instance.deposit = event.result['deposit'];
				close();
			}else{
				tip.text = event.result['reason'];
			}
		}
	}
}