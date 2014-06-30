package com.glearning.melee.components.skill
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.newplayerquest.NpcGuideComponent;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.components.task.NpcTaskComponent;
	import com.glearning.melee.components.task.TalkTaskDetailComponent;
	import com.glearning.melee.model.SkillInfo;
	import com.glearning.melee.net.RemoteService;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.components.utils.AutoTip;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class SkillBaseInfo extends Canvas
	{
		public var currentSkill:VBox;
		public var currentSkillName:Label;
		public var skillObj:Object;
		public var lv20:LinkButton;
		public var lv38:LinkButton;
		public var npcTask:NpcTaskComponent;
		
		public function SkillBaseInfo()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,init);
		}
		
		public function init(event:FlexEvent):void
		{
			currentSkill.addEventListener(DragEvent.DRAG_DROP,dragDrop);
			currentSkill.addEventListener(DragEvent.DRAG_ENTER,dragEnter);
			RemoteService.instance.getSkillPanelInfo(collection.playerId).addHandlers(onGetEquipSkill);
		}
		
		public function onGetEquipSkill(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result['data'].equipedActiveSkill != null)
			{
			for(var i:int = 0 ;i<event.result['data'].learnedSkills.length;i++)
			{
				if(event.result['data'].learnedSkills[i].skillInfo.name == event.result['data'].equipedActiveSkill.name)
				skillObj = event.result['data'].learnedSkills[i];
			}
			}
			if(event.result['data'].equipedActiveSkill != null)
			{
					currentSkill.removeAllChildren();
		            var skillCurrent:CurrentSkillComponent = new CurrentSkillComponent();		   
		            currentSkill.addChild(skillCurrent);
		            skillCurrent.source = event.result['data'].equipedActiveSkill.icon;		          
		            currentSkillName.text = event.result['data'].equipedActiveSkill.name;
		            skillCurrent.data = skillObj;
			}
			if( event.result['data'].changeProfessionStageQuests.LV20!= null && event.result['data'].changeProfessionStageQuests.LV20.name != null)
			{
				lv20.label = event.result['data'].changeProfessionStageQuests.LV20.name;
				lv20.alpha = 0;
				if(event.result['data'].changeProfessionStageQuests.LV20.questRecordId != null)
					addEventHandler(lv20,event.result['data'].changeProfessionStageQuests.LV20.questRecordId,false);
				else
					addEventHandler(lv20,event.result['data'].changeProfessionStageQuests.LV20.id,true);
			}				
			if(event.result['data'].changeProfessionStageQuests.LV38 != null && event.result['data'].changeProfessionStageQuests.LV38.name != null)
			{
				lv38.label = event.result['data'].changeProfessionStageQuests.LV38.name;
				lv38.alpha = 0;
				if(event.result['data'].changeProfessionStageQuests.LV38.questRecordId != null)
					addEventHandler(lv38,event.result['data'].changeProfessionStageQuests.LV38.questRecordId,false);
				else
					addEventHandler(lv38,event.result['data'].changeProfessionStageQuests.LV38.id,true);
			}
			
		}
		
		public function addEventHandler(ui:UIComponent,id:int,flag:Boolean):void
		{
			ui.addEventListener(MouseEvent.CLICK,function():void
			{
				if(flag == true)
				RemoteService.instance.getRecievableQuestDetails(collection.playerId,id).addHandlers(onGetLvQuest);
				else
				RemoteService.instance.getQuestDetails(collection.playerId,id).addHandlers(onGetLvQuest);
			});
		}
		
		public function onGetLvQuest(event:ResultEvent,token:AsyncToken):void
		{
			npcTask = new NpcTaskComponent();
			PopUpManager.addPopUp(npcTask,Application.application.canvas1,true);
			PopUpManager.centerPopUp(npcTask);			
			npcTask.npcName.text = event.result['data'].providerInfo.name;
			npcTask.closeButton.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(npcTask);});
			var taskDetail:TalkTaskDetailComponent = new TalkTaskDetailComponent();
			npcTask.npcTalkTask.addChild(taskDetail);
			taskDetail.taskName.text = event.result['data'].name;
			switch(event.result['data'].type)
			    {
			    	case 1:taskDetail.taskType.text = "主线任务";break;
			    	case 2:taskDetail.taskType.text = "赏金任务";break;
			    	case 3:taskDetail.taskType.text = "支线任务";break;
			    	case 4:taskDetail.taskType.text = "转职任务";break;
			    }
		    taskDetail.description.text = event.result['data'].providerDialog;
		    var taskArray:Array;
		     if(event.result['data'].questType == 'receieval')
		    {
		      taskArray = event.result['data'].questgoals as Array;
		      npcTask.npcImage.source = (event.result['data'].providerInfo.image as String).replace("32","170");
		      taskDetail.accept.label = '接受';
		      addEventAcceptHandler( taskDetail.accept,event.result['data'].id as int);
		    }else
		    {
		      taskArray = event.result['data'].progressesDetails as Array;
		      taskDetail.accept.visible = false;
		      taskDetail.backForward.visible = false;
		    }
		   
		    for(var i:int = 0; i<taskArray.length;i++)
		    {
		    	 taskDetail.target.htmlText += (i+1)+'.前往';
		    	 var placeArray:Array = taskArray[i].parentPlaceList as Array;
		    	  if( taskArray[i].killCount != 0)
				  {
					  for(var j:int = 0 ;j<placeArray.length ; j++)
					  {
					  	if( j == (placeArray.length-1))
					  	{
					  		taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[j].toString()+'</font>';
					  		break;
					  	}
					  	taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[j].toString()+'</font>-'				  	
					  }
				   if(event.result['data'].questType == 'progressing' && (taskArray[i].killCount != taskArray[i].currentKillCount))
				    taskDetail.accept.visible = false;
				   taskDetail.target.htmlText += '杀死'+taskArray[i].killCount+'个<font color="">'+taskArray[i].npcInfo.name+'</font>\n'
				  }else if(taskArray[i].itemCount != 0)
				  {
				  	for(var k:int = 0 ;k<placeArray.length ; k++)
					  {
					  	if( k == (placeArray.length-1))
					  	{
					  		taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[k].toString()+'</font>';
					  		break;
					  	}
					  	taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[k].toString()+'</font>的'				  	
					  }
				   if(event.result['data'].questType == 'progressing' && (taskArray[i].itemCount != taskArray[i].currentCollectCount))
				    taskDetail.accept.visible = false;
				   taskDetail.target.htmlText += '收集'+taskArray[i].itemCount+'个<font color="">'+taskArray[i].itemName+'</font>\n'
				  }	else
				  {
				  	for(var m:int = 0 ;m<placeArray.length ; m++)
					  {
					  	if( m == (placeArray.length-1))
					  	{
					  		taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[m].toString()+'</font>';
					  		break;
					  	}
					  	taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[m].toString()+'</font>的'				  	
					  }
					 
					 	taskDetail.target.htmlText += '与'+'<font color="#009933">'+  taskArray[i].npcInfo.name+'</font>交谈\n';
					 	 if(event.result['data'].questType == 'progressing' && (taskArray[i].hasTalkedToNpc == 0))
				         taskDetail.accept.visible = false;					  
				  }		
		    }
		    taskDetail.target.htmlText += (i+1)+'.前往<font color = "#009933 ">'+event.result['data'].accepterInfo.placeName.toString()+'</font>向<font color="#ff0000">'+event.result['data'].accepterInfo.name.toString()+'</font>交付任务';
		    if(int(event.result['data'].coinBonus) != 0)
		    taskDetail.award.htmlText += '铜币:<font color="#ff0000">'+ event.result['data'].coinBonus+'</font>\n';
		    if(int(event.result['data'].expBonus) != 0)
		    taskDetail.award.htmlText += '经验:<font color="#ff0000">'+ event.result['data'].expBonus+'</font>\n';
		    if(event.result['data'].itemBonus != null)
		    taskDetail.award.htmlText += '装备:<font color="#ff0000">'+ event.result['data'].itemBonus.name+'</font>\n';
		    taskDetail.backForward.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(npcTask);});	
		}
	
	   public function addEventAcceptHandler(ui:UIComponent,id:int):void
		{
			ui.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.applyQuest(collection.playerId,id).addHandlers(onApplyQuest);});
		}
		
		public function onApplyQuest(event:ResultEvent,token:AsyncToken):void
		{
			var normalTip:NormalTipComponent = new NormalTipComponent();
			if(event.result.result == false)
			{
				
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.text = event.result.reason;				
			}else
			{
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.text = '任务接受成功';				
				Application.application.frashMiniTask();
				
			}
			normalTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normalTip);PopUpManager.removePopUp(npcTask);});
		}
		
		public function addEventCommitHandler(ui:UIComponent,id:int):void
		{
			ui.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.commitQuest(collection.playerId,id).addHandlers(onCommitQuest);});
		}
		
		public function onCommitQuest(event:ResultEvent,token:AsyncToken):void
		{
			
		}
		
		public function dragEnter(event:DragEvent):void{
			var dropTarget:VBox=event.currentTarget as VBox;
			
		    DragManager.acceptDragDrop(dropTarget);
		}
		
		public function dragDrop(event:DragEvent):void{
			RemoteService.instance.equipSkill(collection.playerId,SkillInfo.instance.id,SkillInfo.instance.skillType).addHandlers(onEquipSkill);
		    skillObj = event.dragSource.dataForFormat('skillData');
		}
		
		public function onEquipSkill(event:ResultEvent,token:AsyncToken):void
        {
        	if(event.result['result'] == true)
        	{
        		if(event.result['data'][1].type == 1)
	        	{   
	        	   	currentSkill.removeAllChildren();
		            var skillCurrent:CurrentSkillComponent = new CurrentSkillComponent();		   
		            currentSkill.addChild(skillCurrent);                
		            skillCurrent.source = SkillInfo.instance.skillIcon;
		            skillCurrent.data = skillObj;		          
		            currentSkillName.text = SkillInfo.instance.skillName;
		            RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
        	    }
        	    if(MySelf.instance.isNewPlayer == 1 && MySelf.instance.progress == 14)
        	    {
        	    	 AutoTip._destoryTip();
	        	     var npcGuide:NpcGuideComponent = new NpcGuideComponent();
	        	     npcGuide.type = 0;
	        	     npcGuide.finishGuide = '很好，你已经具备了基本的战斗能力了';
	        	     PopUpManager.addPopUp(npcGuide,Application.application.canvas1,true);
	        	     PopUpManager.centerPopUp(npcGuide);
	        	     npcGuide.finish.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);
						       PopUpManager.removePopUp(npcGuide);});
				     Application.application.frashMiniTask();
        	    }
        	   
        	}
        }
        
        //新手指导
		public function onNewPlayerQuestInfo(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.addReward(collection.playerId,event.result['data'][0][3],event.result['data'][0][5],event.result['data'][0][4]).addHandlers(onAddReward);
		    
		}
		
		
		public function onAddReward(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
			RemoteService.instance.changeQuestProgress(collection.playerId,MySelf.instance.progress+1).addHandlers(onChangeQuestProgress);
			MySelf.instance.progress = MySelf.instance.progress+1;
		}
		
		public function onChangeQuestProgress(event:ResultEvent,token:AsyncToken):void
		{
			Application.application.newPlayerQuestProgress(event.result.progress);
		}
        
        public function openSettings():void{
        	RemoteService.instance.getLearnedSkills(collection.playerId).addHandlers(onGetLearnedSkills);
        }
        
        private function onGetLearnedSkills(event:ResultEvent,token:AsyncToken):void{
        	if(event.result['result'] == true)
            {
              	var skillSettings:SkillSettingsComponent = new SkillSettingsComponent();
              	skillSettings.activeSkillData.push({label:'未选择',data:0});
              	for(var i:int=0;i<event.result['data'].length;i++)
              	{
              		if(event.result['data'][i]['skillInfo']['type'] == 1){
              			var skillStr:String = event.result['data'][i]['skillInfo']['name']+' LV.'+event.result['data'][i]['skillInfo']['level'];
	              		var skillId:int = event.result['data'][i]['skillInfo']['id'];
	              		skillSettings.activeSkillData.push({label:skillStr,data:skillId});
              		}
              		
              	}
	        	PopUpManager.addPopUp(skillSettings,Application.application.canvas1,true);
				PopUpManager.centerPopUp(skillSettings);
            }
        }
	}
}