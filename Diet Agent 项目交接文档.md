# Diet Agent 学习项目交接文档

> 用途：将本文件交给新的 Codex 对话，便于继续协助学习、运行、排错和改造项目。
>
> 最后核对时间：2026-08-05

## 1. 给新对话的首要说明

请先完整阅读本交接文档，再阅读项目中的以下两份文档，然后检查实际文件和运行状态后继续工作：

- `D:\学习项目\diet-agent\项目启动说明.md`
- `D:\学习项目\diet-agent\Diet Agent 项目架构与实现说明.md`

不要覆盖现有修改，不要删除 Docker 数据卷，不要把任何 API Key 输出到回复、日志或文档中。

用户正在学习一个购买的 Java 多 Agent 项目，技术基础还在建立阶段。解释时请区分清楚 Windows、WSL 2、Docker Linux 容器、Java 进程、Spring Boot、Maven、MySQL 和大模型接口之间的关系，尽量使用直白语言。

## 2. 项目基本信息

- 项目名称：Diet Agent
- 项目目录：`D:\学习项目\diet-agent`
- 当前目录不是 Git 仓库，没有 `.git`，因此不能依靠 Git 恢复文件。
- 后端：Java 21 + Spring Boot 3.3.13
- Agent 框架：AgentScope Java 1.0.11
- 数据库访问：MyBatis 3.0.4
- 数据库：Docker 中的 MySQL 8.4
- 前端：原生 HTML、CSS、JavaScript，无 Node/npm 构建过程
- 页面地址：`http://localhost:8080`

## 3. 当前运行状态

截至本交接文档生成时：

- Spring Boot 已停止，端口 `8080` 没有监听。
- Docker Desktop 已停止。
- `diet-agent-mysql` 容器已停止。
- Windows 映射端口 `3307` 没有监听。
- MySQL 容器和命名卷数据仍然保留，不需要重新导入 SQL。
- Windows 本机的 MySQL 8.0 服务仍可能自动运行在 `3306`，但本项目不使用它。

新对话如果需要重新确认状态，可执行：

```powershell
Get-NetTCPConnection -State Listen -LocalPort 8080,3307 -ErrorAction SilentlyContinue
Get-Process -Name 'Docker Desktop','com.docker.backend','java' -ErrorAction SilentlyContinue
```

## 4. 当前部署关系

```text
Windows 浏览器
    ↓ http://localhost:8080
Windows 上的 Spring Boot / Java 21
    ↓ jdbc:mysql://localhost:3307/diet_db
Docker Desktop + WSL 2
    ↓ 端口映射 127.0.0.1:3307 → 容器 3306
MySQL 8.4 Linux 容器
    ↓
Docker 命名卷 diet-agent-mysql-data
```

重要理解：

- 项目源码、IDEA、Java、Maven 和 Spring Boot 都运行在 Windows。
- 只有项目数据库运行在 Docker 的 Linux 容器中。
- Docker Desktop 使用 WSL 2 提供 Linux 内核能力。
- Spring Boot 通过 Windows 的 `localhost:3307` 访问容器里的 MySQL。
- 本机 MySQL 的 `3306` 与项目容器的 `3307` 互不冲突。

## 5. 已确认的本机环境

### Java

- Java 21 路径：`D:\jdk`

### IntelliJ IDEA

- IDEA 路径：`D:\idea\IntelliJ IDEA 2025.1.1.1`
- Spring Boot 不需要单独安装，它是项目 Maven 依赖的一部分。
- 启动类：`D:\学习项目\diet-agent\src\main\java\com\diet\DietApplication.java`

### Maven

- IDEA 内置 Maven 3.9.9：
  `D:\idea\IntelliJ IDEA 2025.1.1.1\plugins\maven\lib\maven3\bin\mvn.cmd`
- Maven 没有加入系统 PATH。
- 逻辑仓库路径：`C:\Users\28226\.m2\repository`
- 上述路径已经是目录联接，真实文件位于：`D:\MavenRepository`
- 已使用离线 Maven 构建验证成功。
- 不要删除 `C:\Users\28226\.m2\repository` 这个联接，也不要删除 `D:\MavenRepository`。

### PowerShell

- PowerShell 7.6.3：`D:\PowerShell\7\pwsh.exe`
- Windows PowerShell 5.1 仍保留。
- Codex 全局 `C:\Users\28226\.codex\AGENTS.md` 已要求优先使用 PowerShell 7。
- 新对话执行 Windows 命令时应明确使用 `D:\PowerShell\7\pwsh.exe`。

### WSL 2

- WSL 版本：2.7.11
- Ubuntu 虚拟磁盘：`D:\WSL\Ubuntu\ext4.vhdx`
- WSL 程序本体仍位于 C 盘的 `C:\Program Files\WSL`，这是正常情况。

