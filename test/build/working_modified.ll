; ModuleID = 'build/working_modified.bc'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [41 x i8] c"WinWinWinWinWinWinWinWinWinWinWinWin %d\0A\00", align 1
@llvm.global_dtors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 0, void ()* @Augment_writeOut, i8* null }]

; Function Attrs: uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
; <label>:0
  %1 = call i1 @Augment_sigPrime(i64 0)
  br i1 true, label %2, label %9

; <label>:2                                       ; preds = %0
  %3 = call i1 @Augment_init(i64 18)
  %4 = call i1 @Augment_sig(i64 5)
  %5 = call i1 @Augment_sig(i64 4)
  %6 = call i1 @Augment_sig(i64 3)
  %7 = call i1 @Augment_sig(i64 2)
  %8 = call i1 @Augment_sig(i64 1)
  br label %9

; <label>:9                                       ; preds = %.split4.split, %.split4.split5.split, %.split4.split5, %.split4, %173, %.split2.split, %.split2.split3, %.split2, %165, %.split.split1.split.split.split.split, %.split.split1.split.split, %.split.split1.split, %.split.split1, %.split, %148, %2, %0
  call void @Augment_doNOP()
  %10 = call i1 @Augment_sigTry(i64 15)
  %11 = icmp eq i1 %10, true
  br i1 %11, label %12, label %14

; <label>:12                                      ; preds = %9
  %13 = call i1 @Augment_sigGet(i64 15)
  br label %.split4.split5.split

; <label>:14                                      ; preds = %9
  %15 = call i1 @Augment_sigTry(i64 16)
  %16 = icmp eq i1 %15, true
  br i1 %16, label %17, label %25

; <label>:17                                      ; preds = %14
  %18 = call i1 @Augment_sigDep(i64 14)
  %19 = call i1 @Augment_sigDep(i64 13)
  %20 = and i1 %19, %18
  %21 = icmp eq i1 %20, true
  br i1 %21, label %22, label %24

; <label>:22                                      ; preds = %17
  %23 = call i1 @Augment_sigGet(i64 16)
  br label %.split4.split

; <label>:24                                      ; preds = %17
  call void @Augment_doNOP()
  br label %25

; <label>:25                                      ; preds = %24, %14
  %26 = call i1 @Augment_sigTry(i64 14)
  %27 = icmp eq i1 %26, true
  br i1 %27, label %28, label %34

; <label>:28                                      ; preds = %25
  %29 = call i1 @Augment_sigDep(i64 12)
  %30 = icmp eq i1 %29, true
  br i1 %30, label %31, label %33

; <label>:31                                      ; preds = %28
  %32 = call i1 @Augment_sigGet(i64 14)
  br label %.split4.split5

; <label>:33                                      ; preds = %28
  call void @Augment_doNOP()
  br label %34

; <label>:34                                      ; preds = %33, %25
  %35 = call i1 @Augment_sigTry(i64 13)
  %36 = icmp eq i1 %35, true
  br i1 %36, label %37, label %43

; <label>:37                                      ; preds = %34
  %38 = call i1 @Augment_sigDep(i64 12)
  %39 = icmp eq i1 %38, true
  br i1 %39, label %40, label %42

; <label>:40                                      ; preds = %37
  %41 = call i1 @Augment_sigGet(i64 13)
  br label %.split4

; <label>:42                                      ; preds = %37
  call void @Augment_doNOP()
  br label %43

; <label>:43                                      ; preds = %42, %34
  %44 = call i1 @Augment_sigTry(i64 1)
  %45 = icmp eq i1 %44, true
  br i1 %45, label %46, label %52

; <label>:46                                      ; preds = %43
  %47 = call i1 @Augment_sigDep(i64 0)
  %48 = icmp eq i1 %47, true
  br i1 %48, label %49, label %51

; <label>:49                                      ; preds = %46
  %50 = call i1 @Augment_sigGet(i64 1)
  br label %.split

; <label>:51                                      ; preds = %46
  call void @Augment_doNOP()
  br label %52

; <label>:52                                      ; preds = %51, %43
  %53 = call i1 @Augment_sigTry(i64 2)
  %54 = icmp eq i1 %53, true
  br i1 %54, label %55, label %61

; <label>:55                                      ; preds = %52
  %56 = call i1 @Augment_sigDep(i64 0)
  %57 = icmp eq i1 %56, true
  br i1 %57, label %58, label %60

; <label>:58                                      ; preds = %55
  %59 = call i1 @Augment_sigGet(i64 2)
  br label %.split.split1

; <label>:60                                      ; preds = %55
  call void @Augment_doNOP()
  br label %61

; <label>:61                                      ; preds = %60, %52
  %62 = call i1 @Augment_sigTry(i64 10)
  %63 = icmp eq i1 %62, true
  br i1 %63, label %64, label %66

