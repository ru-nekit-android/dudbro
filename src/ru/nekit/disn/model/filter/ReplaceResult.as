package ru.nekit.disn.model.filter
{
	public class ReplaceResult
	{
		
		public var oldIndex:int = -1;
		public var newIndex:int = -1;
		
		public function ReplaceResult(oldIndex:int, newIndex:int)
		{
			this.oldIndex = oldIndex;
			this.newIndex = newIndex;
		}
		
		public function get needReplace():Boolean
		{
			return oldIndex != newIndex;
		}
	}
}