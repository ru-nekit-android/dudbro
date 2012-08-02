package ie.jampot.nativeExtensions
{
	public class MobileBackup
	{		
		public function MobileBackup()
		{
			trace("* MobileBackup: Simulator doesn't support iOS 5.0.1 extension. *");
		}

		public function doNotBackup( fileURL : String ) : Boolean
		{
			trace("* MobileBackup: Simulator doesn't support doNotBackup(). *");
			return false;
		}
		
	}
}