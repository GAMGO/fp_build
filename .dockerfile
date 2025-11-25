# 1단계: 빌드 환경 설정 (Gradle/JDK 17 사용)
FROM gradle:8.5.0-jdk17 AS build
WORKDIR /app
# 모든 프로젝트 파일 복사
COPY . /app 

# Gradle 빌드 실행 (테스트 건너뛰기)
# --no-daemon : 빌드 속도 향상.
RUN ./gradlew build --no-daemon -x test

# 2단계: 실행 환경 설정 (경량화된 JRE 17 사용)
FROM openjdk:17-jre-slim
WORKDIR /app

# [핵심 수정]: build/libs 폴더에서 JAR 파일을 app.jar로 복사
# *.jar 대신 build.gradle의 version (0.0.1-SNAPSHOT)과 프로젝트 이름에 맞게 정확히 지정하거나 와일드카드를 사용합니다.
COPY --from=build /app/build/libs/*.jar app.jar

# Render의 포트 지정 (Spring Boot 기본 포트 8080)
EXPOSE 8080 
ENV PORT 8080

# 서버 실행 명령어 (단일 JAR 파일 실행)
CMD ["java", "-jar", "app.jar"]