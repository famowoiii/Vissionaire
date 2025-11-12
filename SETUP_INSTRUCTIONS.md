# Construction Hazard Detection - Setup Instructions

## Quick Start (First Time Setup)

### Prerequisites
1. **Python 3.8+** - [Download here](https://www.python.org/downloads/)
2. **XAMPP** (for MySQL) - [Download here](https://www.apachefriends.org/)
3. **Redis** - [Windows Download](https://github.com/microsoftarchive/redis/releases)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Construction-Hazard-Detection
   ```

2. **Run First Time Setup**
   ```bash
   FIRST_TIME_SETUP.bat
   ```
   This script will:
   - Check Python installation
   - Install required packages
   - Check MySQL connection
   - Import database schema
   - Check Redis installation
   - Create .env configuration file

3. **Start the System**
   ```bash
   START_SYSTEM.bat
   ```
   This will:
   - Check MySQL and Redis are ready
   - Start all 5 backend API services
   - Start the detection service

4. **Access Web Interface**
   - Open: https://visionnaire-cda17.web.app
   - Login with default credentials:
     - Username: `user`
     - Password: `password`
   - Configure API URLs to use `127.0.0.1`

## Available Scripts

### Main Scripts

- **`START_SYSTEM.bat`** - Start all services with health checks (USE THIS!)
- **`STOP_SYSTEM.bat`** - Stop all running services
- **`FIRST_TIME_SETUP.bat`** - Initial setup for new installations
- **`CHECK_SYSTEM_HEALTH.bat`** - Verify all components are working

### Legacy Scripts (Still Available)

- `start_all_apis.bat` - Start only backend APIs
- `start_main_detection.bat` - Start only detection service

## Troubleshooting

### Issue: "Cannot connect to MySQL"

**Solution:**
1. Open XAMPP Control Panel
2. Start MySQL service
3. Verify MySQL is running on port 3306
4. Run `CHECK_SYSTEM_HEALTH.bat` to verify

### Issue: "Cannot connect to Redis"

**Solution:**
1. Start Redis server:
   ```bash
   redis-server
   ```
2. Or on Windows with WSL:
   ```bash
   wsl sudo service redis-server start
   ```
3. Verify Redis is running on port 6379

### Issue: "Labels not appearing in web interface"

**Root Cause:** Detection service started before MySQL was ready.

**Solution:**
1. Run `STOP_SYSTEM.bat`
2. Make sure MySQL is running
3. Run `START_SYSTEM.bat` again

### Issue: "Streaming video not showing"

**Checklist:**
- [ ] Detection service is running (check for Python processes)
- [ ] Redis has data (run `CHECK_SYSTEM_HEALTH.bat`)
- [ ] Streaming API (port 8800) is responding
- [ ] Web interface is using correct API URL (127.0.0.1:8800)

## System Architecture

### Services and Ports

| Service              | Port | Purpose                          |
|---------------------|------|----------------------------------|
| DB Management API   | 8005 | User, site, and stream management|
| Notification API    | 8003 | FCM push notifications           |
| Streaming Web API   | 8800 | Real-time video streaming        |
| Violation Records   | 8002 | Safety violation logging         |
| YOLO Detection API  | 8000 | Object detection inference       |

### Data Flow

```
YouTube Live Stream
    ↓
Detection Service (main.py)
    ↓
YOLO Detection API (8000)
    ↓
Streaming Web API (8800)
    ↓
Redis Cache
    ↓
Web Interface
```

## Startup Order (Automatic in START_SYSTEM.bat)

1. **MySQL** - Must be running first
2. **Redis** - Must be running second
3. **Backend APIs** - Started in sequence
4. **Detection Service** - Started last (reads config from MySQL)

⚠️ **IMPORTANT:** If detection starts before MySQL is ready, it will fail to read stream configurations and won't process any videos.

## Default Credentials

- **Username:** `user`
- **Password:** `password`
- **Role:** `admin`

## Environment Variables (.env)

```env
DATABASE_URL=mysql+asyncmy://root@127.0.0.1:3306/construction_hazard_detection
JWT_SECRET_KEY=your-super-secret-jwt-key-change-this-in-production
API_USERNAME=user
API_PASSWORD=password
DETECT_API_URL=http://127.0.0.1:8000
STREAMING_API_URL=http://127.0.0.1:8800
DB_MANAGEMENT_API_URL=http://127.0.0.1:8005
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_PASSWORD=
```

## Adding a New Stream

1. Login to web interface
2. Go to "Site Management" → Add site
3. Go to "Streaming Web Settings" → Add stream
4. Configure:
   - Stream name
   - Video URL (YouTube live stream)
   - Store in Redis: ✓ Enabled
   - Detection options
5. Detection service will automatically pick up new stream within 10 seconds

## Support

For issues or questions:
1. Run `CHECK_SYSTEM_HEALTH.bat` and share the output
2. Check `logs/monitor.log` for detection service logs
3. Open an issue on GitHub with details

## License

[Your License Here]
