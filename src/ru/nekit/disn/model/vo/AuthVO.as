package ru.nekit.disn.model.vo
{
	public class AuthVO
	{
		
		public var login:String;
		public var password:String;
		public var salt:String;
		public var remember:Boolean = false;
		public var registerDate:Date;
		public var lastLoginDate:Date;
		
	}
}