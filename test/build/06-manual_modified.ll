; ModuleID = 'build/06-manual_modified.bc'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %"struct.(anonymous union)::__pthread_mutex_s" }
%"struct.(anonymous union)::__pthread_mutex_s" = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%union.pthread_mutexattr_t = type { i32 }

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
  %blocks = alloca i32, align 4
  %4 = load i32* %blocks, align 4
  %5 = zext i32 %4 to i64
  %6 = alloca %union.pthread_mutex_t, i64 %5, align 16
  store i32 10, i32* %blocks, align 4
  br label %.split.split1.split.split.split

.split.split1.split.split.split:                  ; preds = %.split.split1.split.split
  %7 = alloca i8*
  store i8* %8, i8** %7
  br label %.split.split1.split.split.split.split

.split.split1.split.split.split.split:            ; preds = %.split.split1.split.split.split
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %.split.split1.split.split.split.split.split

.split.split1.split.split.split.split.split:      ; preds = %.split.split1.split.split.split.split
  %data = alloca i32, align 4
  br label %.split.split1.split.split.split.split.split.split

.split.split1.split.split.split.split.split.split: ; preds = %.split.split1.split.split.split.split.split
  %8 = call i8* @llvm.stacksave()
  br label %.split.split

.split.split:                                     ; preds = %.split.split1.split.split.split.split.split.split
  br label %9

; <label>:9                                       ; preds = %.split6.split, %.split.split
  br label %.split2

.split2:                                          ; preds = %9
  %10 = load i32* %i, align 4
  %11 = icmp slt i32 %10, %12
  br label %.split2.split3

.split2.split3:                                   ; preds = %.split2
  %12 = load i32* %blocks, align 4
  br label %.split2.split3.split

.split2.split3.split:                             ; preds = %.split2.split3
  br label %.split2.split

.split2.split:                                    ; preds = %.split2.split3.split
  br i1 %11, label %13, label %25

; <label>:13                                      ; preds = %.split2.split
  br label %.split4

.split4:                                          ; preds = %13
  %14 = load i32* %i, align 4
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds %union.pthread_mutex_t* %6, i64 %15
  %17 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* %16, %union.pthread_mutexattr_t* null) #1
  br label %.split4.split5

.split4.split5:                                   ; preds = %.split4
  %18 = load i32* %i, align 4
  %19 = sext i32 %18 to i64
  %20 = getelementptr inbounds %union.pthread_mutex_t* %6, i64 %19
  %21 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* %20) #1
  br label %.split4.split5.split

.split4.split5.split:                             ; preds = %.split4.split5
  br label %.split4.split

.split4.split5.split.split:                       ; preds = %.split4.split5.split.split
  br label %.split4.split5.split.split

.split4.split:                                    ; preds = %.split4.split5.split
  br label %22

; <label>:22                                      ; preds = %.split4.split
  br label %.split6

.split6:                                          ; preds = %22
  %23 = load i32* %i, align 4
  %24 = add nsw i32 %23, 1
  store i32 %24, i32* %i, align 4
  br label %.split6.split7

.split6.split7:                                   ; preds = %.split6
  br label %.split6.split

.split6.split7.split:                             ; preds = %.split6.split7.split
  br label %.split6.split7.split

.split6.split:                                    ; preds = %.split6.split7
  br label %9

; <label>:25                                      ; preds = %.split2.split
  br label %.split8

.split8:                                          ; preds = %25
  store i32 0, i32* %data, align 4
  br label %.split8.split9

.split8.split9:                                   ; preds = %.split8
  br label %.split8.split

.split8.split:                                    ; preds = %.split8.split9
  br label %26

; <label>:26                                      ; preds = %55, %.split8.split
  br label %27

; <label>:27                                      ; preds = %26
  br label %.split10

.split10:                                         ; preds = %27
  %28 = getelementptr inbounds %union.pthread_mutex_t* %6, i64 0
  %29 = call i32 @pthread_mutex_trylock(%union.pthread_mutex_t* %28) #1
  %30 = icmp ne i32 %29, 0
  br label %.split10.split11

.split10.split11:                                 ; preds = %.split10
  br label %.split10.split

.split10.split11.split:                           ; preds = %.split10.split11.split
  br label %.split10.split11.split

.split10.split:                                   ; preds = %.split10.split11
  br i1 %30, label %31, label %34

; <label>:31                                      ; preds = %.split10.split
  br label %.split12

