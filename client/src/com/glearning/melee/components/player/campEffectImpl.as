package com.glearning.melee.components.player
{
	import flash.utils.setTimeout;
	
	import mx.containers.Canvas;
	import mx.controls.LinkButton;
	import mx.effects.Glow;
	public class campEffectImpl extends Canvas
	{
		public var glowImage:Glow;
		public var unglowImage:Glow;		
	    public var flag:Boolean;
	    public var campName:LinkButton;
		public function campEffectImpl()
		{
			super();
		}
		
			
		public function glowEffect():void
		{
			glowImage.end();
			glowImage.target = campName;
			glowImage.play();
		}
		
		public function unGlowEffect():void
		{
			unglowImage.end();
			unglowImage.target = campName;
			unglowImage.play();
		}
		
	    public function glowUp():void
		{
			glowEffect();
			setTimeout(glowDown,1000);			
		}
		
		public function glowDown():void
		{
			unGlowEffect();
			setTimeout(isAgain,1000);			
		}
		
		public function isAgain():void
		{
			if(flag)
			glowUp();
		}
		
		public function startEffect():void
		{	
			flag = true;		
			glowUp();		
		}
		
		public function endEffect():void
		{
			flag = false;
		}
		
		
	}
}