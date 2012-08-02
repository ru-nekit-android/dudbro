/* Copyright (c) 2011, PIA. All rights reserved.
*
* This file is part of Eskimo.
*
* Eskimo is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Eskimo is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with Eskimo.  If not, see <http://www.gnu.org/licenses/>.
*/
package spark.skins.text
{
	
	import mx.core.DPIClassification;
	
	import spark.filters.DropShadowFilter;
	import spark.skins.mobile.StageTextInputSkin;
	
	public class MessageTextInputSkin extends StageTextInputSkin
	{
		
		public function MessageTextInputSkin()
		{
			super();
			multiline = true;
			switch( applicationDPI )
			{
				
				case DPIClassification.DPI_320:
					
					layoutCornerEllipseSize = 36;
					
					break;
				
				case DPIClassification.DPI_240:
					
					layoutCornerEllipseSize = 27;
					
					break;
				
				default:
					
					layoutCornerEllipseSize = 18;
					
					break;
			}
			filters = [new DropShadowFilter(4, 90, 0, 0.5, 4, 4, 1, 1, true)];	
		}
	}
}
