package com.glearning.melee.components.player
{
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	
	import mx.containers.Canvas;
	import mx.events.ToolTipEvent;
	
	public class PlayerAttackInfoImpl extends Canvas
	{
		public function PlayerAttackInfoImpl()
		{
			super();
		}
		
		public  function createCustomToolTip(event:ToolTipEvent):void { 
  
             var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();  
             toolTip.progressId = event.target.id;             
             toolTip.init(8);
             event.toolTip = toolTip; 
         } 

	}
}