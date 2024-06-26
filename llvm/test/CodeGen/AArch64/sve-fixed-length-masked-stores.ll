; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -aarch64-sve-vector-bits-min=256  < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_256
; RUN: llc -aarch64-sve-vector-bits-min=512  < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=2048 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512

target triple = "aarch64-unknown-linux-gnu"

;
; Masked Stores
;

define void @masked_store_v2f16(ptr %ap, ptr %bp) vscale_range(2,0) #0 {
; CHECK-LABEL: masked_store_v2f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr s1, [x0]
; CHECK-NEXT:    ldr s2, [x1]
; CHECK-NEXT:    movi v0.2d, #0000000000000000
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    fcmeq v2.4h, v1.4h, v2.4h
; CHECK-NEXT:    sshll v2.4s, v2.4h, #0
; CHECK-NEXT:    mov v0.h[0], v2.h[0]
; CHECK-NEXT:    mov w8, v2.s[1]
; CHECK-NEXT:    mov v0.h[1], w8
; CHECK-NEXT:    cmpne p0.h, p0/z, z0.h, #0
; CHECK-NEXT:    st1h { z1.h }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <2 x half>, ptr %ap
  %b = load <2 x half>, ptr %bp
  %mask = fcmp oeq <2 x half> %a, %b
  call void @llvm.masked.store.v2f16(<2 x half> %a, ptr %bp, i32 8, <2 x i1> %mask)
  ret void
}

define void @masked_store_v2f32(ptr %ap, ptr %bp) vscale_range(2,0) #0 {
; CHECK-LABEL: masked_store_v2f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    fcmeq v1.2s, v0.2s, v1.2s
; CHECK-NEXT:    cmpne p0.s, p0/z, z1.s, #0
; CHECK-NEXT:    st1w { z0.s }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <2 x float>, ptr %ap
  %b = load <2 x float>, ptr %bp
  %mask = fcmp oeq <2 x float> %a, %b
  call void @llvm.masked.store.v2f32(<2 x float> %a, ptr %bp, i32 8, <2 x i1> %mask)
  ret void
}

define void @masked_store_v4f32(ptr %ap, ptr %bp) vscale_range(1,0) #0 {
; CHECK-LABEL: masked_store_v4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    fcmeq v1.4s, v0.4s, v1.4s
; CHECK-NEXT:    cmpne p0.s, p0/z, z1.s, #0
; CHECK-NEXT:    st1w { z0.s }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <4 x float>, ptr %ap
  %b = load <4 x float>, ptr %bp
  %mask = fcmp oeq <4 x float> %a, %b
  call void @llvm.masked.store.v4f32(<4 x float> %a, ptr %bp, i32 8, <4 x i1> %mask)
  ret void
}

define void @masked_store_v8f32(ptr %ap, ptr %bp) vscale_range(2,0) #0 {
; CHECK-LABEL: masked_store_v8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl8
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x1]
; CHECK-NEXT:    fcmeq p0.s, p0/z, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <8 x float>, ptr %ap
  %b = load <8 x float>, ptr %bp
  %mask = fcmp oeq <8 x float> %a, %b
  call void @llvm.masked.store.v8f32(<8 x float> %a, ptr %bp, i32 8, <8 x i1> %mask)
  ret void
}

define void @masked_store_v16f32(ptr %ap, ptr %bp) #0 {
; VBITS_GE_256-LABEL: masked_store_v16f32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    mov x8, #8 // =0x8
; VBITS_GE_256-NEXT:    ld1w { z0.s }, p0/z, [x0, x8, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z1.s }, p0/z, [x1, x8, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z2.s }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ld1w { z3.s }, p0/z, [x1]
; VBITS_GE_256-NEXT:    fcmeq p1.s, p0/z, z0.s, z1.s
; VBITS_GE_256-NEXT:    fcmeq p0.s, p0/z, z2.s, z3.s
; VBITS_GE_256-NEXT:    st1w { z0.s }, p1, [x0, x8, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z2.s }, p0, [x0]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: masked_store_v16f32:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.s, vl16
; VBITS_GE_512-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1w { z1.s }, p0/z, [x1]
; VBITS_GE_512-NEXT:    fcmeq p0.s, p0/z, z0.s, z1.s
; VBITS_GE_512-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_GE_512-NEXT:    ret
  %a = load <16 x float>, ptr %ap
  %b = load <16 x float>, ptr %bp
  %mask = fcmp oeq <16 x float> %a, %b
  call void @llvm.masked.store.v16f32(<16 x float> %a, ptr %ap, i32 8, <16 x i1> %mask)
  ret void
}

