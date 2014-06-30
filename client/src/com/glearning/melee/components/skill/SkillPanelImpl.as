package com.glearning.melee.components.skill
{
	import flash.events.MouseEvent;	
	import mx.containers.Canvas;
	import mx.core.Application;
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.utils.AutoTip;
	import com.glearning.melee.model.MySelf;
	public class SkillPanelImpl extends Canvas
	{
		public function SkillPanelImpl()
		{
			super();
		}
		
		public function showCharacter(event:MouseEvent):void
	    {
	    	Application.application.currentState = 'character';
	    }
	    
	    public function colseSkillPanel(event:MouseEvent):void
	    {
	    	Application.application.currentState = collection.currentPosition;
	    	if(MySelf.instance.isNewPlayer == 1)
	    	{
	    		if(MySelf.instance.progress == 14)
	    		{
	    			AutoTip._destoryTip();
	    			
	    		}
	    	}
	    	if(MySelf.instance.sparePoint == 0)
        	{
        		Application.application.character.data = '角色';
        	}else
        	{
        		Application.application.character.data = '您有'+MySelf.instance.sparePoint+'点属性点可加';
        	}
	    }
	}
}