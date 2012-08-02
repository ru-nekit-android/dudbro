package org.puremvc.as3.patterns.proxy
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import ru.nekit.disn.model.ModelLink;
	
	public class Dispatcher extends ModelLink implements IEventDispatcher
	{
		
		private var _dispatcher:EventDispatcher;
		
		public function Dispatcher(proxyName:String=null, data:Object=null)
		{
			_dispatcher = new EventDispatcher(this);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
	}
}