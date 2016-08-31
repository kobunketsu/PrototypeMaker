//
//  PMDataModel.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMDataModel.h"
#import "PMCategory.h"
#import "PMDataViewController.h"
#import "PMDataModel.h"
#import <objC/runtime.h>

#define CurrentVersion 1.0

#define versionKey @"versionKey"

#define ideaKey @"ideaKey"
#define prototypeKey @"prototypeKey"
#define tagKey @"tagKey"

#define ideaIdMappedProtoIdKey @"ideaIdMappedProtoIdKey"
#define protoMappedIdeasKey @"protoMappedIdeasKey"
#define ideaIdMappedTagIdsKey @"ideaIdMappedTagIdsKey"

#define protoIdCollectionKey @"protoIdCollectionKey"
#define ideaIdCollectionKey @"ideaIdCollectionKey"
#define tagIdCollectionKey @"tagIdCollectionKey"

#define protoCategoryIdMappedTagIdsKey @"protoCategoryIdMappedTagIdsKey"
#define protoCategoriesKey @"protoCategoriesKey"

@interface PMDataModel()
{

}
@end

@implementation PMDataModel
static PMDataModel* sharedInstance = nil;

+(PMDataModel*)current{
    if(sharedInstance != nil){
        return sharedInstance;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PMDataModel alloc]init];
    });
    return sharedInstance;
}

+ (void)setCurrent:(PMDataModel *)dataModel{
    sharedInstance = dataModel;
}

