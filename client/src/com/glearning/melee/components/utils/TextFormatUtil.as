package com.glearning.melee.components.utils
{
	import flash.text.TextFormat;
	
	public class TextFormatUtil
	{
		public static const WEIINFOFORMAT:TextFormat = weiCountry();
		public static const SHUINFOFORMAT:TextFormat = shuCountry();
		public static const WUINFOFORMAT:TextFormat = wuCountry();
		public static const LEGIONFORMAT:TextFormat = legionFormat();
		public static const TEAMFORMAT:TextFormat = teamFormat();
		public static const COUNTRYFORMAT:TextFormat = countryFormat();
		public static const CHATTOFORMAT:TextFormat = chatToFormat();
		public static const COMPLEXFORMAT:TextFormat = complexFormat();
		public static const SCENEFORMAT:TextFormat = sceneFormat();
		
		public function TextFormatUtil()
		{
		}
		
		public static function weiCountry():TextFormat
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xAE00AE;
			textFormat.bold = true;
			return textFormat;
		}
		
		public static function shuCountry():TextFormat
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xEAC100;
			textFormat.bold = true;
			return textFormat;
		}
		
		public static function wuCountry():TextFormat
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0x0080FF;
			textFormat.bold = true;
			return textFormat;
		}
		
		public static function legionFormat():TextFormat
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xFF5809;
			textFormat.bold = true;
			return textFormat;
		}
		
		public static function teamFormat():TextFormat
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xACD6FF;
			textFormat.bold = true;
			return textFormat;
		}
		
		public static function countryFormat():TextFormat
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xFFFFFF;
			textFormat.bold = true;
			return textFormat;
		}
		
		public static function chatToFormat():TextFormat
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0x9AFF02;
			textFormat.bold = true;
			return textFormat;
		}

        public static function complexFormat():TextFormat
        {
        	var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = true;
			return textFormat;
        }
        
        public static function sceneFormat():TextFormat
        {
        	var textFormat:TextFormat = new TextFormat();		
        	textFormat.color = 0xFFD2D2;	
			textFormat.bold = true;
			return textFormat;
        }
	}
}