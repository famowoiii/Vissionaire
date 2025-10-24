#!/bin/bash

################################################################################
# AUTOMATED SETUP SCRIPT FOR VAST.AI GPU INSTANCE
# Construction Hazard Detection System
################################################################################

set -e  # Exit on error

echo "========================================================================"
echo "  VAST.AI SETUP - Construction Hazard Detection"
echo "========================================================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

################################################################################
# STEP 1: System Dependencies
################################################################################

echo ""
echo "========================================================================"
echo "STEP 1: Installing System Dependencies"
echo "========================================================================"
echo ""

apt-get update -qq
apt-get upgrade -y -qq

print_info "Installing essential packages..."
apt-get install -y -qq \
    git \
    wget \
    curl \
    vim \
    nano \
    tmux \
    screen \
    htop \
    python3-pip \
    python3.10 \
    python3.10-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    redis-server \
    mysql-server \
    || { print_error "Failed to install system packages"; exit 1; }

print_success "System dependencies installed"

################################################################################
# STEP 2: Verify GPU
################################################################################

echo ""
echo "========================================================================"
echo "STEP 2: Verifying GPU"
echo "========================================================================"
echo ""

if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader
    print_success "GPU detected successfully"
else
    print_error "nvidia-smi not found! GPU may not be available"
    exit 1
fi

################################################################################
# STEP 3: Install PyTorch with CUDA
################################################################################

echo ""
echo "========================================================================"
echo "STEP 3: Installing PyTorch with CUDA Support"
echo "========================================================================"
echo ""

# Detect CUDA version
CUDA_VERSION=$(nvidia-smi | grep "CUDA Version" | awk '{print $9}' | cut -d. -f1,2)
print_info "Detected CUDA Version: $CUDA_VERSION"

# Install PyTorch based on CUDA version
if [[ "$CUDA_VERSION" == "12.1" ]] || [[ "$CUDA_VERSION" == "12.2" ]] || [[ "$CUDA_VERSION" == "12.3" ]]; then
    print_info "Installing PyTorch for CUDA 12.1..."
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 -q
elif [[ "$CUDA_VERSION" == "11.8" ]]; then
    print_info "Installing PyTorch for CUDA 11.8..."
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 -q
else
    print_warning "Unknown CUDA version, installing default PyTorch..."
    pip3 install torch torchvision torchaudio -q
fi

print_success "PyTorch installed"

################################################################################
# STEP 4: Clone Repository
################################################################################

echo ""
echo "========================================================================"
echo "STEP 4: Cloning Construction Hazard Detection Repository"
echo "========================================================================"
echo ""

cd /root

if [ -d "Construction-Hazard-Detection" ]; then
    print_warning "Repository already exists, pulling latest changes..."
    cd Construction-Hazard-Detection
    git pull
else
    print_info "Cloning repository..."
    git clone https://github.com/yihong1120/Construction-Hazard-Detection.git
    cd Construction-Hazard-Detection
fi

print_success "Repository ready at /root/Construction-Hazard-Detection"

################################################################################
# STEP 5: Install Python Dependencies
################################################################################

echo ""
echo "========================================================================"
echo "STEP 5: Installing Python Dependencies"
echo "========================================================================"
echo ""

pip3 install --upgrade pip -q

# Install from requirements.txt
if [ -f "requirements.txt" ]; then
    print_info "Installing from requirements.txt..."
    pip3 install -r requirements.txt -q
fi

# Install additional dependencies
print_info "Installing additional dependencies..."
pip3 install -q \
    opencv-python-headless \
    redis \
    mysql-connector-python \
    asyncmy \
    huggingface-hub \
    ultralytics \
    || { print_error "Failed to install Python dependencies"; exit 1; }

print_success "Python dependencies installed"

################################################################################
# STEP 6: Verify PyTorch CUDA
################################################################################

echo ""
echo "========================================================================"
echo "STEP 6: Verifying PyTorch CUDA Support"
echo "========================================================================"
echo ""

python3 << EOF
import torch
import sys

print(f"PyTorch Version: {torch.__version__}")
print(f"CUDA Available: {torch.cuda.is_available()}")

