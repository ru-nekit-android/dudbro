package spark.skins.form
{
	
	import spark.skins.ios160.assets.Middle_fill;
	
	public class MiddlePartFormSkin extends BasePartFormSkin
	{
		public function MiddlePartFormSkin()
		{
			super();
		}
		
		override protected function get backgroundClass():Class
		{
			return Middle_fill;
		}
	}
}