#!/bin/bash
# =============================================================================
# Kiosk Permissions Setup Script
# =============================================================================
#
# This script configures the necessary system permissions for the Flutter Kiosk
# application running on a Raspberry Pi 5 with Touch Display 2.
#
# It sets up:
#   1. udev rule for backlight access (display sleep/wake)
#   2. udev rule for RTC wake alarm access (scheduled deep sleep)
#   3. sudoers entry for passwordless shutdown (deep sleep shutdown)
#
# USAGE:
#   sudo bash scripts/setup_kiosk_permissions.sh
#
# INSTALLATION (systemd service):
#   1. Copy the service file:
#      sudo cp scripts/kiosk-app.service /etc/systemd/system/kiosk-app.service
#
#   2. Reload systemd daemon:
#      sudo systemctl daemon-reload
#
#   3. Enable the service (auto-start on boot):
#      sudo systemctl enable kiosk-app.service
#
#   4. Start the service:
#      sudo systemctl start kiosk-app.service
#
#   5. Check status:
#      sudo systemctl status kiosk-app.service
#
#   6. View logs:
#      journalctl -u kiosk-app.service -f
#
# NOTES:
#   - This script must be run as root (sudo)
#   - A reboot is recommended after running this script for udev rules to
#     take full effect
#   - The service runs as the 'pi' user and expects the app binary at:
#     /home/pi/kiosk-app/build/linux/arm64/release/bundle/sample_latest
#
# =============================================================================

set -e

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root (use sudo)"
    exit 1
fi

KIOSK_USER="pi"

echo "=== Kiosk Permissions Setup ==="
echo ""

# -----------------------------------------------------------------------------
# 1. Backlight udev rule
# -----------------------------------------------------------------------------
# Grants the 'pi' user write access to the Raspberry Pi Touch Display backlight
# sysfs interface. This allows the kiosk app to turn the display on/off without
# requiring root privileges.

echo "[1/3] Creating backlight udev rule..."

cat > /etc/udev/rules.d/99-backlight.rules << 'EOF'
# Allow the 'pi' user to control the Raspberry Pi Touch Display backlight
# This grants write access to bl_power (on/off) and brightness (0-255)
SUBSYSTEM=="backlight", KERNEL=="rpi_backlight", RUN+="/bin/chmod 0666 /sys/class/backlight/rpi_backlight/bl_power /sys/class/backlight/rpi_backlight/brightness"
EOF

echo "  Created /etc/udev/rules.d/99-backlight.rules"

# -----------------------------------------------------------------------------
# 2. RTC wake alarm udev rule
# -----------------------------------------------------------------------------
# Grants write access to the RTC wake alarm interface. This allows the kiosk app
# to program a wake-up time before initiating system shutdown (scheduled deep
# sleep feature).

echo "[2/3] Creating RTC wake alarm udev rule..."

cat > /etc/udev/rules.d/99-rtc.rules << 'EOF'
# Allow the 'pi' user to set RTC wake alarms for scheduled deep sleep
# The wakealarm file accepts epoch seconds for the next wake-up time
SUBSYSTEM=="rtc", KERNEL=="rtc0", RUN+="/bin/chmod 0666 /sys/class/rtc/rtc0/wakealarm"
EOF

echo "  Created /etc/udev/rules.d/99-rtc.rules"

# -----------------------------------------------------------------------------
# 3. Sudoers entry for shutdown
# -----------------------------------------------------------------------------
# Allows the 'pi' user to execute the shutdown command without a password prompt.
# This is required for the scheduled deep sleep feature to initiate system
# shutdown from the unprivileged kiosk app process.

echo "[3/3] Creating sudoers entry for shutdown..."

cat > /etc/sudoers.d/kiosk-shutdown << EOF
# Allow the kiosk user to shut down the system without a password
# Used by the scheduled deep sleep feature
${KIOSK_USER} ALL=(ALL) NOPASSWD: /sbin/shutdown
EOF

# Secure the sudoers file permissions
chmod 0440 /etc/sudoers.d/kiosk-shutdown

echo "  Created /etc/sudoers.d/kiosk-shutdown"

# -----------------------------------------------------------------------------
# Reload udev rules
# -----------------------------------------------------------------------------

echo ""
echo "Reloading udev rules..."
udevadm control --reload-rules
udevadm trigger

echo ""
echo "=== Setup Complete ==="
echo ""
echo "A reboot is recommended for all changes to take full effect:"
echo "  sudo reboot"
echo ""
echo "To install the systemd service, run:"
echo "  sudo cp scripts/kiosk-app.service /etc/systemd/system/"
echo "  sudo systemctl daemon-reload"
echo "  sudo systemctl enable kiosk-app.service"
echo "  sudo systemctl start kiosk-app.service"
