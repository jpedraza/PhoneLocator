/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.android.internal.telephony;

import android.os.Bundle;
import java.util.List;
import android.telephony.NeighboringCellInfo;

/**
 * Interface used to interact with the phone.  Mostly this is used by the
 * TelephonyManager class.  A few places are still using this directly.
 * Please clean them up if possible and use TelephonyManager insteadl.
 *
 * {@hide}
 */
interface ITelephony {

    /**
     * Dial a number. This doesn't place the call. It displays
     * the Dialer screen.
     * @param number the number to be dialed. If null, this
     * would display the Dialer screen with no number pre-filled.
     */
    void dial(String number);

    /**
     * Place a call to the specified number.
     * @param number the number to be called.
     */
    void call(String number);

    /**
     * If there is currently a call in progress, show the call screen.
     * The DTMF dialpad may or may not be visible initially, depending on
     * whether it was up when the user last exited the InCallScreen.
     *
     * @return true if the call screen was shown.
     */
    boolean showCallScreen();

    /**
     * Variation of showCallScreen() that also specifies whether the
     * DTMF dialpad should be initially visible when the InCallScreen
     * comes up.
     *
     * @param showDialpad if true, make the dialpad visible initially,
     *                    otherwise hide the dialpad initially.
     * @return true if the call screen was shown.
     *
     * @see showCallScreen
     */
    boolean showCallScreenWithDialpad(boolean showDialpad);

    /**
     * End call if there is a call in progress, otherwise does nothing.
     *
     * @return whether it hung up
     */
    boolean endCall();

    /**
     * Answer the currently-ringing call.
     *
     * If there's already a current active call, that call will be
     * automatically put on hold.  If both lines are currently in use, the
     * current active call will be ended.
     *
     * TODO: provide a flag to let the caller specify what policy to use
     * if both lines are in use.  (The current behavior is hardwired to
     * "answer incoming, end ongoing", which is how the CALL button
     * is specced to behave.)
     *
     * TODO: this should be a oneway call (especially since it's called
     * directly from the key queue thread).
     */
    void answerRingingCall();

    /**
     * Silence the ringer if an incoming call is currently ringing.
     * (If vibrating, stop the vibrator also.)
     *
     * It's safe to call this if the ringer has already been silenced, or
     * even if there's no incoming call.  (If so, this method will do nothing.)
     *
     * TODO: this should be a oneway call too (see above).
     *       (Actually *all* the methods here that return void can
     *       probably be oneway.)
     */
    void silenceRinger();

    /**
     * Check if we are in either an active or holding call
     * @return true if the phone state is OFFHOOK.
     */
    boolean isOffhook();

    /**
     * Check if an incoming phone call is ringing or call waiting.
     * @return true if the phone state is RINGING.
     */
    boolean isRinging();

    /**
     * Check if the phone is idle.
     * @return true if the phone state is IDLE.
     */
    boolean isIdle();

    /**
     * Check to see if the radio is on or not.
     * @return returns true if the radio is on.
     */
    boolean isRadioOn();

    /**
     * Check if the SIM pin lock is enabled.
     * @return true if the SIM pin lock is enabled.
     */
    boolean isSimPinEnabled();

    /**
     * Cancels the missed calls notification.
     */
    void cancelMissedCallsNotification();

    /**
     * Supply a pin to unlock the SIM.  Blocks until a result is determined.
     * @param pin The pin to check.
     * @return whether the operation was a success.
     */
    boolean supplyPin(String pin);

    /**
     * Handles PIN MMI commands (PIN/PIN2/PUK/PUK2), which are initiated
     * without SEND (so <code>dial</code> is not appropriate).
     *
     * @param dialString the MMI command to be executed.
     * @return true if MMI command is executed.
     */
    boolean handlePinMmi(String dialString);

    /**
     * Toggles the radio on or off.
     */
    void toggleRadioOnOff();

