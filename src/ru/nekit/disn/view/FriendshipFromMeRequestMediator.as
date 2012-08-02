package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.friend.FriendshipRequestList;
	import ru.nekit.disn.model.vo.FriendshipRequestVO;
	import ru.nekit.disn.view.views.FriendshipFromMeRequestView;
	
	import spark.components.Button;
	
	public class FriendshipFromMeRequestMediator extends ViewMediator
	{
		
		public static const NAME:String = "friendshipFromMeRequestView";
		
		private var _view:FriendshipFromMeRequestView = null;
		private var _friendshipRequestList:FriendshipRequestList;
		private var _request:FriendshipRequestVO;
		
		public function FriendshipFromMeRequestMediator(viewComponent:Object=null)
		{
			_view = viewComponent as FriendshipFromMeRequestView;
			super(NAME, viewComponent);
		}
		
		override protected function get backButton():Button
		{
			return _view.backCall;
		}
		
		public function get view():FriendshipFromMeRequestView
		{
			return _view;
		}
		
		override protected function onMediatorRegister():void
		{			
			
		}
		
		override protected function onViewActive():void
		{
			_view.cancelCall.addEventListener(MouseEvent.CLICK, cancelCallHandler);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
		}
		
		override protected function onViewAdd():void
		{
			_request = model.friendshipRequestList.getRequest(model.currentUser.user.user);
			_view.request.text = _request.text;
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.FRIENDSHIP_REQUEST_REMOVE);
			back();
		}
	}
}