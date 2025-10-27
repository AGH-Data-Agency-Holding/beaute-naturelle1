plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.beaute_naturelle"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.beaute_naturelle"
        minSdk = flutter.minSdkVersion // ou flutter.minSdkVersion si tu importes flutter ici
        targetSdk = 36
        versionCode = 1
        versionName = "1.0.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Google Sign-In
    implementation("com.google.android.gms:play-services-auth:21.2.0")

    // Navigateur AndroidX requis pour Sign In with Apple
    implementation("androidx.browser:browser:1.4.0")
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
