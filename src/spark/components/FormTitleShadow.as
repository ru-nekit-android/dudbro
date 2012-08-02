package spark.components
{
	
	import mx.core.DPIClassification;
	import mx.core.FlexGlobals;
	
	import spark.primitives.RectangularDropShadow;
	
	public class FormTitleShadow extends RectangularDropShadow
	{
		public function FormTitleShadow()
		{
			super();
			
			switch( applicationDPI )
			{
				
				case DPIClassification.DPI_320:
					
					left = -1;
					right = -1;
					bottom = 0;
					top = 0;
					distance=3;
					angle=90;
					color=0x999999;
					blurY=16;
					blurX=16;
					blRadius=16;
					brRadius=16;
					
					break;
				
				case DPIClassification.DPI_240:
					
					left = -1;
					right = -1;
					bottom = 0;
					top = 0;
					distance=3;
					angle=90;
					color=0x999999;
					blurY=12;
					blurX=12;
					blRadius=12;
					brRadius=12;
					
					break;
				
				default:
					
					left = -1;
					right = -1;
					bottom = 0;
					top = 0;
					distance=3;
					angle=90;
					color=0x999999;
					blurY=8;
					blurX=8;
					blRadius=8;
					brRadius=8;
					
					break;
				
			}
			
			alpha= .6;
			
		}
		
		protected function get applicationDPI():Number
		{
			return FlexGlobals.topLevelApplication.applicationDPI;
		}
	}
}