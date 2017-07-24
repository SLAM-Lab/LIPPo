; ModuleID = 'a.o.3.bc'
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@p_str = private unnamed_addr constant [28 x i8] c"computeWeightRGB_fxp_label0\00", align 1
@p_str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@p_str2 = private unnamed_addr constant [28 x i8] c"computeWeightRGB_fxp_label2\00", align 1
@p_str3 = private unnamed_addr constant [28 x i8] c"computeWeightRGB_fxp_label1\00", align 1
@str = internal constant [21 x i8] c"computeWeightRGB_fxp\00"

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

; Function Attrs: nounwind
declare void @_GLOBAL__I_a() #0 section ".text.startup"

define weak i32 @_ssdm_op_SpecRegionBegin(...) {
entry:
  ret i32 0
}

define weak i32 @_ssdm_op_SpecRegionEnd(...) {
entry:
  ret i32 0
}

; Function Attrs: nounwind uwtable
define void @computeWeightRGB_fxp([64 x i16]* %ret, [64 x i16]* %R, [64 x i16]* %G, [64 x i16]* %B, [64 x i16]* %tmp, [32 x i16]* %sqrt_t, [64 x i16]* %exp_t, i16 signext %row, i16 signext %col) #1 {
  call void (...)* @_ssdm_op_SpecBitsMap([64 x i16]* %ret) #0, !map !7
  call void (...)* @_ssdm_op_SpecBitsMap([64 x i16]* %R) #0, !map !13
  call void (...)* @_ssdm_op_SpecBitsMap([64 x i16]* %G) #0, !map !17
  call void (...)* @_ssdm_op_SpecBitsMap([64 x i16]* %B) #0, !map !21
  call void (...)* @_ssdm_op_SpecBitsMap([64 x i16]* %tmp) #0, !map !25
  call void (...)* @_ssdm_op_SpecBitsMap([32 x i16]* %sqrt_t) #0, !map !29
  call void (...)* @_ssdm_op_SpecBitsMap([64 x i16]* %exp_t) #0, !map !35
  call void (...)* @_ssdm_op_SpecBitsMap(i16 %row) #0, !map !41
  call void (...)* @_ssdm_op_SpecBitsMap(i16 %col) #0, !map !47
  call void (...)* @_ssdm_op_SpecTopModule([21 x i8]* @str) #0
  %col_read = call i16 @_ssdm_op_Read.ap_auto.i16(i16 %col) #0
  %row_read = call i16 @_ssdm_op_Read.ap_auto.i16(i16 %row) #0
  br label %1

; <label>:1                                       ; preds = %2, %0
  %i = phi i4 [ 0, %0 ], [ %i_1, %2 ]
  %exitcond3 = icmp eq i4 %i, -8
  %i_1 = add i4 %i, 1
  br i1 %exitcond3, label %.preheader, label %2

.preheader:                                       ; preds = %1
  %tmp_1_cast = sext i16 %col_read to i17
  %tmp_2 = add i17 %tmp_1_cast, -1
  %tmp_3_cast = sext i16 %row_read to i17
  %tmp_4 = add i17 %tmp_3_cast, -1
  br label %3