if torch.cuda.is_available():
    print(f"CUDA Version: {torch.version.cuda}")
    print(f"GPU Count: {torch.cuda.device_count()}")
    print(f"GPU Name: {torch.cuda.get_device_name(0)}")
    print(f"GPU Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.2f} GB")
else:
    print("ERROR: CUDA not available in PyTorch!")
    sys.exit(1)
EOF

if [ $? -eq 0 ]; then
    print_success "PyTorch CUDA verified successfully"
else
    print_error "PyTorch CUDA verification failed!"
    exit 1
fi

################################################################################
# STEP 7: Setup MySQL Database
################################################################################

echo ""
echo "========================================================================"
echo "STEP 7: Setting up MySQL Database"
echo "========================================================================"
echo ""

# Start MySQL
service mysql start
sleep 3

# Create database and user
print_info "Creating database and user..."
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS construction_hazard_detection;
CREATE USER IF NOT EXISTS 'hazard_user'@'localhost' IDENTIFIED BY 'hazard_password';
GRANT ALL PRIVILEGES ON construction_hazard_detection.* TO 'hazard_user'@'localhost';
FLUSH PRIVILEGES;
EOF

# Import schema
if [ -f "scripts/init.sql" ]; then
    print_info "Importing database schema..."
    mysql -u hazard_user -phazard_password construction_hazard_detection < scripts/init.sql
    print_success "Database schema imported"
else
    print_warning "scripts/init.sql not found, skipping schema import"
fi

print_success "MySQL database configured"

################################################################################
# STEP 8: Setup Redis
################################################################################

echo ""
echo "========================================================================"
echo "STEP 8: Setting up Redis"
echo "========================================================================"
echo ""

# Start Redis
redis-server --daemonize yes --bind 127.0.0.1 --port 6379

# Test Redis
sleep 2
if redis-cli ping | grep -q "PONG"; then
    print_success "Redis server running"
else
    print_error "Redis server failed to start"
    exit 1
fi

################################################################################
# STEP 9: Configure Environment Variables
################################################################################

echo ""
echo "========================================================================"
echo "STEP 9: Configuring Environment Variables"
echo "========================================================================"
echo ""

# Create .env file if not exists
if [ ! -f ".env" ]; then
    print_info "Creating .env file..."
    cat > .env << 'ENVEOF'
# Database Configuration
DATABASE_URL='mysql+asyncmy://hazard_user:hazard_password@127.0.0.1:3306/construction_hazard_detection'

# Redis Configuration
REDIS_HOST='127.0.0.1'
REDIS_PORT=6379
REDIS_PASSWORD=

# API Credentials
API_USERNAME='user'
API_PASSWORD='password'

# API URLs
DETECT_API_URL='http://127.0.0.1:8000'
FCM_API_URL='http://127.0.0.1:8003'
VIOLATION_RECORD_API_URL='http://127.0.0.1:8002'
STREAMING_API_URL='http://127.0.0.1:8800'
DB_MANAGEMENT_API_URL='http://127.0.0.1:8005'

# Model Configuration
MODEL_PATH='models/pt/best_yolo11n.pt'
USE_GPU=True
ENVEOF
    print_success ".env file created"
else
    print_warning ".env file already exists, skipping..."
fi

################################################################################
# STEP 10: Download YOLO Models
################################################################################

echo ""
echo "========================================================================"
echo "STEP 10: Downloading YOLO Models"
echo "========================================================================"
echo ""

if [ ! -f "models/pt/best_yolo11n.pt" ]; then
    print_info "Downloading YOLO11 models from Hugging Face..."
    huggingface-cli download yihong1120/Construction-Hazard-Detection-YOLO11 \
        --repo-type model \
        --include "models/pt/*.pt" \
        --local-dir . \
        || { print_warning "Failed to download models, continuing..."; }

    if [ -f "models/pt/best_yolo11n.pt" ]; then
        print_success "YOLO models downloaded successfully"
        ls -lh models/pt/
    else
        print_warning "YOLO models not found, you may need to download manually"
    fi
else
    print_success "YOLO models already exist"
    ls -lh models/pt/
fi

################################################################################
# STEP 11: Create Service Startup Scripts
################################################################################

