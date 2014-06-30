package com.glearning.melee.components
{
	import com.glearning.melee.components.peopleInformation.PeopleInformationComponent;
	
	import flash.events.MouseEvent;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.controls.LinkButton;
	
	public class ClickPlayerImpl extends LinkButton
	{
				
		public function ClickPlayerImpl() 
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_OVER,showUnderLine);
			this.addEventListener(MouseEvent.MOUSE_OUT,hideUnderLine);
			this.addEventListener(MouseEvent.CLICK,open);
		}
		
		public function showUnderLine(event:MouseEvent):void
		{
			this.setStyle('textDecoration','underline');
		}
		
		public function hideUnderLine(event:MouseEvent):void
		{
			this.setStyle('textDecoration','none');
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			this.label = value.nickname;
		}
		
		public function open(event:MouseEvent):void{
			var people:PeopleInformationComponent = new PeopleInformationComponent();
			people.peopleId = data.id;
			PopUpManager.addPopUp(people,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(people);
		}

	}
}