; <label>:64                                      ; preds = %61
  %65 = call i1 @Augment_sigGet(i64 10)
  br label %.split2.split3

; <label>:66                                      ; preds = %61
  %67 = call i1 @Augment_sigTry(i64 7)
  %68 = icmp eq i1 %67, true
  br i1 %68, label %69, label %83

; <label>:69                                      ; preds = %66
  %70 = call i1 @Augment_sigDep(i64 5)
  %71 = call i1 @Augment_sigDep(i64 4)
  %72 = and i1 %71, %70
  %73 = call i1 @Augment_sigDep(i64 3)
  %74 = and i1 %73, %72
  %75 = call i1 @Augment_sigDep(i64 2)
  %76 = and i1 %75, %74
  %77 = call i1 @Augment_sigDep(i64 1)
  %78 = and i1 %77, %76
  %79 = icmp eq i1 %78, true
  br i1 %79, label %80, label %82

; <label>:80                                      ; preds = %69
  %81 = call i1 @Augment_sigGet(i64 7)
  br label %.split.split

; <label>:82                                      ; preds = %69
  call void @Augment_doNOP()
  br label %83

; <label>:83                                      ; preds = %82, %66
  %84 = call i1 @Augment_sigTry(i64 12)
  %85 = icmp eq i1 %84, true
  br i1 %85, label %86, label %88

; <label>:86                                      ; preds = %83
  %87 = call i1 @Augment_sigGet(i64 12)
  br label %173

; <label>:88                                      ; preds = %83
  %89 = call i1 @Augment_sigTry(i64 9)
  %90 = icmp eq i1 %89, true
  br i1 %90, label %91, label %97

; <label>:91                                      ; preds = %88
  %92 = call i1 @Augment_sigDep(i64 8)
  %93 = icmp eq i1 %92, true
  br i1 %93, label %94, label %96

; <label>:94                                      ; preds = %91
  %95 = call i1 @Augment_sigGet(i64 9)
  br label %.split2

; <label>:96                                      ; preds = %91
  call void @Augment_doNOP()
  br label %97

; <label>:97                                      ; preds = %96, %88
  %98 = call i1 @Augment_sigTry(i64 4)
  %99 = icmp eq i1 %98, true
  br i1 %99, label %100, label %106

; <label>:100                                     ; preds = %97
  %101 = call i1 @Augment_sigDep(i64 0)
  %102 = icmp eq i1 %101, true
  br i1 %102, label %103, label %105

; <label>:103                                     ; preds = %100
  %104 = call i1 @Augment_sigGet(i64 4)
  br label %.split.split1.split.split

; <label>:105                                     ; preds = %100
  call void @Augment_doNOP()
  br label %106

; <label>:106                                     ; preds = %105, %97
  %107 = call i1 @Augment_sigTry(i64 17)
  %108 = icmp eq i1 %107, true
  br i1 %108, label %109, label %111

; <label>:109                                     ; preds = %106
  %110 = call i1 @Augment_sigGet(i64 17)
  br label %186

; <label>:111                                     ; preds = %106
  %112 = call i1 @Augment_sigTry(i64 5)
  %113 = icmp eq i1 %112, true
  br i1 %113, label %114, label %120

; <label>:114                                     ; preds = %111
  %115 = call i1 @Augment_sigDep(i64 0)
  %116 = icmp eq i1 %115, true
  br i1 %116, label %117, label %119

; <label>:117                                     ; preds = %114
  %118 = call i1 @Augment_sigGet(i64 5)
  br label %.split.split1.split.split.split

; <label>:119                                     ; preds = %114
  call void @Augment_doNOP()
  br label %120

; <label>:120                                     ; preds = %119, %111
  %121 = call i1 @Augment_sigTry(i64 0)
  %122 = icmp eq i1 %121, true
  br i1 %122, label %123, label %125

; <label>:123                                     ; preds = %120
  %124 = call i1 @Augment_sigGet(i64 0)
  br label %0

; <label>:125                                     ; preds = %120
  %126 = call i1 @Augment_sigTry(i64 3)
  %127 = icmp eq i1 %126, true
  br i1 %127, label %128, label %134

; <label>:128                                     ; preds = %125
  %129 = call i1 @Augment_sigDep(i64 0)
  %130 = icmp eq i1 %129, true
  br i1 %130, label %131, label %133

; <label>:131                                     ; preds = %128
  %132 = call i1 @Augment_sigGet(i64 3)
  br label %.split.split1.split

; <label>:133                                     ; preds = %128
  call void @Augment_doNOP()
  br label %134

; <label>:134                                     ; preds = %133, %125
  %135 = call i1 @Augment_sigTry(i64 8)
  %136 = icmp eq i1 %135, true
  br i1 %136, label %137, label %139

