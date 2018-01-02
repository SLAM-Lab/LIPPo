; ModuleID = 'a.o.3.bc'
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@p_str = private unnamed_addr constant [36 x i8] c"apply_fixed_bilateral_filter_label0\00", align 1
@p_str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@str = internal constant [29 x i8] c"apply_fixed_bilateral_filter\00"
@neighbour_x_table = internal unnamed_addr constant [24 x i3] [i3 0, i3 0, i3 0, i3 0, i3 0, i3 1, i3 1, i3 1, i3 1, i3 1, i3 2, i3 2, i3 2, i3 2, i3 3, i3 3, i3 3, i3 3, i3 3, i3 -4, i3 -4, i3 -4, i3 -4, i3 -4]
@neighbour_y_table = internal unnamed_addr constant [24 x i3] [i3 0, i3 1, i3 2, i3 3, i3 -4, i3 0, i3 1, i3 2, i3 3, i3 -4, i3 0, i3 1, i3 3, i3 -4, i3 0, i3 1, i3 2, i3 3, i3 -4, i3 0, i3 1, i3 2, i3 3, i3 -4]

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

define weak void @_ssdm_op_SpecBitsMap(...) {
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

; Function Attrs: nounwind readonly uwtable
define zeroext i8 @apply_fixed_bilateral_filter([25 x i8]* %source1, [25 x i8]* %source2, i32 %sigma_i, i32 %sigma_s, [1024 x i16]* %div, i8 zeroext %point) #1 {
  call void (...)* @_ssdm_op_SpecBitsMap([25 x i8]* %source1) #0, !map !7
  call void (...)* @_ssdm_op_SpecBitsMap([25 x i8]* %source2) #0, !map !13
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %sigma_i) #0, !map !17
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %sigma_s) #0, !map !23
  call void (...)* @_ssdm_op_SpecBitsMap([1024 x i16]* %div) #0, !map !27
  call void (...)* @_ssdm_op_SpecBitsMap(i8 %point) #0, !map !33
  call void (...)* @_ssdm_op_SpecBitsMap(i8 0) #0, !map !37
  call void (...)* @_ssdm_op_SpecTopModule([29 x i8]* @str) #0
  %point_read = call i8 @_ssdm_op_Read.ap_auto.i8(i8 %point) #0
  %sigma_s_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %sigma_s) #0
  %sigma_i_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %sigma_i) #0
  %i_filtered = call i24 @_ssdm_op_BitConcatenate.i24.i8.i16(i8 %point_read, i16 0)
  %i_filtered_cast = zext i24 %i_filtered to i31
  %tmp_2_cast = zext i8 %point_read to i9
  %tmp = trunc i32 %sigma_i_read to i31
  %tmp_7 = call i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31 %tmp, i1 true)
  %tmp_2 = trunc i32 %sigma_s_read to i31
  %tmp_5 = call i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31 %tmp_2, i1 true)
  br label %1

; <label>:1                                       ; preds = %_ifconv, %0
  %Wp = phi i23 [ 65536, %0 ], [ %Wp_1, %_ifconv ]
  %i_filtered1 = phi i31 [ %i_filtered_cast, %0 ], [ %i_filtered_1, %_ifconv ]
  %k = phi i5 [ 0, %0 ], [ %k_1, %_ifconv ]
  %tmp_3 = icmp ult i5 %k, -8
  br i1 %tmp_3, label %_ifconv, label %2