define void @masked_store_v32f32(ptr %ap, ptr %bp) vscale_range(8,0) #0 {
; CHECK-LABEL: masked_store_v32f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl32
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x1]
; CHECK-NEXT:    fcmeq p0.s, p0/z, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %a = load <32 x float>, ptr %ap
  %b = load <32 x float>, ptr %bp
  %mask = fcmp oeq <32 x float> %a, %b
  call void @llvm.masked.store.v32f32(<32 x float> %a, ptr %ap, i32 8, <32 x i1> %mask)
  ret void
}

define void @masked_store_v64f32(ptr %ap, ptr %bp) vscale_range(16,0) #0 {
; CHECK-LABEL: masked_store_v64f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl64
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x1]
; CHECK-NEXT:    fcmeq p0.s, p0/z, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %a = load <64 x float>, ptr %ap
  %b = load <64 x float>, ptr %bp
  %mask = fcmp oeq <64 x float> %a, %b
  call void @llvm.masked.store.v64f32(<64 x float> %a, ptr %ap, i32 8, <64 x i1> %mask)
  ret void
}

define void @masked_store_trunc_v8i64i8(ptr %ap, ptr %bp, ptr %dest) #0 {
; VBITS_GE_256-LABEL: masked_store_trunc_v8i64i8:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    mov x8, #4 // =0x4
; VBITS_GE_256-NEXT:    ld1d { z0.d }, p0/z, [x0, x8, lsl #3]
; VBITS_GE_256-NEXT:    ld1d { z1.d }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ld1d { z2.d }, p0/z, [x1, x8, lsl #3]
; VBITS_GE_256-NEXT:    ld1d { z3.d }, p0/z, [x1]
; VBITS_GE_256-NEXT:    cmpeq p1.d, p0/z, z0.d, z2.d
; VBITS_GE_256-NEXT:    uzp1 z0.s, z0.s, z0.s
; VBITS_GE_256-NEXT:    cmpeq p0.d, p0/z, z1.d, z3.d
; VBITS_GE_256-NEXT:    uzp1 z1.s, z1.s, z1.s
; VBITS_GE_256-NEXT:    mov z2.d, p1/z, #-1 // =0xffffffffffffffff
; VBITS_GE_256-NEXT:    ptrue p1.s, vl8
; VBITS_GE_256-NEXT:    mov z3.d, p0/z, #-1 // =0xffffffffffffffff
; VBITS_GE_256-NEXT:    ptrue p0.s, vl4
; VBITS_GE_256-NEXT:    uzp1 z2.s, z2.s, z2.s
; VBITS_GE_256-NEXT:    splice z1.s, p0, z1.s, z0.s
; VBITS_GE_256-NEXT:    uzp1 z3.s, z3.s, z3.s
; VBITS_GE_256-NEXT:    splice z3.s, p0, z3.s, z2.s
; VBITS_GE_256-NEXT:    cmpne p1.s, p1/z, z3.s, #0
; VBITS_GE_256-NEXT:    st1b { z1.s }, p1, [x2]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: masked_store_trunc_v8i64i8:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.d, vl8
; VBITS_GE_512-NEXT:    ld1d { z0.d }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1d { z1.d }, p0/z, [x1]
; VBITS_GE_512-NEXT:    cmpeq p0.d, p0/z, z0.d, z1.d
; VBITS_GE_512-NEXT:    st1b { z0.d }, p0, [x2]
; VBITS_GE_512-NEXT:    ret
  %a = load <8 x i64>, ptr %ap
  %b = load <8 x i64>, ptr %bp
  %mask = icmp eq <8 x i64> %a, %b
  %val = trunc <8 x i64> %a to <8 x i8>
  call void @llvm.masked.store.v8i8(<8 x i8> %val, ptr %dest, i32 8, <8 x i1> %mask)
  ret void
}

define void @masked_store_trunc_v8i64i16(ptr %ap, ptr %bp, ptr %dest) #0 {
; VBITS_GE_256-LABEL: masked_store_trunc_v8i64i16:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    mov x8, #4 // =0x4
; VBITS_GE_256-NEXT:    ld1d { z0.d }, p0/z, [x0, x8, lsl #3]
; VBITS_GE_256-NEXT:    ld1d { z1.d }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ld1d { z2.d }, p0/z, [x1, x8, lsl #3]
; VBITS_GE_256-NEXT:    ld1d { z3.d }, p0/z, [x1]
; VBITS_GE_256-NEXT:    cmpeq p1.d, p0/z, z0.d, z2.d
; VBITS_GE_256-NEXT:    uzp1 z0.s, z0.s, z0.s
; VBITS_GE_256-NEXT:    cmpeq p0.d, p0/z, z1.d, z3.d
; VBITS_GE_256-NEXT:    uzp1 z1.s, z1.s, z1.s
; VBITS_GE_256-NEXT:    uzp1 z0.h, z0.h, z0.h
; VBITS_GE_256-NEXT:    mov z2.d, p1/z, #-1 // =0xffffffffffffffff
; VBITS_GE_256-NEXT:    uzp1 z1.h, z1.h, z1.h
; VBITS_GE_256-NEXT:    mov z3.d, p0/z, #-1 // =0xffffffffffffffff
; VBITS_GE_256-NEXT:    ptrue p0.s, vl4
; VBITS_GE_256-NEXT:    uzp1 z2.s, z2.s, z2.s
; VBITS_GE_256-NEXT:    mov v1.d[1], v0.d[0]
; VBITS_GE_256-NEXT:    uzp1 z3.s, z3.s, z3.s
; VBITS_GE_256-NEXT:    splice z3.s, p0, z3.s, z2.s
; VBITS_GE_256-NEXT:    ptrue p0.h, vl8
; VBITS_GE_256-NEXT:    uzp1 z2.h, z3.h, z3.h
; VBITS_GE_256-NEXT:    cmpne p0.h, p0/z, z2.h, #0
; VBITS_GE_256-NEXT:    st1h { z1.h }, p0, [x2]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: masked_store_trunc_v8i64i16:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.d, vl8
; VBITS_GE_512-NEXT:    ld1d { z0.d }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1d { z1.d }, p0/z, [x1]
; VBITS_GE_512-NEXT:    cmpeq p0.d, p0/z, z0.d, z1.d
; VBITS_GE_512-NEXT:    st1h { z0.d }, p0, [x2]
; VBITS_GE_512-NEXT:    ret
  %a = load <8 x i64>, ptr %ap
  %b = load <8 x i64>, ptr %bp
  %mask = icmp eq <8 x i64> %a, %b
  %val = trunc <8 x i64> %a to <8 x i16>
  call void @llvm.masked.store.v8i16(<8 x i16> %val, ptr %dest, i32 8, <8 x i1> %mask)
  ret void
}

define void @masked_store_trunc_v8i64i32(ptr %ap, ptr %bp, ptr %dest) #0 {
; VBITS_GE_256-LABEL: masked_store_trunc_v8i64i32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    mov x8, #4 // =0x4
; VBITS_GE_256-NEXT:    ld1d { z0.d }, p0/z, [x0, x8, lsl #3]
; VBITS_GE_256-NEXT:    ld1d { z1.d }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ld1d { z2.d }, p0/z, [x1, x8, lsl #3]
; VBITS_GE_256-NEXT:    ld1d { z3.d }, p0/z, [x1]
; VBITS_GE_256-NEXT:    cmpeq p1.d, p0/z, z0.d, z2.d
; VBITS_GE_256-NEXT:    uzp1 z0.s, z0.s, z0.s
; VBITS_GE_256-NEXT:    cmpeq p0.d, p0/z, z1.d, z3.d
; VBITS_GE_256-NEXT:    uzp1 z1.s, z1.s, z1.s
; VBITS_GE_256-NEXT:    mov z2.d, p1/z, #-1 // =0xffffffffffffffff
; VBITS_GE_256-NEXT:    ptrue p1.s, vl8
; VBITS_GE_256-NEXT:    mov z3.d, p0/z, #-1 // =0xffffffffffffffff
; VBITS_GE_256-NEXT:    ptrue p0.s, vl4
; VBITS_GE_256-NEXT:    uzp1 z2.s, z2.s, z2.s
; VBITS_GE_256-NEXT:    splice z1.s, p0, z1.s, z0.s
; VBITS_GE_256-NEXT:    uzp1 z3.s, z3.s, z3.s
; VBITS_GE_256-NEXT:    splice z3.s, p0, z3.s, z2.s
; VBITS_GE_256-NEXT:    cmpne p1.s, p1/z, z3.s, #0
; VBITS_GE_256-NEXT:    st1w { z1.s }, p1, [x2]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: masked_store_trunc_v8i64i32:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.d, vl8
; VBITS_GE_512-NEXT:    ld1d { z0.d }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1d { z1.d }, p0/z, [x1]
; VBITS_GE_512-NEXT:    cmpeq p0.d, p0/z, z0.d, z1.d
; VBITS_GE_512-NEXT:    st1w { z0.d }, p0, [x2]
; VBITS_GE_512-NEXT:    ret
  %a = load <8 x i64>, ptr %ap
  %b = load <8 x i64>, ptr %bp
  %mask = icmp eq <8 x i64> %a, %b
  %val = trunc <8 x i64> %a to <8 x i32>
  call void @llvm.masked.store.v8i32(<8 x i32> %val, ptr %dest, i32 8, <8 x i1> %mask)
  ret void
}

define void @masked_store_trunc_v16i32i8(ptr %ap, ptr %bp, ptr %dest) #0 {
; VBITS_GE_256-LABEL: masked_store_trunc_v16i32i8:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    mov x8, #8 // =0x8
; VBITS_GE_256-NEXT:    ld1w { z0.s }, p0/z, [x0, x8, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z1.s }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ld1w { z2.s }, p0/z, [x1, x8, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z3.s }, p0/z, [x1]
; VBITS_GE_256-NEXT:    cmpeq p1.s, p0/z, z0.s, z2.s
; VBITS_GE_256-NEXT:    uzp1 z0.h, z0.h, z0.h
; VBITS_GE_256-NEXT:    cmpeq p0.s, p0/z, z1.s, z3.s
; VBITS_GE_256-NEXT:    uzp1 z1.h, z1.h, z1.h
; VBITS_GE_256-NEXT:    uzp1 z0.b, z0.b, z0.b
; VBITS_GE_256-NEXT:    mov z2.s, p1/z, #-1 // =0xffffffffffffffff
; VBITS_GE_256-NEXT:    uzp1 z1.b, z1.b, z1.b
; VBITS_GE_256-NEXT:    mov z3.s, p0/z, #-1 // =0xffffffffffffffff
; VBITS_GE_256-NEXT:    ptrue p0.b, vl16
; VBITS_GE_256-NEXT:    uzp1 z2.h, z2.h, z2.h
; VBITS_GE_256-NEXT:    mov v1.d[1], v0.d[0]
; VBITS_GE_256-NEXT:    uzp1 z3.h, z3.h, z3.h
; VBITS_GE_256-NEXT:    uzp1 z2.b, z2.b, z2.b
; VBITS_GE_256-NEXT:    uzp1 z3.b, z3.b, z3.b
; VBITS_GE_256-NEXT:    mov v3.d[1], v2.d[0]
; VBITS_GE_256-NEXT:    cmpne p0.b, p0/z, z3.b, #0
; VBITS_GE_256-NEXT:    st1b { z1.b }, p0, [x2]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: masked_store_trunc_v16i32i8:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.s, vl16
; VBITS_GE_512-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1w { z1.s }, p0/z, [x1]
; VBITS_GE_512-NEXT:    cmpeq p0.s, p0/z, z0.s, z1.s
; VBITS_GE_512-NEXT:    st1b { z0.s }, p0, [x2]
; VBITS_GE_512-NEXT:    ret
  %a = load <16 x i32>, ptr %ap
  %b = load <16 x i32>, ptr %bp
  %mask = icmp eq <16 x i32> %a, %b
  %val = trunc <16 x i32> %a to <16 x i8>
  call void @llvm.masked.store.v16i8(<16 x i8> %val, ptr %dest, i32 8, <16 x i1> %mask)
  ret void
}

define void @masked_store_trunc_v16i32i16(ptr %ap, ptr %bp, ptr %dest) #0 {
; VBITS_GE_256-LABEL: masked_store_trunc_v16i32i16:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    mov x8, #8 // =0x8
; VBITS_GE_256-NEXT:    ld1w { z0.s }, p0/z, [x0, x8, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z1.s }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ld1w { z2.s }, p0/z, [x1, x8, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z3.s }, p0/z, [x1]
; VBITS_GE_256-NEXT:    cmpeq p1.s, p0/z, z0.s, z2.s
; VBITS_GE_256-NEXT:    uzp1 z0.h, z0.h, z0.h
; VBITS_GE_256-NEXT:    cmpeq p0.s, p0/z, z1.s, z3.s
; VBITS_GE_256-NEXT:    uzp1 z1.h, z1.h, z1.h
; VBITS_GE_256-NEXT:    mov z2.s, p1/z, #-1 // =0xffffffffffffffff
; VBITS_GE_256-NEXT:    ptrue p1.h, vl8
; VBITS_GE_256-NEXT:    mov z3.s, p0/z, #-1 // =0xffffffffffffffff
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    splice z1.h, p1, z1.h, z0.h
; VBITS_GE_256-NEXT:    uzp1 z2.h, z2.h, z2.h
; VBITS_GE_256-NEXT:    uzp1 z3.h, z3.h, z3.h
; VBITS_GE_256-NEXT:    uzp1 z2.b, z2.b, z2.b
; VBITS_GE_256-NEXT:    uzp1 z3.b, z3.b, z3.b
; VBITS_GE_256-NEXT:    mov v3.d[1], v2.d[0]
; VBITS_GE_256-NEXT:    sunpklo z2.h, z3.b
; VBITS_GE_256-NEXT:    cmpne p0.h, p0/z, z2.h, #0
; VBITS_GE_256-NEXT:    st1h { z1.h }, p0, [x2]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: masked_store_trunc_v16i32i16:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.s, vl16
; VBITS_GE_512-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1w { z1.s }, p0/z, [x1]
; VBITS_GE_512-NEXT:    cmpeq p0.s, p0/z, z0.s, z1.s
; VBITS_GE_512-NEXT:    st1h { z0.s }, p0, [x2]
; VBITS_GE_512-NEXT:    ret
  %a = load <16 x i32>, ptr %ap
  %b = load <16 x i32>, ptr %bp
  %mask = icmp eq <16 x i32> %a, %b
  %val = trunc <16 x i32> %a to <16 x i16>
  call void @llvm.masked.store.v16i16(<16 x i16> %val, ptr %dest, i32 8, <16 x i1> %mask)
  ret void
}

define void @masked_store_trunc_v32i16i8(ptr %ap, ptr %bp, ptr %dest) #0 {
; VBITS_GE_256-LABEL: masked_store_trunc_v32i16i8:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    mov x8, #16 // =0x10
; VBITS_GE_256-NEXT:    ld1h { z0.h }, p0/z, [x0, x8, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z1.h }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ld1h { z2.h }, p0/z, [x1, x8, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z3.h }, p0/z, [x1]
; VBITS_GE_256-NEXT:    cmpeq p1.h, p0/z, z0.h, z2.h
; VBITS_GE_256-NEXT:    uzp1 z0.b, z0.b, z0.b
; VBITS_GE_256-NEXT:    cmpeq p0.h, p0/z, z1.h, z3.h
; VBITS_GE_256-NEXT:    uzp1 z1.b, z1.b, z1.b
; VBITS_GE_256-NEXT:    mov z2.h, p1/z, #-1 // =0xffffffffffffffff
; VBITS_GE_256-NEXT:    ptrue p1.b, vl32
; VBITS_GE_256-NEXT:    mov z3.h, p0/z, #-1 // =0xffffffffffffffff
; VBITS_GE_256-NEXT:    ptrue p0.b, vl16
; VBITS_GE_256-NEXT:    uzp1 z2.b, z2.b, z2.b
; VBITS_GE_256-NEXT:    splice z1.b, p0, z1.b, z0.b
; VBITS_GE_256-NEXT:    uzp1 z3.b, z3.b, z3.b
; VBITS_GE_256-NEXT:    splice z3.b, p0, z3.b, z2.b
; VBITS_GE_256-NEXT:    cmpne p1.b, p1/z, z3.b, #0
; VBITS_GE_256-NEXT:    st1b { z1.b }, p1, [x2]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: masked_store_trunc_v32i16i8:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.h, vl32
; VBITS_GE_512-NEXT:    ld1h { z0.h }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1h { z1.h }, p0/z, [x1]
; VBITS_GE_512-NEXT:    cmpeq p0.h, p0/z, z0.h, z1.h
; VBITS_GE_512-NEXT:    st1b { z0.h }, p0, [x2]
; VBITS_GE_512-NEXT:    ret
  %a = load <32 x i16>, ptr %ap
  %b = load <32 x i16>, ptr %bp
  %mask = icmp eq <32 x i16> %a, %b
  %val = trunc <32 x i16> %a to <32 x i8>
  call void @llvm.masked.store.v32i8(<32 x i8> %val, ptr %dest, i32 8, <32 x i1> %mask)
  ret void
}

