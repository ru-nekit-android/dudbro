package spark.skins.buttonMenu
{
	
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	
	import spark.skins.ios160.assets.ButtonMenuLastButton;
	import spark.skins.ios160.assets.ButtonMenuLastButton_fill;
	import spark.skins.ios240.assets.ButtonMenuLastButton;
	import spark.skins.ios240.assets.ButtonMenuLastButton_fill;
	import spark.skins.ios320.assets.ButtonMenuLastButton;
	import spark.skins.ios320.assets.ButtonMenuLastButton_fill;
	
	use namespace mx_internal;
	
	public class ButtonMenuLastButtonSkin extends ButtonMenuButtonSkinBase
	{
			
		public function ButtonMenuLastButtonSkin()
		{
			super();
			
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					borderSkin = spark.skins.ios320.assets.ButtonMenuLastButton;
					upBorderSkin = spark.skins.ios320.assets.ButtonMenuLastButton_fill;
					downBorderSkin = spark.skins.ios320.assets.ButtonMenuLastButton_fill;
					
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
					borderSkin = spark.skins.ios240.assets.ButtonMenuLastButton;
					upBorderSkin = spark.skins.ios240.assets.ButtonMenuLastButton_fill;
					downBorderSkin = spark.skins.ios240.assets.ButtonMenuLastButton_fill;
					
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
					borderSkin = spark.skins.ios160.assets.ButtonMenuLastButton;
					upBorderSkin = spark.skins.ios160.assets.ButtonMenuLastButton_fill;
					downBorderSkin = spark.skins.ios160.assets.ButtonMenuLastButton_fill;
					
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
	}
}