_ifconv:                                          ; preds = %1
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 12, i64 12, i64 12) #0
  call void (...)* @_ssdm_op_SpecLoopName([36 x i8]* @p_str) #0
  %tmp_9 = call i32 (...)* @_ssdm_op_SpecRegionBegin([36 x i8]* @p_str) #0
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str1) #0
  %tmp_4 = zext i5 %k to i64
  %neighbour_x_table_addr = getelementptr [24 x i3]* @neighbour_x_table, i64 0, i64 %tmp_4
  %neighbour_x = load i3* %neighbour_x_table_addr, align 2
  %neighbour_y_table_addr = getelementptr [24 x i3]* @neighbour_y_table, i64 0, i64 %tmp_4
  %neighbour_y = load i3* %neighbour_y_table_addr, align 2
  %tmp_6_trn_cast = zext i3 %neighbour_x to i6
  %tmp_5_trn_cast = zext i3 %neighbour_y to i6
  %tmp_6 = call i5 @_ssdm_op_BitConcatenate.i5.i3.i2(i3 %neighbour_x, i2 0)
  %p_shl4_cast = zext i5 %tmp_6 to i6
  %p_addr = add i6 %p_shl4_cast, %tmp_6_trn_cast
  %p_addr1 = add i6 %p_addr, %tmp_5_trn_cast
  %tmp_8 = zext i6 %p_addr1 to i64
  %source1_addr = getelementptr [25 x i8]* %source1, i64 0, i64 %tmp_8
  %neighbour_point = load i8* %source1_addr, align 1
  %tmp_7_cast = zext i8 %neighbour_point to i9
  %diff_1 = sub i9 %tmp_7_cast, %tmp_2_cast
  %diff_4_cast = sext i9 %diff_1 to i16
  %tmp_s = mul i16 %diff_4_cast, %diff_4_cast
  %tmp_1 = call i32 @_ssdm_op_BitConcatenate.i32.i16.i16(i16 %tmp_s, i16 0)
  %x_assign_1 = lshr i32 %tmp_1, %tmp_7
  %t_1 = add i32 %x_assign_1, -408835
  %tmp_10 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_1, i32 31)
  %tmp_11 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_1, i32 31)
  %tmp_12 = select i1 %tmp_11, i17 -65536, i17 128
  %p_x_i_i1 = select i1 %tmp_10, i32 %x_assign_1, i32 %t_1
  %t_2 = add i32 %p_x_i_i1, -363409
  %tmp_13 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_2, i32 31)
  %y_cast_cast = select i1 %tmp_11, i17 256, i17 0
  %y = select i1 %tmp_13, i17 %tmp_12, i17 %y_cast_cast
  %x_assign_3 = select i1 %tmp_13, i32 %p_x_i_i1, i32 %t_2
  %t_3 = add i32 %x_assign_3, -181704
  %tmp_14 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_3, i32 31)
  %tmp_15 = call i13 @_ssdm_op_PartSelect.i13.i17.i32.i32(i17 %y, i32 4, i32 16)
  %tmp_16 = zext i13 %tmp_15 to i17
  %p_y_1_i_i1 = select i1 %tmp_14, i17 %y, i17 %tmp_16
  %p_1_i_i1 = select i1 %tmp_14, i32 %x_assign_3, i32 %t_3
  %t_4 = add i32 %p_1_i_i1, -90852
  %tmp_17 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_4, i32 31)
  %tmp_18 = call i15 @_ssdm_op_PartSelect.i15.i17.i32.i32(i17 %p_y_1_i_i1, i32 2, i32 16)
  %tmp_19 = zext i15 %tmp_18 to i17
  %y_1 = select i1 %tmp_17, i17 %p_y_1_i_i1, i17 %tmp_19
  %x_assign_6 = select i1 %tmp_17, i32 %p_1_i_i1, i32 %t_4
  %t_5 = add i32 %x_assign_6, -45426
  %tmp_20 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_5, i32 31)
  %tmp_23 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %y_1, i32 1, i32 16)
  %tmp_26 = zext i16 %tmp_23 to i17
  %p_y_3_i_i1 = select i1 %tmp_20, i17 %y_1, i17 %tmp_26
  %p_y_3_i_i1_cast = zext i17 %p_y_3_i_i1 to i18
  %p_3_i_i1 = select i1 %tmp_20, i32 %x_assign_6, i32 %t_5
  %t_6 = add i32 %p_3_i_i1, -26573
  %tmp_27 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_6, i32 31)
  %tmp_28 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %p_y_3_i_i1, i32 1, i32 16)
  %tmp_192_cast = zext i16 %tmp_28 to i18
  %y_2 = sub i18 %p_y_3_i_i1_cast, %tmp_192_cast
  %y_5_i_i1 = select i1 %tmp_27, i18 %p_y_3_i_i1_cast, i18 %y_2
  %y_5_i_i1_cast_cast = sext i18 %y_5_i_i1 to i19
  %p_5_i_i1 = select i1 %tmp_27, i32 %p_3_i_i1, i32 %t_6
  %t_7 = add i32 %p_5_i_i1, -14624
  %tmp_29 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_7, i32 31)
  %tmp_30 = call i16 @_ssdm_op_PartSelect.i16.i18.i32.i32(i18 %y_5_i_i1, i32 2, i32 17)
  %tmp_28_cast_cast = sext i16 %tmp_30 to i19
  %y_3 = sub i19 %y_5_i_i1_cast_cast, %tmp_28_cast_cast
  %y_6_i_i1 = select i1 %tmp_29, i19 %y_5_i_i1_cast_cast, i19 %y_3
  %y_6_i_i1_cast = sext i19 %y_6_i_i1 to i29
  %p_6_i_i1 = select i1 %tmp_29, i32 %p_5_i_i1, i32 %t_7
  %t_8 = add i32 %p_6_i_i1, -7719
  %tmp_31 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_8, i32 31)
  %tmp_32 = call i16 @_ssdm_op_PartSelect.i16.i19.i32.i32(i19 %y_6_i_i1, i32 3, i32 18)
  %tmp_30_cast_cast = sext i16 %tmp_32 to i29
  %y_4 = sub i29 %y_6_i_i1_cast, %tmp_30_cast_cast
  %y_7_i_i1 = select i1 %tmp_31, i29 %y_6_i_i1_cast, i29 %y_4
  %p_7_i_i1 = select i1 %tmp_31, i32 %p_6_i_i1, i32 %t_8
  %t_9 = add i32 %p_7_i_i1, -3973
  %tmp_33 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_9, i32 31)
  %tmp_34 = call i25 @_ssdm_op_PartSelect.i25.i29.i32.i32(i29 %y_7_i_i1, i32 4, i32 28)
  %tmp_32_cast_cast = sext i25 %tmp_34 to i29
  %y_5 = sub i29 %y_7_i_i1, %tmp_32_cast_cast
  %y_8_i_i1 = select i1 %tmp_33, i29 %y_7_i_i1, i29 %y_5
  %p_8_i_i1 = select i1 %tmp_33, i32 %p_7_i_i1, i32 %t_9
  %t_10 = add i32 %p_8_i_i1, -2017
  %tmp_35 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_10, i32 31)
  %tmp_36 = call i24 @_ssdm_op_PartSelect.i24.i29.i32.i32(i29 %y_8_i_i1, i32 5, i32 28)
  %tmp_34_cast_cast = sext i24 %tmp_36 to i29
  %y_6 = sub i29 %y_8_i_i1, %tmp_34_cast_cast
  %y_9_i_i1 = select i1 %tmp_35, i29 %y_8_i_i1, i29 %y_6
  %p_9_i_i1 = select i1 %tmp_35, i32 %p_8_i_i1, i32 %t_10
  %t_11 = add i32 %p_9_i_i1, -1016
  %tmp_37 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_11, i32 31)
  %tmp_38 = call i23 @_ssdm_op_PartSelect.i23.i29.i32.i32(i29 %y_9_i_i1, i32 6, i32 28)
  %tmp_36_cast_cast = sext i23 %tmp_38 to i29
  %y_7 = sub i29 %y_9_i_i1, %tmp_36_cast_cast
  %y_10_i_i1 = select i1 %tmp_37, i29 %y_9_i_i1, i29 %y_7
  %p_10_i_i1 = select i1 %tmp_37, i32 %p_9_i_i1, i32 %t_11
  %t_12 = add i32 %p_10_i_i1, -510
  %tmp_39 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_12, i32 31)
  %tmp_40 = call i22 @_ssdm_op_PartSelect.i22.i29.i32.i32(i29 %y_10_i_i1, i32 7, i32 28)
  %tmp_38_cast_cast = sext i22 %tmp_40 to i29
  %y_8 = sub i29 %y_10_i_i1, %tmp_38_cast_cast
  %y_11_i_i1 = select i1 %tmp_39, i29 %y_10_i_i1, i29 %y_8
  %p_11_i_i1 = select i1 %tmp_39, i32 %p_10_i_i1, i32 %t_12
  %tmp_41 = trunc i32 %p_11_i_i1 to i1
  %tmp_42 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 8)
  %tmp_43 = call i21 @_ssdm_op_PartSelect.i21.i29.i32.i32(i29 %y_11_i_i1, i32 8, i32 28)
  %tmp_41_cast_cast = sext i21 %tmp_43 to i29
  %y_9 = sub i29 %y_11_i_i1, %tmp_41_cast_cast
  %y_12_i_i1 = select i1 %tmp_42, i29 %y_9, i29 %y_11_i_i1
  %tmp_44 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 7)
  %tmp_45 = call i20 @_ssdm_op_PartSelect.i20.i29.i32.i32(i29 %y_12_i_i1, i32 9, i32 28)
  %tmp_44_cast_cast = sext i20 %tmp_45 to i29
  %y_10 = sub i29 %y_12_i_i1, %tmp_44_cast_cast
  %y_13_i_i1 = select i1 %tmp_44, i29 %y_10, i29 %y_12_i_i1
  %tmp_46 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 6)
  %tmp_47 = call i19 @_ssdm_op_PartSelect.i19.i29.i32.i32(i29 %y_13_i_i1, i32 10, i32 28)
  %tmp_47_cast_cast = sext i19 %tmp_47 to i29
  %y_11 = sub i29 %y_13_i_i1, %tmp_47_cast_cast
  %y_14_i_i1 = select i1 %tmp_46, i29 %y_11, i29 %y_13_i_i1
  %tmp_48 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 5)
  %tmp_49 = call i18 @_ssdm_op_PartSelect.i18.i29.i32.i32(i29 %y_14_i_i1, i32 11, i32 28)
  %tmp_50_cast_cast = sext i18 %tmp_49 to i29
  %y_12 = sub i29 %y_14_i_i1, %tmp_50_cast_cast
  %y_15_i_i1 = select i1 %tmp_48, i29 %y_12, i29 %y_14_i_i1
  %tmp_50 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 4)
  %tmp_51 = call i17 @_ssdm_op_PartSelect.i17.i29.i32.i32(i29 %y_15_i_i1, i32 12, i32 28)
  %tmp_53_cast_cast = sext i17 %tmp_51 to i29
  %y_13 = sub i29 %y_15_i_i1, %tmp_53_cast_cast
  %y_16_i_i1 = select i1 %tmp_50, i29 %y_13, i29 %y_15_i_i1
  %y_16_i_i1_cast = sext i29 %y_16_i_i1 to i30
  %tmp_52 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 3)
  %tmp_53 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %y_16_i_i1, i32 13, i32 28)
  %tmp_56_cast_cast = sext i16 %tmp_53 to i30
  %y_14 = sub i30 %y_16_i_i1_cast, %tmp_56_cast_cast
  %y_17_i_i1 = select i1 %tmp_52, i30 %y_14, i30 %y_16_i_i1_cast
  %tmp_54 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 2)
  %tmp_55 = call i16 @_ssdm_op_PartSelect.i16.i30.i32.i32(i30 %y_17_i_i1, i32 14, i32 29)
  %tmp_59_cast_cast = sext i16 %tmp_55 to i30
  %y_15 = sub i30 %y_17_i_i1, %tmp_59_cast_cast
  %y_18_i_i1 = select i1 %tmp_54, i30 %y_15, i30 %y_17_i_i1
  %tmp_56 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 1)
  %tmp_57 = call i15 @_ssdm_op_PartSelect.i15.i30.i32.i32(i30 %y_18_i_i1, i32 15, i32 29)
  %tmp_57_cast = sext i15 %tmp_57 to i30
  %y_16 = sub i30 %y_18_i_i1, %tmp_57_cast
  %y_19_i_i1 = select i1 %tmp_56, i30 %y_16, i30 %y_18_i_i1
  %tmp_58 = call i14 @_ssdm_op_PartSelect.i14.i30.i32.i32(i30 %y_19_i_i1, i32 16, i32 29)
  %tmp_59_cast = sext i14 %tmp_58 to i30
  %y_17 = sub i30 %y_19_i_i1, %tmp_59_cast
  %ret = select i1 %tmp_41, i30 %y_17, i30 %y_19_i_i1
  %tmp_59 = add i3 %neighbour_x, -2
  %tmp_60 = sext i3 %tmp_59 to i5
  %tmp_68_cast = mul i5 %tmp_60, %tmp_60
  %tmp_61 = add i3 %neighbour_y, -2
  %tmp_62 = sext i3 %tmp_61 to i5
  %tmp_71_cast = mul i5 %tmp_62, %tmp_62
  %tmp_i1 = add i5 %tmp_71_cast, %tmp_68_cast
  %tmp_63 = call i21 @_ssdm_op_BitConcatenate.i21.i5.i16(i5 %tmp_i1, i16 0)
  %diff = sext i21 %tmp_63 to i32
  %x_assign_s = lshr i32 %diff, %tmp_5
  %t_13 = add i32 %x_assign_s, -408835
  %tmp_64 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_13, i32 31)
  %tmp_65 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_13, i32 31)
  %tmp_66 = select i1 %tmp_65, i17 -65536, i17 128
  %p_x_i_i2 = select i1 %tmp_64, i32 %x_assign_s, i32 %t_13
  %t_14 = add i32 %p_x_i_i2, -363409
  %tmp_67 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_14, i32 31)
  %y_22_cast_cast = select i1 %tmp_65, i17 256, i17 0
  %y_18 = select i1 %tmp_67, i17 %tmp_66, i17 %y_22_cast_cast
  %x_assign_4 = select i1 %tmp_67, i32 %p_x_i_i2, i32 %t_14
  %t_15 = add i32 %x_assign_4, -181704
  %tmp_68 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_15, i32 31)
  %tmp_69 = call i13 @_ssdm_op_PartSelect.i13.i17.i32.i32(i17 %y_18, i32 4, i32 16)
  %tmp_70 = zext i13 %tmp_69 to i17
  %p_y_1_i_i2 = select i1 %tmp_68, i17 %y_18, i17 %tmp_70
  %p_1_i_i2 = select i1 %tmp_68, i32 %x_assign_4, i32 %t_15
  %t = add i32 %p_1_i_i2, -90852
  %tmp_71 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t, i32 31)
  %tmp_72 = call i15 @_ssdm_op_PartSelect.i15.i17.i32.i32(i17 %p_y_1_i_i2, i32 2, i32 16)
  %tmp_73 = zext i15 %tmp_72 to i17
  %y_19 = select i1 %tmp_71, i17 %p_y_1_i_i2, i17 %tmp_73
  %x_assign_5 = select i1 %tmp_71, i32 %p_1_i_i2, i32 %t
  %t_16 = add i32 %x_assign_5, -45426
  %tmp_74 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_16, i32 31)
  %tmp_75 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %y_19, i32 1, i32 16)
  %tmp_76 = zext i16 %tmp_75 to i17
  %p_y_3_i_i2 = select i1 %tmp_74, i17 %y_19, i17 %tmp_76
  %p_y_3_i_i2_cast = zext i17 %p_y_3_i_i2 to i18
  %p_3_i_i2 = select i1 %tmp_74, i32 %x_assign_5, i32 %t_16
  %t_17 = add i32 %p_3_i_i2, -26573
  %tmp_77 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_17, i32 31)
  %tmp_78 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %p_y_3_i_i2, i32 1, i32 16)
  %tmp_283_cast = zext i16 %tmp_78 to i18
  %y_20 = sub i18 %p_y_3_i_i2_cast, %tmp_283_cast
  %y_5_i_i2 = select i1 %tmp_77, i18 %p_y_3_i_i2_cast, i18 %y_20
  %y_5_i_i2_cast_cast = sext i18 %y_5_i_i2 to i19
  %p_5_i_i2 = select i1 %tmp_77, i32 %p_3_i_i2, i32 %t_17
  %t_18 = add i32 %p_5_i_i2, -14624
  %tmp_79 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_18, i32 31)
  %tmp_80 = call i16 @_ssdm_op_PartSelect.i16.i18.i32.i32(i18 %y_5_i_i2, i32 2, i32 17)
  %tmp_85_cast_cast = sext i16 %tmp_80 to i19
  %y_21 = sub i19 %y_5_i_i2_cast_cast, %tmp_85_cast_cast
  %y_6_i_i2 = select i1 %tmp_79, i19 %y_5_i_i2_cast_cast, i19 %y_21
  %y_6_i_i2_cast = sext i19 %y_6_i_i2 to i29
  %p_6_i_i2 = select i1 %tmp_79, i32 %p_5_i_i2, i32 %t_18
  %t_19 = add i32 %p_6_i_i2, -7719
  %tmp_81 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_19, i32 31)
  %tmp_82 = call i16 @_ssdm_op_PartSelect.i16.i19.i32.i32(i19 %y_6_i_i2, i32 3, i32 18)
  %tmp_87_cast_cast = sext i16 %tmp_82 to i29
  %y_22 = sub i29 %y_6_i_i2_cast, %tmp_87_cast_cast
  %y_7_i_i2 = select i1 %tmp_81, i29 %y_6_i_i2_cast, i29 %y_22
  %p_7_i_i2 = select i1 %tmp_81, i32 %p_6_i_i2, i32 %t_19
  %t_20 = add i32 %p_7_i_i2, -3973
  %tmp_83 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_20, i32 31)
  %tmp_84 = call i25 @_ssdm_op_PartSelect.i25.i29.i32.i32(i29 %y_7_i_i2, i32 4, i32 28)
  %tmp_89_cast_cast = sext i25 %tmp_84 to i29
  %y_23 = sub i29 %y_7_i_i2, %tmp_89_cast_cast
  %y_8_i_i2 = select i1 %tmp_83, i29 %y_7_i_i2, i29 %y_23
  %p_8_i_i2 = select i1 %tmp_83, i32 %p_7_i_i2, i32 %t_20
  %t_21 = add i32 %p_8_i_i2, -2017
  %tmp_85 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_21, i32 31)
  %tmp_86 = call i24 @_ssdm_op_PartSelect.i24.i29.i32.i32(i29 %y_8_i_i2, i32 5, i32 28)
  %tmp_91_cast_cast = sext i24 %tmp_86 to i29
  %y_24 = sub i29 %y_8_i_i2, %tmp_91_cast_cast
  %y_9_i_i2 = select i1 %tmp_85, i29 %y_8_i_i2, i29 %y_24
  %p_9_i_i2 = select i1 %tmp_85, i32 %p_8_i_i2, i32 %t_21
  %t_22 = add i32 %p_9_i_i2, -1016
  %tmp_87 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_22, i32 31)
  %tmp_88 = call i23 @_ssdm_op_PartSelect.i23.i29.i32.i32(i29 %y_9_i_i2, i32 6, i32 28)
  %tmp_93_cast_cast = sext i23 %tmp_88 to i29
  %y_25 = sub i29 %y_9_i_i2, %tmp_93_cast_cast
  %y_10_i_i2 = select i1 %tmp_87, i29 %y_9_i_i2, i29 %y_25
  %p_10_i_i2 = select i1 %tmp_87, i32 %p_9_i_i2, i32 %t_22
  %t_23 = add i32 %p_10_i_i2, -510
  %tmp_89 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_23, i32 31)
  %tmp_90 = call i22 @_ssdm_op_PartSelect.i22.i29.i32.i32(i29 %y_10_i_i2, i32 7, i32 28)
  %tmp_95_cast_cast = sext i22 %tmp_90 to i29
  %y_26 = sub i29 %y_10_i_i2, %tmp_95_cast_cast
  %y_11_i_i2 = select i1 %tmp_89, i29 %y_10_i_i2, i29 %y_26
  %p_11_i_i2 = select i1 %tmp_89, i32 %p_10_i_i2, i32 %t_23
  %tmp_91 = trunc i32 %p_11_i_i2 to i1
  %tmp_92 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 8)
  %tmp_93 = call i21 @_ssdm_op_PartSelect.i21.i29.i32.i32(i29 %y_11_i_i2, i32 8, i32 28)
  %tmp_98_cast_cast = sext i21 %tmp_93 to i29
  %y_27 = sub i29 %y_11_i_i2, %tmp_98_cast_cast
  %y_12_i_i2 = select i1 %tmp_92, i29 %y_27, i29 %y_11_i_i2
  %tmp_94 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 7)
  %tmp_95 = call i20 @_ssdm_op_PartSelect.i20.i29.i32.i32(i29 %y_12_i_i2, i32 9, i32 28)
  %tmp_101_cast_cast = sext i20 %tmp_95 to i29
  %y_28 = sub i29 %y_12_i_i2, %tmp_101_cast_cast
  %y_13_i_i2 = select i1 %tmp_94, i29 %y_28, i29 %y_12_i_i2
  %tmp_96 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 6)
  %tmp_97 = call i19 @_ssdm_op_PartSelect.i19.i29.i32.i32(i29 %y_13_i_i2, i32 10, i32 28)
  %tmp_104_cast_cast = sext i19 %tmp_97 to i29
  %y_29 = sub i29 %y_13_i_i2, %tmp_104_cast_cast
  %y_14_i_i2 = select i1 %tmp_96, i29 %y_29, i29 %y_13_i_i2
  %tmp_98 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 5)
  %tmp_99 = call i18 @_ssdm_op_PartSelect.i18.i29.i32.i32(i29 %y_14_i_i2, i32 11, i32 28)
  %tmp_107_cast_cast = sext i18 %tmp_99 to i29
  %y_30 = sub i29 %y_14_i_i2, %tmp_107_cast_cast
  %y_15_i_i2 = select i1 %tmp_98, i29 %y_30, i29 %y_14_i_i2
  %tmp_100 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 4)
  %tmp_101 = call i17 @_ssdm_op_PartSelect.i17.i29.i32.i32(i29 %y_15_i_i2, i32 12, i32 28)
  %tmp_110_cast_cast = sext i17 %tmp_101 to i29
  %y_31 = sub i29 %y_15_i_i2, %tmp_110_cast_cast
  %y_16_i_i2 = select i1 %tmp_100, i29 %y_31, i29 %y_15_i_i2
  %y_16_i_i2_cast = sext i29 %y_16_i_i2 to i30
  %tmp_102 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 3)
  %tmp_103 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %y_16_i_i2, i32 13, i32 28)
  %tmp_113_cast_cast = sext i16 %tmp_103 to i30
  %y_32 = sub i30 %y_16_i_i2_cast, %tmp_113_cast_cast
  %y_17_i_i2 = select i1 %tmp_102, i30 %y_32, i30 %y_16_i_i2_cast
  %tmp_104 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 2)
  %tmp_105 = call i16 @_ssdm_op_PartSelect.i16.i30.i32.i32(i30 %y_17_i_i2, i32 14, i32 29)
  %tmp_116_cast_cast = sext i16 %tmp_105 to i30
  %y_33 = sub i30 %y_17_i_i2, %tmp_116_cast_cast
  %y_18_i_i2 = select i1 %tmp_104, i30 %y_33, i30 %y_17_i_i2
  %tmp_106 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 1)
  %tmp_107 = call i15 @_ssdm_op_PartSelect.i15.i30.i32.i32(i30 %y_18_i_i2, i32 15, i32 29)
  %tmp_108_cast = sext i15 %tmp_107 to i30
  %y_34 = sub i30 %y_18_i_i2, %tmp_108_cast
  %y_19_i_i2 = select i1 %tmp_106, i30 %y_34, i30 %y_18_i_i2
  %tmp_108 = call i14 @_ssdm_op_PartSelect.i14.i30.i32.i32(i30 %y_19_i_i2, i32 16, i32 29)
  %tmp_110_cast = sext i14 %tmp_108 to i30
  %y_35 = sub i30 %y_19_i_i2, %tmp_110_cast
  %ret_1 = select i1 %tmp_91, i30 %y_35, i30 %y_19_i_i2
  %tmp_109 = call i29 @_ssdm_op_PartSelect.i29.i30.i32.i32(i30 %ret, i32 1, i32 29)
  %tmp_110 = sext i29 %tmp_109 to i31
  %tmp_111 = zext i31 %tmp_110 to i32
  %tmp_112 = call i29 @_ssdm_op_PartSelect.i29.i30.i32.i32(i30 %ret_1, i32 1, i32 29)
  %tmp_113 = sext i29 %tmp_112 to i31
  %tmp_114 = zext i31 %tmp_113 to i32
  %tmp_115 = mul i32 %tmp_114, %tmp_111
  %tmp_116 = call i18 @_ssdm_op_PartSelect.i18.i32.i32.i32(i32 %tmp_115, i32 14, i32 31)
  %w_cast1 = zext i18 %tmp_116 to i19
  %w_cast = zext i18 %tmp_116 to i26
  %tmp_126_cast = zext i8 %neighbour_point to i26
  %tmp_117 = mul i26 %w_cast, %tmp_126_cast
  %tmp_127_cast = zext i26 %tmp_117 to i27
  %tmp_118 = call i4 @_ssdm_op_PartSelect.i4.i5.i32.i32(i5 %k, i32 1, i32 4)
  %tmp_119 = call i5 @_ssdm_op_BitConcatenate.i5.i4.i1(i4 %tmp_118, i1 true)
  %tmp_120 = zext i5 %tmp_119 to i64
  %neighbour_x_table_addr_1 = getelementptr [24 x i3]* @neighbour_x_table, i64 0, i64 %tmp_120
  %neighbour_x_1 = load i3* %neighbour_x_table_addr_1, align 1
  %neighbour_y_table_addr_1 = getelementptr [24 x i3]* @neighbour_y_table, i64 0, i64 %tmp_120
  %neighbour_y_1 = load i3* %neighbour_y_table_addr_1, align 1
  %tmp_131_trn_cast = zext i3 %neighbour_x_1 to i6
  %tmp_130_trn_cast = zext i3 %neighbour_y_1 to i6
  %tmp_121 = call i5 @_ssdm_op_BitConcatenate.i5.i3.i2(i3 %neighbour_x_1, i2 0)
  %p_shl_cast = zext i5 %tmp_121 to i6
  %p_addr2 = add i6 %p_shl_cast, %tmp_131_trn_cast
  %p_addr3 = add i6 %p_addr2, %tmp_130_trn_cast
  %tmp_122 = zext i6 %p_addr3 to i64
  %source2_addr = getelementptr [25 x i8]* %source2, i64 0, i64 %tmp_122
  %neighbour_point_1 = load i8* %source2_addr, align 1
  %tmp_132_cast = zext i8 %neighbour_point_1 to i9
  %diff_3 = sub i9 %tmp_132_cast, %tmp_2_cast
  %diff_5_cast = sext i9 %diff_3 to i16
  %tmp_123 = mul i16 %diff_5_cast, %diff_5_cast
  %tmp_124 = call i32 @_ssdm_op_BitConcatenate.i32.i16.i16(i16 %tmp_123, i16 0)
  %x_assign_8 = lshr i32 %tmp_124, %tmp_7
  %t_24 = add i32 %x_assign_8, -408835
  %tmp_125 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_24, i32 31)
  %tmp_126 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_24, i32 31)
  %tmp_127 = select i1 %tmp_126, i17 -65536, i17 128
  %p_x_i_i = select i1 %tmp_125, i32 %x_assign_8, i32 %t_24
  %t_25 = add i32 %p_x_i_i, -363409
  %tmp_128 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_25, i32 31)
  %y_44_cast_cast = select i1 %tmp_126, i17 256, i17 0
  %y_36 = select i1 %tmp_128, i17 %tmp_127, i17 %y_44_cast_cast
  %x_assign_2 = select i1 %tmp_128, i32 %p_x_i_i, i32 %t_25
  %t_26 = add i32 %x_assign_2, -181704
  %tmp_129 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_26, i32 31)
  %tmp_130 = call i13 @_ssdm_op_PartSelect.i13.i17.i32.i32(i17 %y_36, i32 4, i32 16)
  %tmp_131 = zext i13 %tmp_130 to i17
  %p_y_1_i_i = select i1 %tmp_129, i17 %y_36, i17 %tmp_131
  %p_1_i_i = select i1 %tmp_129, i32 %x_assign_2, i32 %t_26
  %t_27 = add i32 %p_1_i_i, -90852
  %tmp_132 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_27, i32 31)
  %tmp_133 = call i15 @_ssdm_op_PartSelect.i15.i17.i32.i32(i17 %p_y_1_i_i, i32 2, i32 16)
  %tmp_134 = zext i15 %tmp_133 to i17
  %y_37 = select i1 %tmp_132, i17 %p_y_1_i_i, i17 %tmp_134
  %x_assign_7 = select i1 %tmp_132, i32 %p_1_i_i, i32 %t_27
  %t_28 = add i32 %x_assign_7, -45426
  %tmp_135 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_28, i32 31)
  %tmp_136 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %y_37, i32 1, i32 16)
  %tmp_137 = zext i16 %tmp_136 to i17
  %p_y_3_i_i = select i1 %tmp_135, i17 %y_37, i17 %tmp_137
  %p_y_3_i_i_cast = zext i17 %p_y_3_i_i to i18
  %p_3_i_i = select i1 %tmp_135, i32 %x_assign_7, i32 %t_28
  %t_29 = add i32 %p_3_i_i, -26573
  %tmp_138 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_29, i32 31)
  %tmp_139 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %p_y_3_i_i, i32 1, i32 16)
  %tmp_326_cast = zext i16 %tmp_139 to i18
  %y_38 = sub i18 %p_y_3_i_i_cast, %tmp_326_cast
  %y_5_i_i = select i1 %tmp_138, i18 %p_y_3_i_i_cast, i18 %y_38
  %y_5_i_i_cast_cast = sext i18 %y_5_i_i to i19
  %p_5_i_i = select i1 %tmp_138, i32 %p_3_i_i, i32 %t_29
  %t_30 = add i32 %p_5_i_i, -14624
  %tmp_140 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_30, i32 31)
  %tmp_141 = call i16 @_ssdm_op_PartSelect.i16.i18.i32.i32(i18 %y_5_i_i, i32 2, i32 17)
  %tmp_147_cast_cast = sext i16 %tmp_141 to i19
  %y_39 = sub i19 %y_5_i_i_cast_cast, %tmp_147_cast_cast
  %y_6_i_i = select i1 %tmp_140, i19 %y_5_i_i_cast_cast, i19 %y_39
  %y_6_i_i_cast = sext i19 %y_6_i_i to i29
  %p_6_i_i = select i1 %tmp_140, i32 %p_5_i_i, i32 %t_30
  %t_31 = add i32 %p_6_i_i, -7719
  %tmp_142 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_31, i32 31)
  %tmp_143 = call i16 @_ssdm_op_PartSelect.i16.i19.i32.i32(i19 %y_6_i_i, i32 3, i32 18)
  %tmp_149_cast_cast = sext i16 %tmp_143 to i29
  %y_40 = sub i29 %y_6_i_i_cast, %tmp_149_cast_cast
  %y_7_i_i = select i1 %tmp_142, i29 %y_6_i_i_cast, i29 %y_40
  %p_7_i_i = select i1 %tmp_142, i32 %p_6_i_i, i32 %t_31
  %t_32 = add i32 %p_7_i_i, -3973
  %tmp_144 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_32, i32 31)
  %tmp_145 = call i25 @_ssdm_op_PartSelect.i25.i29.i32.i32(i29 %y_7_i_i, i32 4, i32 28)
  %tmp_151_cast_cast = sext i25 %tmp_145 to i29
  %y_41 = sub i29 %y_7_i_i, %tmp_151_cast_cast
  %y_8_i_i = select i1 %tmp_144, i29 %y_7_i_i, i29 %y_41
  %p_8_i_i = select i1 %tmp_144, i32 %p_7_i_i, i32 %t_32
  %t_33 = add i32 %p_8_i_i, -2017
  %tmp_146 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_33, i32 31)
  %tmp_147 = call i24 @_ssdm_op_PartSelect.i24.i29.i32.i32(i29 %y_8_i_i, i32 5, i32 28)
  %tmp_153_cast_cast = sext i24 %tmp_147 to i29
  %y_42 = sub i29 %y_8_i_i, %tmp_153_cast_cast
  %y_9_i_i = select i1 %tmp_146, i29 %y_8_i_i, i29 %y_42
  %p_9_i_i = select i1 %tmp_146, i32 %p_8_i_i, i32 %t_33
  %t_34 = add i32 %p_9_i_i, -1016
  %tmp_148 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_34, i32 31)
  %tmp_149 = call i23 @_ssdm_op_PartSelect.i23.i29.i32.i32(i29 %y_9_i_i, i32 6, i32 28)
  %tmp_155_cast_cast = sext i23 %tmp_149 to i29
  %y_43 = sub i29 %y_9_i_i, %tmp_155_cast_cast
  %y_10_i_i = select i1 %tmp_148, i29 %y_9_i_i, i29 %y_43
  %p_10_i_i = select i1 %tmp_148, i32 %p_9_i_i, i32 %t_34
  %t_35 = add i32 %p_10_i_i, -510
  %tmp_150 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_35, i32 31)
  %tmp_151 = call i22 @_ssdm_op_PartSelect.i22.i29.i32.i32(i29 %y_10_i_i, i32 7, i32 28)
  %tmp_157_cast_cast = sext i22 %tmp_151 to i29
  %y_44 = sub i29 %y_10_i_i, %tmp_157_cast_cast
  %y_11_i_i = select i1 %tmp_150, i29 %y_10_i_i, i29 %y_44
  %p_11_i_i = select i1 %tmp_150, i32 %p_10_i_i, i32 %t_35
  %tmp_152 = trunc i32 %p_11_i_i to i1
  %tmp_153 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 8)
  %tmp_154 = call i21 @_ssdm_op_PartSelect.i21.i29.i32.i32(i29 %y_11_i_i, i32 8, i32 28)
  %tmp_160_cast_cast = sext i21 %tmp_154 to i29
  %y_45 = sub i29 %y_11_i_i, %tmp_160_cast_cast
  %y_12_i_i = select i1 %tmp_153, i29 %y_45, i29 %y_11_i_i
  %tmp_155 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 7)
  %tmp_156 = call i20 @_ssdm_op_PartSelect.i20.i29.i32.i32(i29 %y_12_i_i, i32 9, i32 28)
  %tmp_163_cast_cast = sext i20 %tmp_156 to i29
  %y_46 = sub i29 %y_12_i_i, %tmp_163_cast_cast
  %y_13_i_i = select i1 %tmp_155, i29 %y_46, i29 %y_12_i_i
  %tmp_157 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 6)
  %tmp_158 = call i19 @_ssdm_op_PartSelect.i19.i29.i32.i32(i29 %y_13_i_i, i32 10, i32 28)
  %tmp_166_cast_cast = sext i19 %tmp_158 to i29
  %y_47 = sub i29 %y_13_i_i, %tmp_166_cast_cast
  %y_14_i_i = select i1 %tmp_157, i29 %y_47, i29 %y_13_i_i
  %tmp_159 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 5)
  %tmp_160 = call i18 @_ssdm_op_PartSelect.i18.i29.i32.i32(i29 %y_14_i_i, i32 11, i32 28)
  %tmp_169_cast_cast = sext i18 %tmp_160 to i29
  %y_48 = sub i29 %y_14_i_i, %tmp_169_cast_cast
  %y_15_i_i = select i1 %tmp_159, i29 %y_48, i29 %y_14_i_i
  %tmp_161 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 4)
  %tmp_162 = call i17 @_ssdm_op_PartSelect.i17.i29.i32.i32(i29 %y_15_i_i, i32 12, i32 28)
  %tmp_172_cast_cast = sext i17 %tmp_162 to i29
  %y_49 = sub i29 %y_15_i_i, %tmp_172_cast_cast
  %y_16_i_i = select i1 %tmp_161, i29 %y_49, i29 %y_15_i_i
  %y_16_i_i_cast = sext i29 %y_16_i_i to i30
  %tmp_163 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 3)
  %tmp_164 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %y_16_i_i, i32 13, i32 28)
  %tmp_175_cast_cast = sext i16 %tmp_164 to i30
  %y_50 = sub i30 %y_16_i_i_cast, %tmp_175_cast_cast
  %y_17_i_i = select i1 %tmp_163, i30 %y_50, i30 %y_16_i_i_cast
  %tmp_165 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 2)
  %tmp_166 = call i16 @_ssdm_op_PartSelect.i16.i30.i32.i32(i30 %y_17_i_i, i32 14, i32 29)
  %tmp_178_cast_cast = sext i16 %tmp_166 to i30
  %y_51 = sub i30 %y_17_i_i, %tmp_178_cast_cast
  %y_18_i_i = select i1 %tmp_165, i30 %y_51, i30 %y_17_i_i
  %tmp_167 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 1)
  %tmp_168 = call i15 @_ssdm_op_PartSelect.i15.i30.i32.i32(i30 %y_18_i_i, i32 15, i32 29)
  %tmp_169_cast8 = sext i15 %tmp_168 to i30
  %y_52 = sub i30 %y_18_i_i, %tmp_169_cast8
  %y_19_i_i = select i1 %tmp_167, i30 %y_52, i30 %y_18_i_i
  %tmp_169 = call i14 @_ssdm_op_PartSelect.i14.i30.i32.i32(i30 %y_19_i_i, i32 16, i32 29)
  %tmp_171_cast = sext i14 %tmp_169 to i30
  %y_53 = sub i30 %y_19_i_i, %tmp_171_cast
  %ret_2 = select i1 %tmp_152, i30 %y_53, i30 %y_19_i_i
  %tmp_170 = add i3 %neighbour_x_1, -2
  %tmp_171 = sext i3 %tmp_170 to i5
  %tmp_187_cast = mul i5 %tmp_171, %tmp_171
  %tmp_172 = add i3 %neighbour_y_1, -2
  %tmp_173 = sext i3 %tmp_172 to i5
  %tmp_190_cast = mul i5 %tmp_173, %tmp_173
  %tmp_i = add i5 %tmp_190_cast, %tmp_187_cast
  %tmp_174 = call i21 @_ssdm_op_BitConcatenate.i21.i5.i16(i5 %tmp_i, i16 0)
  %diff_2 = sext i21 %tmp_174 to i32
  %x_assign_9 = lshr i32 %diff_2, %tmp_5
  %t_36 = add i32 %x_assign_9, -408835
  %tmp_175 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_36, i32 31)
  %tmp_176 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_36, i32 31)
  %tmp_177 = select i1 %tmp_176, i17 -65536, i17 128
  %p_x_i_i3 = select i1 %tmp_175, i32 %x_assign_9, i32 %t_36
  %t_37 = add i32 %p_x_i_i3, -363409
  %tmp_178 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_37, i32 31)
  %y_66_cast_cast = select i1 %tmp_176, i17 256, i17 0
  %y_54 = select i1 %tmp_178, i17 %tmp_177, i17 %y_66_cast_cast
  %x_assign_10 = select i1 %tmp_178, i32 %p_x_i_i3, i32 %t_37
  %t_38 = add i32 %x_assign_10, -181704
  %tmp_179 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_38, i32 31)
  %tmp_180 = call i13 @_ssdm_op_PartSelect.i13.i17.i32.i32(i17 %y_54, i32 4, i32 16)
  %tmp_181 = zext i13 %tmp_180 to i17
  %p_y_1_i_i3 = select i1 %tmp_179, i17 %y_54, i17 %tmp_181
  %p_1_i_i3 = select i1 %tmp_179, i32 %x_assign_10, i32 %t_38
  %t_39 = add i32 %p_1_i_i3, -90852
  %tmp_182 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_39, i32 31)
  %tmp_183 = call i15 @_ssdm_op_PartSelect.i15.i17.i32.i32(i17 %p_y_1_i_i3, i32 2, i32 16)
  %tmp_184 = zext i15 %tmp_183 to i17
  %y_55 = select i1 %tmp_182, i17 %p_y_1_i_i3, i17 %tmp_184
  %x_assign_11 = select i1 %tmp_182, i32 %p_1_i_i3, i32 %t_39
  %t_40 = add i32 %x_assign_11, -45426
  %tmp_185 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_40, i32 31)
  %tmp_186 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %y_55, i32 1, i32 16)
  %tmp_187 = zext i16 %tmp_186 to i17
  %p_y_3_i_i3 = select i1 %tmp_185, i17 %y_55, i17 %tmp_187
  %p_y_3_i_i3_cast = zext i17 %p_y_3_i_i3 to i18
  %p_3_i_i3 = select i1 %tmp_185, i32 %x_assign_11, i32 %t_40
  %t_41 = add i32 %p_3_i_i3, -26573
  %tmp_188 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_41, i32 31)
  %tmp_189 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %p_y_3_i_i3, i32 1, i32 16)
  %tmp_367_cast = zext i16 %tmp_189 to i18
  %y_56 = sub i18 %p_y_3_i_i3_cast, %tmp_367_cast
  %y_5_i_i3 = select i1 %tmp_188, i18 %p_y_3_i_i3_cast, i18 %y_56
  %y_5_i_i3_cast_cast = sext i18 %y_5_i_i3 to i19
  %p_5_i_i3 = select i1 %tmp_188, i32 %p_3_i_i3, i32 %t_41
  %t_42 = add i32 %p_5_i_i3, -14624
  %tmp_190 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_42, i32 31)
  %tmp_191 = call i16 @_ssdm_op_PartSelect.i16.i18.i32.i32(i18 %y_5_i_i3, i32 2, i32 17)
  %tmp_202_cast_cast = sext i16 %tmp_191 to i19
  %y_57 = sub i19 %y_5_i_i3_cast_cast, %tmp_202_cast_cast
  %y_6_i_i3 = select i1 %tmp_190, i19 %y_5_i_i3_cast_cast, i19 %y_57
  %y_6_i_i3_cast = sext i19 %y_6_i_i3 to i29
  %p_6_i_i3 = select i1 %tmp_190, i32 %p_5_i_i3, i32 %t_42
  %t_43 = add i32 %p_6_i_i3, -7719
  %tmp_192 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_43, i32 31)
  %tmp_193 = call i16 @_ssdm_op_PartSelect.i16.i19.i32.i32(i19 %y_6_i_i3, i32 3, i32 18)
  %tmp_204_cast_cast = sext i16 %tmp_193 to i29
  %y_58 = sub i29 %y_6_i_i3_cast, %tmp_204_cast_cast
  %y_7_i_i3 = select i1 %tmp_192, i29 %y_6_i_i3_cast, i29 %y_58
  %p_7_i_i3 = select i1 %tmp_192, i32 %p_6_i_i3, i32 %t_43
  %t_44 = add i32 %p_7_i_i3, -3973
  %tmp_194 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_44, i32 31)
  %tmp_195 = call i25 @_ssdm_op_PartSelect.i25.i29.i32.i32(i29 %y_7_i_i3, i32 4, i32 28)
  %tmp_206_cast_cast = sext i25 %tmp_195 to i29
  %y_59 = sub i29 %y_7_i_i3, %tmp_206_cast_cast
  %y_8_i_i3 = select i1 %tmp_194, i29 %y_7_i_i3, i29 %y_59
  %p_8_i_i3 = select i1 %tmp_194, i32 %p_7_i_i3, i32 %t_44
  %t_45 = add i32 %p_8_i_i3, -2017
  %tmp_196 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_45, i32 31)
  %tmp_197 = call i24 @_ssdm_op_PartSelect.i24.i29.i32.i32(i29 %y_8_i_i3, i32 5, i32 28)
  %tmp_208_cast_cast = sext i24 %tmp_197 to i29
  %y_60 = sub i29 %y_8_i_i3, %tmp_208_cast_cast
  %y_9_i_i3 = select i1 %tmp_196, i29 %y_8_i_i3, i29 %y_60
  %p_9_i_i3 = select i1 %tmp_196, i32 %p_8_i_i3, i32 %t_45
  %t_46 = add i32 %p_9_i_i3, -1016
  %tmp_198 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_46, i32 31)
  %tmp_199 = call i23 @_ssdm_op_PartSelect.i23.i29.i32.i32(i29 %y_9_i_i3, i32 6, i32 28)
  %tmp_210_cast_cast = sext i23 %tmp_199 to i29
  %y_61 = sub i29 %y_9_i_i3, %tmp_210_cast_cast
  %y_10_i_i3 = select i1 %tmp_198, i29 %y_9_i_i3, i29 %y_61
  %p_10_i_i3 = select i1 %tmp_198, i32 %p_9_i_i3, i32 %t_46
  %t_47 = add i32 %p_10_i_i3, -510
  %tmp_200 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_47, i32 31)
  %tmp_201 = call i22 @_ssdm_op_PartSelect.i22.i29.i32.i32(i29 %y_10_i_i3, i32 7, i32 28)
  %tmp_212_cast_cast = sext i22 %tmp_201 to i29
  %y_62 = sub i29 %y_10_i_i3, %tmp_212_cast_cast
  %y_11_i_i3 = select i1 %tmp_200, i29 %y_10_i_i3, i29 %y_62
  %p_11_i_i3 = select i1 %tmp_200, i32 %p_10_i_i3, i32 %t_47
  %tmp_202 = trunc i32 %p_11_i_i3 to i1
  %tmp_203 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 8)
  %tmp_204 = call i21 @_ssdm_op_PartSelect.i21.i29.i32.i32(i29 %y_11_i_i3, i32 8, i32 28)
  %tmp_215_cast_cast = sext i21 %tmp_204 to i29
  %y_63 = sub i29 %y_11_i_i3, %tmp_215_cast_cast
  %y_12_i_i3 = select i1 %tmp_203, i29 %y_63, i29 %y_11_i_i3
  %tmp_205 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 7)
  %tmp_206 = call i20 @_ssdm_op_PartSelect.i20.i29.i32.i32(i29 %y_12_i_i3, i32 9, i32 28)
  %tmp_218_cast_cast = sext i20 %tmp_206 to i29
  %y_64 = sub i29 %y_12_i_i3, %tmp_218_cast_cast
  %y_13_i_i3 = select i1 %tmp_205, i29 %y_64, i29 %y_12_i_i3
  %tmp_207 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 6)
  %tmp_208 = call i19 @_ssdm_op_PartSelect.i19.i29.i32.i32(i29 %y_13_i_i3, i32 10, i32 28)
  %tmp_221_cast_cast = sext i19 %tmp_208 to i29
  %y_65 = sub i29 %y_13_i_i3, %tmp_221_cast_cast
  %y_14_i_i3 = select i1 %tmp_207, i29 %y_65, i29 %y_13_i_i3
  %tmp_209 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 5)
  %tmp_210 = call i18 @_ssdm_op_PartSelect.i18.i29.i32.i32(i29 %y_14_i_i3, i32 11, i32 28)
  %tmp_224_cast_cast = sext i18 %tmp_210 to i29
  %y_66 = sub i29 %y_14_i_i3, %tmp_224_cast_cast
  %y_15_i_i3 = select i1 %tmp_209, i29 %y_66, i29 %y_14_i_i3
  %tmp_211 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 4)
  %tmp_212 = call i17 @_ssdm_op_PartSelect.i17.i29.i32.i32(i29 %y_15_i_i3, i32 12, i32 28)
  %tmp_227_cast_cast = sext i17 %tmp_212 to i29
  %y_67 = sub i29 %y_15_i_i3, %tmp_227_cast_cast
  %y_16_i_i3 = select i1 %tmp_211, i29 %y_67, i29 %y_15_i_i3
  %y_16_i_i3_cast = sext i29 %y_16_i_i3 to i30
  %tmp_213 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 3)
  %tmp_214 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %y_16_i_i3, i32 13, i32 28)
  %tmp_230_cast_cast = sext i16 %tmp_214 to i30
  %y_68 = sub i30 %y_16_i_i3_cast, %tmp_230_cast_cast
  %y_17_i_i3 = select i1 %tmp_213, i30 %y_68, i30 %y_16_i_i3_cast
  %tmp_215 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 2)
  %tmp_216 = call i16 @_ssdm_op_PartSelect.i16.i30.i32.i32(i30 %y_17_i_i3, i32 14, i32 29)
  %tmp_233_cast_cast = sext i16 %tmp_216 to i30
  %y_69 = sub i30 %y_17_i_i3, %tmp_233_cast_cast
  %y_18_i_i3 = select i1 %tmp_215, i30 %y_69, i30 %y_17_i_i3
  %tmp_217 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 1)
  %tmp_218 = call i15 @_ssdm_op_PartSelect.i15.i30.i32.i32(i30 %y_18_i_i3, i32 15, i32 29)
  %tmp_220_cast = sext i15 %tmp_218 to i30
  %y_70 = sub i30 %y_18_i_i3, %tmp_220_cast
  %y_19_i_i3 = select i1 %tmp_217, i30 %y_70, i30 %y_18_i_i3
  %tmp_219 = call i14 @_ssdm_op_PartSelect.i14.i30.i32.i32(i30 %y_19_i_i3, i32 16, i32 29)
  %tmp_222_cast = sext i14 %tmp_219 to i30
  %y_71 = sub i30 %y_19_i_i3, %tmp_222_cast
  %ret_3 = select i1 %tmp_202, i30 %y_71, i30 %y_19_i_i3
  %tmp_220 = call i29 @_ssdm_op_PartSelect.i29.i30.i32.i32(i30 %ret_2, i32 1, i32 29)
  %tmp_221 = sext i29 %tmp_220 to i31
  %tmp_222 = zext i31 %tmp_221 to i32
  %tmp_223 = call i29 @_ssdm_op_PartSelect.i29.i30.i32.i32(i30 %ret_3, i32 1, i32 29)
  %tmp_224 = sext i29 %tmp_223 to i31
  %tmp_225 = zext i31 %tmp_224 to i32
  %tmp_226 = mul i32 %tmp_225, %tmp_222
  %tmp_227 = call i18 @_ssdm_op_PartSelect.i18.i32.i32.i32(i32 %tmp_226, i32 14, i32 31)
  %w_1_cast2 = zext i18 %tmp_227 to i19
  %w_1_cast = zext i18 %tmp_227 to i26
  %tmp_243_cast = zext i8 %neighbour_point_1 to i26
  %tmp_228 = mul i26 %w_1_cast, %tmp_243_cast
  %tmp_244_cast = zext i26 %tmp_228 to i27
  %tmp_229 = add i27 %tmp_244_cast, %tmp_127_cast
  %p_cast1 = zext i27 %tmp_229 to i31
  %i_filtered_1 = add i31 %i_filtered1, %p_cast1
  %tmp_230 = add i19 %w_1_cast2, %w_cast1
  %p_cast = zext i19 %tmp_230 to i23
  %Wp_1 = add i23 %Wp, %p_cast
  %empty_44 = call i32 (...)* @_ssdm_op_SpecRegionEnd([36 x i8]* @p_str, i32 %tmp_9) #0
  %k_1 = add i5 %k, 2
  br label %1

