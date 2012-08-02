package ru.nekit.ane;

import android.provider.Settings;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

public class GetUUID implements FREFunction {

	DeviceContext context;

	public FREObject call(FREContext context, FREObject[] arg) 
	{
		this.context = (DeviceContext)context;
		FREObject returnValue = null;
		try 
		{
			returnValue = FREObject.newObject(getUuid());
		} catch (FREWrongThreadException e) {
			context.dispatchStatusEventAsync("Exception", "Exception");
			e.printStackTrace();
		}
		return returnValue;
	}

	public String getUuid()	
	{	
		String uuid = Settings.Secure.getString(context.getActivity().getContentResolver(), Settings.Secure.ANDROID_ID);
		return uuid;
	}

}
