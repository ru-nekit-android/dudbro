package spark.skins.buttonMenu
{
	
	import flash.display.DisplayObject;
	
	import mx.core.mx_internal;
	
	import ru.nekit.utils.DataUtil;
	
	import spark.components.ButtonMenuButton;
	import spark.components.VLine;
	import spark.components.supportClasses.StyleableTextField;
	import spark.skins.mobile.supportClasses.ButtonBarButtonSkinBase;
	
	use namespace mx_internal;
	
	public class ButtonMenuButtonSkinBase extends ButtonBarButtonSkinBase
	{
		
		private static const DEFAULT_FILL_COLOR:Number = 0xB4B8BF;
		
		protected var borderSkin:Class;	
		protected var labelDisplayShadowOffset:Number;	
		protected var colorized:Boolean;	
		protected var borderBackground:DisplayObject;	
		protected var hintDisplay:StyleableTextField;	
		protected var vLine:VLine;
		
		public function ButtonMenuButtonSkinBase()
		{	
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			borderBackground = (new borderSkin() as DisplayObject);
			addChild(borderBackground);
			if (!hintDisplay )
			{
				hintDisplay = StyleableTextField(createInFontContext(StyleableTextField));
				hintDisplay.styleName = this;
				hintDisplay.colorName = "hintColor";
				hintDisplay.useTightTextBounds = false;
				hintDisplay.setStyle("textAlign", "center");
				addChild(hintDisplay);
			}
			if( !vLine )
			{
				vLine = new VLine;
				addChild(vLine);
			}
		}
		
		override public function styleChanged(styleProp:String):void
		{
			var allStyles:Boolean = !styleProp || styleProp == "styleName";
			if ( allStyles || styleProp == "hintColor")
			{
				invalidateDisplayList();
			}
			super.styleChanged(styleProp);
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);	
			var viewWidth:Number = Math.max(unscaledWidth - layoutPaddingLeft - layoutPaddingRight, 0);
			var viewHeight:Number = Math.max(unscaledHeight - layoutPaddingTop - layoutPaddingBottom, 0);
			removeChild(borderBackground);
			addChildAt(borderBackground, 0);
			if (hostComponent)
				hintDisplay.text = (hostComponent as ButtonMenuButton).hint;
			hintDisplay.commitStyles();
			setElementSize(hintDisplay, unscaledHeight, unscaledHeight);
			setElementSize(borderBackground, unscaledWidth, unscaledHeight);
			setElementPosition(labelDisplayShadow, labelDisplay.x, labelDisplay.y + labelDisplayShadowOffset);
			setElementPosition(hintDisplay,  viewWidth - unscaledHeight/2, labelDisplay.y);
			if( vLine.visible = !DataUtil.isEmpty( hintDisplay.text ) )
			{
				setElementSize(vLine, vLine.width, viewHeight);
				setElementPosition(vLine,  viewWidth - unscaledHeight/2, 0);
			}
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