#include "uart.h"
#include "config.h"
#include "config_runtime.h"
#include "system_state.h"
#include "pid.h"
#include <avr/wdt.h>

void uartInit() {
  Serial.begin(UART_BAUDRATE);
}

void uartTask() {
  if (!Serial.available()) return;
  
  String cmd = Serial.readStringUntil('\n');
  cmd.trim();
  
  // Boş komut kontrolü
  if (cmd.length() == 0) return;
  
  // Komut işleme
  if (cmd.startsWith("T:")) {
    // Hedef sıcaklık ayarla: "T:150"
    float temp = cmd.substring(2).toFloat();
    if (temp > 0 && temp <= HEATER_MAX_TEMP) {
      setTargetTemp(temp);
      Serial.print("Target set to: ");
      Serial.println(temp);
    } else {
      Serial.print("Invalid temperature range (0-");
      Serial.print(HEATER_MAX_TEMP);
      Serial.println(")");
    }
  }
  else if (cmd.startsWith("P:")) {
    // PID parametrelerini ayarla: "P:26.0,0.05,4.0"
    String params = cmd.substring(2);
    int comma1 = params.indexOf(',');
    int comma2 = params.indexOf(',', comma1 + 1);
    
    if (comma1 > 0 && comma2 > 0) {
      float kp = params.substring(0, comma1).toFloat();
      float ki = params.substring(comma1 + 1, comma2).toFloat();
      float kd = params.substring(comma2 + 1).toFloat();
      
      setPidParams(kp, ki, kd);
      pidReset();  // PID'yi sıfırla
      
      Serial.print("PID set to Kp:");
      Serial.print(kp, 3);
      Serial.print(" Ki:");
      Serial.print(ki, 3);
      Serial.print(" Kd:");
      Serial.println(kd, 3);
    } else {
      Serial.println("Invalid PID format. Use: P:kp,ki,kd");
    }
  }
  else if (cmd.startsWith("H:")) {
    // Isıtmayı aç/kapa: "H:1" veya "H:0"
    int state = cmd.substring(2).toInt();
    setHeatingEnabled(state == 1);
    Serial.print("Heating ");
    Serial.println(state == 1 ? "enabled" : "disabled");
  }
  else if (cmd == "SAVE") {
    // EEPROM'a kaydet
    savePidToEEPROM();
    Serial.println("PID parameters saved to EEPROM");
  }
  else if (cmd == "PIDRESET") {
    // PID reset
    pidReset();
    Serial.println("PID reset");
  }
  else if (cmd == "RESET") {
    // Sistem reset
    Serial.println("System resetting...");
    Serial.flush();
    delay(100);
    wdt_enable(WDTO_15MS);  // Watchdog timer ile reset
    while(1);
  }
  else if (cmd == "STATUS") {
    // Detaylı durum bilgisi
    uartPrintDetailedStatus();
  }
  else if (cmd == "HELP") {
    // Yardım menüsü
    uartPrintHelp();
  }
  else {
    // Sayı mı kontrol et (eski uyumluluk için)
    float temp = cmd.toFloat();
    if (temp > 0 && temp <= HEATER_MAX_TEMP) {
      setTargetTemp(temp);
      Serial.print("Target set to: ");
      Serial.println(temp);
    } else if (temp > 0) {
      Serial.print("Temperature too high (max: ");
      Serial.print(HEATER_MAX_TEMP);
      Serial.println(")");
    } else {
      Serial.print("Unknown command: ");
      Serial.println(cmd);
      Serial.println("Type HELP for command list");
    }
  }
}

void uartSendStatus(float temp, float duty, float target) {
  Serial.print("T:");
  Serial.print(temp, 2);
  Serial.print(" SP:");
  Serial.print(target, 1);
  Serial.print(" D:");
  Serial.print(duty, 1);
  Serial.print(" STATE:");
  Serial.print(getSystemState());
  Serial.print(" ERR:");
  Serial.println(getErrorCode());
}

bool uartAvailable() {
  return Serial.available();
}

float uartReadFloat() {
  return Serial.parseFloat();
}

void uartPrintDetailedStatus() {
  Serial.println("\n===== SYSTEM STATUS =====");
  
  // Sistem durumu
  Serial.print("System State: ");
  switch(getSystemState()) {
    case SYS_INIT: Serial.println("INIT"); break;
    case SYS_READY: Serial.println("READY"); break;
    case SYS_RUN: Serial.println("RUN"); break;
    case SYS_ERROR: Serial.println("ERROR"); break;
  }
  
  // Hata kodu
  Serial.print("Error Code: ");
  Serial.print(getErrorCode());
  Serial.print(" - ");
  switch(getErrorCode()) {
    case ERR_NONE: Serial.println("No Error"); break;
    case ERR_SENSOR_NOT_READY: Serial.println("Sensor Not Ready"); break;
    case ERR_SENSOR_DISCONNECTED: Serial.println("Sensor Disconnected"); break;
    case ERR_OVERTEMP: Serial.println("Over Temperature"); break;
    case ERR_ADC_FAILURE: Serial.println("ADC Failure"); break;
    default: Serial.println("Unknown"); break;
  }
  
  // PID parametreleri
  float kp, ki, kd;
  getPidParams(kp, ki, kd);
  Serial.print("PID: Kp=");
  Serial.print(kp, 3);
  Serial.print(" Ki=");
  Serial.print(ki, 3);
  Serial.print(" Kd=");
  Serial.println(kd, 3);
  
  // Sıcaklık bilgisi
  Serial.print("Target: ");
  Serial.print(getTargetTemp(), 1);
  Serial.println("°C");
  
  // Isıtma durumu
  Serial.print("Heating: ");
  Serial.println(isHeatingEnabled() ? "Enabled" : "Disabled");
  
  Serial.println("========================\n");
}

void uartPrintHelp() {
  Serial.println("\n===== COMMAND HELP =====");
  Serial.println("T:<temp>        - Set target temperature (e.g., T:150)");
  Serial.println("P:<kp,ki,kd>    - Set PID parameters (e.g., P:26.0,0.05,4.0)");
  Serial.println("H:<0|1>         - Disable/Enable heating (e.g., H:1)");
  Serial.println("SAVE            - Save PID parameters to EEPROM");
  Serial.println("PIDRESET        - Reset PID controller");
  Serial.println("RESET           - System reset (reboot)");
  Serial.println("STATUS          - Show detailed system status");
  Serial.println("HELP            - Show this help");
  Serial.println("<number>        - Set target temperature (legacy)");
  Serial.println("========================\n");
}
