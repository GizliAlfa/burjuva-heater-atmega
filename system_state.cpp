#include "system_state.h"
#include "pt1000.h"
#include "io.h"
#include "pid.h"
#include "config.h"
#include "config_runtime.h"

static SystemState currentState = SYS_INIT;
static ErrorCode currentError = ERR_NONE;

// Yardımcı fonksiyonlar
static bool isSensorDisconnected() {
  float temp = getTemperature(ACTIVE_CHANNEL);
  return (temp <= TEMP_INVALID_VALUE);
}

static float getMaxTemperature() {
  float maxTemp = TEMP_INVALID_VALUE;
  for (int i = 0; i < 4; i++) {
    float temp = getTemperature(i);
    if (temp > maxTemp) {
      maxTemp = temp;
    }
  }
  return maxTemp;
}

void systemStateInit() {
  currentState = SYS_INIT;
  currentError = ERR_NONE;
}

SystemState getSystemState() {
  return currentState;
}

ErrorCode getErrorCode() {
  return currentError;
}

void setSystemState(SystemState state) {
  currentState = state;
}

void setError(ErrorCode code) {
  currentError = code;
  currentState = SYS_ERROR;
  pidReset(); // Hata durumunda PID'yi sıfırla
  ssrOff();   // Isıtıcıyı kapat
}

void clearError() {
  currentError = ERR_NONE;
  currentState = SYS_READY;
  pidReset(); // Hata temizlendiğinde PID'yi sıfırla
}

void systemStateUpdate() {
  switch (currentState) {

    case SYS_INIT:
      if (!adsIsReady()) {
        setError(ERR_SENSOR_NOT_READY);
      } else {
        currentState = SYS_READY;
      }
      break;

    case SYS_READY:
      if (isHeatingEnabled()) {
        currentState = SYS_RUN;
        pidReset(); // Yeni çalışmada PID'yi sıfırla
      }
      break;

    case SYS_RUN:
      // Sensör hazır değilse
      if (!adsIsReady()) {
        setError(ERR_ADC_FAILURE);
        break;
      }

      // Sensör kopuk kontrolü
      if (isSensorDisconnected()) {
        setError(ERR_SENSOR_DISCONNECTED);
        break;
      }

      // Aşırı sıcaklık
      if (getMaxTemperature() > HEATER_MAX_TEMP) {
        setError(ERR_OVERTEMP);
        break;
      }
      break;

    case SYS_ERROR:
      ssrOff();
      break;
  }
}