    /**
     * Set the radio to on or off
     */
    boolean setRadio(boolean turnOn);

    /**
     * Request to update location information in service state
     */
    void updateServiceLocation();

    /**
     * Enable location update notifications.
     */
    void enableLocationUpdates();

    /**
     * Disable location update notifications.
     */
    void disableLocationUpdates();

    /**
     * Enable a specific APN type.
     */
    int enableApnType(String type);

    /**
     * Disable a specific APN type.
     */
    int disableApnType(String type);

    /**
     * Allow mobile data connections.
     */
    boolean enableDataConnectivity();

    /**
     * Disallow mobile data connections.
     */
    boolean disableDataConnectivity();

    /**
     * Report whether data connectivity is possible.
     */
    boolean isDataConnectivityPossible();

    Bundle getCellLocation();

    /**
     * Returns the neighboring cell information of the device.
     */
    List<NeighboringCellInfo> getNeighboringCellInfo();

     int getCallState();
     int getDataActivity();
     int getDataState();

    /**
     * Returns the current active phone type as integer.
     * Returns TelephonyManager.PHONE_TYPE_CDMA if RILConstants.CDMA_PHONE
     * and TelephonyManager.PHONE_TYPE_GSM if RILConstants.GSM_PHONE
     */
    int getActivePhoneType();

    /**
     * Returns the CDMA ERI icon index to display
     */
    int getCdmaEriIconIndex();

    /**
     * Returns the CDMA ERI icon mode,
     * 0 - ON
     * 1 - FLASHING
     */
    int getCdmaEriIconMode();

    /**
     * Returns the CDMA ERI text,
     */
    String getCdmaEriText();

    /**
     * Returns true if OTA service provisioning needs to run.
     * Only relevant on some technologies, others will always
     * return false.
     */
    boolean needsOtaServiceProvisioning();

    /**
      * Returns the unread count of voicemails
      */
    int getVoiceMessageCount();

    /**
      * Returns the network type
      */
    int getNetworkType();

    /**
     * Return true if an ICC card is present
     */
    boolean hasIccCard();

    //CONFIG_LGT_FEATURE [[
    String getLgt3GDataStatus(int mode);
    // GOPEACE jypark 100621
    String getLgtOzStartPage();

    String getHandsetInfo(String ID) ;
    //CONFIG_LGT_FEATURE ]]

    /**
     * Return if the current radio is LTE on CDMA. This
     * is a tri-state return value as for a period of time
     * the mode may be unknown.
     *
     * @return {@link Phone#LTE_ON_CDMA_UNKNOWN}, {@link Phone#LTE_ON_CDMA_FALSE}
     * or {@link PHone#LTE_ON_CDMA_TRUE}
     */
    int getLteOnCdmaMode();

    // KOREA MODEL FEATURE - START
    
    /**
     * return true if can answer call by home-key
     */
    boolean isAnyKeyMode();

    /**
     * return true if call state is dialing
     */
    boolean isDialing();

    /**
     * return true if call state is alerting
     */
    boolean isAlerting();

    /**
     * return true if current call is video call
     */
    boolean isVideoCall();

    /**
     * return true if current call is video call
     */
    boolean isStartVideoCall();

    /**
     * return true if call activity is on foreground
     */
    boolean isShowingCallScreen();

    /**
     * Request to update missed-call notification
     */
    void notifyMissedCall(String name, String number, String label, long date);

    // VoIP(FMC) FEATURE - START

    /**
     * Register information of FMC
     */
    void registerForCurrentVoIP(String apkName, String actionExitName, String voipPhoneNumber);

    /**
     * Unregister information of FMC
     */
    void unregisterForCurrentVoIP();

    /**
     * Answer call of FMC
     */
    boolean answerVoIPCall();

    /**
     * Hang-up call of FMC
     */
    boolean hangupVoIPCall();

    /**
     * Set the FMC state to ringing
     */
    void setVoIPRinging();

