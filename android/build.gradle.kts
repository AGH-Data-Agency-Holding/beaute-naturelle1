// Fichier : android/build.gradle.kts

plugins {
    // plugins globaux si nécessaire
}

allprojects {
    repositories {
        google()          // pour les bibliothèques Google
        mavenCentral()    // ✅ nécessaire pour télécharger le SDK Facebook
    }
}

// Réorganisation des répertoires de build
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// Tâche clean
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}