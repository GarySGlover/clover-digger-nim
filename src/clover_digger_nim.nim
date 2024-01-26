import picostdlib
import picostdlib/hardware/spi

stdioInitAll()

echo "Setting col to out"
setupGpio(col, 8, Out)
col.put(Low)

type
  RegisterAddress {.size: sizeof(uint8).} = enum
    IoDirA
    IoDirB
    IPolA
    IPolB
    GpintentA
    GpintentB
    DefValA
    DefValB
    IntConA
    IntConB
    Iocon
    IoCon2
    GppuA
    GppuB
    IntfA
    IntfB
    IntcapA
    IntcapB
    GpioA
    GpioB
    OlatA
    OlatB

echo "Init SPI"
discard spi0.init(10000000)
spi0.setFormat(8, Pol0, Phase0, MsbFirst)
DefaultSpiSckPin.setFunction(Spi)
DefaultSpiTxPin.setFunction(Spi)
DefaultSpiRxPin.setFunction(Spi)

echo "Init CS"
DefaultSpiCsnPin.setFunction(Spi)
DefaultSpiCsnPin.init
DefaultSpiCsnPin.setDir(Out)
DefaultSpiCsnPin.put(High)

echo "Wait for SPI Writable"
while not spi0.isWritable:
  discard

echo "Set Iocon"
DefaultSpiCsnPin.put(Low)
discard spi0.writeBlocking(0x40u8, ord(Iocon), 0x0u8)
DefaultSpiCsnPin.put(High)

echo "Set GPA to in"
DefaultSpiCsnPin.put(Low)
discard spi0.writeBlocking(0x40u8, ord(IoDirA), 0xffu8)
DefaultSpiCsnPin.put(High)

echo "Set GPA to pull-up"
DefaultSpiCsnPin.put(Low)
discard spi0.writeBlocking(0x40u8, ord(GppuA), 0xffu8)
DefaultSpiCsnPin.put(High)

echo "Getting initial state"
var readState: uint8
DefaultSpiCsnPin.put(Low)
discard spi0.writeBlocking(0x41u8, ord(GpioA))
discard spi0.readBlocking(0, readState.addr, 1)
DefaultSpiCsnPin.put(High)
var state = readState

echo "Initial state is" & $readState

while true:
  DefaultSpiCsnPin.put(Low)
  discard spi0.writeBlocking(0x41u8, ord(GpioA))
  discard spi0.readBlocking(0, readState.addr, 1)
  DefaultSpiCsnPin.put(High)
  if state != readState:
     state = readState
     echo "Button changed to" & $readState
  sleepMs(2)
