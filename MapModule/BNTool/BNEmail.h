//
//  BNEmail.h
//  Location
//
//  Created by BIN on 2017/12/22.
//  Copyright © 2017年 Location. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kEmail_Title @"kEmail_Title"
#define kEmail_Subject @"kEmail_Subject"
#define kEmail_Body @"kEmail_Body"

#define kEmail_Recipients @"kEmail_Recipients"


#define kEmail_attachData       @"kEmail_attachData"
#define kEmail_attachFilName    @"kEmail_attachFilName"
#define kEmail_attachMineType   @"kEmail_attachMineType"


@interface BNEmail : UIViewController

+ (void)sendBug:(NSString *)bug interface:(NSException *)interfaceinfo;

-(void)sendEmailDict:(NSDictionary *)dict attachmentDict:(NSDictionary *)attachmentDict;

@end
