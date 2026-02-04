#include "pt1000.h"
#include "config.h"
#include <Wire.h>
#include <Adafruit_ADS1X15.h>

static Adafruit_ADS1115 ads;
static bool adsReady = false;
static float temperatures[4];

bool adsInit() {
  // Sıcaklık dizisini başlat
  for (int i = 0; i < 4; i++) {
    temperatures[i] = TEMP_INVALID_VALUE;
  }
  
  if (!ads.begin()) {
    adsReady = false;
    return false;
  }

  ads.setGain(ADS_GAIN);
  adsReady = true;
  return true;
}

bool adsIsReady() {
  return adsReady;
}

void readAllTemperatures() {
  if (!adsReady) return;

  for (int i = 0; i < 4; i++) {
    int16_t raw = ads.readADC_SingleEnded(i);
    float voltage = raw * 0.000125;

    if (voltage <= 0.0 || voltage >= (ADS_VSUPPLY - 0.1)) {
      temperatures[i] = TEMP_INVALID_VALUE;
      continue;
    }

    float Rpt = ADS_REF_RESISTANCE * (voltage / (ADS_VSUPPLY - voltage));
    // PT1000: α = 0.003908 Ω/Ω/°C (DIN EN 60751)
    // Basitleştirilmiş: Temp = (R - R0) / α * R0
    temperatures[i] = (Rpt - 1000.0) / 3.908;
  }
}

float getTemperature(uint8_t channel) {
  if (!adsReady || channel > 3)
    return TEMP_INVALID_VALUE;

  return temperatures[channel];
}
