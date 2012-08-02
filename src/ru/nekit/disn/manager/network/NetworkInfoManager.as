package ru.nekit.disn.manager.network
{
	
	import flash.errors.IllegalOperationError;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.system.Capabilities;
	
	public class NetworkInfoManager
	{
		
		private static const WIFI:String 		= "wifi";
		private static const ETHERNET0:String 	= "en0";
		private static const ETHERNET1:String 	= "en1";
		
		private static var _instance:NetworkInfoManager;
		private static var _instanceAllow:Boolean;
		
		public static function get instance():NetworkInfoManager
		{
			if( !_instance )
			{
				_instanceAllow 	= true;
				_instance		= new NetworkInfoManager;
				_instanceAllow	= false;
			}
			return _instance;
		}
		
		public function NetworkInfoManager()
		{
			if( _instanceAllow )
			{
				
			}
			else
			{
				throw new IllegalOperationError("You must use NetworkInfo.instance.");
			}
		}
		
		public function get wifiIsActive():Boolean
		{
			var interfacelist:Vector.<NetworkInterface> = findInterfaces();
			var resultInterface:NetworkInterface;
			var os:String = Capabilities.os.toLowerCase();
			for each( var _interface:NetworkInterface in interfacelist)
			{
				
				if( os.indexOf("windows") != -1 )
				{
					return true;
				}
				else if( os.indexOf("iphone") != -1 )
				{
					if( _interface.name == ETHERNET0 )
					{
						resultInterface = _interface;
						break;
					}
				}
				else if( os.indexOf("mac") != -1 )
				{
					if( _interface.name == ETHERNET1 )
					{
						resultInterface = _interface;
						break;
					}
				}
				else
				{
					if( _interface.name.toLowerCase() == WIFI )
					{
						resultInterface = _interface
					}
				}
			}
			if( resultInterface )
			{
				return resultInterface.active;
			}
			return false;
		}
		
		public function findInterfaces():Vector.<NetworkInterface>
		{
			var os:String = Capabilities.os;
			var networkInfo:INetworkInfo;
			try
			{
				if( os.indexOf("iPhone") != -1 )
				{
					networkInfo = new IOSNetworkInfo;
				}
				else
				{
					networkInfo = new DefaultNetworkInfo;
				}
			}catch(error:Error)
			{
				return null;
			}
			return networkInfo.findInterfaces();
		}
	}
}

import ru.nekit.ane.NetworkInfo.InterfaceAddress;

class IOSNetworkInfo implements INetworkInfo
{
	
	public function findInterfaces():Vector.<flash.net.NetworkInterface>
	{
		var interfaces:Vector.<ru.nekit.ane.NetworkInfo.NetworkInterface> = ru.nekit.ane.NetworkInfo.NetworkInfo.networkInfo.findInterfaces();
		var result:Vector.<flash.net.NetworkInterface> = new Vector.<flash.net.NetworkInterface>;
		interfaces.forEach(function(item:ru.nekit.ane.NetworkInfo.NetworkInterface, index:int, array:Vector.<ru.nekit.ane.NetworkInfo.NetworkInterface>):void
		{
			var resultInterface:flash.net.NetworkInterface = new flash.net.NetworkInterface;
			resultInterface.active 				= item.active;
			resultInterface.displayName 		= item.displayName;
			resultInterface.hardwareAddress 	= item.hardwareAddress;
			resultInterface.mtu 				= item.mtu;
			resultInterface.name 				= item.name;
			var addresses:Vector.<InterfaceAddress> 				= item.addresses;
			var resultAddresses:Vector.<flash.net.InterfaceAddress> = new Vector.<flash.net.InterfaceAddress>;
			const length:uint = addresses ? addresses.length : 0;
			for( var i:uint = 0; i < length; i++ )
			{
				var address:InterfaceAddress = addresses[i];
				var resultAddress:flash.net.InterfaceAddress = new flash.net.InterfaceAddress;
				resultAddress.address = address.address;
				resultAddress.broadcast = address.broadcast;
				resultAddress.ipVersion = address.ipVersion;
				resultAddress.prefixLength = address.prefixLength;
				resultAddresses.push(resultAddress);
			}
			result.push(resultInterface);	
		}
		)
		return result;
	}	
	
}

class DefaultNetworkInfo implements INetworkInfo
{
	
	public function findInterfaces():Vector.<flash.net.NetworkInterface>
	{
		if( flash.net.NetworkInfo.isSupported )
		{
			return flash.net.NetworkInfo.networkInfo.findInterfaces();
		}
		return null;
	}
	
}

interface INetworkInfo
{
	function findInterfaces():Vector.<flash.net.NetworkInterface>;
}