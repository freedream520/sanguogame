package com.glearning.melee.model
{
	import mx.rpc.events.ResultEvent;
	
	public class PlaceInfo
	{
		//场景中要用到
		public static function get instance():PlaceInfo
		{
			if (!_instance)
				_instance = new PlaceInfo();
			
			return _instance;
		}
		  
		private static var _instance:PlaceInfo = null;
		public function PlaceInfo()
		{
		}
		//当前区域名字
		private var _regionName:String = "";
		[Bindable]
		public function get regionName():String {
			return _regionName;
		}
		public function set regionName(value:String):void {
			_regionName = value;
		}
		
		//当前地点名字
		private var _placeName:String = "";
		[Bindable]
		public function get placeName():String {
			return _placeName;
		}
		public function set placeName(value:String):void {
			_placeName = value;
		}
		
		//地点的类型
		private var _placeType:String = "";
		[Bindable]
		public function get placeType():String {
			return _placeType;
		}
		public function set placeType(value:String):void {
			_placeType = value;
		}
		
		//阵营
		private var _faction:String = "";
		[Bindable]
		public function get faction():String {
			return _faction;
		}
		public function set faction(value:String):void {
			_faction = value;
		}
		
		//地点介绍
		private var _description:String = "";
		[Bindable]
		public function get description():String{
			return _description;
		}
		public function set description(value:String):void{
			_description = value;
		}
		
		//地图图片
		private var _mapImg:String = "";
		[Bindable]
		public function get mapImg():String{
			return _mapImg;
		}
		public function set mapImg(value:String):void{
			_mapImg = value;
		}
		
		//场景中地点的位置列表
		private var _placeList:Array = null;
		[Bindable]
		public function get placeList():Array{
			return _placeList;
		}
		public function set placeList(value:Array):void{
			_placeList = value;
		}
		
		//NPC列表
		private var _npcList:Array = null;
		[Bindable]
		public function get npcList():Array{
			return _npcList;
		}
		public function set npcList(value:Array):void{
			_npcList = value;
		}
		
		//子地点
		private var _palceChilds:Array = null;
		[Bindable]
		public function get palceChilds():Array{
			return _palceChilds;
		}
		public function set palceChilds(value:Array):void{
			_palceChilds = value;
		}
		
		//玩家列表
		private var _playerList:Array = null;
		[Bindable]
		public function get playerList():Array{
			return _playerList;
		}
		public function set playerList(value:Array):void{
			_playerList = value;
		}
		
		//地点导航
		private var _locationMap:Array = null;
		[Bindable]
		public function get locationMap():Array{
			return _locationMap;
		}
		public function set locationMap(value:Array):void{
			_locationMap = value;
		}
		
		//人物所在X位置
		private var _playerX:int = 0;
		[Bindable]
		public function get playerX():int{
			return _playerX;
		}
		public function set playerX(value:int):void{
			_playerX = value;
		}
		
		//人物所在Y位置
		private var _playerY:int = 0;
		[Bindable]
		public function get playerY():int{
			return _playerY;
		}
		public function set playerY(value:int):void{
			_playerY = value;
		}
		
		//判断是否在同一区域
		private var _inRegion:Boolean = false;
		[Bindable]
		public function get inRegion():Boolean{
			return _inRegion;
		}
		public function set inRegion(value:Boolean):void{
			_inRegion = value;
		}
		
		//阵营颜色
		private var _factionColor:String = "#ffffff";
		[Bindable]
		public function get factionColor():String{
			return _factionColor;
		}
		public function set factionColor(value:String):void{
			_factionColor = value;
		}
		
		//当前指针地点
		private var _name:String = "";
		[Bindable]
		public function get name():String{
			return _name;
		}
		public function set name(value:String):void{
			_name = value;
		}
	}
}