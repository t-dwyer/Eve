; ModuleID = 'build/cur.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"class.std::ios_base::Init" = type { i8 }
%union.pthread_mutex_t = type { %"struct.(anonymous union)::__pthread_mutex_s" }
%"struct.(anonymous union)::__pthread_mutex_s" = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@_ZStL8__ioinit = internal global %"class.std::ios_base::Init" zeroinitializer, align 1
@__dso_handle = external global i8
@MainBuffer = global i8* null, align 8
@GlobalBuffer = global i8* null, align 8
@mutex = global %union.pthread_mutex_t zeroinitializer, align 8
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @_GLOBAL__sub_I_06_manual.cpp, i8* null }]

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
  %i1 = alloca i32, align 4
  store i32 0, i32* %1
  %2 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* @mutex, %union.pthread_mutexattr_t* null) #1
  store i32 0, i32* %i, align 4
  br label %3

; <label>:3                                       ; preds = %11, %0
  %4 = load i32* %i, align 4
  %5 = icmp slt i32 %4, 12
  br i1 %5, label %6, label %14

; <label>:6                                       ; preds = %3
  %7 = load i32* %i, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [12 x i64]* %threads, i32 0, i64 %8
  %10 = call i32 @pthread_create(i64* %9, %union.pthread_attr_t* null, i8* (i8*)* @_Z6threadPv, i8* null) #1
  br label %11

; <label>:11                                      ; preds = %6
  %12 = load i32* %i, align 4
  %13 = add nsw i32 %12, 1
  store i32 %13, i32* %i, align 4
  br label %3

; <label>:14                                      ; preds = %3
  store i32 0, i32* %i1, align 4
  br label %15

; <label>:15                                      ; preds = %24, %14
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
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t*, %union.pthread_mutexattr_t*) #3

; Function Attrs: nounwind
declare i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #3

; Function Attrs: nounwind uwtable
define i8* @_Z6threadPv(i8* %ptr) #4 {
  %1 = alloca i8*, align 8
  %work = alloca i8, align 1
  %z = alloca i32, align 4
  %I = alloca i32, align 4
  %I1 = alloca i32, align 4
  store i8* %ptr, i8** %1, align 8
  %2 = call noalias i8* @malloc(i64 2097152) #1
  store i8* %2, i8** @MainBuffer, align 8
  %3 = call noalias i8* @malloc(i64 8388608) #1
  store i8* %3, i8** @GlobalBuffer, align 8
  store i8 0, i8* %work, align 1
  store i32 0, i32* %z, align 4
  br label %4

; <label>:4                                       ; preds = %46, %0
  %5 = load i32* %z, align 4
  %6 = icmp slt i32 %5, 32
  br i1 %6, label %7, label %49

; <label>:7                                       ; preds = %4
  store i32 0, i32* %I, align 4
  br label %8

; <label>:8                                       ; preds = %22, %7
  %9 = load i32* %I, align 4
  %10 = icmp slt i32 %9, 2097152
  br i1 %10, label %11, label %25

; <label>:11                                      ; preds = %8
  %12 = load i8** @MainBuffer, align 8
  %13 = load i32* %I, align 4
  %14 = sext i32 %13 to i64
  %15 = getelementptr inbounds i8* %12, i64 %14
  %16 = load i8* %15, align 1
  %17 = sext i8 %16 to i32
  %18 = load i8* %work, align 1
  %19 = sext i8 %18 to i32
  %20 = and i32 %19, %17
  %21 = trunc i32 %20 to i8
  store i8 %21, i8* %work, align 1
  br label %22

; <label>:22                                      ; preds = %11
  %23 = load i32* %I, align 4
  %24 = add nsw i32 %23, 1
  store i32 %24, i32* %I, align 4
  br label %8

; <label>:25                                      ; preds = %8
  %26 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* @mutex) #1
  store i32 0, i32* %I1, align 4
  br label %27

; <label>:27                                      ; preds = %41, %25
  %28 = load i32* %I1, align 4
  %29 = icmp slt i32 %28, 8388608
  br i1 %29, label %30, label %44

; <label>:30                                      ; preds = %27
  %31 = load i8** @GlobalBuffer, align 8
  %32 = load i32* %I1, align 4
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds i8* %31, i64 %33
  %35 = load i8* %34, align 1
  %36 = sext i8 %35 to i32
  %37 = load i8* %work, align 1
  %38 = sext i8 %37 to i32
  %39 = and i32 %38, %36
  %40 = trunc i32 %39 to i8
  store i8 %40, i8* %work, align 1
  br label %41

; <label>:41                                      ; preds = %30
  %42 = load i32* %I1, align 4
  %43 = add nsw i32 %42, 1
  store i32 %43, i32* %I1, align 4
  br label %27

; <label>:44                                      ; preds = %27
  %45 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* @mutex) #1
  br label %46

; <label>:46                                      ; preds = %44
  %47 = load i32* %z, align 4
  %48 = add nsw i32 %47, 1
  store i32 %48, i32* %z, align 4
  br label %4

; <label>:49                                      ; preds = %4
  ret i8* null
}

declare i32 @pthread_join(i64, i8**) #0

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t*) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t*) #3

define internal void @_GLOBAL__sub_I_06_manual.cpp() section ".text.startup" {
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
