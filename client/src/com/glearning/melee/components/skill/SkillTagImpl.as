package com.glearning.melee.components.skill
{
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.events.ToolTipEvent;

	public class SkillTagImpl extends Canvas
	{
		public var skillId:int;	
		public var skillName:Label;
		public var skillPicture:Image;
		public var skillLevel:Label;	
		public function SkillTagImpl()
		{
			super();
		}
		
//		override public function set data(value:Object):void {
//			super.data = value;
//			skillPicture.source = value.skillInfo.icon;
//			skillLevel
//			
//		}
        public  function createCustomToolTip(event:ToolTipEvent):void { 
  
             var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();  
             toolTip.skill = event.target.data;             
             toolTip.init(2);
             event.toolTip = toolTip; 
         } 
			
	}
}