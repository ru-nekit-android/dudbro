package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.auth.Auth;
	import ru.nekit.disn.view.views.RememberMeView;
	
	public class RememberMeMediator extends ViewMediator
	{
		
		public static const NAME:String = "rememberMe";
		
		private var _view:RememberMeView;
		
		public function RememberMeMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view = viewComponent as RememberMeView;
		}
		
		public function get view():RememberMeView
		{
			return _view;
		}
		
		override protected function onViewActive():void
		{
			_view.okCall.addEventListener(MouseEvent.CLICK, okCallHandler);
		}
		
		override protected function onViewAdd():void
		{
			_view.okCall.height 		= dpi.getAutoSize(56);
			_view.titleContainer.height = dpi.getAutoSize(60);
		}
		
		private function okCallHandler(event:MouseEvent):void
		{
			var auth:Auth 		= model.auth;
			auth.vo.remember 	= _view.remember.selected;
			auth.save();
			sendNotification(NAMES.USER_ENTER);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.okCall.removeEventListener(MouseEvent.CLICK, okCallHandler);
			_view = null;
		}
	}
}