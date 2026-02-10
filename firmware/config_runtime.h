#ifndef CONFIG_RUNTIME_H
#define CONFIG_RUNTIME_H

#include <Arduino.h>

/* ===== Runtime ===== */
void runtimeInit();

/* Target */
void setTargetTemp(float temp);
float getTargetTemp();

/* PID */
void setPidParams(float kp, float ki, float kd);
void getPidParams(float &kp, float &ki, float &kd);

/* EEPROM */
void savePidToEEPROM();
void loadPidFromEEPROM();

/* Heater */
void setHeatingEnabled(bool en);
bool isHeatingEnabled();

#endif
