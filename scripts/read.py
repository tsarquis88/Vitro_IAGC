# Lectura de datos desde FPGA y parseo de los mismos.
# Nota: Para obtener una lectura correcta desde los puertos, puede ser necesario antes ejecutar 'screen <dispotivo>'.

import traceback
import sys


def getBit(byte, bitPosFromLsb):
    binData = bin(byte)
    bit = binData[len(binData) - bitPosFromLsb - 1]
    if bit == 'b':
        return 0
    else:
        return int(bit)


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


def parseIagcData(raw_data, verbose=False):
    BYTE_REF_AMP_L = 0
    BYTE_REF_AMP_H = 1
    BYTE_ERR_AMP_L = 2
    BYTE_ERR_AMP_H = 3
    BYTE_QUOTIENT = 4
    BYTE_FRACTIONAL = 5
    BYTE_MISC = 6

    if verbose:
        return {
            # Valores analogicos se obtienen multiplicando por 0.13e-3
            'reference': raw_data[BYTE_REF_AMP_L] + (raw_data[BYTE_REF_AMP_H] << 8),
            'error': raw_data[BYTE_ERR_AMP_L] + (raw_data[BYTE_ERR_AMP_H] << 8),

            'relation': raw_data[BYTE_QUOTIENT] + parseFixedPoint(raw_data[BYTE_FRACTIONAL]),
            'inPhase': True if getBit(raw_data[BYTE_MISC], 0) == 1 else False,
            'valid': True if getBit(raw_data[BYTE_MISC], 1) == 1 else False
        }
    else:
        inPhaseCoeficient = 1 if getBit(raw_data[BYTE_MISC], 0) == 1 else -1
        return {

            'relation': (raw_data[BYTE_QUOTIENT] + parseFixedPoint(raw_data[BYTE_FRACTIONAL])) * inPhaseCoeficient,
            'valid': True if getBit(raw_data[BYTE_MISC], 1) == 1 else False
        }


def readIagcData(device):
    DATA_AMOUNT = 7
    return open(device, "rb").read(DATA_AMOUNT)


def main():
    try:
        if len(sys.argv) == 1:
            print("Uso: " + sys.argv[0] + " <dispositivo>")
            sys.exit(1)
        device = sys.argv[1]

        while(True):
            print(parseIagcData(readIagcData(device), True))
    except KeyboardInterrupt:
        pass
    except Exception:
        traceback.print_exc(file=sys.stdout)
    sys.exit(0)

if __name__ == "__main__":
    main()
