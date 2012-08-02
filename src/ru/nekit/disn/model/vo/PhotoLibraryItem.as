package ru.nekit.disn.model.vo
{

	public class PhotoLibraryItem
	{
	
		public var name:String;
		public var instanceClass:Class;
		
		public var index:uint;
		
		public function PhotoLibraryItem(name:String, instanceClass:Class)
		{
			this.name 			= name;
			this.instanceClass 	= instanceClass;
		}
	}
}