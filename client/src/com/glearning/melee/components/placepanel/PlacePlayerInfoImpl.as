package com.glearning.melee.components.placepanel
{
	
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.LinkButton;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class PlacePlayerInfoImpl extends Canvas
	{
		public var AllPlayerList:Array;
	    public var numArray:Array;
	    public var partPage:PartPageComponent;
	    public var playList:DataGrid;	  
	    public var flag:Boolean = false;
	    public var closeButton:LinkButton;
	    public var country:ComboBox;
	    public var other:ComboBox;
	    public var type:String;
		public function PlacePlayerInfoImpl()
		{
			super();			
		}
		
		public function init():void
		{
		   AllPlayerList = new Array();
		   numArray = new Array();
		   closeButton.addEventListener(MouseEvent.CLICK,closeList);
		   initList(1);
		}
		
		public function closeList(event:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
		}
		
		public function initList(page:int):void
		{			
			if(type == 'more'){
				RemoteService.instance.getPagePlayers(collection.playerId,page).addHandlers(onGetPagePlayers);
			}else{
				
			}
			
		}
		
		public function onGetPagePlayers(event:ResultEvent,token:AsyncToken):void
		{
			
			AllPlayerList = event.result['data'].playerList as Array;
			playList.dataProvider = AllPlayerList;
			if(flag == false)
			{
			for(var i:int =0;i<event.result['data'].page;i++)
			{
				numArray.push(i+1);
			}			
			partPage.numList = numArray;
			partPage.init();			
			}
			partPage.isFirstOrLast();
			flag = true;
		}
		
		public function filterCountry(event:Event):void
		{
			var txtCountry:String = country.value.toString();
			var countryArray:Array = new Array();
			for(var i:int =0 ;i<AllPlayerList.length;i++)
			{
				if(AllPlayerList[i].camp == txtCountry)
				  countryArray.push(AllPlayerList[i]);
			}
			playList.dataProvider = countryArray;
		}
		
		public function sortBy(event:Event):void
		{
			if(other.value == '声望排行')
			{
				AllPlayerList.sort(sortPopularityFunction);
				playList.dataProvider = AllPlayerList;
			}else if(other.value == '等级排行')
			{
				AllPlayerList.sort(sortLevelFunction);
				playList.dataProvider = AllPlayerList;
			}else{
				AllPlayerList.sort(sortGoodevilFunction);
				playList.dataProvider = AllPlayerList;
			}
		}
		
		public function sortPopularityFunction(a:Object,b:Object):int
		{
			var aNum:int = a.popularity;
			var bNum:int = b.popularity;
			if(aNum < bNum) {
             return 1;
		    } else if(aNum > bNum) {
		     return -1;
		    } else  {		        
		     return 0;
		    }

		}
		
	    public function sortLevelFunction(a:Object,b:Object):int
		{
			var aNum:int = a.level;
			var bNum:int = b.level;
			if(aNum < bNum) {
             return 1;
		    } else if(aNum > bNum) {
		     return -1;
		    } else  {		        
		     return 0;
		    }

		}
		
		 public function sortGoodevilFunction(a:Object,b:Object):int
		{
			var aNum:int = a.goodevil;
			var bNum:int = b.goodevil;
			if(aNum < bNum) {
             return 1;
		    } else if(aNum > bNum) {
		     return -1;
		    } else  {		        
		     return 0;
		    }

		}
		
		
		
	}
}