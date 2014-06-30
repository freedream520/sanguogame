package com.glearning.melee.components.player
{
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.effects.Zoom;

	public class MyEffectButtonImpl extends Canvas
	{
		public var zoomAll:Zoom;
		public var image:Image;
		public function doZoom(event:MouseEvent):void {
    		 	zoomAll.target = image;              
                image.visible = true; 
                zoomAll.end();                                        
                zoomAll.play();
                image.visible = false;
                
            }
		
		public function MyEffectButtonImpl()
		{
			super();
		}
		
	}
}