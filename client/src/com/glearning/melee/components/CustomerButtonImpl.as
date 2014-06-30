package com.glearning.melee.components
{	
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import mx.controls.LinkButton;
	import mx.controls.ToolTip;
	import mx.effects.Glow;
	import mx.events.ToolTipEvent;
	import mx.managers.ToolTipManager; 
           
	public class CustomerButtonImpl extends LinkButton
	{				
		public var glowImage:Glow;
		public var unglowImage:Glow;		
	    public var flag:Boolean;
	    private var _tip:ToolTip;
		public function CustomerButtonImpl()
		{
			super();
		}
		
			
		public function glowEffect():void
		{
			glowImage.end();
			glowImage.target = this;
			glowImage.play();
		}
		
		public function unGlowEffect():void
		{
			unglowImage.end();
			unglowImage.target = this;
			unglowImage.play();
		}
		
	    public function glowUp():void
		{
			glowEffect();
			setTimeout(glowDown,1000);			
		}
		
		public function glowDown():void
		{
			unGlowEffect();
			setTimeout(isAgain,1000);			
		}
		
		public function isAgain():void
		{
			if(flag)
			glowUp();
		}
		
		public function startEffect():void
		{		
			flag = true;		
			glowUp();		
		}
		
		public function endEffect():void
		{
			flag = false;
		}
		
		public  function createCustomToolTip(event:ToolTipEvent):void {            
            	var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();  
	            toolTip.cityInfo = event.target.data;                 
	            toolTip.init(6);
	            event.toolTip = toolTip;           
         } 
         
         public function _showTip($txt:String):void
            {
                trace(_tip);
                if(_tip == null)
                {
                    var __point:Point = new Point(this.x, this.y);
                    trace(__point)
                    __point = this.localToGlobal(__point);
                    trace(__point);
                     _tip = ToolTipManager.createToolTip(    $txt,
                                                             __point.x - this.x, 
                                                             __point.y - this.y-this.height-10 ,
                                                             'errorTipAbove') as ToolTip;
                     _tip.styleName = 'testTip';
                }
            }
 
            public function _destoryTip():void
            {
                if(_tip)
                {
                    ToolTipManager.destroyToolTip(_tip);
                }
                _tip = null;
            }
		
	}
}