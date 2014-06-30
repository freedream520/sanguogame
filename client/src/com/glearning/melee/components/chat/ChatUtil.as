package com.glearning.melee.components.chat
{
	public class ChatUtil
	{
		import mx.collections.ArrayCollection;
		
		public function ChatUtil()
		{
		}
				
		/**
		 * "u'\u4f0d\u5fb7\u9e4f'"
		 *过滤u
		  * */
		public static function replacePrefix(value:String):String{
			trace(value.indexOf("u")==0);
			if (value.indexOf("u")==0){
				value = value.substr(1);
			}else if(value.indexOf("u")==1){
				value = value.substr(2);
			}else{
				value = value;
			}
			return value;
		}
	}
}