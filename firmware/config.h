#ifndef CONFIG_H
#define CONFIG_H

/* ================= UART ================= */
#define UART_BAUDRATE        115200

/* ================= PID ================= */
#define PID_KP               26.0
#define PID_KI               0.05
#define PID_KD               4.0

#define PID_SAMPLE_TIME_MS   300      // PID hesaplama periyodu
#define PID_INTEGRAL_LIMIT   300.0
#define PID_TARGET_DEADBAND  0.3       // hedefte kapama bandı (°C)
#define PID_I_ACTIVE_ERROR   2.0       // integral aktif hata bandı (°C)

/* ================= HEATER ================= */
#define HEATER_TARGET_DEFAULT 100.0
#define HEATER_MAX_TEMP       350.0

/* ================= PWM / SSR ================= */
#define SSR_PIN              8
#define SSR_PWM_HZ           30.0 //hz
#define SSR_CONTROL_PERIOD   (1.0 / SSR_PWM_HZ)

/* ================= ADS1115 ================= */
#define ADS_GAIN             GAIN_ONE
#define ADS_REF_RESISTANCE   938.0 //direnç
#define ADS_VSUPPLY          5.0
#define ACTIVE_CHANNEL       2

/* ================= SYSTEM ================= */
#define TEMP_READ_INTERVAL_MS 300
#define TEMP_INVALID_VALUE   -999.0

#endif