; <label>:2                                       ; preds = %1
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 8, i64 8, i64 8) #0
  call void (...)* @_ssdm_op_SpecLoopName([28 x i8]* @p_str) #0
  %tmp_1 = call i32 (...)* @_ssdm_op_SpecRegionBegin([28 x i8]* @p_str) #0
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, [1 x i8]* @p_str1) #0
  %tmp_5 = call i7 @_ssdm_op_BitConcatenate.i7.i4.i3(i4 %i, i3 0)
  %tmp_6 = zext i7 %tmp_5 to i64
  %R_addr = getelementptr [64 x i16]* %R, i64 0, i64 %tmp_6
  %R_load_1 = load i16* %R_addr, align 2
  %tmp_14_cast = sext i16 %R_load_1 to i27
  %tmp_3 = mul i27 %tmp_14_cast, 1741
  %tmp_11 = call i14 @_ssdm_op_PartSelect.i14.i27.i32.i32(i27 %tmp_3, i32 13, i32 26)
  %tmp_gray_cast = sext i14 %tmp_11 to i15
  %G_addr = getelementptr [64 x i16]* %G, i64 0, i64 %tmp_6
  %G_load_1 = load i16* %G_addr, align 2
  %tmp_17_cast = sext i16 %G_load_1 to i29
  %tmp_8 = mul i29 %tmp_17_cast, 5859
  %tmp_s = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %tmp_8, i32 13, i32 28)
  %B_addr = getelementptr [64 x i16]* %B, i64 0, i64 %tmp_6
  %B_load_1 = load i16* %B_addr, align 2
  %tmp_21_cast = sext i16 %B_load_1 to i26
  %tmp_12 = mul i26 %tmp_21_cast, 591
  %tmp_13 = call i13 @_ssdm_op_PartSelect.i13.i26.i32.i32(i26 %tmp_12, i32 13, i32 25)
  %tmp_15_cast = sext i13 %tmp_13 to i15
  %tmp7 = add i15 %tmp_gray_cast, %tmp_15_cast
  %tmp7_cast = sext i15 %tmp7 to i16
  %tmp_gray_2 = add i16 %tmp7_cast, %tmp_s
  %tmp_addr = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_6
  store i16 %tmp_gray_2, i16* %tmp_addr, align 2
  %tmp_14 = call i7 @_ssdm_op_BitConcatenate.i7.i4.i3(i4 %i, i3 1)
  %tmp_15 = zext i7 %tmp_14 to i64
  %R_addr_1 = getelementptr [64 x i16]* %R, i64 0, i64 %tmp_15
  %R_load_2 = load i16* %R_addr_1, align 2
  %tmp_14_1_cast = sext i16 %R_load_2 to i27
  %tmp_15_1 = mul i27 %tmp_14_1_cast, 1741
  %tmp_16 = call i14 @_ssdm_op_PartSelect.i14.i27.i32.i32(i27 %tmp_15_1, i32 13, i32 26)
  %tmp_gray_cast_42 = sext i14 %tmp_16 to i15
  %G_addr_1 = getelementptr [64 x i16]* %G, i64 0, i64 %tmp_15
  %G_load_2 = load i16* %G_addr_1, align 2
  %tmp_17_1_cast = sext i16 %G_load_2 to i29
  %tmp_18_1 = mul i29 %tmp_17_1_cast, 5859
  %tmp_20_1 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %tmp_18_1, i32 13, i32 28)
  %B_addr_1 = getelementptr [64 x i16]* %B, i64 0, i64 %tmp_15
  %B_load_2 = load i16* %B_addr_1, align 2
  %tmp_21_1_cast = sext i16 %B_load_2 to i26
  %tmp_22_1 = mul i26 %tmp_21_1_cast, 591
  %tmp_17 = call i13 @_ssdm_op_PartSelect.i13.i26.i32.i32(i26 %tmp_22_1, i32 13, i32 25)
  %tmp_24_1_cast = sext i13 %tmp_17 to i15
  %tmp15 = add i15 %tmp_gray_cast_42, %tmp_24_1_cast
  %tmp15_cast = sext i15 %tmp15 to i16
  %tmp_gray_2_1 = add i16 %tmp15_cast, %tmp_20_1
  %tmp_addr_1 = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_15
  store i16 %tmp_gray_2_1, i16* %tmp_addr_1, align 2
  %tmp_18 = call i7 @_ssdm_op_BitConcatenate.i7.i4.i3(i4 %i, i3 2)
  %tmp_19 = zext i7 %tmp_18 to i64
  %R_addr_2 = getelementptr [64 x i16]* %R, i64 0, i64 %tmp_19
  %R_load_3 = load i16* %R_addr_2, align 2
  %tmp_14_2_cast = sext i16 %R_load_3 to i27
  %tmp_15_2 = mul i27 %tmp_14_2_cast, 1741
  %tmp_20 = call i14 @_ssdm_op_PartSelect.i14.i27.i32.i32(i27 %tmp_15_2, i32 13, i32 26)
  %tmp_gray_8_cast = sext i14 %tmp_20 to i15
  %G_addr_2 = getelementptr [64 x i16]* %G, i64 0, i64 %tmp_19
  %G_load_3 = load i16* %G_addr_2, align 2
  %tmp_17_2_cast = sext i16 %G_load_3 to i29
  %tmp_18_2 = mul i29 %tmp_17_2_cast, 5859
  %tmp_20_2 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %tmp_18_2, i32 13, i32 28)
  %B_addr_2 = getelementptr [64 x i16]* %B, i64 0, i64 %tmp_19
  %B_load_3 = load i16* %B_addr_2, align 2
  %tmp_21_2_cast = sext i16 %B_load_3 to i26
  %tmp_22_2 = mul i26 %tmp_21_2_cast, 591
  %tmp_21 = call i13 @_ssdm_op_PartSelect.i13.i26.i32.i32(i26 %tmp_22_2, i32 13, i32 25)
  %tmp_24_2_cast = sext i13 %tmp_21 to i15
  %tmp16 = add i15 %tmp_gray_8_cast, %tmp_24_2_cast
  %tmp16_cast = sext i15 %tmp16 to i16
  %tmp_gray_2_2 = add i16 %tmp16_cast, %tmp_20_2
  %tmp_addr_2 = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_19
  store i16 %tmp_gray_2_2, i16* %tmp_addr_2, align 2
  %tmp_22 = call i7 @_ssdm_op_BitConcatenate.i7.i4.i3(i4 %i, i3 3)
  %tmp_23 = zext i7 %tmp_22 to i64
  %R_addr_3 = getelementptr [64 x i16]* %R, i64 0, i64 %tmp_23
  %R_load_4 = load i16* %R_addr_3, align 2
  %tmp_14_3_cast = sext i16 %R_load_4 to i27
  %tmp_15_3 = mul i27 %tmp_14_3_cast, 1741
  %tmp_24 = call i14 @_ssdm_op_PartSelect.i14.i27.i32.i32(i27 %tmp_15_3, i32 13, i32 26)
  %tmp_gray_3_cast = sext i14 %tmp_24 to i15
  %G_addr_3 = getelementptr [64 x i16]* %G, i64 0, i64 %tmp_23
  %G_load_4 = load i16* %G_addr_3, align 2
  %tmp_17_3_cast = sext i16 %G_load_4 to i29
  %tmp_18_3 = mul i29 %tmp_17_3_cast, 5859
  %tmp_20_3 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %tmp_18_3, i32 13, i32 28)
  %B_addr_3 = getelementptr [64 x i16]* %B, i64 0, i64 %tmp_23
  %B_load_4 = load i16* %B_addr_3, align 2
  %tmp_21_3_cast = sext i16 %B_load_4 to i26
  %tmp_22_3 = mul i26 %tmp_21_3_cast, 591
  %tmp_25 = call i13 @_ssdm_op_PartSelect.i13.i26.i32.i32(i26 %tmp_22_3, i32 13, i32 25)
  %tmp_24_3_cast = sext i13 %tmp_25 to i15
  %tmp17 = add i15 %tmp_gray_3_cast, %tmp_24_3_cast
  %tmp17_cast = sext i15 %tmp17 to i16
  %tmp_gray_2_3 = add i16 %tmp17_cast, %tmp_20_3
  %tmp_addr_3 = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_23
  store i16 %tmp_gray_2_3, i16* %tmp_addr_3, align 2
  %tmp_28 = call i7 @_ssdm_op_BitConcatenate.i7.i4.i3(i4 %i, i3 -4)
  %tmp_30 = zext i7 %tmp_28 to i64
  %R_addr_4 = getelementptr [64 x i16]* %R, i64 0, i64 %tmp_30
  %R_load_5 = load i16* %R_addr_4, align 2
  %tmp_14_4_cast = sext i16 %R_load_5 to i27
  %tmp_15_4 = mul i27 %tmp_14_4_cast, 1741
  %tmp_32 = call i14 @_ssdm_op_PartSelect.i14.i27.i32.i32(i27 %tmp_15_4, i32 13, i32 26)
  %tmp_gray_4_cast = sext i14 %tmp_32 to i15
  %G_addr_4 = getelementptr [64 x i16]* %G, i64 0, i64 %tmp_30
  %G_load_5 = load i16* %G_addr_4, align 2
  %tmp_17_4_cast = sext i16 %G_load_5 to i29
  %tmp_18_4 = mul i29 %tmp_17_4_cast, 5859
  %tmp_20_4 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %tmp_18_4, i32 13, i32 28)
  %B_addr_4 = getelementptr [64 x i16]* %B, i64 0, i64 %tmp_30
  %B_load_5 = load i16* %B_addr_4, align 2
  %tmp_21_4_cast = sext i16 %B_load_5 to i26
  %tmp_22_4 = mul i26 %tmp_21_4_cast, 591
  %tmp_34 = call i13 @_ssdm_op_PartSelect.i13.i26.i32.i32(i26 %tmp_22_4, i32 13, i32 25)
  %tmp_24_4_cast = sext i13 %tmp_34 to i15
  %tmp18 = add i15 %tmp_gray_4_cast, %tmp_24_4_cast
  %tmp18_cast = sext i15 %tmp18 to i16
  %tmp_gray_2_4 = add i16 %tmp18_cast, %tmp_20_4
  %tmp_addr_4 = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_30
  store i16 %tmp_gray_2_4, i16* %tmp_addr_4, align 2
  %tmp_35 = call i7 @_ssdm_op_BitConcatenate.i7.i4.i3(i4 %i, i3 -3)
  %tmp_38 = zext i7 %tmp_35 to i64
  %R_addr_5 = getelementptr [64 x i16]* %R, i64 0, i64 %tmp_38
  %R_load_6 = load i16* %R_addr_5, align 2
  %tmp_14_5_cast = sext i16 %R_load_6 to i27
  %tmp_15_5 = mul i27 %tmp_14_5_cast, 1741
  %tmp_39 = call i14 @_ssdm_op_PartSelect.i14.i27.i32.i32(i27 %tmp_15_5, i32 13, i32 26)
  %tmp_gray_5_cast = sext i14 %tmp_39 to i15
  %G_addr_5 = getelementptr [64 x i16]* %G, i64 0, i64 %tmp_38
  %G_load_6 = load i16* %G_addr_5, align 2
  %tmp_17_5_cast = sext i16 %G_load_6 to i29
  %tmp_18_5 = mul i29 %tmp_17_5_cast, 5859
  %tmp_20_5 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %tmp_18_5, i32 13, i32 28)
  %B_addr_5 = getelementptr [64 x i16]* %B, i64 0, i64 %tmp_38
  %B_load_6 = load i16* %B_addr_5, align 2
  %tmp_21_5_cast = sext i16 %B_load_6 to i26
  %tmp_22_5 = mul i26 %tmp_21_5_cast, 591
  %tmp_40 = call i13 @_ssdm_op_PartSelect.i13.i26.i32.i32(i26 %tmp_22_5, i32 13, i32 25)
  %tmp_24_5_cast = sext i13 %tmp_40 to i15
  %tmp19 = add i15 %tmp_gray_5_cast, %tmp_24_5_cast
  %tmp19_cast = sext i15 %tmp19 to i16
  %tmp_gray_2_5 = add i16 %tmp19_cast, %tmp_20_5
  %tmp_addr_5 = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_38
  store i16 %tmp_gray_2_5, i16* %tmp_addr_5, align 2
  %tmp_42 = call i7 @_ssdm_op_BitConcatenate.i7.i4.i3(i4 %i, i3 -2)
  %tmp_43 = zext i7 %tmp_42 to i64
  %R_addr_6 = getelementptr [64 x i16]* %R, i64 0, i64 %tmp_43
  %R_load_7 = load i16* %R_addr_6, align 2
  %tmp_14_6_cast = sext i16 %R_load_7 to i27
  %tmp_15_6 = mul i27 %tmp_14_6_cast, 1741
  %tmp_44 = call i14 @_ssdm_op_PartSelect.i14.i27.i32.i32(i27 %tmp_15_6, i32 13, i32 26)
  %tmp_gray_6_cast = sext i14 %tmp_44 to i15
  %G_addr_6 = getelementptr [64 x i16]* %G, i64 0, i64 %tmp_43
  %G_load_7 = load i16* %G_addr_6, align 2
  %tmp_17_6_cast = sext i16 %G_load_7 to i29
  %tmp_18_6 = mul i29 %tmp_17_6_cast, 5859
  %tmp_20_6 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %tmp_18_6, i32 13, i32 28)
  %B_addr_6 = getelementptr [64 x i16]* %B, i64 0, i64 %tmp_43
  %B_load_7 = load i16* %B_addr_6, align 2
  %tmp_21_6_cast = sext i16 %B_load_7 to i26
  %tmp_22_6 = mul i26 %tmp_21_6_cast, 591
  %tmp_45 = call i13 @_ssdm_op_PartSelect.i13.i26.i32.i32(i26 %tmp_22_6, i32 13, i32 25)
  %tmp_24_6_cast = sext i13 %tmp_45 to i15
  %tmp20 = add i15 %tmp_gray_6_cast, %tmp_24_6_cast
  %tmp20_cast = sext i15 %tmp20 to i16
  %tmp_gray_2_6 = add i16 %tmp20_cast, %tmp_20_6
  %tmp_addr_6 = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_43
  store i16 %tmp_gray_2_6, i16* %tmp_addr_6, align 2
  %tmp_49 = call i7 @_ssdm_op_BitConcatenate.i7.i4.i3(i4 %i, i3 -1)
  %tmp_51 = zext i7 %tmp_49 to i64
  %R_addr_7 = getelementptr [64 x i16]* %R, i64 0, i64 %tmp_51
  %R_load_8 = load i16* %R_addr_7, align 2
  %tmp_14_7_cast = sext i16 %R_load_8 to i27
  %tmp_15_7 = mul i27 %tmp_14_7_cast, 1741
  %tmp_53 = call i14 @_ssdm_op_PartSelect.i14.i27.i32.i32(i27 %tmp_15_7, i32 13, i32 26)
  %tmp_gray_7_cast = sext i14 %tmp_53 to i15
  %G_addr_7 = getelementptr [64 x i16]* %G, i64 0, i64 %tmp_51
  %G_load_8 = load i16* %G_addr_7, align 2
  %tmp_17_7_cast = sext i16 %G_load_8 to i29
  %tmp_18_7 = mul i29 %tmp_17_7_cast, 5859
  %tmp_20_7 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %tmp_18_7, i32 13, i32 28)
  %B_addr_7 = getelementptr [64 x i16]* %B, i64 0, i64 %tmp_51
  %B_load_8 = load i16* %B_addr_7, align 2
  %tmp_21_7_cast = sext i16 %B_load_8 to i26
  %tmp_22_7 = mul i26 %tmp_21_7_cast, 591
  %tmp_55 = call i13 @_ssdm_op_PartSelect.i13.i26.i32.i32(i26 %tmp_22_7, i32 13, i32 25)
  %tmp_24_7_cast = sext i13 %tmp_55 to i15
  %tmp21 = add i15 %tmp_gray_7_cast, %tmp_24_7_cast
  %tmp21_cast = sext i15 %tmp21 to i16
  %tmp_gray_2_7 = add i16 %tmp21_cast, %tmp_20_7
  %tmp_addr_7 = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_51
  store i16 %tmp_gray_2_7, i16* %tmp_addr_7, align 2
  %empty_43 = call i32 (...)* @_ssdm_op_SpecRegionEnd([28 x i8]* @p_str, i32 %tmp_1) #0
  br label %1

