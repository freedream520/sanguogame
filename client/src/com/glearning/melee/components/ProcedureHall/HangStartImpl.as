package com.glearning.melee.components.ProcedureHall
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;

	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;


	public class HangStartImpl extends Canvas
	{
		public var typeName:Label;
		public var trainingTime:ComboBox;
		[Bindable]
		public var trainingCoin:int;
		[Bindable]
		public var trainingExp:int;
		public var tip:NormalTipComponent;
		public var hangTime:int;
		public var type:String;
		[Bindable]
		public var entertainerCoin:int;
		
		public function HangStartImpl()
		{
			super();

		}
		
		public function close():void{
			PopUpManager.removePopUp(this);
		}
			
		//训练时间
		public function onTrainingTime():void{
			hangTime = trainingTime.selectedIndex + 1;
			trainingCoin = Math.pow((MySelf.instance.level+1)*44,1.15)*hangTime;
			trainingExp = Math.pow((MySelf.instance.level+1)*33,1.15)*hangTime;
		}
		
		//授艺时间
		public function onEntertainerTime():void{
			hangTime = trainingTime.selectedIndex + 1;
			entertainerCoin = Math.pow((MySelf.instance.level+1)*44,1.15)*hangTime;
		}
		
		//训练或授艺 确认提示框
		public function open(str:String):void{
			close();
			type = str;
			tip = new NormalTipComponent();
			PopUpManager.addPopUp(tip,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(tip);
	        tip.tipText.text = '确定要开始'+hangTime.toString()+'小时的'+str+'吗？';
	        tip.accept.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function onClick(e:MouseEvent):void{
			if(type == '训练'){
				RemoteService.instance.lobbyOperate(collection.playerId,1,hangTime).addHandlers(onLobbyOperate);
			}else{
				RemoteService.instance.lobbyOperate(collection.playerId,2,hangTime).addHandlers(onLobbyOperate);
			}
			PopUpManager.removePopUp(tip);
		}
		
		public function onLobbyOperate(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				var seconds:int = event.result['data']['duration'] * 3600;
				MySelf.instance.status = event.result['data']['status'];
				Application.application.procedureHall.hang.init(seconds);
				var hangOption:HangOptionComponent = new HangOptionComponent();
				PopUpManager.addPopUp(hangOption,Application.application.canvas1,true);
				PopUpManager.centerPopUp(hangOption);
				hangOption.typeName.text = type;
		        if(type == '训练'){
				 	hangOption.currentState = 'training';
				 	hangOption.nowBonus = '无法获得任何经验';
				}else{
					 hangOption.currentState = 'entertainer';
					 hangOption.nowBonus = '无法获得任何授艺';
				}
		        hangOption.duration = event.result['data']['duration'];
		        hangOption.bonusCount = event.result['data']['bonusCount'];
		        hangOption.startTime =(event.result['data']['startTime'].monthUTC+1).toString()+'月'+event.result['data']['startTime'].dayUTC.toString()+'日 '+event.result['data']['startTime'].hoursUTC.toString()+':'+event.result['data']['startTime'].minutesUTC.toString();
		        hangOption.endTime =(event.result['data']['finishTime'].monthUTC+1).toString()+'月'+event.result['data']['finishTime'].dayUTC.toString()+'日 '+event.result['data']['finishTime'].hoursUTC.toString()+':'+event.result['data']['finishTime'].minutesUTC.toString();
		        hangOption.totalTime = hangTime;
		        hangOption.totalString = '还不到1小时';
//		        }else{
//		        	hangOption.totalString = '已经'+hangOption.totalTime.toString()+'小时';
//		        }
			}else{
				tip = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = event.result['reason'];
		        tip.accept.addEventListener(MouseEvent.CLICK,onClicks);
			}	
		}
		
		//关闭Tip 窗口
		public function onClicks(e:MouseEvent):void{
			PopUpManager.removePopUp(tip);
		}
	}
}