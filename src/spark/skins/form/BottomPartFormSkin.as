package spark.skins.form
{
	
	import spark.skins.ios160.assets.Bottom_fill;
	import spark.skins.ios240.assets.Bottom_fill
	import spark.skins.ios320.assets.Bottom_fill;
	
	public class BottomPartFormSkin extends BasePartFormSkin
	{
		public function BottomPartFormSkin()
		{
			super();
		}
		
		override protected function get backgroundClass():Class
		{
			switch( applicationDPI)
			{
				case 320:
					return spark.skins.ios320.assets.Bottom_fill;
				case 240:
					return spark.skins.ios240.assets.Bottom_fill;
			}
			return spark.skins.ios160.assets.Bottom_fill;
		}
	}
}