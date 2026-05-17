# Task Management API

REST API для управления задачами на FastAPI с PostgreSQL, Redis, централизованным сбором логов (Loki + Promtail + Grafana) и CI/CD пайплайном в GitLab.

---

## 📋 О проекте

Проект представляет собой бэкенд для системы управления задачами. Разработан на Python с использованием FastAPI. Поддерживает асинхронную работу с PostgreSQL через SQLAlchemy и кэширование через Redis.

**Основные возможности:**

- Кэширование в Redis
- Централизованный сбор логов (Loki + Promtail)
- Визуализация логов в Grafana
- Полная контейнеризация (Docker)
- CI/CD пайплайн в GitLab (тесты, сборка образа, публикация, деплой)

---

## 🛠 Технологии

| Компонент | Технология |
|-----------|-----------|
| API | FastAPI + Uvicorn |
| База данных | PostgreSQL |
| Кэш | Redis  |
| Сбор логов | Promtail |
| Хранилище логов | Loki |
| Визуализация | Grafana |
| CI/CD | GitLab CI |
| Контейнеризация | Docker + Docker Compose |
| Язык | Python  |

---


## 🚀 Быстрый старт (локально)

### 1. Требования

- Docker
- Docker Compose
- Git

### 2. Клонирование и запуск

```bash
git clone https://gitlab.com/Karleenr/Task-Management-API.git
cd Task-Management-API

cp .env.example .env
# отредактируйте пароли в .env (по желанию)

docker compose up -d 
```

### 3. Проверка работоспособности

```bash
curl http://localhost:8000/health 
```

Ожидаемый ответ:
```bash
{"status":"healthy","database":"connected","redis":"connected","timestamp":"..."}
```

### 4. Просмотр запущенных контейнеров

### Должны быть все 6 контейнеров:

task-app — приложение

task-postgres — PostgreSQL

task-redis — Redis

task-loki — хранилище логов

task-promtail — сборщик логов

task-grafana — визуализация

## 📊 Мониторинг логов (Grafana + Loki)

### 1. Доступ к Grafana

Открой в браузере:

http://localhost:3000


**Логин:** `admin`  
**Пароль:** `admin` (или из `.env`)

---


### 2. Просмотр логов приложения

1. Нажми на иконку **Explore** (компас, левое меню)
2. Выбери источник **Loki**
3. Введи запрос: `{container_name="task-app"}`

4. Выбери временной диапазон **Last 5 minutes**
5. Нажми **Run query**


## 🔧 CI/CD (GitLab CI)

Пайплайн автоматически запускается при пуше в ветку `develop`.

### Стадии пайплайна:

| Стадия | Действие |
|--------|----------|
| `test` | Запуск pytest tests/ |
| `build` | Сборка Docker-образа |
| `publish` | Публикация в GitLab Registry |
| `deploy` |  Деплой на сервер |



### Переменные CI/CD (Settings → CI/CD → Variables):

| Переменная | Тип | Описание |
|-----------|-----|----------|
| `DEPLOY_SERVER` | Variable | IP-адрес сервера |
| `DEPLOY_USER` | Variable | Пользователь SSH |
| `SSH_PRIVATE_KEY` | File | Приватный SSH-ключ |
| `CI_REGISTRY` | Variable | `registry.gitlab.com` (авто) |
| `CI_REGISTRY_USER` | Variable | Автоматически |
| `CI_REGISTRY_PASSWORD` | Variable | Автоматически |

## 🖥️ Деплой на сервер

### Подготовка сервера (однократно)

```bash
# 1. Установить Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# 2. Установить Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 3. Создать папку проекта
mkdir -p /opt/task-api/config

# 4. Копирование файлов на сервер (однократно)

scp docker-compose.yaml user@server:/opt/task-api/
scp config/promtail-config.yaml user@server:/opt/task-api/config/
scp scp -r config/grafana/provisioning user@server:/opt/task-api/config/
scp .env user@server:/opt/task-api/
```
### ⚠️ Важно: отличие серверного `docker-compose.yaml` от локального

| Локально (разработка) | На сервере (production) |
|----------------------|------------------------|
| Использует `build: .` | Использует `image: registry.gitlab.com/...` |
| Собирает образ из локального Dockerfile | Тянет готовый образ из GitLab Registry |

## 🧪 Тестирование

### Локальный запуск тестов:

```bash
pip install -r requirements.txt
pytest tests/ -v
```

### В CI/CD:
 
Тесты выполняются автоматически на этапе test в GitLab CI.

