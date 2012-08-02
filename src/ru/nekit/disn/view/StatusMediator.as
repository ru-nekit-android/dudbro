package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.view.views.StatusView;
	
	public class StatusMediator extends ViewMediator
	{
		
		public static const NAME:String = "statusView";
		
		private var _view:StatusView = null;
		private var _localUser:LocalUserProxy; 
		
		public function StatusMediator(viewComponent:Object=null)
		{
			_view = viewComponent as StatusView;
			super(NAME, viewComponent);
		}
		
		public function get view():StatusView
		{
			return _view;
		}
		
		override protected function onMediatorRegister():void
		{			
			_localUser = model.localUser;
		}
		
		override protected function onViewActive():void
		{
			_view.saveCall.addEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.addEventListener(MouseEvent.CLICK, cancelCallHandler);
			_view.stage.focus = null;
			_view.field.setFocus();
			var text:String  = _localUser.user.status || "";
			_view.field.selectRange(text.length, text.length);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.saveCall.removeEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
		}
		
		override protected function onViewAdd():void
		{
			_view.field.prompt = CONST.STATUS_PROMPT;
			_view.field.text = _localUser.user.status;
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			_view.field.text = _localUser.user.status;
			back();
		}
		
		private function saveCallHandler(event:MouseEvent):void
		{
			_localUser.user.status	= _view.field.text;
			_localUser.update();
			back();
		}
	}
}