package ru.nekit.disn.view
{
	
	import mx.collections.ArrayList;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.filter.*;
	import ru.nekit.disn.model.user.*;
	import ru.nekit.disn.view.views.*;
	
	import spark.components.Button;
	import spark.events.IndexChangeEvent;
	
	public class FriendshipRequestListMediator extends ViewMediator
	{
		
		public static const NAME:String = "friendshipRequestListView";
		
		private var _view:FriendshipRequestListView;
		private var _action:String;
		private var _friendshipRequestList:Vector.<User>;
		
		public function FriendshipRequestListMediator(viewComponent:Object=null)
		{
			_view = viewComponent as FriendshipRequestListView;
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
		
		public function get view():FriendshipRequestListView
		{
			return _view;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var body:Object = notification.getBody();
			var name:String = notification.getName();
			var user:User;
			
			switch( name )
			{
				
				default:
					break;
				
			}
		}
		
		private function gotoNormal():void
		{
			if( _friendshipRequestList.length == 0 )
			{
				_view.currentState = "normal";
			}	
		}
		
		override protected function stateChangeComplete(state:String):void
		{
			if( state == "normal" )
			{
				_view.friendshipRequestList.dataProvider	= new ArrayList;
				if( !_view.friendshipRequestList.hasEventListener(IndexChangeEvent.CHANGE) )
				{
					_view.friendshipRequestList.addEventListener(IndexChangeEvent.CHANGE, listHandler);
				}
			}
		}
		
		private function gotoEmpty():void
		{
			if( _friendshipRequestList.length == 0 )
			{
				_view.friendshipRequestList.removeEventListener(IndexChangeEvent.CHANGE, listHandler);
				_view.currentState = "empty";
			}
		}
		
		
		public function get userListDataProvider():ArrayList
		{
			return ArrayList(_view.friendshipRequestList.dataProvider);
		}
		
		override protected function onMediatorRegister():void
		{
			_action = data as String;
			UserListView.dataProviderFunction 	= model.userViewBuilder.userListDataProviderFunction;
		}
		
		override protected function onViewActive():void
		{
			if( _view.friendshipRequestList )
			{
				_view.friendshipRequestList.addEventListener(IndexChangeEvent.CHANGE, listHandler);
			}
		}
		
		override protected function onViewAdd():void
		{
			switch( _action )
			{
				
				case FriendMenuMediator.ACTION_REQUEST_TO_ME:
					
					title = "Запросы ко мне";
					_friendshipRequestList = model.friendshipRequestFilter.toME;
					
					break;
				
				case FriendMenuMediator.ACTION_REQUEST_FROM_ME:
					
					title = "Запросы от меня";
					_friendshipRequestList = model.friendshipRequestFilter.fromME;
					
					break;
				
				default:
					break;
			}
			if( _friendshipRequestList.length == 0 )
			{
				currentState = "empty";
			}
			else
			{
				_view.friendshipRequestList.dataProvider	= model.userViewBuilder.toDataProvider(_friendshipRequestList);
			}
		}
		
		private function listHandler(event:IndexChangeEvent):void
		{
			sendNotification(NAMES.SELECT_USER, _view.friendshipRequestList.selectedItem);
			if( _action == FriendMenuMediator.ACTION_REQUEST_FROM_ME )
			{
				sendNotification(NAMES.VIEW_GO, FriendshipFromMeRequestView);
			}
			else
			{
				sendNotification(NAMES.VIEW_GO, UserView);
			}
		}
		
		override protected function onMediatorRemove():void
		{
			if( _view.friendshipRequestList )
			{
				_view.friendshipRequestList.addEventListener(IndexChangeEvent.CHANGE, listHandler);
			}
		}
		
		override protected function onViewRemove():void
		{
			if( _view.friendshipRequestList && _view.friendshipRequestList.dataProvider )
			{
				_view.friendshipRequestList.dataProvider.removeAll();
				_view.friendshipRequestList.dataProvider = null;
			}
			_view = null;
		}
	}
}