declare void @llvm.masked.store.v2f16(<2 x half>, ptr, i32, <2 x i1>)
declare void @llvm.masked.store.v2f32(<2 x float>, ptr, i32, <2 x i1>)
declare void @llvm.masked.store.v4f32(<4 x float>, ptr, i32, <4 x i1>)
declare void @llvm.masked.store.v8f32(<8 x float>, ptr, i32, <8 x i1>)
declare void @llvm.masked.store.v16f32(<16 x float>, ptr, i32, <16 x i1>)
declare void @llvm.masked.store.v32f32(<32 x float>, ptr, i32, <32 x i1>)
declare void @llvm.masked.store.v64f32(<64 x float>, ptr, i32, <64 x i1>)

declare void @llvm.masked.store.v8i8(<8 x i8>, ptr, i32, <8 x i1>)
declare void @llvm.masked.store.v8i16(<8 x i16>, ptr, i32, <8 x i1>)
declare void @llvm.masked.store.v8i32(<8 x i32>, ptr, i32, <8 x i1>)
declare void @llvm.masked.store.v16i8(<16 x i8>, ptr, i32, <16 x i1>)
declare void @llvm.masked.store.v16i16(<16 x i16>, ptr, i32, <16 x i1>)
declare void @llvm.masked.store.v32i8(<32 x i8>, ptr, i32, <32 x i1>)

attributes #0 = { "target-features"="+sve" }
