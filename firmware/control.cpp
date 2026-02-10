#include "control.h"
#include "system_state.h"
#include "pt1000.h"
#include "pid.h"
#include "io.h"
#include "config.h"
#include "config_runtime.h"
#include "uart.h"

void controlTask() {
  static unsigned long lastTempTime = 0;
  static unsigned long lastPidTime = 0;
  static bool firstRun = true;

  unsigned long nowMs = millis();

  systemStateUpdate();

  if (getSystemState() != SYS_RUN) {
    ssrOff();
    firstRun = true;
    return;
  }

  if (nowMs - lastTempTime < TEMP_READ_INTERVAL_MS)
    return;

  lastTempTime = nowMs;

  readAllTemperatures();
  float temp = getTemperature(ACTIVE_CHANNEL);

  // Geçersiz sıcaklık varsa güvenli mod
  if (temp <= TEMP_INVALID_VALUE) {
    ssrOff();
    return;
  }

  // İlk çalıştırmada dt hesabı için başlat
  if (firstRun) {
    lastPidTime = nowMs;
    firstRun = false;
    return;
  }

  float dt = (nowMs - lastPidTime) / 1000.0;
  lastPidTime = nowMs;

  // dt çok küçükse veya çok büyükse atla
  if (dt < 0.001 || dt > 10.0) {
    return;
  }

  float duty = pidCompute(
    getTargetTemp(),
    temp,
    dt
  );

  ssrUpdate(duty, SSR_CONTROL_PERIOD);
  
  uartSendStatus(temp, duty, getTargetTemp());
}
