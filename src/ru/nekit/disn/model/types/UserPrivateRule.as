package ru.nekit.disn.model.types
{
	
	public class UserPrivateRule
	{
		
		public static const ALLOW_SEX:uint 		= 1;
		public static const ALLOW_BIRTHDAY:uint = 2;
		public static const ALLOW_NAME:uint 	= 2<<1;
		public static const ALLOW_PHONE:uint 	= 2<<2;
		
		public static const ALLOW_OPEN_FRIENDSHIP:uint 	= 2<<3;
		
		public static const ALLOW_ABOUT_ME:uint 	= 2<<4;
		
	}
	
}