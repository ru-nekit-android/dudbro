package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.dpi.DPI;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.vo.FriendshipRequestVO;
	import ru.nekit.disn.view.components.FriendshipBlock;
	import ru.nekit.disn.view.views.FriendshipRequestAddView;
	
	public class FriendshipBlockMediator extends Mediator implements IMediator
	{
		
		public static const NAME:String = "friendshipBlock";
		
		private var _model:ModelProxy;
		private var _component:FriendshipBlock;
		
		private var request:FriendshipRequestVO;
		
		public function FriendshipBlockMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_component = viewComponent as FriendshipBlock;
		}
		
		override public function onRegister():void
		{
			_model = facade.retrieveProxy(ModelProxy.NAME) as ModelProxy;
			_component.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeCompleteHandler);
			update();
		}
		
		private function stateChangeCompleteHandler(event:FlexEvent):void
		{
			switch( _component.currentState )
			{
				
				case "normal":
					
					_component.requestCall.addEventListener(MouseEvent.CLICK, requestCallHandler);
					_component.requestCall.height = DPI.instance.getAutoSize(36);
					
					break;
				
				case "requestFromMe":
					
					_component.requestRemoveCall.addEventListener(MouseEvent.CLICK, requestRemoveCallHandler);
					
					break;
				
				case "requestToMe":
					
					_component.requestConfirmCall.height = DPI.instance.getAutoSize(36);
					_component.requestAbortCall.height = DPI.instance..getAutoSize(36);
					_component.requestConfirmCall.addEventListener(MouseEvent.CLICK, requestConfirmCallHandler);
					_component.requestAbortCall.addEventListener(MouseEvent.CLICK, requestAbortCallHandler);
					_component.requestField.text = "Запрос: " + request.text;
					
					break;
				
				default:
					
					break;
			}
			
		}
		
		private function requestAbortCallHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.FRIENDSHIP_REQUEST_ABORT);
			update();
		}
		
		private function requestConfirmCallHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.FRIENDSHIP_REQUEST_CONFIRM);
			update();
		}
		
		private function requestRemoveCallHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.FRIENDSHIP_REQUEST_REMOVE);
			update();
		}
		
		private function requestCallHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.VIEW_GO, FriendshipRequestAddView);
		}
		
		override public function onRemove():void
		{
			_component.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeCompleteHandler);
			if( _component.requestCall )
			{
				_component.requestCall.removeEventListener(MouseEvent.CLICK, requestCallHandler);
			}
			if( _component.requestRemoveCall )
			{
				_component.requestRemoveCall.removeEventListener(MouseEvent.CLICK, requestRemoveCallHandler);
			}
			if( _component.requestConfirmCall )
			{
				_component.requestConfirmCall.removeEventListener(MouseEvent.CLICK, requestConfirmCallHandler);
				_component.requestAbortCall.removeEventListener(MouseEvent.CLICK, requestAbortCallHandler);
			}
			if( request && ( _model.friendshipRequestFilter.isConfirmedFromMe( request ) || _model.friendshipRequestFilter.isAbortedFromMe( request ) ) )
			{
				_model.friendshipRequestList.remove( _model.currentUser.user.user );
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.USER_FRIENDSHIP_REQUEST_ADD,
				NAMES.USER_FRIENDSHIP_REQUEST_REMOVE,
				NAMES.USER_FRIENDSHIP_REQUEST_ABORT,
				NAMES.FRIEND_ADD,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var body:Object = notification.getBody();
			var name:String = notification.getName();
			var user:User;
			
			switch( name )
			{	
				
				case NAMES.USER_FRIENDSHIP_REQUEST_ADD:
				case NAMES.USER_FRIENDSHIP_REQUEST_REMOVE:
				case NAMES.USER_FRIENDSHIP_REQUEST_ABORT:
					
					update();
					
					break;
				
				case NAMES.FRIEND_ADD:
					
					user = body as User;
					if( user == _model.currentUser.user.user )
					{
						_component.currentState = "confirmed";
					}
					
					break;
				
				default:
					break;
				
			}
		}
		
		private function update():void
		{
			request = _model.currentUser.user.friendshipRequest;
			if( _model.currentUser.user.isFriend )
			{
				if( request && ( _model.friendshipRequestFilter.isConfirmedToMe(request) || _model.friendshipRequestFilter.isConfirmedFromMe(request)) )
				{
					_component.currentState = "confirmed";
				}
				else
				{
					_component.currentState = "friend";
				}
			}
			else
			{
				if( !request )
				{
					_component.currentState = "normal";
				}
				else
				{
					if( _model.friendshipRequestFilter.isFromMe(request) )
					{
						_component.currentState = "requestFromMe";
					}
					else if( _model.friendshipRequestFilter.isToMe(request) )
					{
						_component.currentState = "requestToMe";
					}
					else if( _model.friendshipRequestFilter.isRemoved(request) ||  _model.friendshipRequestFilter.isAborted(request) )
					{
						_component.currentState = "normal";
					}
					else if( _model.friendshipRequestFilter.isAbortedFromMe(request) )
					{
						_component.currentState = "aborted";
					}
				}
			}
		}
	}
}