; <label>:2                                       ; preds = %1
  %tmp_231 = call i19 @_ssdm_op_PartSelect.i19.i31.i32.i32(i31 %i_filtered1, i32 12, i32 30)
  %tmp_20_cast = zext i19 %tmp_231 to i28
  %tmp_21 = call i11 @_ssdm_op_PartSelect.i11.i23.i32.i32(i23 %Wp, i32 12, i32 22)
  %tmp_22 = zext i11 %tmp_21 to i64
  %div_addr = getelementptr [1024 x i16]* %div, i64 0, i64 %tmp_22
  %div_load = load i16* %div_addr, align 2
  %tmp_23_cast = zext i16 %div_load to i28
  %tmp_24 = mul i28 %tmp_20_cast, %tmp_23_cast
  %tmp_25 = call i8 @_ssdm_op_PartSelect.i8.i28.i32.i32(i28 %tmp_24, i32 20, i32 27)
  ret i8 %tmp_25
}

define weak i32 @_ssdm_op_SpecLoopTripCount(...) {
entry:
  ret i32 0
}

; Function Attrs: nounwind readnone
define weak i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31, i1) #2 {
entry:
  %empty = zext i31 %0 to i32
  %empty_45 = zext i1 %1 to i32
  %empty_46 = trunc i32 %empty to i31
  %empty_47 = call i31 @_ssdm_op_PartSelect.i31.i32.i32.i32(i32 %empty_45, i32 1, i32 31)
  %empty_48 = or i31 %empty_46, %empty_47
  %empty_49 = call i32 @_ssdm_op_PartSet.i32.i32.i31.i32.i32(i32 %empty_45, i31 %empty_48, i32 1, i32 31)
  ret i32 %empty_49
}

