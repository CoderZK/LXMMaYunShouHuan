//
//  LxmShengJiSheBeiVC.m
//  JawboneUP
//
//  Created by zk on 2020/8/19.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LxmShengJiSheBeiVC.h"
#import "LxmBLEManager.h"
#import "LxmShengJiProgressView.h"
@interface LxmShengJiSheBeiVC ()<DFUServiceDelegate,DFUProgressDelegate,LoggerDelegate>
@property(nonatomic,strong)NSString *fileStr;
@property(nonatomic,strong)UIButton  *shengJiBt ;
@property(nonatomic,strong)UILabel *LB;
@property(nonatomic,strong)NSData *data;
@property(nonatomic,strong)LxmShengJiProgressView *progressV;
@property(nonatomic,assign)BOOL isCanback;
@property (nonatomic, strong) DFUServiceController *dfuServiceController;
@property(nonatomic,strong)NSString *   serverFv;
@end

@implementation LxmShengJiSheBeiVC
-  (LxmShengJiProgressView *)progressV{
    if (_progressV == nil) {
        _progressV = [[LxmShengJiProgressView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    }
    return _progressV;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[LxmBLEManager shareManager] stopScan ];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[LxmBLEManager shareManager] startScan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if  (self.isZhengChang) {
       
    }else {
        self.peripheral = self.dataDict[@"per"];
        self.type = self.dataDict[@"type"];
        self.noStr = self.dataDict[@"no"];
    
        
    }
    [self getData];
    
    self.navigationItem.title = [NSString stringWithFormat:@"蓝牙:%@",self.peripheral.name];
    
    self.LB = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, ScreenW - 40, 20)];
    [self.view addSubview:self.LB];
    self.LB.textAlignment = NSTextAlignmentCenter;
    self.LB.textColor = CharacterDarkColor;
    
    self.shengJiBt = [[UIButton alloc] initWithFrame:CGRectMake(20, 180, ScreenW - 40, 40)];
    [self.shengJiBt setTitle:@"升级" forState:UIControlStateNormal];
    [self.shengJiBt addTarget:self action:@selector(shengJiClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shengJiBt setBackgroundImage:[UIImage imageNamed:@"bg_8"] forState:UIControlStateNormal];
    [self.shengJiBt setBackgroundImage:[UIImage imageNamed:@"btn_bujies"] forState:UIControlStateDisabled];
    self.shengJiBt.layer.cornerRadius = 10;
    self.shengJiBt.clipsToBounds = YES;
    [self.shengJiBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.shengJiBt];
    self.shengJiBt.hidden = YES;
    
    
    [[LxmBLEManager shareManager] connectPeripheral:self.peripheral];;
    
    
    
    
}

//- (void)setLeftnav {
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_back"] style:UIBarButtonItemStyleDone target:self action:@selector(baseLeftBtnClick)];
//    leftItem.tintColor = UIColor.whiteColor;
//    //        leftItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
//    self.navigationItem.leftBarButtonItem = leftItem;
//    
//}
////点击返回按钮
//- (void)baseLeftBtnClick {
//    
//    if (self.isCanback) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    
//    
//}

- (void)shengJiClickAction:(UIButton *)button  {
    self.shengJiBt.enabled = NO;
    [self shengJiAction];
    
}

//获取设备的固件号
//- (void)getNumerb {
//
//    [[LxmBLEManager shareManager] checkVersion:self.peripheral completed:^(BOOL success, NSString *hVersion, NSString *fVersion) {
//
//        NSLog(@"\n\n%@",@"456456456456456");
//        self.firmwareNo = fVersion;
//        self.noStr = hVersion;
//
//
//
//    }];
//
//}


