package com.glearning.melee.components.skill
{
	import com.glearning.melee.model.SkillInfo;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Image;
	import mx.core.DragSource;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	public class SkillListImpl extends VBox
	{
		public var array:Array;
		public var flag:Boolean = true;
		public var temp:SkillTagComponent = new SkillTagComponent();
		public function SkillListImpl()
		{
			super();
			
		}
		
		public function init():void
		{
		    
			this.removeAllChildren();
			array = new Array();
			array = SkillInfo.instance.skillCurrentArray;						
			for(var i:int = 0 ; i<array.length; i++)
			{
				var skill:SkillTagComponent = new SkillTagComponent();						
				this.addChild(skill);
				skill.selectedState.data = array[i];
				skill.skillBorder.data = array[i];
				skill.skillPicture.data = array[i];
				switch(array[i].skillInfo.type)
				{
				 case 1:skill.skillBorder.setStyle('backgroundImage','images/sanGuo/redBorder.png');break;
				 case 2:skill.skillBorder.setStyle('backgroundImage','images/sanGuo/whiteBorder.png');break;
				 case 3:skill.skillBorder.setStyle('backgroundImage','images/sanGuo/blueBorder.png');break;
				}
				if(i == 0)
				{
					skill.setStyle("backgroundImage","images/sanGuo/skillpicstate.png");;
					temp = skill;
				}
				skill.skillId = array[i].skillInfo.id;
				skill.skillName.text = array[i].skillInfo.name;
				skill.skillLevel.text = array[i].skillInfo.level;
				skill.skillPicture.source = array[i].skillInfo.icon;		
				skill.skillBorder.addEventListener(MouseEvent.MOUSE_DOWN,dragIt);
				skill.skillBorder.addEventListener(MouseEvent.CLICK,clickSkill);
				skill.addEventListener(MouseEvent.ROLL_OVER,selectState);		
				skill.addEventListener(MouseEvent.ROLL_OUT,removeState);
				skill.addEventListener(MouseEvent.CLICK,clickSkill);		
			}
			if (array.length!=0){
			    SkillInfo.instance.id = array[0].skillInfo.id;
	     		SkillInfo.instance.skillDescription = array[0].skillInfo.description;
	     		SkillInfo.instance.skillLevel = array[0].skillInfo.level;
	     		SkillInfo.instance.skillIcon = array[0].skillInfo.icon;
	     		SkillInfo.instance.skillLevelRequire = array[0].skillInfo.levelRequire;
	     		SkillInfo.instance.skillMaxLevel = array[0].skillInfo.maxLevel;
	     		SkillInfo.instance.skillName = array[0].skillInfo.name;
	     		SkillInfo.instance.skillProfession = array[0].skillInfo.skillProfession;
	     		SkillInfo.instance.skillType = array[0].skillInfo.type;
	     		SkillInfo.instance.skillUseMp = array[0].skillInfo.useMp;	     
	     		SkillInfo.instance.skillWeapon = array[0].skillInfo.weapon;
	     		SkillInfo.instance.skillAddEffect = array[0].skillInfo.addEffect;
	     		SkillInfo.instance.skillAddEffectRate = array[0].skillInfo.addEffectRate;
	     		SkillInfo.instance.skillUseCoin = array[0].skillInfo.useCoin;
	     	    SkillInfo.instance.skillAttackDamage = array[0].effects[0];
	     	    SkillInfo.instance.skillRate = array[0].skillInfo.useRate;	
	  		}
		}
		
		public function clickSkill(event:MouseEvent):void
		{
			temp.setStyle("backgroundImage","");
			if(event.currentTarget is SkillTagComponent)
			{
			(event.currentTarget as SkillTagComponent).setStyle("backgroundImage","images/sanGuo/skillpicstate.png");
			temp = event.currentTarget as SkillTagComponent;	
			}			
			else
			{
			(event.currentTarget.parent as SkillTagComponent).setStyle("backgroundImage","images/sanGuo/skillpicstate.png");
			temp = event.currentTarget.parent as SkillTagComponent;	
			}
			
			
		}
		
		public function selectState(event:MouseEvent):void
		{
			(event.currentTarget as SkillTagComponent).selectedState.visible = true;
		}
		
		public function removeState(event:MouseEvent):void
		{
			(event.currentTarget as SkillTagComponent).selectedState.visible = false;
		}
		
		private function dragIt(event:MouseEvent):void{
		
        //CurrentTarget指定要实现拖拽事件的初始化目标
        var dragInitiator:Canvas=event.currentTarget as Canvas;
        SkillInfo.instance.skillIcon = (dragInitiator.parent as SkillTagComponent).skillPicture.getStyle("backgroundImage");
        getSkillInfo(event.currentTarget.data.skillInfo.id); 
        temp.setStyle("backgroundImage","");
        (event.currentTarget.parent as SkillTagComponent).setStyle("backgroundImage","images/sanGuo/skillpicstate.png");
		temp = event.currentTarget.parent as SkillTagComponent;	    
        var dragSource:DragSource=new DragSource();
        dragSource.addData(dragInitiator,'skill');   
        dragSource.addData( (dragInitiator.parent as SkillTagComponent).selectedState.data,'skillData');
        //创建一个拖拽对象的代理作为拷贝
        var dragProxy:Image=new Image();    
        dragProxy.source = (dragInitiator.parent as SkillTagComponent).skillPicture.source;
        dragProxy.width = 32;
		dragProxy.height = 32;
        if(flag == true)
        DragManager.doDrag(dragInitiator,dragSource,event,dragProxy);

      } 		
	
		
	  public function getSkillInfo(id:int):void
	  {
	     for(var i:int = 0; i< array.length ; i++)
	     {
	     	if(array[i].skillInfo.id == id)
	     	{
	     		SkillInfo.instance.id = array[i].skillInfo.id;
	     		SkillInfo.instance.skillDescription = array[i].skillInfo.description;
	     		SkillInfo.instance.skillLevel = array[i].skillInfo.level;
	     		SkillInfo.instance.skillIcon = array[i].skillInfo.icon;
	     		SkillInfo.instance.skillLevelRequire = array[i].skillInfo.levelRequire;
	     		SkillInfo.instance.skillMaxLevel = array[i].skillInfo.maxLevel;
	     		SkillInfo.instance.skillName = array[i].skillInfo.name;
	     		SkillInfo.instance.skillProfession = array[i].skillInfo.skillProfession;
	     		SkillInfo.instance.skillType = array[i].skillInfo.type;
	     		SkillInfo.instance.skillUseMp = array[i].skillInfo.useMp;	     
	     		SkillInfo.instance.skillWeapon = array[i].skillInfo.weapon;
	     		SkillInfo.instance.skillAddEffect = array[i].skillInfo.addEffectNames[0];
	     		SkillInfo.instance.skillAddEffectRate = array[i].skillInfo.addEffectRate;
	     		SkillInfo.instance.skillUseCoin = array[i].skillInfo.useCoin;
	     	    SkillInfo.instance.skillAttackDamage = array[i].effects[0];
	     	    SkillInfo.instance.skillRate = array[i].skillInfo.useRate;     	    
	     	    break;
	     	}
	     }
	  }	
	}
}