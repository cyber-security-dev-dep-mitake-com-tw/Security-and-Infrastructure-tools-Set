# 安全與基礎設施工具集 | Security & Infrastructure Tools Set

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Docker](https://img.shields.io/badge/Docker-20.10+-blue.svg)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2.0+-blue.svg)

**一個基於 Docker 的開源安全掃描與基礎設施管理平台**

[English Documentation](./README_EN.md) | [架構設計](./ARCHITECTURE.md) | [工具參考](./TOOLS.md)

</div>

---

## 📋 目錄

- [專案簡介](#專案簡介)
- [核心特色](#核心特色)
- [快速開始](#快速開始)
- [系統架構](#系統架構)
- [前置需求](#前置需求)
- [安裝與配置](#安裝與配置)
- [使用指南](#使用指南)
- [整合工具](#整合工具)
- [最佳實踐](#最佳實踐)
- [故障排除](#故障排除)
- [開發指南](#開發指南)
- [常見問題](#常見問題)
- [貢獻](#貢獻)
- [授權](#授權)

---

## 專案簡介

**Security & Infrastructure Tools Set** 是一個完整的容器化安全掃描平台，整合業界領先的開源安全工具，提供統一的部署、管理和查詢介面。本專案遵循 Docker 最佳實踐，採用微服務架構，適合個人學習、團隊使用和生產環境部署。

### 解決什麼問題？

- ✅ **環境一致性**: 消除"在我機器上可以運行"的問題
- ✅ **快速部署**: 一行命令啟動完整安全掃描平台
- ✅ **工具整合**: 統一管理多個安全掃描工具
- ✅ **結果聚合**: 中央資料庫集中儲存和查詢掃描結果
- ✅ **可擴展性**: 輕鬆添加新的掃描工具或服務
- ✅ **最佳實踐**: 內建安全配置、健康檢查、資源限制

### 適用場景

| 場景 | 說明 |
|------|------|
| 🎓 **安全學習** | 體驗業界標準工具，理解安全掃描流程 |
| 👨‍💻 **個人使用** | 快速建立本地安全測試環境 |
| 👥 **團隊協作** | 統一的掃描平台，結果共享和追蹤 |
| 🏢 **企業部署** | 可擴展至生產環境的安全掃描基礎設施 |
| 🔬 **安全研究** | 快速驗證漏洞、測試 POC |

---

## 核心特色

### 🎯 技術特色

- **🐳 容器化優先**: 所有服務運行在 Docker 容器中，一鍵部署
- **🔧 微服務架構**: 每個工具獨立運行，互不干擾
- **💾 中央化儲存**: PostgreSQL 統一管理掃描結果和元數據
- **🔐 密鑰管理**: HashiCorp Vault 集中管理敏感資料
- **🌐 反向代理**: Traefik 自動 HTTPS 和服務發現
- **📊 GitOps 支援**: ArgoCD 實現聲明式部署
- **🏥 健康檢查**: 自動監測服務狀態，依賴管理
- **📈 可觀測性**: 完整的日誌和指標收集準備

### 🛡️ 安全特色

- **多層防禦**: 網路隔離、身份認證、最小權限
- **密鑰輪換**: 支援自動化密鑰生命週期管理
- **審計日誌**: 完整記錄所有操作和存取
- **資源限制**: 防止資源耗盡攻擊
- **安全更新**: 使用固定版本標籤，可控更新

### 🚀 整合工具

| 類別 | 工具 | 狀態 |
|------|------|------|
| 漏洞掃描 | Nuclei | ✅ 已整合 |
| 網路掃描 | Nmap | ✅ 已整合 |
| 資產發現 | AMASS | ✅ 已整合 |
| 資料庫 | PostgreSQL | ✅ 已整合 |
| 密鑰管理 | Vault | ✅ 已整合 |
| 反向代理 | Traefik | ✅ 已整合 |
| CI/CD | ArgoCD | ✅ 已整合 |
| 編排 | SecureCodeBox | ✅ 已整合 |

更多可選工具請參考 [TOOLS.md](./TOOLS.md)

---

## 快速開始

### ⚡ 3 分鐘快速部署

```bash
# 1. 克隆專案
git clone https://github.com/your-username/Security-and-Infrastructure-tools-Set.git
cd Security-and-Infrastructure-tools-Set

# 2. 配置環境變數（可選，使用預設值可跳過）
cp .env.template .env
# 編輯 .env 修改資料庫密碼等敏感資訊

# 3. 啟動所有服務
make up

# 4. 檢查服務狀態
make health

# 5. 執行第一次掃描
make scan-nuclei TARGET=https://example.com
```

### 🎉 成功！

訪問以下服務：
- **Traefik Dashboard**: <http://localhost:8080>
- **Vault UI**: <http://localhost:8200>
- **ArgoCD UI**: <http://localhost:8081>
- **Web UI**: <http://localhost:8082>

---

## 系統架構

### 架構圖

```
┌─────────────────────────────────────────────────────────────────┐
│                         外部使用者                                │
│                  (開發者、安全團隊、自動化系統)                    │
└────────────────────────────┬────────────────────────────────────┘
                             │
                    ┌────────▼────────┐
                    │    Traefik      │ ◄── 🌐 反向代理 & SSL 終止
                    │  (Port 80/443)  │     負載均衡、自動服務發現
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
   ┌────▼─────┐      ┌──────▼──────┐      ┌─────▼──────┐
   │  Vault   │      │   ArgoCD    │      │  Web UI    │
   │  :8200   │      │   :8081     │      │  :8082     │
   └────┬─────┘      └──────┬──────┘      └─────┬──────┘
        │ 🔐 密鑰管理        │ 🚀 GitOps         │ 📊 查詢介面
        │                   │                    │
        └───────────────────┼────────────────────┘
                            │
                    ┌───────▼────────┐
                    │   PostgreSQL   │ ◄── 💾 中央資料庫
                    │     :5432      │     掃描結果、元數據
                    └───────┬────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
   ┌────▼─────┐      ┌─────▼──────┐      ┌────▼──────┐
   │ Scanner  │      │  Operator  │      │  Parsers  │
   │ Nuclei   │      │ SecCodeBox │      │ N/A/N     │
   │ Nmap     │      │            │      │           │
   │ AMASS    │      │ 🔧 編排引擎  │      │ 📋 解析器  │
   └──────────┘      └────────────┘      └───────────┘
        │                   │                   │
        └───────────────────┼───────────────────┘
                            │
                    ┌───────▼────────┐
                    │  Scan Results  │ ◄── 📁 共享儲存卷
                    │    Volume      │     掃描輸出檔案
                    └────────────────┘
```

### 資料流程

```
使用者觸發掃描
    │
    ├─► 1. Makefile 命令執行
    │       make scan-nuclei TARGET=example.com
    │
    ├─► 2. Docker Compose 啟動掃描容器
    │       docker-compose run --rm scanner-nuclei
    │
    ├─► 3. Scanner 執行掃描
    │       ├─► 從 Vault 讀取配置和憑證
    │       ├─► 執行 Nuclei 掃描目標
    │       └─► 輸出結果到 /results/nuclei-{timestamp}.json
    │
    ├─► 4. Parser 自動處理
    │       ├─► 監測 /results 目錄
    │       ├─► 讀取 JSON 檔案
    │       ├─► 標準化資料結構
    │       └─► 寫入 PostgreSQL
    │
    └─► 5. 結果查詢
            ├─► Web UI 圖形化展示
            ├─► SQL 直接查詢
            └─► API 程式化存取
```

詳細架構設計請參考 [ARCHITECTURE.md](./ARCHITECTURE.md)

---

## 前置需求

### 硬體需求

| 環境 | CPU | 記憶體 | 磁碟空間 |
|------|-----|--------|---------|
| 最小配置 | 2核 | 4GB | 20GB |
| 推薦配置 | 4核 | 8GB | 50GB |
| 生產環境 | 8核+ | 16GB+ | 100GB+ |

### 軟體需求

- **作業系統**: Linux, macOS, Windows (WSL2)
- **Docker**: 20.10 或更高版本
- **Docker Compose**: 2.0 或更高版本
- **Git**: 用於克隆專案
- **Make**: 用於執行命令（Windows 需額外安裝）

### 檢查環境

```bash
# 檢查 Docker 版本
docker --version
# 輸出: Docker version 20.10.x

# 檢查 Docker Compose 版本
docker-compose --version
# 輸出: Docker Compose version 2.x.x

# 檢查 Docker 是否運行
docker ps
# 應該能正常顯示容器列表（即使是空的）

# 檢查 Make
make --version
# Windows 用戶可以使用 Git Bash 或安裝 Make for Windows
```

---

## 安裝與配置

### 步驟 1: 克隆專案

```bash
git clone https://github.com/your-username/Security-and-Infrastructure-tools-Set.git
cd Security-and-Infrastructure-tools-Set
```

### 步驟 2: 配置環境變數

專案提供環境變數範本，複製並修改：

```bash
# 複製範本
cp .env.template .env

# 編輯環境變數
nano .env  # 或使用你喜歡的編輯器
```

**關鍵配置項**:

```bash
# 🔴 必須修改（生產環境）
DB_PASSWORD=<strong_password>      # 資料庫密碼
VAULT_TOKEN=<vault_root_token>    # Vault 根 Token

# 🟡 建議修改
SCAN_CONCURRENCY=10               # 掃描並發數
NUCLEI_RATE_LIMIT=150            # 速率限制
NMAP_TIMING=T4                    # Nmap 掃描速度

# 🟢 可選配置
TZ=Asia/Taipei                    # 時區
DEBUG=false                       # 除錯模式
```

完整環境變數說明：

| 變數名稱 | 預設值 | 說明 |
|---------|-------|------|
| `DB_PASSWORD` | changeme | PostgreSQL 密碼（**生產環境必改**） |
| `DB_USER` | sectools | 資料庫使用者名稱 |
| `DB_NAME` | security | 資料庫名稱 |
| `VAULT_TOKEN` | root | Vault 根 Token（**生產環境必改**） |
| `VAULT_ADDR` | http://localhost:8200 | Vault 服務地址 |
| `SCAN_CONCURRENCY` | 10 | 掃描並發數 |
| `NUCLEI_RATE_LIMIT` | 150 | Nuclei 每秒請求數限制 |
| `NMAP_TIMING` | T4 | Nmap 時序範本 (T0-T5) |
| `SUBNET` | 172.28.0.0/16 | Docker 網路子網 |

### 步驟 3: 目錄結構檢查

確保以下目錄存在：

```bash
Security-and-Infrastructure-tools-Set/
├── Docker/
│   └── compose/
│       └── docker-compose.yml    # Docker Compose 配置
├── Make_Files/
│   └── Makefile                  # Make 命令定義
├── init_scripts/
│   └── 01-init-sql               # 資料庫初始化腳本
├── scripts/                      # 實用腳本（可選）
├── docs/                         # 詳細文件（可選）
├── examples/                     # 使用範例（可選）
├── .env.template                 # 環境變數範本
├── README.md                     # 本文件
└── LICENSE
```

### 步驟 4: 初次部署

```bash
# 使用 Makefile 一鍵啟動
cd Make_Files
make up

# 或使用 Docker Compose 直接啟動
cd Docker/compose
docker-compose up -d

# 等待服務啟動（約 30 秒）
sleep 30

# 檢查服務狀態
make health
# 或
docker-compose ps
```

**預期輸出**:

```
NAME                 STATUS              PORTS
postgres             Up (healthy)        5432/tcp
vault                Up                  0.0.0.0:8200->8200/tcp
traefik              Up                  0.0.0.0:80->80/tcp, ...
argocd               Up                  0.0.0.0:8081->8080/tcp
scanner-nuclei       Exit 0              (按需啟動)
nmap                 Exit 0              (按需啟動)
```

### 步驟 5: 驗證部署

```bash
# 1. 測試 PostgreSQL 連線
docker exec -it postgres psql -U sectools -d security -c "SELECT version();"

# 2. 測試 Vault
curl http://localhost:8200/v1/sys/health

# 3. 測試 Traefik Dashboard
open http://localhost:8080  # macOS
# 或在瀏覽器訪問 http://localhost:8080

# 4. 檢查資料庫 Schema
docker exec -it postgres psql -U sectools -d security -c "\dt"
# 應該顯示: scan_jobs, scan_findings, nuclei_results, nmap_results, amass_results
```

---

## 使用指南

### Makefile 命令參考

專案提供便捷的 Makefile 命令：

```bash
# 進入 Make_Files 目錄
cd Make_Files

# 顯示所有可用命令
make help
```

#### 服務管理

```bash
# 啟動所有服務
make up

# 停止所有服務
make down

# 重啟所有服務
make restart

# 查看服務狀態
make ps

# 查看健康狀態
make health

# 查看即時日誌
make logs

# 查看特定服務日誌
docker-compose logs -f postgres
docker-compose logs -f vault
```

#### 掃描操作

##### Nuclei 掃描

```bash
# 掃描單一目標
make scan-nuclei TARGET=https://example.com

# 掃描多個目標（使用檔案）
echo "https://example1.com" > targets.txt
echo "https://example2.com" >> targets.txt
docker-compose run --rm scanner-nuclei nuclei -l /results/targets.txt -o /results/output.json

# 使用特定範本
docker-compose run --rm scanner-nuclei nuclei -u https://example.com -t /templates/cves/ -o /results/cve-scan.json

# 指定嚴重度
docker-compose run --rm scanner-nuclei nuclei -u https://example.com -severity critical,high -o /results/critical.json
```

##### Nmap 掃描

```bash
# 基本掃描
make scan-nmap TARGET=192.168.1.1

# 掃描整個網段
make scan-nmap TARGET=192.168.1.0/24

# 服務版本偵測
docker-compose run --rm nmap nmap -sV 192.168.1.1 -oX /results/nmap-version.xml

# 完整掃描（慢速但詳細）
docker-compose run --rm nmap nmap -A -T4 192.168.1.1 -oX /results/nmap-full.xml

# OS 指紋識別
docker-compose run --rm nmap nmap -O 192.168.1.1 -oX /results/nmap-os.xml
```

##### AMASS 掃描

```bash
# 子域名枚舉
docker-compose run --rm scanner-amass amass enum -d example.com -o /results/amass-subs.txt

# 被動模式（不直接探測目標）
docker-compose run --rm scanner-amass amass enum -passive -d example.com -o /results/amass-passive.txt
```

#### 資料庫操作

```bash
# 備份資料庫
make backup

# 手動備份
docker-compose exec -T postgres pg_dump -U sectools security > backup-$(date +%Y%m%d).sql

# 還原資料庫
docker-compose exec -T postgres psql -U sectools security < backup-20251017.sql

# 進入 PostgreSQL CLI
docker exec -it postgres psql -U sectools -d security

# 查詢高危發現項
docker exec -it postgres psql -U sectools -d security -c "SELECT * FROM critical_findings LIMIT 10;"

# 查詢掃描統計
docker exec -it postgres psql -U sectools -d security -c "SELECT * FROM scan_summary;"
```

#### 清理操作

```bash
# 停止服務但保留資料
make down

# 停止並刪除所有資料（⚠️ 危險操作）
make clean

# 清理舊的掃描結果檔案（保留資料庫記錄）
find scan_results/ -name "*.json" -mtime +30 -delete
```

### 常見使用場景

#### 場景 1: 定期網站漏洞掃描

```bash
#!/bin/bash
# 每日掃描腳本

TARGETS=(
    "https://example1.com"
    "https://example2.com"
    "https://example3.com"
)

for target in "${TARGETS[@]}"; do
    echo "Scanning $target..."
    make scan-nuclei TARGET=$target
    sleep 60  # 避免過於頻繁
done

# 產生報告
docker exec -it postgres psql -U sectools -d security -c \
    "SELECT target, COUNT(*) as findings FROM scan_findings 
     WHERE discovered_at > NOW() - INTERVAL '1 day' 
     GROUP BY target;"
```

#### 場景 2: 新資產發現與掃描

```bash
#!/bin/bash
# 完整資產掃描流程

DOMAIN="example.com"

# 1. 子域名發現
echo "Step 1: Subdomain enumeration..."
docker-compose run --rm scanner-amass amass enum -d $DOMAIN -o /results/subs.txt

# 2. 提取子域名
docker exec -it postgres psql -U sectools -d security -c \
    "COPY (SELECT DISTINCT subdomain FROM amass_results WHERE domain='$DOMAIN') TO STDOUT;" > subs.txt

# 3. 對每個子域名執行 Nuclei 掃描
while read sub; do
    echo "Scanning $sub..."
    make scan-nuclei TARGET=https://$sub
done < subs.txt
```

#### 場景 3: CI/CD 整合

```yaml
# .github/workflows/security-scan.yml
name: Security Scan

on:
  schedule:
    - cron: '0 2 * * *'  # 每日凌晨 2 點
  push:
    branches: [main]

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      
      - name: Start Stack
        run: |
          cd Docker/compose
          docker-compose up -d
          sleep 30
      
      - name: Run Scan
        run: |
          cd Make_Files
          make scan-nuclei TARGET=${{ secrets.TARGET_URL }}
      
      - name: Check Critical Findings
        run: |
          CRITICAL_COUNT=$(docker exec postgres psql -U sectools -d security -t -c \
            "SELECT COUNT(*) FROM scan_findings WHERE severity='critical' 
             AND discovered_at > NOW() - INTERVAL '1 day';")
          
          if [ $CRITICAL_COUNT -gt 0 ]; then
            echo "❌ Found $CRITICAL_COUNT critical vulnerabilities!"
            exit 1
          fi
```

---

## 整合工具

### 已整合工具詳細介紹

#### 🔍 Nuclei - 快速漏洞掃描器

**簡介**: ProjectDiscovery 開發的基於範本的漏洞掃描器

**特點**:
- 🚀 極快速度（Go 編寫）
- 📝 YAML 範本，易於自訂
- 🔄 社群驅動，範本更新快
- 📊 低誤報率

**使用範例**:
```bash
# 基本掃描
make scan-nuclei TARGET=https://example.com

# 自訂範本目錄
docker-compose run --rm -v ./custom-templates:/custom scanner-nuclei \
    nuclei -u https://example.com -t /custom -o /results/custom.json

# 使用特定 tag
docker-compose run --rm scanner-nuclei \
    nuclei -u https://example.com -tags cve,exposure -o /results/tagged.json
```

**結果解讀**:
```json
{
  "template-id": "CVE-2021-12345",
  "info": {
    "name": "Example Vulnerability",
    "severity": "high",
    "description": "..."
  },
  "matched-at": "https://example.com/vulnerable-path",
  "extracted-results": ["sensitive_data"]
}
```

#### 🌐 Nmap - 網路掃描之王

**簡介**: 經典的網路探測和安全審計工具

**特點**:
- 🎯 精確的端口掃描
- 🔬 服務版本偵測
- 🖥️ OS 指紋識別
- 📜 NSE 腳本引擎擴展

**掃描類型**:
```bash
# TCP SYN 掃描（預設，需 root）
docker-compose run --rm nmap nmap -sS 192.168.1.1

# TCP Connect 掃描（無需 root）
docker-compose run --rm nmap nmap -sT 192.168.1.1

# UDP 掃描
docker-compose run --rm nmap nmap -sU 192.168.1.1

# 版本偵測
docker-compose run --rm nmap nmap -sV --version-intensity 5 192.168.1.1

# 腳本掃描（漏洞檢測）
docker-compose run --rm nmap nmap --script vuln 192.168.1.1
```

#### 🗺️ AMASS - 資產發現專家

**簡介**: OWASP 專案，深度子域名發現和外部攻擊面管理

**特點**:
- 🔍 多資料來源整合
- 🤫 被動/主動模式
- 🌐 DNS 枚舉
- 📊 關係圖視覺化

**使用範例**:
```bash
# 基本枚舉
docker-compose run --rm scanner-amass amass enum -d example.com

# 使用配置檔（API keys）
docker-compose run --rm -v ./amass-config.ini:/config.ini scanner-amass \
    amass enum -config /config.ini -d example.com

# 輸出 JSON
docker-compose run --rm scanner-amass amass enum -d example.com -json /results/amass.json
```

### 基礎設施組件

#### 💾 PostgreSQL

**資料庫 Schema**:
- `scan_jobs`: 掃描任務記錄
- `scan_findings`: 統一的發現項表
- `nuclei_results`: Nuclei 特定結果
- `nmap_results`: Nmap 特定結果
- `amass_results`: AMASS 特定結果

**常用查詢**:
```sql
-- 查詢最近 7 天的高危漏洞
SELECT * FROM critical_findings 
WHERE discovered_at > NOW() - INTERVAL '7 days'
ORDER BY cvss_score DESC;

-- 統計各類掃描工具使用情況
SELECT scan_type, COUNT(*) as total FROM scan_jobs 
GROUP BY scan_type;

-- 查詢特定目標的所有發現項
SELECT * FROM scan_findings 
WHERE scan_job_id IN (
    SELECT id FROM scan_jobs WHERE target = 'https://example.com'
);
```

#### 🔐 Vault

**使用場景**:
- 資料庫憑證動態生成
- API Token 加密儲存
- SSH 憑證管理
- PKI 憑證簽發

**基本操作**:
```bash
# 讀取密鑰
docker exec -it vault vault kv get secret/database

# 寫入密鑰
docker exec -it vault vault kv put secret/api-key value="your-key"

# 列出所有密鑰
docker exec -it vault vault kv list secret/
```

#### 🌐 Traefik

**功能**:
- 自動 HTTPS (Let's Encrypt)
- 服務發現（Docker labels）
- 負載均衡
- 中介軟體（認證、限流）

**配置範例**:
```yaml
# docker-compose.yml 中添加服務
your-service:
  labels:
    - "traefik.enable=true"
    - "traefik.http.routers.myapp.rule=Host(`myapp.example.com`)"
    - "traefik.http.routers.myapp.entrypoints=websecure"
    - "traefik.http.routers.myapp.tls.certresolver=letsencrypt"
```

---

## 最佳實踐

### 安全配置建議

#### 1. 密鑰管理

**❌ 不要這樣做**:
```yaml
environment:
  DB_PASSWORD: "plaintext_password"  # 明文密碼
```

**✅ 應該這樣做**:
```yaml
environment:
  DB_PASSWORD: ${DB_PASSWORD}  # 從環境變數或 .env 讀取
```

**🔒 最佳實踐**:
```yaml
# 使用 Docker secrets
secrets:
  db_password:
    file: ./secrets/db_password.txt

services:
  postgres:
    secrets:
      - db_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
```

#### 2. 網路隔離

```yaml
# 創建多個網路，隔離不同層級
networks:
  frontend:  # 面向使用者的服務
  backend:   # 內部服務
  database:  # 資料庫專用

services:
  traefik:
    networks:
      - frontend
  
  api:
    networks:
      - frontend
      - backend
  
  postgres:
    networks:
      - backend
      - database
```

#### 3. 資源限制

```yaml
services:
  scanner-nuclei:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
```

#### 4. 健康檢查

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

### 效能調優

#### 1. PostgreSQL 優化

```sql
-- 調整共享緩衝區（容器記憶體的 25%）
ALTER SYSTEM SET shared_buffers = '512MB';

-- 調整工作記憶體
ALTER SYSTEM SET work_mem = '16MB';

-- 啟用平行查詢
ALTER SYSTEM SET max_parallel_workers_per_gather = 2;

-- 重新載入配置
SELECT pg_reload_conf();
```

#### 2. Nuclei 調優

```bash
# 調整並發和速率
nuclei -u https://example.com \
  -c 50 \                    # 並發數
  -rate-limit 150 \          # 每秒請求數
  -timeout 5 \               # 逾時
  -retries 1 \               # 重試次數
  -bulk-size 25              # 批次大小
```

#### 3. Docker 優化

```bash
# 清理未使用的映像和容器
docker system prune -a

# 限制日誌大小
# 在 docker-compose.yml 中
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

### 生產環境部署

#### 1. 環境變數檢查清單

- [ ] 修改 `DB_PASSWORD` 為強密碼
- [ ] 修改 `VAULT_TOKEN` 為安全 Token
- [ ] 設定 `TZ` 為正確時區
- [ ] 配置備份路徑 `BACKUP_DIR`
- [ ] 設定通知（Slack/Email）
- [ ] 關閉 `DEBUG` 模式
- [ ] 配置 SSL 憑證（Traefik）

#### 2. 監控設定

```yaml
# 添加 Prometheus 和 Grafana
prometheus:
  image: prom/prometheus:latest
  volumes:
    - ./prometheus.yml:/etc/prometheus/prometheus.yml
  ports:
    - "9090:9090"

grafana:
  image: grafana/grafana:latest
  ports:
    - "3000:3000"
  environment:
    GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASSWORD}
```

#### 3. 自動化備份

```bash
# 添加到 crontab
0 2 * * * cd /path/to/project && make backup

# 或使用 Docker 定時任務
# 參考 scripts/backup.sh
```

#### 4. 日誌聚合

```yaml
# 添加 Loki 日誌系統
loki:
  image: grafana/loki:latest
  ports:
    - "3100:3100"

promtail:
  image: grafana/promtail:latest
  volumes:
    - /var/log:/var/log
    - /var/lib/docker/containers:/var/lib/docker/containers
```

---

## 故障排除

### 常見問題

#### 問題 1: 服務無法啟動

**症狀**: `docker-compose up -d` 後服務狀態為 `Exited`

**診斷**:
```bash
# 查看服務日誌
docker-compose logs service-name

# 檢查容器狀態
docker-compose ps

# 檢查資源使用
docker stats
```

**可能原因**:
- 端口衝突：修改 docker-compose.yml 中的端口映射
- 記憶體不足：增加 Docker 記憶體限制或減少服務
- 配置錯誤：檢查環境變數和配置檔

#### 問題 2: PostgreSQL 健康檢查失敗

**症狀**: `postgres` 服務狀態顯示 `unhealthy`

**解決方案**:
```bash
# 1. 查看 PostgreSQL 日誌
docker-compose logs postgres

# 2. 手動測試健康檢查命令
docker exec -it postgres pg_isready -U sectools

# 3. 檢查資料庫是否可連線
docker exec -it postgres psql -U sectools -d security -c "SELECT 1;"

# 4. 重啟 PostgreSQL
docker-compose restart postgres
```

#### 問題 3: Vault 無法訪問

**症狀**: `curl http://localhost:8200` 連線失敗

**解決方案**:
```bash
# 1. 檢查 Vault 是否運行
docker-compose ps vault

# 2. 查看 Vault 日誌
docker-compose logs vault

# 3. 檢查 Vault 狀態
docker exec -it vault vault status

# 4. 如果 Vault sealed，需要 unseal
docker exec -it vault vault operator unseal
```

#### 問題 4: 掃描結果未寫入資料庫

**症狀**: 掃描完成但資料庫中無記錄

**診斷步驟**:
```bash
# 1. 檢查掃描結果檔案是否生成
docker-compose exec scanner-nuclei ls -la /results/

# 2. 檢查 Parser 是否運行
docker-compose logs parser-nuclei

# 3. 手動測試資料庫連線
docker exec -it parser-nuclei psql -h postgres -U sectools -d security -c "SELECT 1;"

# 4. 檢查資料庫表結構
docker exec -it postgres psql -U sectools -d security -c "\dt"
```

**解決方案**:
```bash
# 重啟 Parser 服務
docker-compose restart parser-nuclei parser-amass

# 手動匯入結果（如需要）
docker exec -it parser-nuclei python /app/parse.py /results/nuclei-xxx.json
```

#### 問題 5: 權限錯誤

**症狀**: `Permission denied` 錯誤

**解決方案**:
```bash
# 修改掛載目錄的權限
sudo chown -R $(id -u):$(id -g) ./scan_results
sudo chmod -R 755 ./scan_results

# 或在 docker-compose.yml 中指定 user
services:
  scanner-nuclei:
    user: "${UID}:${GID}"
```

### 效能問題

#### CPU 使用率過高

```bash
# 1. 查看哪個容器佔用 CPU
docker stats

# 2. 降低掃描並發數
# 修改 .env
SCAN_CONCURRENCY=5
NUCLEI_RATE_LIMIT=50

# 3. 限制容器 CPU
# 在 docker-compose.yml 中
deploy:
  resources:
    limits:
      cpus: '0.5'
```

#### 記憶體不足

```bash
# 1. 檢查記憶體使用
docker stats

# 2. 增加 swap 空間（Linux）
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 3. 限制容器記憶體
deploy:
  resources:
    limits:
      memory: 512M
```

#### 磁碟空間不足

```bash
# 1. 檢查磁碟使用
df -h

# 2. 清理舊的掃描結果
find scan_results/ -name "*.json" -mtime +30 -delete

# 3. 清理 Docker 系統
docker system prune -a --volumes

# 4. 啟用日誌輪轉
# 在 docker-compose.yml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

### 除錯技巧

```bash
# 1. 進入容器內部排查
docker exec -it service-name /bin/sh

# 2. 查看詳細日誌
docker-compose logs --tail=100 -f service-name

# 3. 檢查網路連通性
docker exec -it service-name ping postgres
docker exec -it service-name nc -zv postgres 5432

# 4. 檢查環境變數
docker exec -it service-name env

# 5. 驗證配置檔
docker exec -it service-name cat /path/to/config
```

---

## 開發指南

### 添加新的掃描工具

#### 步驟 1: 選擇工具

參考 [TOOLS.md](./TOOLS.md) 選擇要整合的工具，例如 `trivy`

#### 步驟 2: 添加到 docker-compose.yml

```yaml
services:
  scanner-trivy:
    image: aquasec/trivy:latest
    volumes:
      - scan_results:/results
      - trivy_cache:/root/.cache/trivy
    networks:
      - security_net
    command: ["--help"]  # 預設命令
```

#### 步驟 3: 添加 Makefile 命令

```makefile
# Make_Files/Makefile
scan-trivy:
	docker-compose run --rm scanner-trivy \
		trivy image --format json --output /results/trivy-$(shell date +%Y%m%d-%H%M%S).json $(TARGET)
```

#### 步驟 4: 創建 Parser（可選）

```python
# scripts/parsers/trivy_parser.py
import json
import psycopg2

def parse_trivy_results(file_path):
    with open(file_path) as f:
        data = json.load(f)
    
    conn = psycopg2.connect(
        host="postgres",
        user="sectools",
        password=os.getenv("DB_PASSWORD"),
        database="security"
    )
    
    # 解析並插入資料庫
    # ...
```

#### 步驟 5: 更新資料庫 Schema（如需要）

```sql
-- init_scripts/02-add-trivy.sql
CREATE TABLE IF NOT EXISTS trivy_results (
    id SERIAL PRIMARY KEY,
    scan_job_id INTEGER REFERENCES scan_jobs(id),
    image_name VARCHAR(255),
    vulnerability_id VARCHAR(50),
    severity VARCHAR(20),
    package_name VARCHAR(255),
    installed_version VARCHAR(50),
    fixed_version VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_trivy_severity ON trivy_results(severity);
```

### 自訂 Nuclei 範本

```yaml
# custom-templates/my-check.yaml
id: my-custom-check

info:
  name: My Custom Vulnerability Check
  author: your-name
  severity: medium
  description: Check for specific vulnerability
  tags: custom,myapp

requests:
  - method: GET
    path:
      - "{{BaseURL}}/api/endpoint"
    
    matchers-condition: and
    matchers:
      - type: word
        words:
          - "vulnerable_string"
        part: body
      
      - type: status
        status:
          - 200

    extractors:
      - type: regex
        name: sensitive_data
        regex:
          - 'token":"([a-zA-Z0-9]+)"'
        group: 1
```

**使用自訂範本**:
```bash
docker-compose run --rm \
  -v ./custom-templates:/custom \
  scanner-nuclei nuclei -u https://example.com -t /custom
```

### 擴展 API 介面

```python
# scripts/api/main.py
from fastapi import FastAPI
import psycopg2

app = FastAPI()

@app.get("/api/scans")
def get_recent_scans(limit: int = 10):
    conn = psycopg2.connect(...)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM scan_jobs ORDER BY started_at DESC LIMIT %s", (limit,))
    return cursor.fetchall()

@app.get("/api/findings/{scan_id}")
def get_findings(scan_id: int):
    # 查詢特定掃描的發現項
    pass

# 添加到 docker-compose.yml
api-server:
  build: ./scripts/api
  ports:
    - "8000:8000"
  environment:
    DATABASE_URL: postgres://sectools:${DB_PASSWORD}@postgres:5432/security
```

---

## 常見問題

### 一般問題

**Q: 可以在生產環境使用嗎？**
A: 可以，但需要做以下調整：
- 修改所有預設密碼
- 啟用 Traefik SSL
- 配置防火牆規則
- 設定監控和告警
- 定期備份資料庫

**Q: 支援哪些作業系統？**
A: 任何支援 Docker 的系統：
- Linux (推薦)
- macOS
- Windows 10/11 with WSL2

**Q: 需要多少資源？**
A: 
- 最小：2核 CPU, 4GB RAM
- 推薦：4核 CPU, 8GB RAM
- 生產：8+核 CPU, 16+ GB RAM

**Q: 資料會存在哪裡？**
A:
- 掃描結果：`scan_results` Docker volume
- 資料庫：`postgres_data` Docker volume
- 備份：`backups/` 目錄

**Q: 如何升級服務版本？**
A:
```bash
# 1. 修改 docker-compose.yml 中的版本標籤
# 2. 拉取新映像
docker-compose pull

# 3. 重新啟動服務
docker-compose up -d

# 4. 檢查是否正常
docker-compose ps
```

### 掃描相關

**Q: 掃描會被目標網站封鎖嗎？**
A: 可能。建議：
- 降低速率限制 `NUCLEI_RATE_LIMIT=50`
- 使用代理或 VPN
- 僅掃描有授權的目標

**Q: 如何減少誤報？**
A:
- 使用 Nuclei 的 `--severity` 過濾
- 啟用手動驗證 `verified` 欄位
- 參考 CVE 資料庫確認

**Q: 結果保留多久？**
A: 預設永久保留，可配置自動清理：
```sql
-- 刪除 90 天前的結果
DELETE FROM scan_findings 
WHERE discovered_at < NOW() - INTERVAL '90 days';
```

### 技術問題

**Q: 如何與現有系統整合？**
A:
- REST API（需自行開發）
- 直接查詢 PostgreSQL
- 匯出 JSON/CSV 檔案
- Webhook 通知

**Q: 支援分散式部署嗎？**
A: 當前為單機版，未來可：
- 使用 Docker Swarm
- 遷移至 Kubernetes
- 設定 PostgreSQL 主從複製

**Q: 如何貢獻代碼？**
A: 請參考 [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## 貢獻

我們歡迎任何形式的貢獻！

### 如何貢獻

1. **Fork 專案**
2. **創建功能分支** (`git checkout -b feature/AmazingFeature`)
3. **提交變更** (`git commit -m 'Add some AmazingFeature'`)
4. **推送分支** (`git push origin feature/AmazingFeature`)
5. **開啟 Pull Request**

### 貢獻類型

- 🐛 回報 Bug
- 💡 提出新功能
- 📝 改進文件
- 🔧 提交程式碼
- 🌐 翻譯文件

詳細規範請參考 [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## 路線圖

### v1.1 (2025 Q2)

- [ ] Web UI 儀表板
- [ ] 完整 REST API
- [ ] Redis 任務佇列
- [ ] 自動化報告生成

### v1.2 (2025 Q3)

- [ ] Prometheus + Grafana 監控
- [ ] ELK Stack 日誌聚合
- [ ] N8N 工作流自動化
- [ ] Trivy 容器掃描整合

### v2.0 (2025 Q4)

- [ ] AI 輔助分析 (Ollama + ChromaDB)
- [ ] Kubernetes Helm Charts
- [ ] 多租戶支援
- [ ] MISP 威脅情報整合

---

## 授權

本專案採用 MIT 授權條款 - 詳見 [LICENSE](LICENSE) 檔案

---

## 致謝

感謝以下開源專案：

- [ProjectDiscovery Nuclei](https://github.com/projectdiscovery/nuclei)
- [Nmap](https://nmap.org/)
- [OWASP AMASS](https://github.com/OWASP/Amass)
- [HashiCorp Vault](https://www.vaultproject.io/)
- [Traefik](https://traefik.io/)
- [SecureCodeBox](https://www.securecodebox.io/)

---

## 聯絡方式

- **專案 Issues**: [GitHub Issues](https://github.com/your-username/Security-and-Infrastructure-tools-Set/issues)
- **討論區**: [GitHub Discussions](https://github.com/your-username/Security-and-Infrastructure-tools-Set/discussions)
- **Email**: security-tools@example.com

---

## 免責聲明

本工具僅供合法的安全測試和研究使用。使用者需遵守所在地區的法律法規，並取得目標系統所有者的明確授權。專案維護者不對任何濫用行為負責。

**請負責任地使用本工具！**

---

<div align="center">

**如果這個專案對您有幫助，請給個 ⭐ Star！**

Made with ❤️ by Security Community

</div>
