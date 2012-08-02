package spark.skins.form
{
	
	import spark.skins.ios160.assets.TopFill;
	import spark.skins.ios240.assets.TopFill;
	import spark.skins.ios320.assets.TopFill;
	
	public class TopPartFormSkin extends BasePartFormSkin
	{
		public function TopPartFormSkin()
		{
			super();
		}
		
		override protected function get backgroundClass():Class
		{
			switch( applicationDPI )
			{
				case 320:
					return spark.skins.ios320.assets.TopFill;
				case 240:
					return spark.skins.ios240.assets.TopFill;
			}
			return spark.skins.ios160.assets.TopFill;
		}
	}
}