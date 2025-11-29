plugins {
    id("com.android.application") version "8.1.2"
    id("org.jetbrains.kotlin.android") version "1.9.0"
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

    buildTypes {
        release {
            isMinifyEnabled = false
        }
    }
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.0")
}
