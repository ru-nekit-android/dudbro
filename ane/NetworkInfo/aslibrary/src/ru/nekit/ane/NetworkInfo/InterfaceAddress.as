package ru.nekit.ane.NetworkInfo
{
	
	public class InterfaceAddress
	{
		
		private var _address:String = "";
		private var _broadcast:String = "";
		private var _prefixLength:int = -1;
		private var _ipVersion:String = "IPV4";
		
		public function InterfaceAddress(add:String, broadCast:String, prfx:int, ipVer:String)
		{
			_address = add;
			_broadcast = broadCast;
			_prefixLength = prfx; 
			_ipVersion = ipVer;
		}
		
		public function get address():String
		{
			return _address;
		}
		
		public function get broadcast():String
		{
			return _broadcast;
		}
		
		public function get prefixLength():int
		{
			return _prefixLength;
		}
		
		public function get ipVersion():String
		{
			return _ipVersion;
		}
	}
}