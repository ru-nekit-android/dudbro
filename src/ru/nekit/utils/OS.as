package ru.nekit.utils
{
	
	import flash.system.Capabilities;
	
	import mx.effects.easing.Back;
	
	public class OS
	{
		
		public static function get os():String {
			switch(true)
			{
				case (Capabilities.version.indexOf('IOS') > -1):
				{
					 
					return "IOS";
				}
				case (Capabilities.version.indexOf('QNX') > -1):
				{
					 
					return "BB";
				}
				case (Capabilities.version.indexOf('AND') > -1):
				{
					 
					return "ANDROID";
				}
				default:
					return "";
					break;
			}
		}
		
		public function isMobile():Boolean
		{
			return os != null;
		}
	}
}