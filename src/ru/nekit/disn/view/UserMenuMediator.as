package ru.nekit.disn.view
{
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.viewDataItem.MenuDataItem;
	import ru.nekit.disn.view.views.*;
	
	import spark.components.Button;
	import spark.events.IndexChangeEvent;
	
	public class UserMenuMediator extends ViewMediator
	{
		
		public static const NAME:String = "userListMenuView";
		
		public static const ACTION_ALL:String = "all";
		public static const ACTION_ONLINE:String = "online";
		public static const ACTION_OFFLINE:String = "offline";
		public static const ACTION_FAVORITES:String = "favorites";
		
		private var _view:UserMenuView = null;
		private var _onlineMenuItem:MenuDataItem;
		
		public function UserMenuMediator(viewComponent:Object=null)
		{
			_view = viewComponent as UserMenuView;
			super(NAME, viewComponent);
			hasMenu = true;
		}
		
		public function get view():UserMenuView
		{
			return _view;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.USER_ADD,
				NAMES.USER_EXIT,
				
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{	
			var body:Object = notification.getBody();
			var name:String = notification.getName();
			var user:User;
			switch( name )
			{	
				
				case NAMES.USER_ADD:
					
					user = body as User;
					model.userListPing.add(user);
					updateOnlineMenuItem();
					
					break;
				
				case NAMES.USER_EXIT:
					
					user = body as User;
					model.userListPing.remove(user);
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
					/*new MenuDataItem("Оффлайн", ACTION_OFFLINE),*/
					new MenuDataItem("Избранные", ACTION_FAVORITES),
				]
			);
		}
		
		private function updateOnlineMenuItem():MenuDataItem
		{
			var count:uint = model.userFilter.onlineUsers.length;
			if( !_onlineMenuItem )
			{
				_onlineMenuItem = new MenuDataItem("Онлайн", ACTION_ONLINE);
			}
			_onlineMenuItem.hint = count.toString();
			return _onlineMenuItem;
		}
		
		override protected function onMediatorRegister():void
		{
			model.currentUser.reset();
		}
		
		override protected function get mainMenuButton():Button
		{
			return _view.mainMenu;
		}
		
		override protected function onViewAdd():void
		{
			model.userListPing.start();
			_view.menu.dataProvider = menuDataProvider;
		}
		
		override protected function onViewActive():void
		{
			_view.menu.addEventListener(IndexChangeEvent.CHANGE, 	menuHandler);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.menu.removeEventListener(IndexChangeEvent.CHANGE, 	menuHandler);
			model.userListPing.start();
		}
		
		override protected function onViewRemove():void
		{
			_view.menu.dataProvider.removeAll();
			_view.menu.dataProvider = null;
			_view = null;
		}
		
		private function menuHandler(event:IndexChangeEvent):void
		{
			var action:String = (_view.menu.selectedItem as MenuDataItem).action;
			sendNotification(NAMES.SET_VIEW_DATA, action);
			sendNotification(NAMES.VIEW_GO, UserListView);
		}
	}
}