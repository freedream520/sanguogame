package com.glearning.melee.components.Workout
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.components.prompts.PayMoneyComponent;
	import com.glearning.melee.components.utils.TimeUtil;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class WorkoutOptionImpl extends Canvas
	{	
		//怪物名字
		[Bindable]
		public var monsterName:String;
		
		//总次数
		[Bindable]
		public var totalCount:int;
		
		//总经验
		[Bindable]
		public var expBonus:int;
		
		public var time:int;
		
		public var timeDown:Label;
		
		public var timeUtil:TimeUtil;
		
		public var tip:NormalTipComponent;
		
		public var payMoney:PayMoneyComponent;
		
		public var payNum:int;
		
		public function WorkoutOptionImpl()
		{
			super();
		}
		
		//关闭
		public function close():void{
			timeUtil.timer.stop();
			PopUpManager.removePopUp(this);
		}
		
		public function setTime():void{
			timeUtil = new TimeUtil(time);
			BindingUtils.bindProperty(timeDown,"text",timeUtil,"time");
			timeUtil.startCount();
		}
		
		//中止修炼
		public function terminate():void{
			close();
			tip = new NormalTipComponent();
			PopUpManager.addPopUp(tip,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(tip);
	        tip.tipText.text = '中途中止训练您只能获得部分经验，确定要中止修炼吗？';
	        tip.accept.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function onClick(event:MouseEvent):void{
			PopUpManager.removePopUp(tip);
			RemoteService.instance.terminatePractice(collection.playerId).addHandlers(onTerminatePractice);
		}
		
		public function onTerminatePractice(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				MySelf.instance.status = event.result['data']['status'];
				//判断是否升级
//				if(event.result['data']['level'] > MySelf.instance.level){
//					RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(Application.application.loadPlayerResult );
//				}else{
//					MySelf.instance.exp = MySelf.instance.exp + event.result['data']['currentExp'];
//				}
				RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(Application.application.loadPlayerResult );
				tip = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.htmlText = '您在击败<font color="#ff0000">'+event.result['data']['currentCountHit']+'</font>个【'+event.result['data']['monsterName']+'】' + 
		        		'后中止了修炼，共获得<font color="#ff0000">'+event.result['data']['currentExp']+'</font>点经验值！\n【'+event.result['data']['monsterName']+'】' + 
		        		'掉落了战利品，请查收临时包裹栏！';
		        tip.accept.addEventListener(MouseEvent.CLICK,onClose);
		        
		        Application.application.frashMiniTask();//刷新快捷任务列表
			}else{
				tip = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = event.result['reason'];
		        tip.accept.addEventListener(MouseEvent.CLICK,onClose);
			}
		}
		
		public function onClose(e:MouseEvent):void{
			Application.application.baseAvatar.update();
			PopUpManager.removePopUp(tip);
		}
		
		
		//立即完成
		public function finish():void{
			close();
			payNum = Math.round(time/180);
			payMoney = new PayMoneyComponent();
			payMoney.amount = payNum.toString();
			payMoney.description = '立即完成修炼吗？';
			PopUpManager.addPopUp(payMoney,Application.application.canvas1,true);
			PopUpManager.centerPopUp(payMoney);
			payMoney.payMoneyOK.addEventListener(MouseEvent.CLICK,payMoneyOK);
		}
		
		public function payMoneyOK(e:MouseEvent):void{
			var type:String = '';
			if(payMoney.gold.selected == true){
				type = 'gold';
			}else{
				type = 'coupon';
			}
			RemoteService.instance.immediateFinishPractice(collection.playerId,type,payNum).addHandlers(onImmediateFinishPractice);
			PopUpManager.removePopUp(payMoney);
		}
		
		public function onImmediateFinishPractice(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				MySelf.instance.status = event.result['data']['status'];
				MySelf.instance.gold = event.result['data']['gold'];
				MySelf.instance.coupon = event.result['data']['coupon'];
				//判断是否升级
//				if(event.result['data']['level'] > MySelf.instance.level){
//					RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(Application.application.loadPlayerResult );
//				}else{
//					MySelf.instance.exp = MySelf.instance.exp + event.result['data']['totalExp'];
//				}
				RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(Application.application.loadPlayerResult );
				
				tip = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.htmlText ='你成功击败<font color="#ff0000">'+event.result['data']['countHit']+ '</font>个【'+event.result['data']['monsterName']+'】\n本次修炼共获得' + 
		        		'<font color="#ff0000">'+event.result['data']['totalExp']+'</font>点经验值以及战利品，请查收临时包裹栏！';
		        tip.accept.addEventListener(MouseEvent.CLICK,onClose);
		        
				Application.application.frashMiniTask();//刷新快捷任务列表
			}else{
				tip = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = event.result['reason'];
		        tip.accept.addEventListener(MouseEvent.CLICK,onClose);
			}
		}
	}
}