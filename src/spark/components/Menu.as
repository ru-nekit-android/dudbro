package spark.components
{
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.events.SandboxMouseEvent;
	import mx.managers.IFocusManagerComponent;
	
	import spark.core.NavigationUnit;
	
	use namespace mx_internal;
	
	[DefaultProperty("content")]
	
	[SkinState("normalAndLandscape")]
	
	[SkinState("closedAndLandscape")]
	
	[SkinState("disabledAndLandscape")]
	
	public class Menu extends SkinnablePopUpContainer
		implements IFocusManagerComponent
	{
		
		public function Menu()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private var isMouseDown:Boolean = false;
		
		private var _content:IVisualElement;
		
		public function get content():IVisualElement
		{
			return _content;
		}
		
		public function set content(value:IVisualElement):void
		{
			_content = value;
			if (value)
			{
				mxmlContent = [value];
			}
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void
		{   
			super.keyDownHandler(event);
			adjustSelectionAndCaretUponNavigation(event); 
		}
		
		override protected function getCurrentSkinState():String
		{
			var skinState:String = super.getCurrentSkinState();
			if (FlexGlobals.topLevelApplication.aspectRatio == "portrait")
				return super.getCurrentSkinState();
			else
				return skinState + "AndLandscape";                
		}
		
		private function adjustSelectionAndCaretUponNavigation(event:KeyboardEvent):void
		{
			var navigationUnit:uint = mapKeycodeForLayoutDirection(event);
			if (!NavigationUnit.isNavigationUnit(event.keyCode))
				return; 	
			event.preventDefault(); 
		}
		
		private function addedToStageHandler(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			systemManager.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler, true);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			systemManager.stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler, true);
		}
		
		private function orientationChangeHandler(event:StageOrientationEvent):void
		{
			invalidateSkinState();
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			isMouseDown = true;
			systemManager.getSandboxRoot().addEventListener(
				MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true /* useCapture */);
			
			systemManager.getSandboxRoot().addEventListener(
				SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
		}
		
		private function systemManager_mouseUpHandler(event:Event):void
		{
			systemManager.getSandboxRoot().removeEventListener(
				MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true /* useCapture */);
			
			systemManager.getSandboxRoot().removeEventListener(
				SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
			
			isMouseDown = false;
		}
	}
}