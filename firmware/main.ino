#include "config.h"
#include "pt1000.h"
#include "pid.h"
#include "io.h"
#include "uart.h"
#include "config_runtime.h"
#include "control.h"
#include "system_state.h"

void setup() {
  systemStateInit();
  runtimeInit();
  uartInit();
  adsInit();
  pidInit();
  ioInit(SSR_PIN);
}

void loop() {
  uartTask();
  controlTask();
}
