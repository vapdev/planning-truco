#!/bin/bash

# Deploy script para Planning Truco Frontend no EC2
# Uso: ./deploy-frontend.sh [IP_DO_EC2] [PORTA_API]

set -e

EC2_IP=${1:-"localhost"}
API_PORT=${2:-"8080"}
FRONTEND_PORT=${3:-"3000"}

echo "🚀 Deploy do Frontend Planning Truco"
echo "📍 EC2 IP: $EC2_IP"
echo "🔌 API Port: $API_PORT"
echo "🌐 Frontend Port: $FRONTEND_PORT"

# Verificar se Node.js está instalado
if ! command -v node &> /dev/null; then
    echo "❌ Node.js não encontrado. Instale o Node.js primeiro."
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ NPM não encontrado. Instale o NPM primeiro."
    exit 1
fi

# Criar arquivo .env com as configurações corretas
echo "📝 Configurando variáveis de ambiente..."

cat > .env << EOF
# Configuração para EC2
NUXT_API_BASE=http://$EC2_IP:$API_PORT
NUXT_WS_BASE=ws://$EC2_IP:$API_PORT

# Google Analytics (opcional)
NUXT_GTAG_ID=
EOF

echo "✅ Arquivo .env criado com sucesso!"
echo "📋 Configurações:"
cat .env

# Instalar dependências
echo "📦 Instalando dependências..."
npm install

# Build para produção
echo "🔨 Fazendo build para produção..."
npm run build

# Verificar se o build foi bem-sucedido
if [ ! -d ".output" ]; then
    echo "❌ Build falhou! Diretório .output não foi criado."
    exit 1
fi

echo "✅ Build concluído com sucesso!"

# Opções para servir a aplicação
echo ""
echo "🎉 Deploy concluído!"
echo ""
echo "📋 Próximos passos:"
echo ""
echo "1. Para desenvolvimento/teste:"
echo "   npm run preview"
echo "   Acesse: http://$EC2_IP:$FRONTEND_PORT"
echo ""
echo "2. Para produção com PM2:"
echo "   npm install -g pm2"
echo "   pm2 start npm --name 'planning-truco' -- run preview"
echo "   pm2 save && pm2 startup"
echo ""
echo "3. Para produção com Nginx:"
echo "   sudo cp -r .output/public/* /var/www/html/"
echo "   sudo systemctl restart nginx"
echo ""
echo "🔧 Configurações utilizadas:"
echo "   API URL: http://$EC2_IP:$API_PORT"
echo "   WebSocket: ws://$EC2_IP:$API_PORT"
echo ""

# Opcional: Iniciar automaticamente se não houver argumentos
if [ "$EC2_IP" == "localhost" ]; then
    echo "🚀 Iniciando em modo desenvolvimento..."
    npm run preview
fi