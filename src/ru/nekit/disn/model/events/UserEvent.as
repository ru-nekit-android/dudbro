package ru.nekit.disn.model.events
{
	
	import flash.events.Event;
	
	import ru.nekit.disn.model.user.User;
	
	public class UserEvent extends Event
	{
		
		public static const GET_INFORMATION:String 				= "getInformation";
		
		public static const ADD:String 							= "add";
		public static const EXIT:String 						= "exit";
		
		public static const UPDATE:String 						= "update";
		public static const UPDATE_ACTIVE:String 				= "update_active";	
		
		public static const FRIENDSHIP_REQUEST_ADD:String 		= "friendshipRequestAdd";
		public static const FRIENDSHIP_REQUEST_REMOVE:String 	= "friendshipRequestRemove";
		public static const FRIENDSHIP_REQUEST_ABORT:String 	= "friendshipRequestAbort";
		
		public static const FRIEND_ADD:String 					= "friendAdd";
		
		public var user:User;
		
		public function UserEvent(type:String, user:User, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.user = user;
		}
	}
}