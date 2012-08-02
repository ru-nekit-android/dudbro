package ru.nekit.disn.model.auth
{
	
	import com.adobe.crypto.MD5;
	
	import flash.crypto.generateRandomBytes;
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	import ru.nekit.disn.model.interfaces.IDeserialize;
	import ru.nekit.disn.model.interfaces.ISerialize;
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.vo.AuthVO;
	
	public class Auth extends ModelLink implements ISerialize, IDeserialize
	{
		
		private static const NAME:String = "auth";
		
		public function get vo():AuthVO
		{
			return data as AuthVO;
		}
		
		public function save():void
		{
			write();
		}
		
		public function write():ByteArray
		{
			var data:ByteArray = serialize();
			EncryptedLocalStore.setItem(NAME, data);
			return data;
		}
		
		public function init():void
		{
			var ba:ByteArray = EncryptedLocalStore.getItem(NAME);
			if( ba )
			{
				data = new AuthVO;
			}
			deserialize(ba);
		}
		
		public function reset():void
		{
			EncryptedLocalStore.removeItem(NAME);
		}
		
		private function get salt():String
		{
			var s:String 		= "";
			var kb:ByteArray 	= generateRandomBytes(16);
			kb.position = 0;
			for( var i:uint = 0; i < 16; i++)
			{
				var byte:int = kb.readByte();
				if( byte < 0 )
				{
					byte += 128;
				}
				s += String.fromCharCode(byte);
			}
			return s;
		}
		
		public function register(login:String, password:String, remember:Boolean):void
		{
			data 			= new AuthVO;
			vo.login		= login;
			vo.salt 		= salt;
			vo.password 	= MD5.hash(vo.salt + password + vo.salt);
			vo.remember 	= remember;
			vo.registerDate = new Date;
			write();
		}
		
		public function login(login:String, password:String):Boolean
		{
			var result:Boolean = vo.password == MD5.hash(vo.salt + password + vo.salt);
			if( result )
			{
				vo.lastLoginDate = new Date;
				write();
			}
			return result;
		}
		
		public function get isFirstLogin():Boolean
		{
			return vo == null;
		}
		
		public function serialize():ByteArray
		{
			var ba:ByteArray = new ByteArray;
			ba.writeUTF( vo.login );
			ba.writeUTF( vo.password );
			ba.writeUTF( vo.salt );
			ba.writeBoolean( vo.remember );
			ba.writeObject( vo.registerDate );
			ba.writeObject( vo.lastLoginDate );
			ba.position = 0;
			return ba;
		}
		
		public function deserialize(value:ByteArray):void
		{
			if( value )
			{
				value.position 		= 0;
				vo.login 			= value.readUTF();
				vo.password 		= value.readUTF();
				vo.salt				= value.readUTF();
				vo.remember 		= value.readBoolean();
				vo.registerDate 	= value.readObject() as Date;
				vo.lastLoginDate = value.readObject() as Date;
			}
		}
	}
}