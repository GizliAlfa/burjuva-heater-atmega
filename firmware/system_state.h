#ifndef SYSTEM_STATE_H
#define SYSTEM_STATE_H

#include <Arduino.h>
#include "error_codes.h"

enum SystemState {
  SYS_INIT = 0,
  SYS_READY,
  SYS_RUN,
  SYS_ERROR
};

void systemStateInit();
void systemStateUpdate();

SystemState getSystemState();
ErrorCode getErrorCode();

void setSystemState(SystemState state);
void setError(ErrorCode code);
void clearError();

#endif
