package ru.nekit.disn.model
{
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class ModelLink
	{
		
		public static var model:ModelProxy;
		
		protected var data:Object;
		
		public function ModelLink(data:Object = null):void
		{
			this.data = data;
		}
		
		public function sendNotification(notificationName:String, body:Object = null, type:String = null):void
		{
			model.sendNotification(notificationName, body, type);
		}
		
		public function retrieveMediator(mediatorName:String):IMediator
		{
			return model.retrieveMediator(mediatorName);
		}
	}
}