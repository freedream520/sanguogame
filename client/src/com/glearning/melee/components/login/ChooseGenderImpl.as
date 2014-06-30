package com.glearning.melee.components.login
{
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.ViewStack;
	import mx.controls.LinkButton;
	import mx.controls.RadioButton;

	public class ChooseGenderImpl extends Canvas
	{
		public var maleRadio:RadioButton;
		public var femaleRadio:RadioButton;
		public var male:ViewStack;
		public var female:ViewStack;
		public var enterGame:LinkButton;
		public var username:String = new String();
		public var password:String = new String();
		public var m1:HBox;
		public var f1:HBox;
		public function ChooseGenderImpl()
		{
			super();
		}
		
		public function init():void
		{
			femaleRadio.addEventListener(MouseEvent.CLICK,chooseFemale);
			maleRadio.addEventListener(MouseEvent.CLICK,chooseMale);
			m1.addEventListener(MouseEvent.CLICK,chooseMale);
			f1.addEventListener(MouseEvent.CLICK,chooseFemale);
		}
		
		public function chooseFemale(event:MouseEvent):void
		{
				maleRadio.selected = false;
				male.selectedIndex = 0;
				femaleRadio.selected = true;
				female.selectedIndex = 1;		
		}
		
		public function chooseMale(event:MouseEvent):void
		{
			    maleRadio.selected = true;
			    femaleRadio.selected = false;
				female.selectedIndex = 0;
				male.selectedIndex = 1;
		}
		
		
		
	}
}