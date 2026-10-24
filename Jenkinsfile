// Jenkins Declarative Pipeline 구문을 시작
pipeline {
    // 파이프라인을 실행할 노드(에이전트)를 지정 ('any'는 사용 가능한 아무 에이전트에서나 실행)
    agent any

    // 여러 파이프라인 단계를 정의하는 그룹 블록
    stages {

        // 1단계: GitHub에서 소스 코드를 가져오는 단계
        stage('Git Clone') {
            steps {
                // 지정한 Git 레포지토리의 main 브랜치 코드를 체크아웃(다운로드)
                git branch: 'main', url: 'https://github.com/깃허브ID/react-repo.git'
            }
        }

        // 2단계: 도커 이미지를 빌드하고 컨테이너로 실행하는 단계
        stage('Docker Build & Run') {
            steps {
                // 기존에 'react-app'으로 실행 중인 컨테이너를 중지. (없어도 에러로 중단되지 않게 || true 처리)
                sh 'docker stop react-app || true'

                // 기존 'react-app' 컨테이너를 삭제 (중복 이름 충돌 방지)
                sh 'docker rm react-app || true'

                // 현재 디렉터리의 Dockerfile을 기반으로 'react-app'이라는 이름의 도커 이미지를 빌드
                sh 'docker build -t react-app .'

                // 컨테이너를 백그라운드(-d)에서 실행하며, 호스트의 80번 포트와 컨테이너 Nginx의 80번 포트를 연결
                sh 'docker run -d -p 80:80 --name react-app react-app'
            }
        }
    }

    // 파이프라인 실행 완료 후 결과에 따라 동작하는 후속 처리 블록
    post {
        // 모든 단계가 성공적으로 완료되었을 때 실행
        success {
            echo 'CI/CD 파이프라인이 성공적으로 완료되었습니다.'
        }
        // 단계 중 하나라도 실패했을 때 실행
        failure {
            echo '파이프라인 실행 중 오류가 발생했습니다.'
        }
    }
}