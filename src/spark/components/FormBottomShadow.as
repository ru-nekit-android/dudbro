package spark.components
{
	
	import mx.core.DPIClassification;
	import mx.core.FlexGlobals;
	
	import spark.primitives.RectangularDropShadow;
	
	public class FormBottomShadow extends RectangularDropShadow
	{
		public function FormBottomShadow()
		{
			super();
			
			switch( applicationDPI )
			{
				
				case DPIClassification.DPI_320:
					
					left = 0;
					right = 0;
					bottom = 0;
					top = 0;
					distance=4;
					angle=90;
					color=0xFFFFFF;
					blurY=16;
					blurX=16;
					tlRadius=16;
					trRadius=16; 
					blRadius=16;
					brRadius=16;
					
					break;
				
				case DPIClassification.DPI_240:
					
					left = 0;
					right = 0;
					bottom = 0;
					top = 0;
					distance=3;
					angle=90;
					color=0xFFFFFF;
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
					distance=2;
					angle=90;
					color=0xFFFFFF;
					blurY=8;
					blurX=8;
					tlRadius=8;
					trRadius=8; 
					blRadius=8;
					brRadius=8;
					
					break;
				
			}
			
			alpha = .3;	
			
		}
		
		protected function get applicationDPI():Number
		{
			return FlexGlobals.topLevelApplication.applicationDPI;
		}
	}
}