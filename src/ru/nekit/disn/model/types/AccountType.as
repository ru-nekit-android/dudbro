package ru.nekit.disn.model.types
{
	
	import mx.collections.ArrayList;
	
	import ru.nekit.disn.model.viewDataItem.MenuDataItem;
	
	public class AccountType
	{
		
		public static const FACEBOOK:uint = 1;
		public static const VK:uint = 2;
		public static const GOOGLEPLUS:uint = 3;
		public static const EMAIL:uint = 4;
		public static const LIVEJOURNAL:uint = 5;
		public static const BEHANCE:uint = 6;
		public static const TWITTER:uint = 7;
		public static const SITE:uint = 8;
		
		public static function get list():ArrayList
		{
			return new ArrayList([new MenuDataItem("Facebook", FACEBOOK),
				new MenuDataItem("ВКонтакте", VK),
				new MenuDataItem("Google+", GOOGLEPLUS),
				new MenuDataItem("Email@", EMAIL),
				new MenuDataItem("ЖЖ", LIVEJOURNAL),
				new MenuDataItem("Behance", BEHANCE),
				new MenuDataItem("Twitter", TWITTER),
				new MenuDataItem("Мой сайт", SITE),
			]);
		}
	}
}