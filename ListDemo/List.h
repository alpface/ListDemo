//
//  List.h
//  ListDemo
//
//  Created by xiaoyuan on 2019/1/9.
//  Copyright © 2019 xiaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface List : NSObject
{
@private
    void **_dataPtr;    // 数据区 存放数据的内存首地址
    NSUInteger _count;  // 元素的个数
    NSUInteger _capacity;  // 最大容量个数
}

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger capacity;
@property (nullable, nonatomic, readonly) id lastObject;
@property (nonatomic, readonly, getter=isEmpty) BOOL empty;

// 初始化
- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)capacity;
- (id)copyFromZone:(void *)z;

// 重置数组容量
- (void)setAvailableCapacity:(NSUInteger)numSlots;

// 按照索引操作list
- (id)objectAtIndex:(NSUInteger)index;
- (void)addObject:(id)anObject;
- (void)addObjectIfAbsent:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (id)removeObjectAtIndex:(NSUInteger)index;
- (id)removeLastObject;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)newObject;
- (void)addObjectsFromList:(NSArray<id> *)otherList;

// 按照元素操作list
- (NSUInteger)indexOfObject:(id)anObject;
- (id)removeObject:(id)anObject;
- (void)replaceObject:(id)anObject withObject:(id)newObject;

// 给所有元素发送消息
- (void)makeObjectsPerform:(SEL)aSelector;
- (void)makeObjectsPerform:(SEL)aSelector with:anObject;

- (void)enumerateObjectsUsingBlock:(void ( ^)(id obj, NSUInteger idx, BOOL *stop))block;
@end

NS_ASSUME_NONNULL_END