; Function Attrs: nounwind readnone
define weak i24 @_ssdm_op_BitConcatenate.i24.i8.i16(i8, i16) #2 {
entry:
  %empty = zext i8 %0 to i24
  %empty_50 = zext i16 %1 to i24
  %empty_51 = trunc i24 %empty to i8
  %empty_52 = call i8 @_ssdm_op_PartSelect.i8.i24.i32.i32(i24 %empty_50, i32 16, i32 23)
  %empty_53 = or i8 %empty_51, %empty_52
  %empty_54 = call i24 @_ssdm_op_PartSet.i24.i24.i8.i32.i32(i24 %empty_50, i8 %empty_53, i32 16, i32 23)
  ret i24 %empty_54
}

; Function Attrs: nounwind readnone
define weak i19 @_ssdm_op_PartSelect.i19.i31.i32.i32(i31, i32, i32) #2 {
entry:
  %empty = call i31 @llvm.part.select.i31(i31 %0, i32 %1, i32 %2)
  %empty_55 = trunc i31 %empty to i19
  ret i19 %empty_55
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i18.i32.i32(i18, i32, i32) #2 {
entry:
  %empty = call i18 @llvm.part.select.i18(i18 %0, i32 %1, i32 %2)
  %empty_56 = trunc i18 %empty to i16
  ret i16 %empty_56
}

