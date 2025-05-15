import time
import random
import json
import paho.mqtt.client as mqtt

BROKER_ADDRESS = "test.mosquitto.org"
TOPIC = "graindoc/sensor"

def generate_data():
    return {
        "location": "Склад №1",
        "temperature": round(random.uniform(15, 30), 2),
        "humidity": round(random.uniform(40, 90), 2),
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
    }

client = mqtt.Client()
client.connect(BROKER_ADDRESS, 1883, 60)

print("Починаємо публікацію в MQTT...")

try:
    while True:
        data = generate_data()
        client.publish(TOPIC, json.dumps(data))
        print("Опубліковано:", data)
        time.sleep(5)
except KeyboardInterrupt:
    print("Зупинено вручну")
    client.disconnect()
