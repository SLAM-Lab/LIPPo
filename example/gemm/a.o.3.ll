; ModuleID = 'a.o.3.bc'
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@p_str2 = private unnamed_addr constant [7 x i8] c"K_LOOP\00", align 1
@p_str3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@str = internal constant [10 x i8] c"matrixmul\00"
@str1 = internal constant [14 x i8] c"J_LOOP_K_LOOP\00"
@str2 = internal constant [21 x i8] c"I_LOOP_J_LOOP_K_LOOP\00"

; Function Attrs: nounwind
define weak void @_ssdm_op_SpecLoopName(...) #0 {
entry:
  ret void
}

; Function Attrs: nounwind
define weak void @_ssdm_op_SpecPipeline(...) #0 {
entry:
  ret void
}

define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecRegionBegin(...) {
entry:
  ret i32 0
}

define weak i32 @_ssdm_op_SpecRegionEnd(...) {
entry:
  ret i32 0
}

; Function Attrs: nounwind uwtable
define void @matrixmul([36 x i16]* %a, [36 x i16]* %b, [36 x i32]* %res) #1 {
  call void (...)* @_ssdm_op_SpecBitsMap([36 x i16]* %a) #0, !map !0
  call void (...)* @_ssdm_op_SpecBitsMap([36 x i16]* %b) #0, !map !6
  call void (...)* @_ssdm_op_SpecBitsMap([36 x i32]* %res) #0, !map !10
  call void (...)* @_ssdm_op_SpecTopModule([10 x i8]* @str) #0
  br label %1

; <label>:1                                       ; preds = %ifFalse, %0
  %indvar_flatten1 = phi i8 [ 0, %0 ], [ %indvar_flatten_next1, %ifFalse ]
  %i = phi i3 [ 0, %0 ], [ %i_mid2, %ifFalse ]
  %indvar_flatten = phi i6 [ 0, %0 ], [ %indvar_flatten_next, %ifFalse ]
  %j = phi i3 [ 0, %0 ], [ %j_mid2, %ifFalse ]
  %t = phi i32 [ 0, %0 ], [ %t_1, %ifFalse ]
  %k = phi i3 [ 0, %0 ], [ %k_1, %ifFalse ]
  %exitcond_flatten1 = icmp eq i8 %indvar_flatten1, -40
  %indvar_flatten_next1 = add i8 %indvar_flatten1, 1
  br i1 %exitcond_flatten1, label %2, label %.reset6

ifTrue:                                           ; preds = %.reset6
  %p_addr8 = add i8 %p_addr_cast, %tmp_2_trn_cast
  %p_addr8_cast = sext i8 %p_addr8 to i32
  %tmp_11 = zext i32 %p_addr8_cast to i64
  %res_addr = getelementptr [36 x i32]* %res, i64 0, i64 %tmp_11
  store i32 %t_1, i32* %res_addr, align 4
  br label %ifFalse

ifFalse:                                          ; preds = %.reset6, %ifTrue
  %indvar_flatten_op = add i6 %indvar_flatten, 1
  %indvar_flatten_next = select i1 %exitcond_flatten, i6 1, i6 %indvar_flatten_op
  br label %1

