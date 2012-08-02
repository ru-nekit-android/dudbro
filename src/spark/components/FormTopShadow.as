package spark.components
{
	
	import mx.core.DPIClassification;
	import mx.core.FlexGlobals;
	
	import spark.primitives.RectangularDropShadow;
	
	public class FormTopShadow extends RectangularDropShadow
	{
		public function FormTopShadow()
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
					angle=-90;
					color=0x666666;
					blurY=16;
					blurX=16;
					tlRadius=16;
					trRadius=16; 
					blRadius=16;
					brRadius=16;
					
					break;
				
				case DPIClassification.DPI_240:
					
					left = -1;
					right = -1;
					bottom = 0;
					top = 0;
					distance=3;
					angle=-90;
					color=0x666666;
					blurY=12;
					blurX=12;
					tlRadius=12;
					trRadius=12; 
					blRadius=12;
					brRadius=12;
					
					break;
				
				default:
					
					left = -1;
					right = -1;
					bottom = 0;
					top = 0;
					distance=3;
					angle=-90;
					color=0x666666;
					blurY=8;
					blurX=8;
					tlRadius=8;
					trRadius=8; 
					blRadius=8;
					brRadius=8;
					
					break;
				
			}
			
			alpha = .6;
			
		}
		
		protected function get applicationDPI():Number
		{
			return FlexGlobals.topLevelApplication.applicationDPI;
		}
	}
}