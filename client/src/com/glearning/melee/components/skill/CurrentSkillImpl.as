package com.glearning.melee.components.skill
{
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	
	import mx.controls.Image;
	import mx.events.ToolTipEvent;
	public class CurrentSkillImpl extends Image
	{
		public function CurrentSkillImpl()
		{
			super();
		}
		
		public  function createCustomToolTip(event:ToolTipEvent):void { 
  
             var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();            
             toolTip.skill = event.target.data;             
             toolTip.init(2);
             event.toolTip = toolTip; 
         } 
		
	}
}