.reset6:                                          ; preds = %1
  call void (...)* @_ssdm_op_SpecLoopName([21 x i8]* @str2)
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 216, i64 216, i64 216) #0
  %exitcond_flatten = icmp eq i6 %indvar_flatten, -28
  %j_mid = select i1 %exitcond_flatten, i3 0, i3 %j
  %not_exitcond_flatten = xor i1 %exitcond_flatten, true
  %exitcond = icmp eq i3 %k, -2
  %exitcond_mid = and i1 %exitcond, %not_exitcond_flatten
  %i_s = add i3 %i, 1
  %i_mid2 = select i1 %exitcond_flatten, i3 %i_s, i3 %i
  %j_1 = add i3 %j_mid, 1
  call void (...)* @_ssdm_op_SpecLoopName([14 x i8]* @str1)
  %tmp = or i1 %exitcond_mid, %exitcond_flatten
  %t_mid2 = select i1 %tmp, i32 0, i32 %t
  %k_mid2 = select i1 %tmp, i3 0, i3 %k
  %j_mid2 = select i1 %exitcond_mid, i3 %j_1, i3 %j_mid
  call void (...)* @_ssdm_op_SpecLoopName([7 x i8]* @p_str2) #0
  %tmp_9 = call i32 (...)* @_ssdm_op_SpecRegionBegin([7 x i8]* @p_str2) #0
  call void (...)* @_ssdm_op_SpecPipeline(i32 2, i32 1, i32 1, [1 x i8]* @p_str3) #0
  %tmp_4_trn_cast = zext i3 %k_mid2 to i8
  %tmp_2 = call i6 @_ssdm_op_BitConcatenate.i6.i3.i3(i3 %i_mid2, i3 0)
  %p_shl_cast = zext i6 %tmp_2 to i7
  %tmp_3 = call i4 @_ssdm_op_BitConcatenate.i4.i3.i1(i3 %i_mid2, i1 false)
  %p_shl9_cast = zext i4 %tmp_3 to i7
  %p_addr = sub i7 %p_shl_cast, %p_shl9_cast
  %p_addr_cast = sext i7 %p_addr to i8
  %p_addr1 = add i8 %p_addr_cast, %tmp_4_trn_cast
  %p_addr1_cast = sext i8 %p_addr1 to i32
  %tmp_4 = zext i32 %p_addr1_cast to i64
  %a_addr = getelementptr [36 x i16]* %a, i64 0, i64 %tmp_4
  %a_load = load i16* %a_addr, align 2
  %tmp_5 = icmp eq i16 %a_load, 0
  %tmp_6 = sext i16 %a_load to i32
  %tmp_2_trn_cast = zext i3 %j_mid2 to i8
  %tmp_s = call i6 @_ssdm_op_BitConcatenate.i6.i3.i3(i3 %k_mid2, i3 0)
  %p_shl1_cast = zext i6 %tmp_s to i7
  %tmp_1 = call i4 @_ssdm_op_BitConcatenate.i4.i3.i1(i3 %k_mid2, i1 false)
  %p_shl2_cast = zext i4 %tmp_1 to i7
  %p_addr3 = sub i7 %p_shl1_cast, %p_shl2_cast
  %p_addr3_cast = sext i7 %p_addr3 to i8
  %p_addr4 = add i8 %p_addr3_cast, %tmp_2_trn_cast
  %p_addr4_cast = sext i8 %p_addr4 to i32
  %tmp_10 = zext i32 %p_addr4_cast to i64
  %b_addr = getelementptr [36 x i16]* %b, i64 0, i64 %tmp_10
  %b_load = load i16* %b_addr, align 2
  %tmp_7 = sext i16 %b_load to i32
  %tmp_8 = mul nsw i32 %tmp_7, %tmp_6
  %t_2 = add nsw i32 %tmp_8, %t_mid2
  %t_1 = select i1 %tmp_5, i32 0, i32 %t_2
  %empty_12 = call i32 (...)* @_ssdm_op_SpecRegionEnd([7 x i8]* @p_str2, i32 %tmp_9) #0
  %k_1 = add i3 %k_mid2, 1
  %ifzero = icmp eq i3 %k_1, -2
  br i1 %ifzero, label %ifTrue, label %ifFalse

; <label>:2                                       ; preds = %1
  ret void
}

define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecLoopTripCount(...) {
entry:
  ret i32 0
}

