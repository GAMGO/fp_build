# 1단계: 빌드 환경 설정
FROM gradle:8.5.0-jdk17 AS build 
WORKDIR /app
COPY . /app 
# 'clean' 옵션을 추가하여 빌드 환경을 깨끗하게 만듭니다.
RUN ./gradlew clean build --no-daemon -x test 

# 2단계: 실행 환경 설정
FROM openjdk:17-jre-slim
WORKDIR /app

# [핵심 수정]: JAR 파일 이름을 'fp_build'로 가정하고 명시합니다.
# 이 이름이 틀릴 경우, 이 부분만 [실제 프로젝트 이름]으로 변경해야 합니다.
COPY --from=build /app/build/libs/fp_build-0.0.1-SNAPSHOT.jar app.jar 

EXPOSE 8080 
ENV PORT 8080

CMD ["java", "-jar", "app.jar"]