# NextMeal

NextMeal 是一个面向日常“吃什么”决策场景的对话式餐食推荐与多餐规划项目。

## 本地开发

当前开发环境采用：

- Spring Boot：Windows 本机运行（Java 21）
- MySQL 8.4：Docker Desktop 运行
- Web 页面：http://localhost:8080
- Docker MySQL：`localhost:3307`
- Windows 本机 MySQL：`localhost:3306`（本项目不使用）

## 启动数据库

先启动 Docker Desktop，然后在项目目录执行：

```powershell
docker compose up -d
docker compose ps
```

第一次创建数据卷时，Compose 会自动执行：

```text
src/main/resources/db/diet_db.sql
```

数据库连接默认值：

```text
地址：localhost:3307
数据库：diet_db
用户：root
密码：123456
```

可通过环境变量 `DB_URL`、`DB_USERNAME` 和 `DB_PASSWORD` 覆盖 Spring Boot 默认连接配置；可通过 `MYSQL_ROOT_PASSWORD` 覆盖 Compose 的默认密码。两边密码必须保持一致。

## 启动应用

在 IntelliJ IDEA 中运行：

```text
src/main/java/com/diet/DietApplication.java
```

启动完成后访问 http://localhost:8080。

## 停止数据库

停止并删除容器，但保留数据库数据：

```powershell
docker compose down
```

再次执行 `docker compose up -d` 会恢复原数据。

如需彻底删除数据库并重新执行初始化 SQL：

```powershell
docker compose down -v
docker compose up -d
```

注意：`docker compose down -v` 会永久删除本项目 Docker MySQL 中的数据。

## 大模型配置

项目当前使用 AgentScope 的 `DashScopeChatModel` 和通义千问模型。DeepSeek API Key 不能直接填写到 `agentscope.dashscope.api-key`；使用 DeepSeek 前需要先完成模型适配。
