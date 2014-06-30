package com.glearning.melee.components.skill
{
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	
	import mx.controls.Image;
	import mx.events.ToolTipEvent;

	public class EffectOnHeaderImpl extends Image
	{
		public var timeCount:String;
		
		public function EffectOnHeaderImpl()
		{
			super();
		}
		
		public  function createCustomToolTip(event:ToolTipEvent):void { 
  
             var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();  
             toolTip.effect = event.target.data;   
             toolTip.timeString = event.target.timeCount;          
             toolTip.init(4);
             event.toolTip = toolTip; 
         } 
		
	}
}