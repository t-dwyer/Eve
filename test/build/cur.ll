; ModuleID = 'build/cur.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"class.std::ios_base::Init" = type { i8 }
%"class.std::basic_ostream" = type { i32 (...)**, %"class.std::basic_ios" }
%"class.std::basic_ios" = type { %"class.std::ios_base", %"class.std::basic_ostream"*, i8, i8, %"class.std::basic_streambuf"*, %"class.std::ctype"*, %"class.std::num_put"*, %"class.std::num_get"* }
%"class.std::ios_base" = type { i32 (...)**, i64, i64, i32, i32, i32, %"struct.std::ios_base::_Callback_list"*, %"struct.std::ios_base::_Words", [8 x %"struct.std::ios_base::_Words"], i32, %"struct.std::ios_base::_Words"*, %"class.std::locale" }
%"struct.std::ios_base::_Callback_list" = type { %"struct.std::ios_base::_Callback_list"*, void (i32, %"class.std::ios_base"*, i32)*, i32, i32 }
%"struct.std::ios_base::_Words" = type { i8*, i64 }
%"class.std::locale" = type { %"class.std::locale::_Impl"* }
%"class.std::locale::_Impl" = type { i32, %"class.std::locale::facet"**, i64, %"class.std::locale::facet"**, i8** }
%"class.std::locale::facet" = type { i32 (...)**, i32 }
%"class.std::basic_streambuf" = type { i32 (...)**, i8*, i8*, i8*, i8*, i8*, i8*, %"class.std::locale" }
%"class.std::ctype" = type { %"class.std::locale::facet.base", %struct.__locale_struct*, i8, i32*, i32*, i16*, i8, [256 x i8], [256 x i8], i8 }
%"class.std::locale::facet.base" = type <{ i32 (...)**, i32 }>
%struct.__locale_struct = type { [13 x %struct.__locale_data*], i16*, i32*, i32*, [13 x i8*] }
%struct.__locale_data = type opaque
%"class.std::num_put" = type { %"class.std::locale::facet.base", [4 x i8] }
%"class.std::num_get" = type { %"class.std::locale::facet.base", [4 x i8] }

@_ZStL8__ioinit = internal global %"class.std::ios_base::Init" zeroinitializer, align 1
@__dso_handle = external global i8
@_ZZ4mainE7aMatrix = private unnamed_addr constant [3 x [2 x i32]] [[2 x i32] [i32 1, i32 4], [2 x i32] [i32 2, i32 5], [2 x i32] [i32 3, i32 6]], align 16
@_ZZ4mainE7bMatrix = private unnamed_addr constant [2 x [3 x i32]] [[3 x i32] [i32 7, i32 8, i32 9], [3 x i32] [i32 10, i32 11, i32 12]], align 16
@_ZSt4cout = external global %"class.std::basic_ostream"
@.str = private unnamed_addr constant [3 x i8] c"  \00", align 1
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @_GLOBAL__sub_I_04_mm1.cpp, i8* null }]

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
  %aMatrix = alloca [3 x [2 x i32]], align 16
  %bMatrix = alloca [2 x [3 x i32]], align 16
  %product = alloca [3 x [3 x i32]], align 16
  %row = alloca i32, align 4
  %col = alloca i32, align 4
  %inner = alloca i32, align 4
  store i32 0, i32* %1
  %2 = bitcast [3 x [2 x i32]]* %aMatrix to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %2, i8* bitcast ([3 x [2 x i32]]* @_ZZ4mainE7aMatrix to i8*), i64 24, i32 16, i1 false)
  %3 = bitcast [2 x [3 x i32]]* %bMatrix to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %3, i8* bitcast ([2 x [3 x i32]]* @_ZZ4mainE7bMatrix to i8*), i64 24, i32 16, i1 false)
  %4 = bitcast [3 x [3 x i32]]* %product to i8*
  call void @llvm.memset.p0i8.i64(i8* %4, i8 0, i64 36, i32 16, i1 false)
  store i32 0, i32* %row, align 4
  br label %5