- (void)getData {
    
    [SVProgressHUD show];
    NSString * url = @"";
    if (self.type.intValue == 3 || self.type.intValue == 1) {
        
        url = get_equipment_firmware;
        
    }else {
       url = get_child_equipment_firmware;
    }
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"versionNo"] = [NSString stringWithFormat:@"%d",self.noStr.intValue];
    [LxmNetworking networkingGET:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            [SVProgressHUD dismiss];
            
            self.fileStr = responseObject[@"result"][@"firmwareUrl"];
           NSString * firmwareNo = responseObject[@"result"][@"firmwareNo"];
            self.serverFv = firmwareNo;
            NSArray * strings =  responseObject[@"result"][@"firmwareByteData"];
            NSUInteger c = strings.count;
            uint8_t * bytes = malloc(sizeof(*bytes) *c);
            for (int i = 0 ; i < c; i++) {
                NSString * str = [strings objectAtIndex:i];
                int byte = [str intValue];
                bytes[i] = byte;
            }
            self.data = [NSData dataWithBytesNoCopy:bytes length:c freeWhenDone:YES];
            if (self.isZhengChang) {
                //正常升级的
                if (self.firmwareNo.intValue == firmwareNo.intValue) {
                    self.LB.text = [NSString stringWithFormat:@"已经是最新版本V%@",firmwareNo];
                    self.shengJiBt.hidden = YES;
                }else {
                   self.LB.text = [NSString stringWithFormat:@"最新版本V%@",firmwareNo];
                    self.shengJiBt.hidden = NO;
                }
            }else {
                self.LB.text = [NSString stringWithFormat:@"最新版本V%@",firmwareNo];
                self.shengJiBt.hidden = YES;
                [self shengJiAction];
            }
            
        }else
        {
            self.isCanback = YES;
            [SVProgressHUD dismiss];
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"]  message:[responseObject objectForKey:@"message"] atVC:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        self.isCanback = YES;
    }];
    
    
}

- (void)shengJiAction {
    [SVProgressHUD show];
    self.isCanback = NO;
//        NSString * path  = [[NSBundle mainBundle] pathForResource:@"8.0mom" ofType:@".zip"];
    NSError * error;
    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithZipFile:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.fileStr] options:(NSDataReadingMappedAlways) error:&error] type:(DFUFirmwareTypeApplication)];
//    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithZipFile:self.data];
//    DFUServiceInitiator * dfuInitiator = [[DFUServiceInitiator alloc]initWithQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
    DFUServiceInitiator * dfuInitiator = [[DFUServiceInitiator alloc] initWithCentralManager:[LxmBLEManager shareManager].centralManager target:self.peripheral];
    dfuInitiator = [dfuInitiator withFirmware:selectedFirmware];
    dfuInitiator.delegate = self;
    dfuInitiator.progressDelegate = self;
    dfuInitiator.logger = self;
    dfuInitiator.alternativeAdvertisingNameEnabled = NO;
    dfuInitiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = YES;
    self.dfuServiceController = [[dfuInitiator withFirmware:selectedFirmware] startWithTarget:self.peripheral];
     [self.progressV show];
}




- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond {
    NSLog(@"\n\n\n %d",progress);
    [SVProgressHUD dismiss];
   
    self.progressV.prog = progress;
    
    NSLog(@"%@",@"123");
    
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message {
    NSLog(@"\n\nmessage ===== %@",message);
    
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"error=%ld--%@",(long)error,message]];
    
    [self.progressV dismiss];
    
    NSLog(@"%@",@"");
    
    
}

- (void)logWith:(enum LogLevel)level message:(NSString *)message {
//    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"log =%ld--%@",(long)level,message]];
//
//    [self.progressV dismiss];
    
    NSLog(@"\n\nmessage =yyyyy==== %@",message);
    
    NSLog(@"%@",@"");
    
}

- (void)dfuStateDidChangeTo:(enum DFUState)state {
    
    NSLog(@"%d",state);
    
    
//    case connecting
//    case starting
//    case enablingDfuMode
//    case uploading
//    case validating
//    case disconnecting
//    case completed
//    case aborted
    
    
    if (state == DFUStateConnecting) {
        self.progressV.LB.text = @"链接中...";
    }else if (state == DFUStateStarting) {
        self.progressV.LB.text = @"开始升级";
    }
    if (state == DFUStateAborted ) {
        [SVProgressHUD showErrorWithStatus:@"升级失败,请重试"];
        self.shengJiBt.enabled = NO;
        self.isCanback = YES;
    }
    if (state == DFUStateCompleted) {
        [SVProgressHUD showSuccessWithStatus:@"升级完成"];
        self.peripheral.fVersion = self.serverFv;
        [self.progressV dismiss];
        
        if (self.shengJiChengGongBlock != nil) {
            self.shengJiChengGongBlock();
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self.navigationController popViewControllerAnimated:YES];
            [LxmEventBus sendEvent:@"sjcg" data:nil];
        });
    }
    
    NSLog(@"%@",@"123");
    
}



@end