### Docker Desktop

- Docker Desktop 4.84.0
- 程序路径：`D:\DockerDesktop`
- Docker 数据目录：`D:\DockerData`
- 主要数据虚拟磁盘：`D:\DockerData\disk\docker_data.vhdx`
- 此前只发现一个业务容器：`diet-agent-mysql`

## 6. 已完成的项目改动

### 6.1 Docker Compose

已创建：`D:\学习项目\diet-agent\compose.yaml`

主要配置：

- 镜像：`mysql:8.4`
- 容器名：`diet-agent-mysql`
- Windows 端口：`127.0.0.1:3307`
- 容器端口：`3306`
- 数据库：`diet_db`
- 用户：`root`
- 本地学习环境默认密码：`123456`
- 数据卷：`diet-agent-mysql-data`
- 初始化脚本：`src/main/resources/db/diet_db.sql`
- 已配置健康检查。

不要执行：

```powershell
docker compose down -v
```

其中 `-v` 会删除数据库数据卷。

### 6.2 Spring Boot 数据源

已修改：`D:\学习项目\diet-agent\src\main\resources\application.yml`

默认连接为：

```text
jdbc:mysql://localhost:3307/diet_db
用户名：root
密码：123456
```

同时支持环境变量覆盖：

- `DB_URL`
- `DB_USERNAME`
- `DB_PASSWORD`

### 6.3 数据库初始化验证

此前已经成功启动并验证：

- MySQL 版本：8.4.11
- 数据库：`diet_db`
- 表数量：6
- 槽位选项记录：91
- 餐食记录：5
- Windows 主机可通过 TCP `localhost:3307` 正常连接。

初始化 SQL 只会在空数据卷第一次创建时执行。已有数据卷再次启动不会重复导入。

### 6.4 Spring Boot 验证

此前已成功验证：

- Spring Boot 正常启动在 `8080`
- 首页返回 HTTP 200
- 槽位选项接口能够返回正确的中文数据
- 随后按照用户要求正常停止，未强制终止数据卷

## 7. 每次启动流程

### 第一步：启动 Docker Desktop

从开始菜单启动 Docker Desktop，等待 Docker Engine 就绪。

如果界面白屏，先用命令判断后台，不要重置数据：

```powershell
docker info
```

### 第二步：启动项目数据库

```powershell
Set-Location -LiteralPath 'D:\学习项目\diet-agent'
docker compose up -d
docker compose ps
```

等待 `diet-agent-mysql` 显示 `healthy`。

### 第三步：启动 Spring Boot

1. 用 IDEA 打开 `D:\学习项目\diet-agent`。
2. 等待 Maven 加载完成。
3. 打开 `src/main/java/com/diet/DietApplication.java`。
4. 点击绿色运行按钮，运行 `DietApplication`。
5. 等待控制台显示 Tomcat 已在 8080 启动。

### 第四步：访问

```text
http://localhost:8080
```

## 8. 停止流程

1. 在 IDEA Run 窗口点击红色停止按钮，停止 Spring Boot。
2. 再执行：

```powershell
Set-Location -LiteralPath 'D:\学习项目\diet-agent'
docker compose stop
```

如果本次不再使用任何 Docker 容器，可以正常退出 Docker Desktop。`docker compose stop` 和退出 Docker Desktop 都不会删除数据库数据。

## 9. Docker Desktop 白屏的既有诊断

之前出现过 Docker Desktop 整个窗口白屏。诊断结果为：

- Docker Engine 当时正常。
- MySQL 容器当时为 healthy。
- Electron 前端日志出现过 `Network service crashed or was terminated, restarting service`。
- 因此属于 Docker Desktop 图形界面/Electron 渲染异常，不是 MySQL、WSL 或数据损坏。

不要因为白屏执行：

- `Clean / Purge data`
- `Reset to factory defaults`
- 删除 `docker_data.vhdx`

先检查 `docker info`、`docker compose ps` 和容器日志。

## 10. 项目架构摘要

该项目是一个饮食推荐多 Agent 系统，主流程为：

```text
用户输入
  → IntentAgent 识别意图和抽取槽位
  → ClarifyAgent 在信息不足时生成追问文案
  → MySQL 根据槽位检索真实餐食
  → Java 规则进行候选重排
  → RecommendResponseAgent 或 PlanResponseAgent 生成自然语言回复
  → 健康风险规则进行最终拦截
  → 保存会话、消息、反馈和 Trace
```

核心编排器：`DietOrchestratorService`

主要 Agent：

