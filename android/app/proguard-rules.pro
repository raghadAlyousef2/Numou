# JNA references desktop-only AWT/Swing APIs that don't exist on Android.
-dontwarn java.awt.**
-dontwarn javax.swing.**
-dontwarn sun.awt.**

# Keep JNA classes so R8 doesn't strip needed JNI mappings
-keep class com.sun.jna.** { *; }
-keep class com.sun.jna.platform.** { *; }
