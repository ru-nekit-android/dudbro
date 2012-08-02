package ru.nekit.disn.view
{
	
	import mx.collections.ArrayList;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.cursor.UserListCursor;
	import ru.nekit.disn.model.filter.ReplaceResult;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.view.views.*;
	
	import spark.components.Button;
	import spark.events.IndexChangeEvent;
	
	public class UserListMediator extends ViewMediator
	{
		
		public static const NAME:String = "userListView";
		
		private var _view:UserListView = null;
		private var _userListCursor:UserListCursor;
		
		private var _action:String;
		
		public function UserListMediator(viewComponent:Object=null)
		{
			_view = viewComponent as UserListView;
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
		
		public function get view():UserListView
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
					
					if( _action == UserMenuMediator.ACTION_OFFLINE )
					{
						gotoNormal();
						userListDataProvider.addItemAt(user, _userListCursor.add(user));
					}
					else if( _action == UserMenuMediator.ACTION_ONLINE )
					{
						index = _userListCursor.remove(user);
						if( index >= 0 )
						{
							userListDataProvider.removeItemAt(index);
						}
						gotoEmpty();
					}
					else if( _action == UserMenuMediator.ACTION_ALL || _action == UserMenuMediator.ACTION_FAVORITES )
					{
						updateUserPosition(user);
					}
					model.userListPing.remove(user);
					
					break;
				
				case NAMES.USER_UPDATE:
					
					user = User(body);
					if( _action == UserMenuMediator.ACTION_ONLINE || _action == UserMenuMediator.ACTION_ALL || _action == UserMenuMediator.ACTION_FAVORITES)
					{
						updateUserPosition(user);
					}
					
					break;
				
				case NAMES.USER_ADD:
					
					user = User(body);
					if( _action == UserMenuMediator.ACTION_ONLINE )
					{
						gotoNormal();
						if( _userListCursor.hasUser( user ) )
						{
							updateUserPosition(user);
						}
						else
						{
							userListDataProvider.addItemAt(user, _userListCursor.add(user));
						}
					}
					else if( _action == UserMenuMediator.ACTION_OFFLINE )
					{
						index = _userListCursor.remove(user);
						if( index >= 0 )
						{
							userListDataProvider.removeItemAt(index);
						}
						gotoEmpty();
					}
					else if( _action == UserMenuMediator.ACTION_ALL )
					{
						gotoNormal();
						updateUserPosition(user);
					}
					else if(  _action == UserMenuMediator.ACTION_FAVORITES )
					{
						if( model.favoriteUserList.hasFavorite(user) )
						{
							gotoNormal();
							updateUserPosition(user);
						}
					}
					model.userListPing.add(user);
					
					break;
				
				default:
					break;
				
			}
		}
		
		private function gotoNormal():void
		{
			if( _userListCursor.list.length == 0 )
			{
				_view.currentState = "normal";
			}	
		}
		
		override protected function stateChangeComplete(state:String):void
		{
			if( state == "normal" )
			{
				if( !_view.userList.hasEventListener(IndexChangeEvent.CHANGE) )
				{
					_view.userList.addEventListener(IndexChangeEvent.CHANGE, menuHandler);
				}
			}
		}
		
		private function gotoEmpty():void
		{
			if( _userListCursor.list.length == 0 )
			{
				_view.userList.removeEventListener(IndexChangeEvent.CHANGE, menuHandler);
				_view.currentState = "empty";
			}
		}
		
		private function updateUserPosition(user:User):void
		{
			try
			{
				var replace:ReplaceResult = _userListCursor.checkOnReplace(user, UserListCursor.onlineOfflineValueFunction);
				if( replace )
				{
					if( replace.needReplace )
					{
						userListDataProvider.removeItemAt(replace.oldIndex);
						userListDataProvider.addItemAt(user, replace.newIndex);
					}
					else
					{
						userListDataProvider.itemUpdated(user);
					}
				}
				else
				{
					gotoNormal();
					userListDataProvider.addItemAt(user, _userListCursor.add(user, UserListCursor.onlineOfflineValueFunction));
				}
			}
			catch(error:Error)
			{
				userListDataProvider.itemUpdated(user);
			}
		}
		
		public function get userListDataProvider():ArrayList
		{
			return ArrayList(_view.userList.dataProvider);
		}
		
		override protected function onMediatorRegister():void
		{
			model.currentUser.reset();
			UserListView.dataProviderFunction = model.userViewBuilder.userListDataProviderFunction;
			_action = data as String;
			var userList:Vector.<User>;
			switch( _action )
			{
				
				case UserMenuMediator.ACTION_ONLINE:
					
					userList = model.userFilter.onlineUsers;
					
					break;
				
				case UserMenuMediator.ACTION_OFFLINE:
					
					userList = model.userFilter.offlineUsers;
					
					break;
				
				case UserMenuMediator.ACTION_ALL:
					
					userList = model.userFilter.allUsers;
					
					break;
				
				case UserMenuMediator.ACTION_FAVORITES:
					
					userList = model.favoriteUserList.list;
					
					break;
				
				default:
					break;
			}
			if( userList )
			{
				if( _action == UserMenuMediator.ACTION_ALL )
				{
					_userListCursor = new UserListCursor(userList, UserListCursor.onlineOfflineSortFunction);
				}
				else
				{
					_userListCursor = new UserListCursor(userList, UserListCursor.simpleSortFunction);
				}
			}
			if( _action != UserMenuMediator.ACTION_OFFLINE )
			{
				model.userListPing.start();
			}
		}
		
		override protected function onViewActive():void
		{
			if( _view.userList )
			{
				_view.userList.addEventListener(IndexChangeEvent.CHANGE, menuHandler);
			}
		}
		
		override protected function onViewAdd():void
		{
			if( _userListCursor.list.length == 0 )
			{
				_view.currentState = "empty";
			}
			else
			{
				_view.currentState = "normal";
			}		
			switch( _action )
			{
				
				case UserMenuMediator.ACTION_ONLINE:
					
					title = "В сети";
					
					break;
				
				case UserMenuMediator.ACTION_OFFLINE:
					
					title = "Вне сети";
					
					break;
				
				case UserMenuMediator.ACTION_ALL:
					
					title = "Все";
					
					break;
				
				case UserMenuMediator.ACTION_FAVORITES:
					
					title = "Избранные";
					
					break;
				
				default:
					break;
				
			}
			if( _view.userList )
			{
				_view.userList.dataProvider	= model.userViewBuilder.toDataProvider(_userListCursor.list);
			}
			else
			{
				_view.userList.dataProvider	= new ArrayList;
			}
		}
		
		private function menuHandler(event:IndexChangeEvent):void
		{
			sendNotification(NAMES.SELECT_USER, _view.userList.selectedItem);
			sendNotification(NAMES.VIEW_GO, UserView);
		}
		
		override protected function onMediatorRemove():void
		{
			model.userListPing.stop();
			_userListCursor.destroy();
			_userListCursor = null;
		}
		
		override protected function onViewRemove():void
		{
			if( _view.userList )
			{
				_view.userList.removeEventListener(IndexChangeEvent.CHANGE, menuHandler);
				_view.userList.dataProvider.removeAll();
				_view.userList.dataProvider = null;
			}
			_view = null;
		}
	}
}