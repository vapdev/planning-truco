# Deploy Frontend Nuxt no EC2 com PM2

## 🚀 Deploy Automatizado com PM2

### Quick Start

```bash
# 1. Clone o repositório
git clone https://github.com/vapdev/planning-truco.git
cd planning-truco

# 2. Execute o script de deploy (substitua pelo IP do seu EC2)
./deploy-pm2.sh 54.123.456.789 8080
```

Pronto! Sua aplicação estará rodando em `http://SEU_IP:3000`

## 📋 Pré-requisitos no EC2

```bash
# Instalar Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar PM2 globalmente
npm install -g pm2

# Configurar PM2 para auto-start
pm2 startup
# Copie e execute o comando que aparecerá
```

## ⚙️ Configuração Manual (se necessário)

### 1. Variáveis de Ambiente

O script `deploy-pm2.sh` cria automaticamente o arquivo `.env`, mas você pode configurar manualmente:

```bash
# .env
NUXT_API_BASE=http://SEU_IP_EC2:8080
NUXT_WS_BASE=ws://SEU_IP_EC2:8080
NODE_ENV=production
HOST=0.0.0.0
PORT=3000
```

## 🔧 Comandos PM2 Úteis

### Gerenciamento Básico
```bash
# Ver status de todos os processos
pm2 status

# Ver logs em tempo real
pm2 logs planning-truco-frontend

# Ver logs das últimas 50 linhas
pm2 logs planning-truco-frontend --lines 50

# Reiniciar aplicação
pm2 restart planning-truco-frontend

# Parar aplicação
pm2 stop planning-truco-frontend

# Remover do PM2
pm2 delete planning-truco-frontend
```

### Monitoramento
```bash
# Monitor interativo (CPU, memória, etc)
pm2 monit

# Detalhes do processo específico
pm2 show planning-truco-frontend

# Informações do sistema
pm2 info planning-truco-frontend
```

### Logs e Debug
```bash
# Flush logs (limpar)
pm2 flush

# Reload (zero-downtime restart)
pm2 reload planning-truco-frontend

# Ver logs de erro
pm2 logs planning-truco-frontend --err

# Seguir logs em tempo real
pm2 logs planning-truco-frontend --follow
```

#### Opção 1: Build Estático (Recomendado)
```bash
# No seu EC2
git clone https://github.com/vapdev/planning-truco.git
cd planning-truco

# Instalar dependências
npm install

# Configurar variáveis
cp .env.example .env
# Editar .env com as URLs corretas

# Build para produção
npm run build

# Servir arquivos estáticos
npm run preview
```

#### Opção 2: Com Docker
```bash
# Dockerfile para o frontend
FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .

# Variáveis de build
ARG NUXT_API_BASE
ARG NUXT_WS_BASE
ENV NUXT_API_BASE=$NUXT_API_BASE
ENV NUXT_WS_BASE=$NUXT_WS_BASE

RUN npm run build

EXPOSE 3000
CMD ["npm", "run", "preview"]
```

```bash
# Build com variáveis
docker build \
  --build-arg NUXT_API_BASE=http://SEU_IP:8080 \
  --build-arg NUXT_WS_BASE=ws://SEU_IP:8080 \
  -t planning-truco-frontend .

# Executar
docker run -p 3000:3000 planning-truco-frontend
```

### 4. Configuração com Nginx (Recomendado para Produção)

```nginx
# /etc/nginx/sites-available/planning-truco
server {
    listen 80;
    server_name seu-dominio.com;
    
    # Frontend (arquivos estáticos)
    location / {
        root /var/www/planning-truco;
        try_files $uri $uri/ /index.html;
    }
    
    # Proxy para API backend
    location /api {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Com esta configuração, você pode usar:
```env
NUXT_API_BASE=/api
NUXT_WS_BASE=/api
```

### 5. SSL/HTTPS com Certbot

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx

# Configurar SSL
sudo certbot --nginx -d seu-dominio.com

# Auto-renovação
sudo systemctl enable certbot.timer
```

### 6. Script de Deploy Automatizado

```bash
#!/bin/bash
# deploy-frontend.sh

set -e

echo "🚀 Iniciando deploy do frontend..."

# Variáveis
EC2_IP="54.123.456.789"  # Substitua pelo seu IP
DOMAIN="seu-dominio.com"  # Ou use o IP

# Atualizar código
git pull origin main

# Configurar variáveis de ambiente
cat > .env << EOF
NUXT_API_BASE=http://$EC2_IP:8080
NUXT_WS_BASE=ws://$EC2_IP:8080
EOF

# Build
npm install
npm run build

# Copiar para diretório do Nginx (se usando)
sudo cp -r .output/public/* /var/www/planning-truco/

# Reiniciar serviços se necessário
sudo systemctl restart nginx

echo "✅ Deploy do frontend concluído!"
echo "📱 Acesse: http://$EC2_IP:3000"
```

### 7. Troubleshooting Comum

**CORS Error:**
- Configure CORS no backend Go para aceitar o domínio do frontend
- Adicione o IP/domínio do EC2 nas configurações CORS

**WebSocket não conecta:**
- Verifique se a porta 8080 está aberta no Security Group do EC2
- Teste a conexão WebSocket diretamente

**Build falha:**
- Verifique se as variáveis de ambiente estão corretas
- Certifique-se que o Node.js está na versão correta

### 8. Monitoramento

```bash
# Ver logs do processo
pm2 logs planning-truco

# Status dos serviços
sudo systemctl status nginx
docker ps  # se usando Docker
```

## 🔧 Configuração Completa de Produção

Para uma configuração completa de produção:

1. **Frontend**: Nuxt servindo arquivos estáticos via Nginx
2. **Backend**: API Go rodando na porta 8080
3. **Banco**: PostgreSQL (pode estar no mesmo EC2 ou RDS)
4. **SSL**: Certificado Let's Encrypt
5. **Domínio**: Configurado no Route53 ou provedor DNS

Desta forma, você terá uma aplicação robusta e escalável no EC2!