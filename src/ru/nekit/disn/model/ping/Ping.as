package ru.nekit.disn.model.ping
{
	
	import org.puremvc.as3.patterns.proxy.Dispatcher;
	
	import ru.nekit.disn.model.events.ExtendedMessageEvent;
	import ru.nekit.disn.model.events.PingEvent;
	import ru.nekit.disn.model.types.ExtendedMessageStatus;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.vo.ExtendedMessageVO;
	
	[Event(name="result", 	type="ru.nekit.disn.model.events.PingEvent")]
	public class Ping extends Dispatcher
	{
		
		private static const DEFAULT_TTL:uint = 1000*60*2;
		
		private var _maxPing:uint = 0;
		private var _minPing:uint = 0;
		private var _pingList:Object;
		
		public function Ping()
		{
			_pingList = new Object;
		}
		
		public function get maxPing():uint
		{
			return _maxPing;
		}
		
		public function get minPing():uint
		{
			return _minPing;
		}
		
		public function ping(user:User):void
		{	
			if( wait(user) )
			{
				model.p2pUserChannel.sendToUser(user, null, LocalUserProxy.PING);
			}
		}
		
		public function wait(object:*, ttl:Number = 0):Boolean
		{
			if( ttl == 0 )
			{
				if( object is User )
				{
					ttl = userTTL(User(object));
				}
			}
			var uid:String = uid(object);
			if( !(uid in _pingList) )
			{
				add(ttl, object).send();
				return true;
			}
			return false;
		}
		
		public function get ttl():Number
		{
			return _maxPing == 0 ? DEFAULT_TTL : _maxPing*2;
		}
		
		public function userTTL(user:User):Number
		{
			return user.ping != 0 ? user.ping*2 : ttl;
		}
		
		private function uid(pingableObject:*):String
		{
			var prefix:String;
			var uid:String;
			if( pingableObject is ExtendedMessageVO || pingableObject is String)
			{
				prefix = "m:";
			}
			else if( pingableObject is User )
			{
				prefix = "u:";
			}
			if( "uid" in pingableObject )
			{
				uid = pingableObject.uid;
			}
			return prefix + uid;
		}
		
		private function add(ttl:Number, pingableObject:*):PingOperation
		{
			var uid:String = uid(pingableObject);
			var ping:PingOperation 	= new PingOperation (ttl, pingableObject);
			_pingList[uid] 			= ping;
			ping.addEventListener(PingEvent.RESULT, ttlResultHandler);
			return ping;
		}
		
		private function ttlResultHandler(event:PingEvent):void
		{
			var object:* = event.object;
			if(  object is User )
			{
				var user:User = object as User;
				if( user.uid in _pingList )
				{
					user.online = false;
					PingOperation(_pingList[user.uid]).removeEventListener(PingEvent.RESULT, ttlResultHandler);
					dispatchEvent(new PingEvent(PingEvent.RESULT, user, false));
					delete _pingList[user.uid];
				}
			}
			else if( object is ExtendedMessageVO )
			{
				var message:ExtendedMessageVO = object as ExtendedMessageVO;
				if( message.uid in _pingList )
				{
					PingOperation(_pingList[message.uid]).removeEventListener(PingEvent.RESULT, ttlResultHandler);
					message.status = message.status | ExtendedMessageStatus.ERROR;
					dispatchEvent(new ExtendedMessageEvent(ExtendedMessageEvent.SENT_FAILED, message));
					delete _pingList[message.uid];
				}
			}
		}
		
		private function updateMinMaxPing(value:uint):void
		{
			if( value > _maxPing)
			{
				_maxPing = value;
			}
			if( _minPing == 0 || _minPing > value )
			{
				_minPing = value;
			}
		}
		
		public function remove(pingableObject:*):void
		{
			var uid:String = uid(pingableObject);
			if( uid in _pingList )
			{
				var ping:PingOperation 	= _pingList[uid] as PingOperation;
				var time:Number 		= (new Date).time;
				var pingValue:uint;
				var user:User;
				if( pingableObject is User )
				{
					user		= User(pingableObject);
					pingValue 	= time - ping.timestamp;
					user.ping 	= pingValue;
					dispatchEvent(new PingEvent(PingEvent.RESULT, user, true));
				}
				else if( pingableObject is String )
				{
					var eMessage:ExtendedMessageVO 	= ExtendedMessageVO(ping.object);
					eMessage.status 				= ExtendedMessageStatus.COMPLETE;
					dispatchEvent(new ExtendedMessageEvent(ExtendedMessageEvent.SENT_SUCCESS, eMessage));
					if( eMessage.destination != "" )
					{
						user = model.userList.getByID(eMessage.destination);
						if( user )
						{
							pingValue = time - eMessage.timestamp;
							user.ping = pingValue;
							//dispatchEvent(new TTLvent(TTLvent.RESULT, user, true));
						}	
					}
				}
				ping.removeEventListener(PingEvent.RESULT, ttlResultHandler);
				ping.stop();
				delete _pingList[uid];
				if( pingValue != 0 )
				{
					updateMinMaxPing(pingValue);
				}
				trace("ping: ", user ? user.uid + " : " : "" , pingValue);
			}
		}	
	}
}