package ru.nekit.utils
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	
	import spark.core.SpriteVisualElement;
	
	public class FXGUtil
	{
		
		public static function toBitmapData(fxg:Class, scaleFactor:Number = 1):BitmapData
		{
			var instance:SpriteVisualElement = new fxg;
			var result:BitmapData = new BitmapData(instance.width*scaleFactor + 5, instance.height*scaleFactor + 5, true, 0);
			
		//	instance.cacheAsBitmap = true;
		//	instance.cacheAsBitmapMatrix = new Matrix;
			
			var matrix:Matrix = new Matrix;
			if( scaleFactor !=1 )
			{
				matrix.scale(scaleFactor, scaleFactor);
			}
			result.draw(instance, matrix);	
			return result;
		}
		
		public static function toBitmap(fxg:Class, scaleFactor:Number = 1, pixelSnapping:String = PixelSnapping.NEVER, smoothing:Boolean = false):Bitmap
		{
			return new Bitmap(toBitmapData(fxg, scaleFactor), pixelSnapping, smoothing);
		}
	}
}