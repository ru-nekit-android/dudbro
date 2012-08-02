package ru.nekit.disn.model.events
{
	
	import flash.events.Event;
	
	public class PingEvent extends Event
	{
		
		public static const RESULT:String = "result";
		
		public var object:*;
		public var result:Boolean;
		
		public function PingEvent(type:String, object:*, result:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.object = object;
			this.result = result;
		}
	}
}