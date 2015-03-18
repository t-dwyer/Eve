; ModuleID = 'build/06-manual_original.bc'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %"struct.(anonymous union)::__pthread_mutex_s" }
%"struct.(anonymous union)::__pthread_mutex_s" = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%union.pthread_mutexattr_t = type { i32 }

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %blocks = alloca i32, align 4
  %4 = alloca i8*
  %i = alloca i32, align 4
  %data = alloca i32, align 4
  store i32 0, i32* %1
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  store i32 10, i32* %blocks, align 4
  %5 = load i32* %blocks, align 4
  %6 = zext i32 %5 to i64
  %7 = call i8* @llvm.stacksave()
  store i8* %7, i8** %4
  %8 = alloca %union.pthread_mutex_t, i64 %6, align 16
  store i32 0, i32* %i, align 4
  br label %9

; <label>:9                                       ; preds = %22, %0
  %10 = load i32* %i, align 4
  %11 = load i32* %blocks, align 4
  %12 = icmp slt i32 %10, %11
  br i1 %12, label %13, label %25

; <label>:13                                      ; preds = %9
  %14 = load i32* %i, align 4
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds %union.pthread_mutex_t* %8, i64 %15
  %17 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* %16, %union.pthread_mutexattr_t* null) #1
  %18 = load i32* %i, align 4
  %19 = sext i32 %18 to i64
  %20 = getelementptr inbounds %union.pthread_mutex_t* %8, i64 %19
  %21 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* %20) #1
  br label %22

; <label>:22                                      ; preds = %13
  %23 = load i32* %i, align 4
  %24 = add nsw i32 %23, 1
  store i32 %24, i32* %i, align 4
  br label %9

; <label>:25                                      ; preds = %9
  store i32 0, i32* %data, align 4
  br label %26

; <label>:26                                      ; preds = %55, %25
  br label %27

; <label>:27                                      ; preds = %26
  %28 = getelementptr inbounds %union.pthread_mutex_t* %8, i64 0
  %29 = call i32 @pthread_mutex_trylock(%union.pthread_mutex_t* %28) #1
  %30 = icmp ne i32 %29, 0
  br i1 %30, label %31, label %34

; <label>:31                                      ; preds = %27
  %32 = load i32* %data, align 4
  %33 = add nsw i32 %32, 1
  store i32 %33, i32* %data, align 4
  br label %34

; <label>:34                                      ; preds = %31, %27
  %35 = getelementptr inbounds %union.pthread_mutex_t* %8, i64 1
  %36 = call i32 @pthread_mutex_trylock(%union.pthread_mutex_t* %35) #1
  %37 = icmp ne i32 %36, 0
  br i1 %37, label %38, label %41

; <label>:38                                      ; preds = %34
  %39 = load i32* %data, align 4
  %40 = add nsw i32 %39, -1
  store i32 %40, i32* %data, align 4
  br label %41

; <label>:41                                      ; preds = %38, %34
  %42 = getelementptr inbounds %union.pthread_mutex_t* %8, i64 2
  %43 = call i32 @pthread_mutex_trylock(%union.pthread_mutex_t* %42) #1
  %44 = icmp ne i32 %43, 0
  br i1 %44, label %45, label %48

; <label>:45                                      ; preds = %41
  %46 = load i32* %data, align 4
  %47 = add nsw i32 %46, 2
  store i32 %47, i32* %data, align 4
  br label %48

; <label>:48                                      ; preds = %45, %41
  %49 = getelementptr inbounds %union.pthread_mutex_t* %8, i64 3
  %50 = call i32 @pthread_mutex_trylock(%union.pthread_mutex_t* %49) #1
  %51 = icmp ne i32 %50, 0
  br i1 %51, label %52, label %55

; <label>:52                                      ; preds = %48
  %53 = load i32* %data, align 4
  %54 = sub nsw i32 %53, 2
  store i32 %54, i32* %data, align 4
  br label %55

; <label>:55                                      ; preds = %52, %48
  br label %26
                                                  ; No predecessors!
  %57 = load i32* %1
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
