package ru.nekit.disn.model.notification
{
	
	import ru.nekit.ane.Device;
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.events.ExtendedMessageEvent;
	import ru.nekit.disn.model.events.PingEvent;
	import ru.nekit.disn.model.events.UserEvent;
	import ru.nekit.disn.model.types.NotificationType;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.vo.ExtendedMessageVO;
	import ru.nekit.disn.view.ApplicationMediator;
	import ru.nekit.disn.view.views.MessageView;
	
	import spark.components.View;
	
	public class NotificationCenter extends ModelLink
	{
		
		public static const NAME:String = "notificationCenter";
		
		private var _view:ApplicationMediator;
		
		public function NotificationCenter()
		{
			super(NAME);
		}
		
		public function init():void
		{		
			_view 						= retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			model.ping.addEventListener(PingEvent.RESULT, ttlResultHandler);
			model.p2pUserChannel.addEventListener(ExtendedMessageEvent.RECEIVED, receiveMessageHandler);
			model.p2pUserChannel.addEventListener(ExtendedMessageEvent.SENT_SUCCESS, sentMessageHandler);
			model.p2pUserChannel.addEventListener(UserEvent.ADD, addUserHandler);
			model.p2pUserChannel.addEventListener(UserEvent.UPDATE, updateUserHandler);
			model.p2pUserChannel.addEventListener(UserEvent.EXIT, exitUserHandler);
			model.p2pUserChannel.addEventListener(UserEvent.FRIENDSHIP_REQUEST_ADD, friendshipRequestAdd);
			model.p2pUserChannel.addEventListener(UserEvent.FRIENDSHIP_REQUEST_REMOVE, friendshipRequestRemove);
			model.p2pUserChannel.addEventListener(UserEvent.FRIENDSHIP_REQUEST_ABORT, friendshipRequestAbort);
			model.p2pUserChannel.addEventListener(UserEvent.FRIEND_ADD, 		friendAddHandler);
		}
		
		private function friendAddHandler(event:UserEvent):void
		{
			sendNotification(NAMES.FRIEND_ADD, event.user);
		}
		
		private function ttlResultHandler(event:PingEvent):void
		{
			if( !event.result )
			{
				sendNotification(NAMES.USER_EXIT, event.object as User);
			}
			else
			{
				sendNotification(NAMES.USER_PING, event.object as User);
			}
		}
		
		private function friendshipRequestAdd(event:UserEvent):void
		{
			sendNotification(NAMES.USER_FRIENDSHIP_REQUEST_ADD, event.user);
			sendNotification(NAMES.NOTIFICATION_STATUS_UPDATE, event.user, NotificationType.NOTIFICATION_FRIENDSHIP);
		}
		
		private function friendshipRequestRemove(event:UserEvent):void
		{	
			sendNotification(NAMES.USER_FRIENDSHIP_REQUEST_REMOVE, event.user);
			sendNotification(NAMES.NOTIFICATION_STATUS_UPDATE, event.user, NotificationType.NOTIFICATION_FRIENDSHIP);
		}
		
		private function friendshipRequestAbort(event:UserEvent):void
		{		
			sendNotification(NAMES.USER_FRIENDSHIP_REQUEST_ABORT, event.user);
			sendNotification(NAMES.NOTIFICATION_STATUS_UPDATE, event.user, NotificationType.NOTIFICATION_FRIENDSHIP);
		}
		
		private function updateUserHandler(event:UserEvent):void
		{
			sendNotification(NAMES.USER_UPDATE, event.user);
		}
		
		private function addUserHandler(event:UserEvent):void
		{
			sendNotification(NAMES.USER_ADD, event.user);
		}
		
		private function exitUserHandler(event:UserEvent):void
		{
			sendNotification(NAMES.USER_EXIT, event.user);
		}
		
		private function saveMessage(message:ExtendedMessageVO):void
		{
			if( model.properties.vo.messageHistory )
			{
				model.messageList.add(message);
			}
			model.messageTreeList.addMessage(message);
		}
		
		private function sentMessageHandler(event:ExtendedMessageEvent):void
		{
			saveMessage(event.message);
		}
		
		private function receiveMessageHandler(event:ExtendedMessageEvent):void
		{
			var message:ExtendedMessageVO = event.message;
			var activeView:View = _view.activeView;
			if( /*!model.localUser.active ||*/ !(activeView is MessageView) || message.sender != model.currentUser.message.user.uid )
			{
				model.notificationMessageTreeList.add(message.sender, message.timestamp);
				sendNotification(NAMES.NOTIFICATION_STATUS_UPDATE, null, NotificationType.NOTIFICATION_MESSAGE);
				Device.instance.vibrate(500);
			}
			sendNotification(NAMES.MESSAGE_RECEIVED, message);
			saveMessage(message);
		}
	}
}