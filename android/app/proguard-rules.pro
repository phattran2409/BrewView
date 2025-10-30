# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Geolocator - Prevent location services from being obfuscated
-keep class com.baseflow.geolocator.** { *; }
-keepclassmembers class com.baseflow.geolocator.** { *; }
-dontwarn com.baseflow.geolocator.**

# Google Play Services - Location
-keep class com.google.android.gms.location.** { *; }
-keepclassmembers class com.google.android.gms.location.** { *; }
-dontwarn com.google.android.gms.location.**

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**

# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }

# Image Picker
-keep class io.flutter.plugins.imagepicker.** { *; }

# Prevent issues with location listeners and NMEA
-keep class android.location.** { *; }
-keepclassmembers class android.location.** { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

