package ru.nekit.disn.model.ping
{
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.user.User;
	
	public class CyclicUserListPing extends ModelLink
	{
		
		private var _list:Vector.<User>;
		private var _refreshTimer:Timer;
		
		public function CyclicUserListPing(list:Vector.<User>=null)
		{
			_list = list;
		}
		
		public function start():void
		{
			if( !_refreshTimer )
			{
				if( !_list )
				{
					_list = model.userFilter.onlineUsers;
				}
				pingList();
				_refreshTimer = new Timer(15000);
				_refreshTimer.addEventListener(TimerEvent.TIMER, refreshTimerHandler);	
				_refreshTimer.start();
			}
		}
		
		public function get active():Boolean
		{
			return _refreshTimer != null;
		}
		
		public function stop():void
		{
			if( _refreshTimer )
			{
				_refreshTimer.stop();
				_refreshTimer.removeEventListener(TimerEvent.TIMER, refreshTimerHandler);
				_refreshTimer = null;
				_list = null;
			}
		}
		
		public function add(user:User):void
		{
			start();
			var index:int = _list.indexOf(user);
			if( index != -1 )
			{
				_list.push(user);
			}
		}
		
		public function remove(user:User):void
		{
			var index:int = _list.indexOf(user);
			if( index != -1 )
			{
				_list.splice(index, 1);
			}
		}
		
		private function pingList():void
		{
			for each( var user:User in _list)
			{
				model.ping.ping(user);
			}
		}
		
		private function refreshTimerHandler(event:TimerEvent):void
		{
			pingList();
		}
		
		public function get list():Vector.<User>
		{
			return _list;
		}
		
		public function set list(value:Vector.<User>):void
		{
			_list = value;
		}
	}
}