; <label>:3                                       ; preds = %6, %.preheader
  %i1 = phi i4 [ %i_2, %6 ], [ 0, %.preheader ]
  %exitcond1 = icmp eq i4 %i1, -8
  %empty_44 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 8, i64 8, i64 8) #0
  %i_2 = add i4 %i1, 1
  br i1 %exitcond1, label %7, label %4

; <label>:4                                       ; preds = %3
  call void (...)* @_ssdm_op_SpecLoopName([28 x i8]* @p_str2) #0
  %tmp_47 = call i32 (...)* @_ssdm_op_SpecRegionBegin([28 x i8]* @p_str2) #0
  %tmp_7 = icmp ne i4 %i1, 0
  %tmp_8_cast = zext i4 %i1 to i17
  %tmp_9 = add i4 %i1, -1
  %tmp_10 = icmp slt i17 %tmp_8_cast, %tmp_4
  br label %5

; <label>:5                                       ; preds = %_ifconv, %4
  %j2 = phi i4 [ 0, %4 ], [ %j, %_ifconv ]
  %exitcond = icmp eq i4 %j2, -8
  %empty_45 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 8, i64 8, i64 8) #0
  %j = add i4 %j2, 1
  br i1 %exitcond, label %6, label %_ifconv

_ifconv:                                          ; preds = %5
  call void (...)* @_ssdm_op_SpecLoopName([28 x i8]* @p_str3) #0
  %tmp_25_trn_cast = zext i4 %j2 to i8
  %tmp_57 = call i7 @_ssdm_op_BitConcatenate.i7.i4.i3(i4 %i1, i3 0)
  %p_addr_cast1 = zext i7 %tmp_57 to i9
  %p_addr_cast = zext i7 %tmp_57 to i8
  %p_addr1 = add i8 %p_addr_cast, %tmp_25_trn_cast
  %tmp_59 = zext i8 %p_addr1 to i64
  %tmp_addr_8 = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_59
  %c = load i16* %tmp_addr_8, align 2
  %tmp_60 = call i7 @_ssdm_op_BitConcatenate.i7.i4.i3(i4 %tmp_9, i3 0)
  %p_addr2_cast = sext i7 %tmp_60 to i8
  %p_addr3 = add i8 %p_addr2_cast, %tmp_25_trn_cast
  %tmp_62 = sext i8 %p_addr3 to i64
  %tmp_addr_9 = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_62
  %empty_46 = load i16* %tmp_addr_9, align 2
  %tmp_26 = select i1 %tmp_7, i16 %empty_46, i16 %c
  %tmp_27 = icmp ne i4 %j2, 0
  %tmp_28_cast = zext i4 %j2 to i17
  %tmp_29 = add i4 %j2, -1
  %tmp_29_cast_cast = sext i4 %tmp_29 to i9
  %p_addr4 = add i9 %p_addr_cast1, %tmp_29_cast_cast
  %tmp_63 = sext i9 %p_addr4 to i64
  %tmp_addr_10 = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_63
  %empty_47 = load i16* %tmp_addr_10, align 2
  %tmp_31 = select i1 %tmp_27, i16 %empty_47, i16 %c
  %tmp_33 = icmp slt i17 %tmp_28_cast, %tmp_2
  %tmp_35_trn_cast = zext i4 %j to i8
  %p_addr5 = add i8 %p_addr_cast, %tmp_35_trn_cast
  %tmp_65 = zext i8 %p_addr5 to i64
  %tmp_addr_11 = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_65
  %empty_48 = load i16* %tmp_addr_11, align 2
  %tmp_36 = select i1 %tmp_33, i16 %empty_48, i16 %c
  %tmp_66 = call i7 @_ssdm_op_BitConcatenate.i7.i4.i3(i4 %i_2, i3 0)
  %p_addr6_cast = zext i7 %tmp_66 to i8
  %p_addr7 = add i8 %p_addr6_cast, %tmp_25_trn_cast
  %tmp_70 = zext i8 %p_addr7 to i64
  %tmp_addr_12 = getelementptr [64 x i16]* %tmp, i64 0, i64 %tmp_70
  %empty_49 = load i16* %tmp_addr_12, align 2
  %tmp_37 = select i1 %tmp_10, i16 %empty_49, i16 %c
  %e = sub i16 %tmp_37, %c
  %tmp_71 = shl i16 %c, 2
  %p_neg = sub i16 0, %tmp_71
  %factor = add i16 %p_neg, %c
  %tmp24 = add i16 %tmp_31, %tmp_36
  %tmp26 = add i16 %tmp_26, %e
  %tmp25 = add i16 %tmp26, %factor
  %contrast = add i16 %tmp25, %tmp24
  %tmp_75 = call i1 @_ssdm_op_BitSelect.i1.i16.i32(i16 %contrast, i32 15)
  %tmp_41 = sub i16 0, %contrast
  %contrast_1 = select i1 %tmp_75, i16 %tmp_41, i16 %contrast
  %R_addr_8 = getelementptr [64 x i16]* %R, i64 0, i64 %tmp_59
  %R_load = load i16* %R_addr_8, align 2
  %tmp_42_cast = sext i16 %R_load to i17
  %G_addr_8 = getelementptr [64 x i16]* %G, i64 0, i64 %tmp_59
  %G_load = load i16* %G_addr_8, align 2
  %tmp_43_cast = sext i16 %G_load to i18
  %B_addr_8 = getelementptr [64 x i16]* %B, i64 0, i64 %tmp_59
  %B_load = load i16* %B_addr_8, align 2
  %tmp_44_cast = sext i16 %B_load to i17
  %tmp27 = add i17 %tmp_42_cast, %tmp_44_cast
  %tmp27_cast = sext i17 %tmp27 to i18
  %tmp_46 = add i18 %tmp27_cast, %tmp_43_cast
  %sext_cast = sext i18 %tmp_46 to i38
  %mul = mul i38 %sext_cast, 699051
  %neg_mul = sub i38 0, %mul
  %tmp_76 = call i1 @_ssdm_op_BitSelect.i1.i18.i32(i18 %tmp_46, i32 17)
  %sel = select i1 %tmp_76, i38 %neg_mul, i38 %mul
  %tmp_82 = call i17 @_ssdm_op_PartSelect.i17.i38.i32.i32(i38 %sel, i32 21, i32 37)
  %trunc_cast = sext i17 %tmp_82 to i18
  %neg_ti = sub i18 0, %trunc_cast
  %tmp_67 = select i1 %tmp_76, i18 %neg_ti, i18 %trunc_cast
  %mean = trunc i18 %tmp_67 to i16
  %ret_1 = sub i16 %R_load, %mean
  %ret_0_i1 = sext i16 %ret_1 to i32
  %tmp_48 = mul nsw i32 %ret_0_i1, %ret_0_i1
  %tmp_50 = call i16 @_ssdm_op_PartSelect.i16.i32.i32.i32(i32 %tmp_48, i32 13, i32 28)
  %tmp_51_cast = sext i16 %tmp_50 to i17
  %ret_2 = sub i16 %G_load, %mean
  %ret_0_i2 = sext i16 %ret_2 to i32
  %tmp_52 = mul nsw i32 %ret_0_i2, %ret_0_i2
  %tmp_54 = call i16 @_ssdm_op_PartSelect.i16.i32.i32.i32(i32 %tmp_52, i32 13, i32 28)
  %tmp_55_cast = sext i16 %tmp_54 to i18
  %ret_3 = sub i16 %B_load, %mean
  %ret_0_i3 = sext i16 %ret_3 to i32
  %tmp_56 = mul nsw i32 %ret_0_i3, %ret_0_i3
  %tmp_58 = call i16 @_ssdm_op_PartSelect.i16.i32.i32.i32(i32 %tmp_56, i32 13, i32 28)
  %tmp_59_cast = sext i16 %tmp_58 to i17
  %tmp28 = add i17 %tmp_51_cast, %tmp_59_cast
  %tmp28_cast = sext i17 %tmp28 to i18
  %tmp_61 = add i18 %tmp28_cast, %tmp_55_cast
  %sext1_cast = sext i18 %tmp_61 to i38
  %mul1 = mul i38 %sext1_cast, 699051
  %neg_mul1 = sub i38 0, %mul1
  %tmp_88 = call i1 @_ssdm_op_BitSelect.i1.i18.i32(i18 %tmp_61, i32 17)
  %sel1 = select i1 %tmp_88, i38 %neg_mul1, i38 %mul1
  %tmp_90 = call i17 @_ssdm_op_PartSelect.i17.i38.i32.i32(i38 %sel1, i32 21, i32 37)
  %trunc1_cast = sext i17 %tmp_90 to i18
  %neg_ti1 = sub i18 0, %trunc1_cast
  %tmp_72 = select i1 %tmp_88, i18 %neg_ti1, i18 %trunc1_cast
  %idx3 = call i3 @_ssdm_op_PartSelect.i3.i18.i32.i32(i18 %tmp_72, i32 10, i32 12)
  %tmp_64 = icmp eq i3 %idx3, 0
  %idx2 = call i3 @_ssdm_op_PartSelect.i3.i18.i32.i32(i18 %tmp_72, i32 7, i32 9)
  %tmp_77 = call i5 @_ssdm_op_BitConcatenate.i5.i2.i3(i2 -1, i3 %idx3)
  %tmp_77_cast = zext i5 %tmp_77 to i16
  %tmp_68 = call i32 @_ssdm_op_BitConcatenate.i32.i16.i16(i16 0, i16 %tmp_77_cast)
  %tmp_69 = zext i32 %tmp_68 to i64
  %sqrt_t_addr = getelementptr [32 x i16]* %sqrt_t, i64 0, i64 %tmp_69
  %sqrt_t_load = load i16* %sqrt_t_addr, align 2
  %idx1 = call i3 @_ssdm_op_PartSelect.i3.i18.i32.i32(i18 %tmp_72, i32 4, i32 6)
  %tmp_85 = call i5 @_ssdm_op_BitConcatenate.i5.i2.i3(i2 -2, i3 %idx2)
  %tmp_109_cast = zext i5 %tmp_85 to i16
  %tmp_73 = call i32 @_ssdm_op_BitConcatenate.i32.i16.i16(i16 0, i16 %tmp_109_cast)
  %tmp_74 = zext i32 %tmp_73 to i64
  %sqrt_t_addr_1 = getelementptr [32 x i16]* %sqrt_t, i64 0, i64 %tmp_74
  %sqrt_t_load_1 = load i16* %sqrt_t_addr_1, align 2
  %idx0 = call i3 @_ssdm_op_PartSelect.i3.i18.i32.i32(i18 %tmp_72, i32 1, i32 3)
  %tmp_91 = call i4 @_ssdm_op_BitConcatenate.i4.i1.i3(i1 true, i3 %idx1)
  %tmp_110_cast = zext i4 %tmp_91 to i16
  %tmp_78 = call i32 @_ssdm_op_BitConcatenate.i32.i16.i16(i16 0, i16 %tmp_110_cast)
  %tmp_79 = zext i32 %tmp_78 to i64
  %sqrt_t_addr_2 = getelementptr [32 x i16]* %sqrt_t, i64 0, i64 %tmp_79
  %sqrt_t_load_2 = load i16* %sqrt_t_addr_2, align 2
  %tmp_80 = zext i3 %idx0 to i64
  %sqrt_t_addr_3 = getelementptr [32 x i16]* %sqrt_t, i64 0, i64 %tmp_80
  %sqrt_t_load_3 = load i16* %sqrt_t_addr_3, align 2
  %sel_tmp2 = icmp ne i3 %idx2, 0
  %sel_tmp3 = and i1 %tmp_64, %sel_tmp2
  %tmp_93 = or i3 %idx3, %idx2
  %tmp_95 = icmp eq i3 %tmp_93, 0
  %sel_tmp6 = icmp ne i3 %idx1, 0
  %sel_tmp7 = and i1 %tmp_95, %sel_tmp6
  %tmp29 = or i3 %idx1, %idx0
  %tmp_96 = or i3 %tmp29, %tmp_93
  %tmp_97 = icmp eq i3 %tmp_96, 0
  %newSel = select i1 %tmp_97, i16 0, i16 %sqrt_t_load_2
  %or_cond = or i1 %tmp_97, %sel_tmp7
  %newSel1 = select i1 %sel_tmp3, i16 %sqrt_t_load_1, i16 %sqrt_t_load_3
  %newSel2 = select i1 %or_cond, i16 %newSel, i16 %newSel1
  %or_cond1 = or i1 %or_cond, %tmp_64
  %saturation = select i1 %or_cond1, i16 %newSel2, i16 %sqrt_t_load
  %ret_4 = add i16 %R_load, -4096
  %ret_0_i4_cast = sext i16 %ret_4 to i29
  %tmp_81 = mul i29 %ret_0_i4_cast, %ret_0_i4_cast
  %tmp_83 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %tmp_81, i32 13, i32 28)
  %ret_5 = add i16 %G_load, -4096
  %ret_0_i5_cast = sext i16 %ret_5 to i29
  %tmp_84 = mul i29 %ret_0_i5_cast, %ret_0_i5_cast
  %tmp_86 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %tmp_84, i32 13, i32 28)
  %ret_6 = add i16 %B_load, -4096
  %ret_0_i6_cast = sext i16 %ret_6 to i29
  %tmp_87 = mul i29 %ret_0_i6_cast, %ret_0_i6_cast
  %tmp_89 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %tmp_87, i32 13, i32 28)
  %tmp30 = add i16 %tmp_83, %tmp_89
  %b_assign = add i16 %tmp30, %tmp_86
  %p_shl1 = call i28 @_ssdm_op_BitConcatenate.i28.i16.i12(i16 %b_assign, i12 0)
  %p_shl1_cast = sext i28 %p_shl1 to i29
  %tmp_92 = sub i29 0, %p_shl1_cast
  %up = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %tmp_92, i32 13, i32 28)
  %tmp_94 = icmp sgt i16 %up, -1310
  %tmp_98 = call i15 @_ssdm_op_PartSelect.i15.i29.i32.i32(i29 %tmp_92, i32 13, i32 27)
  %tmp_102 = mul i15 %tmp_98, -25
  %tmp_97_cast = call i6 @_ssdm_op_PartSelect.i6.i15.i32.i32(i15 %tmp_102, i32 9, i32 14)
  %tmp_99 = zext i6 %tmp_97_cast to i64
  %exp_t_addr = getelementptr [64 x i16]* %exp_t, i64 0, i64 %tmp_99
  %well_exp = load i16* %exp_t_addr, align 2
  %ret_7 = select i1 %tmp_94, i16 %well_exp, i16 1
  %ret_0_i9 = sext i16 %ret_7 to i32
  %tmp_100 = sext i16 %saturation to i32
  %tmp_101 = mul nsw i32 %tmp_100, %ret_0_i9
  %tmp_103 = call i13 @_ssdm_op_PartSelect.i13.i32.i32.i32(i32 %tmp_101, i32 13, i32 25)
  %ret_8 = call i16 @_ssdm_op_BitConcatenate.i16.i13.i3(i13 %tmp_103, i3 0)
  %ret_0_i = sext i16 %ret_8 to i32
  %tmp_104 = sext i16 %contrast_1 to i32
  %tmp_105 = mul nsw i32 %tmp_104, %ret_0_i
  %tmp_106 = call i16 @_ssdm_op_PartSelect.i16.i32.i32.i32(i32 %tmp_105, i32 13, i32 28)
  %ret_addr = getelementptr [64 x i16]* %ret, i64 0, i64 %tmp_59
  %tmp_107 = icmp eq i16 %tmp_106, 0
  %p_tmp_s = select i1 %tmp_107, i16 1, i16 %tmp_106
  store i16 %p_tmp_s, i16* %ret_addr, align 2
  br label %5

