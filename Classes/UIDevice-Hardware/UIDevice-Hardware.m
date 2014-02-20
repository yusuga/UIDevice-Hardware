/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "UIDevice-Hardware.h"

@implementation UIDevice (Hardware)

#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    free(answer);
    return results;
}

- (NSString *) platform
{
    static NSString *s_platform;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_platform = [self getSysInfoByName:"hw.machine"];
    });
    return s_platform;
}


// Thanks, Tom Harrington (Atomicbird)
- (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!

/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
*/

- (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark platform type and name utils
- (NSUInteger) platformType
{
    static NSUInteger s_platformType;
    
    NSString *platform = [self platform];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // The ever mysterious iFPGA
        if ([platform isEqualToString:@"iFPGA"])        s_platformType = UIDeviceIFPGA;
        
        // iPhone http://theiphonewiki.com/wiki/IPhone
        
        else if ([platform isEqualToString:@"iPhone1,1"])    s_platformType = UIDeviceIPhone1G;
        else if ([platform isEqualToString:@"iPhone1,2"])    s_platformType = UIDeviceIPhone3G;
        else if ([platform isEqualToString:@"iPhone2,1"])            s_platformType = UIDeviceIPhone3GS;
        else if ([platform isEqualToString:@"iPhone3,1"])            s_platformType = UIDeviceIPhone4; // GSM
        else if ([platform isEqualToString:@"iPhone3,2"])            s_platformType = UIDeviceIPhone4; // GSM Rev A
        else if ([platform isEqualToString:@"iPhone3,3"])            s_platformType = UIDeviceIPhone4; // CDMA
        else if ([platform isEqualToString:@"iPhone4,1"])            s_platformType = UIDeviceIPhone4S;
        else if ([platform isEqualToString:@"iPhone5,1"])            s_platformType = UIDeviceIPhone5; // GSM
        else if ([platform isEqualToString:@"iPhone5,2"])            s_platformType = UIDeviceIPhone5; // Global
        else if ([platform isEqualToString:@"iPhone5,3"])            s_platformType = UIDeviceIPhone5C; // GSM
        else if ([platform isEqualToString:@"iPhone5,4"])            s_platformType = UIDeviceIPhone5C; // Global
        else if ([platform isEqualToString:@"iPhone6,1"])            s_platformType = UIDeviceIPhone5S; // GSM
        else if ([platform isEqualToString:@"iPhone6,2"])            s_platformType = UIDeviceIPhone5S; // Global
        
        // iPod http://theiphonewiki.com/wiki/IPod
        
        else if ([platform isEqualToString:@"iPod1,1"])              s_platformType = UIDeviceIPod1G;
        else if ([platform isEqualToString:@"iPod2,1"])              s_platformType = UIDeviceIPod2G;
        else if ([platform isEqualToString:@"iPod3,1"])              s_platformType = UIDeviceIPod3G;
        else if ([platform isEqualToString:@"iPod4,1"])              s_platformType = UIDeviceIPod4G;
        else if ([platform isEqualToString:@"iPod5,1"])              s_platformType = UIDeviceIPod5G;
        
        // iPad http://theiphonewiki.com/wiki/IPad
        
        else if ([platform isEqualToString:@"iPad1,1"])              s_platformType = UIDeviceIPad1G;
        else if ([platform isEqualToString:@"iPad2,1"])              s_platformType = UIDeviceIPad2G; // WiFi
        else if ([platform isEqualToString:@"iPad2,2"])              s_platformType = UIDeviceIPad2G; // GSM
        else if ([platform isEqualToString:@"iPad2,3"])              s_platformType = UIDeviceIPad2G; // CDMA
        else if ([platform isEqualToString:@"iPad2,4"])              s_platformType = UIDeviceIPad2G; // Rev A
        else if ([platform isEqualToString:@"iPad3,1"])              s_platformType = UIDeviceIPad3G; // WiFi
        else if ([platform isEqualToString:@"iPad3,2"])              s_platformType = UIDeviceIPad3G; // GSM
        else if ([platform isEqualToString:@"iPad3,3"])              s_platformType = UIDeviceIPad3G; // Global
        else if ([platform isEqualToString:@"iPad3,4"])              s_platformType = UIDeviceIPad4G; // WiFi
        else if ([platform isEqualToString:@"iPad3,5"])              s_platformType = UIDeviceIPad4G; // GSM
        else if ([platform isEqualToString:@"iPad3,6"])              s_platformType = UIDeviceIPad4G; // Global
        
        // iPad Air http://theiphonewiki.com/wiki/IPad
        
        else if ([platform isEqualToString:@"iPad4,1"])              s_platformType = UIDeviceIPadAir1G; // WiFi
        else if ([platform isEqualToString:@"iPad4,2"])              s_platformType = UIDeviceIPadAir1G; // Celluar
        
        // iPad Mini http://theiphonewiki.com/wiki/IPad_mini
        
        else if ([platform isEqualToString:@"iPad2,5"])              s_platformType = UIDeviceIPadMini1G; // WiFi
        else if ([platform isEqualToString:@"iPad2,6"])              s_platformType = UIDeviceIPadMini1G; // GSM
        else if ([platform isEqualToString:@"iPad2,7"])              s_platformType = UIDeviceIPadMini1G; // Global
        else if ([platform isEqualToString:@"iPad4,4"])              s_platformType = UIDeviceIPadMini2G; // WiFi
        else if ([platform isEqualToString:@"iPad4,5"])              s_platformType = UIDeviceIPadMini2G; // Cellular
        
        // Apple TV http://theiphonewiki.com/wiki/Apple_TV
        
        else if ([platform isEqualToString:@"AppleTV2,1"])           s_platformType = UIDeviceAppleTV2;
        else if ([platform isEqualToString:@"AppleTV3,1"])           s_platformType = UIDeviceAppleTV3;
        else if ([platform isEqualToString:@"AppleTV3,2"])           s_platformType = UIDeviceAppleTV3;
        
        // Simulator thanks Jordan Breeding
        
        else if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"]) {
            BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
            s_platformType =  smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
        }
        
        // Unknown
        
        else if ([platform hasPrefix:@"iPhone"])             s_platformType = UIDeviceUnknowniPhone;
        else if ([platform hasPrefix:@"iPod"])               s_platformType = UIDeviceUnknowniPod;
        else if ([platform hasPrefix:@"iPad"])               s_platformType = UIDeviceUnknowniPad;
        else if ([platform hasPrefix:@"AppleTV"])            s_platformType = UIDeviceUnknownAppleTV;        
        else
            s_platformType = UIDeviceUnknown;
    });

    return s_platformType;
}

