package com.glearning.melee.model
{
	public class WareHouseInfo
	{
		public static function get instance():WareHouseInfo
		{
			if (!_instance)
				_instance = new WareHouseInfo();
			
			return _instance;
		}
		  
		private static var _instance:WareHouseInfo = null;
		public function WareHouseInfo()
		{
		}
		
		//仓库中所有物品
		private var _warehouseItems:Array = new Array();
		[Bindable]
		public function get warehouseItems():Array{
			return _warehouseItems;
		}
		public function set warehouseItems(value:Array):void{
			_warehouseItems = value;
		}
		
		//单个仓库中的物品
		private var _oneWarehouseItems:Array = new Array();
		[Bindable]
		public function get oneWarehouseItems():Array{
			return _oneWarehouseItems;
		}
		public function set oneWarehouseItems(value:Array):void{
			_oneWarehouseItems = value;
		}

	}
}