; <label>:6                                       ; preds = %5
  %empty_50 = call i32 (...)* @_ssdm_op_SpecRegionEnd([28 x i8]* @p_str2, i32 %tmp_47) #0
  br label %3

; <label>:7                                       ; preds = %3
  ret void
}

define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

; Function Attrs: nounwind readnone
define weak i32 @_ssdm_op_BitConcatenate.i32.i16.i16(i16, i16) #2 {
entry:
  %empty = zext i16 %0 to i32
  %empty_51 = zext i16 %1 to i32
  %empty_52 = trunc i32 %empty to i16
  %empty_53 = call i16 @_ssdm_op_PartSelect.i16.i32.i32.i32(i32 %empty_51, i32 16, i32 31)
  %empty_54 = or i16 %empty_52, %empty_53
  %empty_55 = call i32 @_ssdm_op_PartSet.i32.i32.i16.i32.i32(i32 %empty_51, i16 %empty_54, i32 16, i32 31)
  ret i32 %empty_55
}

define weak i32 @_ssdm_op_SpecLoopTripCount(...) {
entry:
  ret i32 0
}

; Function Attrs: nounwind readnone
define weak i5 @_ssdm_op_BitConcatenate.i5.i2.i3(i2, i3) #2 {
entry:
  %empty = zext i2 %0 to i5
  %empty_56 = zext i3 %1 to i5
  %empty_57 = trunc i5 %empty to i2
  %empty_58 = call i2 @_ssdm_op_PartSelect.i2.i5.i32.i32(i5 %empty_56, i32 3, i32 4)
  %empty_59 = or i2 %empty_57, %empty_58
  %empty_60 = call i5 @_ssdm_op_PartSet.i5.i5.i2.i32.i32(i5 %empty_56, i2 %empty_59, i32 3, i32 4)
  ret i5 %empty_60
}

