//
//  ViewController.m
//  UIDevice-HardwareExample
//
//  Created by Yu Sugawara on 2014/02/20.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "ViewController.h"
#import "UIDevice-Hardware.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
#define k1MB 1024000.
    UIDevice *device = [UIDevice currentDevice];
    NSString *detailStr;
    switch (indexPath.row) {
        case 0:
            detailStr = [device platform];
            break;
        case 1:
            detailStr = [device hwmodel];
            break;
        case 2:
            detailStr = [NSString stringWithFormat:@"%@", @([device platformType])];
            break;
        case 3:
            detailStr = [device platformString];
            break;
        case 4:
            detailStr = [NSString stringWithFormat:@"%@", @([device deviceFamily])];
            break;
        case 5:
            detailStr = [NSString stringWithFormat:@"%@", @([device cpuFrequency])];
            break;
        case 6:
            detailStr = [NSString stringWithFormat:@"%@", @([device busFrequency])];
            break;
        case 7:
            detailStr = [NSString stringWithFormat:@"%@", @([device cpuCount])];
            break;
        case 8:
            detailStr = [NSString stringWithFormat:@"%.1fMB", [device totalMemory]/k1MB];
            break;
        case 9:
            detailStr = [NSString stringWithFormat:@"%.1fMB", [device userMemory]/k1MB];
            break;
        case 10:
            detailStr = [NSString stringWithFormat:@"%.1fMB", [device totalDiskSpace].floatValue/k1MB];
            break;
        case 11:
            detailStr = [NSString stringWithFormat:@"%.1fMB", [device freeDiskSpace].floatValue/k1MB];
            break;
        default:
            break;
    }
    cell.detailTextLabel.text = detailStr;
}

#pragma mark -

- (IBAction)refreshButtonDidPush:(id)sender
{
    NSLog(@"%s", __func__);
    [self.tableView reloadData];
}

@end
