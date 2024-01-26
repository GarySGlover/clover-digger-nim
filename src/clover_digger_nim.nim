import picostdlib
import picostdlib/hardware/spi

stdioInitAll()

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

echo "Set GPA to out"
DefaultSpiCsnPin.put(Low)
discard spi0.writeBlocking(0x40u8, ord(IoDirA), 0x0u8)
DefaultSpiCsnPin.put(High)

while true:
  echo "Set GPA Low"
  DefaultSpiCsnPin.put(Low)
  discard spi0.writeBlocking(0x40u8, ord(OlatA), 0x0u8)
  DefaultSpiCsnPin.put(High)
  sleepMs(500)
  echo "Set GPA High"
  DefaultSpiCsnPin.put(Low)
  discard spi0.writeBlocking(0x40u8, ord(OlatA), 0xffu8)
  DefaultSpiCsnPin.put(High)
  sleepMs(500)
