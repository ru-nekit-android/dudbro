package ru.nekit.disn.service
{
	
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.p2p.P2PClientType;
	import ru.nekit.disn.model.vo.UserDataVO;
	
	public class LocalP2PService extends ModelLink implements IP2PService
	{
	
		public static const NAME:String = "ru.nekit.disn.p2p";
		
		private var _discovery:LocalNetworkDiscovery;
		
		public function LocalP2PService()
		{
			_discovery = new LocalNetworkDiscovery;
			_discovery.loopback = false;
			_discovery.useCirrus = false;
			_discovery.autoConnect = false;
		}
		
		public function get connection():LocalNetworkDiscovery
		{
			return _discovery;
		}	
		
		public function connect():void
		{
			if( !connected )
			{
				var type:uint				= P2PClientType.USER; 
				type						|= P2PClientType.DESKTOP;
				var userDataVO:UserDataVO 	= model.localUser.user.vo;
				_discovery.uid				= userDataVO.uid;
				_discovery.groupName 		= NAME;
				_discovery.clientName 		= userDataVO.nickname;
				_discovery.type				= type;
				_discovery.connect();
			}
		}
		
		public function get connected():Boolean
		{
			return  _discovery.connection && _discovery.connection.connected;
		}
	}
}