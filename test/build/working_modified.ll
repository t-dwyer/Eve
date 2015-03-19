; ModuleID = 'build/working_modified.bc'
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
entry:
  %0 = call i1 @Augment_init(i64 18)
  br label %1

; <label>:1                                       ; preds = %189, %.split5.split, %entry
  %2 = call i1 @Augment_sigTry(i64 0)
  %3 = icmp eq i1 %2, true
  br i1 %3, label %4, label %.split

; <label>:4                                       ; preds = %1
  %5 = call i1 @Augment_sigGet(i64 0)
  %6 = icmp eq i1 %5, true
  br i1 %6, label %7, label %.split

; <label>:7                                       ; preds = %4
  %8 = call i1 @Augment_sigPrime(i64 0)
  %9 = call i1 @Augment_sig(i64 3)
  %10 = call i1 @Augment_sig(i64 2)
  %11 = call i1 @Augment_sig(i64 1)
  br label %.split

.split:                                           ; preds = %7, %4, %1
  %12 = call i1 @Augment_sigTry(i64 1)
  %13 = icmp eq i1 %12, true
  br i1 %13, label %14, label %.split.split1

; <label>:14                                      ; preds = %.split
  %15 = call i1 @Augment_sigDep(i64 0)
  %16 = call i1 @Augment_sigGet(i64 1)
  %17 = and i1 %16, %15
  %18 = icmp eq i1 %17, true
  br i1 %18, label %19, label %.split.split1

; <label>:19                                      ; preds = %14
  %20 = call i1 @Augment_sigPrime(i64 1)
  %21 = call i1 @Augment_sig(i64 4)
  %22 = alloca i32, align 4
  store i32 0, i32* %22
  br label %.split.split1

.split.split1:                                    ; preds = %19, %14, %.split
  %23 = call i1 @Augment_sigTry(i64 2)
  %24 = icmp eq i1 %23, true
  br i1 %24, label %25, label %.split.split1.split

; <label>:25                                      ; preds = %.split.split1
  %26 = call i1 @Augment_sigDep(i64 0)
  %27 = call i1 @Augment_sigGet(i64 2)
  %28 = and i1 %27, %26
  %29 = icmp eq i1 %28, true
  br i1 %29, label %30, label %.split.split1.split

; <label>:30                                      ; preds = %25
  %31 = call i1 @Augment_sigPrime(i64 2)
  %32 = call i1 @Augment_sig(i64 4)
  %tmp = alloca i32, align 4
  store i32 0, i32* %tmp, align 4
  br label %.split.split1.split

.split.split1.split:                              ; preds = %30, %25, %.split.split1
  %33 = call i1 @Augment_sigTry(i64 3)
  %34 = icmp eq i1 %33, true
  br i1 %34, label %35, label %.split.split

; <label>:35                                      ; preds = %.split.split1.split
  %36 = call i1 @Augment_sigDep(i64 0)
  %37 = call i1 @Augment_sigGet(i64 3)
  %38 = and i1 %37, %36
  %39 = icmp eq i1 %38, true
  br i1 %39, label %40, label %.split.split

; <label>:40                                      ; preds = %35
  %41 = call i1 @Augment_sigPrime(i64 3)
  %42 = call i1 @Augment_sig(i64 4)
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  br label %.split.split

.split.split:                                     ; preds = %40, %35, %.split.split1.split
  %43 = call i1 @Augment_sigTry(i64 4)
  %44 = icmp eq i1 %43, true
  br i1 %44, label %45, label %57

; <label>:45                                      ; preds = %.split.split
  %46 = call i1 @Augment_sigDep(i64 3)
  %47 = call i1 @Augment_sigDep(i64 2)
  %48 = and i1 %47, %46
  %49 = call i1 @Augment_sigDep(i64 1)
  %50 = and i1 %49, %48
  %51 = call i1 @Augment_sigGet(i64 4)
  %52 = and i1 %51, %50
  %53 = icmp eq i1 %52, true
  br i1 %53, label %54, label %57

; <label>:54                                      ; preds = %45
  %55 = call i1 @Augment_sigPrime(i64 4)
  %56 = call i1 @Augment_sig(i64 5)
  br label %57

; <label>:57                                      ; preds = %54, %45, %.split.split
  %58 = call i1 @Augment_sigTry(i64 5)
  %59 = icmp eq i1 %58, true
  br i1 %59, label %60, label %.split2

; <label>:60                                      ; preds = %57
  %61 = call i1 @Augment_sigGet(i64 5)
  %62 = icmp eq i1 %61, true
  br i1 %62, label %63, label %.split2

; <label>:63                                      ; preds = %60
  %64 = call i1 @Augment_sigPrime(i64 5)
  %65 = call i1 @Augment_sig(i64 6)
  br label %.split2

