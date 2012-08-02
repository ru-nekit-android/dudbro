package ru.nekit.disn.view
{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.EffectEvent;
	import mx.events.FlexMouseEvent;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.dpi.DPI;
	import ru.nekit.disn.view.views.*;
	
	import spark.components.Menu;
	import spark.components.View;
	import spark.components.ViewNavigator;
	import spark.effects.Move;
	import spark.effects.easing.Sine;
	import spark.events.ElementExistenceEvent;
	import spark.events.PopUpEvent;
	import spark.primitives.BitmapImage;
	import spark.transitions.SlideViewTransition;
	import spark.transitions.SlideViewTransitionMode;
	import spark.utils.BitmapUtil;
	
	use namespace mx_internal;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		
		public static const NAME:String = "ApplicationMediator";
		
		private static var model:ModelProxy;
		
		private var _view:Main = null;
		private var _activeView:View = null;
		private var _activeMediator:IMediator = null;
		private var _menuEffect:Move;
		private var _mainMenuOpened:Boolean = false;
		private var _nextViewClass:Class;
		private var _effectCount:uint = 0;
		private var _lastFocus:InteractiveObject = null;
		private var _data:*;
		private var _currentMenu:Menu;
		private var lastFocus:InteractiveObject;
		
		public function ApplicationMediator(viewComponent:Object=null)
		{
			_view = viewComponent as Main;
			super(NAME, viewComponent);
			_menuEffect = new Move;
			_menuEffect.addEventListener(EffectEvent.EFFECT_END, menuEffectEndHandler);
		}
		
		private function menuEffectEndHandler(event:EffectEvent):void
		{
			_effectCount++;
			if( _effectCount == event.effectInstance.effect.targets.length )
			{
				_effectCount=0;
				if( _nextViewClass )
				{
					_view.mainNavigator.visible = true;
					sendNotification(NAMES.VIEW_SWITCH, _nextViewClass);
				}
				else
				{
					_view.menuNavigator.visible = _mainMenuOpened;
					_view.mainNavigator.visible = true;
					_view.mainNavigatorSnapshot.visible = false;
					_view.mainNavigatorSnapshot.source = null;
					_view.menuNavigatorSnapshot.visible = false;
					_view.menuNavigatorSnapshot.source = null;
					_view.mouseShield.visible = _mainMenuOpened;
					_view.mouseShield.x = _mainMenuOpened ? menuButtonWidth - mainNavigator.width : 0;
					if( _mainMenuOpened )
					{
						_view.mouseShield.addEventListener( MouseEvent.CLICK, mouseShieldClickHandlre);
					}
					else
					{
						_view.mouseShield.removeEventListener( MouseEvent.CLICK, mouseShieldClickHandlre);
					}
				}
			}
		}
		
		private function mouseShieldClickHandlre(event:MouseEvent):void
		{
			mainMenuOpen = false;
		}
		
		public function get mainMenuOpen():Boolean
		{
			return _mainMenuOpened;	
		}
		
		public function set mainMenuOpen(value:Boolean):void
		{
			if (value == _mainMenuOpened)
				return;
			_view.mouseShield.height	= _view.height - _view.mainNavigator.actionBar.height;
			_view.mouseShield.y			= _view.mainNavigator.actionBar.height;
			_view.mouseShield.visible = true;
			if (value)
			{
				_menuEffect.xFrom 	= 0;
				_menuEffect.xTo 	= -menuNavigator.width;
			}
			else
			{
				if( _nextViewClass )
				{
					_menuEffect.xFrom = menuButtonWidth - mainNavigator.width;
					_menuEffect.xTo = -mainNavigator.width;
				}
				else
				{
					_menuEffect.xFrom = -menuNavigator.width;
					_menuEffect.xTo = 0;
				}
			}
			_mainMenuOpened = value;
			_view.mainNavigatorSnapshot.source 	= getSnapshot(mainNavigator).source;
			menuNavigator.visible 				= true;
			_view.menuNavigatorSnapshot.source 	= getSnapshot(menuNavigator).source;
			menuNavigator.visible 				= false;
			mainNavigator.visible 				= false;
			_view.mainNavigatorSnapshot.visible = true;
			_view.menuNavigatorSnapshot.visible = true;
			_view.mainNavigatorShadow.visible 	= true;
			_view.mainNavigatorShadow.width		= mainNavigator.width;
			mainNavigator.x 					= _nextViewClass ? -mainNavigator.width : (_mainMenuOpened ? -menuNavigator.width : 0);
			menuEffectPlay(_nextViewClass ? 100 : 300);
		}
		
		private function menuEffectPlay(duration:uint = 0):void
		{
			_menuEffect.duration = duration ? duration : 300;
			_menuEffect.easer = new Sine(.5);
			_menuEffect.targets = [_view.mainNavigatorSnapshot, _view.mainNavigatorShadow];
			_menuEffect.play();
		}
		
		protected function getSnapshot(target:UIComponent, padding:int = 0, globalPosition:Point = null):BitmapImage
		{       
			if (!target || !target.visible || target.width == 0 || target.height == 0)
				return null;
			var snapshot:BitmapImage = new BitmapImage();
			snapshot.alwaysCreateDisplayObject = true;
			var bounds:Rectangle = new Rectangle();
			snapshot.source = BitmapUtil.getSnapshotWithPadding(target, padding, true, bounds);
			snapshot.width = bounds.width;
			snapshot.height = bounds.height;
			var m:Matrix = new Matrix();
			m.translate(bounds.left, bounds.top);
			var parent:DisplayObjectContainer = target.parent;
			if (parent)
			{
				var inverted:Matrix = parent.transform.concatenatedMatrix.clone();
				inverted.invert();
				m.concat(inverted);
			}
			snapshot.setLayoutMatrix(m, false);
			snapshot.includeInLayout = false;
			if (globalPosition)
			{
				var pt:Point = parent ? parent.localToGlobal(new Point(snapshot.x, snapshot.y)) : new Point();
				globalPosition.x = pt.x;
				globalPosition.y = pt.y;
			}
			return snapshot; 
		}
		
		public function get view():Main
		{
			return _view;
		}
		
		public function get activeView():View
		{
			return _activeView;
		}	
		
		public function get mainNavigator():ViewNavigator
		{
			return _view.mainNavigator;
		}
		
		public function get menuNavigator():ViewNavigator
		{
			return _view.menuNavigator;
		}
		
		override public function onRegister():void
		{
			mainNavigator.width 		= _view.width;
			_view.addEventListener(Event.ACTIVATE, 									activeHandler);
			_view.addEventListener(Event.DEACTIVATE, 								deactiveHandler);
			_view.systemManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, 		deviceKeyDownHandler);
			_view.systemManager.stage.addEventListener(KeyboardEvent.KEY_UP, 		deviceKeyUpHandler);
			mainNavigator.addEventListener(ElementExistenceEvent.ELEMENT_ADD, 		addElementHandler);
		}
		
		private function deviceKeyDownHandler(event:KeyboardEvent):void
		{
			var key:uint = event.keyCode;
			event.preventDefault();
		}
		
		private function deviceKeyUpHandler(event:KeyboardEvent):void
		{
			var key:uint = event.keyCode;
			if (key == Keyboard.MENU )
			{
				if( menuOpened )
				{
					closeMenu();
					setTimeout(
						function():void
						{
							mainMenuOpen = !mainMenuOpen;
						},
						500
					);
				}
				else
				{
					mainMenuOpen = !mainMenuOpen;
				}
			}
			if (key == Keyboard.BACK )
			{
				//do bothing
			}
		}
		
		private function activeHandler(event:Event):void
		{
			_view.frameRate = 24;
			if( model.localUser.user.connected )
			{
				model.localUser.active = true;
			}
		}
		
		private function deactiveHandler(event:Event):void
		{
			_view.frameRate = 1;
			model.localUser.active = false;
			System.gc();
		}
		
		private function addElementHandler(event:ElementExistenceEvent):void
		{
			registerViewMediator(event.element as View);
		}
		
		private function gcHandler(event:TimerEvent):void
		{
			System.gc();
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.MAIN_MENU_BUTTON_REGISTER, 
				NAMES.INIT_COMPLETE,
				NAMES.APPLICATION_CLOSE,
				NAMES.VIEW_GO,
				NAMES.VIEW_SWITCH,
				NAMES.VIEW_GO_PREVIOUS,
				NAMES.MAIN_MENU_OPEN,
				NAMES.MAIN_MENU_CLOSE,
				NAMES.MENU_OPEN,
				NAMES.MENU_CLOSE,
				NAMES.VIEW_ADD,
				NAMES.VIEW_ACTIVE,
				NAMES.SET_VIEW_DATA
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var body:Object = notification.getBody();
			var transition:SlideViewTransition;
			var name:String = notification.getName();
			
			switch( name )
			{
				
				case NAMES.MAIN_MENU_BUTTON_REGISTER:
					
					facade.removeMediator(MainMenuButtonMediator.NAME);
					facade.registerMediator(new MainMenuButtonMediator( body ));
					
					break;
				
				case NAMES.APPLICATION_CLOSE:
					
					mainMenuOpen = false;
					
					break;
				
				case NAMES.INIT_COMPLETE:
					
					model = facade.retrieveProxy(ModelProxy.NAME) as ModelProxy;
					_view.validateNow();
					facade.registerMediator(new MainMenuMediator(menuNavigator.activeView));
					
					break;
				
				case NAMES.VIEW_SWITCH:			
				case NAMES.VIEW_GO:
					
					var _class:Class 	= body as Class;
					if( _mainMenuOpened	)
					{
						if( !(_activeView is _class) )
						{
							_nextViewClass = _class;
						}
						mainMenuOpen = false;
					}
					else
					{
						if (!(_activeView is _class) )
						{
							switch( _class )
							{
								case StudentProfileView:
								case MeView:
									
									mainNavigator.popAll();
									
									break;
								
								default:
									break;
							}
							transition 				= new SlideViewTransition;
							transition.mode 		= SlideViewTransitionMode.PUSH;
							transition.direction 	= "left";
							if( name == NAMES.VIEW_SWITCH )
							{
								transition.duration = 1;
							}
							mainNavigator.pushView(_class, _data, null, transition);
							_data = null;
						}
					}
					
					break;
				
				case NAMES.VIEW_GO_PREVIOUS:
					
					transition 				= new SlideViewTransition;
					transition.mode 		= SlideViewTransitionMode.PUSH;
					transition.direction 	= "right";
					mainNavigator.popView(transition);
					
					break;
				
				case NAMES.MAIN_MENU_OPEN:
					
					mainMenuOpen = !mainMenuOpen;
					
					break;
				
				case NAMES.MAIN_MENU_CLOSE:
					
					mainMenuOpen = false;
					
					break;
				
				case NAMES.MENU_OPEN:
					
					menuOpen(body as IVisualElement);
					
					break;
				
				case NAMES.MENU_CLOSE:
					
					closeMenu();
					
					break;
				
				case NAMES.VIEW_ADD:
					
					if( body is StudentProfileMediator || body is MeMediator )
					{
						if( facade.hasCommand( NAMES.MODEL_INIT ) )
						{
							sendNotification(NAMES.MODEL_INIT);
						}
					}
					
					break;
				
				case NAMES.VIEW_ACTIVE:
					
					if( _nextViewClass )
					{
						mainNavigator.visible 				= true;
						menuNavigator.visible 				= true;
						_view.mainNavigatorSnapshot.source 	= getSnapshot(mainNavigator).source;
						_view.menuNavigatorSnapshot.source 	= getSnapshot(menuNavigator).source;
						mainNavigator.visible 				= false;
						menuNavigator.visible 				= false;
						mainNavigator.x 					= 0;
						_view.mainNavigatorSnapshot.visible = true;
						_view.menuNavigatorSnapshot.visible = true;
						_menuEffect.xFrom = -mainNavigator.width;
						_menuEffect.xTo = 0;
						menuEffectPlay(300);
						_nextViewClass = null;
					}	
					
					break;
				
				case NAMES.SET_VIEW_DATA:
					
					_data = notification.getBody();
					
					break;
				
				default:
					break;
				
			}
		}
		
		public function get menuButtonWidth():Number
		{
			return DPI.instance.getAutoSize(52);
		}
		
		private function addViewHandler(event:ElementExistenceEvent):void
		{
			registerViewMediator(event.element as View);
		}
		
		private function registerViewMediator(view:View):void
		{
			if( _activeMediator )
			{
				facade.removeMediator(_activeMediator.getMediatorName());
			}
			_activeView = view;
			var classType:Class = Object(view).constructor;
			var mediator:IMediator;
			
			switch( classType  )
			{
				
				case RegisterView:
					
					mediator = new RegisterMediator(view);
					
					break;
				
				case RememberMeView:
					
					mediator = new RememberMeMediator(view);
					
					break;
				
				case LoginView:
					
					mediator = new LoginMediator(view);
					
					break;
				
				case StudentProfileView:
					
					mediator = new StudentProfileMediator(view);
					
					break;
				
				case MeView:
					
					mediator = new MeMediator(view);
					
					break;
				
				case UserListView:
					
					mediator = new UserListMediator(view);
					
					break;
				
				case UserView:
					
					mediator = new UserMediator(view);
					
					break;
				
				case NicknameView:
					
					mediator = new NicknameMediator(view);
					
					break;
				
				case AllDataView:
					
					mediator = new AllDataMediator(view);
					
					break;
				
				case BirthdayView:
					
					mediator = new BirthdayMediator(view);
					
					break;
				
				case FullnameView:
					
					mediator = new FullnameMediator(view);
					
					break;
				
				case PrivateRuleView:
					
					mediator = new PrivateRuleMediator(view);
					
					break;
				
				case SexView:
					
					mediator = new SexMediator(view);
					
					break;
				
				case PhoneView:
					
					mediator = new PhoneMediator(view);
					
					break;
				
				case MessageView:
					
					mediator = new MessageMediator(view);
					
					break;
				
				case MessageListView:
					
					mediator = new MessageListMediator(view);
					
					break;
				
				case MessageMenuView:
					
					mediator = new MessageMenuMediator(view);
					
					break;
				
				case FriendMenuView:
					
					mediator = new FriendMenuMediator(view);
					
					break;
				
				case AboutMeView:
					
					mediator = new AboutMeMediator(view);
					
					break;
				
				case StatusView:
					
					mediator = new StatusMediator(view);
					
					break;
				
				case CheckConnectionView:
					
					mediator = new CheckConnectionMediator(view);
					
					break;
				
				case UserMenuView:
					
					mediator = new UserMenuMediator(view);
					
					break;
				
				case UniversityView:
					
					mediator = new UniversityMediator(view);
					
					break;
				
				case UniversityOtherView:
					
					mediator = new UniversityOtherMediator(view);
					
					break;
				
				case AboutView:
					
					mediator = new AboutMediator(view);
					
					break;
				
				case FriendshipRequestAddView:
					
					mediator = new FriendshipRequestAddMediator(view);
					
					break;
				
				case FriendRemoveView:
					
					break;
				
				case FriendshipRequestListView:
					
					mediator = new FriendshipRequestListMediator(view);
					
					break;
				
				case FriendshipFromMeRequestView:
					
					mediator = new FriendshipFromMeRequestMediator(view);
					
					break;
				
				case FriendMenuView:
					
					mediator = new FriendMenuMediator(view);
					
					break
				
				case FriendListView:
					
					mediator = new FriendListMediator(view);
					
					break;
				
				case AccountView:
					
					mediator = new AccountMediator(view);
					
					break;
				
				case MyComputerView:
					
					mediator = new MyComputerMediator(view);
					
					break;
				
				default:
					
					return;
					
					break;
				
			}
			if( mediator )
			{
				_activeMediator = mediator;
				facade.registerMediator(mediator);
			}
		}
		
		public function get menuOpened():Boolean
		{
			return _currentMenu && _currentMenu.isOpen;
		}
		
		public function menuOpen(content:IVisualElement):void
		{
			if ( menuOpened )
			{
				return;
			}
			openMenu(content);
		}
		
		private function menu_mouseDownOutsideHandler(event:FlexMouseEvent):void
		{
			closeMenu();
		}
		
		private function openMenu(content:IVisualElement = null):void
		{                
			if (!_currentMenu)
			{
				_currentMenu = new Menu;
				var defaultContent:IVisualElement;
				if( !content )
				{
					if( "menuContent" in _activeView)
					{
						content = _activeView["menuContent"];
					}
				}
				if( content )
				{
					_currentMenu.content = content;	
					_lastFocus = _view.getFocus();
					if (_view.isSoftKeyboardActive)
					{
						_view.systemManager.stage.focus = null;
					}
					_currentMenu.width = _view.getLayoutBoundsWidth();
					_currentMenu.height = _view.getLayoutBoundsHeight();
					_currentMenu.setFocus();
					_currentMenu.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, menu_mouseDownOutsideHandler);
					_currentMenu.addEventListener(PopUpEvent.CLOSE, menuClose_handler);
					_currentMenu.addEventListener(PopUpEvent.OPEN, menuOpen_handler);
				}
				else
				{
					return;
				}
			}
			_view.mouseShield.visible = true;
			_currentMenu.open(_view, false /*modal*/);
		}
		
		private function closeMenu():void
		{
			if (_currentMenu)
			{
				_currentMenu.close();
				_view.mouseShield.visible = false;
			}
		}
		
		private function menuOpen_handler(event:PopUpEvent):void
		{
			if (activeView.hasEventListener("viewMenuOpen"))
				activeView.dispatchEvent(new Event("viewMenuOpen"));
		}
		
		private function menuClose_handler(event:PopUpEvent):void
		{
			_currentMenu.removeEventListener(PopUpEvent.OPEN, menuOpen_handler);
			_currentMenu.removeEventListener(PopUpEvent.CLOSE, menuClose_handler);
			_currentMenu.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, menu_mouseDownOutsideHandler);
			if (activeView.hasEventListener("viewMenuClose"))
				activeView.dispatchEvent(new Event("viewMenuClose"));
			_currentMenu.validateProperties();
			_currentMenu.contentGroup.removeAllElements();
			_currentMenu.content = null;
			
			_currentMenu = null;
			_view.systemManager.stage.focus = _lastFocus;
		}
	}
}