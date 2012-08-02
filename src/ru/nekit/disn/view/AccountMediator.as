package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.types.AccountType;
	import ru.nekit.disn.model.types.UserPrivateRule;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.model.viewDataItem.MenuDataItem;
	import ru.nekit.disn.view.views.AccountView;
	import ru.nekit.disn.view.views.BirthdayView;
	
	import spark.formatters.DateTimeFormatter;
	
	public class AccountMediator extends ViewMediator
	{
		
		public static const NAME:String = "accountView";
		
		private var _view:AccountView = null;
		private var _localUser:LocalUserProxy; 
		
		public function AccountMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view = viewComponent as AccountView;
			waitOnBack = true;
			waitTime = 500;
		}
		
		public function get view():AccountView
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
			_view.accountContainer.addEventListener(MouseEvent.CLICK, accountClickHanlder);
			_view.okCall.addEventListener(MouseEvent.CLICK, okClickHandler);
			_view.cancelDateCall.addEventListener(MouseEvent.CLICK, cancelDateClickHandler);
		}
		
		private function cancelDateClickHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.MENU_CLOSE);
		}
		
		private function okClickHandler(event:MouseEvent):void
		{
			updateAccountLabel(_view.accountTypeChoice.selectedItem);
			sendNotification(NAMES.MENU_CLOSE);
		}
		
		private function accountClickHanlder(event:MouseEvent):void
		{
			sendNotification(NAMES.MENU_OPEN);
			_view.accountTypeChoice.dataProvider = AccountType.list;
		}
		
		override protected function onMediatorRemove():void
		{
			_view.saveCall.removeEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
			_view.accountContainer.removeEventListener(MouseEvent.CLICK, accountClickHanlder);
			_view.okCall.removeEventListener(MouseEvent.CLICK, okClickHandler);
			_view.cancelDateCall.removeEventListener(MouseEvent.CLICK, cancelDateClickHandler);
		}
		
		override protected function onViewAdd():void
		{
			//updateBirtdayLabel(_localUser.user.vo.birthDay);
			//_view.rule.selected 		= _localUser.hasDataAccessByField( UserPrivateRule.ALLOW_BIRTHDAY ); 
			_view.okCall.height 	= dpi.getAutoSize(46);
			_view.cancelDateCall.height = dpi.getAutoSize(46);
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			//updateAccountLabel(_localUser.user.vo.birthDay);
			back();	
		}
		
		private function updateAccountLabel(item:MenuDataItem):void
		{
			if( item )
			{
				_view.account.text = item.label;
			}
			else
			{
				_view.account.text = null;
			}
		}
		
		private function saveCallHandler(event:MouseEvent):void
		{
			/*if( _date )
			{
				_localUser.user.vo.birthDay = _date;
			}*/
			_localUser.update();
			back();
		}
	}
}