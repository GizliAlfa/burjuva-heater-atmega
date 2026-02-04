#ifndef IO_H
#define IO_H

#include <Arduino.h>

void ioInit(uint8_t ssrPin);
void ssrUpdate(float duty, float periodSec);
void ssrOff();

#endif
