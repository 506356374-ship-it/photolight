plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.photolight"
    compileSdk = 34
    ndkVersion = "25.1.8937393"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.photolight"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
    release {
        isMinifyEnabled = false      // 关闭代码压缩
        isShrinkResources = false    // 关闭资源压缩
        signingConfig = signingConfigs.getByName("debug") // 用 debug 签名出 release 包，方便测试
    }
}
}

flutter {
    source = "../.."
}
