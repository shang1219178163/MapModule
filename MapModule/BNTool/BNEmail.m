//
//  BNEmail.m
//  Location
//
//  Created by BIN on 2017/12/22.
//  Copyright © 2017年 Location. All rights reserved.
//

#import "BNEmail.h"

#import  <MessageUI/MFMailComposeViewController.h>

#import "NNGloble.h"
#import "NSData+Helper.h"

@interface BNEmail ()<MFMailComposeViewControllerDelegate>

@end

@implementation BNEmail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)sendBug:(NSString *)bug interface:(NSException *)interfaceinfo{
    
    NSString * emailAddress = @"1219176600@qq.com";
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSDate *dd = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *crashLogInfo = [NSString stringWithFormat:@"exception type : %@ \n crash reason : %@ \n call stack time : %@", interfaceinfo, bug, dd];
    NSString *urlStr = [NSString stringWithFormat:@"mailto://%@?subject=bug report&body=Thank you for your cooperation!""Error Details:%@",emailAddress,crashLogInfo];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([[UIApplication sharedApplication] openURL:url]) {
        
    } else {
        DDLog(@"____________________________________________________________邮件发送失败!!!");
    }
}

-(void)sendEmailDict:(NSDictionary *)dict attachmentDict:(NSDictionary *)attachmentDict{

    NSString * mimeType = @"";
    if ([attachmentDict.allKeys containsObject:kEmail_attachMineType]) {
        mimeType = attachmentDict[kEmail_attachMineType];
        
    } else {
        NSArray * fileNameArray = [attachmentDict[kEmail_attachFilName] componentsSeparatedByString:@"."];
        mimeType = [fileNameArray lastObject];

    }
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:dict[kEmail_Recipients]];
    [controller setTitle:dict[kEmail_Title]];
    [controller setSubject:dict[kEmail_Subject]];
    [controller setMessageBody:dict[kEmail_Body] isHTML:YES];
    
    [controller addAttachmentData:attachmentDict[kEmail_attachData] mimeType:mimeType fileName:attachmentDict[kEmail_attachFilName]];

    [self presentViewController:controller animated:YES completion:^{
        
    }];

}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";

            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";

            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            break;
        default:
            break;
    }
    

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


@end