; <label>:137                                     ; preds = %134
  %138 = call i1 @Augment_sigGet(i64 8)
  br label %165

; <label>:139                                     ; preds = %134
  %140 = call i1 @Augment_sigTry(i64 11)
  %141 = icmp eq i1 %140, true
  br i1 %141, label %142, label %148

; <label>:142                                     ; preds = %139
  %143 = call i1 @Augment_sigDep(i64 9)
  %144 = icmp eq i1 %143, true
  br i1 %144, label %145, label %147

; <label>:145                                     ; preds = %142
  %146 = call i1 @Augment_sigGet(i64 11)
  br label %.split2.split

; <label>:147                                     ; preds = %142
  call void @Augment_doNOP()
  br label %148

; <label>:148                                     ; preds = %147, %139
  br label %9

.split:                                           ; preds = %49
  %149 = alloca i32, align 4
  store i32 0, i32* %149
  %150 = call i1 @Augment_sigPrime(i64 1)
  %151 = call i1 @Augment_sig(i64 7)
  br label %9

.split.split1:                                    ; preds = %58
  %152 = alloca i32, align 4
  store i32 %argc, i32* %152, align 4
  %153 = call i1 @Augment_sigPrime(i64 2)
  %154 = call i1 @Augment_sig(i64 7)
  br label %9

.split.split1.split:                              ; preds = %131
  %155 = alloca i8**, align 8
  store i8** %argv, i8*** %155, align 8
  %156 = call i1 @Augment_sigPrime(i64 3)
  %157 = call i1 @Augment_sig(i64 7)
  br label %9

.split.split1.split.split:                        ; preds = %103
  %x = alloca i32, align 4
  %158 = load i32* %x, align 4
  %159 = icmp eq i32 %158, 4
  store i32 1, i32* %x, align 4
  %160 = call i1 @Augment_sigPrime(i64 4)
  %161 = call i1 @Augment_sig(i64 7)
  br label %9

.split.split1.split.split.split:                  ; preds = %117
  br label %.split.split

.split.split1.split.split.split.split:            ; No predecessors!
  %162 = call i1 @Augment_sigPrime(i64 5)
  %163 = call i1 @Augment_sig(i64 7)
  br label %9

.split.split:                                     ; preds = %.split.split1.split.split.split, %80
  %164 = call i1 @Augment_sigPrime(i64 7)
  br i1 %159, label %165, label %173

; <label>:165                                     ; preds = %.split.split, %137
  %166 = call i1 @Augment_sigPrime(i64 8)
  %167 = call i1 @Augment_sig(i64 9)
  br label %9

.split2:                                          ; preds = %94
  store i32 0, i32* %149
  %168 = call i1 @Augment_sigPrime(i64 9)
  %169 = call i1 @Augment_sig(i64 11)
  br label %9

.split2.split3:                                   ; preds = %64
  %170 = call i1 @Augment_sigPrime(i64 10)
  br label %9

.split2.split:                                    ; preds = %145
  %171 = call i1 @Augment_sigPrime(i64 11)
  %172 = call i1 @Augment_sig(i64 17)
  br label %9

; <label>:173                                     ; preds = %.split.split, %86
  %174 = call i1 @Augment_sigPrime(i64 12)
  %175 = call i1 @Augment_sig(i64 14)
  %176 = call i1 @Augment_sig(i64 13)
  br label %9

.split4:                                          ; preds = %40
  %177 = load i32* %x, align 4
  %178 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([41 x i8]* @.str, i32 0, i32 0), i32 %177)
  %179 = call i1 @Augment_sigPrime(i64 13)
  %180 = call i1 @Augment_sig(i64 16)
  br label %9

.split4.split5:                                   ; preds = %31
  store i32 0, i32* %149
  %181 = call i1 @Augment_sigPrime(i64 14)
  %182 = call i1 @Augment_sig(i64 16)
  br label %9

.split4.split5.split:                             ; preds = %12
  %183 = call i1 @Augment_sigPrime(i64 15)
  br label %9

.split4.split:                                    ; preds = %22
  %184 = call i1 @Augment_sigPrime(i64 16)
  %185 = call i1 @Augment_sig(i64 17)
  br label %9

; <label>:186                                     ; preds = %109
  %187 = load i32* %149
  %188 = call i1 @Augment_sigPrime(i64 17)
  ret i32 %187
}

declare i32 @printf(i8*, ...) #1

declare i1 @Augment_sigTry(i64)

declare i1 @Augment_sigGet(i64)

declare i1 @Augment_sigDep(i64)

declare i1 @Augment_sig(i64)

declare i1 @Augment_sigPrime(i64)

declare i1 @Augment_init(i64)

declare void @Augment_writeOut()

declare i1 @Augment_printTrue(i64)

declare i1 @Augment_printFalse(i64)

declare void @Augment_doNOP()

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
