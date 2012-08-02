package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.photo.PhotoLibrary;
	import ru.nekit.disn.model.types.UserPrivateRule;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.model.viewDataItem.MenuDataItem;
	import ru.nekit.disn.view.views.SexView;
	
	public class SexMediator extends ViewMediator
	{
		
		public static const NAME:String = "birthdayView";
		
		private var _view:SexView = null;
		private var _localUser:LocalUserProxy; 
		
		public function SexMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view = viewComponent as SexView;
		}
		
		public function get view():SexView
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
		}
		
		override protected function onMediatorRemove():void
		{
			_view.saveCall.removeEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
		}
		
		override protected function onViewRemove():void
		{
			_view.menu.dataProvider.removeAll();
			_view.menu.dataProvider = null;
			_view = null;
		}
		
		override protected function onViewAdd():void
		{
			_view.menu.iconField 	= "icon";
			_view.menu.labelField 	= "label";
			_view.menu.dataProvider = new ArrayList([
				new MenuDataItem("", "man", 	model.photoLibrary.getIconDPIBitmapDataByName(PhotoLibrary.MAN, 2)),
				new MenuDataItem("", "woman",  	model.photoLibrary.getIconDPIBitmapDataByName(PhotoLibrary.WOMAN, 2))
			])
			_view.menu.selectedIndex = _localUser.user.vo.sex - 1;
			_view.rule.selected = _localUser.hasDataAccessByField( UserPrivateRule.ALLOW_SEX ); 
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			back();
		}
		
		private function saveCallHandler(event:MouseEvent):void
		{
			_localUser.user.vo.sex 	=  _view.menu.selectedIndex + 1;
			_localUser.user.vo.rule	= _localUser.user.vo.rule | ( _view.rule.selected ? UserPrivateRule.ALLOW_SEX : 0 );
			_localUser.update();
			back();
		}
	}
}