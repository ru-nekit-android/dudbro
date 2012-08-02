package ru.nekit.disn.service
{
	import ru.nekit.disn.model.ModelLink;
	
	
	public class NetworkStatusService extends ModelLink
	{	
		public function get localStatus():Boolean
		{
			return true;
		}	
	}
}