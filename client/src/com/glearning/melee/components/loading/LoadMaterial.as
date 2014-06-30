package com.glearning.melee.components.loading
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class LoadMaterial
	{
		public static var SWFCOMPLETE:String = ''; 
		public static var PHOTOCOMPLETE:String = '' ;
		
		public function LoadMaterial()
		{
			
		}
		
		public static function loadSwf(URL:String):void
		{
			var loader:Loader = new Loader();
			loader.load(new URLRequest(URL));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadSwfFinish);
		}
		
		public static function loadSwfFinish(e:Event):void
		{
			SWFCOMPLETE = '人物形象加载中...';
		}
		
		public static function loadPhoto(URL:String):void
		{
			var loader:Loader = new Loader();
			loader.load(new URLRequest(URL));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadPhotoFinish);
		}
		
		public static function loadPhotoFinish(e:Event):void
		{
			PHOTOCOMPLETE = '游戏图片加载中...';
		}
		
		public static function loadProgress():void
		{						
			LoadMaterial.loadSwf('images/sanGuo/profession/PC_1_F_L.swf');			
			LoadMaterial.loadSwf('images/sanGuo/profession/PC_1_M_L.swf');			
			LoadMaterial.loadSwf('images/sanGuo/profession/PC_2_F_L.swf');
			LoadMaterial.loadSwf('images/sanGuo/profession/PC_2_M_L.swf');
			LoadMaterial.loadSwf('images/sanGuo/profession/PC_3_F_L.swf');
			LoadMaterial.loadSwf('images/sanGuo/profession/PC_3_M_L.swf');
			LoadMaterial.loadSwf('images/sanGuo/profession/PC_4_F_L.swf');
			LoadMaterial.loadSwf('images/sanGuo/profession/PC_4_M_L.swf');
			LoadMaterial.loadSwf('images/sanGuo/profession/PC_5_F_L.swf');
			LoadMaterial.loadSwf('images/sanGuo/profession/PC_5_M_L.swf');
			LoadMaterial.loadSwf('images/sanGuo/profession/PC_6_F_L.swf');
			LoadMaterial.loadSwf('images/sanGuo/profession/PC_6_M_L.swf');		
			LoadMaterial.loadSwf('images/sanGuo/profession/effect1.swf');	
			LoadMaterial.loadSwf('images/sanGuo/profession/effect2.swf');			
			LoadMaterial.loadSwf('images/sanGuo/profession/effect3.swf');			
			
			LoadMaterial.loadSwf('images/figure/PC_1_F_L.swf');
			LoadMaterial.loadSwf('images/figure/PC_1_F_R.swf');
			LoadMaterial.loadSwf('images/figure/PC_1_M_L.swf');
			LoadMaterial.loadSwf('images/figure/PC_1_M_R.swf');
			LoadMaterial.loadSwf('images/figure/PC_2_F_L.swf');
			LoadMaterial.loadSwf('images/figure/PC_2_F_R.swf');
			LoadMaterial.loadSwf('images/figure/PC_2_M_L.swf');
			LoadMaterial.loadSwf('images/figure/PC_2_M_R.swf');
			LoadMaterial.loadSwf('images/figure/PC_3_F_L.swf');
			LoadMaterial.loadSwf('images/figure/PC_3_F_R.swf');
			LoadMaterial.loadSwf('images/figure/PC_3_M_L.swf');
			LoadMaterial.loadSwf('images/figure/PC_3_M_R.swf');
			LoadMaterial.loadSwf('images/figure/PC_4_F_L.swf');
			LoadMaterial.loadSwf('images/figure/PC_4_F_R.swf');
			LoadMaterial.loadSwf('images/figure/PC_4_M_L.swf');
			LoadMaterial.loadSwf('images/figure/PC_4_M_R.swf');
			LoadMaterial.loadSwf('images/figure/PC_5_F_L.swf');
			LoadMaterial.loadSwf('images/figure/PC_5_F_R.swf');
			LoadMaterial.loadSwf('images/figure/PC_5_M_L.swf');
			LoadMaterial.loadSwf('images/figure/PC_5_M_R.swf');
			LoadMaterial.loadSwf('images/figure/PC_6_F_L.swf');
			LoadMaterial.loadSwf('images/figure/PC_6_F_R.swf');
			LoadMaterial.loadSwf('images/figure/PC_6_M_L.swf');
			LoadMaterial.loadSwf('images/figure/PC_6_M_R.swf');
			LoadMaterial.loadSwf('images/levelEffect.swf');
			LoadMaterial.loadPhoto('images/sanGuo/Camp/campBG.jpg');
			LoadMaterial.loadPhoto('images/sanGuo/shop/shopBackImage.jpg');
			LoadMaterial.loadPhoto('images/sanGuo/procedurehall/hallBG.png');
			LoadMaterial.loadPhoto('images/sanGuo/login/loginBg.jpg');
			LoadMaterial.loadPhoto('images/sanGuo/loading/loadingBg.jpg');
			LoadMaterial.loadPhoto('images/sanGuo/resthouse/restroomBg.png');
			LoadMaterial.loadPhoto('images/sanGuo/goldgoverBackGround.png');
			LoadMaterial.loadPhoto('images/sanGuo/profession/professionBG.jpg');
			LoadMaterial.loadPhoto('images/sanGuo/roleUI.png');
			LoadMaterial.loadPhoto('images/sanGuo/procedurehall/hallimg.png');
			LoadMaterial.loadPhoto('images/sanGuo/procedurehall/hallimg.png');			
			LoadMaterial.loadPhoto('images/sanGuo/procedurehall/hallimg.png');
			LoadMaterial.loadPhoto('images/places/WorldMap.jpg');			
		}

	}
}