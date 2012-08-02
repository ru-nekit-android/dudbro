package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.*;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.types.NotificationType;
	import ru.nekit.disn.model.viewDataItem.MenuDataItem;
	import ru.nekit.disn.view.views.*;
	
	public class MainMenuMediator extends ViewMediator
	{
		
		public static const NAME:String = "mainMenu";
		
		private var _view:MainMenuView;
		private var _messageMenuItem:MenuDataItem;
		private var _friendshipMenuItem:MenuDataItem;
		private var _selectedItem:MenuDataItem;
		
		public function MainMenuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view = viewComponent as MainMenuView;
			_selectedItem = new MenuDataItem;
			_view.exitCall.height = dpi.getAutoSize(36);
		}
		
		public function get view():MainMenuView
		{
			return _view;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.NOTIFICATION_STATUS_UPDATE,
				NAMES.MODEL_INIT_COMPLETE,
				NAMES.USER_ENTER
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var body:Object = notification.getBody();
			var name:String = notification.getName();
			var type:String = notification.getType();
			switch( name )
			{
				
				case NAMES.MODEL_INIT_COMPLETE:
					
					updateNotificationMessage();
					updateFriendshipRequest();
					
					break;
				
				case NAMES.USER_ENTER:
					
					createMainMenu();
					
					_view.titleLabel.text	= model.localUser.nickname;
					_view.menu.selectedIndex = 0;
					_view.menu.addEventListener(MouseEvent.CLICK, listClickHandler);
					
					break;
				
				case NAMES.NOTIFICATION_STATUS_UPDATE:
					
					switch( type )
					{
						
						case NotificationType.NOTIFICATION_MESSAGE:
							
							updateNotificationMessage();
							
							break;
						
						case NotificationType.NOTIFICATION_FRIENDSHIP:
							
							updateFriendshipRequest();
							
							break;
						
						default:
							break;
						
					}
					
					break;
				
				default:
					break;
				
			}
		}
		
		private function updateNotificationMessage():void
		{
			var count:uint = model.notificationMessageTreeList.length;
			if( count > 0 )
			{
				_messageMenuItem.hint = "+" + count;
			}
			else
			{
				_messageMenuItem.hint = null;
			}
		}
		
		private function updateFriendshipRequest():void
		{
			var count:uint = model.friendshipRequestFilter.toME.length;// + _friendshipRequestFilter.confirmFromME.length;
			if( count > 0 )
			{
				_friendshipMenuItem.hint = "+" + count;
			}
			else
			{
				_friendshipMenuItem.hint = null;
			}
		}
		
		override protected function onMediatorRegister():void
		{
			var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			_view.navigator.width 	= appMediator.view.menuNavigatorSnapshot.width 	= appMediator.view.width - appMediator.menuButtonWidth;
			_view.navigator.x		= appMediator.view.menuNavigatorSnapshot.x		= appMediator.menuButtonWidth;
		}
		
		override protected function onViewActive():void
		{
			_view.exitCall.addEventListener(MouseEvent.CLICK, exitCallHandler);
		}
		
		private function exitCallHandler(event:MouseEvent):void
		{
			_view.exitCall.removeEventListener(MouseEvent.CLICK, exitCallHandler);
			sendNotification(NAMES.APPLICATION_CLOSE);
		}
		
		private function createMainMenu():void
		{
			_view.menu.dataProvider = new ArrayCollection(
				[
					new MenuDataItem("Профиль студента", 					StudentProfileView),
					new MenuDataItem("Я", 									MeView),
					new MenuDataItem("Мой компьютер", 						MyComputerView),
					new MenuDataItem("Пользователи", 						UserMenuView),
					_friendshipMenuItem = new MenuDataItem("Друзья", 		FriendMenuView),
					_messageMenuItem 	= new MenuDataItem("Сообщения", 	MessageMenuView),
					new MenuDataItem("Настройка"),
				]
			);
		}		
		
		private function listClickHandler(event:MouseEvent):void
		{
			var selectedItem:MenuDataItem = _view.menu.selectedItem as MenuDataItem;
			if( _selectedItem.action != selectedItem.action)
			{
				sendNotification(NAMES.VIEW_GO, selectedItem.action);
			}
			else
			{
				sendNotification(NAMES.MAIN_MENU_CLOSE);
			}
			_selectedItem =  selectedItem;
		}
	}
}