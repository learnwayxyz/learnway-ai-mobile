# Flutter Wrapper - Keep everything
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep interface io.flutter.plugin.** { *; }
-keep interface io.flutter.embedding.** { *; }

# Prevent stripping of Flutter engine
-keep class io.flutter.embedding.engine.FlutterEngine { *; }
-keep class io.flutter.embedding.engine.FlutterJNI { *; }
-keep class io.flutter.embedding.engine.dart.DartExecutor { *; }

# Firebase Core
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
-keepattributes *Annotation*

# Firebase Messaging
-keep class com.google.firebase.messaging.** { *; }
-keep class com.google.firebase.iid.** { *; }
-keep class io.flutter.plugins.firebase.messaging.** { *; }
-dontwarn com.google.firebase.messaging.**
-dontwarn com.google.firebase.iid.**

# Firebase Auth
-keep class com.google.firebase.auth.** { *; }
-dontwarn com.google.firebase.auth.**

# Firebase Firestore
-keep class com.google.firebase.firestore.** { *; }
-dontwarn com.google.firebase.firestore.**

# Firebase Installations
-keep class com.google.firebase.installations.** { *; }
-dontwarn com.google.firebase.installations.**

# Firebase Components
-keep class com.google.firebase.components.** { *; }
-dontwarn com.google.firebase.components.**

# Play Services
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.tasks.** { *; }
-keep class com.google.android.gms.internal.** { *; }

# Protobuf (used by Firebase)
-keep class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**

# Keep all Firebase plugin classes
-keep class io.flutter.plugins.firebase.** { *; }
-keep class io.flutter.embedding.engine.** { *; }

# Keep Firebase initialization
-keep class com.google.firebase.FirebaseApp { *; }
-keep class com.google.firebase.FirebaseOptions { *; }
-keep class com.google.firebase.provider.FirebaseInitProvider { *; }

# Keep method channels for Flutter plugins
-keep class io.flutter.plugin.common.** { *; }
-keep class io.flutter.embedding.android.** { *; }

# Google Play Core (for deferred components)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep all Flutter embedding classes
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Keep all model classes and data classes
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Prevent stripping of native methods
-keepclasseswithmembers class * {
    native <methods>;
}

# Keep BuildConfig
-keep class **.BuildConfig { *; }

# Keep R class
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Keep all classes with @Keep annotation
-keep @androidx.annotation.Keep class * { *; }
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Keep all classes that are used via reflection
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Don't optimize or obfuscate any package that contains "learnway"
-keep class xyz.learnway.** { *; }
-keepclassmembers class xyz.learnway.** { *; }

# Keep all native libraries
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep crashlytics and analytics
-keepattributes SourceFile,LineNumberTable

# Local Notifications
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**

# Gson (used by Firebase)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep generic signature of Call, Response (R8 full mode strips signatures from non-kept items).
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response

# With R8 full mode generic signatures are stripped for classes that are not
# kept. Suspend functions are wrapped in continuations where the type argument
# is used.
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation

# Keep data classes
-keep class xyz.learnway.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep setters in Views so that animations can still work.
-keepclassmembers public class * extends android.view.View {
    void set*(***);
    *** get*();
}

# Keep Activity classes
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

# For enumeration classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Parcelable
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ========== ironSource LevelPlay SDK ==========
# Keep ironSource SDK classes
-keep class com.ironsource.** { *; }
-dontwarn com.ironsource.**

# Keep ironSource adapters
-keep class com.ironsource.adapters.** { *; }
-dontwarn com.ironsource.adapters.**

# Keep ironSource mediationsdk
-keep class com.ironsource.mediationsdk.** { *; }
-dontwarn com.ironsource.mediationsdk.**

# Keep ironSource environment
-keep class com.ironsource.environment.** { *; }
-dontwarn com.ironsource.environment.**

# Keep ad network SDKs (ironSource)
-keep class com.ironsrc.** { *; }
-dontwarn com.ironsrc.**

# Keep Google Mobile Ads (AdMob) - used as mediation partner
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Keep all native methods for ironSource
-keepclasseswithmembernames class com.ironsource.** {
    native <methods>;
}

# Keep all Flutter plugin classes for ironSource
-keep class com.ironSource.ironsource_mediation.** { *; }
-dontwarn com.ironSource.ironsource_mediation.**

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable

# Keep all ad network adapter classes
-keep class * extends com.ironsource.mediationsdk.AbstractAdapter { *; }
-keep class * implements com.ironsource.mediationsdk.sdk.** { *; }
