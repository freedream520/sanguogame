//吕忠涛
//创建场景中的地点按钮
package com.glearning.melee.collections
{
	import com.glearning.melee.components.CustomerButtonComponent;
	import com.glearning.melee.components.CustomerLinkButtonComponent;
	
	import mx.controls.LinkButton;
	public class LocationButton
	{
		public function LocationButton()
		{
		}
		
		
		/** 创建Place地点按钮 */
		public static function createPlace(data:Object):LinkButton{
			var linkButton:LinkButton = createPlaceButton(data);
			linkButton.data = data['type'];
			linkButton.id = data['id'];
			linkButton.name = data['name'];
			linkButton.uid = data['regionId'];
			return linkButton;
		}
		
		/** 创建city地点按钮 */
		public static function createBuild(data:Object):CustomerButtonComponent{
			var linkButton:CustomerButtonComponent = createCityButton(data);			
			linkButton.data = data['desciption'];
			if(data['name'] == '宿屋'){
				collection.resetRoom = data['id'];
			}
			if(data['type'] == '出口'){
				//去往野外用的 
				linkButton.id = data['regionId'];
			}else{
				linkButton.id = data['id'];
			}
			
			return linkButton;
		}
		
		/** 创建place按钮 */
		private static function createPlaceButton(data:Object):LinkButton{
			var linkButton:LinkButton = new LinkButton();
			if(data['extentLeft']-20 < 0)
			{
				linkButton.x = 0;
			}else{
				linkButton.x = data['extentLeft']-20;
			}
			
			linkButton.y = data['extentTop'];
			linkButton.label = data['name'];
			data['isBuilded'] == 1 
				? (linkButton.setStyle("styleName","PlaceButton"),linkButton.enabled=true) 
					: (linkButton.setStyle("styleName","PlaceButtonDisable"),linkButton.enabled=false);
			return linkButton;
		}
		
		/** 创建city按钮 */
		private static function createCityButton(data:Object):CustomerButtonComponent{
			var linkButton:CustomerButtonComponent = new CustomerButtonComponent();
			if(data['extentLeft']-20 < 0)
			{
				linkButton.x = 0;
			}else{
				linkButton.x = data['extentLeft']-20;
			}
			
			linkButton.y = data['extentTop'];
			linkButton.label = data['name'];
			linkButton.name = data['name'];
			linkButton.width = 90;
			linkButton.height = 26;
			data['isBuilded'] == 1 
				? (linkButton.setStyle("styleName","PlaceButton"),linkButton.enabled=true) 
					: (linkButton.setStyle("styleName","PlaceButtonDisable"),linkButton.enabled=false);
			return linkButton;
		}
	}
}