package com.glearning.melee.components.player
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.placepanel.PartPageComponent;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class PersonalTopImpl extends Canvas
	{
		public var playerList:Array;
		public var pageArray:Array;
		public var page:int;
		public var allPlayer:DataGrid;
		public var partPageComponent:PartPageComponent;
		public var tb1:Button;
		public var tb2:Button;
		public var tb3:Button;
		public var tb4:Button;
		public var tb5:Button;
		public var tb6:Button;
		public var tb7:Button;
		public var tb8:Button;
		public var flag:Boolean = false;
		public var pro:String;
		public var countryFilter:ComboBox;
		public var professionFilter:ComboBox;
		public function PersonalTopImpl()
		{
			super();
		}
		
		public function init():void
		{
			playerList = new Array();
			pageArray = new Array();
			initList(1,'coin',0,0);
			pro = 'coin';
		}
		
		public function initList(num:int,property:String,camp:int,profession:int):void
		{
			RemoteService.instance.listAllPlayerInfo(num,property,camp,profession).addHandlers(onGetAllPlayerInfo);
			
		}
		
		public function onGetAllPlayerInfo(event:ResultEvent,token:AsyncToken):void
		{
			playerList.splice(0);
			playerList = event.result['data'].playerList as Array;			
			page = event.result['data'].page;
			for(var n:int = 0 ;n<playerList.length ; n++)
			{
				if(playerList[n].id == collection.playerId)
				  allPlayer.selectedIndex = n;
			}
			if(flag == false)
			{
				pageArray.splice(0);
				for(var i:int = 0 ;i<page;i++)
				{
					pageArray.push(i+1);
				}
								
					initCombobox(pageArray,pro);
			}
			if(event.result['data'].currentPage != null)
			{
			   partPageComponent.pageNum.selectedIndex = event.result['data'].currentPage-1;
			   partPageComponent.isFirstOrLast();
			}
			flag = true;			
			allPlayer.dataProvider = playerList;
		}
		
		public function initCombobox(array:Array,property:String):void
		{			
			partPageComponent.numList = array;
			partPageComponent.property = property;			
			partPageComponent.init();
			partPageComponent.isFirstOrLast();
		}
		
	    public function lfRowNum(item:Object,column:DataGridColumn):String
		{
		  var pageNum:int =	int(partPageComponent.pageNum.value);
		  for(var j:int = 0 ;j<playerList.length;j++)
		  {
		  	if(playerList[j].nickname == item.nickname)
		  	 return String(j+1+(pageNum-1)*10);
		  }
		   return null;
		}
		
		public function showMyPosition(event:MouseEvent):void
		{
			RemoteService.instance.listAllPlayerInfo(1,pro,countryFilter.selectedIndex,professionFilter.selectedIndex,collection.playerId).addHandlers(onGetAllPlayerInfo);
		}	
		
		
		public function reSortByPopularity(event:MouseEvent):void
		{
//			flag = false;
//			initList(1,'popularity');
			toggleButtonEffect(1);
		}
		
		public function reSortByLevel(event:MouseEvent):void
		{
			flag = false;
			initList(1,'level',countryFilter.selectedIndex,professionFilter.selectedIndex);
			toggleButtonEffect(2);
			pro = 'level';
		}
		
		public function reSortByCoin(event:MouseEvent):void
		{
			flag = false;
			initList(1,'coin',countryFilter.selectedIndex,professionFilter.selectedIndex);
			toggleButtonEffect(3);
			pro = 'coin';
		}

      
		
		public function closeTop(event:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
		}
		
		public function toggleButtonEffect(i:int):void
		{
			switch(i)
			{
				case 1: tb1.styleName = 'topSelectedButton';
				        tb2.styleName = 'topUnSelectedButton';
				        tb3.styleName = 'topUnSelectedButton';
				        tb4.styleName = 'topUnSelectedButton';
				        tb5.styleName = 'topUnSelectedButton';
				        tb6.styleName = 'topUnSelectedButton';
				        tb7.styleName = 'topUnSelectedButton';
				        tb8.styleName = 'topUnSelectedButton';
				        break;
				case 2: tb1.styleName = 'topUnSelectedButton';
				        tb2.styleName = 'topSelectedButton';
				        tb3.styleName = 'topUnSelectedButton';
				        tb4.styleName = 'topUnSelectedButton';
				        tb5.styleName = 'topUnSelectedButton';
				        tb6.styleName = 'topUnSelectedButton';
				        tb7.styleName = 'topUnSelectedButton';
				        tb8.styleName = 'topUnSelectedButton';
				        break;
				case 3: tb1.styleName = 'topUnSelectedButton';
				        tb2.styleName = 'topUnSelectedButton';
				        tb3.styleName = 'topSelectedButton';
				        tb4.styleName = 'topUnSelectedButton';
				        tb5.styleName = 'topUnSelectedButton';
				        tb6.styleName = 'topUnSelectedButton';
				        tb7.styleName = 'topUnSelectedButton';
				        tb8.styleName = 'topUnSelectedButton';
				        break;
				case 4: tb1.styleName = 'topUnSelectedButton';
				        tb2.styleName = 'topUnSelectedButton';
				        tb3.styleName = 'topUnSelectedButton';
				        tb4.styleName = 'topSelectedButton';
				        tb5.styleName = 'topUnSelectedButton';
				        tb6.styleName = 'topUnSelectedButton';
				        tb7.styleName = 'topUnSelectedButton';
				        tb8.styleName = 'topUnSelectedButton';
				        break;
				case 5: tb1.styleName = 'topUnSelectedButton';
				        tb2.styleName = 'topUnSelectedButton';
				        tb3.styleName = 'topUnSelectedButton';
				        tb4.styleName = 'topUnSelectedButton';
				        tb5.styleName = 'topSelectedButton';
				        tb6.styleName = 'topUnSelectedButton';
				        tb7.styleName = 'topUnSelectedButton';
				        tb8.styleName = 'topUnSelectedButton';
				        break;  
				case 6: tb1.styleName = 'topUnSelectedButton';
				        tb2.styleName = 'topUnSelectedButton';
				        tb3.styleName = 'topUnSelectedButton';
				        tb4.styleName = 'topUnSelectedButton';
				        tb5.styleName = 'topUnSelectedButton';
				        tb6.styleName = 'topSelectedButton';
				        tb7.styleName = 'topUnSelectedButton';
				        tb8.styleName = 'topUnSelectedButton';
				        break;
				case 7: tb1.styleName = 'topUnSelectedButton';
				        tb2.styleName = 'topUnSelectedButton';
				        tb3.styleName = 'topUnSelectedButton';
				        tb4.styleName = 'topUnSelectedButton';
				        tb5.styleName = 'topUnSelectedButton';
				        tb6.styleName = 'topUnSelectedButton';
				        tb7.styleName = 'topSelectedButton';
				        tb8.styleName = 'topUnSelectedButton';
				        break; 
				case 8: tb1.styleName = 'topUnSelectedButton';
				        tb2.styleName = 'topUnSelectedButton';
				        tb3.styleName = 'topUnSelectedButton';
				        tb4.styleName = 'topUnSelectedButton';
				        tb5.styleName = 'topUnSelectedButton';
				        tb6.styleName = 'topUnSelectedButton';
				        tb7.styleName = 'topUnSelectedButton';
				        tb8.styleName = 'topSelectedButton';
				        break;            
			}
			
		}
		
		public function filter(event:Event):void
		{
			flag = false;
			RemoteService.instance.listAllPlayerInfo(1,pro,countryFilter.selectedIndex,professionFilter.selectedIndex).addHandlers(onGetAllPlayerInfo);
		}
		
		public function noFunction(event:MouseEvent):void
		{
			collection.errorEvent('此功能还未完成',null);
		}
		
	}
}