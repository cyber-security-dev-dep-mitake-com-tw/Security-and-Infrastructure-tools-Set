# 工具參考指南 | Tools Reference Guide

> 本文件詳細列出專案中已整合、推薦整合和可選的安全與基礎設施工具

---

## 📋 目錄

- [Tier 1: 已整合工具](#tier-1-已整合工具)
- [Tier 2: 推薦優先整合](#tier-2-推薦優先整合)
- [Tier 3: 可選工具](#tier-3-可選工具)
  - [監控與可觀測性](#監控與可觀測性)
  - [AI/ML 與智能分析](#aiml-與智能分析)
  - [工作流與自動化](#工作流與自動化)
  - [安全掃描工具](#安全掃描工具)
  - [資料儲存與快取](#資料儲存與快取)
  - [API 閘道與代理](#api-閘道與代理)
  - [通知與協作](#通知與協作)
  - [CI/CD 與 DevOps](#cicd-與-devops)
  - [威脅情報](#威脅情報)

---

## Tier 1: 已整合工具

### 🔍 掃描工具

#### Nuclei
- **用途**: 快速、可自訂的漏洞掃描器
- **Docker Hub**: `projectdiscovery/nuclei`
- **整合狀態**: ✅ 已整合
- **資源需求**: 低 (CPU: 0.5核, RAM: 512MB)
- **使用方式**:
  ```bash
  make scan-nuclei TARGET=https://example.com
  ```

#### AMASS
- **用途**: 深度子域名發現和外部資產盤點
- **Docker Hub**: `caffix/amass`
- **整合狀態**: ✅ 已整合 (Parser)
- **資源需求**: 中等 (CPU: 1核, RAM: 1GB)
- **特點**: 支援被動和主動偵察

#### Nmap
- **用途**: 網路探測和安全審計
- **Docker Hub**: `instrumentisto/nmap`
- **整合狀態**: ✅ 已整合
- **資源需求**: 中等 (CPU: 1核, RAM: 512MB)
- **使用方式**:
  ```bash
  make scan-nmap TARGET=192.168.1.0/24
  ```

### 🗄️ 基礎設施

#### PostgreSQL
- **用途**: 主資料庫，儲存掃描結果和元數據
- **Docker Hub**: `postgres:15-alpine`
- **整合狀態**: ✅ 已整合
- **資源需求**: 中等 (CPU: 2核, RAM: 2GB)
- **特點**: 
  - 完整的 Schema 定義
  - 自動索引優化
  - 健康檢查支援

#### Vault
- **用途**: 密鑰管理和敏感資料儲存
- **Docker Hub**: `vault:1.13`
- **整合狀態**: ✅ 已整合
- **資源需求**: 低 (CPU: 0.5核, RAM: 256MB)
- **端口**: 8200

### 🌐 網路與閘道

#### Traefik
- **用途**: 反向代理和負載均衡器
- **Docker Hub**: `traefik:latest`
- **整合狀態**: ✅ 已整合
- **資源需求**: 低 (CPU: 0.5核, RAM: 128MB)
- **特點**:
  - 自動 HTTPS
  - Web Dashboard (Port 8080)
  - Docker 自動服務發現

### 🚀 CI/CD

#### ArgoCD
- **用途**: GitOps 持續部署
- **Docker Hub**: `argoproj/argocd`
- **整合狀態**: ✅ 已整合
- **資源需求**: 中等 (CPU: 1核, RAM: 512MB)
- **端口**: 8081

### 🔧 其他整合工具

#### SecureCodeBox Operator
- **用途**: 掃描工作流編排
- **Docker Hub**: `securecodebox/operator`
- **整合狀態**: ✅ 已整合

---

## Tier 2: 推薦優先整合

以下工具對提升系統功能有重大價值，建議優先整合：

### 📊 監控與可視化

#### Prometheus + Grafana
- **用途**: 指標收集與視覺化儀表板
- **整合難度**: ⭐⭐ 中等
- **資源需求**: 中等 (各 512MB RAM)
- **價值**: 🔥🔥🔥 極高
- **整合建議**:
  ```yaml
  prometheus:
    image: prom/prometheus:latest
    ports: ["9090:9090"]
  grafana:
    image: grafana/grafana:latest
    ports: ["3000:3000"]
  ```

### 🔍 日誌聚合

#### Elasticsearch + Kibana (ELK Stack)
- **用途**: 可搜尋的掃描結果與日誌分析
- **整合難度**: ⭐⭐⭐ 較高
- **資源需求**: 高 (ES: 2GB+, Kibana: 1GB)
- **價值**: 🔥🔥🔥 極高
- **替代方案**: Loki + Promtail (更輕量)

### 🔄 訊息佇列

#### Redis
- **用途**: 快取和任務佇列
- **整合難度**: ⭐ 簡單
- **資源需求**: 低 (256MB)
- **價值**: 🔥🔥🔥 極高
- **使用場景**: 掃描任務排程、結果快取、Session 儲存

#### RabbitMQ / Kafka
- **用途**: 事件串流和任務分發
- **整合難度**: ⭐⭐ 中等
- **資源需求**: 中等 (512MB)
- **價值**: 🔥🔥 高
- **選擇建議**: 中小規模用 RabbitMQ，大規模用 Kafka

### 🤖 低代碼自動化

#### N8N
- **用途**: 工作流自動化（掃描鏈、通知、整合）
- **整合難度**: ⭐⭐ 中等
- **資源需求**: 中等 (512MB)
- **價值**: 🔥🔥🔥 極高
- **Docker Hub**: `n8nio/n8n`

### 🛡️ 額外安全工具

#### Trivy
- **用途**: 容器漏洞掃描
- **整合難度**: ⭐ 簡單
- **資源需求**: 低 (256MB)
- **價值**: 🔥🔥 高
- **Docker Hub**: `aquasec/trivy`

#### OWASP ZAP
- **用途**: Web 應用程式安全掃描
- **整合難度**: ⭐⭐ 中等
- **資源需求**: 中等 (1GB)
- **價值**: 🔥🔥🔥 極高
- **Docker Hub**: `owasp/zap2docker-stable`

---

## Tier 3: 可選工具

### 監控與可觀測性

| 工具 | 用途 | 難度 | 資源 | Docker Image |
|------|------|------|------|--------------|
| **Loki** | 日誌聚合 | ⭐⭐ | 中 | `grafana/loki` |
| **Promtail** | 日誌傳送器 | ⭐ | 低 | `grafana/promtail` |
| **Jaeger** | 分散式追蹤 | ⭐⭐⭐ | 中 | `jaegertracing/all-in-one` |
| **Victoria Metrics** | 長期指標儲存 | ⭐⭐ | 中 | `victoriametrics/victoria-metrics` |
| **Netdata** | 即時監控 | ⭐ | 低 | `netdata/netdata` |
| **Uptime Kuma** | 服務可用性監控 | ⭐ | 低 | `louislam/uptime-kuma` |
| **Graylog** | 日誌管理平台 | ⭐⭐⭐ | 高 | `graylog/graylog` |

### AI/ML 與智能分析

| 工具 | 用途 | 難度 | 資源 | Docker Image |
|------|------|------|------|--------------|
| **Ollama** | 本地 LLM 運行 | ⭐⭐ | 高 (4GB+) | `ollama/ollama` |
| **LangChain** | AI 工作流框架 | ⭐⭐⭐ | 中 | 自建 |
| **ChromaDB** | 向量資料庫 | ⭐⭐ | 中 | `chromadb/chroma` |
| **Qdrant** | 向量相似度搜尋 | ⭐⭐ | 中 | `qdrant/qdrant` |
| **Weaviate** | 向量搜尋引擎 | ⭐⭐⭐ | 中 | `semitechnologies/weaviate` |

**使用場景**:
- 漏洞描述自動分析
- 相似漏洞發現
- 假陽性過濾
- 攻擊路徑分析

### 工作流與自動化

| 工具 | 用途 | 難度 | 資源 | Docker Image |
|------|------|------|------|--------------|
| **Apache Airflow** | 複雜工作流編排 | ⭐⭐⭐ | 高 | `apache/airflow` |
| **Temporal** | 持久化執行引擎 | ⭐⭐⭐ | 中 | `temporalio/auto-setup` |
| **Prefect** | 現代工作流平台 | ⭐⭐ | 中 | `prefecthq/prefect` |
| **Rundeck** | 任務排程與自動化 | ⭐⭐ | 中 | `rundeck/rundeck` |

### 安全掃描工具

| 工具 | 用途 | 難度 | 資源 | Docker Image |
|------|------|------|------|--------------|
| **Falco** | 執行期安全監控 | ⭐⭐⭐ | 中 | `falcosecurity/falco` |
| **Clair** | 容器漏洞分析 | ⭐⭐ | 中 | `quay.io/coreos/clair` |
| **Anchore Engine** | 容器安全 | ⭐⭐⭐ | 高 | `anchore/anchore-engine` |
| **Wazuh** | 主機入侵偵測 | ⭐⭐⭐ | 高 | `wazuh/wazuh` |
| **Suricata** | 網路 IDS/IPS | ⭐⭐⭐ | 中 | `jasonish/suricata` |
| **OpenVAS** | 漏洞評估 | ⭐⭐⭐ | 高 | `greenbone/openvas` |
| **Metasploit** | 滲透測試 | ⭐⭐⭐ | 高 | `metasploitframework/metasploit-framework` |
| **SQLMap** | SQL 注入測試 | ⭐ | 低 | `peterevans/sqlmap` |
| **Nikto** | Web 伺服器掃描 | ⭐ | 低 | `sullo/nikto` |
| **Gobuster** | 目錄爆破 | ⭐ | 低 | `zer0uid/gobuster` |
| **Hashcat** | 密碼破解 | ⭐⭐ | 高 (GPU) | `dizcza/docker-hashcat` |
| **Hydra** | 網路登入破解 | ⭐⭐ | 中 | `vanhauser/hydra` |
| **Snyk** | 程式碼安全掃描 | ⭐⭐ | 中 | `snyk/snyk` |

### 資料儲存與快取

| 工具 | 用途 | 難度 | 資源 | Docker Image |
|------|------|------|------|--------------|
| **MongoDB** | 文件資料庫（非結構化資料） | ⭐⭐ | 中 | `mongo` |
| **TimescaleDB** | 時序資料 | ⭐⭐ | 中 | `timescale/timescaledb` |
| **InfluxDB** | 指標資料庫 | ⭐⭐ | 中 | `influxdb` |
| **ClickHouse** | 分析資料庫 | ⭐⭐⭐ | 高 | `clickhouse/clickhouse-server` |
| **Memcached** | 分散式快取 | ⭐ | 低 | `memcached` |
| **KeyDB** | 多執行緒 Redis | ⭐ | 低 | `eqalpha/keydb` |
| **MinIO** | S3 相容物件儲存 | ⭐⭐ | 中 | `minio/minio` |

### API 閘道與代理

| 工具 | 用途 | 難度 | 資源 | Docker Image |
|------|------|------|------|--------------|
| **Kong** | API 閘道 | ⭐⭐⭐ | 中 | `kong` |
| **Nginx** | 反向代理/負載均衡 | ⭐⭐ | 低 | `nginx` |
| **Caddy** | 自動 HTTPS Web 伺服器 | ⭐ | 低 | `caddy` |
| **HAProxy** | 負載均衡器 | ⭐⭐ | 低 | `haproxy` |
| **Envoy** | 服務代理 | ⭐⭐⭐ | 中 | `envoyproxy/envoy` |

### 通知與協作

| 工具 | 用途 | 難度 | 資源 | Docker Image |
|------|------|------|------|--------------|
| **Gotify** | 推播通知 | ⭐ | 低 | `gotify/server` |
| **Ntfy** | 簡易通知服務 | ⭐ | 低 | `binwiederhier/ntfy` |
| **Apprise** | 多平台通知 | ⭐ | 低 | `caronc/apprise` |
| **Mattermost** | 團隊協作 | ⭐⭐ | 中 | `mattermost/mattermost-team-edition` |
| **Rocket.Chat** | 聊天平台 | ⭐⭐ | 中 | `rocket.chat` |

### CI/CD 與 DevOps

| 工具 | 用途 | 難度 | 資源 | Docker Image |
|------|------|------|------|--------------|
| **Jenkins** | CI/CD 自動化 | ⭐⭐⭐ | 中 | `jenkins/jenkins` |
| **GitLab Runner** | GitLab CI | ⭐⭐ | 中 | `gitlab/gitlab-runner` |
| **Drone** | 容器原生 CI | ⭐⭐ | 中 | `drone/drone` |
| **Harbor** | 容器映像倉庫 | ⭐⭐⭐ | 高 | `goharbor/harbor-core` |
| **Nexus** | 製品倉庫 | ⭐⭐⭐ | 高 | `sonatype/nexus3` |
| **SonarQube** | 程式碼品質分析 | ⭐⭐⭐ | 高 | `sonarqube` |
| **Semgrep** | 靜態分析 | ⭐⭐ | 中 | `returntocorp/semgrep` |
| **Checkov** | 基礎設施安全 | ⭐ | 低 | `bridgecrew/checkov` |

### 威脅情報

| 工具 | 用途 | 難度 | 資源 | Docker Image |
|------|------|------|------|--------------|
| **MISP** | 威脅情報平台 | ⭐⭐⭐⭐ | 高 | `coolacid/misp-docker` |
| **OpenCTI** | 網路威脅情報 | ⭐⭐⭐⭐ | 高 | `opencti/platform` |
| **TheHive** | 安全事件回應 | ⭐⭐⭐ | 中 | `strangebee/thehive` |
| **Cortex** | 可觀察物分析 | ⭐⭐⭐ | 中 | `thehiveproject/cortex` |
| **Shuffle** | 安全編排 (SOAR) | ⭐⭐⭐ | 中 | `ghcr.io/shuffle/shuffle-frontend` |

### 文件與知識管理

| 工具 | 用途 | 難度 | 資源 | Docker Image |
|------|------|------|------|--------------|
| **WikiJS** | 現代化 Wiki | ⭐⭐ | 低 | `requarks/wiki` |
| **BookStack** | 文件平台 | ⭐⭐ | 中 | `solidnerd/bookstack` |
| **Outline** | 知識庫 | ⭐⭐ | 中 | `outlinewiki/outline` |
| **HedgeDoc** | 協作 Markdown | ⭐ | 低 | `quay.io/hedgedoc/hedgedoc` |

### Web UI/儀表板

| 工具 | 用途 | 難度 | 資源 | Docker Image |
|------|------|------|------|--------------|
| **Heimdall** | 應用程式儀表板 | ⭐ | 低 | `linuxserver/heimdall` |
| **Homer** | 靜態儀表板 | ⭐ | 低 | `b4bz/homer` |
| **Dashy** | 功能豐富儀表板 | ⭐ | 低 | `lissy93/dashy` |
| **Portainer** | 容器管理 UI | ⭐ | 低 | `portainer/portainer-ce` |
| **Dozzle** | Docker 日誌查看器 | ⭐ | 低 | `amir20/dozzle` |

---

## 🎯 工具選型指南

### 根據場景選擇

#### 場景 1: 最小化可行系統 (MVP)
**目標**: 快速啟動，低資源需求

**推薦組合**:
- PostgreSQL (資料庫)
- Nuclei + Nmap (掃描)
- Traefik (代理)
- Vault (密鑰管理)

**總資源**: ~4GB RAM, 2 CPU

#### 場景 2: 生產環境系統
**目標**: 可靠、可觀測、可擴展

**推薦組合**:
- 基礎層: PostgreSQL + Redis + Vault
- 掃描層: Nuclei + Nmap + AMASS + Trivy + ZAP
- 監控層: Prometheus + Grafana + Loki
- 自動化: N8N + ArgoCD
- 閘道: Traefik

**總資源**: ~16GB RAM, 8 CPU

#### 場景 3: 企業級安全平台
**目標**: 全功能、AI 增強、威脅情報整合

**推薦組合**:
- 上述所有 + 
- AI 層: Ollama + ChromaDB
- 威脅情報: MISP + OpenCTI
- 日誌分析: ELK Stack
- 事件回應: TheHive + Cortex
- 訊息佇列: Kafka

**總資源**: ~64GB RAM, 16 CPU

### 根據整合難度選擇

#### 快速整合 (1-2小時)
- Redis, Portainer, Uptime Kuma, Gotify, Dozzle

#### 中等整合 (4-8小時)
- Prometheus + Grafana, N8N, Trivy, ZAP, MongoDB

#### 複雜整合 (1-3天)
- ELK Stack, MISP, OpenCTI, Harbor, Airflow

#### 專家級整合 (1週+)
- 完整 AI 管道, Kafka 叢集, Kubernetes 整合

---

## 📝 整合最佳實踐

### 1. 階段性整合
不要一次整合所有工具，建議順序：
1. 核心儲存 (PostgreSQL, Redis)
2. 基礎掃描工具
3. 監控系統 (Prometheus/Grafana)
4. 自動化工具 (N8N)
5. 進階分析 (ELK, AI)

### 2. 資源規劃
- 開發環境: 8GB RAM 最低
- 測試環境: 16GB RAM 推薦
- 生產環境: 32GB+ RAM 推薦

### 3. 安全配置
- 所有服務使用環境變數管理密鑰
- 敏感資料存入 Vault
- 網路隔離使用 Docker Networks
- 啟用 TLS/SSL (Traefik 自動化)

### 4. 監控與告警
優先級：
1. 資料庫健康狀態
2. 掃描服務可用性
3. 磁碟空間使用
4. 記憶體使用率

---

## 🔗 相關資源

- [Docker Hub](https://hub.docker.com) - 尋找官方映像
- [Awesome Docker](https://github.com/veggiemonk/awesome-docker) - Docker 資源集合
- [SecLists](https://github.com/danielmiessler/SecLists) - 安全測試字典
- [OWASP](https://owasp.org) - Web 應用程式安全

---

**最後更新**: 2025-10-17

