package ru.nekit.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class DeviceExtension implements FREExtension {

	private static DeviceContext context;
	
	public FREContext createContext(String name)
	{
		return context;
	}

	public void dispose() 
	{
		context.dispose();
		context = null;
	}

	public void initialize()
	{
		context = new DeviceContext();
	}
}
