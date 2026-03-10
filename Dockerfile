# Use a known-good OpenJDK base image
FROM eclipse-temurin:21-jdk

# Mac GUI forwarding via XQuartz
ENV DISPLAY=host.docker.internal:0.0
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV JAVA_TOOL_OPTIONS="-Djava.awt.headless=false"

# Install dependencies
RUN apt-get update && \
    apt-get install -y maven wget unzip \
    libgtk-3-0 libgbm1 libx11-6 \
    libgl1-mesa-dri \
    xauth x11-apps && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Download JavaFX SDK 21 for  (aarch64)
RUN wget https://download2.gluonhq.com/openjfx/21/openjfx-21_linux-aarch64_bin-sdk.zip \
        -O /tmp/openjfx.zip && \
    unzip /tmp/openjfx.zip -d /opt && \
    rm /tmp/openjfx.zip

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

RUN ls -l target

CMD ["java", \
     "--module-path", "/opt/javafx-sdk-21/lib", \
     "--add-modules", "javafx.controls,javafx.fxml", \
     "-Djava.library.path=/opt/javafx-sdk-21/lib", \
     "-Dprism.order=sw", \
     "-Dprism.verbose=true", \
     "-Djava.awt.headless=false", \
     "-jar", "target/sum-product_fx-1.0-SNAPSHOT.jar"]