; Function Attrs: nounwind readnone
define weak i6 @_ssdm_op_BitConcatenate.i6.i3.i3(i3, i3) #2 {
entry:
  %empty = zext i3 %0 to i6
  %empty_13 = zext i3 %1 to i6
  %empty_14 = trunc i6 %empty to i3
  %empty_15 = call i3 @_ssdm_op_PartSelect.i3.i6.i32.i32(i6 %empty_13, i32 3, i32 5)
  %empty_16 = or i3 %empty_14, %empty_15
  %empty_17 = call i6 @_ssdm_op_PartSet.i6.i6.i3.i32.i32(i6 %empty_13, i3 %empty_16, i32 3, i32 5)
  ret i6 %empty_17
}

; Function Attrs: nounwind readnone
define weak i4 @_ssdm_op_BitConcatenate.i4.i3.i1(i3, i1) #2 {
entry:
  %empty = zext i3 %0 to i4
  %empty_18 = zext i1 %1 to i4
  %empty_19 = trunc i4 %empty to i3
  %empty_20 = call i3 @_ssdm_op_PartSelect.i3.i4.i32.i32(i4 %empty_18, i32 1, i32 3)
  %empty_21 = or i3 %empty_19, %empty_20
  %empty_22 = call i4 @_ssdm_op_PartSet.i4.i4.i3.i32.i32(i4 %empty_18, i3 %empty_21, i32 1, i32 3)
  ret i4 %empty_22
}

; Function Attrs: nounwind readnone
define weak i3 @_ssdm_op_PartSelect.i3.i6.i32.i32(i6, i32, i32) #2 {
entry:
  %empty = call i6 @llvm.part.select.i6(i6 %0, i32 %1, i32 %2)
  %empty_23 = trunc i6 %empty to i3
  ret i3 %empty_23
}

; Function Attrs: nounwind readnone
define weak i6 @_ssdm_op_PartSet.i6.i6.i3.i32.i32(i6, i3, i32, i32) #2 {
entry:
  %empty = call i6 @llvm.part.set.i6.i3(i6 %0, i3 %1, i32 %2, i32 %3)
  ret i6 %empty
}

; Function Attrs: nounwind readnone
define weak i3 @_ssdm_op_PartSelect.i3.i4.i32.i32(i4, i32, i32) #2 {
entry:
  %empty = call i4 @llvm.part.select.i4(i4 %0, i32 %1, i32 %2)
  %empty_24 = trunc i4 %empty to i3
  ret i3 %empty_24
}

; Function Attrs: nounwind readnone
define weak i4 @_ssdm_op_PartSet.i4.i4.i3.i32.i32(i4, i3, i32, i32) #2 {
entry:
  %empty = call i4 @llvm.part.set.i4.i3(i4 %0, i3 %1, i32 %2, i32 %3)
  ret i4 %empty
}

; Function Attrs: nounwind readnone
declare i6 @llvm.part.select.i6(i6, i32, i32) #2

; Function Attrs: nounwind readnone
declare i6 @llvm.part.set.i6.i3(i6, i3, i32, i32) #2

; Function Attrs: nounwind readnone
declare i4 @llvm.part.select.i4(i4, i32, i32) #2

; Function Attrs: nounwind readnone
declare i4 @llvm.part.set.i4.i3(i4, i3, i32, i32) #2

attributes #0 = { nounwind }
attributes #1 = { nounwind uwtable }
attributes #2 = { nounwind readnone }

!llvm.map.gv = !{}

!0 = metadata !{metadata !1}
!1 = metadata !{i32 0, i32 15, metadata !2}
!2 = metadata !{metadata !3}
!3 = metadata !{metadata !"a", metadata !4, metadata !"short"}
!4 = metadata !{metadata !5, metadata !5}
!5 = metadata !{i32 0, i32 5, i32 1}
!6 = metadata !{metadata !7}
!7 = metadata !{i32 0, i32 15, metadata !8}
!8 = metadata !{metadata !9}
!9 = metadata !{metadata !"b", metadata !4, metadata !"short"}
!10 = metadata !{metadata !11}
!11 = metadata !{i32 0, i32 31, metadata !12}
!12 = metadata !{metadata !13}
!13 = metadata !{metadata !"res", metadata !4, metadata !"int"}
