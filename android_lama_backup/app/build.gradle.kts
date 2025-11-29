plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.auto_reminder_aplication"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.auto_reminder_aplication"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    // 🔥 FIX WAJIB: enable Java 8 + desugaring
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib")

    // 🔥 WAJIB BANGET untuk flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
