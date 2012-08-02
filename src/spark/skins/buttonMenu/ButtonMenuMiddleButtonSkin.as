package spark.skins.buttonMenu
{
	
	import mx.core.DPIClassification;
	
	import spark.skins.ios160.assets.ButtonMenuMiddleButton;
	import spark.skins.ios160.assets.ButtonMenuMiddleButton_fill;
	import spark.skins.ios240.assets.ButtonMenuMiddleButton;
	import spark.skins.ios240.assets.ButtonMenuMiddleButton_fill;
	import spark.skins.ios320.assets.ButtonMenuMiddleButton;
	import spark.skins.ios320.assets.ButtonMenuMiddleButton_fill;
	
	public class ButtonMenuMiddleButtonSkin extends ButtonMenuButtonSkinBase
	{
		
		public function ButtonMenuMiddleButtonSkin()
		{
			super();
			
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					borderSkin = spark.skins.ios320.assets.ButtonMenuMiddleButton;
					upBorderSkin = spark.skins.ios320.assets.ButtonMenuMiddleButton_fill;
					downBorderSkin = spark.skins.ios320.assets.ButtonMenuMiddleButton_fill;
					
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
					borderSkin = spark.skins.ios240.assets.ButtonMenuMiddleButton;
					upBorderSkin = spark.skins.ios240.assets.ButtonMenuMiddleButton_fill;
					downBorderSkin = spark.skins.ios240.assets.ButtonMenuMiddleButton_fill;
					
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
					borderSkin = spark.skins.ios160.assets.ButtonMenuMiddleButton;
					upBorderSkin = spark.skins.ios160.assets.ButtonMenuMiddleButton_fill;
					downBorderSkin = spark.skins.ios160.assets.ButtonMenuMiddleButton_fill;
					
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