.split12:                                         ; preds = %31
  %32 = load i32* %data, align 4
  %33 = add nsw i32 %32, 1
  store i32 %33, i32* %data, align 4
  br label %.split12.split13

.split12.split13:                                 ; preds = %.split12
  br label %.split12.split

.split12.split13.split:                           ; preds = %.split12.split13.split
  br label %.split12.split13.split

.split12.split:                                   ; preds = %.split12.split13
  br label %34

; <label>:34                                      ; preds = %.split12.split, %.split10.split
  br label %.split14

.split14:                                         ; preds = %34
  %35 = getelementptr inbounds %union.pthread_mutex_t* %6, i64 1
  %36 = call i32 @pthread_mutex_trylock(%union.pthread_mutex_t* %35) #1
  %37 = icmp ne i32 %36, 0
  br label %.split14.split15

.split14.split15:                                 ; preds = %.split14
  br label %.split14.split

.split14.split15.split:                           ; preds = %.split14.split15.split
  br label %.split14.split15.split

.split14.split:                                   ; preds = %.split14.split15
  br i1 %37, label %38, label %41

; <label>:38                                      ; preds = %.split14.split
  br label %.split16

.split16:                                         ; preds = %38
  %39 = load i32* %data, align 4
  %40 = add nsw i32 %39, -1
  store i32 %40, i32* %data, align 4
  br label %.split16.split17

.split16.split17:                                 ; preds = %.split16
  br label %.split16.split

.split16.split17.split:                           ; preds = %.split16.split17.split
  br label %.split16.split17.split

.split16.split:                                   ; preds = %.split16.split17
  br label %41

; <label>:41                                      ; preds = %.split16.split, %.split14.split
  br label %.split18

.split18:                                         ; preds = %41
  %42 = getelementptr inbounds %union.pthread_mutex_t* %6, i64 2
  %43 = call i32 @pthread_mutex_trylock(%union.pthread_mutex_t* %42) #1
  %44 = icmp ne i32 %43, 0
  br label %.split18.split19

.split18.split19:                                 ; preds = %.split18
  br label %.split18.split

.split18.split19.split:                           ; preds = %.split18.split19.split
  br label %.split18.split19.split

.split18.split:                                   ; preds = %.split18.split19
  br i1 %44, label %45, label %48

; <label>:45                                      ; preds = %.split18.split
  br label %.split20

.split20:                                         ; preds = %45
  %46 = load i32* %data, align 4
  %47 = add nsw i32 %46, 2
  store i32 %47, i32* %data, align 4
  br label %.split20.split21

.split20.split21:                                 ; preds = %.split20
  br label %.split20.split

.split20.split21.split:                           ; preds = %.split20.split21.split
  br label %.split20.split21.split

.split20.split:                                   ; preds = %.split20.split21
  br label %48

; <label>:48                                      ; preds = %.split20.split, %.split18.split
  br label %.split22

.split22:                                         ; preds = %48
  %49 = getelementptr inbounds %union.pthread_mutex_t* %6, i64 3
  %50 = call i32 @pthread_mutex_trylock(%union.pthread_mutex_t* %49) #1
  %51 = icmp ne i32 %50, 0
  br label %.split22.split23

.split22.split23:                                 ; preds = %.split22
  br label %.split22.split

.split22.split23.split:                           ; preds = %.split22.split23.split
  br label %.split22.split23.split

.split22.split:                                   ; preds = %.split22.split23
  br i1 %51, label %52, label %55

; <label>:52                                      ; preds = %.split22.split
  br label %.split24

.split24:                                         ; preds = %52
  %53 = load i32* %data, align 4
  %54 = sub nsw i32 %53, 2
  store i32 %54, i32* %data, align 4
  br label %.split24.split25

.split24.split25:                                 ; preds = %.split24
  br label %.split24.split

.split24.split25.split:                           ; preds = %.split24.split25.split
  br label %.split24.split25.split

.split24.split:                                   ; preds = %.split24.split25
  br label %55

; <label>:55                                      ; preds = %.split24.split, %.split22.split
  br label %26
                                                  ; No predecessors!
  br label %.split26

.split26:                                         ; preds = %56
  %57 = load i32* %1
  br label %.split26.split27

.split26.split27:                                 ; preds = %.split26
  br label %.split26.split

.split26.split:                                   ; preds = %.split26.split27
  ret i32 %57
}

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t*, %union.pthread_mutexattr_t*) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t*) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_trylock(%union.pthread_mutex_t*) #2

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
