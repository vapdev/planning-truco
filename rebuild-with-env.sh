#!/bin/bash#!/bin/bash



# Script para rebuild com novas variáveis de ambiente

# Uso: ./rebuild-with-env.sh [IP_DO_EC2] [PORTA_API] [DOMAIN_OPCIONAL]

# Script para rebuild com novas variáveis de ambiente# Script para rebuild com novas variáveis de ambiente

set -e

# Uso: ./rebuild-with-env.sh [IP_DO_EC2] [PORTA_API] [DOMAIN_OPCIONAL]# Uso: ./rebuild-with-envecho ""

EC2_IP=${1}

API_PORT=${2:-"8080"}echo "✅ Rebuild concluído!"

DOMAIN=${3}

set -eecho "🌐 Aplicação rodando em: http://$EC2_IP:3000"

if [ -z "$EC2_IP" ]; then

    echo "❌ Erro: IP do EC2 é obrigatório"echo "🔗 API configurada para: $API_BASE"

    echo "Uso: ./rebuild-with-env.sh [IP_DO_EC2] [PORTA_API] [DOMAIN_OPCIONAL]"

    echo "Exemplo: ./rebuild-with-env.sh 54.123.456.789 8080"EC2_IP=${1}echo ""IP_DO_EC2] [PORTA_API] [DOMAIN_OPCIONAL]

    echo "Exemplo com domínio: ./rebuild-with-env.sh 54.123.456.789 8080 planningpoker.digital"

    exit 1API_PORT=${2:-"8080"}

fi

DOMAIN=${3}  # Novo parâmetro opcionalset -e

echo "🔄 Rebuild com novas variáveis de ambiente"

echo "📍 EC2 IP: $EC2_IP"

echo "🔌 API Port: $API_PORT"

if [ -n "$DOMAIN" ]; thenif [ -z "$EC2_IP" ]; thenEC2_IP=${1}

    echo "🌐 Domain: $DOMAIN"

fi    echo "❌ Erro: IP do EC2 é obrigatório"API_PORT=${2:-"8080"}



# Parar PM2    echo "Uso: ./rebuild-with-env.sh [IP_DO_EC2] [PORTA_API] [DOMAIN_OPCIONAL]"DOMAIN=${3}  # Novo parâmetro opcional

echo "🛑 Parando PM2 e liberando porta 3000..."

pm2 stop planning-truco-frontend 2>/dev/null || echo "App não estava rodando no PM2"    echo "Exemplo: ./rebuild-with-env.sh 54.123.456.789 8080"

pm2 delete planning-truco-frontend 2>/dev/null || echo "App removido do PM2"

    echo "Exemplo com domínio: ./rebuild-with-env.sh 54.123.456.789 8080 planningpoker.digital"if [ -z "$EC2_IP" ]; then

# Matar qualquer processo na porta 3000

echo "💀 Liberando porta 3000..."    exit 1    echo "❌ Erro: IP do EC2 é obrigatório"

PIDS=$(lsof -ti :3000 2>/dev/null || echo "")

if [ -n "$PIDS" ]; thenfi    echo "Uso: ./rebuild-with-env.sh [IP_DO_EC2] [PORTA_API] [DOMAIN_OPCIONAL]"

    echo "Matando processos na porta 3000: $PIDS"

    kill -9 $PIDS 2>/dev/null || echo "Alguns processos já estavam mortos"    echo "Exemplo: ./rebuild-with-env.sh 54.123.456.789 8080"

fi

echo "🔄 Rebuild com novas variáveis de ambiente"    echo "Exemplo com domínio: ./rebuild-with-env.sh 54.123.456.789 8080 meudominio.com"

# Configurar variáveis de ambiente para BUILD TIME

echo "📝 Configurando variáveis de ambiente para build..."echo "📍 EC2 IP: $EC2_IP"    exit 1



# Usar domínio se fornecido, senão usar IPecho "🔌 API Port: $API_PORT"fi

if [ -n "$DOMAIN" ]; then

    API_BASE="http://$DOMAIN:$API_PORT"if [ -n "$DOMAIN" ]; then

    WS_BASE="ws://$DOMAIN:$API_PORT"

    echo "🌐 Usando domínio para API: $DOMAIN"    echo "🌐 Domain: $DOMAIN"echo "🔄 Rebuild com novas variáveis de ambiente"

else

    API_BASE="http://$EC2_IP:$API_PORT"fiecho "📍 EC2 IP: $EC2_IP"

    WS_BASE="ws://$EC2_IP:$API_PORT"

    echo "📍 Usando IP para API: $EC2_IP"echo "🔌 API Port: $API_PORT"

fi

# Parar PM2if [ -n "$DOMAIN" ]; then

export NUXT_API_BASE=$API_BASE

export NUXT_WS_BASE=$WS_BASEecho "🛑 Parando PM2 e liberando porta 3000..."    echo "🌐 Domain: $DOMAIN"



# Criar arquivo .envpm2 stop planning-truco-frontend 2>/dev/null || echo "App não estava rodando no PM2"fi

cat > .env << EOF

NUXT_API_BASE=$API_BASEpm2 delete planning-truco-frontend 2>/dev/null || echo "App removido do PM2"

NUXT_WS_BASE=$WS_BASE

NODE_ENV=production# Parar PM2

HOST=0.0.0.0

PORT=3000# Matar qualquer processo na porta 3000echo "🛑 Parando PM2 e liberando porta 3000..."

EOF

echo "💀 Liberando porta 3000..."pm2 stop planning-truco-frontend 2>/dev/null || echo "App não estava rodando no PM2"

