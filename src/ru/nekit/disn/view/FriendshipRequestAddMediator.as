package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.view.views.FriendshipRequestAddView;
	
	import spark.components.Button;
	
	public class FriendshipRequestAddMediator extends ViewMediator
	{
		
		public static const NAME:String = "friendshipRequestAddView";
		
		private var _view:FriendshipRequestAddView = null;
		
		public function FriendshipRequestAddMediator(viewComponent:Object=null)
		{
			_view = viewComponent as FriendshipRequestAddView;
			super(NAME, viewComponent);
			waitOnBack = true;
		}
		
		override protected function get backButton():Button
		{
			return _view.backCall;
		}
		
		public function get view():FriendshipRequestAddView
		{
			return _view;
		}
		
		override protected function onViewActive():void
		{
			_view.requestCall.addEventListener(MouseEvent.CLICK, requestCallHandler);
			_view.cancelCall.addEventListener(MouseEvent.CLICK, cancelCallHandler);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.requestCall.removeEventListener(MouseEvent.CLICK, requestCallHandler);
			_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
		}
		
		override protected function onViewAdd():void
		{
			_view.requestCall.height = dpi.getAutoSize(36);
			_view.cancelCall.height = dpi.getAutoSize(36);
			_view.field.prompt = CONST.FRIENDSHIP_REQUEST_ADD_TEXT;
			_view.focusManager.setFocus(_view.field);
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			back();
		}
		
		private function requestCallHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.FRIENDSHIP_REQUEST_ADD, _view.field.text);
			back();
		}
	}
}