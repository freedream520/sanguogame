package com.glearning.melee.net
{
	import com.glearning.melee.collections.collection;
	
	import mx.collections.ItemResponder;
	
	public class MyItemResponder extends ItemResponder
	{
		public function MyItemResponder(result:Function, fault:Function,type:Boolean, token:Object = null)
		{
			super(result,fault,token);

//			_resultHandler = result;
//			_faultHandler = fault;
//			_token = token;
			_type = type;
		}
		
		override public function result(data:Object):void
		{
//			_resultHandler(data, _token);
			
			super.result(data);
			if(_type){
				collection.closeLoading();
			}
		}
		
		override public function fault(info:Object):void
		{
			
			
			super.fault(info);
			if(_type){
				collection.closeLoading();
			}
		}
		
//		public var _resultHandler:Function;
//		public var _faultHandler:Function;
//		public var _token:Object;
		public var _type:Boolean;

	}
}