package spark.skins.form
{
	
	import flash.errors.IllegalOperationError;
	
	import spark.core.SpriteVisualElement;
	import spark.skins.mobile.SkinnableContainerSkin;
	
	public class BasePartFormSkin extends SkinnableContainerSkin
	{
		
		private static const DEFAULT_FILL_COLOR:Number = 0xB4B8BF;
		
		protected var background:SpriteVisualElement;
		protected var colorized:Boolean;
		
		public function BasePartFormSkin()
		{
			super();
		}
		
		protected function get backgroundClass():Class
		{
			throw new IllegalOperationError("You must override this function.");
		}
		
		override protected function createChildren():void
		{
			// Adding container background
			background = new backgroundClass;
			addChild(background);
			// Creating content group instance
			super.createChildren();
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			// Setting size of background container
			setElementSize(background, unscaledWidth, unscaledHeight);
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// omit call to super.drawBackground() to apply tint instead and don't draw fill
			var chromeColor:uint = getStyle("chromeColor");
			
			if (colorized || (chromeColor != defaultFillColor))
			{
				// apply tint instead of fill
				applyColorTransform(background, defaultFillColor, chromeColor);
				
				// if we restore to original color, unset colorized
				colorized = (chromeColor != defaultFillColor);
			}
		}
		
		protected function get defaultFillColor():Number
		{
			return DEFAULT_FILL_COLOR;
		}
		
	}
}