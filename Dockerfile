# ----------------------------------------------------
# 1단계: 빌드 스테이지 (Node.js 환경)
# ----------------------------------------------------
# Node.js v22 경량화(Alpine) 버전을 기반 이미지로 사용하고, 이 단계를 'builder'로 명명
FROM node:22-alpine AS builder

# 컨테이너 내부의 작업 디렉터리를 /app으로 설정. (이후 명령어는 이 위치에서 실행됨)
WORKDIR /app

# 패키지 의존성 정의 파일(package.json, package-lock.json 등)을 컨테이너 내부로 복사
COPY package*.json ./

# npm을 사용하여 프로젝트에 필요한 라이브러리 및 의존성을 설치
RUN npm install

# 프로젝트의 모든 소스 코드 파일을 컨테이너 내부의 /app 디렉터리로 복사
COPY . .

# 작성된 소스 코드를 프로덕션용 정적 파일로 빌드 (Vite의 경우 기본 /app/dist 생성)
RUN npm run build


# ----------------------------------------------------
# 2단계: 실행 스테이지 (Nginx 환경)
# ----------------------------------------------------
# 정적 웹 파일 서비스에 최적화된 Nginx 경량화(Alpine) 이미지를 불러온다.
FROM nginx:stable-alpine

# 이전 'builder' 단계에서 빌드된 정적 파일(/app/dist)을 Nginx의 기본 웹 루트 경로로 복사
COPY --from=builder /app/dist /usr/share/nginx/html

# 프로젝트 내의 사용자 지정 Nginx 설정 파일(nginx.conf)을 컨테이너 설정 경로로 덮어쓴다
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 컨테이너가 80번 포트를 사용함을 명시 (문서화 용도)
EXPOSE 80

# Nginx를 데몬(백그라운드)이 아닌 포그라운드 모드로 실행하여 컨테이너가 종료되지 않고 계속 유지되도록 한다
CMD ["nginx", "-g", "daemon off;"]