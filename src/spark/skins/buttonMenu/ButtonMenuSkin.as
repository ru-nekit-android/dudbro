////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2010 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package spark.skins.buttonMenu
{
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import mx.core.mx_internal;
	
	import spark.components.ButtonBar;
	import spark.components.ButtonBarButton;
	import spark.components.ButtonMenuButton;
	import spark.components.DataGroup;
	import spark.events.RendererExistenceEvent;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalLayout;
	import spark.skins.mobile.supportClasses.ButtonBarButtonClassFactory;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	use namespace mx_internal;
	
	/**
	 *  The default skin class for the Spark ButtonBar component.
	 *
	 *  @see spark.components.ButtonBar
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	public class ButtonMenuSkin extends MobileSkin
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 *
		 */
		public function ButtonMenuSkin()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @copy spark.skins.spark.ApplicationSkin#hostComponent
		 */
		public var hostComponent:ButtonBar;
		
		/**
		 *  @copy spark.components.ButtonBar#firstButton
		 */
		public var firstButton:ButtonBarButtonClassFactory;
		
		/**
		 *  @copy spark.components.ButtonBar#lastButton
		 */
		public var lastButton:ButtonBarButtonClassFactory;
		
		/**
		 *  @copy spark.components.ButtonBar#middleButton
		 */
		public var middleButton:ButtonBarButtonClassFactory;
		
		/**
		 *  @copy spark.components.SkinnableDataContainer#dataGroup
		 */
		public var dataGroup:DataGroup;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function createChildren():void
		{
			// Set up the class factories for the buttons
			if (!firstButton)
			{
				firstButton = new ButtonBarButtonClassFactory(ButtonMenuButton);
				firstButton.skinClass = spark.skins.buttonMenu.ButtonMenuFirstButtonSkin;
			}
			if (!lastButton)
			{
				lastButton = new ButtonBarButtonClassFactory(ButtonMenuButton);
				lastButton.skinClass = spark.skins.buttonMenu.ButtonMenuLastButtonSkin;
			}
			
			if (!middleButton)
			{
				middleButton = new ButtonBarButtonClassFactory(ButtonMenuButton);
				middleButton.skinClass = spark.skins.buttonMenu.ButtonMenuMiddleButtonSkin;
			}
			// create the data group to house the buttons
			if (!dataGroup)
			{
				dataGroup = new DataGroup();
				var layout:VerticalLayout = new VerticalLayout();
				layout.requestedMinRowCount = 3;
				layout.horizontalAlign = HorizontalAlign.CONTENT_JUSTIFY;
				layout.gap = 1;
				dataGroup.layout = layout;
				dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD, dataGroup_rendererAddHandler);
				addChild(dataGroup);
			}
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}
		
		private function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			event.renderer.depth = 100 - event.index;
		}	
		
		private function removeFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_ADD, dataGroup_rendererAddHandler);
		}
		
		/**
		 *  @private
		 */
		override protected function commitCurrentState():void
		{
			alpha = (currentState == "disabled") ? 0.5 : 1;
		}
		
		override protected function measure():void
		{
			measuredWidth = dataGroup.measuredWidth;
			measuredHeight = dataGroup.measuredHeight;
			
			measuredMinWidth = dataGroup.measuredMinWidth;
			measuredMinHeight = dataGroup.measuredMinHeight;
		}
		
		/**
		 *  @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			setElementPosition(dataGroup, 0, 0);
			setElementSize(dataGroup, unscaledWidth, unscaledHeight);
		}
	}
}