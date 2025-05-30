; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=vector-combine -S %s | FileCheck %s

; Ensure canScalarizeAccess handles cases where the index type can't represent all inbounds values

define void @src_1_idx(ptr %q, i8 zeroext %s, i1 %idx) {
; CHECK-LABEL: @src_1_idx(
; CHECK-NEXT:    [[LD:%.*]] = load <16 x i8>, ptr [[Q:%.*]], align 16
; CHECK-NEXT:    [[V1:%.*]] = insertelement <16 x i8> [[LD]], i8 [[S:%.*]], i1 [[IDX:%.*]]
; CHECK-NEXT:    store <16 x i8> [[V1]], ptr [[Q]], align 16
; CHECK-NEXT:    ret void
;
  %ld = load <16 x i8>, ptr %q
  %v1 = insertelement <16 x i8> %ld, i8 %s, i1 %idx
  store <16 x i8> %v1, ptr %q
  ret void
}

define void @src_2_idx(ptr %q, i8 zeroext %s, i8 %idx) {
; CHECK-LABEL: @src_2_idx(
; CHECK-NEXT:    [[LD:%.*]] = load <256 x i8>, ptr [[Q:%.*]], align 256
; CHECK-NEXT:    [[V1:%.*]] = insertelement <256 x i8> [[LD]], i8 [[S:%.*]], i8 [[IDX:%.*]]
; CHECK-NEXT:    store <256 x i8> [[V1]], ptr [[Q]], align 256
; CHECK-NEXT:    ret void
;
  %ld = load <256 x i8>, ptr %q
  %v1 = insertelement <256 x i8> %ld, i8 %s, i8 %idx
  store <256 x i8> %v1, ptr %q
  ret void
}
