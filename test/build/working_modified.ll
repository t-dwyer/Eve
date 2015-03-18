; ModuleID = 'build/working_modified.bc'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"class.std::ios_base::Init" = type { i8 }

@_ZStL8__ioinit = internal global %"class.std::ios_base::Init" zeroinitializer, align 1
@__dso_handle = external global i8
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

; Function Attrs: nounwind uwtable
define i32 @main() #2 {
  br label %.split

.split:                                           ; preds = %0
  %1 = alloca i32, align 4
  store i32 0, i32* %1
  br label %.split.split1

.split.split1:                                    ; preds = %.split
  %tmp = alloca i32, align 4
  store i32 0, i32* %tmp, align 4
  br label %.split.split1.split

.split.split1.split:                              ; preds = %.split.split1
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  br label %.split.split

.split.split:                                     ; preds = %.split.split1.split
  br label %2

; <label>:2                                       ; preds = %.split4.split, %.split.split
  br label %.split2

.split2:                                          ; preds = %2
  %3 = load i32* %j, align 4
  %4 = icmp slt i32 %3, 5
  br label %.split2.split

.split2.split:                                    ; preds = %.split2
  br i1 %4, label %5, label %12

; <label>:5                                       ; preds = %.split2.split
  br label %.split3

.split3:                                          ; preds = %5
  %6 = load i32* %tmp, align 4
  %7 = mul nsw i32 %6, 2
  %8 = add nsw i32 %7, 3
  store i32 %8, i32* %tmp, align 4
  br label %.split3.split

.split3.split:                                    ; preds = %.split3
  br label %9

; <label>:9                                       ; preds = %.split3.split
  br label %.split4

.split4:                                          ; preds = %9
  %10 = load i32* %j, align 4
  %11 = add nsw i32 %10, 1
  store i32 %11, i32* %j, align 4
  br label %.split4.split

.split4.split:                                    ; preds = %.split4
  br label %2

; <label>:12                                      ; preds = %.split2.split
  %13 = load i32* %tmp, align 4
  ret i32 %13
}

define internal void @_GLOBAL__sub_I_02_more.cpp() section ".text.startup" {
  call void @__cxx_global_var_init()
  ret void
}

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
