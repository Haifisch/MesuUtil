//
//  main.m
//  MesuUtility
//
//  Created by Haifisch on 9/27/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

//meth is dope ~jk9357

#import <Foundation/Foundation.h>
#define BUILD "B2792014"
void help(){
    printf("-d      List all OTA updates for one device (ex. MesuUtility -d \"iPod2,1\")\n");
    printf("-a      List all OTA updates for all devices");
}
void allForDevice(char *device){
    NSURL *mesuURL = [NSURL URLWithString:@"http://mesu.apple.com/assets/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"];
    NSDictionary *mesuData = [NSDictionary dictionaryWithContentsOfURL:mesuURL];
    printf("Available OTA updates;\n");
    int count;
    NSString *optDevice = [NSString stringWithUTF8String:device];
    while (count < [mesuData[@"Assets"] count]) {
        if([mesuData[@"Assets"][count][@"SupportedDevices"][0] isEqualToString:optDevice]){
            printf("======================\n");
            printf("Device: %s\n",[mesuData[@"Assets"][count][@"SupportedDevices"][0] UTF8String]);
            printf("Version: %s\n",[mesuData[@"Assets"][count][@"OSVersion"] UTF8String]);
            printf("Build: %s\n",[mesuData[@"Assets"][count][@"Build"] UTF8String]);
            if ([mesuData[@"Assets"][count][@"ReleaseType"] UTF8String] == NULL) {
                printf("Release Type: Production\n");
            }else{
                printf("Release Type: Beta\n");
            }
            printf("Installation Size: %i MB\n", [mesuData[@"Assets"][count][@"InstallationSize"] intValue]/1024/1024);
        }else if (device == NULL){
            printf("======================\n");
            printf("Device: %s\n",[mesuData[@"Assets"][count][@"SupportedDevices"][0] UTF8String]);
            printf("Version: %s\n",[mesuData[@"Assets"][count][@"OSVersion"] UTF8String]);
            printf("Build: %s\n",[mesuData[@"Assets"][count][@"Build"] UTF8String]);
            if ([mesuData[@"Assets"][count][@"ReleaseType"] UTF8String] == NULL) {
                printf("Release Type: Production\n");
            }else{
                printf("Release Type: Beta\n");
            }
            printf("Installation Size: %i MB\n", [mesuData[@"Assets"][count][@"InstallationSize"] intValue]/1024/1024);
        }else {
            printf("======================\n");
            printf("No OTA updates were found.\n");

        }
        count++;
    }
    printf("======================\n");
    
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        // insert code here...
        printf("MesuUtility v0.0.1 BUILD: %s\n",BUILD);
        int index;
        int c;
        char *cvalue = NULL;

        opterr = 0;
        if (argc > 1) {
            while ((c = getopt (argc, argv, "ad:")) != -1)
                switch (c)
            {
                case 'd':
                    cvalue = optarg;
                    break;
                case 'a':
                    cvalue = NULL;
                    break;
                case '?':
                    if (optopt == 'c')
                        fprintf (stderr, "Option -%c requires an argument.\n", optopt);
                    else if (isprint (optopt))
                        fprintf (stderr, "Unknown option `-%c'.\n", optopt);
                    else
                        fprintf (stderr,
                                 "Unknown option character `\\x%x'.\n",
                                 optopt);
                    return 1;
                default:
                    abort();
            }
            if (cvalue == NULL) {
                allForDevice(NULL);
            }else {
                allForDevice(cvalue);
            }
            for (index = optind; index < argc; index++)
                printf ("Non-option argument %s\n", argv[index]);
        }else {
            help();
        }
        
    }
    return 0;
}
