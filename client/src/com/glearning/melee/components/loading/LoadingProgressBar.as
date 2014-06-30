package com.glearning.melee.components.loading
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;
	import com.glearning.melee.components.loading.LoadMaterial;
	public class LoadingProgressBar extends DownloadProgressBar
	{
		private var logo:Loader;
		private var logo_bar:Loader;
		private var txt:TextField;
		private var _preloader:Sprite;
		public function LoadingProgressBar()
		{
			logo = new Loader();
			logo.load(new URLRequest("images/loading/loadingPage.jpg"));
			addChild(logo);
			logo_bar = new Loader();
			logo_bar.load(new URLRequest("images/loading/full.gif"));
			addChild(logo_bar);
			var style:TextFormat = new TextFormat(null,null,0xFFFFFF,null,null,null,null,null,"center");
			txt = new TextField();
			txt.defaultTextFormat = style;
			txt.width = 200;
			txt.selectable = false;
			txt.height = 20;
			addChild(txt);
			LoadMaterial.loadProgress();
			super();
		}
		
		
		
		
		
		override public function set preloader(value:Sprite):void{
			_preloader = value
			_preloader.addEventListener(ProgressEvent.PROGRESS,load_progress);
			_preloader.addEventListener(Event.COMPLETE,load_complete);
			_preloader.addEventListener(FlexEvent.INIT_PROGRESS,init_progress);
			_preloader.addEventListener(FlexEvent.INIT_COMPLETE,init_complete);
			
			stage.addEventListener(Event.RESIZE,resize)
			resize(null);
		}
		private function remove():void{
			_preloader.removeEventListener(ProgressEvent.PROGRESS,load_progress);
			_preloader.removeEventListener(Event.COMPLETE,load_complete);
			_preloader.removeEventListener(FlexEvent.INIT_PROGRESS,init_progress);
			_preloader.removeEventListener(FlexEvent.INIT_COMPLETE,init_complete);
			stage.removeEventListener(Event.RESIZE,resize)
		}
		private function resize(e:Event):void{
			logo.x = 0;
			logo.y = 0;
			logo_bar.x = 390;
			logo_bar.y = 355;
			logo_bar.scaleX = 0.1;
			txt.x = 580;
			txt.y = 350;
			
			graphics.clear();
			graphics.beginFill(0x333333);
			graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			graphics.endFill();
		}
		private function load_progress(e:ProgressEvent):void{
			
			logo_bar.scaleX = Number(e.bytesLoaded/e.bytesTotal);
			txt.text = '当前加载'+Math.round(Number(e.bytesLoaded/e.bytesTotal)*100)+'%';
		}
		private function load_complete(e:Event):void{
			
		}
		private function init_progress(e:FlexEvent):void{
			
		}
		private function init_complete(e:FlexEvent):void{
			remove();	
			dispatchEvent(new Event(Event.COMPLETE));	
		}

	}
}