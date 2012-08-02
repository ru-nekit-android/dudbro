package ru.nekit.disn.model.types
{
	public class FriendshipRequestStatus
	{
		
		//public static const OK:uint 						= 0;
		//public static const ABORT:uint 						= 1;
		
		public static const FROM_ME:uint 			= 1;
		public static const FROM_ME_SUCCESS:uint 	= 2;
		public static const TO_ME:uint 				= 3;
		public static const CONFIRM_TO_ME:uint 		= 4;
		public static const CONFIRM_FROM_ME:uint 	= 5;
		public static const REMOVED:uint 			= 6;
		public static const ABORTED:uint 			= 7;
		public static const ABORTED_FROM_ME:uint 	= 8;
		
	}
}