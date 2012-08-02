package ru.nekit.disn.model.user
{
	
	import com.adobe.crypto.MD5;
	import com.projectcocoon.p2p.events.*;
	import com.projectcocoon.p2p.vo.ClientVO;
	
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	import ru.nekit.ane.Device;
	import ru.nekit.disn.model.account.Account;
	import ru.nekit.disn.model.interfaces.*;
	import ru.nekit.disn.model.photo.Photo;
	import ru.nekit.disn.model.university.University;
	import ru.nekit.disn.model.user.base.BaseUserProxy;
	import ru.nekit.disn.model.vo.UserDataVO;
	import ru.nekit.disn.service.*;
	import ru.nekit.utils.ByteArrayUtil;
	
	public class LocalUserProxy extends BaseUserProxy implements ISerialize, IDeserialize
	{
		
		private static const NAME:String 						= "localUser";
		
		public static const VERSION:String						= "1.2";
		
		public static const USER:String 						= "user";
		public static const UPDATE_NICKNAME:String 				= "update_nickname";
		public static const UPDATE_DATA:String 					= "update_data";
		public static const SUBSCRIBE:String 					= "subscribe";
		public static const UNSUBSCRIBE:String 					= "subscribe";
		public static const ENTER:String 						= "enter";
		public static const PING:String 						= "ping";
		public static const PONG:String 						= "pong";
		
		public static const HANDSHAKE:String 							= "handshake";
		public static const HANDSHAKE_OK:String 						= "handshake_ok";
		
		public static const FRIENDSHIP_REQUEST:String 							= "friendship_request";
		public static const FRIENDSHIP_REQUEST_REMOVE:String 					= "friendship_request_remove";
		public static const FRIENDSHIP_REQUEST_REMOVE_SUCCESS:String 			= "friendship_request_remove_success";
		public static const FRIENDSHIP_REQUEST_ABORT:String 					= "friendship_request_abort";
		public static const FRIENDSHIP_REQUEST_ABORT_SUCCESS:String 			= "friendship_request_abort_success";
		public static const FRIENDSHIP_REQUEST_SUCCESS:String 					= "friendship_request_success";
		public static const FRIENDSHIP_REQUEST_CONFIRM:String 					= "confirm_friendship_request";
		public static const FRIENDSHIP_REQUEST_CONFIRM_SUCCESS:String 			= "confirm_friendship_request_success";
		
		public static const EXIT:String 								= "exit";
		public static const UPDATE_ACTIVE_STATUS:String 						= "active";
		public static const MESSAGE:String 									= "message";
		public static const MESSAGE_DELIVERY_REPORT:String =	"delivery_report";
		public static const INFORMATION_REQUEST:String  		= "request_information";
		public static const INFORMATION_GET:String  				= "get_information";
		
		public static const GET_OFFLINE_USERS:String  				= "call_offline_users";
		
		use namespace user_internal;
		
		public var p2pClient:ClientVO;
		
		public function LocalUserProxy()
		{
			super(new LocalUser);
			_photo	= new Photo(user.vo.photo);
			_account = new Account(user.vo.accounts);
			_university = new University(user.vo.university);
		}
		
		public function register(nickname:String, password:String):void
		{
			vo.nickname = nickname;
			var uid:String = Device.instance.getUUID();
			if( !uid ) 
			{
				uid = MD5.hash(nickname + password);
			}
			vo.uid 	= uid;
			save();
		}
		
		public function get user():LocalUser
		{
			return _baseUser as LocalUser;
		}
		
		public function serialize():ByteArray
		{
			var ba:ByteArray = new ByteArray;
			ByteArrayUtil.writeUTF(ba, 	VERSION);
			ByteArrayUtil.writeUTF(ba, 	vo.uid);
			ByteArrayUtil.writeUTF(ba, 	vo.nickname);
			ByteArrayUtil.writeUTF(ba, 	vo.name);
			ByteArrayUtil.writeUTF(ba, 	vo.status);
			ByteArrayUtil.writeInt(ba, 		vo.mood);
			ByteArrayUtil.writeUTF(ba, 	vo.phone);
			ByteArrayUtil.writeUnsignedInt(ba, 		vo.rule);
			ByteArrayUtil.writeInt(ba, 		vo.sex);
			ByteArrayUtil.writeObject(ba, vo.birthDay);
			ByteArrayUtil.writeUTF(ba, vo.aboutMe);		
			ByteArrayUtil.writeObject(ba, vo.extension);
			_photo.write(ba);
			_account.write(ba);
			_university.write(ba);
			ba.position = 0;
			return ba;
		}
		
		public function deserialize(ba:ByteArray):void
		{
			if( ba )
			{
				ba.position 		= 0;
				vo.version			= ba.readUTF();
				vo.uid 				= ba.readUTF();
				vo.nickname 		= ba.readUTF();
				vo.name				= ba.readUTF();
				vo.status 			= ba.readUTF();
				vo.mood				= ba.readInt();
				vo.phone			= ba.readUTF();
				vo.rule				= ba.readUnsignedInt();
				vo.sex				= ba.readInt();
				vo.birthDay 		= ByteArrayUtil.readDate(ba);
				vo.aboutMe			= ba.readUTF();
				vo.extension 		= ba.readObject();
				_photo.read(ba);
				_account.read(ba);
				if( vo.version == "1.2")
				{
					_university.read(ba);
				}
			}
		}
		
		public function isFriend(user:User):Boolean
		{
			return model.friendList.hasFriend(user);
		}
		
		public function enter():void
		{
			if( !user.connected )
			{
				model.p2p.connect();
			}
		}
		
		public function exit():void
		{
			if( user.connected )
			{
				model.p2pUserChannel.sendToAllUsers("self", LocalUserProxy.EXIT);
				user.connected 	= false;
				user.online		= false;
			}
		}
		
		public function get active():Boolean
		{
			return user.active;
		}
		
		public function set active(value:Boolean):void
		{
			if( user.active != value )
			{
				user.active = value;
				if( user.connected )
				{
					model.subscriberList.sendDataToSubscribers(value, LocalUserProxy.USER, LocalUserProxy.UPDATE_ACTIVE_STATUS);
				}
			}
		}
		
		private function save():ByteArray
		{
			var data:ByteArray = serialize();
			EncryptedLocalStore.setItem(NAME, data);
			return data;
		}
		
		public function update():void
		{
			user.update();
			save();
			model.subscriberList.updateUserData(vo);
		}
		
		public function init():void
		{
			deserialize(EncryptedLocalStore.getItem(NAME));
		}
		
		public function reset():void
		{
			EncryptedLocalStore.removeItem(NAME);
		}
		
		public function set nickname(value:String):void
		{
			if( vo.nickname != value )
			{
				vo.nickname = value;
				save();
				model.p2pUserChannel.sendToAllUsers(vo.nickname, UPDATE_NICKNAME);
			}
		}
		
		public function get nickname():String
		{
			return vo.nickname;
		}
		
		private function get vo():UserDataVO
		{
			return user.vo;
		}
	}
}