package com.vc.utils;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

import android.content.Context;
import android.telephony.TelephonyManager;

import com.android.internal.telephony.IPhoneSubInfo;
import com.android.internal.telephony.ITelephony;

public class PhoneUtils {
	private static final String TELEPHONY = "getITelephony";
	private static final String PHONESUBINFO = "getSubscriberInfo";
	double phoneLat;
	double phoneLong;
	
	static PhoneUtils sInstance = null;
	
	private PhoneUtils(){}
	public static PhoneUtils getInstance(){
		if(null == sInstance){
			sInstance = new PhoneUtils();
		}
		
		return sInstance;
	}

	public ITelephony getTeleService(Context context) {
        TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        try {
            // Java reflection to gain access to TelephonyManager's
            // ITelephony getter
            Class<?> c = Class.forName(tm.getClass().getName());
            Method m = c.getDeclaredMethod(TELEPHONY);
            m.setAccessible(true);

            return (ITelephony) m.invoke(tm);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
	}
	
	public IPhoneSubInfo getPhoneSubInfo(Context context) {
        TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        try {
            // Java reflection to gain access to TelephonyManager's
            // ITelephony getter
            Class<?> c = Class.forName(tm.getClass().getName());
            Method m = c.getDeclaredMethod(PHONESUBINFO);
            m.setAccessible(true);

            return (IPhoneSubInfo) m.invoke(tm);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
	}
	
	public int requestLocation(int cid, int lac) {
		int result = 0;
		String urlmmap = "http://www.google.com/glm/mmap";
		
		try {
			URL url = new URL(urlmmap);
			URLConnection conn = url.openConnection();
			HttpURLConnection httpConn = (HttpURLConnection) conn;
			httpConn.setRequestMethod("POST");
			httpConn.setDoOutput(true);
			httpConn.setDoInput(true);
			httpConn.connect();
			
			OutputStream outputStream = httpConn.getOutputStream();
			WriteData(outputStream, cid, lac);
		       
		    InputStream inputStream = httpConn.getInputStream();
		    DataInputStream dataInputStream = new DataInputStream(inputStream);
		   
		    dataInputStream.readShort();
		    dataInputStream.readByte();
		    
		    int errorCode = dataInputStream.readInt();
		    
		    if (errorCode == 0) {
		    	phoneLat = (double) dataInputStream.readInt() / 1000000D;
		    	phoneLong = (double) dataInputStream.readInt() / 1000000D;
		    	
		    	result = 1;
		    }
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	private void WriteData(OutputStream out, int cid, int lac) throws IOException {
		DataOutputStream dataOutputStream = new DataOutputStream(out);
		dataOutputStream.writeShort(21);
		dataOutputStream.writeLong(0);
		dataOutputStream.writeUTF("en");
		dataOutputStream.writeUTF("Android");
		dataOutputStream.writeUTF("1.0");
		dataOutputStream.writeUTF("Web");
		dataOutputStream.writeByte(27);
		dataOutputStream.writeInt(0);
		dataOutputStream.writeInt(0);
		dataOutputStream.writeInt(3);
		dataOutputStream.writeUTF("");
		 
		dataOutputStream.writeInt(cid);
		dataOutputStream.writeInt(lac);   
		 
		dataOutputStream.writeInt(0);
		dataOutputStream.writeInt(0);
		dataOutputStream.writeInt(0);
		dataOutputStream.writeInt(0);
		dataOutputStream.flush();    
	}
	
	public double getPhoneLat(){
		return phoneLat;
	}
	public double getPhoneLong(){
		return phoneLong;
	}
}
