package ru.nekit.disn.view
{
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.utils.setTimeout;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.dpi.DPI;
	import ru.nekit.disn.view.components.MainMenuButton;
	
	import spark.components.Button;
	import spark.components.View;
	import spark.events.ViewNavigatorEvent;
	
	public class ViewMediator extends Mediator implements IMediator
	{
		
		private static var _model:ModelProxy;
		
		private var _view:View;
		private var _mainMenuButtonRegistered:Boolean = false;
		private var _titleFontSize:Number = 0;
		
		public var hasMenu:Boolean = false;
		public var waitOnBack:Boolean = false;
		public var waitTime:Number = 200;
		
		public function ViewMediator(mediatorName:String=null, view:*=null)
		{
			super(mediatorName, view);
			_view = view;
		}
		
		final protected function get model():ModelProxy
		{
			if( !_model )
			{
				_model = facade.retrieveProxy(ModelProxy.NAME) as ModelProxy;
			}
			return _model;
		}
		
		public function get dpi():DPI
		{
			return DPI.instance;
		}
		
		public function set currentState(value:String):void
		{
			_view.currentState = value;
		}
		
		public function get currentState():String
		{
			return _view.currentState;
		}
		
		protected function removeNotificationInterest(value:String):void
		{
			var interests:Array = listNotificationInterests();
			var index:uint = interests.indexOf(value);
			if( index != -1)
			{
				interests.splice(index, 1);
			}
		}
		
		public function get data():Object
		{
			return _view.data;
		}
		
		protected function includeIn(object:UIComponent, value:Boolean):void
		{
			object.visible = object.includeInLayout = value;
		}
		
		protected function onMediatorRegister():void
		{			
		}	
		
		protected function onMediatorRemove():void
		{			
		}	
		
		protected function get backButton():Button
		{
			return null;
		}
		
		protected function get mainMenuButton():Button
		{
			return null;
		}
		
		protected function back():void
		{
			if( waitOnBack )
			{
				setTimeout(backFunction, waitTime);
			}
			else
			{
				_view.callLater(backFunction);
			}
		}
		
		protected function backHandler(event:MouseEvent):void
		{
			backFunction();
		}
		
		protected function mainMenuHandler(event:MouseEvent):void
		{
			mainMenuFunction();
		}
		
		private function backFunction():void
		{
			sendNotification(NAMES.VIEW_GO_PREVIOUS);	
		}
		
		private function mainMenuFunction():void
		{
			sendNotification(NAMES.MAIN_MENU_OPEN);
		}
		
		final override public function onRegister():void
		{
			_view.addEventListener(ViewNavigatorEvent.VIEW_ACTIVATE,  		activeHandler);
			_view.addEventListener(FlexEvent.ADD,  							addHandler);
			_view.addEventListener(FlexEvent.REMOVE,  						removeHandler);
			_view.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, 		stateChangeCompleteHandler);
			onMediatorRegister();
		}
		
		private function stateChangeCompleteHandler(event:FlexEvent):void
		{
			stateChangeComplete(currentState);
		}
		
		protected function stateChangeComplete(state:String):void
		{
			
		}
		
		final override public function onRemove():void
		{	
			if( backButton )
			{
				backButton.removeEventListener(MouseEvent.CLICK, backHandler);
			}
			var actionInterests:Array = this.actionInterests;
			if( actionInterests )
			{
				const length:uint = actionInterests.length;
				for( var i:uint = 0; i < length; i++)
				{
					var action:IEventDispatcher = actionInterests[i] as IEventDispatcher;
					if( action )
					{
						action.removeEventListener(MouseEvent.CLICK, actionCallHandler);
					}
				}
			}
			_view.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE, 		stateChangeCompleteHandler);
			onMediatorRemove();
		}
		
		protected function get actionInterests():Array
		{
			return null;
		}
		
		private function activeHandler(event:ViewNavigatorEvent):void
		{
			_view.removeEventListener(ViewNavigatorEvent.VIEW_ACTIVATE,  								activeHandler);
			if( backButton )
			{
				backButton.addEventListener(MouseEvent.CLICK, backHandler);
			}
			registerMainMenuButton();
			sendNotification(NAMES.VIEW_ACTIVE, this);
			onViewActive();
		}
		
		final protected function registerMainMenuButton():void
		{
			var _mainMenuButton:MainMenuButton = mainMenuButton as MainMenuButton;
			if( !_mainMenuButton)
			{
				if( "mainMenu" in _view )
				{
					_mainMenuButton = _view["mainMenu"] as MainMenuButton;
				}
			}
			if( _mainMenuButton )
			{
				if( !_mainMenuButtonRegistered )
				{
					sendNotification(NAMES.MAIN_MENU_BUTTON_REGISTER, _mainMenuButton);
					_mainMenuButtonRegistered = true;
					_mainMenuButton.addEventListener(MouseEvent.CLICK, mainMenuHandler);
				}
			}
		}
		
		public function set title(value:String):void
		{
			_view.title = value;
		}
		
		public function get title():String
		{
			return _view.title;
		}
		
		protected function onViewActive():void
		{
		}
		
		protected function get titleComponent():UIComponent
		{
			return _view.navigator.actionBar.titleDisplay as UIComponent;
		}
		
		protected function setTitleFontSize(value:Number):void
		{
			_titleFontSize = titleComponent.getStyle("fontSize") as Number;
			titleComponent.setStyle("fontSize", dpi.getAutoSize(value));
		}
		
		protected function restoreTitleFontSize():void
		{
			if( _titleFontSize )
			{
				titleComponent.setStyle("fontSize", _titleFontSize);
			}
		}
		
		private function addHandler(event:FlexEvent):void
		{
			_view.removeEventListener(FlexEvent.ADD,  													addHandler);
			var actionInterests:Array = this.actionInterests;
			if( actionInterests )
			{
				const length:uint = actionInterests.length;
				for( var i:uint = 0; i < length; i++)
				{
					var action:IEventDispatcher = actionInterests[i] as IEventDispatcher;
					if( action )
					{
						action.addEventListener(MouseEvent.CLICK, actionCallHandler);
					}
				}
			}
			validateNow();
			registerMainMenuButton();
			sendNotification(NAMES.VIEW_ADD, this);
			onViewAdd();
		}
		
		private function removeHandler(event:FlexEvent):void
		{	
			onViewRemove();
			restoreTitleFontSize();
			sendNotification(NAMES.VIEW_REMOVE, this);		
			_view.removeEventListener(FlexEvent.REMOVE,  												removeHandler);
			_view = null;
		}
		
		protected function actionCallHandler(event:MouseEvent):void
		{
		}
		
		protected function onViewAdd():void
		{
		}
		
		protected function onViewRemove():void
		{
		}
		
		final protected function validateNow():void
		{
			_view.validateNow();
		}
		
		final protected function callLater(method:Function, args:Array = null):void
		{
			_view.callLater(method, args);
		}
		
		final protected function cacheAsBitmap(value:DisplayObject, opaqueBackground:Object = null):void
		{
			value.cacheAsBitmap = true;
			value.cacheAsBitmapMatrix = new Matrix;
			if( opaqueBackground )
			{
				value.opaqueBackground = opaqueBackground;
			}
		}
	}
}