package ru.nekit.disn.service
{
	
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	
	public interface IP2PService
	{
		
		function connect():void;
		function get connection():LocalNetworkDiscovery;
		function get connected():Boolean;
		
	}
}