; Function Attrs: nounwind readnone
define weak i32 @_ssdm_op_BitConcatenate.i32.i16.i16(i16, i16) #2 {
entry:
  %empty = zext i16 %0 to i32
  %empty_57 = zext i16 %1 to i32
  %empty_58 = trunc i32 %empty to i16
  %empty_59 = call i16 @_ssdm_op_PartSelect.i16.i32.i32.i32(i32 %empty_57, i32 16, i32 31)
  %empty_60 = or i16 %empty_58, %empty_59
  %empty_61 = call i32 @_ssdm_op_PartSet.i32.i32.i16.i32.i32(i32 %empty_57, i16 %empty_60, i32 16, i32 31)
  ret i32 %empty_61
}

; Function Attrs: nounwind readnone
define weak i4 @_ssdm_op_PartSelect.i4.i5.i32.i32(i5, i32, i32) #2 {
entry:
  %empty = call i5 @llvm.part.select.i5(i5 %0, i32 %1, i32 %2)
  %empty_62 = trunc i5 %empty to i4
  ret i4 %empty_62
}

; Function Attrs: nounwind readnone
define weak i5 @_ssdm_op_BitConcatenate.i5.i4.i1(i4, i1) #2 {
entry:
  %empty = zext i4 %0 to i5
  %empty_63 = zext i1 %1 to i5
  %empty_64 = trunc i5 %empty to i4
  %empty_65 = call i4 @_ssdm_op_PartSelect.i4.i5.i32.i32(i5 %empty_63, i32 1, i32 4)
  %empty_66 = or i4 %empty_64, %empty_65
  %empty_67 = call i5 @_ssdm_op_PartSet.i5.i5.i4.i32.i32(i5 %empty_63, i4 %empty_66, i32 1, i32 4)
  ret i5 %empty_67
}

