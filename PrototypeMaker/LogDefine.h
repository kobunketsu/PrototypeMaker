//
//  DebugLog.h
//  PaintProjector
//
//  Created by 胡 文杰 on 8/19/14.
//  Copyright (c) 2014 WenjiHu. All rights reserved.
//

//debug color
#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#ifdef DEBUG
//普通的log
    #define __DebugLog(s, ...) NSLog(@"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

//警告的log
    #define __DebugLogWarn(s, ...) NSLog(XCODE_COLORS_ESCAPE @"fg255,255,0;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])


//严重错误的log
    #define __DebugLogError(s, ...) NSLog(XCODE_COLORS_ESCAPE @"fg255,0,0;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

//成功的log
    #define __DebugLogWriteSuccess(s, ...) NSLog(XCODE_COLORS_ESCAPE @"fg0,255,0;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

//系统函数调用的log
    #define __DebugLogSystem(s, ...) NSLog(XCODE_COLORS_ESCAPE @"bg127,127,127;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

//用户交互的log
    #define __DebugLogIBAction(s, ...) NSLog(XCODE_COLORS_ESCAPE @"bg0,64,64;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

//函数开始的log
    #define __DebugLogFuncStart(s, ...) NSLog(XCODE_COLORS_ESCAPE @"bg0,0,127;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

//函数每帧都调用的log
    #define __DebugLogFuncUpdate(s, ...) NSLog(XCODE_COLORS_ESCAPE @"bg0,0,255;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

//OpenGLES调用的log
    #define __DebugLogGL(s, ...) NSLog(XCODE_COLORS_ESCAPE @"bg255,0,255;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

//函数每帧都调用的log (去除self指针)
    #define __DebugLogProfile(s, ...) NSLog(XCODE_COLORS_ESCAPE @"fg255,125,0;" @"<%@:(%d)> %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

    #define __DebugLogGLGroupStart(s, ...) glPushGroupMarkerEXT(0, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String]); _DebugLogGL(s, ##__VA_ARGS__);

    #define __DebugLogGLGroupEnd() glPopGroupMarkerEXT();

    #define DebugLogGLSnapshotStart [[REGLWrapper current].context presentRenderbuffer:GL_RENDERBUFFER];
    #define DebugLogGLSnapshotEnd DebugLogGLSnapshotStart
    #define DebugLogGLLabel(type,object,length,label) glLabelObjectEXT(type,object,length,label)

#else
//release版需要输出的LOG类型分：1.testflight log. 2.distribution log
//所有release版本的log都会testflight阶段显示在testflight和flurry中
    #define __DebugLog(s, ...)
    #define __DebugLogWarn(s, ...)
    #define __DebugLogError(s, ...)
    #define __DebugLogWriteSuccess(s, ...)
    #define __DebugLogSystem(s, ...) NSString *str = [NSString stringWithFormat:@"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]];[RemoteLog log:str];
    #define __DebugLogIBAction(s, ...)
    #define __DebugLogFuncStart(s, ...) NSString *str = [NSString stringWithFormat:@"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]];[RemoteLog log:str];
    #define __DebugLogFuncUpdate(s, ...)
    #define __DebugLogGL(s, ...)
    #define __DebugLogGLGroupStart(s, ...)
    #define __DebugLogGLGroupEnd()
    #define __DebugLogProfile(s, ...)

    #define DebugLogGLSnapshotStart
    #define DebugLogGLSnapshotEnd
    #define DebugLogGLLabel(type,object,length,label)
#endif