.split2:                                          ; preds = %63, %60, %57
  %66 = call i1 @Augment_sigTry(i64 6)
  %67 = icmp eq i1 %66, true
  br i1 %67, label %68, label %.split2.split

; <label>:68                                      ; preds = %.split2
  %69 = call i1 @Augment_sigDep(i64 5)
  %70 = call i1 @Augment_sigGet(i64 6)
  %71 = and i1 %70, %69
  %72 = icmp eq i1 %71, true
  br i1 %72, label %73, label %.split2.split

; <label>:73                                      ; preds = %68
  %74 = call i1 @Augment_sigPrime(i64 6)
  %75 = call i1 @Augment_sig(i64 7)
  %76 = load i32* %j, align 4
  %77 = icmp slt i32 %76, 5
  br label %.split2.split

.split2.split:                                    ; preds = %73, %68, %.split2
  %78 = call i1 @Augment_sigTry(i64 7)
  %79 = icmp eq i1 %78, true
  br i1 %79, label %80, label %91

; <label>:80                                      ; preds = %.split2.split
  %81 = call i1 @Augment_sigDep(i64 6)
  %82 = call i1 @Augment_sigGet(i64 7)
  %83 = and i1 %82, %81
  %84 = icmp eq i1 %83, true
  br i1 %84, label %85, label %91

; <label>:85                                      ; preds = %80
  %86 = call i1 @Augment_sigPrime(i64 7)
  br i1 %77, label %87, label %89

; <label>:87                                      ; preds = %85
  %88 = call i1 @Augment_sig(i64 8)
  br label %91

; <label>:89                                      ; preds = %85
  %90 = call i1 @Augment_sig(i64 14)
  br label %91

; <label>:91                                      ; preds = %89, %87, %80, %.split2.split
  %92 = call i1 @Augment_sigTry(i64 8)
  %93 = icmp eq i1 %92, true
  br i1 %93, label %94, label %.split3

; <label>:94                                      ; preds = %91
  %95 = call i1 @Augment_sigGet(i64 8)
  %96 = icmp eq i1 %95, true
  br i1 %96, label %97, label %.split3

; <label>:97                                      ; preds = %94
  %98 = call i1 @Augment_sigPrime(i64 8)
  %99 = call i1 @Augment_sig(i64 9)
  br label %.split3

.split3:                                          ; preds = %97, %94, %91
  %100 = call i1 @Augment_sigTry(i64 9)
  %101 = icmp eq i1 %100, true
  br i1 %101, label %102, label %.split3.split

; <label>:102                                     ; preds = %.split3
  %103 = call i1 @Augment_sigDep(i64 8)
  %104 = call i1 @Augment_sigGet(i64 9)
  %105 = and i1 %104, %103
  %106 = icmp eq i1 %105, true
  br i1 %106, label %107, label %.split3.split

; <label>:107                                     ; preds = %102
  %108 = call i1 @Augment_sigPrime(i64 9)
  %109 = call i1 @Augment_sig(i64 10)
  %110 = load i32* %tmp, align 4
  %111 = mul nsw i32 %110, 2
  %112 = add nsw i32 %111, 3
  store i32 %112, i32* %tmp, align 4
  br label %.split3.split

.split3.split:                                    ; preds = %107, %102, %.split3
  %113 = call i1 @Augment_sigTry(i64 10)
  %114 = icmp eq i1 %113, true
  br i1 %114, label %115, label %123

; <label>:115                                     ; preds = %.split3.split
  %116 = call i1 @Augment_sigDep(i64 9)
  %117 = call i1 @Augment_sigGet(i64 10)
  %118 = and i1 %117, %116
  %119 = icmp eq i1 %118, true
  br i1 %119, label %120, label %123

; <label>:120                                     ; preds = %115
  %121 = call i1 @Augment_sigPrime(i64 10)
  %122 = call i1 @Augment_sig(i64 11)
  br label %123

; <label>:123                                     ; preds = %120, %115, %.split3.split
  %124 = call i1 @Augment_sigTry(i64 11)
  %125 = icmp eq i1 %124, true
  br i1 %125, label %126, label %.split4

; <label>:126                                     ; preds = %123
  %127 = call i1 @Augment_sigGet(i64 11)
  %128 = icmp eq i1 %127, true
  br i1 %128, label %129, label %.split4

; <label>:129                                     ; preds = %126
  %130 = call i1 @Augment_sigPrime(i64 11)
  %131 = call i1 @Augment_sig(i64 12)
  br label %.split4

.split4:                                          ; preds = %129, %126, %123
  %132 = call i1 @Augment_sigTry(i64 12)
  %133 = icmp eq i1 %132, true
  br i1 %133, label %134, label %.split4.split

