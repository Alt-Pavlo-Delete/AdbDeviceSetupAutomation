@ECHO OFF

:setup
SET dmodel=SM-T545
ECHO WELCOME !!! ENABLE USB DEBUG AND CONNECT %dmodel% !!!
PAUSE

FOR /F %%d IN ('adb devices') DO (

IF NOT %%d==List (

 FOR /F %%m IN ('adb -s %%d shell getprop ro.product.model') DO (

  IF %%m==%dmodel% (
   ECHO SETUP %%d %%m ...
   ECHO SETTING STAY WAKE UP...
   ADB -s %%d shell settings put global stay_on_while_plugged_in 3
   ECHO INSTALLING APKs...

   FOR %%f IN (".\*.apk") DO (
    ECHO INSTALLING "%%f"
    ADB -s %%d install "%%f"
    ) || ( 
     ECHO APK INSTALLATION FAILED !!!
     PAUSE
    )
          ECHO APPLYING DEVICE SETTINGS FROM UI...
          ECHO CHANGING ORIENTATION...
          ADB -s %%d shell settings put system accelerometer_rotation 0
          ADB -s %%d shell settings put system user_rotation 1
          timeout 2
          ECHO CONFIGURING HOTSPOT...
          ADB -s %%d shell am start -n com.android.settings/.wifi.mobileap.WifiApSettings
          ADB -s %%d shell dumpsys window windows | find "com.android.settings/.wifi.mobileap.WifiApSettings" && (
          ADB -s %%d shell input tap 950 800
	     timeout 1
	     ADB -s %%d shell input keyevent --longpress  KKEYCODE_DEL KEYCODE_DEL KEYCODE_DEL KEYCODE_DEL KEYCODE_DEL KEYCODE_DEL KEYCODE_DEL KEYCODE_DEL KEYCODE_DEL KEYCODE_DEL KEYCODE_DEL KEYCODE_DEL KEYCODE_DEL KEYCODE_DEL
	     ADB -s %%d shell input keyboard text "rtkwifi"
	     ADB -s %%d shell input tap 300 500
	     timeout 1
	     ADB -s %%d shell input keyboard text "12345678"
	     ADB -s %%d shell input tap 1450 670
	     ADB -s %%d shell input keyevent KEYCODE_HOME
	     ADB -s %%d shell settings put system accelerometer_rotation 1
	     ECHO DEVICE %%d %%m CONFIGURATION SUCCESSFUL !!!
	     ) || (
               ECHO HOTSPOT ACTIVITY NOT FOUND !!! HOTSPOT SETUP FAILED !!!
               PAUSE
               )
     ) ELSE (
	ECHO DEVICE %%d IS NOT %dmodel% !!!
   )
  )
 )
) || (
     ECHO ADB SERVER ERROR !!!
     PAUSE
     GOTO setup
)
GOTO setup
cmd /k
