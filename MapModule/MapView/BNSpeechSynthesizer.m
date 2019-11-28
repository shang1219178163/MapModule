//
//  BNSpeechSynthesizer.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/3.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "BNSpeechSynthesizer.h"
#import "AVSpeechSynthesizer+Helper.h"
#import "NNGloble.h"

@implementation BNSpeechSynthesizer

+ (instancetype)shared{
    static id _instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BNSpeechSynthesizer alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        AVAudioSession *session = AVAudioSession.sharedInstance;
        [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
        
    }
    return self;
}

#pragma mark -funtions

- (void)speakString:(NSString *)string{
     [self speakString:string voiceLanguage:kLanguageCN];
}

- (void)speakString:(NSString *)string voiceLanguage:(NSString *)voiceLanguage{
    AVSpeechUtterance *utterance = AVSpeechUtteranceDefault(string, voiceLanguage);
    //开始播放
    if (self.speechSynthesizer.isSpeaking) {
        [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
    }
    [self.speechSynthesizer speakUtterance:utterance];
}

- (void)stopSpeak{
    if (self.speechSynthesizer){
        [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}

#pragma mark - - lazy

-(AVSpeechSynthesizer *)speechSynthesizer{
    if (!_speechSynthesizer) {
        _speechSynthesizer = [[AVSpeechSynthesizer alloc]init];
        _speechSynthesizer.delegate = self;
        
    }
    return _speechSynthesizer;
}

@end
