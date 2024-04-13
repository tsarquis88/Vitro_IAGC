# Lectura de datos desde FPGA y parseo de los mismos.
# Nota: Para obtener una lectura correcta desde los puertos, puede ser necesario antes ejecutar 'screen <dispotivo>'.

import traceback
import sys

def parseFixedPoint(data):
    binStr = bin(data)
    idx = len(binStr) - 1
    powIdx = 8
    floatValue = 0.0
    while 'b' != binStr[idx]:
        floatValue += int(binStr[idx]) * pow(2, -(powIdx))
        idx -= 1
        powIdx -= 1
    return floatValue

def parseIagcData(raw_data):
    return {
        # Valores analogicos se obtienen multiplicando por 0.13e-3
        'reference_amplitude': raw_data[0] + (raw_data[1] << 8),
        'error_amplitude': raw_data[2] + (raw_data[3] << 8),

        'relation': raw_data[4] + parseFixedPoint(raw_data[5]),
        'in_phase': True if raw_data[6] == 1 else False,
    }

def readIagcData(device):
    # 1 - Amplitud referencia L
    # 2 - Amplitud referencia H
    # 3 - Amplitude error L
    # 4 - Amplitude error H
    # 5 - Cociente
    # 6 - Fraccional
    # 7 - Fase
    DATA_AMOUNT = 7
    return open(device, "rb").read(DATA_AMOUNT)

def main():
    try:
        if len(sys.argv) == 1:
            print("Uso: " + sys.argv[0] + " <dispositivo>")
            sys.exit(1)
        device = sys.argv[1]

        while(True):
            print(parseIagcData(readIagcData(device)))
    except KeyboardInterrupt:
        pass
    except Exception:
        traceback.print_exc(file=sys.stdout)
    sys.exit(0)

if __name__ == "__main__":
    main()
