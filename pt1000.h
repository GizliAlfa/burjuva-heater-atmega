#ifndef PT1000_H
#define PT1000_H

#include <Arduino.h>

bool adsInit();
bool adsIsReady();

void readAllTemperatures();
float getTemperature(uint8_t channel);

#endif
