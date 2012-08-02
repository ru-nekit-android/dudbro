package spark.skins.form
{
	
	import spark.skins.ios160.assets.TitleFill;
	import spark.skins.ios240.assets.TitleFill;
	import spark.skins.ios320.assets.TitleFill;
	
	public class TitlePartFormSkin extends BasePartFormSkin
	{
		public function TitlePartFormSkin()
		{
			super();
		}
		
		override protected function get backgroundClass():Class
		{
			switch( applicationDPI )
			{
				case 320:
					return spark.skins.ios320.assets.TitleFill;
				case 240:
					return spark.skins.ios240.assets.TitleFill;
			}
			return spark.skins.ios160.assets.TitleFill;
		}
	}
}