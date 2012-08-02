package ru.nekit.disn.model.properties
{
	
	import ru.nekit.disn.model.vo.PropertiesVO;
	import ru.nekit.disn.model.ModelLink;
	
	
	public class Properties extends ModelLink
	{
		
		public function Properties()
		{
			super(new PropertiesVO )
		}
		
		public function get vo():PropertiesVO
		{
			return data as PropertiesVO;
		}
	}
}