pipeline {
    agent any
    stages {
        stage('Git Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/hwanyhee1209/react-repo.git'
            }
        }
        stage('Docker Build & Run') {
            steps {
                sh 'docker stop react-app || true'
                sh 'docker rm react-app || true'
                sh 'docker build -t react-app .'
                sh 'docker run -d -p 80:80 --name react-app react-app'
            }
        }
    }
    post {
        success {
            echo 'CI/CD 파이프라인이 성공적으로 완료되었습니다.'
        }
        failure {
            echo '파이프라인 실행 중 오류가 발생했습니다.'
        }
    }
}