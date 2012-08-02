package ru.nekit.disn.service
{
	
	import com.adobe.air.crypto.EncryptionKeyGenerator;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import ie.jampot.device.DataStorage;
	import ie.jampot.nativeExtensions.MobileBackup;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.disn.manager.entity.EntityManager;
	import ru.nekit.disn.manager.entity.IEntity;
	
	public class DBService extends Proxy implements IProxy
	{
		
		public static const NAME:String = "dbService";
		public static const DB:String   = "base_.db";
		
		private const em:EntityManager 	= EntityManager.instance;
		
		private var _dbFile:File;
		private var _connection:SQLConnection;	
		
		public function DBService()
		{
			super(NAME);
		}
		
		private function createPrivateStorage():void
		{
			DataStorage.init();
			var saveFile:File 			= DataStorage.filePrivate.resolvePath("date.txt");
			var saveStream:FileStream 	= new FileStream;
			saveStream.open(saveFile, FileMode.WRITE);
			saveStream.writeObject(new Date);
			saveStream.close();
			try
			{
				(new MobileBackup).doNotBackup(DataStorage.filePrivate.nativePath);
			}
			catch( error:Error )
			{
				
			}
		}
		
		public function init(password:String):void
		{
			createPrivateStorage();
			_dbFile 			= DataStorage.filePrivate.resolvePath(DB);
			_connection 		= new SQLConnection;
			var keyGenerator:EncryptionKeyGenerator = new EncryptionKeyGenerator;
			var key:ByteArray 	= keyGenerator.getEncryptionKey(password.substr(0, 29) + "ABC");
			_connection.open(_dbFile, SQLMode.CREATE);//, false, 1024, key);
			em.sqlConnection 	= _connection;
		}
		
		public function deleteDatabase():Boolean
		{
			var result:Boolean = false;
			if ( _dbFile ) 
			{				
				if ( _connection && _connection.connected )
					_connection.close(null);	
				var fs:FileStream = new FileStream();
				try 
				{
					fs.open(_dbFile,FileMode.UPDATE);
					while ( fs.bytesAvailable )	
						fs.writeByte(Math.random() * Math.pow(2,32));						
					fs.close();
					_dbFile.deleteFile();				
					result = true;
				}
				catch (e:Error)
				{
					fs.close();
				}				
			}
			return result;
		}
		
		public function save(o:IEntity):Object
		{
			em.save(o);
			return o;
		}
		
		public function update(o:IEntity):Object
		{
			em.update(o);
			return o;
		}
		
		public function remove(o:IEntity):void
		{
			em.remove(o);
		}
		
		public function removeList(c:Class, list:Vector.<IEntity>):void
		{
			em.removeList(c, list);
		}
		
		public function removeAll(c:Class):void
		{
			em.removeAll(c);
		}
		
		public function drop(c:Class):void
		{
			em.drop(c);
		}
		
		public function select(o:IEntity):IEntity
		{
			return em.select(o);
		}
		
		public function createSelect(c:Class, name:String, column:Array, field:Array, condition:Array):void
		{
			em.createSelect(c, name, column, field, condition);
		}
		
		public function executeSelect(c:Class, name:String, value:Array):Array
		{
			return em.executeSelect(c, name, value);
		}
		
		public function selectAll(c:Class):Array
		{
			return em.selectAll(c);
		}
	}
}