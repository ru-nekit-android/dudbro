package ru.nekit.ane
{
	
	import flash.errors.IllegalOperationError;
	import flash.external.ExtensionContext;
	
	public final class Device
	{
		
		private static var _instance:Device;
		private static var _instanceAllow:Boolean;
		private static var context:ExtensionContext;
		
		public function Device()
		{
			if( _instanceAllow )
			{
				context = ExtensionContext.createExtensionContext("ru.nekit.Device", null);
			}
			else
			{
				throw new IllegalOperationError("You must use instance call!");
			}
		}	
		
		public static function get instance():Device
		{
			if( !_instance )
			{
				_instanceAllow 	= true;
				_instance 		= new Device;
				_instanceAllow 	= false;
			}
			return _instance;
		}
		
		public function getUUID():String
		{
			try
			{
				return context.call("getUUID") as String;
			} 
			catch(error:Error) 
			{	
			}
			return null;
		}
		
		public function vibrate(duration:uint):void
		{
			try{
				context.call("vibrate", duration);
			}catch(error:Error) 
			{	
			}
		}
		
		public function goSMSActivity(phoneNumber:String, body:String):void
		{
			try{
				context.call("goSMSActivity", phoneNumber, body);
			}catch(error:Error) 
			{	
			}
		}
	}
}