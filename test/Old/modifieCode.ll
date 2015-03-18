; ModuleID = 'build/modifiedCode.bc'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1
  br label %.split

.split:                                           ; preds = %0
  %2 = alloca i32, align 4
  store i32 %argc, i32* %2, align 4
  br label %.split.split

.split.split:                                     ; preds = %.split
  %3 = alloca i8**, align 8
  store i8** %argv, i8*** %3, align 8
  br label %.split.split.split

.split.split.split:                               ; preds = %.split.split
  %x = alloca i32, align 4
  %4 = load i32* %x, align 4
  store i32 0, i32* %x, align 4
  br label %.split.split.split.split

.split.split.split.split:                         ; preds = %.split.split.split
  %5 = icmp slt i32 %4, 4
  br i1 %5, label %6, label %7

; <label>:6                                       ; preds = %.split.split.split.split
  store i32 0, i32* %1
  br label %.split1

.split1:                                          ; preds = %6
  br label %8

; <label>:7                                       ; preds = %.split.split.split.split
  store i32 0, i32* %1
  br label %.split2

.split2:                                          ; preds = %7
  br label %8

; <label>:8                                       ; preds = %.split2, %.split1
  %9 = load i32* %1
  ret i32 %9

.split3:                                          ; preds = %.split3
  br label %.split3
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
