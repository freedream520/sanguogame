package com.glearning.melee.components.Workout
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class WorkoutImpl extends Canvas
	{
		//初始修炼怪数量
		[Bindable]
		public var workoutNum:int = 12;
		
		//获得经验
		[Bindable]
		public var exp:int;
		
		//消耗铜币
		[Bindable]
		public var coin:int;
		
		//所用时间
		[Bindable]
		public var time:int;
		
		//消耗活力
		[Bindable]
		public var energy:int;
		
		public var expBonus:int;
		
		public var workout:TextInput;
		
		public var monsterName:String;
		
		public var monsterId:int;
		
		public var monsterCount:int = 12;
		
		public var monsterLevel:int;
		
		public var oneMonsterTiem:int = 3;
		
		public function WorkoutImpl()
		{
			super();
		}
		
		//关闭窗口
		public function close():void{
			PopUpManager.removePopUp(this);
		}
		
		//选择最大修炼数
		public function maxNum():void{
			if(MySelf.instance.energy >= 24){
				workoutNum = 24;
			}else{
				workoutNum = MySelf.instance.energy;
			}
			workout.text = workoutNum.toString();
			setWorkoutNum();
		}
		
		//修改修炼次数
		public function setWorkoutNum():void{
			var str:* = workout.text;
			if(isNaN(str)){
				workout.text = '';
				energy = 0;
				exp = 0;
				coin = 0;
				time = 1;
			}else{
				monsterCount = int(workout.text);
				if(monsterCount>24){
					workout.text = '24';
					monsterCount = int(workout.text);
				}
				energy = monsterCount;
				exp = expBonus * monsterCount;
				coin = int(Math.pow(monsterLevel,1.1)*9*(1+(monsterLevel/150)))*monsterCount
				time = monsterCount * oneMonsterTiem;
				
			}	
		}
		
		//开始修炼
		public function workoutStart():void{
			if(workout.text != ''){
				close();
				RemoteService.instance.pratice(collection.playerId,monsterId,expBonus,monsterCount,monsterLevel).addHandlers(onFightWithNpc);	
			}
		}
		
		public function onFightWithNpc(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == false){
				var tip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = event.result['reason'];
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
			}else{
				MySelf.instance.status = event.result['data']['status'];
				MySelf.instance.energy = MySelf.instance.energy - monsterCount;
				MySelf.instance.coin = MySelf.instance.coin - coin;
				var workoutOption:WorkoutOptionComponent = new WorkoutOptionComponent();
				workoutOption.expBonus = exp;
				workoutOption.monsterName = monsterName;
				workoutOption.totalCount = monsterCount;
				workoutOption.time = time*60;
				PopUpManager.addPopUp(workoutOption,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(workoutOption);
		        workoutOption.setTime();
			}
		}
		
		
		
		
	}
}