; Function Attrs: nounwind readnone
define weak i4 @_ssdm_op_BitConcatenate.i4.i1.i3(i1, i3) #2 {
entry:
  %empty = zext i1 %0 to i4
  %empty_61 = zext i3 %1 to i4
  %empty_62 = trunc i4 %empty to i1
  %empty_63 = call i1 @_ssdm_op_BitSelect.i1.i4.i32(i4 %empty_61, i32 3)
  %empty_64 = or i1 %empty_62, %empty_63
  %empty_65 = call i4 @_ssdm_op_PartSet.i4.i4.i1.i32.i32(i4 %empty_61, i1 %empty_64, i32 3, i32 3)
  ret i4 %empty_65
}

; Function Attrs: nounwind readnone
define weak i14 @_ssdm_op_PartSelect.i14.i27.i32.i32(i27, i32, i32) #2 {
entry:
  %empty = call i27 @llvm.part.select.i27(i27 %0, i32 %1, i32 %2)
  %empty_66 = trunc i27 %empty to i14
  ret i14 %empty_66
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_67 = trunc i29 %empty to i16
  ret i16 %empty_67
}

; Function Attrs: nounwind readnone
define weak i13 @_ssdm_op_PartSelect.i13.i26.i32.i32(i26, i32, i32) #2 {
entry:
  %empty = call i26 @llvm.part.select.i26(i26 %0, i32 %1, i32 %2)
  %empty_68 = trunc i26 %empty to i13
  ret i13 %empty_68
}

