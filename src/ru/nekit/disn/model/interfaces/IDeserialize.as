package ru.nekit.disn.model.interfaces
{
	import flash.utils.ByteArray;

	public interface IDeserialize
	{
		
		function deserialize(value:ByteArray):void;
		
	}
}