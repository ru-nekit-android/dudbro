package ru.nekit.disn.model.p2p
{
	
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.MessageVO;
	
	import flash.net.NetGroup;
	import flash.utils.Dictionary;
	
	import ru.nekit.ane.Device;
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.desktop.Desktop;
	import ru.nekit.disn.model.desktop.DesktopProxy;
	import ru.nekit.disn.service.IP2PService;
	
	public class P2PDesktopChannel extends ModelLink
	{
		
		private static const NAMES_PREFIX:String = "ru.nekit.disn.p2p.desktop";
		
		private var _p2pService:IP2PService;
		private var _groupList:Dictionary;
		
		public function P2PDesktopChannel()
		{
			super();
		}
		
		public function get service():IP2PService
		{
			if( !_p2pService )
			{
				_p2pService = model.localP2PService;
			}
			return _p2pService;
		}
		
		public function init():void
		{
			model.p2p.addEventListener(ClientEvent.CLIENT_ANNONCE, clientAnnonceHandler);
			model.p2p.addEventListener(ClientEvent.CLIENT_ADDED, 	clientAddedHandler);
			model.p2p.addEventListener(GroupEvent.GROUP_CONNECTED, 	groupConnectedHandler);
			model.p2p.addEventListener(MessageEvent.DATA_RECEIVED, 	messageReceiveHandler);
		}
		
		private function clientAddedHandler(event:ClientEvent):void
		{
			var sclient:ClientVO = event.client;
			if( !sclient.isLocal )
			{
				if( check(event.group) )
				{
					
					var clients:Vector.<ClientVO> = model.p2p.service.connection.clients;
					if( clients )
					{
						for each( var client:ClientVO in clients )
						{
							if( client.peerID == sclient.peerID )
							{
								sclient.clientName 	= client.clientName;
								sclient.uid			= client.uid;
								sclient.type		= client.type;
								break;
							}
						}
					}
					var desktop:Desktop = model.desktopList.getByUID(event.client.uid);
					if( desktop )
					{
						sendOnChannel(desktop.p2pClient, null, DesktopProxy.CALL);
					}
				}
			}
		}
		
		private function check(netGroup:NetGroup):Boolean
		{
			return service.connection.groupManager.getGroupName(netGroup).indexOf(NAMES_PREFIX) == 0;
		}
		
		private function clientAnnonceHandler(event:ClientEvent):void
		{
			var client:ClientVO = event.client;
			if( !client.isLocal )
			{
				if( ( client.type & P2PClientType.DESKTOP ) != 0 )
				{
					model.desktopList.add(new Desktop(client));
				}
			}
		}
		
		private function groupConnectedHandler(event:GroupEvent):void
		{
			
		}	
		
		private function getGroupName(p2pClient:ClientVO):String
		{
			return NAMES_PREFIX + "." + p2pClient.uid;
		}
		
		private function getUID(netGroup:NetGroup):String
		{
			var nameList:Array = service.connection.groupManager.getGroupName(netGroup).split(".");
			nameList.reverse();
			return nameList[0];
		}
		
		public function openChannel(desktop:Desktop):void
		{
			sendTo(desktop.p2pClient, null, DesktopProxy.OPEN);
		}
		
		public function close(client:ClientVO):void
		{
			var group:NetGroup = getNetGroup(client);
			if( group )
			{
				service.connection.groupManager.leaveNetGroup(group);
			}
		}
		
		public function sendOnChannel(client:ClientVO, data:*, command:String):void
		{
			var group:NetGroup = getNetGroup(client);
			service.connection.groupManager.sendMessageToClient(data, group, client, DesktopProxy.DESKTOP, command);
		}
		
		private function getNetGroup(client:ClientVO):NetGroup
		{
			return _groupList[client.uid];	
		}
		
		private function createNetGroup(client:ClientVO):void
		{
			if( !(client.uid in _groupList) )
			{
				_groupList[client.uid] = service.connection.createNetGroup(getGroupName(client));
			}
		}
		
		public function sendTo(client:ClientVO, data:*, command:String):void
		{
			service.connection.sendMessageToClient(data, client.groupID, DesktopProxy.DESKTOP, command);
		}
		
		private function messageReceiveHandler(event:MessageEvent):void
		{
			var message:MessageVO 	= event.message;
			var client:ClientVO 	= message.client;
			var data:Object 		= message.data;
			if( message.type == DesktopProxy.DESKTOP )
			{
				//phisics - channel created
				if( check(event.group) )
				{
					
					switch( message.command )
					{
						
						case DesktopProxy.CALL:
							
							Device.instance.vibrate(1000);
							
							break;
						
						default:
							
							break;
						
					}
					
				}
				else
				{
					//logic - channel not created
					switch( message.command )
					{
						
						case DesktopProxy.OPEN:
							
							sendTo(client, null, DesktopProxy.OPEN_OK);
							createNetGroup(model.localUser.p2pClient);
							
							break;
						
						case DesktopProxy.OPEN_OK:
							
							createNetGroup(client);
							
							break;
						
						default:
							
							break;
						
					}
				}
			}
		}
	}
}