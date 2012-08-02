package ru.nekit.disn.view
{
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.filter.*;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.viewDataItem.MenuDataItem;
	import ru.nekit.disn.view.views.FriendListView;
	import ru.nekit.disn.view.views.FriendMenuView;
	import ru.nekit.disn.view.views.FriendshipRequestListView;
	
	import spark.components.Button;
	import spark.events.IndexChangeEvent;
	
	public class FriendMenuMediator extends ViewMediator
	{
		
		public static const NAME:String = "friendListMenuView";
		
		public static const ACTION_ALL:String = "all";
		public static const ACTION_ONLINE:String = "online";
		public static const ACTION_OFFLINE:String = "offline";
		public static const ACTION_REQUEST_TO_ME:String = "request_to_me";
		public static const ACTION_REQUEST_FROM_ME:String = "request_from_me";
		
		private var _view:FriendMenuView = null;
		private var _onlineMenuItem:MenuDataItem;
		private var _friendshipRequestToMeMenuItem:MenuDataItem;
		
		public function FriendMenuMediator(viewComponent:Object=null)
		{
			_view = viewComponent as FriendMenuView;
			super(NAME, viewComponent);
		}
		
		override protected function get mainMenuButton():Button
		{
			return _view.mainMenu;
		}
		
		public function get view():FriendMenuView
		{
			return _view;
		}	
		
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.USER_FRIENDSHIP_REQUEST_ADD,
				NAMES.USER_EXIT,
				NAMES.USER_ADD,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{	
			var body:Object = notification.getBody();
			var name:String = notification.getName();
			var user:User;
			switch( name )
			{	
				
				case NAMES.USER_FRIENDSHIP_REQUEST_ADD:
					
					updateFriendshipRequestToMeMenuItem();
					
					break;
				
				case NAMES.USER_ADD:
					
					user = body as User;
					model.userListPing.add(user);
					updateOnlineMenuItem();
					
					break;
				
				case NAMES.USER_EXIT:
					
					user = body as User;
					model.userListPing.add(user);
					updateOnlineMenuItem();
					
					break;
				
				default:
					
					break;
				
			}
		}
		
		private function get menuDataProvider():IList
		{
			return new ArrayList(
				[
					new MenuDataItem("Все", ACTION_ALL),
					updateOnlineMenuItem(),
					/*new MenuDataItem("Оффлайн", ACTION_OFFLINE),*/
				]
			);
		}
		
		private function get requestMenuDataProvider():IList
		{
			return new ArrayList(
				[
					updateFriendshipRequestToMeMenuItem(),
					new MenuDataItem("От меня", ACTION_REQUEST_FROM_ME),
				]
			);
		}
		
		private function updateOnlineMenuItem():MenuDataItem
		{
			var count:uint = model.friendFilter.onlineFriends.length;
			if( !_onlineMenuItem )
			{
				_onlineMenuItem = new MenuDataItem("Онлайн", ACTION_ONLINE);
			}
			_onlineMenuItem.hint = count.toString();
			return _onlineMenuItem;
		}
		
		private function updateFriendshipRequestToMeMenuItem():MenuDataItem
		{
			if( !_friendshipRequestToMeMenuItem )
			{
				_friendshipRequestToMeMenuItem = new MenuDataItem("Ко мне", ACTION_REQUEST_TO_ME);
			}
			var count:uint = model.friendshipRequestFilter.toME.length;
			_friendshipRequestToMeMenuItem.hint = count ? "+" + count : null;
			return _friendshipRequestToMeMenuItem;
		}
		
		override protected function onMediatorRegister():void
		{
			
		}
		
		override protected function onViewAdd():void
		{
			_view.menu.dataProvider 		= menuDataProvider;
			_view.requestMenu.dataProvider 	= requestMenuDataProvider;
		}
		
		override protected function onViewActive():void
		{
			_view.menu.addEventListener(IndexChangeEvent.CHANGE, 	menuHandler);
			_view.requestMenu.addEventListener(IndexChangeEvent.CHANGE, 	requestMenuHandler);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.menu.removeEventListener(IndexChangeEvent.CHANGE, 	menuHandler);
			_view.requestMenu.removeEventListener(IndexChangeEvent.CHANGE, 	requestMenuHandler);
		}
		
		override protected function onViewRemove():void
		{
			_view.menu.dataProvider.removeAll();
			_view.menu.dataProvider = null;
			_view.requestMenu.dataProvider.removeAll();
			_view.requestMenu.dataProvider = null;
			_view = null;
		}
		
		private function menuHandler(event:IndexChangeEvent):void
		{
			var action:String = (_view.menu.dataProvider.getItemAt(event.newIndex) as MenuDataItem).action;
			sendNotification(NAMES.SET_VIEW_DATA, action);
			sendNotification(NAMES.VIEW_GO, FriendListView);
		}
		
		private function requestMenuHandler(event:IndexChangeEvent):void
		{
			var action:String = (_view.requestMenu.dataProvider.getItemAt(event.newIndex) as MenuDataItem).action;
			sendNotification(NAMES.SET_VIEW_DATA, action);
			sendNotification(NAMES.VIEW_GO, FriendshipRequestListView);
		}
	}
}