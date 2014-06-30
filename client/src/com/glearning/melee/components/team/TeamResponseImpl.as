package com.glearning.melee.components.team
{
	import mx.containers.Canvas;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;

	public class TeamResponseImpl extends Canvas
	{
		public var teamMemberArray:Array;
		public var teamData:DataGrid;
		public var leaderId:int;
		public function TeamResponseImpl()
		{
			super();
		}
		
		public function initArray(array:Array):void
		{
			teamMemberArray = array;
			teamData.dataProvider = teamMemberArray;
			for(var i:int =0;i<teamMemberArray.length;i++)
			{
				if(teamMemberArray[i].isLeader == true)
				{
					leaderId = teamMemberArray[i].id;
					break;
				}
			}
		}
		
		public function fun(item:Object,column:DataGridColumn):String
    		{
    			if(item == null)
    			return null;
    				
    			switch(column.headerText)
    			{
    				case "性别":
    				return item.gender == 1 ? '男' : '女'; 
    				break;    				
    			}
    			return null;  			
    		}    	
		
	
		
	}
}