; <label>:134                                     ; preds = %.split4
  %135 = call i1 @Augment_sigDep(i64 11)
  %136 = call i1 @Augment_sigGet(i64 12)
  %137 = and i1 %136, %135
  %138 = icmp eq i1 %137, true
  br i1 %138, label %139, label %.split4.split

; <label>:139                                     ; preds = %134
  %140 = call i1 @Augment_sigPrime(i64 12)
  %141 = call i1 @Augment_sig(i64 13)
  %142 = load i32* %j, align 4
  %143 = add nsw i32 %142, 1
  store i32 %143, i32* %j, align 4
  br label %.split4.split

.split4.split:                                    ; preds = %139, %134, %.split4
  %144 = call i1 @Augment_sigTry(i64 13)
  %145 = icmp eq i1 %144, true
  br i1 %145, label %146, label %154

; <label>:146                                     ; preds = %.split4.split
  %147 = call i1 @Augment_sigDep(i64 12)
  %148 = call i1 @Augment_sigGet(i64 13)
  %149 = and i1 %148, %147
  %150 = icmp eq i1 %149, true
  br i1 %150, label %151, label %154

; <label>:151                                     ; preds = %146
  %152 = call i1 @Augment_sigPrime(i64 13)
  %153 = call i1 @Augment_sig(i64 5)
  br label %154

; <label>:154                                     ; preds = %151, %146, %.split4.split
  %155 = call i1 @Augment_sigTry(i64 14)
  %156 = icmp eq i1 %155, true
  br i1 %156, label %157, label %.split5

; <label>:157                                     ; preds = %154
  %158 = call i1 @Augment_sigGet(i64 14)
  %159 = icmp eq i1 %158, true
  br i1 %159, label %160, label %.split5

; <label>:160                                     ; preds = %157
  %161 = call i1 @Augment_sigPrime(i64 14)
  %162 = call i1 @Augment_sig(i64 16)
  %163 = call i1 @Augment_sig(i64 15)
  br label %.split5

.split5:                                          ; preds = %160, %157, %154
  %164 = call i1 @Augment_sigTry(i64 15)
  %165 = icmp eq i1 %164, true
  br i1 %165, label %166, label %.split5.split6

; <label>:166                                     ; preds = %.split5
  %167 = call i1 @Augment_sigDep(i64 14)
  %168 = call i1 @Augment_sigGet(i64 15)
  %169 = and i1 %168, %167
  %170 = icmp eq i1 %169, true
  br i1 %170, label %171, label %.split5.split6

; <label>:171                                     ; preds = %166
  %172 = call i1 @Augment_sigPrime(i64 15)
  %173 = call i1 @Augment_sig(i64 17)
  %174 = load i32* %tmp, align 4
  %175 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([14 x i8]* @.str, i32 0, i32 0), i32 %174)
  br label %.split5.split6

.split5.split6:                                   ; preds = %171, %166, %.split5
  %176 = call i1 @Augment_sigTry(i64 16)
  %177 = icmp eq i1 %176, true
  br i1 %177, label %178, label %.split5.split

; <label>:178                                     ; preds = %.split5.split6
  %179 = call i1 @Augment_sigDep(i64 14)
  %180 = call i1 @Augment_sigGet(i64 16)
  %181 = and i1 %180, %179
  %182 = icmp eq i1 %181, true
  br i1 %182, label %183, label %.split5.split

; <label>:183                                     ; preds = %178
  %184 = call i1 @Augment_sigPrime(i64 16)
  %185 = call i1 @Augment_sig(i64 17)
  %186 = load i32* %tmp, align 4
  br label %.split5.split

.split5.split:                                    ; preds = %183, %178, %.split5.split6
  %187 = call i1 @Augment_sigTry(i64 17)
  %188 = icmp eq i1 %187, true
  br i1 %188, label %189, label %1

; <label>:189                                     ; preds = %.split5.split
  %190 = call i1 @Augment_sigDep(i64 16)
  %191 = call i1 @Augment_sigDep(i64 15)
  %192 = and i1 %191, %190
  %193 = call i1 @Augment_sigGet(i64 17)
  %194 = and i1 %193, %192
  %195 = icmp eq i1 %194, true
  br i1 %195, label %196, label %1

; <label>:196                                     ; preds = %189
  %197 = call i1 @Augment_sigPrime(i64 17)
  ret i32 %186
}

declare i32 @printf(i8*, ...) #0

define internal void @_GLOBAL__sub_I_02_more.cpp() section ".text.startup" {
  call void @__cxx_global_var_init()
  ret void
}

declare i1 @Augment_sigTry(i64)

declare i1 @Augment_sigGet(i64)

declare i1 @Augment_sigDep(i64)

declare i1 @Augment_sig(i64)

declare i1 @Augment_sigPrime(i64)

declare i1 @Augment_init(i64)

declare i1 @Augment_printTrue(i64)

declare i1 @Augment_printFalse(i64)

declare void @Augment_doNOP()

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
