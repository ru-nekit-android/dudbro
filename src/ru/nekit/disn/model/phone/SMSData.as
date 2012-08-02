package ru.nekit.disn.model.phone
{
	public class SMSData
	{
		
		public var phoneNumber:String
		public var body:String;
		
		public function SMSData(phoneNumber:String, body:String)
		{
			this.phoneNumber 	= phoneNumber;
			this.body			= body;
		}
	}
}