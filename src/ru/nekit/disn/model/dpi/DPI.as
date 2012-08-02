package ru.nekit.disn.model.dpi
{
	
	import mx.core.DPIClassification;
	import mx.core.FlexGlobals;
	
	public class DPI
	{
		
		private static var _instance:DPI;
		
		public const sourceDPI:Number = DPIClassification.DPI_160;
		
		public static function get instance():DPI
		{
			if( !_instance )
			{
				_instance = new DPI;
			}
			return _instance;
		}
		
		public function get applicationDPI():Number
		{
			return FlexGlobals.topLevelApplication.applicationDPI;
		}
		
		public function get is160():Boolean
		{
			return applicationDPI == DPIClassification.DPI_160;
		}
		
		public function get is240():Boolean
		{
			return applicationDPI == DPIClassification.DPI_240;
		}
		
		public function get is320():Boolean
		{
			return applicationDPI == DPIClassification.DPI_320;
		}
		
		public function get dpiScale():Number
		{
			return FlexGlobals.topLevelApplication.runtimeDPI / sourceDPI;
		}
		
		public function getSize(dpi160:Number, dpi240:Number, dpi320:Number):Number
		{
			if( is160 )
			{
				return dpi160;
			}
			if( is240 )
			{
				return dpi240;
			}
			return dpi320;
		}
		
		public function getAutoSize(start:Number):Number
		{
			if( is160 )
			{
				return start;
			}
			if( is240 )
			{
				return start*dpiScale;
			}
			return start*dpiScale;
		}
	}
}