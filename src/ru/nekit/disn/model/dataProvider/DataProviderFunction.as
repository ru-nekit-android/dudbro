package ru.nekit.disn.model.dataProvider
{
	
	[Bindable]
	public class DataProviderFunction
	{
		
		public var labelFunction:Function;
		public var messageFunction:Function;
		public var iconFunction:Function;
		public var decoratorFunction:Function;
		
		public function DataProviderFunction(labelFunction:Function, messageFunction:Function, iconFunction:Function, decoratorFunction:Function)
		{
			this.labelFunction = labelFunction;
			this.messageFunction = messageFunction;
			this.iconFunction = iconFunction;
			this.decoratorFunction = decoratorFunction;
		}
	}
}