package ru.nekit.disn.model.photo
{
	
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.core.DPIClassification;
	import mx.core.FlexGlobals;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.data.fxg.*;
	import ru.nekit.disn.model.vo.PhotoLibraryItem;
	import ru.nekit.utils.FXGUtil;
	
	public class PhotoLibrary extends ModelLink
	{
		
		public static const FXG_ROOT:String = "ru.nekit.disn.model.data.fxg";
		
		public static const USER_PHOTO:String		= "UserIcon";
		public static const USER_LIST_PHOTO:String 	= "UserListIcon";
		public static const MY_WIFI:String 			= "myWifiIcon";
		public static const MAN:String 				= "Man";
		public static const WOMAN:String 			= "Woman";
		
		private var _list:Vector.<PhotoLibraryItem>;
		private var _dictionary:Object;
		
		public function PhotoLibrary()
		{
			_list = new Vector.<PhotoLibraryItem>;
			_dictionary = new Object;
			addFXG(USER_PHOTO);
			addFXG(USER_LIST_PHOTO);
			addFXG(MY_WIFI);
			addFXG(MAN);
			addFXG(WOMAN);
		}
		
		private function addFXG(name:String):void
		{
			UserIcon;
			UserListIcon;
			myWifiIcon;
			Man;
			Woman;
			var instanceClass:Class = getDefinitionByName( FXG_ROOT + "." + name) as Class;
			var item:PhotoLibraryItem = new PhotoLibraryItem(USER_PHOTO, instanceClass);
			_list.push(item);	
			item.index = _list.length;
			_dictionary[name] = item;
		}
		
		public function getIconByName(name:String):PhotoLibraryItem
		{
			return _dictionary[name];
		}
		
		private function get dpiScale():Number
		{
			return FlexGlobals.topLevelApplication.applicationDPI/DPIClassification.DPI_160;
		}
		
		public function getIconDPIBitmapDataByName(name:String, preScaleFactor:Number = 1):BitmapData
		{
			return FXGUtil.toBitmapData(getIconByName(name).instanceClass, dpiScale * preScaleFactor);
		}
		
		public function getIconDPIBitmapDataByIndex(index:uint, preScaleFactor:Number = 1):BitmapData
		{
			return FXGUtil.toBitmapData(getIconByIndex(index).instanceClass, dpiScale * preScaleFactor);
		}	
		
		public function getIconByIndex(index:uint):PhotoLibraryItem
		{
			return _list[index - 1];
		}
		
		public function get defaultUserPhoto():PhotoLibraryItem
		{
			return getIconByName(USER_PHOTO);
		}
		
		public function get dataProvider():ArrayCollection
		{
			var ac:ArrayCollection = new ArrayCollection;
			const length:uint = _list.length;
			for( var i:uint = 0 ; i < length; i++)
			{
				ac.addItem(_list[i]);
			}
			return ac;
		}
	}
}