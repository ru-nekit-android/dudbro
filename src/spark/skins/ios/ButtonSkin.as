package spark.skins.ios
{
	import flash.display.DisplayObject;
	
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	import mx.graphics.BitmapScaleMode;
	
	import spark.components.Group;
	import spark.primitives.BitmapImage;
	import spark.skins.ios160.assets.Button;
	import spark.skins.ios160.assets.Button_fill;
	import spark.skins.ios240.assets.Button;
	import spark.skins.ios240.assets.Button_fill;
	import spark.skins.ios320.assets.Button;
	import spark.skins.ios320.assets.Button_fill;
	import spark.skins.mobile.ButtonSkin;
	
	use namespace mx_internal;
	
	public class ButtonSkin extends spark.skins.mobile.ButtonSkin
	{
		private static const DEFAULT_FILL_COLOR:Number = 0xB4B8BF;
		
		public function ButtonSkin()
		{
			super();
			
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					borderSkin = spark.skins.ios320.assets.Button;
					upBorderSkin = spark.skins.ios320.assets.Button_fill;
					downBorderSkin = spark.skins.ios320.assets.Button_fill;
					
					layoutGap = 10;
					layoutPaddingLeft = 20;
					layoutPaddingRight = 20;
					layoutPaddingTop = 0;
					layoutPaddingBottom = 0;
					measuredDefaultWidth = 254;
					measuredDefaultHeight = 86;
					
					labelDisplayShadowOffset = 2;
					
					break;
				}
				case DPIClassification.DPI_240:
				{
					borderSkin = spark.skins.ios240.assets.Button;
					upBorderSkin = spark.skins.ios240.assets.Button_fill;
					downBorderSkin = spark.skins.ios240.assets.Button_fill;
					
					layoutGap = 8;
					layoutPaddingLeft = 15;
					layoutPaddingRight = 15;
					layoutPaddingTop = 0;
					layoutPaddingBottom = 0;
					measuredDefaultWidth = 195;
					measuredDefaultHeight = 66;
					
					labelDisplayShadowOffset = 1;
					
					break;
				}
				default:
				{
					
					borderSkin = spark.skins.ios160.assets.Button;
					upBorderSkin = spark.skins.ios160.assets.Button_fill;
					downBorderSkin = spark.skins.ios160.assets.Button_fill;
					
					layoutGap = 5;
					layoutPaddingLeft = 10;
					layoutPaddingRight = 10;
					layoutPaddingTop = 0;
					layoutPaddingBottom = 0;
					measuredDefaultWidth = 127;
					measuredDefaultHeight = 43;
					
					labelDisplayShadowOffset = 1;
					
					break;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		protected var borderSkin:Class;
		
		protected var labelDisplayShadowOffset:Number;
		
		protected var colorized:Boolean;
		
		protected var borderBackground:DisplayObject;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			borderBackground = (new borderSkin() as DisplayObject);
			addChildAt(borderBackground, 0);			
			var _iconHolder:DisplayObject = getIconDisplay();
			if( _iconHolder is Group )
			{
				var _icon:BitmapImage = (_iconHolder as Group).getElementAt(0) as BitmapImage;
				_icon.scaleMode = BitmapScaleMode.LETTERBOX;
			}
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			if( currentState == "down" )
			{
				removeChild(borderBackground);
			}else{
				addChildAt(borderBackground, 0);
				setElementSize(borderBackground, unscaledWidth, unscaledHeight);
			}		
			setElementPosition(labelDisplayShadow, labelDisplay.x, labelDisplay.y + labelDisplayShadowOffset);
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var chromeColor:uint = getStyle("chromeColor");
			if (colorized || (chromeColor != defaultFillColor))
			{
				applyColorTransform(border, defaultFillColor, chromeColor);
				colorized = (chromeColor != defaultFillColor);
			}
		}
		
		protected function get defaultFillColor():Number
		{
			return DEFAULT_FILL_COLOR;
		}
	}
}