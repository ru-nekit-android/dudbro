package ru.nekit.disn.model.p2p
{
	
	import com.adobe.crypto.MD5;
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.MessageVO;
	
	import flash.crypto.generateRandomBytes;
	import flash.net.NetGroup;
	
	import org.puremvc.as3.patterns.proxy.Dispatcher;
	
	import ru.nekit.disn.model.events.ExtendedMessageEvent;
	import ru.nekit.disn.model.events.UserEvent;
	import ru.nekit.disn.model.types.ExtendedMessageStatus;
	import ru.nekit.disn.model.types.FriendshipRequestStatus;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.user.UserProxy;
	import ru.nekit.disn.model.vo.ExtendedMessageVO;
	import ru.nekit.disn.model.vo.FriendshipRequestVO;
	import ru.nekit.disn.model.vo.UserDataVO;
	import ru.nekit.disn.service.LocalP2PService;
	
	[Event(name="success", 	type="ru.nekit.disn.model.events.ExtendedMessageEvent")]
	[Event(name="failed", 	type="ru.nekit.disn.model.events.ExtendedMessageEvent")]
	[Event(name="received", type="ru.nekit.disn.model.events.ExtendedMessageEvent")]
	[Event(name="getInformation", type="ru.nekit.disn.model.events.UserEvent")]
	[Event(name="add", type="ru.nekit.disn.model.events.UserEvent")]
	[Event(name="exit", type="ru.nekit.disn.model.events.UserEvent")]
	[Event(name="update", type="ru.nekit.disn.model.events.UserEvent")]
	[Event(name="update_active", type="ru.nekit.disn.model.events.UserEvent")]
	[Event(name="friendshipRequestAdd", type="ru.nekit.disn.model.events.UserEvent")]
	[Event(name="friendshipRequestRemove", type="ru.nekit.disn.model.events.UserEvent")]
	[Event(name="friendshipRequestAbort", type="ru.nekit.disn.model.events.UserEvent")]
	[Event(name="friendAdd", type="ru.nekit.disn.model.events.UserEvent")]
	public class P2PUserChannel extends Dispatcher
	{
		
		private var _userProxy:UserProxy;
		
		public function P2PUserChannel()
		{
			super();
		}
		
		public function init():void
		{
			_userProxy = new UserProxy;
			model.p2p.addEventListener(GroupEvent.GROUP_CONNECTED, 	groupConnectedHandler);
			model.p2p.addEventListener(ClientEvent.CLIENT_ADDED, 	clientAddedHandler);
			model.p2p.addEventListener(ClientEvent.CLIENT_REMOVED, 	clientRemovedHandler);
			model.p2p.addEventListener(ClientEvent.CLIENT_ANNONCE, 	clientAnnonceHandler);
			model.p2p.addEventListener(MessageEvent.DATA_RECEIVED, 	messageReceiveHandler);
		}
		
		private function check(netGroup:NetGroup):Boolean
		{
			return model.p2p.service.connection.groupManager.getGroupName(netGroup) == LocalP2PService.NAME;
		}
		
		private function clientRemovedHandler(event:ClientEvent):void
		{
			var client:ClientVO = event.client;
			if( !client.isLocal )
			{
				_userProxy.user = model.userList.getByPeerID(client.peerID);
				if( _userProxy.user )
				{
					_userProxy.exit();
					dispatchEvent(new UserEvent(UserEvent.EXIT, _userProxy.user));
				}
			}
		}
		
		private function clientAddedHandler(event:ClientEvent):void
		{
			var client:ClientVO = event.client;
			if( client.isLocal )
			{
				model.localUser.user.connected = true;
			}
		}
		
		private function groupConnectedHandler(event:GroupEvent):void
		{
			if( check(event.group) )
			{
				model.localUser.p2pClient		= model.p2p.client;
			}
		}	
		
		private function clientAnnonceHandler(event:ClientEvent):void
		{
			var client:ClientVO = event.client;
			if( !client.isLocal )
			{
				var clients:Vector.<ClientVO> = model.p2p.service.connection.groupManager.getClients(event.group);
				announce(client);
			}
		}
		
		private function announce(client:ClientVO):User
		{
			if( ( client.type & P2PClientType.USER ) != 0 )
			{
				var user:User = _userProxy.register(client);
				if( user )
				{
					handshake(user);
					return user;
				}
			}
			return null;
		}
		
		public function handshake(user:User):void
		{
			model.ping.wait(user);
			sendToUser(user, null, LocalUserProxy.HANDSHAKE);
		}
		
		public function sendToUser(user:User, data:*, command:String):void
		{
			model.p2p.service.connection.sendMessageToClient(data, user.groupID, LocalUserProxy.USER, command);
		}
		
		public function sendToAllUsers( data:*, command:String):void
		{
			model.p2p.service.connection.sendMessageToAll(data, LocalUserProxy.USER, command);
		}
		
		private function checkOnFriendshipRequest(user:User):void
		{
			if( !model.friendList.hasFriend(user) )
			{
				var request:FriendshipRequestVO = model.friendshipRequestList.getRequest(user);
				if( request )
				{
					if( request.status == FriendshipRequestStatus.FROM_ME )
					{
						friendshipAddRequest(user, request.text);
					}
					else if( request.status == FriendshipRequestStatus.CONFIRM_TO_ME )
					{
						friendshipConfirmRequest(user);
					}
					else if( request.status == FriendshipRequestStatus.REMOVED )
					{
						friendshipRemoveRequest(user);
					}
					else if( request.status == FriendshipRequestStatus.ABORTED )
					{
						friendshipAbortRequest(user);
					}
					else
					{
						
					}
				}
			}
		}
		
		public function sendMessage(value:Object, user:User, deliveryReport:Boolean = false):void
		{
			var message:ExtendedMessageVO 	= new ExtendedMessageVO(model.localUser.user.uid, user.uid, value);
			message.uid						= MD5.hashBinary(generateRandomBytes(32));
			if( deliveryReport )
			{
				message.status 					= ExtendedMessageStatus.DELIVERY_REPORT;
				model.ping.wait(message, model.ping.userTTL(user));
			}
			else
			{
				message.status 					= ExtendedMessageStatus.COMPLETE;
				dispatchEvent(new ExtendedMessageEvent(ExtendedMessageEvent.SENT_SUCCESS, message));
			}
			sendToUser(user, message, LocalUserProxy.MESSAGE);
		}
		
		public function friendshipAddRequest(user:User, text:String):void
		{
			sendToUser(user, text, LocalUserProxy.FRIENDSHIP_REQUEST);
		}
		
		public function friendshipRemoveRequest(user:User):void
		{
			sendToUser(user, null, LocalUserProxy.FRIENDSHIP_REQUEST_REMOVE);
		}
		
		public function friendshipAbortRequest(user:User):void
		{
			sendToUser(user, null, LocalUserProxy.FRIENDSHIP_REQUEST_ABORT);
		}
		
		public function friendshipConfirmRequest(user:User):void
		{
			sendToUser(user, null, LocalUserProxy.FRIENDSHIP_REQUEST_CONFIRM);
		}
		
		public function requestInformation(user:User):void
		{
			sendToUser(user, null, LocalUserProxy.INFORMATION_REQUEST);
		}
		
		private function messageReceiveHandler(event:MessageEvent):void
		{
			var message:MessageVO 	= event.message;
			if( message.type == LocalUserProxy.USER )
			{
				event.stopImmediatePropagation();
				if( check(event.group) )
				{
					var client:ClientVO 	= message.client;
					var data:Object 		= message.data;
					var user:User 			= model.userList.getByPeerID(client.peerID);
					if( !user )
					{
						user = announce(client);
					}
					_userProxy.user = user;
					if( user )
					{
						switch( message.command )
						{
							
							case LocalUserProxy.INFORMATION_REQUEST:
								
								sendToUser(user, model.localUser.user.vo, LocalUserProxy.INFORMATION_GET);
								
								break;
							
							case LocalUserProxy.INFORMATION_GET:
								
								_userProxy.save( data as UserDataVO );
								dispatchEvent(new UserEvent(UserEvent.GET_INFORMATION, user));
								
								break;
							
							case LocalUserProxy.UPDATE_NICKNAME:
								
								_userProxy.nickname = data as String;
								dispatchEvent(new UserEvent(UserEvent.UPDATE, user));
								
								break;
							
							case LocalUserProxy.UPDATE_DATA:
								
								_userProxy.save( data as UserDataVO );
								dispatchEvent(new UserEvent(UserEvent.UPDATE, user));
								
								break;
							
							case LocalUserProxy.FRIENDSHIP_REQUEST:
								
								if( model.friendList.hasFriend(user) )
								{
									sendToUser(user, null, LocalUserProxy.FRIENDSHIP_REQUEST_CONFIRM);
								}
								else
								{
									sendToUser(user, null, LocalUserProxy.FRIENDSHIP_REQUEST_SUCCESS);
									model.friendshipRequestList.save(user, FriendshipRequestStatus.TO_ME, data as String);
									dispatchEvent(new UserEvent(UserEvent.FRIENDSHIP_REQUEST_ADD, user));
								}
								
								break;
							
							case LocalUserProxy.FRIENDSHIP_REQUEST_SUCCESS:
								
								if( model.friendList.hasFriend(user) )
								{
									sendToUser(user, null, LocalUserProxy.FRIENDSHIP_REQUEST_CONFIRM);
								}
								else
								{
									model.friendshipRequestList.save(user, FriendshipRequestStatus.FROM_ME_SUCCESS);
									dispatchEvent(new UserEvent(UserEvent.FRIENDSHIP_REQUEST_ADD, user));
								}
								
								break;
							
							case LocalUserProxy.FRIENDSHIP_REQUEST_CONFIRM:
								
								if( model.friendList.hasFriend(user) )
								{
									sendToUser(user, null, LocalUserProxy.FRIENDSHIP_REQUEST_CONFIRM_SUCCESS);
								}
								else
								{	
									model.friendList.add(user);
									model.friendshipRequestList.save(user, FriendshipRequestStatus.CONFIRM_FROM_ME);
									sendToUser(user, null, LocalUserProxy.FRIENDSHIP_REQUEST_CONFIRM_SUCCESS);
									dispatchEvent(new UserEvent(UserEvent.FRIEND_ADD, user));
								}
								
								break;
							
							case LocalUserProxy.FRIENDSHIP_REQUEST_ABORT:
								
								model.friendshipRequestList.save(user, FriendshipRequestStatus.ABORTED_FROM_ME);
								sendToUser(user, null, LocalUserProxy.FRIENDSHIP_REQUEST_ABORT_SUCCESS);
								dispatchEvent(new UserEvent(UserEvent.FRIENDSHIP_REQUEST_ABORT, user));
								
								break;
							
							case LocalUserProxy.FRIENDSHIP_REQUEST_ABORT_SUCCESS:
								
								model.friendshipRequestList.remove(user);
								
								break;
							
							case LocalUserProxy.FRIENDSHIP_REQUEST_CONFIRM_SUCCESS:
								
								model.friendList.add(user);
								model.friendshipRequestList.remove(user);
								
								break;
							
							case LocalUserProxy.FRIENDSHIP_REQUEST_REMOVE:
								
								model.friendshipRequestList.remove(user);
								sendToUser(user, null, LocalUserProxy.FRIENDSHIP_REQUEST_REMOVE_SUCCESS);
								dispatchEvent(new UserEvent(UserEvent.FRIENDSHIP_REQUEST_REMOVE, user));
								
								break;
							
							case LocalUserProxy.FRIENDSHIP_REQUEST_REMOVE_SUCCESS:
								
								model.friendshipRequestList.remove(user);
								dispatchEvent(new UserEvent(UserEvent.FRIENDSHIP_REQUEST_REMOVE, user));
								
								break;
							
							case LocalUserProxy.UPDATE_ACTIVE_STATUS:
								
								user.active = data as Boolean;
								dispatchEvent(new UserEvent(UserEvent.UPDATE_ACTIVE, user));
								
								break;
							
							case LocalUserProxy.SUBSCRIBE:
								
								model.subscriberList.add(user);
								
								break;
							
							case LocalUserProxy.UNSUBSCRIBE:
								
								model.subscriberList.remove(user);
								
								break;
							
							case LocalUserProxy.PING:
								
								sendToUser(user, null, LocalUserProxy.PONG);
								
								break;
							
							case LocalUserProxy.PONG:
								
								model.ping.remove(user);
								
								break;
							
							case LocalUserProxy.HANDSHAKE:
								
								sendToUser(user, model.localUser.user.vo, LocalUserProxy.HANDSHAKE_OK);
								
								break;
							
							case LocalUserProxy.HANDSHAKE_OK:
								
								model.ping.remove(user);
								_userProxy.user.setVO(data as UserDataVO);
								_userProxy.connect();
								dispatchEvent(new UserEvent(UserEvent.ADD, user));
								checkOnFriendshipRequest(user);
								
								break;
							
							case LocalUserProxy.EXIT:
								
								_userProxy.exit();
								dispatchEvent(new UserEvent(UserEvent.EXIT, user));
								
								break;
							
							case LocalUserProxy.MESSAGE:
								
								var eMessage:ExtendedMessageVO = data as ExtendedMessageVO;
								if( eMessage.destination != "" && eMessage.destination == model.localUser.user.uid )
								{
									if( ( eMessage.status & ExtendedMessageStatus.DELIVERY_REPORT ) != 0)
									{
										sendToUser(user, eMessage.uid, LocalUserProxy.MESSAGE_DELIVERY_REPORT);
									}
									eMessage.status = ExtendedMessageStatus.COMPLETE;
									dispatchEvent(new ExtendedMessageEvent(ExtendedMessageEvent.RECEIVED, eMessage));
								}
								
								break;
							
							case LocalUserProxy.MESSAGE_DELIVERY_REPORT:
								
								model.ping.remove(data as String);
								
								break;
							
							default:
								
								break;
							
						}
					}
				}
			}
		}
	}
}