; <label>:5                                       ; preds = %57, %0
  %6 = load i32* %row, align 4
  %7 = icmp slt i32 %6, 3
  br i1 %7, label %8, label %60

; <label>:8                                       ; preds = %5
  store i32 0, i32* %col, align 4
  br label %9

; <label>:9                                       ; preds = %53, %8
  %10 = load i32* %col, align 4
  %11 = icmp slt i32 %10, 3
  br i1 %11, label %12, label %56

; <label>:12                                      ; preds = %9
  store i32 0, i32* %inner, align 4
  br label %13

; <label>:13                                      ; preds = %49, %12
  %14 = load i32* %inner, align 4
  %15 = icmp slt i32 %14, 2
  br i1 %15, label %16, label %52

; <label>:16                                      ; preds = %13
  %17 = load i32* %inner, align 4
  %18 = sext i32 %17 to i64
  %19 = load i32* %row, align 4
  %20 = sext i32 %19 to i64
  %21 = getelementptr inbounds [3 x [2 x i32]]* %aMatrix, i32 0, i64 %20
  %22 = getelementptr inbounds [2 x i32]* %21, i32 0, i64 %18
  %23 = load i32* %22, align 4
  %24 = load i32* %col, align 4
  %25 = sext i32 %24 to i64
  %26 = load i32* %inner, align 4
  %27 = sext i32 %26 to i64
  %28 = getelementptr inbounds [2 x [3 x i32]]* %bMatrix, i32 0, i64 %27
  %29 = getelementptr inbounds [3 x i32]* %28, i32 0, i64 %25
  %30 = load i32* %29, align 4
  %31 = mul nsw i32 %23, %30
  %32 = load i32* %col, align 4
  %33 = sext i32 %32 to i64
  %34 = load i32* %row, align 4
  %35 = sext i32 %34 to i64
  %36 = getelementptr inbounds [3 x [3 x i32]]* %product, i32 0, i64 %35
  %37 = getelementptr inbounds [3 x i32]* %36, i32 0, i64 %33
  %38 = load i32* %37, align 4
  %39 = add nsw i32 %38, %31
  store i32 %39, i32* %37, align 4
  %40 = load i32* %col, align 4
  %41 = sext i32 %40 to i64
  %42 = load i32* %row, align 4
  %43 = sext i32 %42 to i64
  %44 = getelementptr inbounds [3 x [3 x i32]]* %product, i32 0, i64 %43
  %45 = getelementptr inbounds [3 x i32]* %44, i32 0, i64 %41
  %46 = load i32* %45, align 4
  %47 = call dereferenceable(272) %"class.std::basic_ostream"* @_ZNSolsEi(%"class.std::basic_ostream"* @_ZSt4cout, i32 %46)
  %48 = call dereferenceable(272) %"class.std::basic_ostream"* @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%"class.std::basic_ostream"* dereferenceable(272) %47, i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0))
  br label %49

; <label>:49                                      ; preds = %16
  %50 = load i32* %inner, align 4
  %51 = add nsw i32 %50, 1
  store i32 %51, i32* %inner, align 4
  br label %13

; <label>:52                                      ; preds = %13
  br label %53

; <label>:53                                      ; preds = %52
  %54 = load i32* %col, align 4
  %55 = add nsw i32 %54, 1
  store i32 %55, i32* %col, align 4
  br label %9

; <label>:56                                      ; preds = %9
  br label %57

; <label>:57                                      ; preds = %56
  %58 = load i32* %row, align 4
  %59 = add nsw i32 %58, 1
  store i32 %59, i32* %row, align 4
  br label %5

; <label>:60                                      ; preds = %5
  ret i32 0
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #1

; Function Attrs: nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) #1

declare dereferenceable(272) %"class.std::basic_ostream"* @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(%"class.std::basic_ostream"* dereferenceable(272), i8*) #0

declare dereferenceable(272) %"class.std::basic_ostream"* @_ZNSolsEi(%"class.std::basic_ostream"*, i32) #0

define internal void @_GLOBAL__sub_I_04_mm1.cpp() section ".text.startup" {
  call void @__cxx_global_var_init()
  ret void
}

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