; Function Attrs: nounwind readnone
define weak i18 @_ssdm_op_PartSelect.i18.i32.i32.i32(i32, i32, i32) #2 {
entry:
  %empty = call i32 @llvm.part.select.i32(i32 %0, i32 %1, i32 %2)
  %empty_68 = trunc i32 %empty to i18
  ret i18 %empty_68
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17, i32, i32) #2 {
entry:
  %empty = call i17 @llvm.part.select.i17(i17 %0, i32 %1, i32 %2)
  %empty_69 = trunc i17 %empty to i16
  ret i16 %empty_69
}

; Function Attrs: nounwind readnone
define weak i15 @_ssdm_op_PartSelect.i15.i17.i32.i32(i17, i32, i32) #2 {
entry:
  %empty = call i17 @llvm.part.select.i17(i17 %0, i32 %1, i32 %2)
  %empty_70 = trunc i17 %empty to i15
  ret i15 %empty_70
}

; Function Attrs: nounwind readnone
define weak i13 @_ssdm_op_PartSelect.i13.i17.i32.i32(i17, i32, i32) #2 {
entry:
  %empty = call i17 @llvm.part.select.i17(i17 %0, i32 %1, i32 %2)
  %empty_71 = trunc i17 %empty to i13
  ret i13 %empty_71
}

