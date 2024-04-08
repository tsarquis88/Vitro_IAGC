import json

# 1 - Reference raw amplitude low
# 2 - Reference raw amplitude high
# 3 - Error raw amplitude low
# 4 - Error raw amplitude high
# 5 - Quotient
# 6 - Fractional
# 7 - In phase
DATA_AMOUNT = 7

class IagcData:

    json_data: json

    def __init__(self, raw_data) -> None:
        data = {}
        data['reference_amplitude'] = (raw_data[0] >> 2) + (raw_data[1] << 6)
        data['error_amplitude'] = (raw_data[2] >> 2) + (raw_data[3] << 6)
        data['reference_voltage'] = data['reference_amplitude'] * 0.13e-3
        data['error_voltage'] = data['error_amplitude'] * 0.13e-3
        data['quotient'] = raw_data[4]
        data['fractional'] = raw_data[5]
        data['in_phase'] = True if raw_data[6] == 1 else False

        self.json_data = json.dumps(data, sort_keys=True, indent=4)
    
    def print(self) -> None:
        print(self.json_data)

file = open("/dev/ttyUSB0", "rb")

while(True):
    content = file.read(DATA_AMOUNT)
    IagcData(content).print()





