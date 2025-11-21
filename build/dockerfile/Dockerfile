# 使用官方 OpenJDK 17 镜像作为基础镜像
FROM eclipse-temurin:17-jdk-jammy

# 定义模块名称和端口，可在 build 时传入
ARG MODULE_NAME
ARG PORT

# 设置工作目录
WORKDIR /app

# 复制 Jar 文件
COPY ${MODULE_NAME}/target/${MODULE_NAME}-1.0-SNAPSHOT.jar app.jar

# 暴露端口
EXPOSE ${PORT}

# 运行 Spring Boot 应用
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.config.location=/app/config/application.yaml"]


# 示例
# docker build \
#   -t mall-auth:latest \
#   --build-arg MODULE_NAME=mall-auth \
#   --build-arg PORT=8401 \
#   -f build/dockerfile/Dockerfile .
