package com.vc.main;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.RemoteException;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.telephony.gsm.GsmCellLocation;
import android.util.Log;
import android.widget.TextView;
import android.widget.Toast;

import com.android.internal.telephony.IPhoneSubInfo;
import com.android.internal.telephony.ITelephony;
import com.vc.utils.PhoneUtils;

public class PhoneLocatorActivity extends Activity {
	private final String TAG = "PhoneLocatorActivity";
	private final int MSG_REQUEST_LOCATION = 1000;
	
    Context mContext;
    ITelephony mTelephonyService;
    IPhoneSubInfo mPhoneSubInfo;
    TelephonyManager mTelephonyManager;
    PhoneUtils sPhoneUtils;
    int mLastPhoneState = TelephonyManager.CALL_STATE_IDLE;
    
    PhoneStateListener mListener = new PhoneStateListener(){

		@Override
		public void onCallStateChanged(int state, String incomingNumber) {
			super.onCallStateChanged(state, incomingNumber);
			
			mTelephonyService = sPhoneUtils.getTeleService(mContext);			
			
			if(mLastPhoneState == TelephonyManager.CALL_STATE_IDLE && state == TelephonyManager.CALL_STATE_RINGING){
				/* Update phone state */
				mLastPhoneState = state;
				
				final GsmCellLocation cellLocation = (GsmCellLocation) mTelephonyManager.getCellLocation();
				
				new Thread(new Runnable(){
					@Override
					public void run() {
						int result = sPhoneUtils.requestLocation(cellLocation.getCid(), cellLocation.getLac());
						Message msg = mHandler.obtainMessage(MSG_REQUEST_LOCATION, result, 0);
						mHandler.sendMessage(msg);
					}
					
				}).start();
				
				boolean result = false;//sPhoneUtils.requestLocation(cellLocation.getCid(), cellLocation.getLac());
				if(true == result){
					Toast.makeText(mContext, "IncomingNumber:" + incomingNumber +
							"\nCellID:" + cellLocation.getCid() +
							"\nLac:" + cellLocation.getLac() +
							"\nPhoneLat:" + sPhoneUtils.getPhoneLat() +
							"\nPhoneLong:" + sPhoneUtils.getPhoneLong(), Toast.LENGTH_LONG).show();
				} else {
					Toast.makeText(mContext, "IncomingNumber:" + incomingNumber +
							"\nCellID:" + cellLocation.getCid() +
							"\nLac:" + cellLocation.getLac(), Toast.LENGTH_LONG).show();
				}
			} else {
				Log.i(TAG, "onCallStateChanged::::::state:" + state);
			}
			
			
		}
    	
    };
    
    private Handler mHandler = new Handler(){
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
				case MSG_REQUEST_LOCATION:
					{
						if(1 == msg.arg1){
							Toast.makeText(mContext, "PhoneLat:" + sPhoneUtils.getPhoneLat() +
									"\nPhoneLong:" + sPhoneUtils.getPhoneLong(), Toast.LENGTH_LONG).show();
						} else {
							Toast.makeText(mContext, "Network error: Can't fetch data", Toast.LENGTH_SHORT).show();
						}
					}
					break;
				default:
					Toast.makeText(mContext, "Unknown message:" + msg.what, Toast.LENGTH_SHORT).show();
					break;
			}
		}
    	
    };
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        mContext = getApplicationContext();
        sPhoneUtils = PhoneUtils.getInstance();
        mPhoneSubInfo = sPhoneUtils.getPhoneSubInfo(mContext);
        
        TextView tv = (TextView) findViewById(R.id.device_info);
        try {
			tv.setText("DeviceId:" + mPhoneSubInfo.getDeviceId() +
					"\nDeviceSvn:" + mPhoneSubInfo.getDeviceSvn() +
					"\nSubscriberId:" + mPhoneSubInfo.getSubscriberId());
		} catch (RemoteException e) {
			e.printStackTrace();
		}
        
        mTelephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
        mTelephonyManager.listen(mListener, PhoneStateListener.LISTEN_CALL_STATE);
    }
}