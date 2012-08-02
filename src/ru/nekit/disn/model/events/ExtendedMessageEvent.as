package ru.nekit.disn.model.events
{
	import flash.events.Event;
	
	import ru.nekit.disn.model.vo.ExtendedMessageVO;
	
	public class ExtendedMessageEvent extends Event
	{
		
		public static const SENT_SUCCESS:String = "success";
		public static const SENT_FAILED:String 	= "failed";
		public static const RECEIVED:String 	= "received";
		
		public var message:ExtendedMessageVO;
		
		public function ExtendedMessageEvent(type:String, message:ExtendedMessageVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.message = message;
		}
	}
}