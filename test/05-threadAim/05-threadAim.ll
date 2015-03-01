; ModuleID = 'build/cur.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"class.std::ios_base::Init" = type { i8 }
%union.pthread_mutex_t = type { %"struct.(anonymous union)::__pthread_mutex_s" }
%"struct.(anonymous union)::__pthread_mutex_s" = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%union.pthread_attr_t = type { i64, [48 x i8] }
%union.pthread_mutexattr_t = type { i32 }

@_ZStL8__ioinit = internal global %"class.std::ios_base::Init" zeroinitializer, align 1
@__dso_handle = external global i8
@MainBuffer = global i8* null, align 8
@GlobalBuffer = global i8* null, align 8
@mutex = global %union.pthread_mutex_t zeroinitializer, align 8
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @_GLOBAL__sub_I_05_threadAim.cpp, i8* null }]

define internal void @__cxx_global_var_init() section ".text.startup" {
  call void @_ZNSt8ios_base4InitC1Ev(%"class.std::ios_base::Init"* @_ZStL8__ioinit)
  %1 = call i32 @__cxa_atexit(void (i8*)* bitcast (void (%"class.std::ios_base::Init"*)* @_ZNSt8ios_base4InitD1Ev to void (i8*)*), i8* getelementptr inbounds (%"class.std::ios_base::Init"* @_ZStL8__ioinit, i32 0, i32 0), i8* @__dso_handle) #1
  ret void
}

declare void @_ZNSt8ios_base4InitC1Ev(%"class.std::ios_base::Init"*) #0

declare void @_ZNSt8ios_base4InitD1Ev(%"class.std::ios_base::Init"*) #0

; Function Attrs: nounwind
declare i32 @__cxa_atexit(void (i8*)*, i8*, i8*) #1

; Function Attrs: uwtable
define i32 @main() #2 {
  %1 = alloca i32, align 4
  %threads = alloca [12 x i64], align 16
  %i = alloca i32, align 4
  %newThread = alloca i64, align 8
  %i1 = alloca i32, align 4
  store i32 0, i32* %1
  store i32 0, i32* %i, align 4
  br label %2

; <label>:2                                       ; preds = %10, %0
  %3 = load i32* %i, align 4
  %4 = icmp slt i32 %3, 12
  br i1 %4, label %5, label %13

; <label>:5                                       ; preds = %2
  %6 = load i32* %i, align 4
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds [12 x i64]* %threads, i32 0, i64 %7
  %9 = call i32 @pthread_create(i64* %8, %union.pthread_attr_t* null, i8* (i8*)* @_Z6threadPv, i8* null) #1
  br label %10

; <label>:10                                      ; preds = %5
  %11 = load i32* %i, align 4
  %12 = add nsw i32 %11, 1
  store i32 %12, i32* %i, align 4
  br label %2

; <label>:13                                      ; preds = %2
  %14 = call i32 @pthread_create(i64* %newThread, %union.pthread_attr_t* null, i8* (i8*)* @_Z15updateGlobalVarPv, i8* null) #1
  store i32 0, i32* %i1, align 4
  br label %15

; <label>:15                                      ; preds = %24, %13
  %16 = load i32* %i1, align 4
  %17 = icmp slt i32 %16, 12
  br i1 %17, label %18, label %27

; <label>:18                                      ; preds = %15
  %19 = load i32* %i1, align 4
  %20 = sext i32 %19 to i64
  %21 = getelementptr inbounds [12 x i64]* %threads, i32 0, i64 %20
  %22 = load i64* %21, align 8
  %23 = call i32 @pthread_join(i64 %22, i8** null)
  br label %24

; <label>:24                                      ; preds = %18
  %25 = load i32* %i1, align 4
  %26 = add nsw i32 %25, 1
  store i32 %26, i32* %i1, align 4
  br label %15

; <label>:27                                      ; preds = %15
  %28 = load i64* %newThread, align 8
  %29 = call i32 @pthread_cancel(i64 %28)
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #3

