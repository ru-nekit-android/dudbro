package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.view.views.UniversityOtherView;
	
	public class UniversityOtherMediator extends ViewMediator
	{
		
		public static const NAME:String = "universityOtherView";
		
		private var _view:UniversityOtherView = null;
		private var _localUser:LocalUserProxy; 
		
		public function UniversityOtherMediator(viewComponent:Object=null)
		{
			_view = viewComponent as UniversityOtherView;
			super(NAME, viewComponent);
		}
		
		public function get view():UniversityOtherView
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
			_view.focusManager.setFocus(_view.group);
			var text:String = _localUser.university.vo.group || "";
			_view.group.selectRange(text.length, text.length);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.saveCall.removeEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
		}
		
		override protected function onViewAdd():void
		{
			_view.group.text 				= _localUser.university.vo.group;
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			_view.group.text = _localUser.university.vo.group;
			back();
		}
		
		private function saveCallHandler(event:MouseEvent):void
		{
			_localUser.university.vo.group 			= _view.group.text;
			_localUser.update();
			back();
		}
	}
}