package com.glearning.melee.components.ProcedureHall
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.components.prompts.PayMoneyComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class HangOptionImpl extends Canvas
	{
		public var typeName:Label;
		public var type:String;
		//是否双倍
		[Bindable]
		public var isDouble:Boolean = false;
		
		///总时间
		[Bindable]
		public var totalTime:int;
		
		//进过时间描述
		[Bindable]
		public var totalString:String;
		
		///进过时间
		
		public var duration:int;
		
		//开始时间
		[Bindable]
		public var startTime:String;
		
		//结束时间
		[Bindable]
		public var endTime:String;
		
		//总数量
		[Bindable]
		public var bonusCount:int;
		
		//目前获得数量
		[Bindable]
		public var nowBonus:String;
		
		public var payMoney:PayMoneyComponent;
		public var tip:NormalTipComponent;
		public var trainingDouble:LinkButton;
		public var entertainerDouble:LinkButton;
		
		public function HangOptionImpl()
		{
			super();
		}
		
		//关闭
		public function close():void{
			PopUpManager.removePopUp(this);
		}
		
		//隐藏双倍按钮 
		public function hideButton():void{
			if(MySelf.instance.status == '训练中'){
				if(isDouble){
					trainingDouble.visible = false;
					trainingDouble.includeInLayout = false ;
				}	
			}else{
				if(isDouble){
					entertainerDouble.visible = false;
					entertainerDouble.includeInLayout = false ;
				}	
			}
			
		}
		
		//双倍
		public function double(str:String):void{
			type = str;
			payMoney = new PayMoneyComponent();
			payMoney.amount = totalTime.toString();
			if(str == '训练'){
				payMoney.description = '加倍获得经验吗？';
			}else{
				payMoney.description = '加倍获得薪酬吗？';
			}
			PopUpManager.addPopUp(payMoney,Application.application.canvas1,true);
			PopUpManager.centerPopUp(payMoney);
			payMoney.payMoneyOK.addEventListener(MouseEvent.CLICK,payMoneyOK);
			close();		
		}
		
		public function payMoneyOK(e:MouseEvent):void{
			var payType:String = '';
			if(payMoney.gold.selected == true){
				payType = 'gold';
			}else{
				payType = 'coupon';
			}
			if(type == '训练'){
				RemoteService.instance.lobbyDoubleBonus(collection.playerId,1,payType,totalTime).addHandlers(onLobbyDoubleBonus);
			}else{
				RemoteService.instance.lobbyDoubleBonus(collection.playerId,2,payType,totalTime).addHandlers(onLobbyDoubleBonus);
			}
			PopUpManager.removePopUp(payMoney);
		}
		
		public function onLobbyDoubleBonus(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				tip = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        if(type =='训练'){
		        	tip.tipText.text = '恭喜，您的经验已加倍，训练结束后你将获得'+event.result['data']['bonus']+'点经验！';
		        }else{
		        	tip.tipText.text = '恭喜，您的薪酬已加倍，授艺结束后你将获得'+event.result['data']['bonus']+'铜币！';
		        }
		        MySelf.instance.gold = event.result['data']['gold'];
		        MySelf.instance.coupon = event.result['data']['coupon'];
		        tip.accept.addEventListener(MouseEvent.CLICK,onClick);
			}else{
				tip = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = event.result['reason'];
		        tip.accept.addEventListener(MouseEvent.CLICK,onClick);
			}
		}
		
		//中止
		public function over(str:String):void{
			type = str;
			tip = new NormalTipComponent();
			PopUpManager.addPopUp(tip,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(tip);
	        var reason:String = ''
	        if(duration < 1){
	        	if(type == '训练'){
	        		reason = '无法获得任何经验！';
	        	}else{
	        		reason = '无法获得任何薪酬！';
	        	}
	        }else{
	        	if(type == '训练'){
	        		var exp:int = Math.pow((MySelf.instance.level+1)*33,1.15)*duration;
	        		reason = '获得'+exp.toString()+'点经验！';
	        	}else{
	        		reason = '获得铜币！';
	        	}
	        }
	        tip.tipText.text = '确定要中止'+type+'吗？您将'+reason;
	        tip.accept.addEventListener(MouseEvent.CLICK,onOver);
	        close();
		}
		
		public function onOver(e:MouseEvent):void{
			if(type == '训练'){
				RemoteService.instance.terminateLobbyOperation(collection.playerId,1).addHandlers(onTerminateLobbyOperation);
			}else{
				RemoteService.instance.terminateLobbyOperation(collection.playerId,2).addHandlers(onTerminateLobbyOperation);
			}
			PopUpManager.removePopUp(tip);
		}
		
		public function onTerminateLobbyOperation(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				tip = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        var reason:String = ''
		        if(type == '训练'){
		        	reason = '点经验！'
		        	MySelf.instance.exp = MySelf.instance.exp + event.result['data']['bonus'];
		        }else{
		        	MySelf.instance.coin = MySelf.instance.coin + event.result['data']['bonus'];
		        	reason = '铜币！'
		        }
		        MySelf.instance.status = '正常';
		        Application.application.procedureHall.hang.init();
		        tip.tipText.text = type+'已经成功中止！您获得了'+event.result['data']['bonus'].toString()+reason;
		        tip.accept.addEventListener(MouseEvent.CLICK,onClick);
			}else{
				tip = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = event.result['reason'];
		        tip.accept.addEventListener(MouseEvent.CLICK,onClick);
			}
		}
		
		//关闭Tip 窗口
		public function onClick(e:MouseEvent):void{
			PopUpManager.removePopUp(tip);
		}
		
	}
}