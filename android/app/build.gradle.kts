plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load AdMob App ID from admob.properties
val admobPropertiesFile = rootProject.file("admob.properties")
val admobAppId = if (admobPropertiesFile.exists()) {
    admobPropertiesFile.readLines()
        .find { it.startsWith("android_app_id=") }
        ?.substringAfter("=")
        ?: "ca-app-pub-3940256099942544~3347511713"
} else {
    // test id
    "ca-app-pub-3940256099942544~3347511713"
}

android {
    namespace = "com.incpahl.h2osync"
    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.incpahl.h2osync"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        
        // Inject AdMob App ID into manifest
        manifestPlaceholders["admobAppId"] = admobAppId
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
