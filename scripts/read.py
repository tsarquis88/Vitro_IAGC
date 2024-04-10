import json
import traceback
import sys

# 1 - Reference raw amplitude low
# 2 - Reference raw amplitude high
# 3 - Error raw amplitude low
# 4 - Error raw amplitude high
# 5 - Quotient
# 6 - Fractional
# 7 - In phase
DATA_AMOUNT = 7

def parseFixedPoint(data):
    binStr = bin(data)
    binStr = binStr[2:] # Remove '0b'
    idx = len(binStr) - 1
    powIdx = 8
    floatValue = 0.0
    while idx >= 0:
        floatValue += int(binStr[idx]) * pow(2, -(powIdx))
        idx -= 1
        powIdx -= 1
    return floatValue

class IagcData:

    json_data: json

    def __init__(self, raw_data) -> None:
        data = {}
        data['reference_amplitude'] = raw_data[0] + (raw_data[1] << 8)
        data['error_amplitude'] = raw_data[2] + (raw_data[3] << 8)
        data['reference_voltage'] = float("{:.5f}".format(data['reference_amplitude'] * 0.13e-3))
        data['error_voltage'] = float("{:.5f}".format(data['error_amplitude'] * 0.13e-3))
        data['relation'] = raw_data[4] + parseFixedPoint(raw_data[5])
        data['in_phase'] = True if raw_data[6] == 1 else False

        self.json_data = json.dumps(data, sort_keys=True, indent=4)
    
    def print(self) -> None:
        print(self.json_data)

def main():
    try:
        while(True):
            content = open("/dev/ttyUSB0", "rb").read(DATA_AMOUNT)
            IagcData(content).print()
    except KeyboardInterrupt:
        pass
    except Exception:
        traceback.print_exc(file=sys.stdout)
    sys.exit(0)

if __name__ == "__main__":
    main()
