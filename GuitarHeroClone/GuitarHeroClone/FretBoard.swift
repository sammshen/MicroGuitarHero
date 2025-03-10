import ORSSerial

class FretBoard: NSObject, ORSSerialPortDelegate, ObservableObject {
    var serialPort: ORSSerialPort?
    var onBendChange: ((Float) -> Void)? // Notifies ContentView of pitch bend changes
    
    // Closure to notify ContentView when a key is pressed or released
    var onKeyChange: ((Int, Bool) -> Void)?
    
    @Published var receivedMessage: String = "Fretboard Waiting for data..."
    
    override init() {
        super.init()
        setupSerial()
    }

    func setupSerial() {
        guard let port = ORSSerialPort(path: "/dev/cu.usbmodem101") else {
            print("❌ Failed to find Fret Board serial port")
            return
        }
        print("✅ Found Fret Board serial port!")
        serialPort = port
        serialPort?.baudRate = 115200
        serialPort?.delegate = self
        serialPort?.open()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.serialPort?.isOpen == true {
                print("✅ Fret Board Serial Port Opened: \(port.path)")
            } else {
                print("❌ Fret Board Serial Port FAILED to Open! Another process might be using it.")
            }
        }
    }

    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        if let message = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
            DispatchQueue.main.async {
                self.receivedMessage = message
//                print("📡 Fretboard RAW DATA RECEIVED: \(message)")
                
                // ✅ Detect "1on", "1off", ..., "4on", "4off"
                let regex = try! NSRegularExpression(pattern: "([1-4])(on|off)")
                if let match = regex.firstMatch(in: message, range: NSRange(message.startIndex..., in: message)) {
                    print(message)
                    let keyNumber = Int((message as NSString).substring(with: match.range(at: 1)))!
                    let isPressed = (message as NSString).substring(with: match.range(at: 2)) == "on"
                    
                    print("🎸 Key \(keyNumber) \(isPressed ? "PRESSED" : "RELEASED")")
                    self.onKeyChange?(keyNumber, isPressed) // Notify ContentView
                }
                else {
                    if let fretValue = Int(message) {
                        print("Cap Touch Sensor: \(fretValue)")
                        let clampedValue = min(max(fretValue, 0), 40000) // Clamp between 0-40,000
                        let normalizedBend = Float(clampedValue) / 40000.0 // Normalize 0-1
                        self.onBendChange?(normalizedBend) // Notify UI
                    }
                }
            }
        }
    }

    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("⚠️ SerialPort encountered an error: \(error.localizedDescription)")
    }

    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        print("⚠️ Serial Port Disconnected")
        DispatchQueue.main.async {
            self.receivedMessage = "USB Disconnected"
        }
    }
}
