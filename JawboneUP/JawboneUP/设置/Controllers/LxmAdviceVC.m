//
//  LxmAdviceVC.m
//  ShareGo
//
//  Created by 李晓满 on 16/4/21.
//  Copyright © 2016年 李晓满. All rights reserved.
//

#import "LxmAdviceVC.h"
#import "IQTextView.h"
@interface LxmAdviceVC ()<UITextViewDelegate>
{
    IQTextView * _commentTF;
    UILabel * _numLab;
}
@end

@implementation LxmAdviceVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    self.tableView.backgroundColor = BGGrayColor;
    [self initSubviews];
}

-(void)initSubviews
{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 180)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:bgView];
    
    _commentTF=[[IQTextView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 140)];
    _commentTF.layer.cornerRadius=5;
    _commentTF.font = [UIFont systemFontOfSize:16];
    _commentTF.placeholder=@"请描述您的问题";
    _commentTF.delegate = self;
    [bgView addSubview:_commentTF];
    
    UILabel * numLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, ScreenW, 20)];
    _numLab = numLab;
    _numLab.text = @"0/200";
    numLab.textAlignment = 2;
    numLab.textColor = [CharacterGrayColor colorWithAlphaComponent:0.5];
    numLab.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numLab];
    
    
    UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0,200, ScreenW, 64)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:bgView1];

    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, ScreenW-20, 44)];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_8"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10;
    btn.clipsToBounds = YES;
    btn.tag = 101;
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(upLoadCLick) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:btn];
}
#pragma mark-文本内容发生改变

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
        //        self.infoDic[@""]=textField.text;
        [SVProgressHUD showErrorWithStatus:@"最多200字哦"];
    }else{
        _numLab.text = [NSString stringWithFormat:@"%ld/200",textView.text.length];
    }
}
-(void)upLoadCLick
{
    if (_commentTF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请描述您的问题"];
        return;
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine getAdviceURL] parameters:@{@"token":[LxmTool ShareTool].session_token,@"content":_commentTF.text} success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"意见反馈成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}



@end