- (id)init{
    self = [super init];
    if (self) {
        _ideas = [[NSMutableDictionary alloc]init];
        _protos = [[NSMutableDictionary alloc]init];
        _tags = [[NSMutableDictionary alloc]init];
        
        _ideaIdMappedProtoIds = [[NSMutableDictionary alloc]init];
        _protoIdMappedIdeaIds = [[NSMutableDictionary alloc]init];
        _ideaIdMappedTagIds = [[NSMutableDictionary alloc]init];
        
        _protoIdCollection = [[NSMutableArray alloc]init];
        _ideaIdCollection = [[NSMutableArray alloc]init];
        _tagIdCollection = [[NSMutableArray alloc]init];
        
        _protoCategoryIdMappedTagIds = [[NSMutableDictionary alloc]init];
        _protoCategories = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc{
    DebugLog(@"dealloc");
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:CurrentVersion forKey:versionKey];
    [encoder encodeObject:self.ideas forKey:ideaKey];
    [encoder encodeObject:self.protos forKey:prototypeKey];
    [encoder encodeObject:self.ideaIdMappedProtoIds forKey:ideaIdMappedProtoIdKey];
    [encoder encodeObject:self.protoIdMappedIdeaIds forKey:protoMappedIdeasKey];
    [encoder encodeObject:self.tags forKey:tagKey];
    [encoder encodeObject:self.ideaIdMappedTagIds forKey:ideaIdMappedTagIdsKey];
    [encoder encodeObject:self.protoCategoryIdMappedTagIds forKey:protoCategoryIdMappedTagIdsKey];
    [encoder encodeObject:self.protoCategories forKey:protoCategoriesKey];
    [encoder encodeObject:self.protoIdCollection forKey:protoIdCollectionKey];
    [encoder encodeObject:self.ideaIdCollection forKey:ideaIdCollectionKey];
    [encoder encodeObject:self.tagIdCollection forKey:tagIdCollectionKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _version = [decoder decodeIntegerForKey:versionKey];
        _ideas = [decoder decodeObjectForKey:ideaKey];
        _protos = [decoder decodeObjectForKey:prototypeKey];
        _tags = [decoder decodeObjectForKey:tagKey];
        
        _ideaIdMappedProtoIds = [decoder decodeObjectForKey:ideaIdMappedProtoIdKey];
        _protoIdMappedIdeaIds = [decoder decodeObjectForKey:protoMappedIdeasKey];
        _ideaIdMappedTagIds = [decoder decodeObjectForKey:ideaIdMappedTagIdsKey];
        
        _protoIdCollection = [decoder decodeObjectForKey:protoIdCollectionKey];
        _ideaIdCollection = [decoder decodeObjectForKey:ideaIdCollectionKey];
        _tagIdCollection = [decoder decodeObjectForKey:tagIdCollectionKey];
        
        _protoCategoryIdMappedTagIds = [decoder decodeObjectForKey:protoCategoryIdMappedTagIdsKey];
        _protoCategories = [decoder decodeObjectForKey:protoCategoriesKey];
    }
    return self;
}
#pragma mark- Add Elements
- (void)addIdea:(PMIdea *)idea{
    [self.ideas setObject:idea forKey:idea.identifier];
}

- (void)deleteIdea:(PMIdea *)idea{
    [self.ideas removeObjectForKey:idea.identifier];
    
    if ([self.ideaIdCollection containsObject:idea.identifier]) {
        [self.ideaIdCollection removeObject:idea.identifier];
    }
}

- (void)addProto:(PMPrototype *)prototype{
    [self.protos setObject:prototype forKey:prototype.identifier];
}

- (void)deleteProto:(PMPrototype *)prototype{
    [self.protos removeObjectForKey:prototype.identifier];
    
    if ([self.protoIdCollection containsObject:prototype.identifier]) {
        [self.protoIdCollection removeObject:prototype.identifier];
    }
}

- (void)connectProto:(PMPrototype *)prototype withIdea:(PMIdea *)idea{
    [prototype addIdea:idea];
    [idea addPrototype:prototype];
}

- (void)addTag:(PMTag *)tag{
    [self.tags setObject:tag forKey:tag.identifier];
}

- (void)deleteTag:(PMTag *)tag{
    [self.tags removeObjectForKey:tag.identifier];
    
    if ([self.tagIdCollection containsObject:tag.identifier]) {
        [self.tagIdCollection removeObject:tag.identifier];
    }
}

- (void)connectIdea:(PMIdea *)idea withTag:(PMTag *)tag{
    [idea addTag:tag];
}

//- (void)saveToJson{
//
//}
//
//- (void)loadFromJson{
//
//}

//prepare some test data
- (void)feedSampleData{
    DebugLog(@"feedSampleData");
    //category
    PMCategory *cat = [[PMCategory alloc]initWithTitle:@"Film" desc:@""];
    [[PMDataModel current].protoCategories addObject:cat];
    cat = [[PMCategory alloc]initWithTitle:@"Game" desc:@""];
    [[PMDataModel current].protoCategories addObject:cat];
    [PMDataViewController sharedInstance].curCategory = cat;
    
    //tag
    PMTag *tag = [PMTag tagWithTitle:@"graphic"];
    [self addTag:tag]; [cat addTag:tag];
    
    tag = [PMTag tagWithTitle:@"sound"];
    [self addTag:tag]; [cat addTag:tag]; 

    tag = [PMTag tagWithTitle:@"physics"];
    [self addTag:tag]; [cat addTag:tag];

    tag = [PMTag tagWithTitle:@"story"];
    [self addTag:tag]; [cat addTag:tag];

    tag = [PMTag tagWithTitle:@"gameplay"];
    [self addTag:tag]; [cat addTag:tag];

    tag = [PMTag tagWithTitle:@"mechanism"];
    [self addTag:tag]; [cat addTag:tag];
    
    //idea
    PMIdea *idea1 = [PMIdea ideaWithTitle:@"Sandbox" desc:@"开放式场景，以探索为主要玩法。"];
    [self addIdea:idea1];
    [idea1 addTag:[PMTag tagOfId:cat.tagIds[4]]];
    
    PMIdea *idea2 = [PMIdea ideaWithTitle:@"LowPoly" desc:@"低多边形风格，通常配合鲜艳明快的配色，材质干净"];
    [self addIdea:idea2];
    [idea2 addTag:[PMTag tagOfId:cat.tagIds[0]]];
    
    PMIdea *idea3 = [PMIdea ideaWithTitle:@"Illusion" desc:@"幻觉，欺骗艺术"];
    [self addIdea:idea3];
    [idea3 addTag:[PMTag tagOfId:cat.tagIds[5]]];
    
    PMIdea *idea4 = [PMIdea ideaWithTitle:@"Emotional" desc:@"情感体验"];
    [self addIdea:idea4];
    [idea4 addTag:[PMTag tagOfId:cat.tagIds[3]]];

    PMPrototype *pt1 = [PMPrototype prototypeWithTitle:@"Minecraft" desc:@"我的世界，一款自由度很高的沙盒游戏。这个游戏让每一个玩家在三维空间中自由地创造和破坏不同种类的方块。玩家在游戏中的形象可以在单人或多人模式中通过摧毁或创造方块以创造精妙绝伦的建筑物和艺术"];
    [self addProto:pt1];
    
    PMPrototype *pt2 = [PMPrototype prototypeWithTitle:@"Journey" desc:@"journey，可在PS3运作的游戏，于2012年3月发售。在风之旅人中，玩家各自扮演一位徘徊在无尽沙海中的无名旅者。这位旅者以颜色鲜艳但式样朴素的斗篷遮盖全身，看上去是一位准备前往应许之地朝圣的教徒。游戏开始后，你独自漫步在一望无际的沙漠中，当你爬上眼前高高的沙丘，可以看到远方映出的一座高耸入云的山峰。当你不断向山峰的方向前进，屏幕上会打出游戏的标题：Journey，直到通关后的STAFF列表，这就是游戏中惟一的文字了。"];
    [self addProto:pt2];
    
    PMPrototype *pt3 = [PMPrototype prototypeWithTitle:@"MonumentValley" desc:@"《纪念碑谷》是由ustwo games开发的解谜类手机游戏。游戏通过探索隐藏小路，发现视力错觉以及击败神秘的乌鸦人来帮助沉默公主艾达走出纪念碑迷阵。"];
    [self addProto:pt3];
    
    [pt1 addIdea:idea1];
    [idea1 addPrototype:pt1];
    
    [pt1 addIdea:idea2];
    [idea2 addPrototype:pt1];
    
    [pt2 addIdea:idea2];
    [idea2 addPrototype:pt2];
    
    [pt2 addIdea:idea4];
    [idea4 addPrototype:pt2];
    
    [pt3 addIdea:idea2];
    [idea2 addPrototype:pt3];
    
    [pt3 addIdea:idea3];
    [idea3 addPrototype:pt3];
    
    [pt3 addIdea:idea4];
    [idea4 addPrototype:pt3];
    
    //display some ideas
    self.ideaIdCollection = [[NSMutableArray alloc]initWithArray:@[idea1.identifier, idea2.identifier]];
    self.protoIdCollection = [self protoIdsFromIdeaIds:self.ideaIdCollection];
    
    //json
//    DebugLog(@"json data %@", self.toJSONString);
//    [self writeJsonString:self.toJSONString toDocumentPath:@"test.json"];
}

- (NSMutableArray *)ideaIdsFromProtoIds:(NSMutableArray *)protoIds{
    NSMutableArray *newIdeaIds = [[NSMutableArray alloc]init];
    for (NSString *ptId in protoIds) {
        NSMutableArray *ideaIds = [self.protoIdMappedIdeaIds valueForKey:ptId];
        for (NSString *ideaId in ideaIds) {
            if (![newIdeaIds containsObject:ideaId]) {
                [newIdeaIds addObject:ideaId];
            }
        }
    }
    return newIdeaIds;
}

- (NSMutableArray *)protoIdsFromIdeaIds:(NSMutableArray *)ideaIds{
    NSMutableArray *newProtoIds = [[NSMutableArray alloc]init];
    for (NSString *ideaId in ideaIds) {
        NSMutableArray *protoIds = [self.ideaIdMappedProtoIds valueForKey:ideaId];
        for (NSString *protoId in protoIds) {
            if (![newProtoIds containsObject:protoId]) {
                [newProtoIds addObject:protoId];
            }
        }
    }
    return newProtoIds;
}

- (NSMutableArray *)tagIdsFromIdeaIds:(NSMutableArray *)ideaIds{
    NSMutableArray *newTagIds = [[NSMutableArray alloc]init];
    for (NSString *ideaId in ideaIds) {
        NSMutableArray *tagIds = [self.ideaIdMappedTagIds valueForKey:ideaId];
        for (NSString *tagId in tagIds) {
            if (![newTagIds containsObject:tagId]) {
                [newTagIds addObject:tagId];
            }
        }
    }
    return newTagIds;
}

- (void)setIdeaIdCollection:(NSMutableArray *)ideaCollection{
    _ideaIdCollection = ideaCollection;
    self.tagIdCollection = [[PMDataModel current] tagIdsFromIdeaIds:[PMDataModel current].ideaIdCollection];
}

//- (NSArray *)sharedIdeaIdsFromProtoIds:(NSArray *)protoIds{
//    
//}

#pragma mark- Write
- (void)writeJsonString:(NSString *)jsonString toDocumentPath:(NSString *)path{
    //applications Documents dirctory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:path];
    
    //file to copy from
    NSError *error = nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        DebugLog(@"jsonData nil. error %@", [error localizedDescription]);
    }
    
    //write file to device
    if(![jsonData writeToFile:filePath atomically:true]){
        DebugLog(@"writeJsonString error!");
    }
}

//- (BOOL)readJsonFilePath:(NSString *)filePath fromDocumentPath:(NSString *)docPath{
//    NSString *path = [docPath stringByAppendingPathComponent:filePath];
//    NSError *error = nil;
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path] options:NSDataReadingUncached error:&error];
//    if (error) {
//        DebugLogError(@"readJsonFilePath %@ error %@", path, [error localizedDescription]);
//        return false;
//    }
//    
//    [[PMDataModel alloc]initWithData:data error:&error];
//    
//}

//- (NSMutableArray *)NSMutableArrayFromJSONModelArray:(JSONModelArray *)jsonArray{
//    return [jsonArray mutableCopy];
//}


#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
