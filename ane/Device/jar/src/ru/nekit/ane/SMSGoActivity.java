package ru.nekit.ane;

import android.app.Activity;
import android.content.Intent;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

public class SMSGoActivity implements FREFunction {

	DeviceContext context;

	public FREObject call(FREContext context, FREObject[] arg)
	{
		this.context = (DeviceContext) context;
		try {
			String phoneNumber = arg[0].getAsString();
			String body = arg[1].getAsString();
			goActivity(phoneNumber, body);
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

	public void goActivity(String phoneNumber, String body){
		Activity activity = context.getActivity();
		Intent smsIntent = new Intent(Intent.ACTION_VIEW); 
		smsIntent.setType("vnd.android-dir/mms-sms"); 
		smsIntent.putExtra("address", phoneNumber); 
		smsIntent.putExtra("sms_body", body);
		activity.startActivity(smsIntent);
	}

}