echo ""
echo "========================================================================"
echo "STEP 11: Creating Service Startup Scripts"
echo "========================================================================"
echo ""

# Create start_all_services.sh
cat > start_all_services.sh << 'SERVICEEOF'
#!/bin/bash

echo "Starting Construction Hazard Detection Services..."

# Start Redis
redis-server --daemonize yes --bind 127.0.0.1 --port 6379
echo "✅ Redis started"

# Start MySQL
service mysql start
echo "✅ MySQL started"

# Wait for services
sleep 5

# Create log directory
mkdir -p /var/log/hazard_detection

cd /root/Construction-Hazard-Detection

# Start YOLO API (Port 8000)
cd examples/YOLO_server_api
nohup python main.py > /var/log/hazard_detection/yolo_api.log 2>&1 &
echo "✅ YOLO API started (port 8000)"

# Start Violation Record API (Port 8002)
cd ../violation-record-api
nohup uvicorn main:app --host 0.0.0.0 --port 8002 > /var/log/hazard_detection/violation_api.log 2>&1 &
echo "✅ Violation Record API started (port 8002)"

# Start FCM API (Port 8003)
cd ../fcm-api
nohup uvicorn main:app --host 0.0.0.0 --port 8003 > /var/log/hazard_detection/fcm_api.log 2>&1 &
echo "✅ FCM API started (port 8003)"

# Start DB Management API (Port 8005)
cd ../user-management-api
nohup uvicorn main:app --host 0.0.0.0 --port 8005 > /var/log/hazard_detection/db_api.log 2>&1 &
echo "✅ DB Management API started (port 8005)"

# Start Streaming API (Port 8800)
cd ../streaming-web-api
nohup uvicorn main:app --host 0.0.0.0 --port 8800 > /var/log/hazard_detection/streaming_api.log 2>&1 &
echo "✅ Streaming API started (port 8800)"

sleep 10

echo ""
echo "========================================================================"
echo "All services started successfully!"
echo "========================================================================"
echo ""
echo "Logs available at: /var/log/hazard_detection/"
echo ""
echo "Check status with: ps aux | grep python"
echo "View logs with: tail -f /var/log/hazard_detection/*.log"
echo ""
SERVICEEOF

chmod +x start_all_services.sh
print_success "Service startup script created"

# Create stop_all_services.sh
cat > stop_all_services.sh << 'STOPEOF'
#!/bin/bash

echo "Stopping all services..."

pkill -f "python main.py"
pkill -f "uvicorn"
redis-cli shutdown
service mysql stop

echo "✅ All services stopped"
STOPEOF

chmod +x stop_all_services.sh
print_success "Service stop script created"

################################################################################
# STEP 12: Create GPU Performance Test Script
################################################################################

echo ""
echo "========================================================================"
echo "STEP 12: Creating GPU Performance Test Script"
echo "========================================================================"
echo ""

cat > test_gpu_performance.py << 'TESTEOF'
#!/usr/bin/env python3

import torch
import cv2
import time
import sys
from pathlib import Path

try:
    from ultralytics import YOLO
except ImportError:
    print("ERROR: ultralytics not installed. Run: pip install ultralytics")
    sys.exit(1)

