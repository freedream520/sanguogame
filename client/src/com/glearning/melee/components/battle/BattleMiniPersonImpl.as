package com.glearning.melee.components.battle
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.*;
	import flash.utils.setTimeout;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.controls.Label;
	import mx.controls.SWFLoader;
	import mx.core.Application;
	import mx.effects.Move;
	public class BattleMiniPersonImpl extends Canvas
	{
		
		public var figureArray:Array = Application.application.figureArray;
		public var swf:SWFLoader;
		public var hurtEffect:Move;
		public var effectScene:Canvas;
		public var flashCount:int;
		public var effectSwf:SWFLoader;
		public var swfArray:Array = new Array();
		public function BattleMiniPersonImpl()
		{
			super();
		}
		//根据职业选择人物造型
		public function init(source:String):void
		{
			swf.source = source;
//			if(direction == 'right')
//			{          
//             	swf.source = "imgs/personRight.swf";
//            }
//            else
//            {
//             	swf.source = "imgs/personLeft.swf";
//            }
           
		}
		
		//播放动画
		public function playFlash():void
		{
			MovieClip(swf.content).play();
		}
		
		//初始化动画并播放
//		public function initial(count:int,path:String,fxEvent:int,loaclX:int):void
//      {
//      	if(fxEvent == 1){
//      		closeEffect('3');
//      	}else{
//      		closeEffect();
//      	}
//         var effectSwf:SWFLoader = new SWFLoader();
//         effectSwf.source = path;
//         if(loaclX > 490){
//         	effectSwf.x = 70;
//         }else{
//         	effectSwf.x = 5;
//         }
//		 effectSwf.y = 20;
//         effectScene.addChildAt(effectSwf,5);
//         effectSwf.addEventListener(Event.COMPLETE,function():void
//         {
//           if(count == 1)
//           {
//              MovieClip(effectSwf.content).addEventListener("finish",function():void
//              {
//               MovieClip(effectSwf.content).stop();
//               effectScene.removeChild(effectSwf);
//              });
//           }else
//           {
//           	swfArray.push({type:count,obj:effectSwf});
//            MovieClip(effectSwf.content).play();
//           }
//         });
//        
//      }		
//      
//      //关闭所有动画特效
//      
//      public function closeEffect(type:String ='all'):void
//      {
//      	if(type == 'all'){
//      		effectScene.removeAllChildren();
//      		swfArray.splice(0);
//      	}
//      	if(type == '3'){
//      		for(var i:int = 0;i<swfArray.length;i++)
//	 		{
//	 			if(swfArray[i]['type'] == 3){
//	 				effectScene.removeChild(swfArray[0]['obj']);
//	 				swfArray.splice(i,1);
//	 				i -= 1;
//	 			}
//	 		}
//      	}
//      	if(type == '2'){
//      		for(var i:int = 0;i<swfArray.length;i++)
//	 		{
//	 			if(swfArray[i]['type'] == 2){
//	 				effectScene.removeChild(swfArray[0]['obj']);
//	 				swfArray.splice(i,1);
//	 				i -= 1;
//	 			}
//	 		}
//      	}
//      	//effectScene.removeAllChildren();
//      }
		
		//跳数字
		public function showHurt(num:String,property:String,textSize:int,direction:String,type:int = 0):void
		{
			var addOrMinus:String = num.substring(0,1);
			var hurt:String = num.substr(1);
			
			//创建bubble底框
			var bubble:HBox = new HBox();
			bubble.setStyle('horizontalAlign','center');
			bubble.x = 0;
			bubble.y = 60;
			bubble.height = 52;bubble.percentWidth = 100;			
			
			//创建bubble数字
			var hurtNum:Label = new Label();
			var myGlowFilter:GlowFilter= new GlowFilter(0x000000, 1, 8, 8, 30, 1, false, false);
			var myFilters:Array = hurtNum.filters;
			myFilters.push(myGlowFilter);
	    	hurtNum.filters = myFilters;
	    	hurtNum.y = 12;
	    	hurtNum.text = num;
	    	hurtNum.styleName = 'battleNumStyle'; 	    	 
	    	hurtNum.setStyle("textAlign",'center');
	    	   
	    	//创建bubble样式 
	    	if(type == 1){
	    		bubble.setStyle('backgroundImage','images/battle/baoji.png');
	    	}else if(type == 2){
	    		bubble.setStyle('backgroundImage','images/battle/pofang.png');
	    	}else if(type == 3){
	    		bubble.setStyle('backgroundImage','images/battle/pofangbaoji.png');
	    	}      
	    	if(property == "hp" && addOrMinus == "-"){
	    		if(hurt == '0')
				{
					hurt = 'MISS';
					hurtNum.text = hurt;
				}
		    	hurtNum.setStyle("color","0xff0000");
	    	}else if(property == "hp" && addOrMinus == "+"){
	    		if(hurt == '0')
				{
					hurtNum.text = '';
				}
		    	hurtNum.setStyle("color","0x00ff00");
	    	}else if(property == "mp"){
	    		if(hurt == '0')
				{
					hurtNum.text = '';
				}
		    	hurtNum.setStyle("color","0x0000ff");
	    	}
	        if(textSize == 1)
	        hurtNum.setStyle("fontSize","20");
	        else if(textSize == 2)
	        hurtNum.setStyle("fontSize","30");
	        else if(textSize == 3)
	        hurtNum.setStyle("fontSize","40");
	        addChildAt(bubble,this.getChildren().length);
	    	bubble.addChild(hurtNum);
	    	hurtEffect.target = bubble;
	    	hurtEffect.end();
	    	hurtEffect.play();
	    	setTimeout(function():void{bubble.removeChild(hurtNum);removeChild(bubble);},1500);
			
			
		}
		
//		  public function removeLabel():void
//	    {
//	    	bubble.removeChild(hurtNum);
//	    	removeChild(bubble);
//	    }
		
	}
}