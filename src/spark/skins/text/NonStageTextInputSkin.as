package spark.skins.text
{
	
	import spark.filters.DropShadowFilter;
	import spark.skins.mobile.TextInputSkin;
	
	public class NonStageTextInputSkin extends TextInputSkin
	{
		
		public function NonStageTextInputSkin()
		{
			super();
			layoutCornerEllipseSize =16;			
			filters = [new DropShadowFilter(4, 90, 0, 0.5, 4, 4, 1, 1, true)];
			
		}
	}
}