def test_gpu_performance():
    print("="*70)
    print("GPU PERFORMANCE TEST - Construction Hazard Detection")
    print("="*70)
    print()

    # Check CUDA
    if not torch.cuda.is_available():
        print("❌ ERROR: CUDA not available!")
        print("   Please install PyTorch with CUDA support")
        return False

    print(f"✅ CUDA Available: {torch.cuda.is_available()}")
    print(f"✅ GPU: {torch.cuda.get_device_name(0)}")
    print(f"✅ CUDA Version: {torch.version.cuda}")
    print(f"✅ GPU Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.2f} GB")
    print()

    # Load YOLO model
    model_path = 'models/pt/best_yolo11n.pt'

    if not Path(model_path).exists():
        print(f"❌ ERROR: Model not found at {model_path}")
        print("   Please download models first")
        return False

    print(f"Loading YOLO model from {model_path}...")
    model = YOLO(model_path)
    model.to('cuda')
    print("✅ Model loaded on GPU")
    print()

    # Create dummy frames for testing
    print("Creating test frames (640x640)...")
    test_frame = torch.randint(0, 255, (640, 640, 3), dtype=torch.uint8).numpy()
    print("✅ Test frames ready")
    print()

    # Warmup
    print("Warming up GPU (first inference is always slower)...")
    _ = model(test_frame, verbose=False)
    torch.cuda.synchronize()
    print("✅ Warmup complete")
    print()

    # Benchmark
    num_frames = 100
    print(f"Running inference benchmark on {num_frames} frames...")
    print("-"*70)

    inference_times = []

    for i in range(num_frames):
        start_time = time.time()
        results = model(test_frame, verbose=False)
        torch.cuda.synchronize()  # Wait for GPU to finish
        inference_time = time.time() - start_time

        inference_times.append(inference_time)

        if (i + 1) % 10 == 0:
            avg_time = sum(inference_times) / len(inference_times)
            avg_fps = 1.0 / avg_time
            print(f"Frame {i+1:3d}/{num_frames}: {inference_time*1000:6.2f}ms | Avg: {avg_time*1000:6.2f}ms | FPS: {avg_fps:5.2f}")

    # Results
    avg_time = sum(inference_times) / len(inference_times)
    min_time = min(inference_times)
    max_time = max(inference_times)
    avg_fps = 1.0 / avg_time

    print()
    print("="*70)
    print("PERFORMANCE RESULTS")
    print("="*70)
    print(f"Total Frames:           {num_frames}")
    print(f"Average Inference Time: {avg_time*1000:.2f}ms per frame")
    print(f"Min Inference Time:     {min_time*1000:.2f}ms")
    print(f"Max Inference Time:     {max_time*1000:.2f}ms")
    print(f"Average FPS:            {avg_fps:.2f}")
    print()

    # Evaluation
    if avg_fps >= 25:
        print("✅ EXCELLENT! Real-time capable (>25 FPS)")
        print("   Status: SIAP UNTUK KOMPETISI!")
        status = True
    elif avg_fps >= 20:
        print("✅ GOOD! Real-time capable (20-25 FPS)")
        print("   Status: Siap untuk kompetisi")
        status = True
    elif avg_fps >= 15:
        print("⚠️  ACCEPTABLE (15-20 FPS)")
        print("   Status: Masih bisa digunakan, tapi kurang optimal")
        status = True
    elif avg_fps >= 10:
        print("⚠️  MARGINAL (10-15 FPS)")
        print("   Status: Butuh optimasi (reduce resolution atau gunakan TensorRT)")
        status = False
    else:
        print("❌ TOO SLOW (<10 FPS)")
        print("   Status: Perlu GPU lebih kuat atau optimasi agresif")
        status = False

    print("="*70)
    print()

    # GPU Memory
    print("GPU MEMORY USAGE:")
    print(f"  Allocated: {torch.cuda.memory_allocated() / 1e9:.2f} GB")
    print(f"  Reserved:  {torch.cuda.memory_reserved() / 1e9:.2f} GB")
    print()

    return status

if __name__ == "__main__":
    success = test_gpu_performance()
    sys.exit(0 if success else 1)
TESTEOF

chmod +x test_gpu_performance.py
print_success "GPU performance test script created"

################################################################################
# FINAL SUMMARY
################################################################################

echo ""
echo "========================================================================"
echo "  SETUP COMPLETED SUCCESSFULLY!"
echo "========================================================================"
echo ""
print_success "Construction Hazard Detection system is ready!"
echo ""
echo "Next steps:"
echo ""
echo "1. Test GPU performance:"
echo "   cd /root/Construction-Hazard-Detection"
echo "   python3 test_gpu_performance.py"
echo ""
echo "2. Start all services:"
echo "   ./start_all_services.sh"
echo ""
echo "3. Run detection:"
echo "   python3 main.py --config config/test_stream.json"
echo ""
echo "4. Monitor GPU:"
echo "   watch -n 1 nvidia-smi"
echo ""
echo "5. View logs:"
echo "   tail -f /var/log/hazard_detection/*.log"
echo ""
echo "========================================================================"
echo "Installation log saved to: /root/vastai_setup.log"
echo "========================================================================"
echo ""

print_success "All done! Good luck with your competition! 🚀"
