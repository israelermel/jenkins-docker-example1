node {
    //Utilizing a try block so as to make the code cleaner and send slack notification in case of any error
    try {                
        // Global variable declaration
        def project = 'israel/android-teste'
        def appName = 'Sample App'

        // Stage, is to tell the Jenkins that this is the new process/step that needs to be executed
        stage('Checkout') {
            // Pull the code from the repo
            checkout scm
        }

        stage('Build Image') {
            // Build our docker Image
            sh("sudo docker build -t ${project} .")
        }

        stage('Deploy application') {
            // This is the cool part where you deploy. Here, you can specify builds you want to deploy
            switch (env.BRANCH_NAME) {
                case "master":
                    sh("env >> .env")
                    sh("sudo docker run --env-file .env --rm ${project} ./gradlew clean build assembleDebug")                    
                    sh("rm -rf .env")
                    break                
            }
        }
    } catch (e) {        
        throw e      
    }
}