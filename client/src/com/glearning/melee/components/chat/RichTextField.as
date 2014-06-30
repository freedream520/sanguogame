package com.glearning.melee.components.chat
{
	import fl.controls.UIScrollBar;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	public class RichTextField extends Sprite
	{
		[Bindable] 
		[Embed("/images/sanGuo/down2.gif")] 
		public var downArrowDisabledSkin:Class;
		
		[Embed("/images/sanGuo/down1.gif")] 
		public var downArrowDownSkin:Class;
		
		[Embed("/images/sanGuo/down1.gif")] 
		public var downArrowOverSkin:Class;
		
		[Embed("/images/sanGuo/down1.gif")] 
		public var downArrowUpSkin:Class;

        [Embed("/images/sanGuo/up2.gif")] 
		public var upArrowDisabledSkin:Class;
		
		[Embed("/images/sanGuo/up1.gif")] 
		public var upArrowDownSkin:Class;
		
		[Embed("/images/sanGuo/up1.gif")] 
		public var upArrowOverSkin:Class;
		
		[Embed("/images/sanGuo/up1.gif")] 
		public var upArrowUpSkin:Class;
		
		[Embed("/images/sanGuo/bg.png")] 
		public var trackSkin:Class;
		
		[Embed("/images/sanGuo/center1.gif")] 
		public var thumbIcon:Class;
		
		[Embed("/images/sanGuo/squre1.gif",scaleGridTop=2,                 
        scaleGridLeft=2, 
        scaleGridBottom=4, 
        scaleGridRight=4)] 
		public var thumbUpSkin:Class;
		
		[Embed("/images/sanGuo/squre1.gif",scaleGridTop=2,                 
        scaleGridLeft=2, 
        scaleGridBottom=4, 
        scaleGridRight=4)] 
		public var thumbOverSkin:Class;
		
		[Embed("/images/sanGuo/squre1.gif",scaleGridTop=2,                 
        scaleGridLeft=2, 
        scaleGridBottom=4, 
        scaleGridRight=4)] 
		public var thumbDownSkin:Class;
		//the instance of textfield
		private var _textfield:TextField;
		//the default textformat of _textfield
		private var _defaultTextFormat:TextFormat;
		//the length of the _textfield.text
		private var _length:int;
		//only contain sprites which are inserted in _textfield
		public var _spriteContainer:Sprite;
		//specify the sprite's vspace/hspace in _textfield
		private var _spriteVspace:int;
		private var _spriteHspace:int;
		//save the selection begin/end indexes of _textfield
		private var _selectBegin:int;
		private var _selectEnd:int;
		//save the scrollV of the _textfield
		private var _scrollV:int;		
		//the mask of _spriteContainer
		private var _spriteMask:Shape;
		//use it to mark the TextField.replaceText() time during addSprite
		private var _replacing:Boolean;
		//assemble TextFormats of _textfield except placeholders
		private var _format:Dictionary;
		
		//indicates whether the textfield scroll to the bottom line automatically.
		public var autoScroll:Boolean;
		public var autoScrollV:int = 0;
		//indicates line height.
		public var lineHeight:Number;
		public var uis:UIScrollBar = new UIScrollBar();
//        public var uis:VScrollBar = new VScrollBar();
		//specify type of _textfield
		public static const DYNAMIC:String = "dynamic";
		public static const INPUT:String = "input";
		
		
		/**
		 * trick, a sprite's placeholder
		 * special character: ﹒ unicode is 65106
		 * special font: Arial
		 */
		//private var PLACEHOLDER:String = String.fromCharCode(65106);
		private var PLACEHOLDER:String = "﹒";
		private var PLACEHOLDER_FONT:String = "Arial";
		private var PLACEHOLDER_COLOR:uint = 0x000000;
		
		//type of adjust
		private static const ADJUST_TYPE_INSERT:String = "adjust_type_insert";
		private static const ADJUST_TYPE_CHANGE:String = "adjust_type_change";		
		
		
		/**
		 * constructor
		 */
		public function RichTextField(width:Number, height:Number, type:String = DYNAMIC)
		{
			initTextField(width, height);			
			addChild(_textfield);
			

			_spriteContainer = new Sprite();
			addChild(_spriteContainer);				
			_format = new Dictionary();
			//default scrollV is 1
			_scrollV = 1;
			//default lineHeight is 0(ignore)
			lineHeight = 0;
			//default sprite vspace/hspace is 2 (changes to 1, 2009-3-3)
			_spriteHspace = _spriteVspace = 1;		
			//set textfield's type and add event listeners.
			this.type = type;
			
			//create sprite mask.
			_spriteMask = createSpritesMask(_textfield.x, _textfield.y, _textfield.width, _textfield.height);
			addChild(_spriteMask);
			_spriteContainer.mask = _spriteMask;
		}		
		
		
		// ********************** public method *********************************	
		
		/**
		 * append rich text which contains display objects and text format.		 * 
		 * @param	text
		 * @param	object each element should like this {index:1, src:object}
		 * @param	format
		 * @param	autoWordWrap
		 */
		public function appendRichText(text:String, object:Array = null, format:TextFormat = null, autoWordWrap:Boolean = true):void
		{
			if (text)
			{
				appendText(text, format, autoWordWrap);	
			}
			
			if (object)
			{
				for (var i:int = 0; i < object.length; i++)
				{
					var index:int = object[i].index;
					if (index == -1) index = text.length;
					else if (autoWordWrap) index -= 1;
					index += _textfield.length - text.length;					
					//trace("addSprite", object[i].src, index, _textfield.length);
					//the last sprite should be added before newline character(\n).
					//if (autoWordWrap && index == _textfield.length) index --;
					//modified at 12-05-2008
					if (autoWordWrap && index >= _textfield.length) index = _textfield.length - 1;
					//if specify lineHeight(>0), all lines will be same height.
					addSprite(object[i].src, index, -1, lineHeight);
				}
			}
			
			if (autoScroll) scrollTo(_textfield.maxScrollV);
			else if (autoScrollV > 0) scrollTo(autoScrollV);
		}	
		
		public function appendText(text:String, format:TextFormat = null, autoWordWrap:Boolean = true):void
		{
			recoverDefaultTextFormat();
			var addText:String = text;
			if (autoWordWrap) addText += "\n";
			//because the carriage return escape character(\r) has some bug in text copying
			//so change all of them to newline escape character(\n)			
			addText = addText.split("\r").join("\n");
			var start:int = _textfield.length - 1;
			_textfield.appendText(addText);
			if (format)_textfield.setTextFormat(format, start, _textfield.length - 1);
		}
		/**
		 * append rich text with sprites in source.
		 * @param	source
		 * @param	beginIndex
		 * @param	endIndex
		 * @param	autoWordWrap
		 */
		public function appendFromRichText(source:RichTextField, beginIndex:int = -1, endIndex:int = -1, autoWordWrap:Boolean = true):void
		{			
			recoverDefaultTextFormat();
			var newIndex:int = _textfield.text.length;
			if (beginIndex == -1 && endIndex == -1) {
				beginIndex = 0;
				endIndex = source.textfield.text.length - 1;
			}else if (endIndex == -1)
			{
				endIndex = beginIndex;
			}
			//step1. append specify text in source to _textfield
			var addText:String = source.textfield.text.substring(beginIndex, endIndex + 1);
			if (autoWordWrap) addText += "\n";
			//because the carriage return escape character(\r) has some bug in text copying
			//so change all of them to newline escape character(\n)			
			addText = addText.split("\r").join("\n");
			_textfield.appendText(addText);			
			//step2. set textformat if has any textformat in source
			applyTextFormat(source.format, newIndex);			
			//step3. check if has any sprite appended.
			for (var i:int = 0, len:int = addText.length; i < len; i++)
			{
				var char:String = addText.charAt(i);
				if (char == PLACEHOLDER)
				{
					//set corresponding format for placeholder
					//var newSprite:Sprite = source.spriteContainer.getChildByName(String(i)) as Sprite;
					var newSprite:Sprite = source.getSpriteByName(String(i));
					if (newSprite)
					{
						//remove placeholder, then add sprite
						//trace("appendFromRichText Sprite", newSprite, i, newIndex + i);
						_textfield.replaceText(newIndex + i, newIndex + i + 1, "");
						addSprite(newSprite, newIndex + i, newSprite.width, newSprite.height);				
					}			
				}
			}
		}
		
		public function copyFromRichText(source:RichTextField, beginIndex:int = -1, endIndex:int = -1, autoWordWrap:Boolean = true):void
		{			
			recoverDefaultTextFormat();
			var newIndex:int = _textfield.text.length;
			if (beginIndex == -1 && endIndex == -1) {
				beginIndex = 0;
				endIndex = source.textfield.text.length - 1;
			}else if (endIndex == -1)
			{
				endIndex = beginIndex;
			}
			//step1. append specify text in source to _textfield
			var addText:String = source.textfield.text.substring(beginIndex, endIndex + 1);
			if (autoWordWrap) addText += "\n";
			//because the carriage return escape character(\r) has some bug in text copying
			//so change all of them to newline escape character(\n)			
			addText = addText.split("\r").join("\n");
			//_textfield.appendText(addText);			
			_textfield.text = addText;		
			//step2. set textformat if has any textformat in source
			applyTextFormat(source.format, newIndex);			
			//step3. check if has any sprite appended.
			for (var i:int = 0, len:int = addText.length; i < len; i++)
			{
				var char:String = addText.charAt(i);
				if (char == PLACEHOLDER)
				{
					//set corresponding format for placeholder
					//var newSprite:Sprite = source.spriteContainer.getChildByName(String(i)) as Sprite;
					var newSprite:Sprite = source.getSpriteByName(String(i));
					if (newSprite)
					{
						//remove placeholder, then add sprite
						//trace("copyFromRichText Sprite", newSprite, i, newIndex + i);
						_textfield.replaceText(newIndex + i, newIndex + i + 1, "");
						addSprite(newSprite, newIndex + i, newSprite.width, newSprite.height);				
					}			
				}
			}
		}
		 
		/**
		 * add a sprite with a placeholder to the right place
		 * @param	target Class or Sprite instance
		 * @param	width
		 * @param	height
		 * @param	caretIndex
		 */
		public function addSprite(target:*, caretIndex:int = -1, width:Number = -1, height:Number = -1):void
		{			
			//create a target sprite
			var targetClass:Class;
			if (target is Class)
			{
				targetClass = target;
				var newObj:Sprite = new target() as Sprite;
			}else
			{
				//var className:String = getQualifiedClassName(target);
				//targetClass = getDefinitionByName(className) as Class;
				//newObj = new targetClass() as Sprite;
				newObj = target;
			}
			if (width > 0) newObj.width = width;
			if (height > 0) newObj.height = height;
			//insert a placeholder for target and format it
			if (caretIndex == -1) caretIndex = _textfield.caretIndex;
			//fix the bug that supplied index is out of bound, 11-24-2008
			//if caretIndex is out of bound, add sprite to the end.			
			if (caretIndex > _textfield.length) {
				caretIndex = _textfield.length;
			}
			var format:TextFormat = getPlaceholderFormat(newObj.width, newObj.height);		
			//because if use replaceText method, the TextField will scroll incorrectly(scrollV=1)
			//we don't need to adjust the _spriteContainer's position in this scroll time
			//so use _replacing to split this time			
			_replacing = true;
			var oldScrollV:int = _textfield.scrollV;
	
			_textfield.replaceText(caretIndex, caretIndex, PLACEHOLDER);
			_textfield.setTextFormat(format, caretIndex);			
			//srcoll back to the correct line.		
			_textfield.scrollV = oldScrollV;
			_replacing = false;
			
			_spriteContainer.addChild(newObj);
			newObj.name = String(caretIndex);
			
			_length++;
			//adjust sprite's coordinate
			adjustSprites(caretIndex, 1, ADJUST_TYPE_INSERT);
			
			if (autoScroll) scrollTo(_textfield.maxScrollV);
			else if (autoScrollV > 0) scrollTo(autoScrollV);
		}
		
		/**
		 * set a textformat to _textfield, and save it.
		 * if beginIndex=-1 and endIndex=-1, all text will be setted
		 * if beginIndex!=-1 and endIndex=-1, only one char in beginIndex will be setted
		 * @param	format
		 * @param	beginIndex
		 * @param	endIndex
		 */
		public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void
		{			
			if (beginIndex > -1 && beginIndex == endIndex) return;			
			if (endIndex < 0)
			{
				if (beginIndex < 0) endIndex = _textfield.text.length;
				else endIndex = beginIndex + 1;
			}
			if (beginIndex < 0) beginIndex = 0;
			if (endIndex <= beginIndex) return;
			//step1. settextformat
			_textfield.setTextFormat(format, beginIndex, endIndex);
			//step2. recover placeholders' original textformat whose textformat are changed
			recoverPlaceholderFormat(beginIndex, endIndex);
			//step3. save this textformat
			_format[ { begin:beginIndex, end:endIndex } ] = format;
			//step4. adjust sprites' coordinate
			adjustCoordinate(beginIndex, _textfield.text.length - 1);	
		}		
		
		/**
		 * clear all properties, back to original status.
		 */
		public function clear():void
		{
			_textfield.text = "";
			_length = 0;
			_scrollV = 1;
			recoverDefaultTextFormat();
			_format = new Dictionary();
			_spriteContainer.y = 0;
			while (_spriteContainer.numChildren > 0)_spriteContainer.removeChildAt(0);
		}
		
		
		
		// ********************** private method *********************************
		
		/**
		 * monitor the change of scrollV and adjust the _spriteContainer's coordinate
		 * @param	evt
		 */
		private function scrollHandler(evt:Event):void
		{			
			if (!_replacing)
			{									
				var scrollDirection:int = _textfield.scrollV > _scrollV ? 1 : -1;
				var begin:int = scrollDirection > 0 ? (_textfield.scrollV - 2) : (_scrollV - 2);
				var end:int = scrollDirection > 0 ? (_scrollV - 2) : (_textfield.scrollV - 2);
				var scrollHeight:Number = 0;
				for (var i:int = begin; i > end; i--)
				{
					scrollHeight += _textfield.getLineMetrics(i).height;						
				}
				//make sure sprite container's y <= 0
				var newY:Number = _spriteContainer.y - scrollDirection * scrollHeight;
				_spriteContainer.y = newY <= 0 ? newY : 0;
				//trace("scroll", scrollDirection, _scrollV, _textfield.scrollV, scrollDirection * scrollHeight, newY);				
			}
			
			//if (_replacing && _textfield.scrollV == 1) return;
			_scrollV = _textfield.scrollV;
			//trace("set _scrollV", _scrollV);
		}		
		
		private function scrollTo(line:int):void
		{
			if (_textfield.scrollV != line)
			{
				_textfield.scrollV = line;
			}
		}
		
		/**
		 * monitor the selection range of _textfield
		 * @param	evt
		 */
		private function getSelectionHandler(evt:MouseEvent):void
		{
			_selectBegin = _textfield.selectionBeginIndex;
			_selectEnd = _textfield.selectionEndIndex;
			//trace("get selection:", _selectBegin, _selectEnd);
		}
		
		/**
		 * monitor the input of _textfield
		 * @param	evt
		 */
		private function inputHandler(evt:Event):void
		{			
			recoverDefaultTextFormat();
		}		
		
		/**
		 * monitor the change of _textfield and adjust all sprites
		 * @param	evt
		 */
		private function changeHandler(evt:Event):void
		{			
			var offset:int = _textfield.length - _length;
			//trace("change:", _length, _textfield.length, offset, _textfield.caretIndex);
			_length = _textfield.length;
			var caretIndex:int = _textfield.caretIndex;			
			//only delete text want to check whether the sprite is exist
			if (offset < 0)
			{
				checkSpriteExist(_textfield.caretIndex, offset);
				adjustSprites(_textfield.caretIndex, offset, ADJUST_TYPE_CHANGE);
			}else
			{
				adjustSprites(_textfield.caretIndex - offset + 1, offset, ADJUST_TYPE_CHANGE);
			}
		}
		
		/**
		 * check if has sprite placeholders removed in specific caretIndex
		 * @param	caretIndex
		 * @param	offset
		 */
		private function checkSpriteExist(caretIndex:int, offset:int):void
		{				
			var begin:int = caretIndex + offset + 1;
			var end:int = caretIndex + 1;
			//if is selection deleted, adjust begin and end			
			if (offset < -1 && _selectBegin != _selectEnd)
			{
				//trace("selection:", _selectBegin, _selectEnd);
				begin = _selectBegin;
				end = _selectEnd;
			}
			//check sprite status from begin to end
			for (var i:int = begin; i < end; i++)
			{
				var checkObj:Sprite = _spriteContainer.getChildByName(String(i)) as Sprite;
				if (checkObj)
				{
					var index:int = _spriteContainer.getChildIndex(checkObj);
					//trace("remove ", i, getSpriteIndexAt(index), caretIndex, offset, begin, end);
					_spriteContainer.removeChild(checkObj);	
				}
			}
		}	
		
		/**
		 * adjust the position of sprite if need
		 * @param	caretIndex the caret index of the change place
		 * @param	offset whether plus or minus
		 * @type default is ADJUST_TYPE_CHANGE
		 */
		private function adjustSprites(caretIndex:int, offset:int = 1, type:String = ADJUST_TYPE_CHANGE):void
		{			
			var insertStatus:Boolean = true;
			for (var i:int = 0, len:int = numSprite; i < len; i++)
			{				
				var caret:int = getSpriteIndexAt(i);					
				//these sprites before current sprite don't needed to adjust				
				if (caret < caretIndex - 1) continue;
				else if (caret == caretIndex && type == ADJUST_TYPE_CHANGE) caret = caret + offset;
				else if (caret == caretIndex - 1 && type == ADJUST_TYPE_CHANGE && offset < 0) continue;				
				else if (caret == caretIndex - 1 && type == ADJUST_TYPE_CHANGE && offset > 0) caret = caret + offset;
				else if (caret == caretIndex - 1 && type == ADJUST_TYPE_INSERT) caret = caret;
				else if (caret == caretIndex && type == ADJUST_TYPE_INSERT)
				{
					//check if there is a sprite/PLACEHOLDER at caretIndex + 1
					if (insertStatus && _textfield.text.charAt(caretIndex + 1) == PLACEHOLDER)
					{
						//this check is not very exactly, just ok.
						if (_textfield.getTextFormat(caretIndex + 1).letterSpacing != 0)
						{
							caret = caret + offset;
							insertStatus = false;
						}						
					}else
					{						
						insertStatus = true;
					}
				}				
				else if (caret != caretIndex) caret = caret + offset;				
				var adjustObj:Sprite = _spriteContainer.getChildAt(i) as Sprite;
				var rectPlaceholder:Rectangle = getCharBoundaries(caret);			
				//trace("rectPlaceholder: " + rectPlaceholder);
				if (adjustObj && rectPlaceholder)
				{																
					//adjust name and coordinate
					//trace("adjustObj", adjustObj, i, caret, caretIndex);
					adjustObj.name = String(caret);					
					setSpriteCoordinate(adjustObj, rectPlaceholder);	
				}
			}
		}		
		
		/**
		 * check if has any placeholder from beginIndex to endIndex
		 * then recover these placeholders' original textformat
		 * @param	beginIndex
		 * @param	endIndex
		 */
		private function recoverPlaceholderFormat(beginIndex:int, endIndex:int):void
		{
			for (var i:int = beginIndex; i < endIndex; i++)
			{
				if (_textfield.text.charAt(i) == PLACEHOLDER)
				{
					var sprite:Sprite = _spriteContainer.getChildByName(String(i)) as Sprite;
					if (!sprite) continue;
					var format:TextFormat = getPlaceholderFormat(sprite.width, sprite.height);
					_textfield.setTextFormat(format, i);
				}
			}
		}
		
		/**
		 * return a textformat for placeholder corresponding to the given width and height.
		 * @param	width
		 * @param	height
		 * @return
		 */
		private function getPlaceholderFormat(width:Number, height:Number):TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.font = PLACEHOLDER_FONT;
			format.color = PLACEHOLDER_COLOR;
			format.size = height + 2 * _spriteVspace;
			format.underline = false;			
			format.letterSpacing = width - height - 2 * _spriteVspace + 2 * _spriteHspace;
			//trace(width, height, format.size, format.letterSpacing);
			return format;
		}		
		
		/**
		 * recover the default textformat
		 */
		private function recoverDefaultTextFormat():void
		{
			if (_defaultTextFormat) defaultTextFormat = _defaultTextFormat;			
		}
		
		/**
		 * adjust sprite's coordinate from beginIndex to endIndex
		 * @param	beginIndex
		 * @param	endIndex
		 */
		private function adjustCoordinate(beginIndex:int = -1, endIndex:int = -1):void
		{			
			for (var i:int = 0, len:int = _spriteContainer.numChildren; i < len; i++)
			{
				var sprite:Sprite = _spriteContainer.getChildAt(i) as Sprite;
				var spriteIndex:int = int(sprite.name);
				if (beginIndex <= spriteIndex && endIndex >= spriteIndex)
				{
					var rectPlaceholder:Rectangle = getCharBoundaries(spriteIndex);
					//trace("adjustCoordinate", sprite, spriteIndex, rectPlaceholder);
					if (rectPlaceholder) setSpriteCoordinate(sprite, rectPlaceholder);
				}
			}
		}
		
		/**
		 * set target sprite to the right coordinate, according to the rectangle of it's placeholder
		 * @param	target
		 * @param	rectPlaceholder
		 */
		private function setSpriteCoordinate(target:Sprite, rectPlaceholder:Rectangle):void
		{
			target.x = _spriteContainer.x + rectPlaceholder.left + _spriteHspace;
			target.y = rectPlaceholder.top + rectPlaceholder.height - target.height - _spriteVspace;
			//trace("setSpriteCoordinate", _spriteContainer.y, _textfield.textHeight, rectPlaceholder);
		}
		
		/**
		 * replace the textfield's getCharBoundaries method
		 * get char boundaries in the specify char index
		 * @param	charIndex
		 * @return
		 */
		private function getCharBoundaries(charIndex:int):Rectangle
		{
			var rect:Rectangle = _textfield.getCharBoundaries(charIndex);
			if (!rect)
			{
				//because only display text can get getCharBoundaries in textfield
				//so we should scroll to the line of this PLACEHOLDER first
				//then calculate the boundary of this PLACEHOLDER, scroll back at last
				var objLine:int = _textfield.getLineIndexOfChar(charIndex);
				if (_textfield.bottomScrollV < objLine)
				{
					var oldScrollV:int = _textfield.scrollV;
					_textfield.scrollV = objLine;
					rect = _textfield.getCharBoundaries(charIndex);
					_textfield.scrollV = oldScrollV;
				}
			}
			return rect;
		}		
		
		/**
		 * apply textformats in formatDict, start from startIndex
		 * @param	formatDict
		 * @param	startIndex
		 */
		private function applyTextFormat(formatDict:Dictionary, startIndex:int):void
		{
			for (var flag:Object in formatDict)
			{
				var beginIndex:int = flag.begin + startIndex;
				var endIndex:int = flag.end + startIndex;
				setTextFormat(formatDict[flag], beginIndex, endIndex);
			}
		}
		
		/**
		 * use TextField.setSelection 
		 * @param	caretIndex
		 */
		public function setCaretIndex(caretIndex:int):void
		{
			_textfield.setSelection(caretIndex, caretIndex);
		}
		
		/**
		 * initialize the _textfield
		 * @param	width
		 * @param	height
		 * @param	type
		 */
		private function initTextField(width:Number, height:Number):void
		{
			_textfield = new TextField();	
		    
			_textfield.width = width;
			_textfield.height = height;
			//default multiline and wordWrap are true
			_textfield.multiline = true;
			_textfield.wordWrap = true;
			//for test view
			//_textfield.border = true;			
			//restriction of inserting placeholder
			_textfield.restrict = "^" + PLACEHOLDER;
//			_textfield.addEventListener(TextEvent.TEXT_INPUT,assignScrollBar);
//			assignScrollBar()

		}
		
		//textfield每次输入信息 对滚动条的位置进行判断
		public function assignScrollBar():void
         {                	       
			uis.move(_textfield.x+_textfield.width,_textfield.y);          
			uis.setSize(uis.width,_textfield.height);          			       
			uis.scrollTarget = _textfield;         
			addChild(uis);          
			uis.update(); 
			uis.scrollPosition = uis.maxScrollPosition; 
			
			uis.setStyle('thumbDownSkin',thumbDownSkin);
			uis.setStyle('thumbOverSkin',thumbOverSkin);
			uis.setStyle('thumbUpSkin',thumbUpSkin);
			uis.setStyle('trackDisabledSkin',trackSkin);
			uis.setStyle('trackOverSkin',trackSkin);
			uis.setStyle('trackUpSkin',trackSkin);
			uis.setStyle('downArrowDisabledSkin',downArrowDisabledSkin);
			uis.setStyle('downArrowDownSkin',downArrowDownSkin);
			uis.setStyle('downArrowOverSkin',downArrowOverSkin);
			uis.setStyle('downArrowUpSkin',downArrowUpSkin);
			uis.setStyle('upArrowDisabledSkin',upArrowDisabledSkin);
			uis.setStyle('upArrowDownSkin',upArrowDownSkin);
			uis.setStyle('upArrowOverSkin',upArrowOverSkin);
			uis.setStyle('upArrowUpSkin',upArrowUpSkin);
		 }  
		
		/**
		 * create a mask of _spriteContainer
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @return
		 */
		private function createSpritesMask(x:Number, y:Number, width:Number, height:Number):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xFF0000);
			shape.graphics.lineStyle(0, 0x000000);
			shape.graphics.drawRect(x, y, width, height);
			shape.graphics.endFill();
			return shape;
		}
		
		public function resize(width:Number, height:Number):void
		{
			_textfield.width = _spriteMask.width = width;
			_textfield.height = _spriteMask.height = height;			
			adjustCoordinate(0, _textfield.length);
		}		
		
		public function replace(value:String, repl:String, beginIndex:int, endIndex:int):void
		{
			value = value.split(PLACEHOLDER).join("");	
			repl = repl.split(PLACEHOLDER).join("");	
			_textfield.text = _textfield.text.substring(0, beginIndex) + _textfield.text.substring(beginIndex, endIndex).split(value).join(repl) + _textfield.text.substring(endIndex);			
			_length += repl.length - value.length;
			recoverPlaceholderFormat(0, length);
		}
		
		
		// ********************** getters & setters *********************************
		
		
		/**
		 * instance of textfield
		 */
		public function get textfield():TextField
		{
			return _textfield;
		}
		
		public function get length():int
		{
			return _textfield.text.length;
		}
		
		public function get textLength():int
		{
			return text.length;
		}
		
		public function get text():String
		{
			return _textfield.text.split(PLACEHOLDER).join("");
		}		
		
		public function set text(value:String):void
		{
			value = value.split(PLACEHOLDER).join("");
			_textfield.text = value;
			assignScrollBar();
		}
		
		public function isSprite(index:int):Boolean
		{
			if (index < 0 || index >= length) return false;
			return _textfield.text.charAt(index) == PLACEHOLDER;
		}
		
		public function testString(str:String):Boolean
		{
			return str.indexOf(PLACEHOLDER) == -1;
		}
		
		public function get format():Dictionary
		{
			return _format;
		}
		
		public function get numSprite():int
		{
			return _spriteContainer.numChildren;
		}
		
		public function getSpriteIndexAt(depth:int):int
		{			
			var sprite:Sprite = getSpriteAt(depth);
			if (sprite) return int(sprite.name);
			else return -1;
		}
		
		public function getSpriteAt(depth:int):Sprite
		{
			if (depth >= _spriteContainer.numChildren) return null;
			return _spriteContainer.getChildAt(depth) as Sprite;
		}	
		
		public function getSpriteByName(name:String):Sprite
		{
			return _spriteContainer.getChildByName(name) as Sprite;			
		}
		
		public function removeSpriteByName(name:String):void
		{
			var sp:Sprite = _spriteContainer.getChildByName(name) as Sprite;
			if (sp)
			{
				_spriteContainer.removeChild(sp);
			}
		}
		
		public function set spriteVspace(value:int):void
		{
			_spriteVspace = value;
		}
		
		public function set spriteHspace(value:int):void
		{
			_spriteHspace = value;
		}
		
		public function set defaultTextFormat(format:TextFormat):void
		{
			//set the default textformat and effect immediately
			if (format.letterSpacing == null) format.letterSpacing = 0;
			_defaultTextFormat = format;
			_textfield.defaultTextFormat = format;
		}
		
		public function get defaultTextFormat():TextFormat
		{
			return _defaultTextFormat;
		}
		
		public function set placeholderColor(value:uint):void
		{
			PLACEHOLDER_COLOR = value;
		}
		
		public function set type(value:String):void
		{
			_textfield.type = value;			
			_textfield.addEventListener(Event.SCROLL, scrollHandler);
			//below events only use for INPUT textfield.
			if (value == INPUT)
			{				
				_textfield.addEventListener(Event.CHANGE, changeHandler);
				_textfield.addEventListener(TextEvent.TEXT_INPUT, inputHandler);
				//use MOUSE_UP and MOUSE_OUT event to get selection of _textfield
				_textfield.addEventListener(MouseEvent.MOUSE_UP, getSelectionHandler);
				_textfield.addEventListener(MouseEvent.MOUSE_OUT, getSelectionHandler);
			}			
		}
		
		public function get type():String
		{
			return _textfield.type;
		}
	}	
}