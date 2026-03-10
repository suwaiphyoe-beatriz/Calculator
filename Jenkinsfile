pipeline {
    agent any

    tools {
        maven 'Maven3'
    }

    environment {
        PATH = "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:${env.PATH}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo ' Checking out source code...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo '🔨 Building with Maven...'
                sh 'mvn clean compile -q'
            }
        }

        stage('Test') {
            steps {
                echo ' Running unit tests...'
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                echo ' Packaging JAR...'
                sh 'mvn package -DskipTests -q'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo ' Building Docker image...'
                sh '''
                    export PATH=/usr/local/bin:/opt/homebrew/bin:$PATH
                    docker build -t suph03/sum-product-fx:latest .
                '''
            }
        }

        stage('Start Database') {
            steps {
                echo '️ Starting MariaDB container...'
                sh '''
                    export PATH=/usr/local/bin:/opt/homebrew/bin:$PATH
                    docker rm -f calculator-db || true
                    docker compose up -d db
                    sleep 20
                '''
            }
        }

        stage('Verify Database') {
            steps {
                echo ' Verifying database and table...'
                sh '''
                    export PATH=/usr/local/bin:/opt/homebrew/bin:$PATH
                    docker exec calculator-db mariadb -u root -pswp123 calc_data -e "
                        CREATE TABLE IF NOT EXISTS calc_results (
                            id INT AUTO_INCREMENT PRIMARY KEY,
                            number1 DOUBLE NOT NULL,
                            number2 DOUBLE NOT NULL,
                            sum_result DOUBLE NOT NULL,
                            product_result DOUBLE NOT NULL,
                            subtract_result DOUBLE,
                            division_result DOUBLE,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                        );
                        INSERT INTO calc_results (number1, number2, sum_result, product_result, subtract_result, division_result)
                        VALUES (10, 5, 15, 50, 5, 2);
                        SHOW TABLES;
                        SELECT * FROM calc_results;
                    "
                '''
            }
        }
    }

    post {
        success {
            echo ' Pipeline completed successfully!'
        }
        failure {
            echo ' Pipeline failed — check the logs above.'
        }
    }
}