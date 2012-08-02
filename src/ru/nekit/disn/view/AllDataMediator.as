package ru.nekit.disn.view
{
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.viewDataItem.MenuDataItem;
	import ru.nekit.disn.view.views.*;
	
	import spark.components.Button;
	import spark.components.ButtonBar;
	import spark.components.supportClasses.ListBase;
	import spark.events.IndexChangeEvent;
	
	public class AllDataMediator extends ViewMediator
	{
		
		public static const NAME:String = "alldDataView";
		
		private var _view:AllDataView = null;
		
		public function AllDataMediator(viewComponent:Object=null)
		{
			_view = viewComponent as AllDataView;
			super(NAME, viewComponent);
			hasMenu = true;
		}
		
		public function get view():AllDataView
		{
			return _view;
		}
		
		override protected function get backButton():Button
		{
			return _view.backCall;
		}
		
		private function get menuPrivateDataProvider():IList
		{
			return new ArrayList(
				[
					new MenuDataItem("Имя", FullnameView),
					new MenuDataItem("Пол", SexView),
					new MenuDataItem("День рождения", BirthdayView),
					new MenuDataItem("Телефон", PhoneView),
					new MenuDataItem("Настройки приватности", PrivateRuleView)
				]
			);
		}
		
		private function get menuSocialDataProvider():IList
		{
			return new ArrayList(
				[
					new MenuDataItem("Никнейм", NicknameView),
					new MenuDataItem("О себе", AboutMeView),
					new MenuDataItem("Статус", StatusView),
					new MenuDataItem("Акаунты", AccountView),
				]
			);
		}		
		
		override protected function onViewAdd():void
		{
			_view.menuPrivate.dataProvider 	= menuPrivateDataProvider;
			_view.menuSocial.dataProvider 	= menuSocialDataProvider;
		}
		
		override protected function onViewActive():void
		{
			_view.menuSocial.addEventListener(IndexChangeEvent.CHANGE, 	menuHandler);
			_view.menuPrivate.addEventListener(IndexChangeEvent.CHANGE, 	menuHandler);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.menuSocial.removeEventListener(IndexChangeEvent.CHANGE, 	menuHandler);
			_view.menuPrivate.addEventListener(IndexChangeEvent.CHANGE, 	menuHandler);
		}
		
		override protected function onViewRemove():void
		{
			_view.menuSocial.dataProvider.removeAll();
			_view.menuSocial.dataProvider = null;
			_view.menuPrivate.dataProvider.removeAll();
			_view.menuPrivate.dataProvider = null;
			_view = null;
		}
		
		private function menuHandler(event:IndexChangeEvent):void
		{
			var item:MenuDataItem = ListBase(event.target).selectedItem as MenuDataItem;
			sendNotification(NAMES.VIEW_GO, item.action);
		}
	}
}