; Function Attrs: nounwind readnone
define weak i7 @_ssdm_op_BitConcatenate.i7.i4.i3(i4, i3) #2 {
entry:
  %empty = zext i4 %0 to i7
  %empty_69 = zext i3 %1 to i7
  %empty_70 = trunc i7 %empty to i4
  %empty_71 = call i4 @_ssdm_op_PartSelect.i4.i7.i32.i32(i7 %empty_69, i32 3, i32 6)
  %empty_72 = or i4 %empty_70, %empty_71
  %empty_73 = call i7 @_ssdm_op_PartSet.i7.i7.i4.i32.i32(i7 %empty_69, i4 %empty_72, i32 3, i32 6)
  ret i7 %empty_73
}

; Function Attrs: nounwind readnone
define weak i17 @_ssdm_op_PartSelect.i17.i38.i32.i32(i38, i32, i32) #2 {
entry:
  %empty = call i38 @llvm.part.select.i38(i38 %0, i32 %1, i32 %2)
  %empty_74 = trunc i38 %empty to i17
  ret i17 %empty_74
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i32.i32.i32(i32, i32, i32) #2 {
entry:
  %empty = call i32 @llvm.part.select.i32(i32 %0, i32 %1, i32 %2)
  %empty_75 = trunc i32 %empty to i16
  ret i16 %empty_75
}

