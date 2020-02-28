import Cocoa

func turnDNDOn() {
    // The trick is to set DND time range from 00:00 (0 minutes) to 23:59 (1439 minutes),
    // so it will always be on
    CFPreferencesSetValue("dndStart" as CFString,
                          0 as CFPropertyList,
                          "com.apple.notificationcenterui" as CFString,
                          kCFPreferencesCurrentUser,
                          kCFPreferencesCurrentHost)
    
    CFPreferencesSetValue("dndEnd" as CFString,
                          1440 as CFPropertyList,
                          "com.apple.notificationcenterui" as CFString,
                          kCFPreferencesCurrentUser,
                          kCFPreferencesCurrentHost)
    
    CFPreferencesSetValue("doNotDisturb" as CFString,
                          true as CFPropertyList,
                          "com.apple.notificationcenterui" as CFString,
                          kCFPreferencesCurrentUser,
                          kCFPreferencesCurrentHost)
    
    commitDoNotDisturbChanges()
}

func turnDNDOff() {
    CFPreferencesSetValue("dndStart" as CFString,
                          nil,
                          "com.apple.notificationcenterui" as CFString,
                          kCFPreferencesCurrentUser,
                          kCFPreferencesCurrentHost)
    
    CFPreferencesSetValue("dndEnd" as CFString,
                          nil,
                          "com.apple.notificationcenterui" as CFString,
                          kCFPreferencesCurrentUser,
                          kCFPreferencesCurrentHost)
    
    CFPreferencesSetValue("doNotDisturb" as CFString,
                          false as CFPropertyList,
                          "com.apple.notificationcenterui" as CFString,
                          kCFPreferencesCurrentUser,
                          kCFPreferencesCurrentHost)
    
    commitDoNotDisturbChanges()
}

func commitDoNotDisturbChanges() {
    CFPreferencesSynchronize("com.apple.notificationcenterui" as CFString, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
    
    DistributedNotificationCenter.default().postNotificationName(Notification.Name("com.apple.notificationcenterui.dndprefs_changed"),
                                                                 object: nil,
                                                                 userInfo: nil,
                                                                 deliverImmediately: true)
    
}
