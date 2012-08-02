package ru.nekit.disn.model.viewDataItem
{
	
	public class MenuDataItem
	{
		
		[Bindable]
		public var label:String;
		public var action:*;
		public var icon:*;
		[Bindable]
		public var message:String;
		[Bindable]
		public var hint:String;
		
		public function MenuDataItem(label:String = null, action:* = null, icon:* = null, message:String = null, hint:String = null)
		{
			this.label 		= label;
			this.action 	= action;
			this.icon 		= icon;
			this.message 	= message;
			this.hint		= hint;
		}
	}
}