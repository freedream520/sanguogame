//吕忠涛
package com.glearning.melee.components
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.Workout.WorkoutComponent;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.components.utils.AutoTip;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	public class MonsterItemImpl extends Canvas
	{
		[Bindable]
		public var monsterData:Object;		
		public var monsterName:Label;
		public var monsterIcon:Image;
		public var practice:Image;
		public var fight:Image;	
		public var type:int;	
		public var monsterDescription:NpcDescriptionComponent;
	
		public function MonsterItemImpl()
		{
			super();
		}

		
		public function init():void
		{
			if(MySelf.instance.isKilled == 0)
			{
				AutoTip._destoryTip();
			}
			if(MySelf.instance.isNewPlayer == 1 && Application.application.baseAvatar.txtStatus.label != '死亡' && Application.application.isFirst == true)
			{				
				practice.visible = false;
				if(MySelf.instance.progress == 11 && MySelf.instance.isKilled == 0 && monsterData.id == 5001)
				{
					
					AutoTip._showTip('点击此处发动攻击',fight);
					
				}else if(MySelf.instance.progress == 12 && MySelf.instance.isKilled == 0 && monsterData.id == 5008)
				{
					AutoTip._showTip('点击此处发动攻击',fight);
				}else if(MySelf.instance.progress == 13 && MySelf.instance.isKilled == 0 && monsterData.id == 5015)
				{
					AutoTip._showTip('点击此处发动攻击',fight);
				}
			}
			Application.application.isFirst = true;
		  
		}
		
		//修炼
		public function practices():void{
			if(MySelf.instance.isTeamMember == false || (MySelf.instance.isLeader == true && MySelf.instance.isTeamMember == true)){
			RemoteService.instance.getMonsterPracticeExp(collection.playerId,monsterData.id).addHandlers(onGetMonsterPracticeExp);	
		    }else
			{
				var normalTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.text = '您不是队长，无法带队修炼';
				normalTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normalTip);});
			}
		}
		
		//攻击
		public function attack():void{	
			if(AutoTip._tip != null)
			{
				AutoTip._destoryTip();
			}	
			if(MySelf.instance.progress == 11 && monsterData.id == 5001)
			{
				AutoTip._destoryTip();
			}else if(MySelf.instance.progress == 12 && monsterData.id == 5008)
			{
				AutoTip._destoryTip();
			}else if(MySelf.instance.progress == 13 && monsterData.id == 5015)
			{
				AutoTip._destoryTip();
			}	
			if(MySelf.instance.isTeamMember == false || (MySelf.instance.isLeader == true && MySelf.instance.isTeamMember == true)){
			  RemoteService.instance.fightWithNpc(collection.playerId,monsterData.id,type).addHandlers(collection.onBattle);		
			}else
			{
				var normalTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.text = '您不是队长，无法带队战斗';
				normalTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normalTip);});
			}
			
		}

		public function onGetMonsterPracticeExp(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				var workout:WorkoutComponent = new WorkoutComponent();
				workout.expBonus = event.result['data']['expBonus'];
				workout.monsterLevel = event.result['data']['monsterLevel'];
				workout.monsterName = monsterData.name;
				workout.monsterId = monsterData.id;
				PopUpManager.addPopUp(workout,Application.application.canvas1,true);
				PopUpManager.centerPopUp(workout);		
			}else{
				collection.errorEvent(event.result['reason'],event.result['data']);

			}
			
		}
		
		public function monsterInfo():void
		{
			var levelArray:Array = String(monsterData.levelGroup).split(';');
			monsterDescription = new NpcDescriptionComponent();			
			PopUpManager.addPopUp(monsterDescription,Application.application.canvas1,true);
			PopUpManager.centerPopUp(monsterDescription);
			monsterDescription.npcName.text = monsterData.name;
			monsterDescription.description.htmlText = monsterData.description+'\n';	
			if((MySelf.instance.level - levelArray[levelArray.length-1]) >3)
			{
				monsterDescription.description.htmlText += '等级范围:'+'<font color="#ADADAD">'+levelArray[levelArray.length-1]+'~'+levelArray[0]+'</font>';
			}else if(Math.abs(MySelf.instance.level - levelArray[levelArray.length-1]) <= 3)
			{
				monsterDescription.description.htmlText += '等级范围:'+'<font color="#FFD306">'+levelArray[levelArray.length-1]+'~'+levelArray[0]+'</font>';
			}else if( (levelArray[levelArray.length-1] - MySelf.instance.level) >3)
			{
				monsterDescription.description.htmlText += '等级范围:'+'<font color="#FF5151">'+levelArray[levelArray.length-1]+'~'+levelArray[0]+'</font>';
			}
			monsterDescription.npcImage.source = (monsterData.image as String).replace("32","170");
			monsterDescription.closeButton.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(monsterDescription)});
		}
	}
}