echo "✅ Arquivo .env atualizado:"

cat .envPIDS=$(lsof -ti :3000 2>/dev/null || echo "")pm2 delete planning-truco-frontend 2>/dev/null || echo "App removido do PM2"



# Limpar build anteriorif [ -n "$PIDS" ]; then

echo "🧹 Limpando build anterior..."

rm -rf .output .nuxt    echo "Matando processos na porta 3000: $PIDS"# Matar qualquer processo na porta 3000



# Rebuild com as novas variáveis    kill -9 $PIDS 2>/dev/null || echo "Alguns processos já estavam mortos"echo "💀 Liberando porta 3000..."

echo "🔨 Fazendo rebuild com novas variáveis..."

npm run buildfiPIDS=$(lsof -ti :3000 2>/dev/null || echo "")



# Verificar se build foi bem-sucedidoif [ -n "$PIDS" ]; then

if [ ! -d ".output" ]; then

    echo "❌ Build falhou!"# Configurar variáveis de ambiente para BUILD TIME    echo "Matando processos na porta 3000: $PIDS"

    exit 1

fiecho "📝 Configurando variáveis de ambiente para build..."    kill -9 $PIDS 2>/dev/null || echo "Alguns processos já estavam mortos"



# Reiniciar com PM2fi

echo "🚀 Reiniciando com PM2..."

pm2 start npm --name "planning-truco-frontend" -- run preview# Usar domínio se fornecido, senão usar IP



# Salvar configuraçãoif [ -n "$DOMAIN" ]; then# Configurar variáveis de ambiente para BUILD TIME

pm2 save

    API_BASE="http://$DOMAIN:$API_PORT"echo "📝 Configurando variáveis de ambiente para build..."

echo "📊 Status:"

pm2 status planning-truco-frontend    WS_BASE="ws://$DOMAIN:$API_PORT"



echo ""    echo "🌐 Usando domínio para API: $DOMAIN"# Usar domínio se fornecido, senão usar IP

echo "✅ Rebuild concluído!"

echo "🌐 Aplicação rodando em: http://$EC2_IP:3000"elseif [ -n "$DOMAIN" ]; then

echo "🔗 API configurada para: $API_BASE"

echo ""    API_BASE="http://$EC2_IP:$API_PORT"    API_BASE="http://$DOMAIN:$API_PORT"

echo "🧪 Teste no navegador para confirmar que as URLs estão corretas!"

echo ""    WS_BASE="ws://$EC2_IP:$API_PORT"    WS_BASE="ws://$DOMAIN:$API_PORT"

    echo "📍 Usando IP para API: $EC2_IP"    echo "🌐 Usando domínio para API: $DOMAIN"

fielse

    API_BASE="http://$EC2_IP:$API_PORT"

export NUXT_API_BASE=$API_BASE    WS_BASE="ws://$EC2_IP:$API_PORT"

export NUXT_WS_BASE=$WS_BASE    echo "📍 Usando IP para API: $EC2_IP"

fi

# Criar arquivo .env

cat > .env << EOFexport NUXT_API_BASE=$API_BASE

NUXT_API_BASE=$API_BASEexport NUXT_WS_BASE=$WS_BASE

NUXT_WS_BASE=$WS_BASE

NODE_ENV=production# Criar arquivo .env

HOST=0.0.0.0cat > .env << EOF

PORT=3000NUXT_API_BASE=$API_BASE

EOFNUXT_WS_BASE=$WS_BASE

NODE_ENV=production

echo "✅ Arquivo .env atualizado:"HOST=0.0.0.0

cat .envPORT=3000

EOF

# Limpar build anterior

echo "🧹 Limpando build anterior..."echo "✅ Arquivo .env atualizado:"

rm -rf .output .nuxtcat .env



# Rebuild com as novas variáveis# Limpar build anterior

echo "🔨 Fazendo rebuild com novas variáveis..."echo "🧹 Limpando build anterior..."

npm run buildrm -rf .output .nuxt



# Verificar se build foi bem-sucedido# Rebuild com as novas variáveis

if [ ! -d ".output" ]; thenecho "🔨 Fazendo rebuild com novas variáveis..."

    echo "❌ Build falhou!"npm run build

    exit 1

fi# Verificar se build foi bem-sucedido

if [ ! -d ".output" ]; then

# Reiniciar com PM2    echo "❌ Build falhou!"

echo "🚀 Reiniciando com PM2..."    exit 1

pm2 start npm --name "planning-truco-frontend" -- run previewfi



# Salvar configuração# Reiniciar com PM2

pm2 saveecho "🚀 Reiniciando com PM2..."

pm2 start npm --name "planning-truco-frontend" -- run preview

echo "📊 Status:"

pm2 status planning-truco-frontend# Salvar configuração

pm2 save

echo ""

echo "✅ Rebuild concluído!"echo "📊 Status:"

echo "🌐 Aplicação rodando em: http://$EC2_IP:3000"pm2 status planning-truco-frontend

echo "🔗 API configurada para: $API_BASE"

echo ""echo ""

echo "🧪 Teste no navegador para confirmar que as URLs estão corretas!"echo "✅ Rebuild concluído!"

echo ""echo "🌐 Aplicação rodando em: http://$EC2_IP:3000"

echo "💡 Para usar com o domínio planningpoker.digital:"echo "🔗 API configurada para: http://$EC2_IP:$API_PORT"

echo "   ./rebuild-with-env.sh $EC2_IP $API_PORT planningpoker.digital"echo ""

echo ""echo "🧪 Teste no navegador para confirmar que as URLs estão corretas!"
echo ""