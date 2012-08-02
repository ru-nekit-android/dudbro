package ru.nekit.ane;

import android.content.Context;
import android.os.Vibrator;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

public class Vibrate implements FREFunction {

DeviceContext context;
	
	public FREObject call(FREContext context, FREObject[] arg)
	{
		this.context = (DeviceContext) context;
		try {
			vibrate(arg[0].getAsInt());
		} catch (IllegalStateException e) {
			context.dispatchStatusEventAsync("Exception", "Exception");
			e.printStackTrace();
		} catch (FRETypeMismatchException e) {
			context.dispatchStatusEventAsync("Exception", "Exception");
			e.printStackTrace();
		} catch (FREInvalidObjectException e) {
			context.dispatchStatusEventAsync("Exception", "Exception");
			e.printStackTrace();
		} catch (FREWrongThreadException e) {
			context.dispatchStatusEventAsync("Exception", "Exception");
			e.printStackTrace();
		}
		return null;
	}
	
	public void vibrate(long time){
        // Start the vibration, 0 defaults to half a second.
		if (time == 0) {
			time = 500;
		}
        Vibrator vibrator = (Vibrator) context.getActivity().getSystemService(Context.VIBRATOR_SERVICE);
        vibrator.vibrate(time);
	}

}