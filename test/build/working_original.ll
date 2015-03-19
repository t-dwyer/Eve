; ModuleID = 'build/working_original.bc'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"class.std::ios_base::Init" = type { i8 }

@_ZStL8__ioinit = internal global %"class.std::ios_base::Init" zeroinitializer, align 1
@__dso_handle = external global i8
@.str = private unnamed_addr constant [14 x i8] c"Result is:%d\0A\00", align 1
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @_GLOBAL__sub_I_02_more.cpp, i8* null }]

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
  %tmp = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %1
  store i32 0, i32* %tmp, align 4
  store i32 0, i32* %j, align 4
  br label %2

; <label>:2                                       ; preds = %9, %0
  %3 = load i32* %j, align 4
  %4 = icmp slt i32 %3, 5
  br i1 %4, label %5, label %12

; <label>:5                                       ; preds = %2
  %6 = load i32* %tmp, align 4
  %7 = mul nsw i32 %6, 2
  %8 = add nsw i32 %7, 3
  store i32 %8, i32* %tmp, align 4
  br label %9

; <label>:9                                       ; preds = %5
  %10 = load i32* %j, align 4
  %11 = add nsw i32 %10, 1
  store i32 %11, i32* %j, align 4
  br label %2

; <label>:12                                      ; preds = %2
  %13 = load i32* %tmp, align 4
  %14 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([14 x i8]* @.str, i32 0, i32 0), i32 %13)
  %15 = load i32* %tmp, align 4
  ret i32 %15
}

declare i32 @printf(i8*, ...) #0

define internal void @_GLOBAL__sub_I_02_more.cpp() section ".text.startup" {
  call void @__cxx_global_var_init()
  ret void
}

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
