/*
-------------------------------------------------------------
DataStorage Singleton Class
Version: 1.0.0
Created On: 25/11/2011
-------------------------------------------------------------
Description:
+ Data Storage 2.23 support for iOS Data Storage Guidlines
-------------------------------------------------------------
Important Notes:
- Do not use spaces in directories! This is not yet supported.
-------------------------------------------------------------
Usage: 
DataStorage.init();
-------------------------------------------------------------
Support URL:
http://www.jampot.ie/ane
-------------------------------------------------------------
Contact: David Douglas <david.douglas@jampot.ie>
©2011 JamPot Technologies Ltd.
-------------------------------------------------------------
*/

package ie.jampot.device
{
	import flash.filesystem.File;
	import flash.system.Capabilities;

	public class DataStorage
	{
		// Singleton
		private static var _$instance : DataStorage;
		private static var _$allowInstance : Boolean;
		
		// Instance Vars
		private static var _$os : String;
		private static var _$version : String;
		
		// Directories
		private static var _$publicDir : File ; // Documents can be made accessible in iTunes or backed up to iCloud in iOS 5.0.1
		private static var _$privateDir : File ; // This is critical data that the user expects to be reliably available when offline.
		private static var _$cacheDir : File ; // Cached data may be purged in low storage situations, and is not backed up by iTunes or iCloud.
		private static var _$tempDir : File ; // Files in this directory are not backed up by iTunes or iCloud.
		
		public function DataStorage()
		{
			if(! _$allowInstance){
				throw new Error("DataStorage singleton error: Use 'DataStorage.init()' instead of 'new DataStorage()'.");
			}
		}
		
		public static function init() : DataStorage
		{
			if(_$instance == null){
				_$allowInstance = true;
				_$instance = new DataStorage();
				_$allowInstance = false;
				getDeviceInfo();
				configDataStorage();
			}
			return _$instance; // returns reference to the Singleton instance.
		}
		
		// Get device info
		private static function getDeviceInfo() : void
		{
			_$os = returnFirstWord( Capabilities.os );
			_$version = returnFirstWord( Capabilities.version );
		}
		
		// Configure Data Storage for iOS 
		private static function configDataStorage() : void
		{
			// Shortcut to <Application_Home> location as listed on QA1719 Apple tech note
			var applicationHome : String = File.userDirectory.nativePath;
			// Shortcuts for Android, etc...
			var publicStorage : String = File.documentsDirectory.nativePath;
			var privateStorage : String = File.applicationStorageDirectory.nativePath;
			
			// Check for iOS and not Mac/PC Simulator.
			if( _$version=="IOS" && (_$os!="Mac" || _$os!="Win" ) )
			{
				_$publicDir = new File( applicationHome + '/Documents' );
				_$privateDir = new File( applicationHome + '/Library/PrivateDocuments' );
				_$cacheDir = new File( applicationHome + '/Library/Caches' );
				_$tempDir = new File( applicationHome + '/tmp' );
				trace("iOS Data Storage");
			}
			else
			{
				_$publicDir = new File( publicStorage );
				_$privateDir = new File( privateStorage );
				_$cacheDir = new File( privateStorage + '/Caches' );
				_$tempDir = new File( File.createTempDirectory().nativePath + '/tmp' );
				trace("Data Storage");
			}
			trace("- Public: "+_$publicDir.nativePath +"\n- Private: "+_$privateDir.nativePath +"\n- Cache: "+_$cacheDir.nativePath +"\n- Temp: "+_$tempDir.nativePath );
		}
		
		// Getters
		public static function get filePublic() : File
		{
			return _$publicDir;
		}
		
		public static function get filePrivate() : File
		{
			return _$privateDir;
		}
		
		public static function get fileCache() : File
		{
			return _$cacheDir;
		}
		
		public static function get fileTemp() : File
		{
			return _$tempDir;
		}
		
		// String helper
		public static function returnFirstWord( s : String ) : String
		{
			var i:int = s.indexOf(" ");
			var len:uint = (i>0) ? i : s.length;
			return s.substring(0, len);
		}
		
		
	}
}