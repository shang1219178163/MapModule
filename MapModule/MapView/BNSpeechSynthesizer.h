//
//  BNSpeechSynthesizer.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/3.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNSpeechSynthesizer : NSObject<AVSpeechSynthesizerDelegate>

+ (instancetype)shared;

@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;

- (void)speakString:(NSString *)string voiceLanguage:(NSString *)voiceLanguage;

- (void)speakString:(NSString *)string;

- (void)stopSpeak;

@end

NS_ASSUME_NONNULL_END
