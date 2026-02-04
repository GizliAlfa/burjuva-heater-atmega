#include "pid.h"
#include "config.h"
#include "config_runtime.h"
#include <math.h>

static float integral = 0;
static float lastTemp = 0;

void pidInit() {
  pidReset();
}

void pidReset() {
  integral = 0;
  lastTemp = 0;
}

float pidCompute(float setpoint, float measured, float dt) {
  // Runtime config'den PID parametrelerini al
  float Kp, Ki, Kd;
  getPidParams(Kp, Ki, Kd);
  
  float error = setpoint - measured;

  // Integral sadece hedefe yakınken (PID_I_ACTIVE_ERROR)
  if (fabs(error) < PID_I_ACTIVE_ERROR) {
    integral += error * dt;
  }

  // Integral sınırla (PID_INTEGRAL_LIMIT)
  integral = constrain(integral, -PID_INTEGRAL_LIMIT, PID_INTEGRAL_LIMIT);

  // İlk çalıştırmada lastTemp başlatılmamışsa, derivative'i sıfırla
  float derivative = 0;
  if (lastTemp != 0) {
    derivative = (measured - lastTemp) / dt;
  }
  lastTemp = measured;

  float output = Kp * error + Ki * integral - Kd * derivative;

  return constrain(output, 0, 100);
}
