# Dockerfile
# Use uma imagem base com Node.js
FROM node:16-bullseye

# Instalar dependências essenciais
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk wget unzip && \
    apt-get clean;

# Configurar variáveis de ambiente para o Android SDK
ENV ANDROID_SDK_ROOT /usr/local/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools

# Baixar e instalar o Android SDK Command Line Tools
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O android-commandlinetools.zip && \
    unzip android-commandlinetools.zip -d $ANDROID_SDK_ROOT/cmdline-tools && \
    mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest && \
    rm android-commandlinetools.zip

# Aceitar licenças e instalar ferramentas necessárias
RUN yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses && \
    $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-31" "build-tools;31.0.0"

# Instalar o React Native CLI
RUN npm install -g react-native-cli

# Criar um diretório para o projeto
WORKDIR /app

# Copiar arquivos package.json e package-lock.json
COPY package*.json ./

# Instalar dependências
RUN npm install

# Copiar o código do projeto
COPY . .

# Expor a porta
EXPOSE 8081

# Comando padrão ao iniciar o container
CMD ["npm", "start"]