    /**
     * Set the FMC state to dialing
     */
    void setVoIPDialing();

    /**
     * Set the FMC state to offhook
     */
    void setVoIPInCall();

    /**
     * Set the FMC state to idle
     */
    void setVoIPIdle();

    /**
     * return true if FMC state is idle
     */
    boolean isVoIPIdle();

    /**
     * return true if FMC state is ringing or dialing
     */
    boolean isVoIPRingOrDialing();

    /**
     * return true if FMC state is ringing
     */
    boolean isVoIPRinging();

    /**
     * return true if FMC state is dialing
     */
    boolean isVoIPDialing();

    /**
     * return true if FMC state is offhook
     */
    boolean isVoIPActivated();

    /**
     * return phone number of FMC
     */
    String getCurrentVoIPNumber();

    /**
     * Place a call to the specified number.
     * @param number the number to be called.
     */
    void callInVoIP(String number);

    /**
     * Move FMC activity to top of task
     */
    boolean moveVoIPToTop();

    /**
     * return base call time of FMC
     */
    long getVoIPCallBaseTime();

    /**
     * Set the FMC base call time
     */
    void setVoIPCallBaseTime(long baseCallTime);

    /**
     * Switch holding call and active call of FMC
     */
    boolean switchVoIPHoldingAndActive();

    /**
     * return true if FMC call is mute
     */
    boolean getVoIPMute();

    /**
     * Set the FMC mute state to true
     */
    void setVoIPMuteState(boolean falg);

    /**
     * Mute FMC call
     */
    boolean setVoIPMute(boolean flag);

    /**
     * Turn on speaker of FMC
     */
    void turnOnVoIPSpeaker(boolean flag);

    /**
     * Set the count of FMC active call
     */
    void setActiveVoIPCallsCount(int activeCalls);

    /**
     * return count of FMC active call
     */
    int getActiveVoIPCallsCount();

    /**
     * Set the count of FMC holding call
     */
    void setHoldVoIPCallsCount(int holdCalls);

    /**
     * return count of FMC hold call
     */
    int getHoldVoIPCallsCount();

    /**
     * Disable statusbar
     */
    void disableStatusBarforVoIP();

    /**
     * Re-enable statusbar
     */
    void reenableStatusBarforVoIP();
    
    // VoIP(FMC) FEATURE - END

// CONFIG_KOREA_FEATURE [[
    int getPhoneServiceState();
// CONFIG_KOREA_FEATURE ]]
    boolean getDataRoamingEnabled();
    void setDataRoamingEnabled(boolean set);
    void setDefaultSharedPreferencesForPhone(String pref, boolean set);
    int getServiceState();    
    boolean isRoamingArea();
    boolean getDataNetworkDisable();

    // KOREA MODEL FEATURE - END
    //SecFeature.FEATURE_SEC_NFC_SCAPI_Start
    /**
     * Returns the response APDU for a command APDU sent to a logical channel
     */
    String transmitIccLogicalChannel(int cla, int command, int channel,
            int p1, int p2, int p3, String data);

    /**
     * Returns the response APDU for a command APDU sent to the basic channel
     */
    String transmitIccBasicChannel(int cla, int command,
            int p1, int p2, int p3, String data);

    /**
     * Returns the channel id of the logical channel,
     * Returns 0 on error.
     */
    int openIccLogicalChannel(String AID);

    /**
     * Return true if logical channel was closed successfully
     */
    boolean closeIccLogicalChannel(int channel);

    /**
     * Returns the error code of the last error occured.
     * Currently only used for openIccLogicalChannel
     */
    int getLastError();
    /**
     * Return ATR info
     */
    byte[] getAtr();

    /**
     * Returns the response APDU for a command APDU sent through SIM_IO
     */
    byte[] transmitIccSimIO(int fileID, int command, int p1, int p2, int p3, String filePath);
//SecFeature.FEATURE_SEC_NFC_SCAPI
}

