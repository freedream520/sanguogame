package com.glearning.melee.components.placepanel
{
	import com.glearning.melee.components.player.PersonalTopComponent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.ComboBox;
	import mx.controls.LinkButton;

	public class PartPageImpl extends HBox
	{
		public var numList:Array;
		public var lastPage:LinkButton;
		public var nextPage:LinkButton;
		public var firstPage:LinkButton;
		public var finalPage:LinkButton;
		public var pageNum:ComboBox;
		public var property:String;
		public function PartPageImpl()
		{
			super();
		}
		
		public function init():void
		{			
			pageNum.dataProvider = numList;
			isFirstOrLast();
		}
		
		public function isFirstOrLast():void
		{
			switch(pageNum.value)
			{
				case 1:
				       lastPage.enabled = false;
		               firstPage.enabled = false;
		               if(numList.length == 1)
		               {
		               	nextPage.enabled = false;
		               	finalPage.enabled = false;
		               }else
		               {
		               	nextPage.enabled = true;
		               	finalPage.enabled = true;
		               }
		               break;
		        case numList.length:
		              nextPage.enabled = false;
		              finalPage.enabled = false; 
		              lastPage.enabled = true;
		              firstPage.enabled = true;
		              break;
		        default:
		              nextPage.enabled = true;
		              finalPage.enabled = true; 
		              lastPage.enabled = true;
		              firstPage.enabled = true;
		              break;
			}	
		}
		
		public function getNewPlayerList(event:Event):void
		{
			if(parent is PlacePlayerInfoComponent)
			{
				(parent as PlacePlayerInfoComponent).initList(pageNum.value as int);
				isFirstOrLast();
			}    
		    else if(parent.parent.parent is PersonalTopComponent)
		    {
		    	var personTop:PersonalTopComponent = parent.parent.parent as PersonalTopComponent;
		    	personTop.initList(pageNum.value as int,property,personTop.countryFilter.selectedIndex,personTop.professionFilter.selectedIndex);
		    	isFirstOrLast();
		    }
		        
			
		}
		
		public function goToFirstPage(event:MouseEvent):void
		{
			if(parent is PlacePlayerInfoComponent)
			{
				(parent as PlacePlayerInfoComponent).initList(1);
				 pageNum.selectedIndex = 0;
				 isFirstOrLast();
			}else if(parent.parent.parent is PersonalTopComponent)
			{
				var personTop:PersonalTopComponent = parent.parent.parent as PersonalTopComponent;
				personTop.initList(1,property,personTop.countryFilter.selectedIndex,personTop.professionFilter.selectedIndex);
				pageNum.selectedIndex = 0;
			    isFirstOrLast();
			}
			
		}
		
		public function goToFinalPage(event:MouseEvent):void
		{
			if(parent is PlacePlayerInfoComponent)
			{
				(parent as PlacePlayerInfoComponent).initList(numList.length);
				 pageNum.selectedIndex = numList.length+1;
				 isFirstOrLast();
			}else if(parent.parent.parent is PersonalTopComponent)
			{
				var personTop:PersonalTopComponent = parent.parent.parent as PersonalTopComponent;
				personTop.initList(numList.length,property,personTop.countryFilter.selectedIndex,personTop.professionFilter.selectedIndex);
				 pageNum.selectedIndex = numList.length+1;
				 isFirstOrLast();
			}
			
		}
		
		public function goToLastPage(event:MouseEvent):void
		{
			if(parent is PlacePlayerInfoComponent)
			{
				(parent as PlacePlayerInfoComponent).initList((pageNum.value as int) - 1);
				pageNum.selectedIndex = (pageNum.value as int)-2;
				 isFirstOrLast();
			}else if(parent.parent.parent is PersonalTopComponent)
			{
				var personTop:PersonalTopComponent = parent.parent.parent as PersonalTopComponent;
				personTop.initList((pageNum.value as int) - 1,property,personTop.countryFilter.selectedIndex,personTop.professionFilter.selectedIndex);
				pageNum.selectedIndex = (pageNum.value as int)-2;
				 isFirstOrLast();
			}
			
		}
		
		public function goToNextPage(event:MouseEvent):void
		{
			if(parent is PlacePlayerInfoComponent)
			{
				(parent as PlacePlayerInfoComponent).initList((pageNum.value as int) + 1);
				pageNum.selectedIndex = (pageNum.value as int);
				isFirstOrLast();
			}else if(parent.parent.parent is PersonalTopComponent)
			{
				var personTop:PersonalTopComponent = parent.parent.parent as PersonalTopComponent;
				personTop.initList((pageNum.value as int) + 1,property,personTop.countryFilter.selectedIndex,personTop.professionFilter.selectedIndex);
				pageNum.selectedIndex = (pageNum.value as int);
				isFirstOrLast();
			}
			
		}
		
	}
}