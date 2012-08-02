////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2011 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package spark.skins.ios
{
	
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.text.TextFormatAlign;
	
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	import mx.utils.ColorUtil;
	
	import spark.components.ActionBar;
	import spark.components.Group;
	import spark.components.LabelDisplayComponent;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalAlign;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	use namespace mx_internal;
	
	/**
	 *  The default skin class for the Spark ActionBar component in mobile
	 *  applications.
	 *  
	 *  @see spark.components.ActionBar
	 *  @see spark.skins.mobile.NavigationButtonSkin
	 *  @see spark.skins.mobile.NavigationBackButtonSkin
	 *  @see spark.skins.mobile.ActionButtonSkin
	 *  @see spark.skins.mobile.ActionRoundedButtonSkin
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	public class ActionBarSkin extends MobileSkin
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function ActionBarSkin()
		{
			super();
			
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					layoutContentGroupHeight = 88;
					layoutTitleGroupHorizontalPadding = 26;
					borderWeight = 2;
					
					break;
				}
				case DPIClassification.DPI_240:
				{
					layoutContentGroupHeight = 66;
					layoutTitleGroupHorizontalPadding = 20;
					borderWeight = 1;
					
					break;
				}
				default:
				{
					// default DPI_160
					layoutContentGroupHeight = 44;
					layoutTitleGroupHorizontalPadding = 13;
					borderWeight = 1;
					
					break;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Layout variables
		//
		//--------------------------------------------------------------------------
		
		protected var layoutContentGroupHeight:uint;
		
		protected var layoutTitleGroupHorizontalPadding:uint;
		
		protected var borderWeight:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/** 
		 *  @copy spark.skins.spark.ApplicationSkin#hostComponent
		 */
		public var hostComponent:ActionBar;
		
		private var _navigationVisible:Boolean = false;
		
		private var _titleContentVisible:Boolean = false;
		
		private var _actionVisible:Boolean = false;
		
		private var colorized:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------
		
		public var navigationGroup:Group;
		
		public var titleGroup:Group;
		
		public var actionGroup:Group;
		
		/**
		 *  Wraps a StyleableTextField in a UIComponent to be compatible with
		 *  ViewTransition effects.
		 */
		public var titleDisplay:LabelDisplayComponent;
		
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
			navigationGroup = new Group();
			var hLayout:HorizontalLayout = new HorizontalLayout();
			hLayout.horizontalAlign = HorizontalAlign.LEFT;
			hLayout.verticalAlign = VerticalAlign.MIDDLE;
			hLayout.gap = 0;
			hLayout.paddingLeft = hLayout.paddingTop = hLayout.paddingRight = 
				hLayout.paddingBottom = 0;
			navigationGroup.layout = hLayout;
			navigationGroup.id = "navigationGroup";
			
			titleGroup = new Group();
			hLayout = new HorizontalLayout();
			hLayout.horizontalAlign = HorizontalAlign.LEFT;
			hLayout.verticalAlign = VerticalAlign.MIDDLE;
			hLayout.gap = 0;
			hLayout.paddingLeft = hLayout.paddingRight = layoutTitleGroupHorizontalPadding; 
			hLayout.paddingTop = hLayout.paddingBottom = 0;
			titleGroup.layout = hLayout;
			titleGroup.id = "titleGroup";
			
			actionGroup = new Group();
			hLayout = new HorizontalLayout();
			hLayout.horizontalAlign = HorizontalAlign.RIGHT;
			hLayout.verticalAlign = VerticalAlign.MIDDLE;
			hLayout.gap = 0;
			hLayout.paddingLeft = hLayout.paddingTop = hLayout.paddingRight = 
				hLayout.paddingBottom = 0;
			actionGroup.layout = hLayout;
			actionGroup.id = "actionGroup";
			
			titleDisplay = new LabelDisplayComponent();
			titleDisplay.id = "titleDisplay";
			
			addChild(navigationGroup);
			addChild(titleGroup);
			addChild(actionGroup);
			addChild(titleDisplay);
		}
		
		/**
		 *  @private
		 */
		override protected function measure():void
		{
			var titleWidth:Number = 0;
			var titleHeight:Number = 0;
			
			if (_titleContentVisible)
			{
				titleWidth = titleGroup.getPreferredBoundsWidth();
				titleHeight = titleGroup.getPreferredBoundsHeight();
			}
			else
			{
				// use titleLayout for paddingLeft and paddingRight
				var layoutObject:Object = hostComponent.titleLayout;
				titleWidth = ((layoutObject.paddingLeft) ? Number(layoutObject.paddingLeft) : 0)
					+ ((layoutObject.paddingRight) ? Number(layoutObject.paddingRight) : 0)
					+ titleDisplay.getPreferredBoundsWidth();
				
				titleHeight = titleDisplay.getPreferredBoundsHeight();
			}
			
			measuredWidth =
				getStyle("paddingLeft")
				+ navigationGroup.getPreferredBoundsWidth()
				+ titleWidth
				+ actionGroup.getPreferredBoundsWidth()
				+ getStyle("paddingRight");
			
			// measuredHeight is contentGroupHeight, 2x border on top and bottom
			measuredHeight =
				getStyle("paddingTop")
				+ Math.max(layoutContentGroupHeight,
					navigationGroup.getPreferredBoundsHeight(), 
					actionGroup.getPreferredBoundsHeight(),
					titleHeight)
				+ getStyle("paddingBottom");
		}
		
		/**
		 *  @private
		 */
		override protected function commitCurrentState():void
		{
			super.commitCurrentState();
			
			_titleContentVisible = currentState.indexOf("titleContent") >= 0;
			_navigationVisible = currentState.indexOf("Navigation") >= 0;
			_actionVisible = currentState.indexOf("Action") >= 0;
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 *  @private
		 */
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			if (styleProp == "textAlign")
			{
				var titleAlign:String = getStyle("textAlign");
				
				if (titleAlign == "center")
				{ 
					// If the title align is set to center, the alignment is set to LEFT
					// so that the skin can manually center the component in layoutContents
					titleDisplay.setStyle("textAlign", TextFormatAlign.LEFT);
				}
				else
				{
					titleDisplay.setStyle("textAlign", titleAlign);
				}
			}
		}
		
		/**
		 *  @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			var navigationGroupWidth:Number = 0;
			
			var paddingLeft:Number   = getStyle("paddingLeft"); 
			var paddingRight:Number  = getStyle("paddingRight");
			var paddingTop:Number    = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");
			
			var titleCompX:Number = paddingLeft;
			var titleCompWidth:Number = 0;
			var titleHeight:Number = 0;
			var titleCompY:Number = 0;
			
			var actionGroupX:Number = unscaledWidth;
			var actionGroupWidth:Number = 0;
			
			// remove top and bottom padding from content group height
			var contentGroupsHeight:Number = Math.max(0, unscaledHeight - paddingTop - paddingBottom);
			
			// position groups, overlap of navigation and action groups is allowed
			// when overlap occurs, titleDisplay/titleGroup is not visible
			if (_navigationVisible)
			{
				navigationGroupWidth = navigationGroup.getPreferredBoundsWidth();
				titleCompX += navigationGroupWidth;
				
				setElementSize(navigationGroup, navigationGroupWidth, contentGroupsHeight);
				setElementPosition(navigationGroup, paddingLeft, paddingTop);
			}
			
			if (_actionVisible)
			{
				// actionGroup x position can be negative
				actionGroupWidth = actionGroup.getPreferredBoundsWidth();
				actionGroupX = unscaledWidth - actionGroupWidth - paddingRight;
				
				setElementSize(actionGroup, actionGroupWidth, contentGroupsHeight);
				setElementPosition(actionGroup, actionGroupX, paddingTop);
			}
			
			// titleGroup or titleDisplay is given remaining width after navigation
			// and action groups preferred widths
			titleCompWidth = unscaledWidth - navigationGroupWidth - actionGroupWidth
				- paddingLeft - paddingRight;
			
			if (titleCompWidth <= 0)
			{
				titleDisplay.visible = false;
				titleGroup.visible = false;
			}
			else if (_titleContentVisible)
			{
				titleDisplay.visible = false;
				titleGroup.visible = true;
				
				// use titleGroup for titleContent
				setElementSize(titleGroup, titleCompWidth, contentGroupsHeight);
				setElementPosition(titleGroup, titleCompX, paddingTop);
			}
			else
			{
				// use titleDisplay for title text label
				titleGroup.visible = false;
				
				// use titleLayout for paddingLeft and paddingRight
				var layoutObject:Object = hostComponent.titleLayout;
				var titlePaddingLeft:Number = (layoutObject.paddingLeft) ? Number(layoutObject.paddingLeft) : 0;
				var titlePaddingRight:Number = (layoutObject.paddingRight) ? Number(layoutObject.paddingRight) : 0;
				
				titleHeight = titleDisplay.getExplicitOrMeasuredHeight();
				titleCompY = Math.round((contentGroupsHeight - titleHeight)/2) + paddingTop;
				
				// align titleDisplay to the absolute center
				var titleAlign:String = getStyle("titleAlign");
				
				// check for available width after padding
				if ((titleCompWidth - titlePaddingLeft - titlePaddingRight) <= 0)
				{
					titleCompX = 0;
					titleCompWidth = 0;
				}
				else if (titleAlign == "center")
				{ 
					// use LEFT instead of CENTER
					titleCompWidth = titleDisplay.getExplicitOrMeasuredWidth();
					
					// use x position of titleDisplay to implement CENTER
					titleCompX = Math.round((unscaledWidth - titleCompWidth) / 2); 
					
					var navigationOverlap:Number = navigationGroupWidth + titlePaddingLeft - titleCompX;
					var actionOverlap:Number = (titleCompX + titleCompWidth + titlePaddingRight) - actionGroupX;
					
					// shrink and/or move titleDisplay width if there is any
					// overlap after centering
					if ((navigationOverlap > 0) && (actionOverlap > 0))
					{
						// remaining width
						titleCompX = navigationGroupWidth + titlePaddingLeft;
						titleCompWidth = unscaledWidth - navigationGroupWidth - actionGroupWidth - titlePaddingLeft - titlePaddingRight;
					}
					else if ((navigationOverlap > 0) || (actionOverlap > 0))
					{
						if (navigationOverlap > 0)
						{
							// nudge to the right
							titleCompX += navigationOverlap;
						}
						else if (actionOverlap > 0)
						{
							// nudge to the left
							titleCompX -= actionOverlap;
							
							// force left padding
							if (titleCompX < (navigationGroupWidth + titlePaddingLeft))
								titleCompX = navigationGroupWidth + titlePaddingLeft;
						}
						
						// recompute action overlap and force right padding
						actionOverlap = (titleCompX + titleCompWidth + titlePaddingRight) - actionGroupX;
						
						if (actionOverlap > 0)
							titleCompWidth -= actionOverlap;
					}
				}
				else
				{
					// implement padding by adjusting width and position
					titleCompX += titlePaddingLeft;
					titleCompWidth = titleCompWidth - titlePaddingLeft - titlePaddingRight;
				}
				
				// check for negative width
				titleCompWidth = (titleCompWidth < 0) ? 0 : titleCompWidth;
				
				setElementSize(titleDisplay, titleCompWidth, titleDisplay.realTextHeight);
				setElementPosition(titleDisplay, titleCompX, titleCompY);
				
				titleDisplay.visible = true;
			}
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.drawBackground(unscaledWidth, unscaledHeight);
			
			var chromeColor:uint = getStyle("chromeColor");
			var backgroundAlphaValue:Number = getStyle("backgroundAlpha");
			var colors:Array = [];
			
			// apply alpha to chromeColor fill only
			var backgroundAlphas:Array = [backgroundAlphaValue, backgroundAlphaValue, backgroundAlphaValue, backgroundAlphaValue];
			
			// exclude top and bottom 1px borders
			colorMatrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0);
			
			colors[0] = ColorUtil.adjustBrightness2(chromeColor, 40);
			colors[1] = ColorUtil.adjustBrightness2(chromeColor, 20);
			colors[2] = chromeColor;
			colors[3] = chromeColor;
			
			var roundCorner:Number = 8*applicationDPI/160;
			// glossy fill
			graphics.beginGradientFill(GradientType.LINEAR, colors, backgroundAlphas, ThemeConstants.CHROME_COLOR_RATIOS, colorMatrix);
			graphics.drawRoundRectComplex(0, 0, unscaledWidth, unscaledHeight, roundCorner, roundCorner, 0, 0);
			graphics.endFill();
			
			// top border light
			var borderInset:uint = borderWeight / 2;// - roundCorner;
			graphics.lineStyle(borderWeight, 0xFFFFFF, 0.3, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			graphics.moveTo(roundCorner - 2, borderInset);
			graphics.lineTo(unscaledWidth - roundCorner + 2, borderInset);
			
			// bottom border dark
			graphics.lineStyle(borderWeight, 0, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			graphics.moveTo(0, unscaledHeight - borderInset - 1);
			graphics.lineTo(unscaledWidth, unscaledHeight - borderInset - 1);
			
			graphics.lineStyle(borderWeight, 0xffffff, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			graphics.moveTo(0, unscaledHeight - borderInset);
			graphics.lineTo(unscaledWidth, unscaledHeight - borderInset );
			
			/*graphics.lineStyle(borderWeight, 0xffffff, .5, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			graphics.moveTo(0, roundCorner);
			graphics.lineTo(0, unscaledHeight);*/
		}
		
	}
}
