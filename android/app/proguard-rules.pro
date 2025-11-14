# Keep okhttp API classes used directly
-keep class okhttp3.** { *; }

# Suppress warnings / missing optional security provider classes referenced by okhttp
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
-dontwarn okhttp3.internal.platform.**
-dontwarn okhttp3.**
-dontwarn okio.**