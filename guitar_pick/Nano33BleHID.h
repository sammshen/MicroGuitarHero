#ifndef NANO33_BLE_HID_H_
#define NANO33_BLE_HID_H_

#include "Mbed_BLE_HID.h"

/* -------------------------------------------------------------------------- */

/** Use "Nano33" as an alias for Arduino users. */
template<typename T>
using Nano33BleHID = BasicMbedBleHID<T>;

#include "HIDMouseService.h"
#include "HIDKeyboardService.h"
#include "HIDGamepadService.h"

using Nano33BleMouse    = Nano33BleHID<HIDMouseService>;
using Nano33BleKeyboard = Nano33BleHID<HIDKeyboardService>;
using Nano33BleGamepad  = Nano33BleHID<HIDGamepadService>;

/* -------------------------------------------------------------------------- */

#endif // NANO33_BLE_HID_H_
