package com.glearning.melee.components.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TimeUtil
	{
		private var obj_time:int;
		private var hour:int;
		private var minut:int;
		private var second:int;
		[Bindable]
		public var time:String = '';
		public var timer:Timer;
		public function TimeUtil(obj_time:int)
		{
			this.obj_time = obj_time;
			timer = new Timer(1000,obj_time*1000);
			init(obj_time);
		}
		
		public function formatTime(num:int):String
		{
			if(0<=num && num<10)
			{
				return '0'+num;
			}
			return num.toString();
		}
		
		public function init(obj:int):void
		{
		   hour = obj/3600;
		   minut = (obj%3600)/60;
		   second = obj%3600%60;	
		  
		   time = formatTime(hour)+':'+formatTime(minut)+':'+formatTime(second); 
		   
		  
		}
		
		
		
		public function startCount():void
		{			
			
			timer.addEventListener(TimerEvent.TIMER,countTime);			
//			timer.addEventListener(TimerEvent.TIMER_COMPLETE,removeTimer);
			timer.start();
		}
		
		public function countTime(event:TimerEvent):void
		{
		  if(second >0)
		  {
		  	
		  	second -= 1;
		  }else
		  {
		  	if(minut >0 )
		  	{
		  		minut -= 1;
		  		second = 59;
		  	}
		  	else
		  	{
		  		if(hour >0)
		  		{
		  			hour -= 1;
		  			minut = 59;
		  			second = 59;
		  		}else
		  		time = '0';
		  	}
		  }
		  
		   time = formatTime(hour)+':'+formatTime(minut)+':'+formatTime(second); 
		}

       public function removeTimer(event:TimerEvent):void
       {
		  trace('stop');
       }
       
       public function resetTimer(resetTime:int):void
       {       	
//       	timer.reset();
	        timer.stop();
	        timer = new Timer(1000,resetTime*1000);
	       	init(resetTime);
	       	startCount();
       }
	}
}