#ifndef PID_H
#define PID_H

#include <Arduino.h>

void pidInit();
float pidCompute(float setpoint, float measured, float dt);
void pidReset();

#endif
