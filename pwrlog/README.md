# 🔋 pwrlog

A hardware-aware telemetry script designed for Termux to monitor overnight battery health and generate weekly reports.

## 📅 Cron Setup
To ensure the script runs daily at 00:00 and 06:00, follow these steps:

### 1. Install Requirements

```
pkg install cronie termux-api
```

### 2. Configure the Crontab
Open your crontab editor:

```
crontab -e
```

Add the following lines to schedule the script:

```
0 0 * * * /data/data/com.termux/files/home/termux-api-scripts/pwrlog/pwrlog.sh
0 6 * * * /data/data/com.termux/files/home/termux-api-scripts/pwrlog/pwrlog.sh
```

### 3. Start the Daemon
Cron does not start automatically in Termux. 
You must trigger it manually or add these lines to your `.bashrc`:

```
termux-wake-lock
crond
```

## Data
The report of average battery drain calculated weekly is sent via notification.
And also the script saves it to file in `/home/average_drain.txt`