; Function Attrs: nounwind readnone
define weak i21 @_ssdm_op_BitConcatenate.i21.i5.i16(i5, i16) #2 {
entry:
  %empty = zext i5 %0 to i21
  %empty_72 = zext i16 %1 to i21
  %empty_73 = trunc i21 %empty to i5
  %empty_74 = call i5 @_ssdm_op_PartSelect.i5.i21.i32.i32(i21 %empty_72, i32 16, i32 20)
  %empty_75 = or i5 %empty_73, %empty_74
  %empty_76 = call i21 @_ssdm_op_PartSet.i21.i21.i5.i32.i32(i21 %empty_72, i5 %empty_75, i32 16, i32 20)
  ret i21 %empty_76
}

; Function Attrs: nounwind readnone
define weak i5 @_ssdm_op_BitConcatenate.i5.i3.i2(i3, i2) #2 {
entry:
  %empty = zext i3 %0 to i5
  %empty_77 = zext i2 %1 to i5
  %empty_78 = trunc i5 %empty to i3
  %empty_79 = call i3 @_ssdm_op_PartSelect.i3.i5.i32.i32(i5 %empty_77, i32 2, i32 4)
  %empty_80 = or i3 %empty_78, %empty_79
  %empty_81 = call i5 @_ssdm_op_PartSet.i5.i5.i3.i32.i32(i5 %empty_77, i3 %empty_80, i32 2, i32 4)
  ret i5 %empty_81
}

; Function Attrs: nounwind readnone
define weak i8 @_ssdm_op_PartSelect.i8.i28.i32.i32(i28, i32, i32) #2 {
entry:
  %empty = call i28 @llvm.part.select.i28(i28 %0, i32 %1, i32 %2)
  %empty_82 = trunc i28 %empty to i8
  ret i8 %empty_82
}

; Function Attrs: nounwind readnone
define weak i11 @_ssdm_op_PartSelect.i11.i23.i32.i32(i23, i32, i32) #2 {
entry:
  %empty = call i23 @llvm.part.select.i23(i23 %0, i32 %1, i32 %2)
  %empty_83 = trunc i23 %empty to i11
  ret i11 %empty_83
}

; Function Attrs: nounwind readnone
define weak i29 @_ssdm_op_PartSelect.i29.i30.i32.i32(i30, i32, i32) #2 {
entry:
  %empty = call i30 @llvm.part.select.i30(i30 %0, i32 %1, i32 %2)
  %empty_84 = trunc i30 %empty to i29
  ret i29 %empty_84
}

; Function Attrs: nounwind readnone
define weak i14 @_ssdm_op_PartSelect.i14.i30.i32.i32(i30, i32, i32) #2 {
entry:
  %empty = call i30 @llvm.part.select.i30(i30 %0, i32 %1, i32 %2)
  %empty_85 = trunc i30 %empty to i14
  ret i14 %empty_85
}

; Function Attrs: nounwind readnone
define weak i15 @_ssdm_op_PartSelect.i15.i30.i32.i32(i30, i32, i32) #2 {
entry:
  %empty = call i30 @llvm.part.select.i30(i30 %0, i32 %1, i32 %2)
  %empty_86 = trunc i30 %empty to i15
  ret i15 %empty_86
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i30.i32.i32(i30, i32, i32) #2 {
entry:
  %empty = call i30 @llvm.part.select.i30(i30 %0, i32 %1, i32 %2)
  %empty_87 = trunc i30 %empty to i16
  ret i16 %empty_87
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_88 = trunc i29 %empty to i16
  ret i16 %empty_88
}

; Function Attrs: nounwind readnone
define weak i17 @_ssdm_op_PartSelect.i17.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_89 = trunc i29 %empty to i17
  ret i17 %empty_89
}

; Function Attrs: nounwind readnone
define weak i18 @_ssdm_op_PartSelect.i18.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_90 = trunc i29 %empty to i18
  ret i18 %empty_90
}

; Function Attrs: nounwind readnone
define weak i19 @_ssdm_op_PartSelect.i19.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_91 = trunc i29 %empty to i19
  ret i19 %empty_91
}

; Function Attrs: nounwind readnone
define weak i20 @_ssdm_op_PartSelect.i20.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_92 = trunc i29 %empty to i20
  ret i20 %empty_92
}

; Function Attrs: nounwind readnone
define weak i21 @_ssdm_op_PartSelect.i21.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_93 = trunc i29 %empty to i21
  ret i21 %empty_93
}

; Function Attrs: nounwind readnone
define weak i22 @_ssdm_op_PartSelect.i22.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_94 = trunc i29 %empty to i22
  ret i22 %empty_94
}

; Function Attrs: nounwind readnone
define weak i23 @_ssdm_op_PartSelect.i23.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_95 = trunc i29 %empty to i23
  ret i23 %empty_95
}

; Function Attrs: nounwind readnone
define weak i24 @_ssdm_op_PartSelect.i24.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_96 = trunc i29 %empty to i24
  ret i24 %empty_96
}

; Function Attrs: nounwind readnone
define weak i25 @_ssdm_op_PartSelect.i25.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_97 = trunc i29 %empty to i25
  ret i25 %empty_97
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i19.i32.i32(i19, i32, i32) #2 {
entry:
  %empty = call i19 @llvm.part.select.i19(i19 %0, i32 %1, i32 %2)
  %empty_98 = trunc i19 %empty to i16
  ret i16 %empty_98
}

define weak i32 @_ssdm_op_Read.ap_auto.i32(i32) {
entry:
  ret i32 %0
}

