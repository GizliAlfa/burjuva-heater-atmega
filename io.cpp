#include "config.h"
#include "io.h"

static uint8_t _ssrPin;
static unsigned long pwmStart = 0;

void ioInit(uint8_t ssrPin) {
  _ssrPin = ssrPin;
  pinMode(_ssrPin, OUTPUT);
  digitalWrite(_ssrPin, LOW);
}

void ssrUpdate(float duty, float periodSec) {
  // Duty 0 veya negatifse, direkt kapat
  if (duty <= 0) {
    digitalWrite(_ssrPin, LOW);
    return;
  }
  
  // Duty 100 veya üzerindeyse, direkt aç
  if (duty >= 100) {
    digitalWrite(_ssrPin, HIGH);
    return;
  }
  
  unsigned long now = micros();
  unsigned long periodUs = periodSec * 1000000UL;

  // Periyot tamamlandı mı?
  if (now - pwmStart >= periodUs) {
    pwmStart = now;
  }

  unsigned long onTimeUs = (unsigned long)(periodUs * (duty / 100.0));
  unsigned long elapsed = now - pwmStart;

  digitalWrite(
    _ssrPin,
    (elapsed < onTimeUs) ? HIGH : LOW
  );
}

void ssrOff() {
  digitalWrite(_ssrPin, LOW);
}