; Function Attrs: nounwind readnone
define weak i28 @_ssdm_op_BitConcatenate.i28.i16.i12(i16, i12) #2 {
entry:
  %empty = zext i16 %0 to i28
  %empty_76 = zext i12 %1 to i28
  %empty_77 = trunc i28 %empty to i16
  %empty_78 = call i16 @_ssdm_op_PartSelect.i16.i28.i32.i32(i28 %empty_76, i32 12, i32 27)
  %empty_79 = or i16 %empty_77, %empty_78
  %empty_80 = call i28 @_ssdm_op_PartSet.i28.i28.i16.i32.i32(i28 %empty_76, i16 %empty_79, i32 12, i32 27)
  ret i28 %empty_80
}

; Function Attrs: nounwind readnone
define weak i15 @_ssdm_op_PartSelect.i15.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_81 = trunc i29 %empty to i15
  ret i15 %empty_81
}

; Function Attrs: nounwind readnone
define weak i6 @_ssdm_op_PartSelect.i6.i15.i32.i32(i15, i32, i32) #2 {
entry:
  %empty = call i15 @llvm.part.select.i15(i15 %0, i32 %1, i32 %2)
  %empty_82 = trunc i15 %empty to i6
  ret i6 %empty_82
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_BitConcatenate.i16.i13.i3(i13, i3) #2 {
entry:
  %empty = zext i13 %0 to i16
  %empty_83 = zext i3 %1 to i16
  %empty_84 = trunc i16 %empty to i13
  %empty_85 = call i13 @_ssdm_op_PartSelect.i13.i16.i32.i32(i16 %empty_83, i32 3, i32 15)
  %empty_86 = or i13 %empty_84, %empty_85
  %empty_87 = call i16 @_ssdm_op_PartSet.i16.i16.i13.i32.i32(i16 %empty_83, i13 %empty_86, i32 3, i32 15)
  ret i16 %empty_87
}

; Function Attrs: nounwind readnone
define weak i13 @_ssdm_op_PartSelect.i13.i32.i32.i32(i32, i32, i32) #2 {
entry:
  %empty = call i32 @llvm.part.select.i32(i32 %0, i32 %1, i32 %2)
  %empty_88 = trunc i32 %empty to i13
  ret i13 %empty_88
}

; Function Attrs: nounwind readnone
define weak i3 @_ssdm_op_PartSelect.i3.i18.i32.i32(i18, i32, i32) #2 {
entry:
  %empty = call i18 @llvm.part.select.i18(i18 %0, i32 %1, i32 %2)
  %empty_89 = trunc i18 %empty to i3
  ret i3 %empty_89
}

define weak i16 @_ssdm_op_Read.ap_auto.i16(i16) {
entry:
  ret i16 %0
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i16.i32(i16, i32) #2 {
entry:
  %empty = trunc i32 %1 to i16
  %empty_90 = shl i16 1, %empty
  %empty_91 = and i16 %0, %empty_90
  %empty_92 = icmp ne i16 %empty_91, 0
  ret i1 %empty_92
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i18.i32(i18, i32) #2 {
entry:
  %empty = trunc i32 %1 to i18
  %empty_93 = shl i18 1, %empty
  %empty_94 = and i18 %0, %empty_93
  %empty_95 = icmp ne i18 %empty_94, 0
  ret i1 %empty_95
}

; Function Attrs: nounwind readnone
declare i27 @llvm.part.select.i27(i27, i32, i32) #2

; Function Attrs: nounwind readnone
declare i29 @llvm.part.select.i29(i29, i32, i32) #2

; Function Attrs: nounwind readnone
declare i26 @llvm.part.select.i26(i26, i32, i32) #2

; Function Attrs: nounwind readnone
declare i38 @llvm.part.select.i38(i38, i32, i32) #2

; Function Attrs: nounwind readnone
declare i32 @llvm.part.select.i32(i32, i32, i32) #2

; Function Attrs: nounwind readnone
declare i15 @llvm.part.select.i15(i15, i32, i32) #2

; Function Attrs: nounwind readnone
declare i18 @llvm.part.select.i18(i18, i32, i32) #2

; Function Attrs: nounwind readnone
declare i16 @_ssdm_op_PartSelect.i16.i18.i32.i32(i18, i32, i32) #2

; Function Attrs: nounwind readnone
declare i14 @_ssdm_op_PartSelect.i14.i16.i32.i32(i16, i32, i32) #2

; Function Attrs: nounwind readnone
declare i16 @_ssdm_op_BitConcatenate.i16.i14.i2(i14, i2) #2

; Function Attrs: nounwind readnone
define weak i32 @_ssdm_op_PartSet.i32.i32.i16.i32.i32(i32, i16, i32, i32) #2 {
entry:
  %empty = call i32 @llvm.part.set.i32.i16(i32 %0, i16 %1, i32 %2, i32 %3)
  ret i32 %empty
}

; Function Attrs: nounwind readnone
define weak i2 @_ssdm_op_PartSelect.i2.i5.i32.i32(i5, i32, i32) #2 {
entry:
  %empty = call i5 @llvm.part.select.i5(i5 %0, i32 %1, i32 %2)
  %empty_96 = trunc i5 %empty to i2
  ret i2 %empty_96
}

; Function Attrs: nounwind readnone
define weak i5 @_ssdm_op_PartSet.i5.i5.i2.i32.i32(i5, i2, i32, i32) #2 {
entry:
  %empty = call i5 @llvm.part.set.i5.i2(i5 %0, i2 %1, i32 %2, i32 %3)
  ret i5 %empty
}

