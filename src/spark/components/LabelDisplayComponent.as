package spark.components
{
	
	import flash.events.Event;
	
	import mx.core.DPIClassification;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.StyleableTextField;
	import spark.core.IDisplayText;
	
	use namespace mx_internal;
	
	public class LabelDisplayComponent extends UIComponent implements IDisplayText
	{
		
		private var titleDisplay:StyleableTextField;
		private var titleDisplayShadow:StyleableTextField;
		private var title:String;
		private var titleChanged:Boolean;
		private var shadowDistance:uint;
		private var _realTextHeight:Number;
		
		public function LabelDisplayComponent()
		{
			super();
			
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					
					shadowDistance = 2;
					
					break;
				}
				case DPIClassification.DPI_240:
				{
					
					shadowDistance = 1;
					
					break;
				}
				default:
				{
					
					shadowDistance = 1;
					
					break;
				}
			}
			title = "";
		}
		
		protected function get applicationDPI():Number
		{
			return FlexGlobals.topLevelApplication.applicationDPI;
		}
		
		override public function get baselinePosition():Number
		{
			return titleDisplay.baselinePosition;
		}
		
		/**
		 *  @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			titleDisplay = StyleableTextField(createInFontContext(StyleableTextField));
			titleDisplay.styleName = this;
			titleDisplay.editable = false;
			titleDisplay.selectable = false;
			titleDisplay.multiline = false;
			titleDisplay.wordWrap = false;
			titleDisplay.addEventListener(FlexEvent.VALUE_COMMIT,
				titleDisplay_valueCommitHandler);
			
			titleDisplayShadow =
				StyleableTextField(createInFontContext(StyleableTextField));
			titleDisplayShadow.styleName = this;
			titleDisplayShadow.colorName = "textShadowColor";
			titleDisplayShadow.editable = false;
			titleDisplayShadow.selectable = false;
			titleDisplayShadow.multiline = false;
			titleDisplayShadow.wordWrap = false;
			
			addChild(titleDisplayShadow);
			addChild(titleDisplay);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (titleChanged)
			{
				titleDisplay.text = title;
				
				invalidateSize();
				invalidateDisplayList();
				
				titleChanged = false;
			}
		}
		
		override protected function measure():void
		{
			var textWidth:Number = 0;
			var textHeight:Number = 0;
			if (titleDisplay.isTruncated)
				titleDisplay.text = title;
			measuredWidth = titleDisplay.getPreferredBoundsWidth();
			measuredHeight = titleDisplay.getPreferredBoundsHeight();
			_realTextHeight = titleDisplay.measuredTextSize.y + shadowDistance;
		}
		
		/**
		 *  @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (titleDisplay.isTruncated)
				titleDisplay.text = title;
			titleDisplay.commitStyles();	
			titleDisplay.setLayoutBoundsPosition(0, 0);
			titleDisplay.setLayoutBoundsSize(unscaledWidth, unscaledHeight);
			titleDisplay.truncateToFit();			
			titleDisplayShadow.commitStyles();
			titleDisplayShadow.setLayoutBoundsPosition(0, -shadowDistance);
			titleDisplayShadow.setLayoutBoundsSize(unscaledWidth, unscaledHeight);			
			titleDisplayShadow.alpha = getStyle("textShadowAlpha");
			if (titleDisplay.isTruncated)
				titleDisplayShadow.text = titleDisplay.text;
		}
		
		private function titleDisplay_valueCommitHandler(event:Event):void 
		{
			titleDisplayShadow.text = titleDisplay.text;
		}
		
		public function get text():String
		{
			return title;
		}
		
		public function set text(value:String):void
		{
			title = value;
			titleChanged = true;
			
			invalidateProperties();
		}
		
		public function get isTruncated():Boolean
		{
			return titleDisplay.isTruncated;
		}
		
		public function get realTextHeight():Number
		{
			return _realTextHeight;
		}
	}
}