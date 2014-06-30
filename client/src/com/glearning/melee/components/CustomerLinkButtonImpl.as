package com.glearning.melee.components
{
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	
	import mx.controls.LinkButton;
	import mx.events.ToolTipEvent;

	public class CustomerLinkButtonImpl extends LinkButton
	{
		public function CustomerLinkButtonImpl()
		{
			super();
		}
		
		public  function createCustomToolTip(event:ToolTipEvent):void { 
  
             var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();  
             toolTip.cityInfo = event.target.data;                 
             toolTip.init(6);
             event.toolTip = toolTip; 
         } 
		
	}
}