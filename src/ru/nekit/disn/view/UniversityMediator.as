package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.view.views.UniversityView;
	
	public class UniversityMediator extends ViewMediator
	{
		
		public static const NAME:String = "universityView";
		
		private var _view:UniversityView = null;
		private var _localUser:LocalUserProxy; 
		
		public function UniversityMediator(viewComponent:Object=null)
		{
			_view = viewComponent as UniversityView;
			super(NAME, viewComponent);
		}
		
		public function get view():UniversityView
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
			_view.focusManager.setFocus(_view.university);
			var text:String = _localUser.university.vo.name || "";
			_view.university.selectRange(text.length, text.length);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.saveCall.removeEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
		}
		
		override protected function onViewAdd():void
		{
			_view.university.text 				= _localUser.university.vo.name;
			_view.universityDiscription.text 	= _localUser.university.vo.description;
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			_view.university.text = _localUser.university.vo.name;
			back();
		}
		
		private function saveCallHandler(event:MouseEvent):void
		{
			_localUser.university.vo.name 			= _view.university.text;
			_localUser.university.vo.description 	= _view.universityDiscription.text;
			_localUser.update();
			back();
		}
	}
}