import picostdlib
import picostdlib/hardware/spi
import std/bitops

stdioInitAll()

echo "Setting rows to in"
setupGpio(up, 2, In)
up.pullUp
setupGpio(right, 3, In)
right.pullUp
setupGpio(down, 6, In)
down.pullUp
setupGpio(left, 7, In)
left.pullUp
setupGpio(push, 8, In)
push.pullUp

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

echo "Set GPx to out"
DefaultSpiCsnPin.put(Low)
discard spi0.writeBlocking(0x40u8, ord(IoDirA), 0x00u8)
discard spi0.writeBlocking(0x40u8, ord(IoDirB), 0x00u8)
DefaultSpiCsnPin.put(High)

echo "Set GPx to high"
DefaultSpiCsnPin.put(Low)
discard spi0.writeBlocking(0x40u8, ord(OlatA), 0xffu8)
discard spi0.writeBlocking(0x40u8, ord(OlatB), bitxor(0xffu8, 1u8))
DefaultSpiCsnPin.put(High)

echo "Getting initial state"
var upState = up.get
var rightState = right.get
var downState = down.get
var leftState = left.get
var pushState = push.get

echo "Initial up state is" & $upState
echo "Initial right state is" & $rightState
echo "Initial downn state is" & $downState
echo "Initial left state is" & $rightState
echo "Initial push state is" & $leftState

while true:
  var upStateRead = up.get
  var rightStateRead = right.get
  var downStateRead = down.get
  var leftStateRead = left.get
  var pushStateRead = push.get
  if upState != upStateRead:
     upState = upStateRead
     echo "Up button changed to" & $upState
  if rightState != rightStateRead:
     rightState = rightStateRead
     echo "Right button changed to" & $rightState
  if downState != downStateRead:
     downState = downStateRead
     echo "Down button changed to" & $downState
  if leftState != leftStateRead:
     leftState = leftStateRead
     echo "Left button changed to" & $leftState
  if pushState != pushStateRead:
     pushState = pushStateRead
     echo "Push button changed to" & $pushState
  sleepMs(2)
