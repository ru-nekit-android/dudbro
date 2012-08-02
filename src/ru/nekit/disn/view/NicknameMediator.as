package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.view.views.NicknameView;
	
	public class NicknameMediator extends ViewMediator
	{
		
		public static const NAME:String = "nicknameView";
		
		private var _view:NicknameView = null;
		private var _localUser:LocalUserProxy; 
		
		public function NicknameMediator(viewComponent:Object=null)
		{
			_view = viewComponent as NicknameView;
			super(NAME, viewComponent);
		}
		
		public function get view():NicknameView
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
			setFocus();
		}
		
		private function setFocus():void
		{
			_view.focusManager.setFocus(_view.nickname);
			var text:String = _localUser.user.nickname;
			_view.nickname.selectRange(text.length, text.length);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.saveCall.removeEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
		}
		
		override protected function onViewAdd():void
		{
			_view.nickname.text 		= _localUser.user.vo.nickname;
			_view.titleContainer.height = dpi.getAutoSize(100);
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			_view.nickname.text = _localUser.user.vo.nickname;
			back();
		}
		
		private function saveCallHandler(event:MouseEvent):void
		{
			_localUser.nickname = _view.nickname.text;
			back();
		}
	}
}