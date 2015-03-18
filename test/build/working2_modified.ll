; ModuleID = 'build/working2_modified.bc'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = alloca i32, align 4
  store i32 0, i32* %1
  br label %.split.split1

.split.split1:                                    ; preds = %.split
  %2 = alloca i32, align 4
  store i32 %argc, i32* %2, align 4
  br label %.split.split1.split

.split.split1.split:                              ; preds = %.split.split1
  %3 = alloca i8**, align 8
  store i8** %argv, i8*** %3, align 8
  br label %.split.split1.split.split

.split.split1.split.split:                        ; preds = %.split.split1.split
  %x = alloca i32, align 4
  %4 = load i32* %x, align 4
  %5 = icmp slt i32 %4, 4
  store i32 0, i32* %x, align 4
  br label %.split.split1.split.split.split

.split.split1.split.split.split:                  ; preds = %.split.split1.split.split
  br label %.split.split

.split.split1.split.split.split.split:            ; preds = %.split.split1.split.split.split.split
  br label %.split.split1.split.split.split.split

.split.split:                                     ; preds = %.split.split1.split.split.split
  br i1 %5, label %6, label %7

; <label>:6                                       ; preds = %.split.split
  br label %.split2

.split2:                                          ; preds = %6
  store i32 0, i32* %1
  br label %.split2.split3

.split2.split3:                                   ; preds = %.split2
  br label %.split2.split

.split2.split:                                    ; preds = %.split2.split3
  br label %8

; <label>:7                                       ; preds = %.split.split
  br label %.split4

.split4:                                          ; preds = %7
  store i32 0, i32* %1
  br label %.split4.split5

.split4.split5:                                   ; preds = %.split4
  br label %.split4.split

.split4.split:                                    ; preds = %.split4.split5
  br label %8

; <label>:8                                       ; preds = %.split4.split, %.split2.split
  br label %.split6

.split6:                                          ; preds = %8
  %9 = load i32* %1
  br label %.split6.split7

.split6.split7:                                   ; preds = %.split6
  br label %.split6.split

.split6.split:                                    ; preds = %.split6.split7
  ret i32 %9
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
