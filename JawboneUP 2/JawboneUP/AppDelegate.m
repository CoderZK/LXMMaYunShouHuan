//
//  AppDelegate.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/12.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "AppDelegate.h"
#import "LxmLoginVC.h"
#import "TabBarController.h"
#import "LxmSearchDeviceVC.h"
#import "BaseNavigationController.h"
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "LxmWeiTuoVC.h"
#import "LxmFriendRequestVC.h"
#import <AVFoundation/AVFoundation.h>
#import "LxmEventBus.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MGKeepActiveTool.h"


//友盟账号 heartcolour@163.com xysh2017
#define UMKey @"5a04f92df29d987a3000005e"
#define UMSecert @"5xhokrqy5j7oeel93zmcgjkvdthlomik"
//api485@163.com  Heartcolor485163
@interface AppDelegate ()<UNUserNotificationCenterDelegate>
{
    AVPlayer *_player;
}
@end
@implementation AppDelegate
 //苹果账号 api485@163.com  Heartcolor485163

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self initPush];
    [self initUMeng:launchOptions];
    bool  login = [LxmTool ShareTool].isLogin;
    if (login&&[[LxmTool ShareTool].hasPerfect intValue] == 1) {
        TabBarController *BarVC = [[TabBarController alloc] init];
        self.window.rootViewController = BarVC;
    } else {
        self.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[LxmLoginVC alloc] init]];
    }
    
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    [self initSDWebimage];
    [self.window makeKeyAndVisible];
    [self initLocationPush:application finishLaunchingWithOptions:launchOptions];
    [LxmEventBus registerEvent:@"playSound" block:^(id data) {
        [self playSound];
    }];

    return YES;
}

- (void)playSound {
    NSString *mp3 = @"";
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [_player pause];
        _player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:[NSBundle.mainBundle pathForResource:@"warning.mp3" ofType:nil]]];
        [_player play];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//默认震动效果
    } else {
        UILocalNotification *notification=[[UILocalNotification alloc] init];
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:0];
        notification.repeatInterval=0;
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber=0;
        notification.soundName= @"warning.mp3";
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

-(void)initUMeng:(NSDictionary *)launchOptions
{
    [UMessage startWithAppkey:UMKey launchOptions:launchOptions httpsEnable:YES];
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
//    if (@available(iOS 10.0, *)) {
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate=self;
//         UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
//        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            
//        }];
//    } else {
//        // Fallback on earlier versions
//    }

}
-(void)initSDWebimage
{
    NSString *userAGENT = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)",
                           [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
   // [[SDWebImageDownloader sharedDownloader] setValue:userAGENT forHTTPHeaderField:@"User-Agent"];
}

- (BOOL)initLocationPush:(UIApplication *)application finishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
    [application registerUserNotificationSettings:setting];
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        // 这里添加处理代码
    }
    return YES;
}



-(void)initPush
{
    //1.向系统申请推送
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    }
    else
    {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}

//在用户接受推送通知后系统会调用
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

    self.pushToken = deviceToken;
    if (![LxmTool ShareTool].isClosePush)
    {
        [UMessage registerDeviceToken:deviceToken];
        NSString * token = @"";

          if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {
                 if (![deviceToken isKindOfClass:[NSData class]]) {
                     //记录获取token失败的描述
                     return;
                 }
                 const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
                 token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                                       ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                                       ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                                       ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
                 NSLog(@"deviceToken1:%@", token);
             } else {
                token = [NSString
                                stringWithFormat:@"%@",deviceToken];
                 token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
                 token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
                 token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];

             }
        //将deviceToken给后台
        NSLog(@"send_token:%@",token);
        [LxmTool ShareTool].deviceToken = token;
        [[LxmTool ShareTool] uploadDeviceToken];
    }
    else
    {
        [UMessage registerDeviceToken:nil];
        [LxmTool ShareTool].deviceToken = @"";
        [[LxmTool ShareTool] uploadDeviceToken];
    }
    
    
    
//    self.pushToken = deviceToken;
//    if (![LxmTool ShareTool].isClosePush)
//    {
//        [UMessage registerDeviceToken:deviceToken];
//        //2.获取到deviceToken
//        NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//        //将deviceToken给后台
//        NSLog(@"send_token:%@",token);
//        [LxmTool ShareTool].deviceToken = token;
//        [[LxmTool ShareTool] uploadDeviceToken];
//    }
//    else
//    {
//        [UMessage registerDeviceToken:nil];
//        [LxmTool ShareTool].deviceToken = @"";
//        [[LxmTool ShareTool] uploadDeviceToken];
//    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [UMessage didReceiveRemoteNotification:userInfo];
    if (![LxmTool ShareTool].isLogin) {
        [SVProgressHUD showErrorWithStatus:@"您目前处于离线状态"];
        return;
    }
    TabBarController *BarVC=(TabBarController *)self.window.rootViewController;
    BarVC.selectedIndex = 1;
    UINavigationController * navi = BarVC.selectedViewController;
    for (UIViewController * vc in navi.viewControllers) {
        if ([vc isKindOfClass:[LxmWeiTuoVC class]]) {
            [LxmTool ShareTool].messageID = [userInfo objectForKey:@"msgId"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfo" object:vc];
        }
    }
    
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        
        
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        if (![LxmTool ShareTool].isLogin) {
            [SVProgressHUD showErrorWithStatus:@"您目前处于离线状态"];
            return;
        }
        TabBarController *BarVC=(TabBarController *)self.window.rootViewController;
        BarVC.selectedIndex = 1;
        UINavigationController * navi = BarVC.selectedViewController;
        for (UIViewController * vc in navi.viewControllers) {
            if ([vc isKindOfClass:[LxmWeiTuoVC class]]) {
                [LxmTool ShareTool].messageID = [userInfo objectForKey:@"msgId"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfo" object:vc];
            }
        }
        

    }else{
        //应用处于后台时的本地推送接受
        NSLog(@"11111");
    }
    completionHandler();
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [MGKeepActiveTool keepActive:YES];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [MGKeepActiveTool keepActive:NO];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"JawboneUP"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
