//
//  LxmModifyDeviceInforVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/30.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmModifyDeviceInforVC.h"
#import "UIViewController+OpenImagePicker.h"
#import "LxmStyleSelectView.h"
#import "LxmTextTFView.h"

#import "LxmBLEManager.h"

@interface LxmModifyDeviceInforVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UIImageView * _headerImgView ;
    UILabel * _titleLab;
    LxmStyleSelectView * _selectView;
    UILabel * _baojingStyleLab;
    
    LxmTextTFView *_jixingView;
    LxmTextTFView *_nickNameView;
    LxmTextTFView * _phoneView;
    
}
@end

@implementation LxmModifyDeviceInforVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)
//    name:UITextFieldTextDidChangeNotification object:nil];
    self.navigationItem.title  = @"修改资料";
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 351 + 50)];
    self.tableView.tableHeaderView = headerView;
    
    _headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW*0.5-50, 25, 100, 100)];
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:[Base_img_URL stringByAppendingString:self.model.equHead]] placeholderImage:[UIImage imageNamed:@"pic_1"] options:SDWebImageRetryFailed];
    _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImgView.layer.cornerRadius = 50;
    _headerImgView.clipsToBounds = YES;
    _headerImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touxiangBtnClick)];
    [_headerImgView addGestureRecognizer:tapGesturRecognizer];
    [headerView addSubview:_headerImgView];
    
    _jixingView = [[LxmTextTFView alloc] initWithFrame:CGRectMake(0, 150, ScreenW, 50)];
    _jixingView.backgroundColor = [UIColor whiteColor];
    _jixingView.leftLab.text = @"机型";
    _jixingView.rightTF.userInteractionEnabled = NO;
    if ([self.role isEqualToString:@"主机"]) {
        _jixingView.rightTF.text = @"主机";
    }else{
        _jixingView.rightTF.text = @"子机";
    }
    
    [headerView addSubview:_jixingView];
    
    
    _nickNameView = [[LxmTextTFView alloc] initWithFrame:CGRectMake(0, 200.5, ScreenW, 50)];
    _nickNameView.backgroundColor = [UIColor whiteColor];
    _nickNameView.leftLab.text = @"设备昵称";
    _nickNameView.rightTF.placeholder = @"请输入设备昵称";
    _nickNameView.rightTF.text = self.model.nickname;
    _nickNameView.rightTF.delegate = self;
    _nickNameView.rightTF.tag = 100;
    [headerView addSubview:_nickNameView];
    
    
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:bgView];
    if ([self.role isEqualToString:@"主机"]) {
        bgView.frame = CGRectMake(0, 270, ScreenW, 54);
    } else {
        _phoneView = [[LxmTextTFView alloc] initWithFrame:CGRectMake(0, 251, ScreenW, 50)];
        _phoneView.backgroundColor = [UIColor whiteColor];
        _phoneView.leftLab.text = @"紧急电话";
        _phoneView.rightTF.placeholder = @"请输入紧急电话";
        _phoneView.rightTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneView.rightTF.delegate = self;
        _phoneView.rightTF.tag = 101;
        [self.tableView addSubview:_phoneView];
        
        bgView.frame = CGRectMake(0, 320, ScreenW, 54);
    }
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 7, ScreenW-40, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_8"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    [self loadModifiedData];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger length = [newString charactorNumber];//转换过的长度
    NSLog(@"%@------长度: %ld",newString,length);

    if (textField.tag == 100) {
        if (length >4) {
            return NO;
        }else {
            return YES;
        }
    }else if (textField.tag == 101) {
        if (length > 11) {
            return NO;
        }else {
            return YES;
        }
    }
    return YES;
}

//- (void)textFiledEditChanged:(id)notification {
//    UITextRange *selectedRange = _nickNameView.rightTF.markedTextRange;
//    //过滤非汉字字符
//    UITextPosition *position = [_nickNameView.rightTF positionFromPosition:selectedRange.start offset:0];
//    if (!position) {
//        _nickNameView.rightTF.text = [self filterCharactor:_nickNameView.rightTF.text withRegex:@"[^\u4e00-\u9fa5]"];
//        if (_nickNameView.rightTF.text.length >= 2) {
//            _nickNameView.rightTF.text = [_nickNameView.rightTF.text substringToIndex:2];
//        }
//    }
//}

//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

