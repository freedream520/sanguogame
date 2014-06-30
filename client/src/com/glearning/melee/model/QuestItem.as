//任务信息
package com.glearning.melee.model
{
	public class QuestItem
	{
		public function QuestItem()
		{
		}
		
		//任务名
		public var _name:String;
		[Bindable]
		public function get name():String{
			return _name;
		}
		public function set name(value:String):void{
			_name = value;
		}
		
		//任务类型
		public var _type:String;
		[Bindable]
		public function get type():String{
			return _type;
		}
		public function set type(value:String):void{
			_type = value;
		}
		
		//任务要求
		public var _request:Array;
		public function get request():Array{
			return _request;
		}
		public function set request(value:Array):void{
			_request = value;
		}
		
		//传送点
		public var _teleport:Array;
		public function get teleport():Array{
			return _teleport;
		}
		public function set teleport(value:Array):void{
			_teleport = value;
		}
		
		//任务详细信息
		public var _details:Object;
		public function get details():Object{
			return _details;
		}
		public function set details(value:Object):void{
			_details = value;
		}
	}
}