define weak i8 @_ssdm_op_Read.ap_auto.i8(i8) {
entry:
  ret i8 %0
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i32.i32(i32, i32) #2 {
entry:
  %empty = shl i32 1, %1
  %empty_99 = and i32 %0, %empty
  %empty_100 = icmp ne i32 %empty_99, 0
  ret i1 %empty_100
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i9.i32(i9, i32) #2 {
entry:
  %empty = trunc i32 %1 to i9
  %empty_101 = shl i9 1, %empty
  %empty_102 = and i9 %0, %empty_101
  %empty_103 = icmp ne i9 %empty_102, 0
  ret i1 %empty_103
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i8.i32(i8, i32) #2 {
entry:
  %empty = trunc i32 %1 to i8
  %empty_104 = shl i8 1, %empty
  %empty_105 = and i8 %0, %empty_104
  %empty_106 = icmp ne i8 %empty_105, 0
  ret i1 %empty_106
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i7.i32(i7, i32) #2 {
entry:
  %empty = trunc i32 %1 to i7
  %empty_107 = shl i7 1, %empty
  %empty_108 = and i7 %0, %empty_107
  %empty_109 = icmp ne i7 %empty_108, 0
  ret i1 %empty_109
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i6.i32(i6, i32) #2 {
entry:
  %empty = trunc i32 %1 to i6
  %empty_110 = shl i6 1, %empty
  %empty_111 = and i6 %0, %empty_110
  %empty_112 = icmp ne i6 %empty_111, 0
  ret i1 %empty_112
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i5.i32(i5, i32) #2 {
entry:
  %empty = trunc i32 %1 to i5
  %empty_113 = shl i5 1, %empty
  %empty_114 = and i5 %0, %empty_113
  %empty_115 = icmp ne i5 %empty_114, 0
  ret i1 %empty_115
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i4.i32(i4, i32) #2 {
entry:
  %empty = trunc i32 %1 to i4
  %empty_116 = shl i4 1, %empty
  %empty_117 = and i4 %0, %empty_116
  %empty_118 = icmp ne i4 %empty_117, 0
  ret i1 %empty_118
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i3.i32(i3, i32) #2 {
entry:
  %empty = trunc i32 %1 to i3
  %empty_119 = shl i3 1, %empty
  %empty_120 = and i3 %0, %empty_119
  %empty_121 = icmp ne i3 %empty_120, 0
  ret i1 %empty_121
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i2.i32(i2, i32) #2 {
entry:
  %empty = trunc i32 %1 to i2
  %empty_122 = shl i2 1, %empty
  %empty_123 = and i2 %0, %empty_122
  %empty_124 = icmp ne i2 %empty_123, 0
  ret i1 %empty_124
}

; Function Attrs: nounwind readnone
declare i31 @llvm.part.select.i31(i31, i32, i32) #2

; Function Attrs: nounwind readnone
declare i18 @llvm.part.select.i18(i18, i32, i32) #2

; Function Attrs: nounwind readnone
declare i5 @llvm.part.select.i5(i5, i32, i32) #2

; Function Attrs: nounwind readnone
declare i32 @llvm.part.select.i32(i32, i32, i32) #2

; Function Attrs: nounwind readnone
declare i17 @llvm.part.select.i17(i17, i32, i32) #2

; Function Attrs: nounwind readnone
declare i28 @llvm.part.select.i28(i28, i32, i32) #2

; Function Attrs: nounwind readnone
declare i23 @llvm.part.select.i23(i23, i32, i32) #2

; Function Attrs: nounwind readnone
declare i30 @llvm.part.select.i30(i30, i32, i32) #2

; Function Attrs: nounwind readnone
declare i29 @llvm.part.select.i29(i29, i32, i32) #2

; Function Attrs: nounwind readnone
declare i19 @llvm.part.select.i19(i19, i32, i32) #2

; Function Attrs: nounwind readnone
define weak i31 @_ssdm_op_PartSelect.i31.i32.i32.i32(i32, i32, i32) #2 {
entry:
  %empty = call i32 @llvm.part.select.i32(i32 %0, i32 %1, i32 %2)
  %empty_125 = trunc i32 %empty to i31
  ret i31 %empty_125
}

; Function Attrs: nounwind readnone
declare i1 @_ssdm_op_PartSelect.i1.i32.i32.i32(i32, i32, i32) #2

; Function Attrs: nounwind readnone
define weak i32 @_ssdm_op_PartSet.i32.i32.i31.i32.i32(i32, i31, i32, i32) #2 {
entry:
  %empty = call i32 @llvm.part.set.i32.i31(i32 %0, i31 %1, i32 %2, i32 %3)
  ret i32 %empty
}

; Function Attrs: nounwind readnone
define weak i8 @_ssdm_op_PartSelect.i8.i24.i32.i32(i24, i32, i32) #2 {
entry:
  %empty = call i24 @llvm.part.select.i24(i24 %0, i32 %1, i32 %2)
  %empty_126 = trunc i24 %empty to i8
  ret i8 %empty_126
}

; Function Attrs: nounwind readnone
define weak i24 @_ssdm_op_PartSet.i24.i24.i8.i32.i32(i24, i8, i32, i32) #2 {
entry:
  %empty = call i24 @llvm.part.set.i24.i8(i24 %0, i8 %1, i32 %2, i32 %3)
  ret i24 %empty
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i32.i32.i32(i32, i32, i32) #2 {
entry:
  %empty = call i32 @llvm.part.select.i32(i32 %0, i32 %1, i32 %2)
  %empty_127 = trunc i32 %empty to i16
  ret i16 %empty_127
}

; Function Attrs: nounwind readnone
define weak i32 @_ssdm_op_PartSet.i32.i32.i16.i32.i32(i32, i16, i32, i32) #2 {
entry:
  %empty = call i32 @llvm.part.set.i32.i16(i32 %0, i16 %1, i32 %2, i32 %3)
  ret i32 %empty
}

; Function Attrs: nounwind readnone
define weak i5 @_ssdm_op_PartSet.i5.i5.i4.i32.i32(i5, i4, i32, i32) #2 {
entry:
  %empty = call i5 @llvm.part.set.i5.i4(i5 %0, i4 %1, i32 %2, i32 %3)
  ret i5 %empty
}

; Function Attrs: nounwind readnone
define weak i5 @_ssdm_op_PartSelect.i5.i21.i32.i32(i21, i32, i32) #2 {
entry:
  %empty = call i21 @llvm.part.select.i21(i21 %0, i32 %1, i32 %2)
  %empty_128 = trunc i21 %empty to i5
  ret i5 %empty_128
}

; Function Attrs: nounwind readnone
define weak i21 @_ssdm_op_PartSet.i21.i21.i5.i32.i32(i21, i5, i32, i32) #2 {
entry:
  %empty = call i21 @llvm.part.set.i21.i5(i21 %0, i5 %1, i32 %2, i32 %3)
  ret i21 %empty
}

; Function Attrs: nounwind readnone
define weak i3 @_ssdm_op_PartSelect.i3.i5.i32.i32(i5, i32, i32) #2 {
entry:
  %empty = call i5 @llvm.part.select.i5(i5 %0, i32 %1, i32 %2)
  %empty_129 = trunc i5 %empty to i3
  ret i3 %empty_129
}

; Function Attrs: nounwind readnone
define weak i5 @_ssdm_op_PartSet.i5.i5.i3.i32.i32(i5, i3, i32, i32) #2 {
entry:
  %empty = call i5 @llvm.part.set.i5.i3(i5 %0, i3 %1, i32 %2, i32 %3)
  ret i5 %empty
}

; Function Attrs: nounwind readnone
declare i32 @llvm.part.set.i32.i31(i32, i31, i32, i32) #2

; Function Attrs: nounwind readnone
declare i24 @llvm.part.select.i24(i24, i32, i32) #2

; Function Attrs: nounwind readnone
declare i24 @llvm.part.set.i24.i8(i24, i8, i32, i32) #2

; Function Attrs: nounwind readnone
declare i32 @llvm.part.set.i32.i16(i32, i16, i32, i32) #2

; Function Attrs: nounwind readnone
declare i5 @llvm.part.set.i5.i4(i5, i4, i32, i32) #2

; Function Attrs: nounwind readnone
declare i21 @llvm.part.select.i21(i21, i32, i32) #2

; Function Attrs: nounwind readnone
declare i21 @llvm.part.set.i21.i5(i21, i5, i32, i32) #2

; Function Attrs: nounwind readnone
declare i5 @llvm.part.set.i5.i3(i5, i3, i32, i32) #2

attributes #0 = { nounwind }
attributes #1 = { nounwind readonly uwtable }
attributes #2 = { nounwind readnone }


!7 = metadata !{metadata !8}
!8 = metadata !{i32 0, i32 7, metadata !9}
!9 = metadata !{metadata !10}
!10 = metadata !{metadata !"source1", metadata !11, metadata !"unsigned char"}
!11 = metadata !{metadata !12, metadata !12}
!12 = metadata !{i32 0, i32 4, i32 1}
!13 = metadata !{metadata !14}
!14 = metadata !{i32 0, i32 7, metadata !15}
!15 = metadata !{metadata !16}
!16 = metadata !{metadata !"source2", metadata !11, metadata !"unsigned char"}
!17 = metadata !{metadata !18}
!18 = metadata !{i32 0, i32 31, metadata !19}
!19 = metadata !{metadata !20}
!20 = metadata !{metadata !"sigma_i", metadata !21, metadata !"int"}
!21 = metadata !{metadata !22}
!22 = metadata !{i32 0, i32 0, i32 0}
!23 = metadata !{metadata !24}
!24 = metadata !{i32 0, i32 31, metadata !25}
!25 = metadata !{metadata !26}
!26 = metadata !{metadata !"sigma_s", metadata !21, metadata !"int"}
!27 = metadata !{metadata !28}
!28 = metadata !{i32 0, i32 15, metadata !29}
!29 = metadata !{metadata !30}
!30 = metadata !{metadata !"div", metadata !31, metadata !"unsigned short"}
!31 = metadata !{metadata !32}
!32 = metadata !{i32 0, i32 1023, i32 1}
!33 = metadata !{metadata !34}
!34 = metadata !{i32 0, i32 7, metadata !35}
!35 = metadata !{metadata !36}
!36 = metadata !{metadata !"point", metadata !21, metadata !"unsigned char"}
!37 = metadata !{metadata !38}
!38 = metadata !{i32 0, i32 7, metadata !39}
!39 = metadata !{metadata !40}
!40 = metadata !{metadata !"return", metadata !41, metadata !"unsigned char"}
!41 = metadata !{metadata !42}
!42 = metadata !{i32 0, i32 1, i32 0}
