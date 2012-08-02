package spark.skins.containers
{
	
	import spark.skins.form.BasePartFormSkin;
	import spark.skins.ios160.assets.MessageContainer_fill;
	
	public class MessageContainerSkin extends BasePartFormSkin
	{
		public function MessageContainerSkin()
		{
			super();
		}
		
		override protected function get backgroundClass():Class
		{
			return MessageContainer_fill;
		}
	}
}