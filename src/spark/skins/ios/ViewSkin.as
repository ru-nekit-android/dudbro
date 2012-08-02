package spark.skins.ios
{
	import mx.graphics.BitmapFillMode;
	
	import spark.components.Image;
	import spark.skins.mobile.SkinnableContainerSkin;
	
	public class ViewSkin extends SkinnableContainerSkin
	{
		[Embed(source="pattern.png")]
		private var borderClass:Class;
		private var backgroundImage:Image;
		
		override protected function createChildren():void
		{
			backgroundImage = new Image();
			backgroundImage.source = borderClass;
			backgroundImage.fillMode = BitmapFillMode.REPEAT;
			addChild(backgroundImage);
			super.createChildren();
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			setElementSize(backgroundImage, unscaledWidth, unscaledHeight);
		}
	}
}