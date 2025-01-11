#!/usr/bin/bash

pip install netmiko

# Python execution script for configuring SNMP on Cisco switches

python3 <<EOF
from netmiko import ConnectHandler
from concurrent.futures import ThreadPoolExecutor

# اطلاعات دستگاه‌ها
devices = [
    {
        'device_type': 'cisco_ios',
        'host': '192.168.1.1',
        'username': 'admin',
        'password': 'password',
    },
    {
        'device_type': 'cisco_ios',
        'host': '192.168.1.2',
        'username': 'admin',
        'password': 'password',
    },
    # سوئیچ‌های دیگر را اضافه کنید
]

# دستورات تنظیم SNMP
commands_to_run = [
    "snmp-server community @dmi1234 RO",
]

# تابع برای اتصال و اجرای دستورات
def configure_device(device):
    try:
        print(f"Connecting to {device['host']}...")
        connection = ConnectHandler(**device)
        
        # اجرای دستورات
        output = connection.send_config_set(commands_to_run)
        print(f"Configuration applied on {device['host']}:\n{output}")
        
        connection.save_config()  # ذخیره تنظیمات
        connection.disconnect()
    except Exception as e:
        print(f"Error connecting to {device['host']}: {e}")

# اجرای تنظیمات به صورت همزمان
with ThreadPoolExecutor(max_workers=5) as executor:
    executor.map(configure_device, devices)
EOF