; Function Attrs: nounwind uwtable
define i8* @_Z6threadPv(i8* %ptr) #4 {
  %1 = alloca i8*, align 8
  %work = alloca i8, align 1
  %z = alloca i32, align 4
  %I = alloca i32, align 4
  store i8* %ptr, i8** %1, align 8
  %2 = call noalias i8* @malloc(i64 2097152) #1
  store i8* %2, i8** @MainBuffer, align 8
  store i8 0, i8* %work, align 1
  store i32 0, i32* %z, align 4
  br label %3

; <label>:3                                       ; preds = %26, %0
  %4 = load i32* %z, align 4
  %5 = icmp slt i32 %4, 16
  br i1 %5, label %6, label %29

; <label>:6                                       ; preds = %3
  store i32 0, i32* %I, align 4
  br label %7

; <label>:7                                       ; preds = %21, %6
  %8 = load i32* %I, align 4
  %9 = icmp slt i32 %8, 2097152
  br i1 %9, label %10, label %24

; <label>:10                                      ; preds = %7
  %11 = load i8** @MainBuffer, align 8
  %12 = load i32* %I, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds i8* %11, i64 %13
  %15 = load i8* %14, align 1
  %16 = sext i8 %15 to i32
  %17 = load i8* %work, align 1
  %18 = sext i8 %17 to i32
  %19 = and i32 %18, %16
  %20 = trunc i32 %19 to i8
  store i8 %20, i8* %work, align 1
  br label %21

; <label>:21                                      ; preds = %10
  %22 = load i32* %I, align 4
  %23 = add nsw i32 %22, 1
  store i32 %23, i32* %I, align 4
  br label %7

; <label>:24                                      ; preds = %7
  %25 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* @mutex) #1
  br label %26

; <label>:26                                      ; preds = %24
  %27 = load i32* %z, align 4
  %28 = add nsw i32 %27, 1
  store i32 %28, i32* %z, align 4
  br label %3

; <label>:29                                      ; preds = %3
  ret i8* null
}

; Function Attrs: nounwind uwtable
define i8* @_Z15updateGlobalVarPv(i8* %ptr) #4 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %work = alloca i8, align 1
  %I = alloca i32, align 4
  store i8* %ptr, i8** %2, align 8
  %3 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* @mutex, %union.pthread_mutexattr_t* null) #1
  %4 = call noalias i8* @malloc(i64 8388608) #1
  store i8* %4, i8** @GlobalBuffer, align 8
  br label %5

; <label>:5                                       ; preds = %24, %0
  %6 = call i32 @pthread_mutex_trylock(%union.pthread_mutex_t* @mutex) #1
  store i8 0, i8* %work, align 1
  store i32 0, i32* %I, align 4
  br label %7

; <label>:7                                       ; preds = %21, %5
  %8 = load i32* %I, align 4
  %9 = icmp slt i32 %8, 8388608
  br i1 %9, label %10, label %24

; <label>:10                                      ; preds = %7
  %11 = load i8** @GlobalBuffer, align 8
  %12 = load i32* %I, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds i8* %11, i64 %13
  %15 = load i8* %14, align 1
  %16 = sext i8 %15 to i32
  %17 = load i8* %work, align 1
  %18 = sext i8 %17 to i32
  %19 = and i32 %18, %16
  %20 = trunc i32 %19 to i8
  store i8 %20, i8* %work, align 1
  br label %21

; <label>:21                                      ; preds = %10
  %22 = load i32* %I, align 4
  %23 = add nsw i32 %22, 1
  store i32 %23, i32* %I, align 4
  br label %7

; <label>:24                                      ; preds = %7
  br label %5
                                                  ; No predecessors!
  %26 = load i8** %1
  ret i8* %26
}

declare i32 @pthread_join(i64, i8**) #0

declare i32 @pthread_cancel(i64) #0

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t*, %union.pthread_mutexattr_t*) #3

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_trylock(%union.pthread_mutex_t*) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t*) #3

define internal void @_GLOBAL__sub_I_05_threadAim.cpp() section ".text.startup" {
  call void @__cxx_global_var_init()
  ret void
}

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
