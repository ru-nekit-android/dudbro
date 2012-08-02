package ru.nekit.disn.model.ping
{
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.user.User;
	
	public class CyclicUserPing extends ModelLink
	{
		
		private var _refreshTimer:Timer;
		public var user:User;
		
		public function CyclicUserPing(user:User)
		{
			super();
			this.user = user;
		}
		
		public function start():void
		{
			if( !_refreshTimer )
			{
				_refreshTimer = new Timer(15000);
				_refreshTimer.addEventListener(TimerEvent.TIMER, refreshTimerHandler);	
				_refreshTimer.start();
			}
		}
		
		public function stop():void
		{
			if( _refreshTimer )
			{
				_refreshTimer.stop();
				_refreshTimer.removeEventListener(TimerEvent.TIMER, refreshTimerHandler);	
				_refreshTimer = null;
			}
		}
		
		private function refreshTimerHandler(event:TimerEvent):void
		{
			if( user )
			{
				model.ping.ping(user);
			}
		}
	}
}