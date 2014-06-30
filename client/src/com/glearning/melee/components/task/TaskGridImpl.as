package com.glearning.melee.components.task
{

	import mx.containers.Canvas;
	
	public class TaskGridImpl extends Canvas
	{
		public var array:Array = new Array();
		
		public function TaskGridImpl()
		{
			super();
		}
		
		public function addFrushImmediate():void
		{
			this.parentDocument.frushImmediate();			
		}
		
	}
}