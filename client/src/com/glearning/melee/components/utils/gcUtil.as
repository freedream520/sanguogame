package com.glearning.melee.components.utils
{
	import mx.core.Container;
	import mx.core.UIComponent;
	//对象销毁功能
	public class gcUtil
	{
		public function gcUtil()
		{
		}
		
		public static function destroyAllItem(container:Container):void
		{
			for(var i:int = 0; i<container.numChildren-1;i++)
			{				
				container.removeChildAt(0);	
				container.getChildAt(0) = null;			
			}
		}
		
		public static function destroyItem(ui:UIComponent,container:Container = this):void
		{			
			container.removeChild(ui);
			ui = null;
		}

	}
}