package ru.nekit.ane;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class DeviceContext extends FREContext {

	@Override
	public void dispose() 
	{
	}

	@Override
	public Map<String, FREFunction> getFunctions() 
	{
		Map<String, FREFunction> map = 	new HashMap<String, FREFunction>();
		map.put("getUUID", 				new GetUUID());
		map.put("vibrate", 				new Vibrate());
		map.put("goSMSActivity", 		new SMSGoActivity());
		return map;
	}
}
