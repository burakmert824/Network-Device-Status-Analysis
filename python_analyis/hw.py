import json
import csv
import csv
import json
import os

CSV_FILE_PATH = "Cards.csv"
OUTPUT_FILE_PATH = "Devices.html"
NEG_INF_TEMP = -50000

class Card:
    def __init__(self, name: str, temperature: int):
        self.name = name
        self.temperature = temperature


class Device:
    def __init__(self, name: str):
        self.name = name
        self.cards = []
        self.card_count = 0
        self.over_70_degrees_count = 0
        self.maximum_temperature_card = None
        
        self.sum_of_card_temperature = 0
        self.average_card_temperature = 0


    def add_card(self, card: Card):
        self.cards.append(card)
        self.card_count += 1
        self.sum_of_card_temperature += card.temperature
        
        if card.temperature > 70:
            self.over_70_degrees_count += 1
            
        if self.maximum_temperature_card == None or card.temperature > self.maximum_temperature_card.temperature:
            self.maximum_temperature_card = card
        
        self.average_card_temperature = self.sum_of_card_temperature / self.card_count


def find_device_statistics(devices: dict[str, Device]):
    total_card_count = 0
    max_temp_device = None
    max_temp_card = None
    max_temp = float('-inf')

    for device in devices.values():
        total_card_count += device.card_count
        
        if device.maximum_temperature_card.temperature > max_temp:
            max_temp = device.maximum_temperature_card.temperature
            max_temp_device = device
            max_temp_card = device.maximum_temperature_card

    statistics = {
        "total_devices":len(devices),
        "total_cards": total_card_count,
        "max_card_temperature": max_temp_card.temperature if max_temp_card else None,
        "hottest_card_device": max_temp_card.name+"/"+max_temp_device.name if max_temp_card and max_temp_device else None,
        }
    return statistics

def read_devices_from_csv(file_path: str):
    devices = {}
    with open(file_path, mode='r') as file:
        csv_reader = csv.DictReader(file, delimiter=';')
        for row in csv_reader:
            device_name = row['Device']
            card_name = row['Card']
            temperature = int(row['Temperature'])

            if device_name not in devices:
                devices[device_name] = Device(name=device_name)
            
            card = Card(name=card_name, temperature=temperature)
            devices[device_name].add_card(card)

    return devices

def generate_html(devices: dict[str,Device], statistics:dict,output_file: str):
    
    
    summary_table = f"""
    <table border="1">
        <tr><td>Total Devices</td><td>{statistics["total_devices"]}</td></tr>
        <tr><td>Total Cards</td><td>{statistics["total_cards"]}</td></tr>
        <tr><td>Max Card Temperature</td><td>{statistics["max_card_temperature"]}</td></tr>
        <tr><td>Hottest Card / Device</td><td>{statistics["hottest_card_device"]}</td></tr>
    </table>
    """

    rows = ""
    for device in devices.values():
        rows += f"""
        <tr>
            <td>{device.name}</td>
            <td>{device.card_count}</td>
            <td>{device.over_70_degrees_count}</td>
            <td>{device.maximum_temperature_card.temperature}</td>
            <td>{int(device.average_card_temperature)}</td>
        </tr>
        """
        

    devices_table = """
    <table border="1">
        <tr>
            <td>Device</td>
            <td>Total # of Cards</td>
            <td>High Temp. Cards #</td>
            <td>Max. Temperature</td>
            <td>Avg. Temperature</td>
        </tr>
        """+ rows +"""
    </table>
    """

    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Device Report</title>
    </head>
    <body>
        <h1>Summary</h1>
        {summary_table}
        <h1>Devices</h1>
        {devices_table}
        <p>(High Temperature >= 70)</p>
    </body>
    </html>
    """

    with open(output_file, 'w') as file:
        file.write(html_content)
        print(f"HTML report generated: {output_file}")



if __name__ == "__main__":
    try:
        devices = read_devices_from_csv(CSV_FILE_PATH)
        statistics = find_device_statistics(devices)
        for device_name, device in devices.items():
            print(device_name)
            print(device)
            
        print(statistics)
        generate_html(devices, statistics, OUTPUT_FILE_PATH)
        
    except Exception as e:
        print(f"An error occurred: {e}")
