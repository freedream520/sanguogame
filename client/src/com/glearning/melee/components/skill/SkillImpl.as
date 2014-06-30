package com.glearning.melee.components.skill
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.SkillInfo;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;

	import mx.controls.Image;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class SkillImpl extends Canvas
	{
		public var learnSkill:LinkButton;
		public var useSkill:LinkButton;
		public var learningSkill:LinkButton;
		public var learnedSkill:LinkButton;
		public var allSkill:LinkButton;
		public var skillList:SkillListComponent;
		public var temp:LinkButton;
		public function SkillImpl()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,init);
		}
		
		public function init(event:FlexEvent):void
		{
			learnedSkill.styleName="tabClickButton";
			temp = learnedSkill;
			learnSkill.addEventListener(MouseEvent.CLICK,LearnSkill);
		    learningSkill.addEventListener(MouseEvent.CLICK,showLearnSkill);
		    learnedSkill.addEventListener(MouseEvent.CLICK,showLearnedSkill);
		    allSkill.addEventListener(MouseEvent.CLICK,showAllSkill);
			learnSkill.enabled = false;
			useSkill.addEventListener(MouseEvent.CLICK,useLearnedSkill);
		}
		
		public function LearnSkill(event:MouseEvent):void
		{			
			
			RemoteService.instance.learnSkill(collection.playerId,SkillInfo.instance.id).addHandlers(onLearnSkill);
		}
	
		public function onLearnSkill(event:ResultEvent,token:AsyncToken):void
		{			
			if(event.result['result'] == false)
			{
				var falseTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(falseTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(falseTip);
				falseTip.tipText.text = event.result['reason'].toString();
				falseTip.hideButton();
				falseTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(falseTip);});
			}		
			else
			{
				var successTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(successTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(successTip);
				successTip.tipText.text = '修炼技能成功';
				successTip.hideButton();
				successTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(successTip);});
				((this.parent as SkillPanelComponent).skillComp as SkillComponent).skillList.removeAllChildren();
				RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
				RemoteService.instance.getLearnableSkills(collection.playerId).addHandlers(onHandlerSkills);	
			}
		}
		
		 public function onLoadSkill(event:ResultEvent, token:AsyncToken):void
        {
        	SkillInfo.instance.skillCurrentArray = event.result['data']['learnableSkills'];        	   	
        }
        
        public function useLearnedSkill(event:MouseEvent):void
        {
        	
        	RemoteService.instance.equipSkill(collection.playerId,SkillInfo.instance.id,SkillInfo.instance.skillType).addHandlers(onEquipSkill);
        }
        
        public function onEquipSkill(event:ResultEvent,token:AsyncToken):void
        {
        	if(event.result['result'] == true)
        	{
        		if(event.result['data'][1].type == 1)
	        	{   
	        	    var skill:Image = new Image(); 
	        	    skill.source = SkillInfo.instance.skillIcon;
	        	    ((this.parent as SkillPanelComponent).skillBaseInfo as SkillBaseComponent).currentSkill.removeAllChildren();       	
	        	    ((this.parent as SkillPanelComponent).skillBaseInfo as SkillBaseComponent).currentSkill.addChild(skill);
		        	((this.parent as SkillPanelComponent).skillBaseInfo as SkillBaseComponent).currentSkillName.text = SkillInfo.instance.skillName;
        	    }
        	    else
        	    {
        	    	if(event.result['result'] == true)
        	   {
        	   	collection.errorEvent(event.result['data'][0],null);
        		
        		var array:Array = event.result['data'][1] as Array;
        		for(var i:int = 0;i<array.length;i++)
        		{
        			var img:Image = new Image();
        			img.source = array[i].icon;
        			img.width = 32;
        			img.height = 32;
        			img.x = 115;
        			img.y = i*32+10;
        			Application.application.mainAvatar._canvas.addChild(img);
        		}
        	}
        	    }
        	}
        }
        
        public function showLearnSkill(event:MouseEvent):void
        {
        	temp.styleName = "tabNoClickButton";
			learningSkill.styleName = "tabClickButton";
			temp = learningSkill;
        	RemoteService.instance.getLearnableSkills(collection.playerId).addHandlers(onHandlerSkills);
        	skillList.flag = false;
        	learnSkill.enabled = true;
        	useSkill.enabled = false;
        }
        

        
        public function showLearnedSkill(event:MouseEvent):void
        {
        	temp.styleName = "tabNoClickButton";
			learnedSkill.styleName = "tabClickButton";
			temp = learnedSkill;
        	RemoteService.instance.getLearnedSkills(collection.playerId).addHandlers(onHandlerSkills);
        	skillList.flag = true;
        	learnSkill.enabled = false;
        	useSkill.enabled = true;
        }
        

        
        public function showAllSkill(event:MouseEvent):void
        {
        	temp.styleName = "tabNoClickButton";
			allSkill.styleName = "tabClickButton";
			temp = allSkill;
        	RemoteService.instance.getAllSkills(collection.playerId).addHandlers(onHandlerSkills);
        	skillList.flag = false;
        	learnSkill.enabled = false;
        	useSkill.enabled = false;
        }
        
        public function onHandlerSkills(event:ResultEvent,token:AsyncToken):void
        {
        	if(event.result['result'] == false)
            {
            	var falseTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(falseTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(falseTip);
				falseTip.tipText.text = event.result['reason'].toString();
				falseTip.hideButton();
				falseTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(falseTip);});
            }
            else
            {
	            SkillInfo.instance.skillCurrentArray = event.result['data'] as Array;
	            skillList.init();
            }
        }
	}
}