#if DEBUG_SCREENLOG
#define _DebugLog(s,...) __DebugLog(s, ##__VA_ARGS__);\
[[UIApplication sharedApplication].delegate performSelector:@selector(displayLogToScreen:) withObject:[NSString stringWithFormat:@"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]]];

#define _DebugLogWarn(s,...) __DebugLogWarn(s, ##__VA_ARGS__);\
[[UIApplication sharedApplication].delegate performSelector:@selector(displayLogToScreen:) withObject:[NSString stringWithFormat:XCODE_COLORS_ESCAPE @"fg255,255,0;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]]];

#define _DebugLogError(s,...) __DebugLogError(s, ##__VA_ARGS__);\
[[UIApplication sharedApplication].delegate performSelector:@selector(displayLogToScreen:) withObject:[NSString stringWithFormat:XCODE_COLORS_ESCAPE @"fg255,0,0;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]]];

#define _DebugLogWriteSuccess(s,...) __DebugLogWriteSuccess(s, ##__VA_ARGS__);\
[[UIApplication sharedApplication].delegate performSelector:@selector(displayLogToScreen:) withObject:[NSString stringWithFormat:XCODE_COLORS_ESCAPE @"fg0,255,0;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]]];

#define _DebugLogSystem(s,...) __DebugLogSystem(s, ##__VA_ARGS__);\
[[UIApplication sharedApplication].delegate performSelector:@selector(displayLogToScreen:) withObject:[NSString stringWithFormat:XCODE_COLORS_ESCAPE @"bg127,127,127;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]]];

#define _DebugLogIBAction(s,...) __DebugLogIBAction(s, ##__VA_ARGS__);\
[[UIApplication sharedApplication].delegate performSelector:@selector(displayLogToScreen:) withObject:[NSString stringWithFormat:XCODE_COLORS_ESCAPE @"bg0,64,64;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]]];

#define _DebugLogFuncStart(s,...) __DebugLogFuncStart(s, ##__VA_ARGS__);\
[[UIApplication sharedApplication].delegate performSelector:@selector(displayLogToScreen:) withObject:[NSString stringWithFormat:XCODE_COLORS_ESCAPE @"bg0,0,127;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]]];

#define _DebugLogFuncUpdate(s,...) __DebugLogFuncUpdate(s, ##__VA_ARGS__);\
[[UIApplication sharedApplication].delegate performSelector:@selector(displayLogToScreen:) withObject:[NSString stringWithFormat:XCODE_COLORS_ESCAPE @"bg0,0,255;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]]];

#define _DebugLogGL(s,...) __DebugLogGL(s, ##__VA_ARGS__);\
[[UIApplication sharedApplication].delegate performSelector:@selector(displayLogToScreen:) withObject:[NSString stringWithFormat:XCODE_COLORS_ESCAPE @"bg255,0,255;" @"<%p %@:(%d)> %@" XCODE_COLORS_RESET, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]]];

#define _DebugLogProfile(s,...) __DebugLogProfile(s, ##__VA_ARGS__);\
[[UIApplication sharedApplication].delegate performSelector:@selector(displayLogToScreen:) withObject:[NSString stringWithFormat:XCODE_COLORS_ESCAPE @"fg255,125,0;" @"<%@:(%d)> %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]]];

#define _DebugLogGLGroupStart(s,...) __DebugLogGLGroupStart(s, ##__VA_ARGS__);\

#define _DebugLogGLGroupEnd(s,...) __DebugLogGLGroupEnd(s, ##__VA_ARGS__);\

#else
#define _DebugLog(s,...) __DebugLog(s, ##__VA_ARGS__)
#define _DebugLogWarn(s,...) __DebugLogWarn(s, ##__VA_ARGS__)
#define _DebugLogError(s,...) __DebugLogError(s, ##__VA_ARGS__)
#define _DebugLogWriteSuccess(s,...) __DebugLogWriteSuccess(s, ##__VA_ARGS__)
#define _DebugLogSystem(s,...) __DebugLogSystem(s, ##__VA_ARGS__)
#define _DebugLogIBAction(s,...) __DebugLogIBAction(s, ##__VA_ARGS__)
#define _DebugLogFuncStart(s,...) __DebugLogFuncStart(s, ##__VA_ARGS__)
#define _DebugLogFuncUpdate(s,...) __DebugLogFuncUpdate(s, ##__VA_ARGS__)
#define _DebugLogGL(s,...) __DebugLogGL(s, ##__VA_ARGS__)
#define _DebugLogProfile(s,...) __DebugLogProfile(s, ##__VA_ARGS__)
#define _DebugLogGLGroupStart(s,...) __DebugLogGLGroupStart(s, ##__VA_ARGS__)
#define _DebugLogGLGroupEnd(s,...) __DebugLogGLGroupEnd(s, ##__VA_ARGS__)
#endif

//global switcher
#define DebugLog(s,...)                 _DebugLog(s, ##__VA_ARGS__)
#define DebugLogWarn(s,...)             _DebugLogWarn(s, ##__VA_ARGS__)
#define DebugLogError(s,...)            _DebugLogError(s, ##__VA_ARGS__)
#define DebugLogWriteSuccess(s,...)     _DebugLogWriteSuccess(s, ##__VA_ARGS__)
#define DebugLogSystem(s,...)           _DebugLogSystem(s, ##__VA_ARGS__)
#define DebugLogIBAction(s,...)         _DebugLogIBAction(s, ##__VA_ARGS__)
#define DebugLogFuncStart(s,...)        _DebugLogFuncStart(s, ##__VA_ARGS__)
#define DebugLogFuncUpdate(s,...)       _DebugLogFuncUpdate(s, ##__VA_ARGS__)
#define DebugLogProfile(s,...)          //_DebugLogProfile(s, ##__VA_ARGS__)
#define DebugLogGL(s,...)               //_DebugLogGL(s, ##__VA_ARGS__)
#define DebugLogGLGroupStart(s,...)     //_DebugLogGLGroupStart(s, ##__VA_ARGS__)
#define DebugLogGLGroupEnd()            //_DebugLogGLGroupEnd()
