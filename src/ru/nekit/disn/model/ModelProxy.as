package ru.nekit.disn.model
{
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.disn.model.auth.Auth;
	import ru.nekit.disn.model.cursor.MessageTreeCursor;
	import ru.nekit.disn.model.favorite.FavoriteUserList;
	import ru.nekit.disn.model.filter.FriendFilter;
	import ru.nekit.disn.model.filter.FriendshipRequestFilter;
	import ru.nekit.disn.model.filter.MessageFilter;
	import ru.nekit.disn.model.filter.UserFilter;
	import ru.nekit.disn.model.friend.FriendList;
	import ru.nekit.disn.model.friend.FriendshipRequestList;
	import ru.nekit.disn.model.desktop.DesktopList;
	import ru.nekit.disn.model.message.MessageList;
	import ru.nekit.disn.model.message.MessageTreeList;
	import ru.nekit.disn.model.notification.NotificationCenter;
	import ru.nekit.disn.model.notification.NotificationMessageTreeList;
	import ru.nekit.disn.model.p2p.P2PCore;
	import ru.nekit.disn.model.p2p.P2PDesktopChannel;
	import ru.nekit.disn.model.p2p.P2PUserChannel;
	import ru.nekit.disn.model.photo.PhotoLibrary;
	import ru.nekit.disn.model.ping.CyclicUserListPing;
	import ru.nekit.disn.model.ping.Ping;
	import ru.nekit.disn.model.properties.Properties;
	import ru.nekit.disn.model.subscriber.SubscriberList;
	import ru.nekit.disn.model.user.CurrentUser;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.model.user.UserList;
	import ru.nekit.disn.model.viewBuilder.MessageViewBuilder;
	import ru.nekit.disn.model.viewBuilder.UserViewBuilder;
	import ru.nekit.disn.service.DBService;
	import ru.nekit.disn.service.LocalP2PService;
	import ru.nekit.disn.service.NetworkStatusService;
	
	public class ModelProxy extends Proxy implements IProxy
	{
		
		public static const NAME:String = "modelProxy";
		
		public var auth:Auth;
		public var p2p:P2PCore;
		public var p2pDesktopChannel:P2PDesktopChannel;
		public var p2pUserChannel:P2PUserChannel;
		
		public var db:DBService;	
		
		public var favoriteUserList:FavoriteUserList;
		
		public var friendList:FriendList;
		public var friendFilter:FriendFilter;
		public var friendshipRequestList:FriendshipRequestList;
		public var friendshipRequestFilter:FriendshipRequestFilter;
		
		public var messageTreeList:MessageTreeList;
		public var messageList:MessageList;
		public var messageViewBuilder:MessageViewBuilder;
		public var messageFilter:MessageFilter;
		public var messageTreeCursor:MessageTreeCursor;
		
		public var localUser:LocalUserProxy;
		public var currentUser:CurrentUser;
		
		public var properties:Properties;
		public var networkStatus:NetworkStatusService;
		public var localP2PService:LocalP2PService;
		
		public var notificationMessageTreeList:NotificationMessageTreeList;
		public var photoLibrary:PhotoLibrary;
		
		public var notificationCenter:NotificationCenter;
		
		public var userList:UserList;
		public var userListPing:CyclicUserListPing;
		public var userViewBuilder:UserViewBuilder;
		public var userFilter:UserFilter;
		
		public var ping:Ping;
		
		public var subscriberList:SubscriberList;
		
		public var desktopList:DesktopList;
		
		public function ModelProxy()
		{	
			super(NAME);			
			auth 						= new Auth;
			localUser 					= new LocalUserProxy;				
			currentUser 				= new CurrentUser;			
			db 							= new DBService;				
			friendList 					= new FriendList;
			friendshipRequestList 		= new FriendshipRequestList;				
			favoriteUserList 			= new FavoriteUserList;			
			messageList 				= new MessageList;
			messageTreeList 			= new MessageTreeList;	
			messageFilter				= new MessageFilter;
			messageTreeCursor			= new MessageTreeCursor;
			userList 					= new UserList;		
			userListPing				= new CyclicUserListPing;
			p2p 						= new P2PCore;
			networkStatus 				= new NetworkStatusService;								
			localP2PService 			= new LocalP2PService;			
			properties 					= new Properties;
			photoLibrary 				= new PhotoLibrary;			
			messageViewBuilder 			= new MessageViewBuilder;				
			userViewBuilder 			= new UserViewBuilder;
			notificationCenter 			= new NotificationCenter;
			notificationMessageTreeList = new NotificationMessageTreeList;
			friendshipRequestFilter 	= new FriendshipRequestFilter;
			userFilter 					= new UserFilter;
			friendFilter 				= new FriendFilter	
			subscriberList				= new SubscriberList;
			ping						= new Ping;
			desktopList					= new DesktopList;
			p2pDesktopChannel			= new P2PDesktopChannel;
			p2pUserChannel				= new P2PUserChannel;
		}
		
		public function init():void
		{
			db.init(auth.vo.password);
			userList.init();
			messageList.init();
			friendList.init();
			friendshipRequestList.init();
			favoriteUserList.init();
			notificationCenter.init();
			notificationMessageTreeList.init();
			localUser.enter();
		}
		
		public function retrieveMediator(mediatorName:String):IMediator
		{
			return facade.retrieveMediator(mediatorName);
		}
	}
}