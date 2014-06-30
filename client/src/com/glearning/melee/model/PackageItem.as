//物品信息
package com.glearning.melee.model
{
	import flash.geom.Rectangle;
	
	public class PackageItem
	{
		public function PackageItem()
		{
		}
		
		//物品在包裹栏里的ID
		public var _id:int;
		[Bindable]
		public function get id():int{
			return _id;
		} 
		public function set id(value:int):void{
			_id = value;
		}
		
		//物品图片
		public var _image:String;
		[Bindable]
		public function get image():String{
			return _image;
		}
		public function set image(value:String):void{
			_image = value;
		}
		
		//物品所在X位置
		public var _xInPackage:uint;
		[Bindable]
		public function get xInPackage():uint{
			return _xInPackage;
		}
		public function set xInPackage(value:uint):void{
			_xInPackage = value;
		}
		
		//物品所在Y位置
		public var _yInPackage:uint;
		[Bindable]
		public function get yInPackage():uint{
			return _yInPackage;
		}
		public function set yInPackage(value:uint):void{
			_yInPackage = value;
		}
		
		//物品占有的X位置
		public var _width:uint;
		[Bindable]
		public function get width():uint{
			return _width;
		}
		public function set width(value:uint):void{
			_width = value;
		}
		
		//物品占有的 Y位置
		public var _height:uint;
		[Bindable]
		public function get height():uint{
			return _height;
		}
		public function set height(value:uint):void{
			_height = value;
		}
		
		//物品的数量
		public var _count:uint;
		[Bindable]
		public function get count():uint{
			return _count;
		}
		public function set count(value:uint):void{
			_count = value;
		}
		
		//物品可叠数量
		public var _stack:int;
		[Bindable]
		public function get stack():int{
			return _stack;
		}
		public function set stack(value:int):void{
			_stack = value;
		}
		
		//物品当前位置数组
		public var _xy:Array;
		[Bindable]
		public function get xy():Array{
			return _xy;
		}
		public function set xy(value:Array):void{
			_xy = value;
		}
		
		//物品的详细信息
		public var _itemInfo:Object;
		[Bindable]
		public function get itemInfo():Object{
			return _itemInfo;
		}
		public function set itemInfo(value:Object):void{
			_itemInfo = value;
		}
		
		//物品的具体名字
		public var _itemName:String;
		[Bindable]
		public function get itemName():String{
			return _itemName;
		}
		public function set itemName(value:String):void{
			_itemName = value;
		}
		
		//绑定类型
		public var _itemBindType:String;
		[Bindable]
		public function get itemBindType():String{
			return _itemBindType;
		}
		public function set itemBindType(value:String):void{
			_itemBindType = value;
		}
		
		//是否绑定
		public var _itemIsBoundDesc:String;
		[Bindable]
		public function get itemIsBoundDesc():String{
			return _itemIsBoundDesc;
		}
		public function set itemIsBoundDesc(value:String):void{
			_itemIsBoundDesc = value;
		}
		
		//出售价格
		public var _itemSellPrice:int;
		[Bindable]
		public function get itemSellPrice():int{
			return _itemSellPrice;
		}
		public function set itemSellPrice(value:int):void{
			_itemSellPrice = value;
		}
		
		//是否装备
		public var _itemIsEquiped:Boolean;
		[Bindable]
		public function get itemIsEquiped():Boolean{
			return _itemIsEquiped;
		}
		public function set itemIsEquiped(value:Boolean):void{
			_itemIsEquiped = value;
		}
		
		//物品的附加属性
		public var _itemProperty:Array;
		[Bindable]
		public function get itemProperty():Array{
			return _itemProperty;
		}
		public function set itemProperty(value:Array):void{
			_itemProperty = value;
		}
		
		//itemId
		public var _itemId:int;
		[Bindable]
		public function get itemId():int{
			return _itemId;
		}
		public function set itemId(value:int):void{
			_itemId = value;
		}
		
		//itemObj
		public var _itemObj:Object;
		[Bindable]
		public function get itemObj():Object{
			return _itemObj;
		}
		public function set itemObj(value:Object):void{
			_itemObj = value;
		}
		
					
		public function containsPosition( x:uint, y:uint ):Boolean {
			var rec1:Rectangle = new Rectangle(this.xInPackage, this.yInPackage, this.width, this.height);
			return rec1.contains(x,y);
		}
		
		
		
		public function checkOverlap( otherItem:PackageItem, x:uint, y:uint ):Boolean {
			var rec1:Rectangle = new Rectangle(this.xInPackage, this.yInPackage, this.width, this.height);
			var rec2:Rectangle = new Rectangle(x,y, otherItem.width, otherItem.height);
			return rec1.intersects( rec2 );
		}

	}
}