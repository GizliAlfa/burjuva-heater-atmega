#include "config_runtime.h"
#include "config.h"
#include <EEPROM.h>

#define EEPROM_MAGIC_ADDR  0
#define EEPROM_MAGIC_VAL   0x42

#define EEPROM_KP_ADDR     1
#define EEPROM_KI_ADDR     (EEPROM_KP_ADDR + sizeof(float))
#define EEPROM_KD_ADDR     (EEPROM_KI_ADDR + sizeof(float))

static float targetTemp;
static float kp, ki, kd;
static bool heatingEnabled = true;

void runtimeInit() {
  loadPidFromEEPROM();
  targetTemp = HEATER_TARGET_DEFAULT;
  heatingEnabled = true;
}

/* ===== PID ===== */
void setPidParams(float _kp, float _ki, float _kd) {
  kp = _kp;
  ki = _ki;
  kd = _kd;
}

void getPidParams(float &outKp, float &outKi, float &outKd) {
  outKp = kp;
  outKi = ki;
  outKd = kd;
}

/* ===== EEPROM ===== */
void savePidToEEPROM() {
  EEPROM.update(EEPROM_MAGIC_ADDR, EEPROM_MAGIC_VAL);
  EEPROM.put(EEPROM_KP_ADDR, kp);
  EEPROM.put(EEPROM_KI_ADDR, ki);
  EEPROM.put(EEPROM_KD_ADDR, kd);
}

void loadPidFromEEPROM() {
  if (EEPROM.read(EEPROM_MAGIC_ADDR) == EEPROM_MAGIC_VAL) {
    EEPROM.get(EEPROM_KP_ADDR, kp);
    EEPROM.get(EEPROM_KI_ADDR, ki);
    EEPROM.get(EEPROM_KD_ADDR, kd);
  } else {
    kp = PID_KP;
    ki = PID_KI;
    kd = PID_KD;
  }
}

/* ===== Target ===== */
void setTargetTemp(float temp) {
  if (temp > 0 && temp <= HEATER_MAX_TEMP)
    targetTemp = temp;
}

float getTargetTemp() {
  return targetTemp;
}

/* ===== Heater ===== */
void setHeatingEnabled(bool en) {
  heatingEnabled = en;
}

bool isHeatingEnabled() {
  return heatingEnabled;
}
