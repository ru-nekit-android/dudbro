package ru.nekit.disn.model.user
{
	
	public class CurrentUser
	{
		
		private var _user:UserProxy;
		private var _message:UserProxy;
		
		public function get user():UserProxy
		{
			return _user;
		}
		
		public function get message():UserProxy
		{
			return _message;
		}
		
		public function reset():void
		{
			_user.user = null;
		}
		
		public function CurrentUser()
		{
			_user = new UserProxy;
			_message = new UserProxy;
		}
	}
}