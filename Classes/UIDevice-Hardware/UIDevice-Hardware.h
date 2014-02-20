/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define IFPGA_NAMESTRING                @"iFPGA"

// iPhone

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS" 
#define IPHONE_4_NAMESTRING             @"iPhone 4" 
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_5C_NAMESTRING             @"iPhone 5C"
#define IPHONE_5S_NAMESTRING            @"iPhone 5S"

// iPod

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_5G_NAMESTRING              @"iPod touch 5G"

// iPad

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"

// iPad Air

#define IPAD_AIR_1G_NAMESTRING              @"iPad Air"

// iPad Mini

#define IPAD_MINI_1G_NAMESTRING              @"iPad Mini 1G"
#define IPAD_MINI_2G_NAMESTRING              @"iPad Mini 2G"

// AppleTV

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"

// Simulator

#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"

// Unknown

#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"
#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

typedef enum {
    UIDeviceIFPGA,
    
    // iPhone
    
    UIDeviceIPhone1G,
    UIDeviceIPhone3G,
    UIDeviceIPhone3GS,
    UIDeviceIPhone4,
    UIDeviceIPhone4S,
    UIDeviceIPhone5,
    UIDeviceIPhone5C,
    UIDeviceIPhone5S,
    
    // iPod
    
    UIDeviceIPod1G,
    UIDeviceIPod2G,
    UIDeviceIPod3G,
    UIDeviceIPod4G,
    UIDeviceIPod5G,
    
    // iPad
    
    UIDeviceIPad1G,
    UIDeviceIPad2G,
    UIDeviceIPad3G,
    UIDeviceIPad4G,
    
    // iPad Air
    
    UIDeviceIPadAir1G,
    
    // iPad Mini
    
    UIDeviceIPadMini1G,
    UIDeviceIPadMini2G,
    
    // Apple TV
    
    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    
    // Simulator
    
    UIDeviceSimulatoriPhone,
    UIDeviceSimulatoriPad,
    
    // Unknown
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceUnknownAppleTV,
    UIDeviceUnknown,
} UIDevicePlatform;

typedef enum {
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,
} UIDeviceFamily;

@interface UIDevice (Hardware)

- (NSString *)platform;
- (NSString *)hwmodel;
- (NSUInteger)platformType;
- (NSString *)platformString;
- (UIDeviceFamily)deviceFamily;

- (NSUInteger)cpuFrequency;
- (NSUInteger)busFrequency;
- (NSUInteger)cpuCount;
- (NSUInteger)totalMemory;
- (NSUInteger)userMemory;

- (NSNumber *)totalDiskSpace;
- (NSNumber *)freeDiskSpace;

@end