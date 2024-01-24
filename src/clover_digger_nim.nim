import picostdlib

stdioInitAll()

setupGpio(col, 10, Out)
col.put(High)

setupGpio(row, 8, In)
row.pullDown

sleepMs(250)

var state = row.get
var readState = state

while true:
  readState = row.get
  if state != readState:
     state = readState
     echo "Button changed to" & $readState
  sleepMs(250)
