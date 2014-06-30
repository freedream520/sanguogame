package com.glearning.melee.components.task
{
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	
	import mx.containers.VBox;
	import mx.events.ToolTipEvent;

	public class TalkTaskDetailImpl extends VBox
	{
		public function TalkTaskDetailImpl()
		{
			super();
		}
		
		public  function createCustomToolTip(event:ToolTipEvent):void {
			if(event.target.data != null){
				var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();              
	             toolTip.packageItem = event.target.data;             
	             toolTip.init(1);
	             event.toolTip = toolTip; 
			} 
             
         } 
	}
}