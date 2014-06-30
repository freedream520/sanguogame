package com.glearning.melee.components.utils
{
	import flash.geom.Point;
	
	import mx.controls.ToolTip;
	import mx.core.UIComponent;
	import mx.managers.ToolTipManager;
    
	public class AutoTip
	{
		public static var _tip:ToolTip;
		public static var _point:Point;
		public function AutoTip()
		{
		}
		
		  public static function _showTip($txt:String,ui:UIComponent,direct:String = 'errorTipAbove'):void
            {
                
                if(_tip == null)
                {
                	
                    _point = new Point(ui.x, ui.y);
                   
                    _point = ui.localToGlobal(_point);
                   
                    if(direct == 'errorTipBelow')
                    {
                    	 _tip = ToolTipManager.createToolTip(    $txt,
                                                             _point.x - ui.x, 
                                                             _point.y + ui.y+ui.height+20 ,
                                                             direct) as ToolTip;
                    }else
                    {
                    	 _tip = ToolTipManager.createToolTip(    $txt,
                                                             _point.x - ui.x, 
                                                             _point.y - ui.y-ui.height-20 ,
                                                             direct) as ToolTip;
                    }
                    
                                                             
                     _tip.styleName = 'testTip';
                }
            }
 
          public static function _controlTip(visible:Boolean):void
          {
          	if(_tip !=null)
          	{
          			if(visible == false)
		          	{
		          		ToolTipManager.currentToolTip.visible = false;
		          	}else
		          	{
		          		ToolTipManager.currentToolTip.visible = true;
		          	}
          	}
          
          	
          }
          
        
 
            public static function _destoryTip():void
            {
                if(_tip)
                {
                    ToolTipManager.destroyToolTip(_tip);
                }
                _tip = null;
            }

	}
}