- (NSString *) platformString
{
    switch ([self platformType])
    {
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
            // iPhone
            
        case UIDeviceIPhone1G: return IPHONE_1G_NAMESTRING;
        case UIDeviceIPhone3G: return IPHONE_3G_NAMESTRING;
        case UIDeviceIPhone3GS: return IPHONE_3GS_NAMESTRING;
        case UIDeviceIPhone4: return IPHONE_4_NAMESTRING;
        case UIDeviceIPhone4S: return IPHONE_4S_NAMESTRING;
        case UIDeviceIPhone5: return IPHONE_5_NAMESTRING;
        case UIDeviceIPhone5C: return IPHONE_5C_NAMESTRING;
        case UIDeviceIPhone5S: return IPHONE_5S_NAMESTRING;
        
            // iPod
            
        case UIDeviceIPod1G: return IPOD_1G_NAMESTRING;
        case UIDeviceIPod2G: return IPOD_2G_NAMESTRING;
        case UIDeviceIPod3G: return IPOD_3G_NAMESTRING;
        case UIDeviceIPod4G: return IPOD_4G_NAMESTRING;
        case UIDeviceIPod5G: return IPOD_5G_NAMESTRING;
            
            // iPad
            
        case UIDeviceIPad1G : return IPAD_1G_NAMESTRING;
        case UIDeviceIPad2G : return IPAD_2G_NAMESTRING;
        case UIDeviceIPad3G : return IPAD_3G_NAMESTRING;
        case UIDeviceIPad4G : return IPAD_4G_NAMESTRING;
            
            // iPad Air
            
        case UIDeviceIPadAir1G : return IPAD_AIR_1G_NAMESTRING;
            
            // iPad mini
            
        case UIDeviceIPadMini1G : return IPAD_MINI_1G_NAMESTRING;
        case UIDeviceIPadMini2G : return IPAD_MINI_2G_NAMESTRING;
            
            // Apple TV
            
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
        case UIDeviceAppleTV3 : return APPLETV_3G_NAMESTRING;
            
            // Simulator
            
        case UIDeviceSimulatoriPhone: return SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceSimulatoriPad: return SIMULATOR_IPAD_NAMESTRING;
        
            // Unknown
            
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
        case UIDeviceUnknowniPad : return IPAD_UNKNOWN_NAMESTRING;
        case UIDeviceUnknownAppleTV: return APPLETV_UNKNOWN_NAMESTRING;
        
            
        default: return IOS_FAMILY_UNKNOWN_DEVICE;
    }
}

- (UIDeviceFamily) deviceFamily
{
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"]) return UIDeviceFamilyAppleTV;
    
    return UIDeviceFamilyUnknown;
}

@end