- `IntentAgent`：意图识别和七维槽位抽取
- `ClarifyAgent`：生成澄清问题的自然语言文案
- `RecommendResponseAgent`：为 Top 3 候选生成理由和回复
- `PlanResponseAgent`：包装多餐规划回复
- `EvaluationJudgeAgent`：离线评估解释性与自然度

六类意图：

- `MEAL_RECOMMENDATION`
- `CLARIFY_NEEDED`
- `MEAL_ADJUST`
- `MEAL_PLAN`
- `HEALTH_RISK`
- `OTHER`

七维槽位：

- `mealTime`
- `mood`
- `scene`
- `healthGoal`
- `cuisine`
- `taste`
- `convenience`

数据库检索使用 MySQL JSON 条件，Java 对每个槽位的重合度打分并排序。大模型主要负责理解语言和组织表达，不应凭空决定数据库中不存在的餐食。

完整架构细节见：

`D:\学习项目\diet-agent\Diet Agent 项目架构与实现说明.md`

## 11. 这个项目是否使用 RAG

目前不是典型 RAG。

它更准确地属于：

```text
结构化数据库检索 → Java 排序 → 大模型生成解释
```

项目没有以下典型 RAG 组件：

- 文档切块
- Embedding 向量化
- 向量数据库
- 相似度向量检索
- 将外部文档片段注入上下文

如果后续要加入真正的 RAG，可以增加营养知识库、疾病饮食指南或菜谱文档检索，但这属于新功能，不要把现有 MySQL 检索误称为完整 RAG。

## 12. 当前最重要的未完成项：DeepSeek 适配

项目原版使用：

- `DashScopeChatModel`
- `qwen-max`
- `qwen-turbo`
- 配置项 `agentscope.dashscope.api-key`

用户拥有 DeepSeek API Key，但 DeepSeek Key 不能直接填入 DashScope Key 配置。当前尚未实现 DeepSeek 模型适配，因此：

- 数据库、页面和普通接口可以运行。
- 真正依赖大模型的聊天/Agent 功能不能直接用 DeepSeek Key 正常调用。
- 不要把用户的 DeepSeek Key 写入文档、源码或提交记录。

后续适配前应先检查 AgentScope Java 1.0.11 是否提供 OpenAI-compatible 模型实现；如果有，优先通过 DeepSeek 的 OpenAI 兼容接口接入，并保留主模型/轻量模型的角色划分。如果框架版本不支持，再设计最小模型适配器，不要大范围重写 Agent 编排。

## 13. 已发现但尚未修复的代码问题

这些问题只记录过，尚未得到用户授权实施修复：

1. `DietExceptionHandler` 使用的基础包似乎是 `com.diet.newdiet`，而 Controller 位于 `com.diet.controller`，全局异常处理可能没有覆盖实际 Controller。
2. 当前没有真实用户认证，`X-User-Id` 默认值为 1。
3. 每个 session 的同步锁保存在 `ConcurrentHashMap` 中，缺少生命周期清理，长期运行可能不断增长。
4. Feedback 没有明确绑定 `trace_id`，评估归因可能不够精确。
5. 项目中没有完整自动化测试。
6. API Key 应通过环境变量或安全配置注入，不应硬编码。

新对话不要擅自一次性修复全部问题，应先与用户确认下一步学习或改造目标。

## 14. 已生成的说明文档

项目目录中：

- `D:\学习项目\diet-agent\项目启动说明.md`
- `D:\学习项目\diet-agent\Diet Agent 项目架构与实现说明.md`
- `D:\学习项目\diet-agent\Diet Agent 项目交接文档.md`

桌面此前也有：

- `C:\Users\28226\Desktop\Diet Agent 项目启动说明.md`
- `C:\Users\28226\Desktop\Diet Agent 项目架构与实现说明.md`

本交接文档也应复制到桌面：

- `C:\Users\28226\Desktop\Diet Agent 项目交接文档.md`

## 15. 新对话建议的第一轮检查

新对话收到本文档后，建议按以下顺序执行只读检查：

1. 确认项目目录和关键文档存在。
2. 检查端口 8080、3307 是否监听。
3. 检查 Docker Desktop 和 Java 进程。
4. 检查 `compose.yaml` 与 `application.yml`，但输出时隐藏 API Key。
5. 明确用户下一步目标是运行项目、学习架构、适配 DeepSeek、修复代码还是增加 RAG。
6. 只有用户要求运行时，才启动 Docker 和 Spring Boot。

## 16. 交接给新 Codex 的简短提示词

用户可以把本文件发给新对话，并附上：

> 请完整阅读这份交接文档，以及文档中列出的启动说明和架构说明。先检查当前环境状态，不要覆盖现有文件，不要删除 Docker 数据卷，不要输出任何 API Key。然后根据我接下来的要求继续协助我学习和改造 Diet Agent 项目。

