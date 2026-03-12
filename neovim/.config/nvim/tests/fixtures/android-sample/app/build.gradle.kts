plugins {
  id("com.android.application")
  kotlin("android")
}

android {
  namespace = "com.example"
  compileSdk = 34

  defaultConfig {
    applicationId = "com.example"
    minSdk = 24
    targetSdk = 34
    versionCode = 1
    versionName = "1.0"
  }
}
