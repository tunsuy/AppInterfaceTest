// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: appinftest.proto

#import "GPBProtocolBuffers_RuntimeSupport.h"
#import "Appinftest.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - AppinftestRoot

@implementation AppinftestRoot

@end

#pragma mark - AppinftestRoot_FileDescriptor

static GPBFileDescriptor *AppinftestRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPBDebugCheckRuntimeVersion();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"com.sangfor.moa.protobuf"
                                                     syntax:GPBFileSyntaxProto2];
  }
  return descriptor;
}

#pragma mark - PB_IOSInfInfo

@implementation PB_IOSInfInfo

@dynamic hasClassName, className;
@dynamic hasMethodName, methodName;

typedef struct PB_IOSInfInfo__storage_ {
  uint32_t _has_storage_[1];
  NSString *className;
  NSString *methodName;
} PB_IOSInfInfo__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "className",
        .dataTypeSpecific.className = NULL,
        .number = PB_IOSInfInfo_FieldNumber_ClassName,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(PB_IOSInfInfo__storage_, className),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "methodName",
        .dataTypeSpecific.className = NULL,
        .number = PB_IOSInfInfo_FieldNumber_MethodName,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(PB_IOSInfInfo__storage_, methodName),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[PB_IOSInfInfo class]
                                     rootClass:[AppinftestRoot class]
                                          file:AppinftestRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(PB_IOSInfInfo__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - PB_SendIOSInfReq

@implementation PB_SendIOSInfReq

@dynamic iOsInfoArray, iOsInfoArray_Count;

typedef struct PB_SendIOSInfReq__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *iOsInfoArray;
} PB_SendIOSInfReq__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "iOsInfoArray",
        .dataTypeSpecific.className = GPBStringifySymbol(PB_IOSInfInfo),
        .number = PB_SendIOSInfReq_FieldNumber_IOsInfoArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(PB_SendIOSInfReq__storage_, iOsInfoArray),
        .flags = GPBFieldRepeated | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[PB_SendIOSInfReq class]
                                     rootClass:[AppinftestRoot class]
                                          file:AppinftestRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(PB_SendIOSInfReq__storage_)
                                         flags:0];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\000iOS_info\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - PB_SendIOSInfRsp

@implementation PB_SendIOSInfRsp

@dynamic hasResult, result;

typedef struct PB_SendIOSInfRsp__storage_ {
  uint32_t _has_storage_[1];
  int32_t result;
} PB_SendIOSInfRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "result",
        .dataTypeSpecific.className = NULL,
        .number = PB_SendIOSInfRsp_FieldNumber_Result,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(PB_SendIOSInfRsp__storage_, result),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[PB_SendIOSInfRsp class]
                                     rootClass:[AppinftestRoot class]
                                          file:AppinftestRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(PB_SendIOSInfRsp__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
