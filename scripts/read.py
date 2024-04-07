class IagcData:

    amp_ref: int
    amp_err: int
    vol_ref: float
    vol_err: float
    quotient : int
    fractional : int
    in_phase : int

    def __init__(self, raw_data) -> None:
        self.amp_ref = raw_data[0] + (raw_data[1] << 8)
        self.amp_err = raw_data[2] + (raw_data[3] << 8)
        self.vol_ref = self.amp_ref * 0.13e-3
        self.vol_err = self.amp_err * 0.13e-3
        self.quotient = raw_data[4]
        self.fractional = raw_data[5]
        self.in_phase = raw_data[6]
    
    def print(self) -> None:
        print("REF: " + str(self.amp_ref))
        print("ERR: " + str(self.amp_err))
        print("REF [V]: " + str(self.vol_ref))
        print("ERR [V]: " + str(self.vol_err))
        print("QUOTIENT: " + str(self.quotient))
        print("FRACTIONAL: " + str(self.fractional))
        print("PHASE: " + str(self.in_phase))

file = open("/dev/ttyUSB0", "rb")

while(True):
    content = file.read(7)
    IagcData(content).print()