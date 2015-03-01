; ModuleID = 'build/cur.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  br label %1

; <label>:1                                       ; preds = %0					
  %2 = alloca i32, align 4
  store i32 0, i32* %2
  br label %3  

; <label>:3                                       ; preds = %1	
  %4 = alloca i32, align 4
  store i32 %argc, i32* %4, align 4
  br label %5

; <label>:5                                       ; preds = %3	
  %6 = alloca i8**, align 8
  store i8** %argv, i8*** %6, align 8
  br label %7

; <label>:7                                       ; preds = %5
  %x = alloca i32, align 4
  store i32 0, i32* %x, align 4
  %8 = load i32* %x, align 4
  %9 = icmp slt i32 %8, 4
  br i1 %9, label %10, label %11

; <label>:10                                       ; preds = %7
  store i32 0, i32* %2
  br label %12

; <label>:11                                       ; preds = %7
  store i32 0, i32* %2
  br label %12

; <label>:12                                       ; preds = %10, %11
  %13 = load i32* %2
  ret i32 %13
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
