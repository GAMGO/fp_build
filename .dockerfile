# 1단계: 빌드 환경 설정
FROM gradle:8.5.0-jdk17 AS build 
WORKDIR /app
COPY . /app 
# 빌드 실행
RUN ./gradlew clean build --no-daemon -x test # 'clean' 옵션 추가

# 2단계: 실행 환경 설정
FROM openjdk:17-jre-slim
WORKDIR /app

# [핵심 수정]: 고객님의 프로젝트 이름과 버전(0.0.1-SNAPSHOT)을 명시적으로 사용합니다.
# JAR 파일 이름은 '프로젝트명-버전.jar' 형태입니다.
# [YOUR_PROJECT_NAME] 부분을 고객님의 프로젝트 이름으로 변경하세요.
# 예시: finalProject-0.0.1-SNAPSHOT.jar 
COPY --from=build /app/build/libs/[YOUR_PROJECT_NAME]-0.0.1-SNAPSHOT.jar app.jar 

EXPOSE 8080 
ENV PORT 8080

CMD ["java", "-jar", "app.jar"]