; Function Attrs: nounwind readnone
declare i1 @_ssdm_op_PartSelect.i1.i4.i32.i32(i4, i32, i32) #2

; Function Attrs: nounwind readnone
define weak i4 @_ssdm_op_PartSet.i4.i4.i1.i32.i32(i4, i1, i32, i32) #2 {
entry:
  %empty = call i4 @llvm.part.set.i4.i1(i4 %0, i1 %1, i32 %2, i32 %3)
  ret i4 %empty
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i4.i32(i4, i32) #2 {
entry:
  %empty = trunc i32 %1 to i4
  %empty_97 = shl i4 1, %empty
  %empty_98 = and i4 %0, %empty_97
  %empty_99 = icmp ne i4 %empty_98, 0
  ret i1 %empty_99
}

; Function Attrs: nounwind readnone
define weak i4 @_ssdm_op_PartSelect.i4.i7.i32.i32(i7, i32, i32) #2 {
entry:
  %empty = call i7 @llvm.part.select.i7(i7 %0, i32 %1, i32 %2)
  %empty_100 = trunc i7 %empty to i4
  ret i4 %empty_100
}

; Function Attrs: nounwind readnone
define weak i7 @_ssdm_op_PartSet.i7.i7.i4.i32.i32(i7, i4, i32, i32) #2 {
entry:
  %empty = call i7 @llvm.part.set.i7.i4(i7 %0, i4 %1, i32 %2, i32 %3)
  ret i7 %empty
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i28.i32.i32(i28, i32, i32) #2 {
entry:
  %empty = call i28 @llvm.part.select.i28(i28 %0, i32 %1, i32 %2)
  %empty_101 = trunc i28 %empty to i16
  ret i16 %empty_101
}

; Function Attrs: nounwind readnone
define weak i28 @_ssdm_op_PartSet.i28.i28.i16.i32.i32(i28, i16, i32, i32) #2 {
entry:
  %empty = call i28 @llvm.part.set.i28.i16(i28 %0, i16 %1, i32 %2, i32 %3)
  ret i28 %empty
}

; Function Attrs: nounwind readnone
define weak i13 @_ssdm_op_PartSelect.i13.i16.i32.i32(i16, i32, i32) #2 {
entry:
  %empty = call i16 @llvm.part.select.i16(i16 %0, i32 %1, i32 %2)
  %empty_102 = trunc i16 %empty to i13
  ret i13 %empty_102
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSet.i16.i16.i13.i32.i32(i16, i13, i32, i32) #2 {
entry:
  %empty = call i16 @llvm.part.set.i16.i13(i16 %0, i13 %1, i32 %2, i32 %3)
  ret i16 %empty
}

; Function Attrs: nounwind readnone
declare i32 @llvm.part.set.i32.i16(i32, i16, i32, i32) #2

; Function Attrs: nounwind readnone
declare i5 @llvm.part.select.i5(i5, i32, i32) #2

; Function Attrs: nounwind readnone
declare i5 @llvm.part.set.i5.i2(i5, i2, i32, i32) #2

; Function Attrs: nounwind readnone
declare i4 @llvm.part.set.i4.i1(i4, i1, i32, i32) #2

; Function Attrs: nounwind readnone
declare i7 @llvm.part.select.i7(i7, i32, i32) #2

; Function Attrs: nounwind readnone
declare i7 @llvm.part.set.i7.i4(i7, i4, i32, i32) #2

; Function Attrs: nounwind readnone
declare i28 @llvm.part.select.i28(i28, i32, i32) #2

; Function Attrs: nounwind readnone
declare i28 @llvm.part.set.i28.i16(i28, i16, i32, i32) #2

; Function Attrs: nounwind readnone
declare i16 @llvm.part.select.i16(i16, i32, i32) #2

; Function Attrs: nounwind readnone
declare i16 @llvm.part.set.i16.i13(i16, i13, i32, i32) #2

attributes #0 = { nounwind }
attributes #1 = { nounwind uwtable }
attributes #2 = { nounwind readnone }


!7 = metadata !{metadata !8}
!8 = metadata !{i32 0, i32 15, metadata !9}
!9 = metadata !{metadata !10}
!10 = metadata !{metadata !"ret", metadata !11, metadata !"short"}
!11 = metadata !{metadata !12, metadata !12}
!12 = metadata !{i32 0, i32 7, i32 1}
!13 = metadata !{metadata !14}
!14 = metadata !{i32 0, i32 15, metadata !15}
!15 = metadata !{metadata !16}
!16 = metadata !{metadata !"R", metadata !11, metadata !"short"}
!17 = metadata !{metadata !18}
!18 = metadata !{i32 0, i32 15, metadata !19}
!19 = metadata !{metadata !20}
!20 = metadata !{metadata !"G", metadata !11, metadata !"short"}
!21 = metadata !{metadata !22}
!22 = metadata !{i32 0, i32 15, metadata !23}
!23 = metadata !{metadata !24}
!24 = metadata !{metadata !"B", metadata !11, metadata !"short"}
!25 = metadata !{metadata !26}
!26 = metadata !{i32 0, i32 15, metadata !27}
!27 = metadata !{metadata !28}
!28 = metadata !{metadata !"tmp", metadata !11, metadata !"short"}
!29 = metadata !{metadata !30}
!30 = metadata !{i32 0, i32 15, metadata !31}
!31 = metadata !{metadata !32}
!32 = metadata !{metadata !"sqrt_t", metadata !33, metadata !"short"}
!33 = metadata !{metadata !34}
!34 = metadata !{i32 0, i32 31, i32 1}
!35 = metadata !{metadata !36}
!36 = metadata !{i32 0, i32 15, metadata !37}
!37 = metadata !{metadata !38}
!38 = metadata !{metadata !"exp_t", metadata !39, metadata !"short"}
!39 = metadata !{metadata !40}
!40 = metadata !{i32 0, i32 63, i32 1}
!41 = metadata !{metadata !42}
!42 = metadata !{i32 0, i32 15, metadata !43}
!43 = metadata !{metadata !44}
!44 = metadata !{metadata !"row", metadata !45, metadata !"short"}
!45 = metadata !{metadata !46}
!46 = metadata !{i32 0, i32 0, i32 0}
!47 = metadata !{metadata !48}
!48 = metadata !{i32 0, i32 15, metadata !49}
!49 = metadata !{metadata !50}
!50 = metadata !{metadata !"col", metadata !45, metadata !"short"}
