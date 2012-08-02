package spark.skins.text
{
	
	import mx.core.DPIClassification;
	
	import spark.filters.DropShadowFilter;
	import spark.skins.mobile.StageTextAreaSkin;
	
	public class TextAreaSkin extends StageTextAreaSkin
	{
		
		public function TextAreaSkin()
		{
			super();
			switch( applicationDPI )
			{
				
				case DPIClassification.DPI_320:
					
					layoutCornerEllipseSize = 28;
					
					break;
				
				case DPIClassification.DPI_240:
					
					layoutCornerEllipseSize = 21;
					
					break;
				
				default:
					
					layoutCornerEllipseSize = 14;
					
					break;
			}
			
			filters = [new DropShadowFilter(4, 90, 0, 0.5, 4, 4, 1, 1, true)];
		}
	}
}
