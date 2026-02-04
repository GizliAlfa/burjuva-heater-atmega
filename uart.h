#ifndef UART_H
#define UART_H

#include <Arduino.h>

void uartInit();
void uartTask();
bool uartAvailable();
float uartReadFloat();
void uartSendStatus(float temp, float duty, float target);
void uartPrintDetailedStatus();
void uartPrintHelp();

#endif
