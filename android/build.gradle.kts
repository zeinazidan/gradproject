//allprojects {
//    repositories {
//        google()
//        mavenCentral()
//    }
//}
//
//val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
//rootProject.layout.buildDirectory.value(newBuildDir)
//
//subprojects {
//    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
//    project.layout.buildDirectory.value(newSubprojectBuildDir)
//}
//subprojects {
//    project.evaluationDependsOn(":app")
//}
//
//tasks.register<Delete>("clean") {
//    delete(rootProject.layout.buildDirectory)
//}
// Top-level build file for Flutter + Firebase using Kotlin DSL

import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

// Repositories for all subprojects
allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // Optional: Kotlin compile target (if you use Kotlin)
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        kotlinOptions.jvmTarget = "1.8"
    }

    // Optional: Java compile target
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
}

// Custom build output directory setup (optional, for unified build folder)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Optional: if some subprojects rely on ":app" being evaluated first
subprojects {
    project.evaluationDependsOn(":app")
}

// Clean task for deleting build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
