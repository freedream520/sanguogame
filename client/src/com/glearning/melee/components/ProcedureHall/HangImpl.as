package com.glearning.melee.components.ProcedureHall
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.components.utils.TimeUtil;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class HangImpl extends Canvas
	{
		public var training:LinkButton;
		public var trainingSet:LinkButton;
		public var entertainer:LinkButton;
		public var entertainerSet:LinkButton;
		public var countdown:Label;
		public var hangAlert:Label;
		public var timeUtil:TimeUtil;
		public var hangType:String;
		public var tip:NormalTipComponent;
		
		public function HangImpl()
		{
			super();
		}
		
		//打开训练或授艺
		public function start(type:String):void{
			if(MySelf.instance.isNewPlayer == 1)
			{
				collection.errorEvent('对不起，该功能不对新手状态开放',null);
			}else
			{
				var hangStart:HangStartComponent = new HangStartComponent();
				PopUpManager.addPopUp(hangStart,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(hangStart);
		        hangStart.currentState = type;
		        if(type == 'training'){
					hangStart.typeName.text = '训练';
				}else{
					hangStart.typeName.text = '授艺';
				}
			}
			
		}
		
		//打开训练或授艺设置
		public function openSet(type:String):void{
			hangType = type;
			if(type == 'training'){
				RemoteService.instance.lobbyOperatingSetting(collection.playerId,1).addHandlers(onLobbyOperatingSetting);
			}else{
				RemoteService.instance.lobbyOperatingSetting(collection.playerId,2).addHandlers(onLobbyOperatingSetting);
			}
		}
		
		public function onLobbyOperatingSetting(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				var hangOption:HangOptionComponent = new HangOptionComponent();
				PopUpManager.addPopUp(hangOption,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(hangOption);
		        hangOption.currentState = hangType;
		        hangOption.duration = event.result['data']['duration'];
		        hangOption.bonusCount = event.result['data']['bonusCount'];
		        hangOption.isDouble = event.result['data']['isDoubleBonus'];
		        hangOption.startTime =(event.result['data']['startTime'].monthUTC+1).toString()+'月'+event.result['data']['startTime'].dayUTC.toString()+'日 '+event.result['data']['startTime'].hoursUTC.toString()+':'+event.result['data']['startTime'].minutesUTC.toString();
		        hangOption.endTime =(event.result['data']['finishTime'].monthUTC+1).toString()+'月'+event.result['data']['finishTime'].dayUTC.toString()+'日 '+event.result['data']['finishTime'].hoursUTC.toString()+':'+event.result['data']['finishTime'].minutesUTC.toString();
		        hangOption.totalTime = event.result['data']['totalTime'];
		        if(hangOption.duration < 1){
		        	hangOption.totalString = '还不到1小时';
		        	if(hangType == 'training'){
		        		hangOption.typeName.text = '训练';
		        		hangOption.nowBonus = '无法获得任何经验';
		        	}else{
		        		hangOption.typeName.text = '授艺';
		        		hangOption.nowBonus = '无法获得任何授艺';
		        	}
		        }else{
		        	if(hangType == 'training'){
		        		var trainingExp:int = Math.pow((MySelf.instance.level+1)*33,1.15)*hangOption.duration;
		        		hangOption.nowBonus = '获得'+trainingExp.toString()+'经验';
		        	}else{
		        		hangOption.nowBonus = '获得授艺';
		        	}
		        	hangOption.totalString = '已经'+hangOption.totalTime.toString()+'小时';
		        }
		        hangOption.hideButton();
		        
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
		
		//隐藏按钮
		public function hideButton(button:UIComponent):void{
			button.visible = false;
			button.includeInLayout = false ;
		}
		
		//初始所有按钮
		public function initButton(button:UIComponent):void{
			button.visible = true;
			button.includeInLayout = true ;
		}
		
		public function init(idx:int = 0):void{
			switch(MySelf.instance.status){
				case '正常':
					initButton(training);
					initButton(entertainer);
					hideButton(entertainer);
					hideButton(trainingSet);
					hideButton(entertainerSet);
					hideButton(countdown);
					hideButton(hangAlert);
					break;
				case '训练中':
					initButton(trainingSet);
					initButton(countdown);
					initButton(hangAlert);
					hideButton(training);
					hideButton(entertainer);
					hideButton(entertainerSet);
					hangAlert.text = '你当前正在训练中，离训练结束还有：'
					timeUtil = new TimeUtil(idx);
					BindingUtils.bindProperty(countdown,"text",timeUtil,"time");
					timeUtil.startCount();
					break;
				case '授艺中':
					initButton(entertainerSet);
					initButton(countdown);
					initButton(hangAlert);
					hideButton(entertainer);
					hideButton(training);
					hideButton(trainingSet);
					hangAlert.text = '你当前正在授艺中，离授艺结束还有：'
					timeUtil = new TimeUtil(idx);
					BindingUtils.bindProperty(countdown,"text",timeUtil,"time");
					timeUtil.startCount();
					break;
			}
		}
		
	}
}