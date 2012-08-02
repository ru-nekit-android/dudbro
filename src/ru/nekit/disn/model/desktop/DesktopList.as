package ru.nekit.disn.model.desktop
{
	
	import flash.utils.Dictionary;
	
	import ru.nekit.disn.model.ModelLink;
	
	public class DesktopList extends ModelLink
	{
		
		private var _list:Vector.<Desktop>;
		private var _uidList:Dictionary;
		
		public function DesktopList()
		{
			super();
			_list = new Vector.<Desktop>;
			_uidList = new Dictionary;
		}
		
		public function add(desktop:Desktop):void
		{
			if( !hasDesktop(desktop) )
			{
				_uidList[desktop.p2pClient.uid] = desktop;
				_list.push(desktop);
			}
		}
		
		public function getDesktopAt(position:uint):Desktop
		{
			if( position < length )
			{
				return _list[position];
			}
			return null;
		}
		
		public function getByUID(uid:String):Desktop
		{
			if( uid in _uidList )
			{
				return _uidList[uid];
			}
			return null;
		}
		
		public function get length():uint
		{
			return _list.length;
		}
		
		public function hasDesktop(desktop:Desktop):Boolean
		{
			return desktop.p2pClient.uid in _uidList;
		}
	}
}