package com.glearning.melee.components.prompts
{
	import com.glearning.melee.components.packages.PackageImpl;
	import com.glearning.melee.components.packages.PackageItemImpl;
	import com.glearning.melee.model.Package;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.events.DragEvent;
	public class SplitItemIpml extends  Canvas
	{
		[Bindable]
		public var splitNum:Object;
		
		public var num:TextInput;
		public var alertNum:Label;
		public function SplitItemIpml()
		{
			super();
		}
		
		public function splitFinish(packageInfo:Package,array:Array,event:DragEvent,type:String,obj:PackageImpl,child:PackageItemImpl):void
		{				
			var splitNum:int = int(num.text);
			if(splitNum !=0 )
			packageInfo.moveItem(array,event.dragInitiator['data'],type,event.dragSource.formats[0].toString(),splitNum,obj,child);
			
		}
		
		public function init():void
		{
			Application.application.focusManager.setFocus(num);
		}
	}
}