package ru.nekit.disn.model.desktop
{
	
	import com.projectcocoon.p2p.vo.ClientVO;
	
	public class Desktop
	{
		
		public var p2pClient:ClientVO;
		
		public function Desktop(p2pClient:ClientVO)
		{
			this.p2pClient = p2pClient;
		}
	}
}