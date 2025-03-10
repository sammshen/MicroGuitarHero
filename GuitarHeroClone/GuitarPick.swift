import ORSSerial

class GuitarPick: NSObject, ORSSerialPortDelegate, ObservableObject {
    var serialPort: ORSSerialPort?
    var onStrum: (() -> Void)? // Closure to notify ContentView
    
    @Published var receivedMessage: String = "GuitarPick Waiting for data..."
    
    override init() {
        super.init()
        setupSerial()
    }

    func setupSerial() {
        guard let port = ORSSerialPort(path: "/dev/cu.usbmodem1101") else {
            print("❌ Failed to find guitar pick serial port")
            return
        }
        print("✅ Found Guitar Pick serial port!")
        serialPort = port
        serialPort?.baudRate = 115200
        serialPort?.delegate = self
        serialPort?.open()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.serialPort?.isOpen == true {
                print("✅ Guitar Pick Serial Port Opened: \(port.path)")
            } else {
                print("❌ Guitar Pick Serial Port FAILED to Open! Another process might be using it.")
            }
        }
    }

    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        print("Received data from guitar pick!")
        if let message = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
            print("📡 RAW DATA RECEIVED: \(message)")
            DispatchQueue.main.async {
                self.receivedMessage = message
                
                // ✅ Check if the received message is "strum"
                if message == "strum" {
                    print("🎸 Strum detected! Triggering checkAndPlayWave()")
                    self.onStrum?() // Call ContentView's function
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