-(void)btnClick {
    NSString * str = [LxmURLDefine getModifyDeviceURL];
    NSNumber *type = @0;
    if ([self.role isEqualToString:@"主机"]) {
           type = @1;
            NSDictionary * dict = @{@"token":[LxmTool ShareTool].session_token,
                                       @"userEquId":self.userEquId,
                                       @"nickname":_nickNameView.rightTF.text,
                                       @"type" : type
                                       };
               [SVProgressHUD show];
               [LxmNetworking NetWorkingUpLoad:str image:_headerImgView.image image1:nil parameters:dict name:@"equHead" name1:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                   [SVProgressHUD dismiss];
                   if ([[responseObject objectForKey:@"key"] intValue] == 1) {
                       [SVProgressHUD showSuccessWithStatus:@"设备信息修改成功"];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"bindingListChanged" object:nil];
                       [self.navigationController popViewControllerAnimated:YES];
                       
                   }else{
                       [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
                   }
               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [SVProgressHUD dismiss];
               }];
       } else {
           if (LxmBLEManager.shareManager.isTongbuStep || LxmBLEManager.shareManager.isTongbuDistance) {
               [SVProgressHUD showErrorWithStatus:@"正在同步硬件数据!,所有硬件相关操作暂不能执行!"];
               return;
           }
           
           type = @2;
           if (_nickNameView.rightTF.text.length == 0) {
               [SVProgressHUD showErrorWithStatus:@"请输入1~2汉字的设备名称"];
               return;
           }
           if (_nickNameView.rightTF.text.length > 2) {
               [SVProgressHUD showErrorWithStatus:@"请输入1~2汉字的设备名称"];
               return;
           }
           if (_phoneView.rightTF.text.length != 11) {
               [SVProgressHUD showErrorWithStatus:@"请输入11位的紧急联系电话!"];
               return;
           }
           
           WeakObj(self);
           void(^modifyBlock)(void) = ^(void){
               if (selfWeak.isConnectWork) {
                   CBPeripheral *subP = [LxmBLEManager.shareManager peripheralWithTongXinId:selfWeak.model.communication];
                   CBPeripheral *mainP = [LxmBLEManager.shareManager peripheralWithTongXinId:selfWeak.mainModel.communication];
                   if (subP.state == CBPeripheralStateConnected && mainP.state == CBPeripheralStateConnected) {
                       [LxmBLEManager.shareManager setDeviceName:subP tongxinID:selfWeak.model.communication deviceName: _nickNameView.rightTF.text completed:^(BOOL success, NSString *tips) {
                           if (success) {
                               [LxmBLEManager.shareManager setDeviceName:mainP tongxinID:selfWeak.model.communication deviceName:_nickNameView.rightTF.text completed:^(BOOL success, NSString *tips) {
                                   if (success) {
                                       NSDictionary * dict = @{@"token":[LxmTool ShareTool].session_token,
                                                                                    @"userEquId":self.userEquId,
                                                                                    @"nickname":_nickNameView.rightTF.text,
                                                                                    @"criticalTel":_phoneView.rightTF.text,
                                                                                    @"type" : type
                                                                                    };
                                                            [SVProgressHUD show];
                                                            [LxmNetworking NetWorkingUpLoad:str image:_headerImgView.image image1:nil parameters:dict name:@"equHead" name1:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                [SVProgressHUD dismiss];
                                                                if ([[responseObject objectForKey:@"key"] intValue] == 1) {
                                                                    [SVProgressHUD showSuccessWithStatus:@"设备信息修改成功"];
                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"bindingListChanged" object:nil];
                                                                    [selfWeak.navigationController popViewControllerAnimated:YES];
                                                                    
                                                                }else{
                                                                    [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
                                                                }
                                                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                 [SVProgressHUD dismiss];
                                                            }];
                                   } else {
                                       [SVProgressHUD showErrorWithStatus:@"主机设备更新子机姓名失败!"];
                                   }
                               }];
                           } else {
                               [SVProgressHUD showErrorWithStatus:tips];
                           }
                       }];
                   } else {
                       if (subP.state != CBPeripheralStateConnected) {
                           [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"设备%@已断开连接!",self.model.nickname]];
                       } else {
                           [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"设备%@已断开连接!",self.mainModel.equNickname]];
                       }
                   }
                   
               } else {
                   [SVProgressHUD showErrorWithStatus:@"当前无互联网连接!"];
               }
           };
           
           if ([_phoneView.rightTF.text isEqualToString:self.model.criticalTel]) {
               modifyBlock();
           } else {
               CBPeripheral *subP = [LxmBLEManager.shareManager peripheralWithTongXinId:selfWeak.model.communication];
               [LxmBLEManager.shareManager setSubDevicePhone:subP phone:_phoneView.rightTF.text completed:^(BOOL success, NSString *tips) {
                   if (success) {
                       modifyBlock();
                   } else {
                       [SVProgressHUD showErrorWithStatus:@"子机修改紧急联系方式失败!"];
                   }
               }];
           }
           
           
       }
   
    
}

-(void)loadModifiedData {
    NSString * str = [LxmURLDefine getOwerDeviceURL];
    NSNumber *type = @0;
   if ([self.role isEqualToString:@"主机"]){
       type = @1;
   } else {
       type = @2;
   }
    NSDictionary * dict = @{@"token":[LxmTool ShareTool].session_token,
                            @"userEquId":self.userEquId,
                            @"type" : type
                            };
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            self.model.nickname = [[responseObject objectForKey:@"result"] objectForKey:@"nickname"];
            self.model.equHead = [[responseObject objectForKey:@"result"] objectForKey:@"equHead"];
            if (type.intValue == 2) {
                self.model.criticalTel = [[responseObject objectForKey:@"result"] objectForKey:@"criticalTel"];
                _phoneView.rightTF.text = self.model.criticalTel;
            }
            _nickNameView.rightTF.text = self.model.nickname;
            
            [_headerImgView sd_setImageWithURL:[NSURL URLWithString:[Base_img_URL stringByAppendingString:self.model.equHead]] placeholderImage:[UIImage imageNamed:@"pic_1"] options:SDWebImageRetryFailed];
        }else{
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)touxiangBtnClick
{
    //上传设备头像
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选择图片方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openImagePickerWithAction:OpenImagePickerAction_xiangce completed:^(UIImage *image, NSString *filePath) {
            
            _headerImgView.image = image;
        }];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openImagePickerWithAction:OpenImagePickerAction_paizhao completed:^(UIImage *image, NSString *filePath) {
            
            _headerImgView.image = image;
        }];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
