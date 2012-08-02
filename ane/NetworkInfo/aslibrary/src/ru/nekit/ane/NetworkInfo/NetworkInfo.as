package ru.nekit.ane.NetworkInfo
{
	
	import flash.external.ExtensionContext;
	
	public class NetworkInfo
	{
		private static var extContext:ExtensionContext = null;
		
		private static var _instance:NetworkInfo = null;
		private static var _shouldCreateInstance:Boolean = false;
		
		public function NetworkInfo()
		{
			
			if (_shouldCreateInstance)
			{
				extContext = ExtensionContext.createExtensionContext("ru.nekit.ane.NetworkInfo", "net");
			}
			else
			{
				throw new Error("ERROR!!");  
			}		
		}
		
		public static function get networkInfo():NetworkInfo {
			
			if(_instance == null)
			{
				_shouldCreateInstance = true; 
				_instance = new NetworkInfo();
				_shouldCreateInstance = false;
			}
			
			return _instance;
		} 
		
		public function findInterfaces():Vector.<NetworkInterface>
		{  
			var arr:Array = extContext.call("getInterfaces") as Array ;
			var i:int = 0;
			var rarr:Vector.<NetworkInterface> = Vector.<NetworkInterface>(arr);
			return rarr;		
		}
	}
}