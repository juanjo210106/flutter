allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

buildscript {
    repositories {
        // Estos repositorios son necesarios para descargar el plugin de Google Services
        google()
        mavenCentral()
    }
    dependencies {
        // Asegúrate de usar paréntesis y comillas dobles para Kotlin DSL
        classpath("com.google.gms:google-services:4.3.15")
    }
}