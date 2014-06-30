package com.glearning.melee.components.utils
{
    import flash.display.DisplayObject;
    
    import mx.core.IFlexDisplayObject;
    import mx.effects.Blur;
    import mx.events.TweenEvent;
    import mx.managers.PopUpManager;
    
    public class PopUpEffect
    {
        
        public function PopUpEffect()
        {
        }

        public static function Show(control:IFlexDisplayObject,parent:DisplayObject,modal:Boolean=true):void
        {
           
            PopUpManager.addPopUp(control,parent,modal);
            PopUpManager.centerPopUp(control);
           
        
        }
        
        public static function Hide(control:IFlexDisplayObject):void
        {            
                PopUpManager.removePopUp(control);        
        }
    }
}