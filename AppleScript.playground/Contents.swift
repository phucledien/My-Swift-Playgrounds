//import Foundation
//let myAppleScript = """
//tell application \"Finder\"
//    get insertion location
//end tell
//"""
//var error: NSDictionary? = nil
//
//if let scriptObject = NSAppleScript(source: myAppleScript) {
//    if
//        let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error),
//        let folder = output.atIndex(3)?.stringValue {
//        print(folder)
//    } else if (error != nil) {
//        print("error: \(error)")
//    }
//}
//
//
//
//
//let display = CGRect(x: -390, y: 1050, width: 2560, height: 1440)
//let window = CGRect(x: -252, y: 1060, width: 1892, height: 1025)
//
//display.contains(window)


import Foundation
import CoreMediaIO


var opa = CMIOObjectPropertyAddress(
    mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyDevices),
    mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
    mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster)
)

var (dataSize, dataUsed) = (UInt32(0), UInt32(0))
var result = CMIOObjectGetPropertyDataSize(CMIOObjectID(kCMIOObjectSystemObject), &opa, 0, nil, &dataSize)
var devices: UnsafeMutableRawPointer? = nil

repeat {
    if devices != nil {
        free(devices)
        devices = nil
    }
    devices = malloc(Int(dataSize))
    result = CMIOObjectGetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &opa, 0, nil, dataSize, &dataUsed, devices);
} while result == OSStatus(kCMIOHardwareBadPropertySizeError)

var camera: CMIOObjectID = 0

if let devices = devices {
    for offset in stride(from: 0, to: dataSize, by: MemoryLayout<CMIOObjectID>.size) {
        let current = devices.advanced(by: Int(offset)).assumingMemoryBound(to: CMIOObjectID.self)
        // current.pointee is your object ID you will want to keep track of somehow
        camera = current.pointee

        var name:String = "?"
        opa = CMIOObjectPropertyAddress(
            mSelector: CMIOObjectPropertySelector(kCMIODevicePropertyModelUID),
            mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeWildcard),
            mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementWildcard)
        )

        result = CMIOObjectGetPropertyDataSize(camera, &opa, 0, nil, &dataSize)
        if (result == OSStatus(kCMIOHardwareNoError)) {
            if let data = malloc(Int(dataSize)) {
                result = CMIOObjectGetPropertyData(camera, &opa, 0, nil, dataSize, &dataUsed, data)
                name = data.assumingMemoryBound(to: CFString.self).pointee as String
                free(data)
            } else {
                name = "MEMORY"
            }
        } else {
            name = "HWERROR"
        }

        var isOn = "unknown state"

        opa = CMIOObjectPropertyAddress(
            mSelector: CMIOObjectPropertySelector(kCMIODevicePropertyDeviceIsRunningSomewhere),
            mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeWildcard),
            mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementWildcard)
        )

        result = CMIOObjectGetPropertyDataSize(camera, &opa, 0, nil, &dataSize)
        if (result == OSStatus(kCMIOHardwareNoError)) {
            if let data = malloc(Int(dataSize)) {
                result = CMIOObjectGetPropertyData(camera, &opa, 0, nil, dataSize, &dataUsed, data)
                let on = data.assumingMemoryBound(to: UInt8.self)
                isOn = (on.pointee != 0 ? "ON" : "OFF")
                free(data)
            } else {
                isOn = "MEMORY"
            }
        } else {
            isOn = "HWERROR"
        }



        print(name, "\t", isOn)
    }
}

func handle(_ errorCode: OSStatus) throws {
    if errorCode != kAudioHardwareNoError {
        let error = NSError(domain: NSOSStatusErrorDomain, code: Int(errorCode), userInfo: [NSLocalizedDescriptionKey : "CAError: \(errorCode)" ])
        //            NSApplication.shared().presentError(error)
        throw error
    }
}

func getInputDevices() throws -> [AudioDeviceID] {
    
    var inputDevices: [AudioDeviceID] = []
    
    // Construct the address of the property which holds all available devices
    var devicesPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyDevices, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMaster)
    var propertySize = UInt32(0)
    
    // Get the size of the property in the kAudioObjectSystemObject so we can make space to store it
    try handle(AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &devicesPropertyAddress, 0, nil, &propertySize))
    
    // Get the number of devices by dividing the property address by the size of AudioDeviceIDs
    let numberOfDevices = Int(propertySize) / MemoryLayout<AudioDeviceID>.size
    
    // Create space to store the values
    var deviceIDs: [AudioDeviceID] = []
    for _ in 0 ..< numberOfDevices {
        deviceIDs.append(AudioDeviceID())
    }
    
    // Get the available devices
    try handle(AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &devicesPropertyAddress, 0, nil, &propertySize, &deviceIDs))
    
    // Iterate
    for id in deviceIDs {
        
        // Get the device name for fun
        var name: CFString = "" as CFString
        var propertySize: UInt32 = UInt32(MemoryLayout<CFString>.size)
        var deviceNamePropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyDeviceNameCFString, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMaster)
        try handle(AudioObjectGetPropertyData(id, &deviceNamePropertyAddress, 0, nil, &propertySize, &name))
        
        // Check the input scope of the device for any channels. That would mean it's an input device
        
        // Get the stream configuration of the device. It's a list of audio buffers.
        var streamConfigAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyStreamConfiguration, mScope: kAudioDevicePropertyScopeInput, mElement: 0)
        
        // Get the size so we can make room again
        try handle(AudioObjectGetPropertyDataSize(id, &streamConfigAddress, 0, nil, &propertySize))
        
        // Create a buffer list with the property size we just got and let core audio fill it
        let audioBufferList = AudioBufferList.allocate(maximumBuffers: Int(propertySize))
        try handle(AudioObjectGetPropertyData(id, &streamConfigAddress, 0, nil, &propertySize, audioBufferList.unsafeMutablePointer))
        
        // Get the number of channels in all the audio buffers in the audio buffer list
        var channelCount = 0
        for i in 0 ..< Int(audioBufferList.unsafeMutablePointer.pointee.mNumberBuffers) {
            channelCount = channelCount + Int(audioBufferList[i].mNumberChannels)
        }
        
        free(audioBufferList.unsafeMutablePointer)
        
        // If there are channels, it's an input device
        if channelCount > 0 {
            Swift.print("Found input device '\(name)' with \(channelCount) channels")
            inputDevices.append(id)
        }
    }
    
    return inputDevices
}


public func isAudioDeviceInUseSomewhere(device: AudioObjectID) -> Bool {
    var inUseSomewhere = UInt32(0)
    var size = UInt32(MemoryLayout<UInt32>.size)
    var address: AudioObjectPropertyAddress = AudioObjectPropertyAddress()
    address.mSelector = kAudioDevicePropertyDeviceIsRunningSomewhere
    address.mScope = kAudioObjectPropertyScopeGlobal
    address.mElement = kAudioObjectPropertyElementMaster
    
    do {
        var osStatus = AudioObjectGetPropertyData(device, &address, 0, nil, &size, &inUseSomewhere)
        
        if osStatus != kAudioHardwareNoError {
            NSLog("isAudioDeviceInUseSomewhere: Error occurred.")
        }
    } catch let e {
        NSLog("isAudioDeviceInUseSomewhere: Error occurred.")
    }
    
    if inUseSomewhere == 1 {
        return true
    } else {
        return false
    }
}


isAudioDeviceInUseSomewhere(device: getInputDevices()[0])
