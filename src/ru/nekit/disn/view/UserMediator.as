package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.phone.SMSData;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.viewDataItem.MenuDataItem;
	import ru.nekit.disn.view.views.AboutView;
	import ru.nekit.disn.view.views.FriendRemoveView;
	import ru.nekit.disn.view.views.FriendshipFromMeRequestView;
	import ru.nekit.disn.view.views.FriendshipRequestAddView;
	import ru.nekit.disn.view.views.MessageView;
	import ru.nekit.disn.view.views.UserView;
	import ru.nekit.utils.DataUtil;
	
	import spark.components.Button;
	import spark.events.IndexChangeEvent;
	import spark.formatters.DateTimeFormatter;
	
	public class UserMediator extends ViewMediator
	{
		
		public static const NAME:String 									= "userView";
		
		private static const ACTION_FAVORITE_ADD:String 					= "favorite_add";
		private static const ACTION_FAVORITE_REMOVE:String 					= "favorite_remove";
		
		private static const ACTION_FRIENDSHIP_REQUEST_ADD:String 			= "friendship_add";
		private static const ACTION_FRIENDSHIP_FROM_ME_REQUEST_VIEW:String 	= "friendship_from_me_view";
		private static const ACTION_FRIENDSHIP_TO_ME_REQUEST_VIEW:String 	= "friendship_to_me_view";
		private static const ACTION_FRIEND_REMOVE:String 					= "friend_remove";
		
		private static const ACTION_ABOUT:String 							= "about";
		private static const ACTION_MESSAGE:String 							= "message";
		
		private var _view:UserView = null;
		private var _friendshipBlockMediator:FriendshipBlockMediator;
		
		private var _favoriteMenuItem:MenuDataItem;	
		
		public function UserMediator(viewComponent:Object=null)
		{
			_view = viewComponent as UserView;
			super(NAME, viewComponent);
			hasMenu = true;
		}
		
		public function get view():UserView
		{
			return _view;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.USER_ADD,
				NAMES.USER_EXIT,
				NAMES.USER_PING,
				NAMES.USER_UPDATE,
				NAMES.USER_FRIENDSHIP_REQUEST_ADD,
				NAMES.USER_FRIENDSHIP_REQUEST_REMOVE,
				NAMES.USER_FRIENDSHIP_REQUEST_ABORT,
				NAMES.FRIEND_ADD,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{	
			var body:Object = notification.getBody();
			var name:String = notification.getName();
			var user:User;
			switch( name )
			{	
				
				case NAMES.USER_PING:
					
					user = body as User;
					if( user.uid == model.currentUser.user.user.uid )
					{
						updateCurrentState();
					}
					
					break;
				
				case NAMES.USER_FRIENDSHIP_REQUEST_ADD:
				case NAMES.USER_FRIENDSHIP_REQUEST_REMOVE:
				case NAMES.USER_FRIENDSHIP_REQUEST_ABORT:
				case NAMES.FRIEND_ADD:
				case NAMES.USER_UPDATE:
					
					user = body as User;
					if( user.uid == model.currentUser.user.user.uid )
					{
						updateView();
						updateMenu();
					}
					
					break;
				
				case NAMES.USER_ADD:
					
					user = body as User;
					if( user.uid == model.currentUser.user.user.uid )
					{
						currentState = "online";
						model.currentUser.user.ping.start();
					}
					
					break;
				
				case NAMES.USER_EXIT:
					
					user = body as User;
					if( user.uid == model.currentUser.user.user.uid )
					{
						currentState = "offline";
						model.currentUser.user.ping.stop();
					}
					
					break;
				
				default:
					break;
				
			}
		}
		
		override protected function onViewActive():void
		{
			_view.menu.addEventListener(IndexChangeEvent.CHANGE, menuClickHandler);
			_view.phoneCall.addEventListener(MouseEvent.CLICK, phoneCallHandler);
			_view.smsCall.addEventListener(MouseEvent.CLICK, smsCallHandler);
			_view.phoneArrow.addEventListener(MouseEvent.CLICK, phoneArrowClickHandler);
			_view.statusArrow.addEventListener(MouseEvent.CLICK, statusArrowClickHandler);
			_view.ageArrow.addEventListener(MouseEvent.CLICK, ageArrowClickHandler);
		}
		
		private function ageArrowClickHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.MENU_OPEN, _view.birthdayContent);
			var formatter:DateTimeFormatter = new DateTimeFormatter;
			formatter.dateTimePattern ="dd MMMM yyyy"
			_view.ageFullText.text = formatter.format(model.currentUser.user.birthday);
		}
		
		private function smsCallHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.MENU_CLOSE);
			sendNotification(NAMES.PHONE_SEND_SMS, new SMSData(model.currentUser.user.phone, "Сообщение от " + model.localUser.nickname ));
		}
		
		private function phoneCallHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.MENU_CLOSE);
			sendNotification(NAMES.PHONE_PHONE_CALL, model.currentUser.user.phone);
		}
		
		private function phoneArrowClickHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.MENU_OPEN, _view.phoneContent);	
		}
		
		private function statusArrowClickHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.MENU_OPEN, _view.statusContent);	
			_view.statusFullText.text		= model.currentUser.user.status;
			//_view.aboutFullText.text		= model.currentUser.user.aboutMe;
		}
		
		private function menuClickHandler(event:IndexChangeEvent):void
		{
			var action:String = (_view.menu.dataProvider.getItemAt(event.newIndex) as MenuDataItem).action;
			switch( action )
			{
				case ACTION_ABOUT:
					
					sendNotification(NAMES.VIEW_GO, AboutView);
					
					break;
				
				case ACTION_FAVORITE_ADD:
					
					model.currentUser.user.addToFavorites();
					updateFavoriteItem();
					
					break;
				
				case ACTION_FAVORITE_REMOVE:
					
					model.currentUser.user.removeFromFavorites();
					updateFavoriteItem();
					
					break;
				
				case ACTION_FRIENDSHIP_REQUEST_ADD:
					
					sendNotification(NAMES.VIEW_GO, FriendshipRequestAddView);
					
					break;
				
				case ACTION_FRIEND_REMOVE:
					
					sendNotification(NAMES.VIEW_GO, FriendRemoveView);
					
					break;
				
				case ACTION_FRIENDSHIP_FROM_ME_REQUEST_VIEW:
					
					sendNotification(NAMES.VIEW_GO, FriendshipFromMeRequestView);
					
					break;
				
				case ACTION_MESSAGE:
					
					sendNotification(NAMES.SELECT_MESSAGE, model.currentUser.user.user);
					sendNotification(NAMES.VIEW_GO, MessageView);
					
					break;
				
				default:
					break;
			}
			_view.menu.selectedIndex = -1;
		}
		
		override protected function get backButton():Button
		{
			return _view.backCall;
		}
		
		override protected function get mainMenuButton():Button
		{
			return _view.mainMenu;
		}
		
		override protected function onMediatorRegister():void
		{
			_favoriteMenuItem = new MenuDataItem;
			facade.registerMediator(new FriendshipBlockMediator(_view.friendshipBlock));
			model.currentUser.user.ping.start();
		}
		
		override protected function onViewAdd():void
		{
			_view.fullnameContainer.minHeight 		= dpi.getAutoSize(64);
			_view.descriptionContainer.minHeight 	= dpi.getAutoSize(30);
			updateCurrentState();
			updateMenu();
		}
		
		private function updateMenu():void
		{
			var menuDataProvider:ArrayList = new ArrayList;
			menuDataProvider.addItem(new MenuDataItem("Написать сообщение", ACTION_MESSAGE));
			menuDataProvider.addItem(updateFavoriteItem());
			_view.menu.dataProvider = menuDataProvider;
		}
		
		private function updateFavoriteItem():MenuDataItem
		{
			if( model.currentUser.user.isFavorite )
			{
				_favoriteMenuItem.label = "Удалить из избранных";
				_favoriteMenuItem.action = ACTION_FAVORITE_REMOVE;
			}
			else
			{
				_favoriteMenuItem.label = "Добавить в избранные";
				_favoriteMenuItem.action = ACTION_FAVORITE_ADD;
			}
			return _favoriteMenuItem;
		}
		
		private function updateCurrentState():void
		{
			currentState = model.currentUser.user.online ? "online" : "offline";
		}
		
		override protected function stateChangeComplete(state:String):void
		{
			updateView();
		}
		
		private function updateView():void
		{
			_view.photo.source		= model.currentUser.user.photo.source;
			_view.nickname.text 	= model.currentUser.user.displayName;
			_view.title				= model.currentUser.user.nickname;
			_view.status.text 		= model.currentUser.user.status;
			var fullname:String 	= model.currentUser.user.fullname;
			var sex:String 			= model.currentUser.user.sexString;
			var age:String 			= model.currentUser.user.ageString;
			var phone:String 		= model.currentUser.user.phone;
			if( fullname )
			{
				_view.fullname.text 	= fullname;
			}
			else
			{
				_view.fullname.text = "Имя скрыто";
			}
			if( sex )
			{
				_view.sex.text 	= sex;
				_view.sex.setStyle("fontStyle", "normal");	
			}
			else
			{
				_view.sex.text = "Пол скрыт";
				_view.sex.setStyle("fontStyle", "italic");	
			}
			if( age )
			{
				_view.age.text 	= age;
				_view.age.setStyle("fontStyle", "normal");	
				includeIn(_view.ageArrow, true);
				_view.ageLayout.paddingRight = 30;
			}
			else
			{
				_view.age.text 	= "Возраст скрыт";
				_view.age.setStyle("fontStyle", "italic");	
				includeIn(_view.ageArrow, false);
				_view.ageLayout.paddingRight = 0;
			}
			if( phone )
			{
				_view.phone.text 	= DataUtil.normalizePhoneNumber(phone);
				_view.phone.setStyle("fontStyle", "normal");	
				includeIn(_view.phoneArrow, true);
			}
			else
			{
				_view.phone.text 	= "Телефон скрыт";
				_view.phone.setStyle("fontStyle", "italic");	
				includeIn(_view.phoneArrow, false);
			}
			includeIn(_view.statusArrow, !DataUtil.isEmpty(model.currentUser.user.status));
		}
		
		override protected function onMediatorRemove():void
		{
			_view.phoneCall.removeEventListener(MouseEvent.CLICK, phoneCallHandler);
			_view.smsCall.removeEventListener(MouseEvent.CLICK, smsCallHandler);
			_view.phoneArrow.removeEventListener(MouseEvent.CLICK, phoneArrowClickHandler);
			_view.statusArrow.removeEventListener(MouseEvent.CLICK, statusArrowClickHandler);
			_view.ageArrow.removeEventListener(MouseEvent.CLICK, ageArrowClickHandler);
			_view.menu.removeEventListener(MouseEvent.CLICK, menuClickHandler);
			facade.removeMediator(FriendshipBlockMediator.NAME);
			model.currentUser.user.ping.stop();
			_view = null;
		}
	}
}