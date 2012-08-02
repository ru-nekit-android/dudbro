package ru.nekit.disn.view
{
	
	import mx.collections.ArrayList;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.cursor.UserListCursor;
	import ru.nekit.disn.model.filter.*;
	import ru.nekit.disn.model.user.*;
	import ru.nekit.disn.view.views.*;
	
	import spark.components.Button;
	import spark.events.IndexChangeEvent;
	
	public class FriendListMediator extends ViewMediator
	{
		
		public static const NAME:String = "friendListView";
		
		private var _view:FriendListView = null;
		private var _friendListCursor:UserListCursor;
		
		private var _action:String;
		
		public function FriendListMediator(viewComponent:Object=null)
		{
			_view = viewComponent as FriendListView;
			super(NAME, viewComponent);
			hasMenu = true;
		}
		
		override protected function get backButton():Button
		{
			return _view.backCall;
		}
		
		override protected function get mainMenuButton():Button
		{
			return _view.mainMenu;
		}
		
		public function get view():FriendListView
		{
			return _view;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.USER_ADD,
				NAMES.USER_EXIT,
				NAMES.USER_UPDATE,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var body:Object = notification.getBody();
			var name:String = notification.getName();
			var user:User;
			var index:int = -1;
			
			switch( name )
			{
				
				case NAMES.USER_EXIT:
					
					user = User(body);
					
					if( _action == FriendMenuMediator.ACTION_OFFLINE )
					{
						gotoNormal();
						friendListDataProvider.addItemAt(user, _friendListCursor.add(user));
					}
					else if( _action == FriendMenuMediator.ACTION_ONLINE )
					{
						index = _friendListCursor.remove(user);
						if( index >= 0 )
						{
							friendListDataProvider.removeItemAt(index);
						}
						gotoEmpty();
					}
					else if( _action == FriendMenuMediator.ACTION_ALL )
					{
						updateUserPosition(user);
					}
					model.userListPing.remove(user);
					
					break;
				
				case NAMES.USER_UPDATE:
					
					user = User(body);
					if( _action == FriendMenuMediator.ACTION_ONLINE || _action == FriendMenuMediator.ACTION_ALL )
					{
						updateUserPosition(user);
					}
					
					break;
				
				case NAMES.USER_ADD:
					
					user = User(body);
					if( _action == FriendMenuMediator.ACTION_ONLINE )
					{
						gotoNormal();
						if( _friendListCursor.hasUser( user ) )
						{
							updateUserPosition(user);
						}
						else
						{
							friendListDataProvider.addItemAt(user, _friendListCursor.add(user));
						}
					}
					else if( _action == FriendMenuMediator.ACTION_OFFLINE )
					{
						index = _friendListCursor.remove(user);
						if( index >= 0 )
						{
							friendListDataProvider.removeItemAt(index);
						}
						gotoEmpty();
					}
					else if( _action == FriendMenuMediator.ACTION_ALL )
					{
						gotoNormal();
						updateUserPosition(user);
					}
					model.userListPing.add(user);
					
					break;
				
				default:
					break;
				
			}
		}
		
		private function gotoNormal():void
		{
			if( model.friendList.length == 0 )
			{
				_view.currentState = "normal";
			}	
		}
		
		override protected function stateChangeComplete(state:String):void
		{
			if( state == "normal" )
			{
				if( !_view.friendList.hasEventListener(IndexChangeEvent.CHANGE) )
				{
					_view.friendList.addEventListener(IndexChangeEvent.CHANGE, menuHandler);
				}
			}
		}
		
		private function gotoEmpty():void
		{
			if( model.friendList.length == 0 )
			{
				_view.friendList.removeEventListener(IndexChangeEvent.CHANGE, menuHandler);
				_view.currentState = "empty";
			}
		}
		
		private function updateUserPosition(user:User):void
		{
			try
			{
				var replace:ReplaceResult = _friendListCursor.checkOnReplace(user, UserListCursor.onlineOfflineValueFunction);
				if( replace )
				{
					if( replace.needReplace )
					{
						friendListDataProvider.removeItemAt(replace.oldIndex);
						friendListDataProvider.addItemAt(user, replace.newIndex);
					}
					else
					{
						friendListDataProvider.itemUpdated(user);
					}
				}
				else
				{
					gotoNormal();
					friendListDataProvider.addItemAt(user, _friendListCursor.add(user, UserListCursor.onlineOfflineValueFunction));
				}
			}
			catch(error:Error)
			{
				friendListDataProvider.itemUpdated(user);
			}
		}
		
		public function get friendListDataProvider():ArrayList
		{
			return ArrayList(_view.friendList.dataProvider);
		}
		
		override protected function onMediatorRegister():void
		{
			FriendListView.dataProviderFunction = model.userViewBuilder.userListDataProviderFunction;	
			_action = data as String;
			var friendList:Vector.<User>;
			switch( _action )
			{
				
				case FriendMenuMediator.ACTION_ONLINE:
					
					friendList = model.friendFilter.onlineFriends;
					
					break;
				
				case UserMenuMediator.ACTION_OFFLINE:
					
					friendList = model.friendFilter.offlineFriends;
					
					break;
				
				case UserMenuMediator.ACTION_ALL:
					
					friendList = model.friendFilter.allFriends;
					
					break;
				
				default:
					break;
			}	
			if( friendList )
			{
				if( _action == UserMenuMediator.ACTION_ALL )
				{
					_friendListCursor = new UserListCursor(friendList, UserListCursor.onlineOfflineSortFunction);
				}
				else
				{
					_friendListCursor = new UserListCursor(friendList, UserListCursor.simpleSortFunction);
				}
			}	
			if( _action != UserMenuMediator.ACTION_OFFLINE )
			{
				model.userListPing.list = friendList;
				model.userListPing.start();
			}
		}
		
		override protected function onViewActive():void
		{
			if( _view.friendList )
			{
				_view.friendList.addEventListener(IndexChangeEvent.CHANGE, menuHandler);
			}
		}
		
		override protected function onViewAdd():void
		{	
			if( _friendListCursor.list.length == 0 )
			{
				_view.currentState = "empty";
			}
			else
			{
				_view.currentState = "normal";
			}
			switch( _action )
			{
				
				case FriendMenuMediator.ACTION_ALL:
					
					title = "Все";
					
					break;
				
				case FriendMenuMediator.ACTION_ONLINE:
					
					title = "В сети";
					
					break;
				
				default:
					break;
			}
			if( _view.friendList )
			{
				_view.friendList.dataProvider	= model.userViewBuilder.toDataProvider(_friendListCursor.list);
			}
			else
			{
				_view.friendList.dataProvider	= new ArrayList;
			}
		}
		
		private function menuHandler(event:IndexChangeEvent):void
		{
			sendNotification(NAMES.SELECT_USER, _view.friendList.selectedItem);
			sendNotification(NAMES.VIEW_GO, UserView);
		}
		
		override protected function onMediatorRemove():void
		{
			_friendListCursor.destroy();
			_friendListCursor = null;
		}
		
		override protected function onViewRemove():void
		{
			if( _view.friendList )
			{
				_view.friendList.removeEventListener(IndexChangeEvent.CHANGE, menuHandler);
				_view.friendList.dataProvider.removeAll();
				_view.friendList.dataProvider = null;
			}
			_view = null;
		}
	}
}