package ru.nekit.disn.service
{
	
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class P2PService extends Proxy implements IProxy, IP2PService
	{
		
		public static const NAME:String = "p2pService";
		
		private var _discovery:LocalNetworkDiscovery;
		
		public function P2PService()
		{
			super(NAME);
			_discovery = new LocalNetworkDiscovery;
			_discovery.loopback = false;
			_discovery.useCirrus = true;
			_discovery.key = "fa34a2a9cd8864b67cdb154d-ac8a93ff4df0";
		}
		
		public function get connection():LocalNetworkDiscovery
		{
			return _discovery;
		}	
		
		public function connect():void
		{
			//stub
		}
		
		public function get connected():Boolean
		{
			return  _discovery.connection && _discovery.connection.connected;
		}
	}
}