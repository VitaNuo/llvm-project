; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=ALL,SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefixes=ALL,SSE,SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=ALL,AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=ALL,AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefixes=ALL,AVX512,AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512bw,+avx512vl | FileCheck %s --check-prefixes=ALL,AVX512,AVX512VL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512fp16,+avx512vl | FileCheck %s --check-prefixes=ALL,AVX512,AVX512FP16

;
; vXf32
;

define float @test_v1f32(<1 x float> %a0) {
; ALL-LABEL: test_v1f32:
; ALL:       # %bb.0:
; ALL-NEXT:    retq
  %1 = call nnan float @llvm.vector.reduce.fmin.v1f32(<1 x float> %a0)
  ret float %1
}

define float @test_v2f32(<2 x float> %a0) {
; SSE2-LABEL: test_v2f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1],xmm0[1,1]
; SSE2-NEXT:    minss %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v2f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE41-NEXT:    minss %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v2f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vminss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v2f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX512-NEXT:    vminss %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = call nnan float @llvm.vector.reduce.fmin.v2f32(<2 x float> %a0)
  ret float %1
}

define float @test_v3f32(<3 x float> %a0) {
; SSE2-LABEL: test_v3f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm0, %xmm2
; SSE2-NEXT:    shufps {{.*#+}} xmm2 = xmm2[1,1],xmm0[1,1]
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    minss %xmm2, %xmm1
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    minss %xmm0, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v3f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movshdup {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE41-NEXT:    movaps %xmm0, %xmm1
; SSE41-NEXT:    minss %xmm2, %xmm1
; SSE41-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE41-NEXT:    minss %xmm0, %xmm1
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v3f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vminss %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vshufpd {{.*#+}} xmm0 = xmm0[1,0]
; AVX-NEXT:    vminss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v3f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX512-NEXT:    vminss %xmm1, %xmm0, %xmm1
; AVX512-NEXT:    vshufpd {{.*#+}} xmm0 = xmm0[1,0]
; AVX512-NEXT:    vminss %xmm0, %xmm1, %xmm0
; AVX512-NEXT:    retq
  %1 = call nnan float @llvm.vector.reduce.fmin.v3f32(<3 x float> %a0)
  ret float %1
}

define float @test_v4f32(<4 x float> %a0) {
; SSE2-LABEL: test_v4f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    minps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1],xmm0[1,1]
; SSE2-NEXT:    minss %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v4f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movaps %xmm0, %xmm1
; SSE41-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE41-NEXT:    minps %xmm1, %xmm0
; SSE41-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE41-NEXT:    minss %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vminps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vminss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v4f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vminps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX512-NEXT:    vminss %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = call nnan float @llvm.vector.reduce.fmin.v4f32(<4 x float> %a0)
  ret float %1
}

define float @test_v8f32(<8 x float> %a0) {
; SSE2-LABEL: test_v8f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    minps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    minps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1],xmm0[1,1]
; SSE2-NEXT:    minss %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v8f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    minps %xmm1, %xmm0
; SSE41-NEXT:    movaps %xmm0, %xmm1
; SSE41-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE41-NEXT:    minps %xmm1, %xmm0
; SSE41-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE41-NEXT:    minss %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vminps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vminps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vminss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v8f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vminps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vminps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX512-NEXT:    vminss %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call nnan float @llvm.vector.reduce.fmin.v8f32(<8 x float> %a0)
  ret float %1
}

define float @test_v16f32(<16 x float> %a0) {
; SSE2-LABEL: test_v16f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    minps %xmm3, %xmm1
; SSE2-NEXT:    minps %xmm2, %xmm0
; SSE2-NEXT:    minps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2-NEXT:    minps %xmm1, %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1],xmm0[1,1]
; SSE2-NEXT:    minss %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v16f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    minps %xmm3, %xmm1
; SSE41-NEXT:    minps %xmm2, %xmm0
; SSE41-NEXT:    minps %xmm1, %xmm0
; SSE41-NEXT:    movaps %xmm0, %xmm1
; SSE41-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE41-NEXT:    minps %xmm1, %xmm0
; SSE41-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE41-NEXT:    minss %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_v16f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vminps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vminps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vminps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vminss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v16f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    vminps %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vminps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vminps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX512-NEXT:    vminss %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call nnan float @llvm.vector.reduce.fmin.v16f32(<16 x float> %a0)
  ret float %1
}

;
; vXf64
;

define double @test_v2f64(<2 x double> %a0) {
; SSE-LABEL: test_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movapd %xmm0, %xmm1
; SSE-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE-NEXT:    minsd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vminsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v2f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vminsd %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = call nnan double @llvm.vector.reduce.fmin.v2f64(<2 x double> %a0)
  ret double %1
}

define double @test_v4f64(<4 x double> %a0) {
; SSE-LABEL: test_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    minpd %xmm1, %xmm0
; SSE-NEXT:    movapd %xmm0, %xmm1
; SSE-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE-NEXT:    minsd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vminpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vminsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v4f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vminpd %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vminsd %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call nnan double @llvm.vector.reduce.fmin.v4f64(<4 x double> %a0)
  ret double %1
}

define double @test_v8f64(<8 x double> %a0) {
; SSE-LABEL: test_v8f64:
; SSE:       # %bb.0:
; SSE-NEXT:    minpd %xmm3, %xmm1
; SSE-NEXT:    minpd %xmm2, %xmm0
; SSE-NEXT:    minpd %xmm1, %xmm0
; SSE-NEXT:    movapd %xmm0, %xmm1
; SSE-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE-NEXT:    minsd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_v8f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vminpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vminpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vminsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v8f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextractf64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    vminpd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vminpd %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vminsd %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call nnan double @llvm.vector.reduce.fmin.v8f64(<8 x double> %a0)
  ret double %1
}

define double @test_v16f64(<16 x double> %a0) {
; SSE-LABEL: test_v16f64:
; SSE:       # %bb.0:
; SSE-NEXT:    minpd %xmm6, %xmm2
; SSE-NEXT:    minpd %xmm4, %xmm0
; SSE-NEXT:    minpd %xmm2, %xmm0
; SSE-NEXT:    minpd %xmm7, %xmm3
; SSE-NEXT:    minpd %xmm5, %xmm1
; SSE-NEXT:    minpd %xmm3, %xmm1
; SSE-NEXT:    minpd %xmm1, %xmm0
; SSE-NEXT:    movapd %xmm0, %xmm1
; SSE-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE-NEXT:    minsd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_v16f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vminpd %ymm3, %ymm1, %ymm1
; AVX-NEXT:    vminpd %ymm2, %ymm0, %ymm0
; AVX-NEXT:    vminpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vminpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vminsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_v16f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vminpd %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vextractf64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    vminpd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vminpd %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vshufpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX512-NEXT:    vminsd %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = call nnan double @llvm.vector.reduce.fmin.v16f64(<16 x double> %a0)
  ret double %1
}

define half @test_v2f16(<2 x half> %a0) nounwind {
; SSE-LABEL: test_v2f16:
; SSE:       # %bb.0:
; SSE-NEXT:    pushq %rbp
; SSE-NEXT:    pushq %rbx
; SSE-NEXT:    subq $40, %rsp
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    psrld $16, %xmm0
; SSE-NEXT:    pextrw $0, %xmm0, %ebx
; SSE-NEXT:    pextrw $0, %xmm1, %ebp
; SSE-NEXT:    callq __extendhfsf2@PLT
; SSE-NEXT:    movd %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Folded Spill
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    callq __extendhfsf2@PLT
; SSE-NEXT:    ucomiss {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 4-byte Folded Reload
; SSE-NEXT:    cmovbl %ebp, %ebx
; SSE-NEXT:    pinsrw $0, %ebx, %xmm0
; SSE-NEXT:    addq $40, %rsp
; SSE-NEXT:    popq %rbx
; SSE-NEXT:    popq %rbp
; SSE-NEXT:    retq
;
; AVX-LABEL: test_v2f16:
; AVX:       # %bb.0:
; AVX-NEXT:    pushq %rbp
; AVX-NEXT:    pushq %rbx
; AVX-NEXT:    subq $40, %rsp
; AVX-NEXT:    vmovdqa %xmm0, %xmm1
; AVX-NEXT:    vmovdqa %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; AVX-NEXT:    vpsrld $16, %xmm0, %xmm0
; AVX-NEXT:    vpextrw $0, %xmm0, %ebx
; AVX-NEXT:    vpextrw $0, %xmm1, %ebp
; AVX-NEXT:    callq __extendhfsf2@PLT
; AVX-NEXT:    vmovd %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Folded Spill
; AVX-NEXT:    vmovaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; AVX-NEXT:    callq __extendhfsf2@PLT
; AVX-NEXT:    vucomiss {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 4-byte Folded Reload
; AVX-NEXT:    cmovbl %ebp, %ebx
; AVX-NEXT:    vpinsrw $0, %ebx, %xmm0, %xmm0
; AVX-NEXT:    addq $40, %rsp
; AVX-NEXT:    popq %rbx
; AVX-NEXT:    popq %rbp
; AVX-NEXT:    retq
;
; AVX512F-LABEL: test_v2f16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-NEXT:    vpsrld $16, %xmm0, %xmm1
; AVX512F-NEXT:    vcvtph2ps %xmm0, %xmm2
; AVX512F-NEXT:    vcvtph2ps %xmm1, %xmm3
; AVX512F-NEXT:    xorl %eax, %eax
; AVX512F-NEXT:    vucomiss %xmm3, %xmm2
; AVX512F-NEXT:    sbbl %eax, %eax
; AVX512F-NEXT:    kmovd %eax, %k1
; AVX512F-NEXT:    vmovdqu16 %zmm0, %zmm1 {%k1}
; AVX512F-NEXT:    vmovdqa %xmm1, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: test_v2f16:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpsrld $16, %xmm0, %xmm1
; AVX512VL-NEXT:    vcvtph2ps %xmm0, %xmm2
; AVX512VL-NEXT:    vcvtph2ps %xmm1, %xmm3
; AVX512VL-NEXT:    vcmpltss %xmm3, %xmm2, %k1
; AVX512VL-NEXT:    vmovdqu16 %xmm0, %xmm1 {%k1}
; AVX512VL-NEXT:    vmovdqa %xmm1, %xmm0
; AVX512VL-NEXT:    retq
;
; AVX512FP16-LABEL: test_v2f16:
; AVX512FP16:       # %bb.0:
; AVX512FP16-NEXT:    vpsrld $16, %xmm0, %xmm1
; AVX512FP16-NEXT:    vcmpltsh %xmm1, %xmm0, %k1
; AVX512FP16-NEXT:    vmovsh %xmm0, %xmm0, %xmm1 {%k1}
; AVX512FP16-NEXT:    vmovaps %xmm1, %xmm0
; AVX512FP16-NEXT:    retq
  %1 = call nnan half @llvm.vector.reduce.fmin.v2f16(<2 x half> %a0)
  ret half %1
}

declare float @llvm.vector.reduce.fmin.v1f32(<1 x float>)
declare float @llvm.vector.reduce.fmin.v2f32(<2 x float>)
declare float @llvm.vector.reduce.fmin.v3f32(<3 x float>)
declare float @llvm.vector.reduce.fmin.v4f32(<4 x float>)
declare float @llvm.vector.reduce.fmin.v8f32(<8 x float>)
declare float @llvm.vector.reduce.fmin.v16f32(<16 x float>)

declare double @llvm.vector.reduce.fmin.v2f64(<2 x double>)
declare double @llvm.vector.reduce.fmin.v4f64(<4 x double>)
declare double @llvm.vector.reduce.fmin.v8f64(<8 x double>)
declare double @llvm.vector.reduce.fmin.v16f64(<16 x double>)

declare half @llvm.vector.reduce.fmin.v2f16(<2 x half>)
