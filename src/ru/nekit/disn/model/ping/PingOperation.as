package ru.nekit.disn.model.ping
{
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ru.nekit.disn.model.events.PingEvent;
	
	[Event(name="result", type="ru.nekit.disn.model.events.PingEvent")]
	public class PingOperation extends EventDispatcher
	{
		
		private var _time:Timer;
		
		public var ttl:uint;
		public var timestamp:Number;
		public var object:*;	
		
		public function PingOperation(ttl:uint, object:*)
		{
			super();
			this.ttl	= ttl;
			this.object	= object;
		}
		
		public function send():void
		{
			if( !_time )
			{
				timestamp	= (new Date).time;
				_time 		= new Timer(ttl);
				_time.addEventListener(TimerEvent.TIMER, timerHandler);
				_time.start();
			}
		}
		
		public function stop():void
		{
			if( _time )
			{
				_time.removeEventListener(TimerEvent.TIMER, timerHandler);
				_time.start();
				_time 	= null;
				object 	= null;
			}
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			dispatchEvent(new PingEvent(PingEvent.RESULT, object, false));
			stop();
		}
	}
}