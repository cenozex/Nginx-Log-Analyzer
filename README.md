<div align="center">

# 🔍 Nginx Log Analyzer

### Project #5 — A powerful Bash script to analyze Nginx access logs

[![Shell Script](https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS-lightgrey?style=for-the-badge&logo=linux&logoColor=white)]()
[![Roadmap](https://img.shields.io/badge/Roadmap-roadmap.sh-ff4e1a?style=for-the-badge)](https://roadmap.sh/projects/nginx-log-analyser)

> Quickly surface the most important insights from your Nginx access logs — top IPs, paths, status codes, and user agents — straight from your terminal.

🔗 **Project Reference:** [https://roadmap.sh/projects/nginx-log-analyser](https://roadmap.sh/projects/nginx-log-analyser)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Sample Output](#-sample-output)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Usage](#-usage)
- [How It Works](#-how-it-works)
- [Script Breakdown](#-script-breakdown)
- [Example Log Format](#-example-log-format)
- [Configuration](#-configuration)
- [Contributing](#-contributing)

---

## 🌟 Overview

**Nginx Log Analyzer** is a lightweight, dependency-free Bash script that parses standard Nginx access log files and reports the top patterns across four key dimensions: IP addresses, requested paths, HTTP status codes, and user agents.

It's ideal for server administrators, developers, and DevOps engineers who want a fast, terminal-native way to understand their server traffic without needing to install heavy log management tools.

---

## ✨ Features

- 🌐 **Top IPs** — Identify which clients are hitting your server the most
- 🛣️ **Top Paths** — See which endpoints or routes receive the highest traffic
- 📊 **Status Codes** — Quickly spot error spikes (4xx, 5xx) vs healthy traffic (2xx)
- 🤖 **User Agents** — Detect bots, scrapers, or unusual clients
- 🎨 **Color-coded Output** — Clean, readable terminal output using ANSI colors
- ⚡ **Zero Dependencies** — Uses only standard Unix tools: `awk`, `grep`, `sort`, `uniq`
- 🔧 **Configurable Count** — Easily adjust how many top results to display

---

## 🖥️ Sample Output

```
────────────────────────────────────────────────────
   Nginx Log Analyzer
────────────────────────────────────────────────────

────────────────────────────────────────────────────
   Top 5 IP addresses with the most requests
────────────────────────────────────────────────────
178.128.94.113 - 450 requests
142.93.136.176 - 448 requests
138.68.248.85  - 446 requests
159.89.185.30  - 432 requests
36.141.34.62   - 87 requests

────────────────────────────────────────────────────
   Top 5 most requested paths
────────────────────────────────────────────────────
/v1-health - 1320 requests
/v1-me - 214 requests
/v1-list-workspaces - 198 requests
/v1-list-projects - 176 requests
/.env - 94 requests

────────────────────────────────────────────────────
   Top 5 response status codes
────────────────────────────────────────────────────
200 - 2847 requests
304 - 612 requests
404 - 389 requests
400 - 201 requests
405 - 12 requests

────────────────────────────────────────────────────
   Top 5 user agents
────────────────────────────────────────────────────
DigitalOcean Uptime Probe 0.22.0 - 1320 requests
Mozilla/5.0 Chrome/129.0.0.0 Safari/537.36 - 834 requests
...
```

---

## ✅ Prerequisites

This script requires only standard Unix utilities — no installation needed beyond a Bash shell.

| Tool   | Purpose                        | Availability        |
|--------|--------------------------------|---------------------|
| `bash` | Script interpreter             | All Unix systems    |
| `awk`  | Field parsing & formatting     | All Unix systems    |
| `grep` | Pattern matching               | All Unix systems    |
| `sort` | Sorting results                | All Unix systems    |
| `uniq` | Counting unique occurrences    | All Unix systems    |
| `head` | Limiting output to top N       | All Unix systems    |

---

## 📦 Installation

**1. Clone the repository:**

```bash
git clone https://github.com/cenozex/Nginx-Log-Analyzer.git
cd Nginx-Log-Analyzer
```

**2. Make the script executable:**

```bash
chmod +x log-analyzer.sh
```

**3. Place your Nginx log file** in the same directory and name it `logfile.txt`, or edit the script to point to your log path.

---

## 🚀 Usage

```bash
./log-analyzer.sh
```

The script will automatically read from `logfile.txt` in the current directory and print a formatted analysis to your terminal.

### Custom log file path

To analyze a different log file, edit the script and replace `logfile.txt` with your path:

```bash
# Example: point to your actual Nginx log
awk '{print $1}' /var/log/nginx/access.log | ...
```

---

## ⚙️ How It Works

The script processes the log file in **four passes**, each extracting a different dimension of data using `awk`, `grep`, `sort`, and `uniq -c`.

```
logfile.txt
     │
     ├──► awk '{print $1}'           ──► Top IPs
     │
     ├──► awk '{print $7}'           ──► Top Paths
     │
     ├──► grep -oE ' [1-5][0-9]{2} ' ──► Top Status Codes
     │
     └──► awk -F'"' '{print $6}'     ──► Top User Agents
```

Each pass pipes through `sort | uniq -c | sort -nr | head -n N` to rank results by frequency.

---

## 🧩 Script Breakdown

```bash
# Configurable result count
COUNTS=5

# Section 1: Top IPs — extract field 1 (IP address)
awk '{print $1}' logfile.txt | sort | uniq -c | sort -nr \
  | awk '{print $2 " - " $1 " requests"}' | head -n ${COUNTS}

# Section 2: Top Paths — extract field 7 (request path)
awk '{print $7}' logfile.txt | sort | uniq -c | sort -nr \
  | awk '{print $2 " - " $1 " requests"}' | head -n ${COUNTS}

# Section 3: Status Codes — regex match 3-digit HTTP codes
grep -oE ' [1-5][0-9]{2} ' logfile.txt | sort | uniq -c | sort -rn \
  | awk '{print $2 " - " $1 " requests"}' | head -n ${COUNTS}

# Section 4: User Agents — extract 6th double-quoted field
awk -F'"' '{print $6}' logfile.txt | sort | uniq -c | sort -nr \
  | awk '{for(i=2;i<=NF;i++) printf "%s ", $i; print "-",$1,"requests"}' \
  | head -n ${COUNTS}
```

---

## 📄 Example Log Format

The script expects standard **Nginx combined log format**:

```
152.58.26.123 - - [04/Oct/2024:03:13:48 +0000] "POST /v1-github-login HTTP/1.1" 200 339 "https://time.fyi/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
```

| Field      | Position  | Example Value              |
|------------|-----------|----------------------------|
| IP         | `$1`      | `152.58.26.123`            |
| Date       | `$4`      | `[04/Oct/2024:03:13:48`    |
| Method     | `$6`      | `POST`                     |
| Path       | `$7`      | `/v1-github-login`         |
| Status     | `$9`      | `200`                      |
| Referrer   | `"$5"`    | `https://time.fyi/`        |
| User Agent | `"$6"`    | `Mozilla/5.0 ...`          |

---

## 🔧 Configuration

You can change the number of top results shown by editing the `COUNTS` variable at the top of the script:

```bash
# Show top 10 results instead of 5
COUNTS=10
```


---

<div align="center">

Project #5 on [roadmap.sh](https://roadmap.sh/projects/nginx-log-analyser)

</div>
