package ru.nekit.disn.model.p2p
{
	
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.vo.ClientVO;
	
	import org.puremvc.as3.patterns.proxy.Dispatcher;
	
	import ru.nekit.disn.model.user.user_internal;
	import ru.nekit.disn.service.IP2PService;
	
	use namespace user_internal;
	
	[Event(name="groupConnected", 	type="com.projectcocoon.p2p.events.GroupEvent")]
	[Event(name="clientAdded",	 	type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="clientAnnonce", 	type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="clientRemoved", 	type="com.projectcocoon.p2p.events.ClientEvent")]
	[Event(name="dataReceived", 	type="com.projectcocoon.p2p.events.MessageEvent")]
	public class P2PCore extends Dispatcher
	{
		
		private var _service:IP2PService;
		private var _client:ClientVO;
		
		public function get service():IP2PService
		{
			if( !_service )
			{
				_service = model.networkStatus.localStatus ? model.localP2PService : null;
			}
			return _service;
		}
		
		public function connect():void
		{
			model.p2pUserChannel.init();
			model.p2pDesktopChannel.init();
			service.connection.addEventListener(GroupEvent.GROUP_CONNECTED, 	groupConnectionHandler);
			service.connection.addEventListener(MessageEvent.DATA_RECEIVED, 	messageReceiveHandler);
			service.connection.addEventListener(ClientEvent.CLIENT_ADDED, 		clientAddedHandler);
			service.connection.addEventListener(ClientEvent.CLIENT_REMOVED, 	clientRemoveHandler);
			service.connection.addEventListener(ClientEvent.CLIENT_ANNONCE, 	clientAnnounceHandler);
			service.connect();
		}
		
		public function close():void
		{
			service.connection.close();
		}
		
		public function get client():ClientVO
		{
			return _client;
		}
		
		private function groupConnectionHandler(event:GroupEvent):void
		{
			_client			= service.connection.localClient;
			dispatchEvent(event.clone());
		}
		
		private function clientAddedHandler(event:ClientEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		private function clientRemoveHandler(event:ClientEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		private function clientAnnounceHandler(event:ClientEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		private function messageReceiveHandler(event:MessageEvent):void
		{
			dispatchEvent(event.clone());
		}
	}
}