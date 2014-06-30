package com.glearning.melee.components.prompts
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.model.MySelf;
	
	import mx.containers.VBox;
	import mx.controls.Text;
	public class CustomerTooltipImpl extends VBox
	{
		
		public var packageItem:Object;				
		public var playerProperty:Object;
		public var progressValue:int;
		public var progressId:String;		
		public var onlyText:Object;		
		public var skill:Object;		
		public var content:VBox;
		public var effect:Object;
		public var _text:String; 
        public var packageType:int;
        public var cityInfo:String;
        public var timeString:String;
        public var st:String = '';
        public var tip:String = '';

		public function get text():String { 
		 
		return _text; 
		 
		} 
		 
		public function set text(value:String):void { 
		 
		}  
		public function CustomerTooltipImpl()
		{
			super();
		}
		
		
		public function init(num:int):void
		{
			var description:Text = new Text();			
			description.width = 220;
			description.setStyle('paddingLeft',10);
			description.setStyle('paddingBottom',10)
			switch(num)
			{
				case 1:var type:String = collection.getItemTypeGroupString(packageItem.itemTemplateInfo.type as int);
				      
				      
				       if(type == '武器')
				       {
				       	 var itemtype:String = collection.getItemTypeString(packageItem.itemTemplateInfo.type as int);
				        
//				         description.width = 220;
				         description.getStyle('leading');
				         if(packageItem.extraAttributeList.length == 1)
				         {
				           description.htmlText += '<b><font size="15" color="#8EDD40">'+packageItem.name+'</font></b>';
				         }else if(packageItem.extraAttributeList.length == 2)
				         {
				           description.htmlText += '<b><font size="15" color="#8CB3F5">'+packageItem.name+'</font></b>';
				         }else if(packageItem.extraAttributeList.length == 3)
				         {
				           description.htmlText += '<b><font size="15" color="#E15CEC">'+packageItem.name+'</font></b>';
				         }else
				         {
				         	description.htmlText += '<b><font size="15" color="#FDF3D1">'+packageItem.name+'</font></b>';
				         }
				         if(packageItem.itemLevel > 1){
				         	description.htmlText += '  <b><font size="15">(LV.'+packageItem.itemLevel+')</font></b>\n';
				         }else{
				         	description.htmlText += '\n';
				         }
				         description.htmlText += '<font color="#DBD2C5">绑定类型:</font>'+packageItem.bindType+(packageItem.isBound == 0?'(未绑定)':'(<font color="#E28BF4">已绑定</font>)')+'\n';
				         description.htmlText += '<font color="#E28BF4">'+packageItem.itemTemplateInfo.description+'</font>\n';
				         description.htmlText += '<font color="#DBD2C5">装备类型:</font>武器 '+itemtype+'\n';
				         description.htmlText += '<font color="#DBD2C5">攻击力:</font>'+packageItem.itemTemplateInfo.minDamage+'-'+packageItem.itemTemplateInfo.maxDamage+'\n';
				         if(packageItem.extraAttributeList.length > 0)
				         {
					         for(var i:int = 0 ;i<packageItem.extraAttributeList.length;i++)
					         {
					         	
					         }
				         }				         
				         description.htmlText += '<font color="#DBD2C5">单价:</font>'+packageItem.sellPrice+'\n';
				         description.htmlText += '<font color="#DBD2C5">等级需求:</font>'+(packageItem.itemTemplateInfo.levelRequire <= int(MySelf.instance.level) ? '<font color="#91FB6B">Lv.'+packageItem.itemTemplateInfo.levelRequire+'</font>\n':'<font color="#F75554">Lv.'+packageItem.itemTemplateInfo.levelRequire +'</font>\n');				         
				         description.htmlText += '<font color="#DBD2C5">职业需求:</font><font color="#91FB6B">'+packageItem.itemTemplateInfo.professionRequire+'</font>\n';
				         description.htmlText += '<font color="#DBD2C5">属性需求:</font>';
				         if(packageItem.itemTemplateInfo.strRequire != -1)
				         {
				         	if(packageItem.itemTemplateInfo.strRequire <= (MySelf.instance.manualStr+MySelf.instance.baseStr))
				         	   description.htmlText += '<font color="#DBD2C5">武勇:</font><font color="#91FB6B">'+packageItem.itemTemplateInfo.strRequire+'</font>';
				         	else
				         	   description.htmlText += '<font color="#DBD2C5">武勇:</font><font color="#F75554">'+packageItem.itemTemplateInfo.strRequire+'</font>';
				         }				         
				         if(packageItem.itemTemplateInfo.vitRequire != -1)
				         {
				         	if(packageItem.itemTemplateInfo.vitRequire <= (MySelf.instance.manualVit+MySelf.instance.baseVit))
				         	   description.htmlText += '<font color="#DBD2C5">体魄:</font><font color="#91FB6B">'+packageItem.itemTemplateInfo.vitRequire+'</font>';
				         	else
				         	   description.htmlText += '<font color="#DBD2C5">体魄:</font><font color="#F75554">'+packageItem.itemTemplateInfo.vitRequire+'</font>';
				         }
				         
				         if(packageItem.itemTemplateInfo.dexRequire != -1)
				         {
				         	if(packageItem.itemTemplateInfo.dexRequire <= (MySelf.instance.manualDex + MySelf.instance.baseDex))
				         	   description.htmlText += '<font color="#DBD2C5">机警:</font><font color="#91FB6B">'+packageItem.itemTemplateInfo.dexRequire+'</font>';
				         	else
				         	   description.htmlText += '<font color="#DBD2C5">机警:</font><font color="#F75554">'+packageItem.itemTemplateInfo.dexRequire+'</font>';
				         }
				         
				         description.htmlText += '\n<font color="#DBD2C5">耐久度:</font>'+packageItem.itemTemplateInfo.druability+'\n';				       
				         for(var k:int = 0;k<packageItem.extraAttributeList.length;k++)
						 {				         	
						   description.htmlText +=	'<font color="#668EEE">'+packageItem.extraAttributeList[k].attributeEffects[0]+'</font>\n';
						 }
							        
				        if(packageType == 1)
				        {
				        	description.htmlText += '<font color="#E28BF4">双击鼠标后使用装备</font>';
				        }else if(packageType == 2)
				        {
				        	description.htmlText += '<font color = "#E28BF4">双击鼠标后卸载装备</font>';
				        }
				         
				         addChild(description);
				       }else if(type == '防具')
				       {
				       	 var armortype:String = collection.getArmorTypeString(packageItem.itemTemplateInfo.type as int);
//				       	  description.width = 220;
				       	   if(packageItem.extraAttributeList.length == 1)
				         {
				           description.htmlText += '<b><font size="15" color="#8EDD40">'+packageItem.name+'</font></b>';
				         }else if(packageItem.extraAttributeList.length == 2)
				         {
				           description.htmlText += '<b><font size="15" color="#8CB3F5">'+packageItem.name+'</font></b>';
				         }else if(packageItem.extraAttributeList.length == 3)
				         {
				           description.htmlText += '<b><font size="15" color="#E15CEC">'+packageItem.name+'</font></b>';
				         }else
				         {
				           description.htmlText += '<b><font size="15" color="#FDF3D1">'+packageItem.name+'</font></b>';
				         }
				         if(packageItem.itemLevel > 1){
				         	description.htmlText += '  <b><font size="15">(LV.'+packageItem.itemLevel+')</font></b>\n';
				         }else{
				         	description.htmlText += '\n';
				         }				         
				         description.htmlText += '<font color="#DBD2C5">绑定类型:</font>'+packageItem.bindType+(packageItem.isBound == 0?'(未绑定)':'(<font color="#E28BF4">已绑定</font>)')+'\n';
				         description.htmlText += '<font color="#E28BF4">'+packageItem.itemTemplateInfo.description+'</font>\n';
				         description.htmlText += '<font color="#DBD2C5">装备类型:</font>防具 '+armortype+'\n';
				         description.htmlText += '<font color="#DBD2C5">防御力:</font>'+packageItem.itemTemplateInfo.defense+'\n';
				         description.htmlText += '<font color="#DBD2C5">单价:</font>'+packageItem.sellPrice+'\n';
				        description.htmlText += '<font color="#DBD2C5">等级需求:</font>'+(packageItem.itemTemplateInfo.levelRequire <= int(MySelf.instance.level) ? '<font color="#91FB6B">Lv.'+packageItem.itemTemplateInfo.levelRequire+'</font>\n':'<font color="#F75554">Lv.'+packageItem.itemTemplateInfo.levelRequire +'</font>\n');				       				         
				         description.htmlText += '<font color="#DBD2C5">职业需求:</font><font color="#91FB6B">'+packageItem.itemTemplateInfo.professionRequire+'</font>\n';
				         description.htmlText += '<font color="#DBD2C5">属性需求:</font>';
				        if(packageItem.itemTemplateInfo.strRequire != -1)
				         {
				         	if(packageItem.itemTemplateInfo.strRequire <= (MySelf.instance.manualStr+MySelf.instance.baseStr))
				         	   description.htmlText += '<font color="#DBD2C5">武勇:</font><font color="#91FB6B">'+packageItem.itemTemplateInfo.strRequire+'</font>';
				         	else
				         	   description.htmlText += '<font color="#DBD2C5">武勇:</font><font color="#F75554">'+packageItem.itemTemplateInfo.strRequire+'</font>';
				         }				         
				         if(packageItem.itemTemplateInfo.vitRequire != -1)
				         {
				         	if(packageItem.itemTemplateInfo.vitRequire <= (MySelf.instance.manualVit+MySelf.instance.baseVit))
				         	   description.htmlText += '<font color="#DBD2C5">体魄:</font><font color="#91FB6B">'+packageItem.itemTemplateInfo.vitRequire+'</font>';
				         	else
				         	   description.htmlText += '<font color="#DBD2C5">体魄:</font><font color="#F75554">'+packageItem.itemTemplateInfo.vitRequire+'</font>';
				         }
				         
				         if(packageItem.itemTemplateInfo.dexRequire != -1)
				         {
				         	if(packageItem.itemTemplateInfo.dexRequire <= (MySelf.instance.manualDex + MySelf.instance.baseDex))
				         	   description.htmlText += '<font color="#DBD2C5">机警:</font><font color="#91FB6B">'+packageItem.itemTemplateInfo.dexRequire+'</font>';
				         	else
				         	   description.htmlText += '<font color="#DBD2C5">机警:</font><font color="#F75554">'+packageItem.itemTemplateInfo.dexRequire+'</font>';
				         }
				         description.htmlText += '<font color="#DBD2C5">耐久度:</font>'+packageItem.itemTemplateInfo.druability+'\n';
				        		       
				         for(var j:int = 0;j<packageItem.extraAttributeList.length;j++)
						 {				         	
						     description.htmlText += '<font color="#668EEE">'+packageItem.extraAttributeList[j].attributeEffects[0]+'</font>\n';
						 }
						 if(packageItem.itemLevel>1){
						 	
						 	description.htmlText += '<font color="#668EEE">升级效果：体力和法力上限提高'+0.5*(packageItem.itemLevel -1)+'%</font>\n';
						 }
						
				         if(packageType == 1)
				        {
				        	description.htmlText += '<font color="#E28BF4">双击鼠标后使用装备</font>';
				        }else if(packageType == 2)
				        {
				        	description.htmlText += '<font color = "#E28BF4">双击鼠标后卸载装备</font>';
				        }
				         addChild(description);
				       }
				       else
				       {
//				       	  description.width = 220;
				         description.htmlText += '<font size="15" color="#DBD2C5"><b>'+packageItem.itemTemplateInfo.name+'</b></font>'+'X'+packageItem.stack+'\n';
				         description.htmlText += '<font color="#E28BF4">'+packageItem.itemTemplateInfo.description+'</font>\n';			        
				         description.htmlText += '<font color="#DBD2C5">单价:</font>'+packageItem.sellPrice+'\n';
				         if(packageType !=1 && packageType != 2)
				         description.htmlText += '<font color="#E28BF4">双击鼠标直接使用</font>';
				         addChild(description);
				       }
				       break;
		        case 2:
//		               description.width = 220;
		               if(skill.skillInfo.type == 1)
		               {
		               	description.htmlText += '<font size="15" color="#FDF3D1"><b>'+skill.skillInfo.name+'</b></font><font size="15" color="#DBD2C5">(主动技能)</font>\n';
		               	description.htmlText += '<font color="#DBD2C5">当前等级:</font>'+skill.skillInfo.level+'\n<font color="#DBD2C5">最高可修炼等级:</font>'+skill.skillInfo.maxLevel+'\n';
		               	description.htmlText += '<font color="#E28BF4">'+skill.skillInfo.description+'</font>\n';
		               	description.htmlText += '<font color="#DBD2C5">发动几率:</font>'+int(skill.skillInfo.useRate/1000)+'%\n';
		               	description.htmlText += '<font color="#DBD2C5">技能消耗:</font>'+skill.skillInfo.useMp+'\n';
		               	description.htmlText += skill.effects[0]+'\n';
		               	description.htmlText += '<font color="#DBD2C5">修炼条件</font>('+(skill.skillInfo.levelRequire <= MySelf.instance.level ? '<font color="#91FB6B">达成</font>':'<font color="#F75554">未达成</font>')+')\n';
		               
		               }else if(skill.skillInfo.type == 2)
		               {
		               	description.htmlText += '<font size="15" color="#FDF3D1"><b>'+skill.skillInfo.name+'</b></font><font size="15" color="#DBD2C5">(辅助技能)</font>\n';
		               	description.htmlText += '<font color="#DBD2C5">当前等级:</font>'+skill.skillInfo.level+'\n<font color="#DBD2C5">最高可修炼等级:</font>'+skill.skillInfo.maxLevel+'\n';
		               	description.htmlText += '<font color="#E28BF4">'+skill.skillInfo.description+'</font>\n';
		               	description.htmlText += '<font color="#DBD2C5">发动几率:</font>'+int(skill.skillInfo.useRate/1000)+'%\n';
		               	description.htmlText += '<font color="#DBD2C5">技能消耗:</font>'+skill.skillInfo.useMp+'\n';
		               	description.htmlText += skill.effects[0]+'\n';
		               	description.htmlText += '<font color="#DBD2C5">修炼条件</font>('+(skill.skillInfo.levelRequire <= MySelf.instance.level ? '<font color="#91FB6B">达成</font>':'<font color="#F75554">未达成</font>')+')\n';
		               
		               }else
		               {
		               	description.htmlText += '<font size="15" color="#FDF3D1"><b>'+skill.skillInfo.name+'</b></font><font size="15" color="#DBD2C5">(被动技能)</font>\n';
		               	description.htmlText += '<font color="#DBD2C5">当前等级:</font>'+skill.skillInfo.level+'\n<font color="#DBD2C5">最高可修炼等级:</font>'+skill.skillInfo.maxLevel+'\n';
		               	description.htmlText += '<font color="#E28BF4">'+skill.skillInfo.description+'</font>\n';
		               	description.htmlText += '<font color="#DBD2C5">发动几率:</font>'+int(skill.skillInfo.useRate/1000)+'%\n';
		               	description.htmlText += '<font color="#DBD2C5">技能消耗:</font>'+skill.skillInfo.useMp+'\n';
		               	description.htmlText += skill.effects[0]+'\n';
		               	description.htmlText += '<font color="#DBD2C5">修炼条件</font>('+(skill.skillInfo.levelRequire <= MySelf.instance.level ? '<font color="#91FB6B">达成</font>':'<font color="#F75554">未达成</font>')+')\n';
		               
		               }	
		               switch(skill.skillInfo.skillProfession)
		               {
		               	  case 1:
		               	         description.htmlText += '<font color="#DBD2C5">职业:</font><font color="#91FB6B">武士系</font>';
		               	         break;
		               	  case 2:
		               	         description.htmlText += '<font color="#DBD2C5">职业:</font><font color="#91FB6B">侠士系</font>';
		               	         break;
		               	  case 3:
		               	         description.htmlText += '<font color="#DBD2C5">职业:</font><font color="#91FB6B">谋士系</font>';
		               	         break;
		               	  case 4:
		               	         description.htmlText += '<font color="#DBD2C5">职业:</font><font color="#91FB6B">术士系</font>';
		               	         break;
		               	  case 5:
		               	         description.htmlText += '<font color="#DBD2C5">职业:</font><font color="#91FB6B">卫士系</font>';
		               	         break;
		               	  case 6:
		               	         description.htmlText += '<font color="#DBD2C5">职业:</font><font color="#91FB6B">勇士系</font>';
		               	         break;
		               }	               	
		               	
		               	description.htmlText += '<font color="#DBD2C5">等级:</font><font color="#91FB6B">LV'+skill.skillInfo.levelRequire;
		               	description.htmlText += '<font color="#DBD2C5">费用:</font><font color="#91FB6B">'+skill.skillInfo.useCoin+'</font>';
		               	addChild(description);
		               break;
		        case 3:
//		               description.width = 220;
		               if(progressId == 'strcanvas')
		               {
		               	   description.htmlText += '<font color="#DBD2C5">武勇可以提升角色攻击力</font>\n';
			               if(MySelf.instance.profession == '无职业')
			               {				               	
					         description.htmlText += '<font color="#DBD2C5">当前武勇:</font>'+(MySelf.instance.baseStr+MySelf.instance.manualStr);
					         if( MySelf.instance.extraStr != 0)
					         {
					         	description.htmlText += '+<font color="#E15CEC">'+MySelf.instance.extraStr+'</font>';
					         }					         		
					         description.htmlText += '(攻击力:+'+Number((MySelf.instance.baseStr+MySelf.instance.manualStr)*0.1).toFixed(2)+'%)';	
					         addChild(description);			               
			               }
			               else if(MySelf.instance.profession == '卫士系' || MySelf.instance.profession == '勇士系')
			               {
			               	 description.htmlText += '<font color="#DBD2C5">当前武勇:</font>'+(MySelf.instance.baseStr+MySelf.instance.manualStr);
					         if( MySelf.instance.extraStr != 0)
					         {
					         	description.htmlText += '+<font color="#E15CEC">'+MySelf.instance.extraStr+'</font>';
					         }					         		
					         description.htmlText += '(攻击力:+'+Number((MySelf.instance.baseStr+MySelf.instance.manualStr)*0.3).toFixed(2)+'%)';	
					         addChild(description);		
			               }
			               else if(MySelf.instance.profession == '武士系' || MySelf.instance.profession == '侠士系')
			               {
			               	 description.htmlText += '<font color="#DBD2C5">当前武勇:</font>'+(MySelf.instance.baseStr+MySelf.instance.manualStr);
					         if( MySelf.instance.extraStr != 0)
					         {
					         	description.htmlText += '+<font color="#E15CEC">'+MySelf.instance.extraStr+'</font>';
					         }					         		
					         description.htmlText += '(攻击力:+'+Number((MySelf.instance.baseStr+MySelf.instance.manualStr)*0.2).toFixed(2)+'%)';	
					         addChild(description);		
			               }
			               else
			               {
			               	 description.htmlText += '<font color="#DBD2C5">当前武勇:</font>'+(MySelf.instance.baseStr+MySelf.instance.manualStr);
					         if( MySelf.instance.extraStr != 0)
					         {
					         	description.htmlText += '+<font color="#E15CEC">'+MySelf.instance.extraStr+'</font>';
					         }					         		
					         description.htmlText += '(攻击力:+'+Number((MySelf.instance.baseStr+MySelf.instance.manualStr)*0.1).toFixed(2)+'%)';	
					         addChild(description);		
			               }
		               }else if(progressId == 'dexcanvas')
		               {
		               	description.htmlText += '<font color="#DBD2C5">机警可以提升角色提升角色攻击力和闪避率</font>\n';
		               	if(MySelf.instance.profession == '无职业')
		               	{
		               		description.htmlText += '<font color="#DBD2C5">当前机警:</font>'+(MySelf.instance.baseDex+MySelf.instance.manualDex);
		               		if(MySelf.instance.extraDex != 0)
		               		{
		               			description.htmlText +='+<font color="#E15CEC">'+MySelf.instance.extraDex+'</font>';
		               		} 		               			
		               		description.htmlText +=	'(攻击力:+'+Number((MySelf.instance.baseDex+MySelf.instance.manualDex)*0.1).toFixed(2)+'%)'+'\n(闪避:+'+Number((MySelf.instance.baseDex+MySelf.instance.manualDex)*0.1).toFixed(2)+'%)';
		                    addChild(description);
		               	}
		               	else if(MySelf.instance.profession == '勇士系'|| MySelf.instance.profession == '卫士系')
		               	{
		               		description.htmlText += '<font color="#DBD2C5">当前机警:</font>'+(MySelf.instance.baseDex+MySelf.instance.manualDex);
		               		if(MySelf.instance.extraDex != 0)
		               		{
		               			description.htmlText +='+<font color="#E15CEC">'+MySelf.instance.extraDex+'</font>';
		               		} 		               			
		               		description.htmlText +=	'(攻击力:+'+Number((MySelf.instance.baseDex+MySelf.instance.manualDex)*0.1).toFixed(2)+'%)'+'\n(闪避:+'+Number((MySelf.instance.baseDex+MySelf.instance.manualDex)*0.12).toFixed(2)+'%)';
		                    addChild(description);
		               	}
		               	else if(MySelf.instance.profession == '武士系'|| MySelf.instance.profession == '侠士系')
		               	{
		               		description.htmlText += '<font color="#DBD2C5">当前机警:</font>'+(MySelf.instance.baseDex+MySelf.instance.manualDex);
		               		if(MySelf.instance.extraDex != 0)
		               		{
		               			description.htmlText +='+<font color="#E15CEC">'+MySelf.instance.extraDex+'</font>';
		               		} 		               			
		               		description.htmlText +=	'(攻击力:+'+Number((MySelf.instance.baseDex+MySelf.instance.manualDex)*0.2).toFixed(2)+'%)'+'\n(闪避:+'+Number((MySelf.instance.baseDex+MySelf.instance.manualDex)*0.12).toFixed(2)+'%)';
		                    addChild(description);
		               	}
		               	else
		               	{
		               		description.htmlText += '<font color="#DBD2C5">当前机警:</font>'+(MySelf.instance.baseDex+MySelf.instance.manualDex);
		               		if(MySelf.instance.extraDex != 0)
		               		{
		               			description.htmlText +='+<font color="#E15CEC">'+MySelf.instance.extraDex+'</font>';
		               		} 		               			
		               		description.htmlText +=	'(攻击力:+'+Number((MySelf.instance.baseDex+MySelf.instance.manualDex)*0.3).toFixed(2)+'%)'+'\n(闪避:+'+Number((MySelf.instance.baseDex+MySelf.instance.manualDex)*0.12).toFixed(2)+'%)';
		                    addChild(description);
		               	}
		               }else
		               {
		               	description.htmlText += '<font color="#DBD2C5">体魄可以提升角色体力和法力上限</font>\n';
		               	description.htmlText += '<font color="#DBD2C5">当前体魄:</font>'+(MySelf.instance.baseVit+MySelf.instance.manualVit);
		               	if(MySelf.instance.extraVit != 0)
		               	{
		               		description.htmlText += '+<font color="#E15CEC">'+MySelf.instance.extraVit+'</font>';
		               	}		               
		               	description.htmlText += '(体力:+'+Number((MySelf.instance.baseVit+MySelf.instance.manualVit)*1).toFixed(2)+'%)'+'\n(法力:+'+Number((MySelf.instance.baseVit+MySelf.instance.manualVit)*1).toFixed(2)+'%)';
		                addChild(description);
		               }
		               break;
		         case 4:		                 
//		                 description.width = 220;
		                 description.htmlText += '<font size="15">'+effect.name+'</font>\n';
		                 description.htmlText += '<font color="#DF01D7">'+effect.description+'</font>\n';
		                 description.htmlText += '剩余时间: '+timeString.substring(0,timeString.lastIndexOf(':'));		                 
		                 addChild(description);
		                 break;
		         case 5:
//		                 description.width = 220;
		                if(progressId == 'hpcanvas')
		                {
		                   description.htmlText += '<font color="#DBD2C5">当前气血:</font>'+MySelf.instance.hp+'/'+MySelf.instance.maxHp;	
		                   addChild(description);
		                }else if(progressId == 'mpcanvas')
		                {
		                   description.htmlText += '<font color="#DBD2C5">当前内息:</font>'+MySelf.instance.mp+'/'+MySelf.instance.maxMp;	
		                   addChild(description);
		                }else
		                {
		                   description.htmlText += '<font color="#DBD2C5">等级:</font>Lv.'+MySelf.instance.level+'/当前等级上限Lv.30\n';
		                   description.htmlText += '<font color="#DBD2C5">经验:</font>'+MySelf.instance.exp+'/'+MySelf.instance.maxExp;
		                   addChild(description);
		                }
		                break;
		         case 6:
//		                 description.width = 220;
		                 description.htmlText = '<font color="#DBD2C5">'+cityInfo+'</font>';
		                 addChild(description);
		                 break;
		         case 7:
//		                 description.width = 150;
		                 description.htmlText = '<font color="#DBD2C5">您当前的位置在</font>'+tip;
		                 addChild(description);
		                 break;
		         case 8:
//		                 description.width = 220;
		                 if(progressId == 'hitRate')
		                    description.htmlText = '<font color="#DBD2C5">命中率:</font>额外加'+MySelf.instance.hitRate+'%几率命中对手';
		                 else if(progressId == 'criRate')
		                    description.htmlText = '<font color="#DBD2C5">暴击率:</font>'+MySelf.instance.criRate+'%的几率给对手造成1.5倍的伤害';
		                 else if(progressId == 'dodgeRate')
		                    description.htmlText = '<font color="#DBD2C5">躲闪率:</font>'+MySelf.instance.dodgeRate+'%的几率躲避对手的攻击';
		                 else if(progressId == 'bogeyRate')
		                    description.htmlText = '<font color="#DBD2C5">破击率:</font>'+MySelf.instance.bogeyRate+'%的几率无视对手防御';
		                 else if(progressId == 'attack')
		                    description.htmlText = '<font color="#DBD2C5">攻击力决定了人物战斗时能造成的伤害</font>';
		                 else if(progressId == 'guard')
		                    description.htmlText = '<font color="#DBD2C5">防御力决定了人物在战斗时能减免的伤害</font>';
		                 else if(progressId == 'speed')
		                    description.htmlText = '<font color="#DBD2C5">速度决定了在战斗中可出手的次数</font>';
		                 addChild(description);
		                 break;
			}
		}
		
		
		public function otherInit(num:int,obj:Object):void
		{
			var description:Text = new Text();
			switch(num)
			{
				
		        case 1:
		               
//		               description.width = 220;
		               if(progressId == 'str')
		               {
		               	   description.htmlText += '<font color="#DBD2C5">武勇可以提升角色攻击力</font>\n';
			               if(obj.profession == '无职业')
			               {				               	
					         description.htmlText += '<font color="#DBD2C5">当前武勇:</font>'+(obj.baseStr+obj.manualStr)+'(攻击力:+'+(obj.baseStr+obj.manualStr)*0.1+'%)';	
					          addChild(description);			               
			               }
			               else if(obj.profession == '卫士系' || obj.profession == '勇士系')
			               {
			               	 description.htmlText +='<font color="#DBD2C5">当前武勇:</font>'+(obj.baseStr+obj.manualStr)+'(攻击力:+'+(obj.baseStr+obj.manualStr)*0.3+'%)';				             
			                  addChild(description);
			               }
			               else if(obj.profession == '武士系' || obj.profession == '侠士系')
			               {
			               	 description.htmlText += '<font color="#DBD2C5">当前武勇:</font>'+(obj.baseStr+obj.manualStr)+'(攻击力:+'+(obj.baseStr+obj.manualStr)*0.2+'%)';
			                  addChild(description);
			               }
			               else
			               {
			               	 description.htmlText += '<font color="#DBD2C5">当前武勇:</font>'+(obj.baseStr+obj.manualStr)+'(攻击力:+'+(obj.baseStr+obj.manualStr)*0.1+'%)';
			                  addChild(description);
			               }
		               }else if(progressId == 'dex')
		               {
		               	description.htmlText += '<font color="#DBD2C5">机警可以提升角色提升角色攻击力和闪避率</font>\n';
		               	if(obj.profession == '无职业')
		               	{
		               		description.htmlText += '<font color="#DBD2C5">当前机警:</font>'+(obj.baseDex+obj.manualDex)+'(攻击力:+'+(obj.baseDex+obj.manualDex)*0.1+'%)'+'\n(闪避:+'+(obj.baseDex+obj.manualDex)*0.1+'%)';
		                     addChild(description);
		               	}
		               	else if(obj.profession == '勇士系'|| obj.profession == '卫士系')
		               	{
		               		description.htmlText += '<font color="#DBD2C5">当前机警:</font>'+(obj.baseDex+obj.manualDex)+'(攻击力:+'+(obj.baseDex+obj.manualDex)*0.1+'%)'+'\n(闪避:+'+(obj.baseDex+obj.manualDex)*0.12+'%)';
		               	     addChild(description);
		               	}
		               	else if(obj.profession == '武士系'|| obj.profession == '侠士系')
		               	{
		               		description.htmlText += '<font color="#DBD2C5">当前机警:</font>'+(obj.baseDex+obj.manualDex)+'(攻击力:+'+(obj.baseDex+obj.manualDex)*0.2+'%)'+'\n(闪避:+'+(obj.baseDex+obj.manualDex)*0.12+'%)';
		               	    addChild(description);
		               	}
		               	else
		               	{
		               		description.htmlText += '<font color="#DBD2C5">当前机警:</font>'+(obj.baseDex+obj.manualDex)+'(攻击力:+'+(obj.baseDex+obj.manualDex)*0.3+'%)'+'\n(闪避:+'+(obj.baseDex+obj.manualDex)*0.12+'%)';
		                    addChild(description);
		               	}
		               }else
		               {
		               	description.htmlText += '<font color="#DBD2C5">体魄可以提升角色体力和法力上限</font>\n';
		               	description.htmlText += '<font color="#DBD2C5">当前体魄:</font>'+(obj.baseVit+obj.manualVit)+'(体力:+'+(obj.baseVit+obj.manualVit)*1+'%)'+'\n(法力:+'+(obj.baseVit+obj.manualVit)*1+'%)';
		                addChild(description);
		               }
		               break;
		         case 2:
//		                 description.width = 220;
		                if(progressId == 'hp')
		                {
		                   description.htmlText += '<font color="#DBD2C5">当前气血:</font>'+obj.hp+'/'+obj.maxHp;	
		                   addChild(description);
		                }else if(progressId == 'mp')
		                {
		                   description.htmlText += '<font color="#DBD2C5">当前内息:</font>'+obj.mp+'/'+obj.maxMp;	
		                   addChild(description);
		                }else
		                {
		                   description.htmlText += '<font color="#DBD2C5">等级:</font>Lv.'+obj.level+'/当前等级上限Lv.30\n';
		                   description.htmlText += '<font color="#DBD2C5">经验:</font>'+obj.exp+'/'+obj.maxExp;
		                   addChild(description);
		                }
		                break;
		         case 3:
//		                 description.width = 220;
		                 if(progressId == 'hitRate')
		                    description.htmlText = '<font color="#DBD2C5">命中率:</font>额外加'+obj.hitRate+'%几率命中对手';
		                 else if(progressId == 'criRate')
		                    description.htmlText = '<font color="#DBD2C5">暴击率:</font>'+obj.criRate+'%的几率给对手造成1.5倍的伤害';
		                 else if(progressId == 'dodgeRate')
		                    description.htmlText = '<font color="#DBD2C5">躲闪率:</font>'+obj.dodgeRate+'%的几率躲避对手的攻击';
		                 else if(progressId == 'bogeyRate')
		                    description.htmlText = '<font color="#DBD2C5">破击率:</font>'+obj.bogeyRate+'%的几率无视对手防御';
		                 else if(progressId == 'attack')
		                    description.htmlText = '<font color="#DBD2C5">攻击力决定了人物战斗时能造成的伤害</font>';
		                 else if(progressId == 'guard')
		                    description.htmlText = '<font color="#DBD2C5">防御力决定了人物在战斗时能减免的伤害</font>';
		                 else if(progressId == 'speed')
		                    description.htmlText = '<font color="#DBD2C5">速度决定了在战斗中可出手的次数</font>';
		                 addChild(description);
		                 break;
			}
		}
		
	}
}