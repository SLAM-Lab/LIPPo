; ModuleID = 'a.o.3.bc'
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@p_str = private unnamed_addr constant [36 x i8] c"apply_fixed_bilateral_filter_label0\00", align 1
@str = internal constant [29 x i8] c"apply_fixed_bilateral_filter\00"
@neighbour_x_table = internal unnamed_addr constant [24 x i3] [i3 0, i3 0, i3 0, i3 0, i3 0, i3 1, i3 1, i3 1, i3 1, i3 1, i3 2, i3 2, i3 2, i3 2, i3 3, i3 3, i3 3, i3 3, i3 3, i3 -4, i3 -4, i3 -4, i3 -4, i3 -4]
@neighbour_y_table = internal unnamed_addr constant [24 x i3] [i3 0, i3 1, i3 2, i3 3, i3 -4, i3 0, i3 1, i3 2, i3 3, i3 -4, i3 0, i3 1, i3 3, i3 -4, i3 0, i3 1, i3 2, i3 3, i3 -4, i3 0, i3 1, i3 2, i3 3, i3 -4]

; Function Attrs: nounwind
define weak void @_ssdm_op_SpecLoopName(...) #0 {
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
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 12, i64 12, i64 12) #0
  br i1 %tmp_3, label %_ifconv, label %2

_ifconv:                                          ; preds = %1
  call void (...)* @_ssdm_op_SpecLoopName([36 x i8]* @p_str) #0
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
  %tmp_9 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_1, i32 31)
  %tmp_10 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_1, i32 31)
  %tmp_11 = select i1 %tmp_10, i17 -65536, i17 128
  %p_x_i_i1 = select i1 %tmp_9, i32 %x_assign_1, i32 %t_1
  %t_2 = add i32 %p_x_i_i1, -363409
  %tmp_12 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_2, i32 31)
  %y_cast_cast = select i1 %tmp_10, i17 256, i17 0
  %y = select i1 %tmp_12, i17 %tmp_11, i17 %y_cast_cast
  %x_assign_3 = select i1 %tmp_12, i32 %p_x_i_i1, i32 %t_2
  %t_3 = add i32 %x_assign_3, -181704
  %tmp_13 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_3, i32 31)
  %tmp_14 = call i13 @_ssdm_op_PartSelect.i13.i17.i32.i32(i17 %y, i32 4, i32 16)
  %tmp_15 = zext i13 %tmp_14 to i17
  %p_y_1_i_i1 = select i1 %tmp_13, i17 %y, i17 %tmp_15
  %p_1_i_i1 = select i1 %tmp_13, i32 %x_assign_3, i32 %t_3
  %t_4 = add i32 %p_1_i_i1, -90852
  %tmp_16 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_4, i32 31)
  %tmp_17 = call i15 @_ssdm_op_PartSelect.i15.i17.i32.i32(i17 %p_y_1_i_i1, i32 2, i32 16)
  %tmp_18 = zext i15 %tmp_17 to i17
  %y_1 = select i1 %tmp_16, i17 %p_y_1_i_i1, i17 %tmp_18
  %x_assign_6 = select i1 %tmp_16, i32 %p_1_i_i1, i32 %t_4
  %t_5 = add i32 %x_assign_6, -45426
  %tmp_19 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_5, i32 31)
  %tmp_20 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %y_1, i32 1, i32 16)
  %tmp_23 = zext i16 %tmp_20 to i17
  %p_y_3_i_i1 = select i1 %tmp_19, i17 %y_1, i17 %tmp_23
  %p_y_3_i_i1_cast = zext i17 %p_y_3_i_i1 to i18
  %p_3_i_i1 = select i1 %tmp_19, i32 %x_assign_6, i32 %t_5
  %t_6 = add i32 %p_3_i_i1, -26573
  %tmp_27 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_6, i32 31)
  %tmp_26 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %p_y_3_i_i1, i32 1, i32 16)
  %tmp_192_cast = zext i16 %tmp_26 to i18
  %y_2 = sub i18 %p_y_3_i_i1_cast, %tmp_192_cast
  %y_5_i_i1 = select i1 %tmp_27, i18 %p_y_3_i_i1_cast, i18 %y_2
  %y_5_i_i1_cast_cast = sext i18 %y_5_i_i1 to i19
  %p_5_i_i1 = select i1 %tmp_27, i32 %p_3_i_i1, i32 %t_6
  %t_7 = add i32 %p_5_i_i1, -14624
  %tmp_28 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_7, i32 31)
  %tmp_29 = call i16 @_ssdm_op_PartSelect.i16.i18.i32.i32(i18 %y_5_i_i1, i32 2, i32 17)
  %tmp_28_cast_cast = sext i16 %tmp_29 to i19
  %y_3 = sub i19 %y_5_i_i1_cast_cast, %tmp_28_cast_cast
  %y_6_i_i1 = select i1 %tmp_28, i19 %y_5_i_i1_cast_cast, i19 %y_3
  %y_6_i_i1_cast = sext i19 %y_6_i_i1 to i29
  %p_6_i_i1 = select i1 %tmp_28, i32 %p_5_i_i1, i32 %t_7
  %t_8 = add i32 %p_6_i_i1, -7719
  %tmp_30 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_8, i32 31)
  %tmp_31 = call i16 @_ssdm_op_PartSelect.i16.i19.i32.i32(i19 %y_6_i_i1, i32 3, i32 18)
  %tmp_30_cast_cast = sext i16 %tmp_31 to i29
  %y_4 = sub i29 %y_6_i_i1_cast, %tmp_30_cast_cast
  %y_7_i_i1 = select i1 %tmp_30, i29 %y_6_i_i1_cast, i29 %y_4
  %p_7_i_i1 = select i1 %tmp_30, i32 %p_6_i_i1, i32 %t_8
  %t_9 = add i32 %p_7_i_i1, -3973
  %tmp_32 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_9, i32 31)
  %tmp_33 = call i25 @_ssdm_op_PartSelect.i25.i29.i32.i32(i29 %y_7_i_i1, i32 4, i32 28)
  %tmp_32_cast_cast = sext i25 %tmp_33 to i29
  %y_5 = sub i29 %y_7_i_i1, %tmp_32_cast_cast
  %y_8_i_i1 = select i1 %tmp_32, i29 %y_7_i_i1, i29 %y_5
  %p_8_i_i1 = select i1 %tmp_32, i32 %p_7_i_i1, i32 %t_9
  %t_10 = add i32 %p_8_i_i1, -2017
  %tmp_34 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_10, i32 31)
  %tmp_35 = call i24 @_ssdm_op_PartSelect.i24.i29.i32.i32(i29 %y_8_i_i1, i32 5, i32 28)
  %tmp_34_cast_cast = sext i24 %tmp_35 to i29
  %y_6 = sub i29 %y_8_i_i1, %tmp_34_cast_cast
  %y_9_i_i1 = select i1 %tmp_34, i29 %y_8_i_i1, i29 %y_6
  %p_9_i_i1 = select i1 %tmp_34, i32 %p_8_i_i1, i32 %t_10
  %t_11 = add i32 %p_9_i_i1, -1016
  %tmp_36 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_11, i32 31)
  %tmp_37 = call i23 @_ssdm_op_PartSelect.i23.i29.i32.i32(i29 %y_9_i_i1, i32 6, i32 28)
  %tmp_36_cast_cast = sext i23 %tmp_37 to i29
  %y_7 = sub i29 %y_9_i_i1, %tmp_36_cast_cast
  %y_10_i_i1 = select i1 %tmp_36, i29 %y_9_i_i1, i29 %y_7
  %p_10_i_i1 = select i1 %tmp_36, i32 %p_9_i_i1, i32 %t_11
  %t_12 = add i32 %p_10_i_i1, -510
  %tmp_38 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_12, i32 31)
  %tmp_39 = call i22 @_ssdm_op_PartSelect.i22.i29.i32.i32(i29 %y_10_i_i1, i32 7, i32 28)
  %tmp_38_cast_cast = sext i22 %tmp_39 to i29
  %y_8 = sub i29 %y_10_i_i1, %tmp_38_cast_cast
  %y_11_i_i1 = select i1 %tmp_38, i29 %y_10_i_i1, i29 %y_8
  %p_11_i_i1 = select i1 %tmp_38, i32 %p_10_i_i1, i32 %t_12
  %tmp_40 = trunc i32 %p_11_i_i1 to i1
  %tmp_41 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 8)
  %tmp_42 = call i21 @_ssdm_op_PartSelect.i21.i29.i32.i32(i29 %y_11_i_i1, i32 8, i32 28)
  %tmp_41_cast_cast = sext i21 %tmp_42 to i29
  %y_9 = sub i29 %y_11_i_i1, %tmp_41_cast_cast
  %y_12_i_i1 = select i1 %tmp_41, i29 %y_9, i29 %y_11_i_i1
  %tmp_43 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 7)
  %tmp_44 = call i20 @_ssdm_op_PartSelect.i20.i29.i32.i32(i29 %y_12_i_i1, i32 9, i32 28)
  %tmp_44_cast_cast = sext i20 %tmp_44 to i29
  %y_10 = sub i29 %y_12_i_i1, %tmp_44_cast_cast
  %y_13_i_i1 = select i1 %tmp_43, i29 %y_10, i29 %y_12_i_i1
  %tmp_45 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 6)
  %tmp_46 = call i19 @_ssdm_op_PartSelect.i19.i29.i32.i32(i29 %y_13_i_i1, i32 10, i32 28)
  %tmp_47_cast_cast = sext i19 %tmp_46 to i29
  %y_11 = sub i29 %y_13_i_i1, %tmp_47_cast_cast
  %y_14_i_i1 = select i1 %tmp_45, i29 %y_11, i29 %y_13_i_i1
  %tmp_47 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 5)
  %tmp_48 = call i18 @_ssdm_op_PartSelect.i18.i29.i32.i32(i29 %y_14_i_i1, i32 11, i32 28)
  %tmp_50_cast_cast = sext i18 %tmp_48 to i29
  %y_12 = sub i29 %y_14_i_i1, %tmp_50_cast_cast
  %y_15_i_i1 = select i1 %tmp_47, i29 %y_12, i29 %y_14_i_i1
  %tmp_49 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 4)
  %tmp_50 = call i17 @_ssdm_op_PartSelect.i17.i29.i32.i32(i29 %y_15_i_i1, i32 12, i32 28)
  %tmp_53_cast_cast = sext i17 %tmp_50 to i29
  %y_13 = sub i29 %y_15_i_i1, %tmp_53_cast_cast
  %y_16_i_i1 = select i1 %tmp_49, i29 %y_13, i29 %y_15_i_i1
  %y_16_i_i1_cast = sext i29 %y_16_i_i1 to i30
  %tmp_51 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 3)
  %tmp_52 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %y_16_i_i1, i32 13, i32 28)
  %tmp_56_cast_cast = sext i16 %tmp_52 to i30
  %y_14 = sub i30 %y_16_i_i1_cast, %tmp_56_cast_cast
  %y_17_i_i1 = select i1 %tmp_51, i30 %y_14, i30 %y_16_i_i1_cast
  %tmp_53 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 2)
  %tmp_54 = call i16 @_ssdm_op_PartSelect.i16.i30.i32.i32(i30 %y_17_i_i1, i32 14, i32 29)
  %tmp_59_cast_cast = sext i16 %tmp_54 to i30
  %y_15 = sub i30 %y_17_i_i1, %tmp_59_cast_cast
  %y_18_i_i1 = select i1 %tmp_53, i30 %y_15, i30 %y_17_i_i1
  %tmp_55 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i1, i32 1)
  %tmp_56 = call i15 @_ssdm_op_PartSelect.i15.i30.i32.i32(i30 %y_18_i_i1, i32 15, i32 29)
  %tmp_56_cast = sext i15 %tmp_56 to i30
  %y_16 = sub i30 %y_18_i_i1, %tmp_56_cast
  %y_19_i_i1 = select i1 %tmp_55, i30 %y_16, i30 %y_18_i_i1
  %tmp_57 = call i14 @_ssdm_op_PartSelect.i14.i30.i32.i32(i30 %y_19_i_i1, i32 16, i32 29)
  %tmp_58_cast = sext i14 %tmp_57 to i30
  %y_17 = sub i30 %y_19_i_i1, %tmp_58_cast
  %ret = select i1 %tmp_40, i30 %y_17, i30 %y_19_i_i1
  %tmp_58 = add i3 %neighbour_x, -2
  %tmp_59 = sext i3 %tmp_58 to i5
  %tmp_68_cast = mul i5 %tmp_59, %tmp_59
  %tmp_60 = add i3 %neighbour_y, -2
  %tmp_61 = sext i3 %tmp_60 to i5
  %tmp_71_cast = mul i5 %tmp_61, %tmp_61
  %tmp_i1 = add i5 %tmp_71_cast, %tmp_68_cast
  %tmp_62 = call i21 @_ssdm_op_BitConcatenate.i21.i5.i16(i5 %tmp_i1, i16 0)
  %diff = sext i21 %tmp_62 to i32
  %x_assign_s = lshr i32 %diff, %tmp_5
  %t_13 = add i32 %x_assign_s, -408835
  %tmp_63 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_13, i32 31)
  %tmp_64 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_13, i32 31)
  %tmp_65 = select i1 %tmp_64, i17 -65536, i17 128
  %p_x_i_i2 = select i1 %tmp_63, i32 %x_assign_s, i32 %t_13
  %t_14 = add i32 %p_x_i_i2, -363409
  %tmp_66 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_14, i32 31)
  %y_22_cast_cast = select i1 %tmp_64, i17 256, i17 0
  %y_18 = select i1 %tmp_66, i17 %tmp_65, i17 %y_22_cast_cast
  %x_assign_4 = select i1 %tmp_66, i32 %p_x_i_i2, i32 %t_14
  %t_15 = add i32 %x_assign_4, -181704
  %tmp_67 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_15, i32 31)
  %tmp_68 = call i13 @_ssdm_op_PartSelect.i13.i17.i32.i32(i17 %y_18, i32 4, i32 16)
  %tmp_69 = zext i13 %tmp_68 to i17
  %p_y_1_i_i2 = select i1 %tmp_67, i17 %y_18, i17 %tmp_69
  %p_1_i_i2 = select i1 %tmp_67, i32 %x_assign_4, i32 %t_15
  %t = add i32 %p_1_i_i2, -90852
  %tmp_70 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t, i32 31)
  %tmp_71 = call i15 @_ssdm_op_PartSelect.i15.i17.i32.i32(i17 %p_y_1_i_i2, i32 2, i32 16)
  %tmp_72 = zext i15 %tmp_71 to i17
  %y_19 = select i1 %tmp_70, i17 %p_y_1_i_i2, i17 %tmp_72
  %x_assign_5 = select i1 %tmp_70, i32 %p_1_i_i2, i32 %t
  %t_16 = add i32 %x_assign_5, -45426
  %tmp_73 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_16, i32 31)
  %tmp_74 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %y_19, i32 1, i32 16)
  %tmp_75 = zext i16 %tmp_74 to i17
  %p_y_3_i_i2 = select i1 %tmp_73, i17 %y_19, i17 %tmp_75
  %p_y_3_i_i2_cast = zext i17 %p_y_3_i_i2 to i18
  %p_3_i_i2 = select i1 %tmp_73, i32 %x_assign_5, i32 %t_16
  %t_17 = add i32 %p_3_i_i2, -26573
  %tmp_76 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_17, i32 31)
  %tmp_77 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %p_y_3_i_i2, i32 1, i32 16)
  %tmp_283_cast = zext i16 %tmp_77 to i18
  %y_20 = sub i18 %p_y_3_i_i2_cast, %tmp_283_cast
  %y_5_i_i2 = select i1 %tmp_76, i18 %p_y_3_i_i2_cast, i18 %y_20
  %y_5_i_i2_cast_cast = sext i18 %y_5_i_i2 to i19
  %p_5_i_i2 = select i1 %tmp_76, i32 %p_3_i_i2, i32 %t_17
  %t_18 = add i32 %p_5_i_i2, -14624
  %tmp_78 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_18, i32 31)
  %tmp_79 = call i16 @_ssdm_op_PartSelect.i16.i18.i32.i32(i18 %y_5_i_i2, i32 2, i32 17)
  %tmp_85_cast_cast = sext i16 %tmp_79 to i19
  %y_21 = sub i19 %y_5_i_i2_cast_cast, %tmp_85_cast_cast
  %y_6_i_i2 = select i1 %tmp_78, i19 %y_5_i_i2_cast_cast, i19 %y_21
  %y_6_i_i2_cast = sext i19 %y_6_i_i2 to i29
  %p_6_i_i2 = select i1 %tmp_78, i32 %p_5_i_i2, i32 %t_18
  %t_19 = add i32 %p_6_i_i2, -7719
  %tmp_80 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_19, i32 31)
  %tmp_81 = call i16 @_ssdm_op_PartSelect.i16.i19.i32.i32(i19 %y_6_i_i2, i32 3, i32 18)
  %tmp_87_cast_cast = sext i16 %tmp_81 to i29
  %y_22 = sub i29 %y_6_i_i2_cast, %tmp_87_cast_cast
  %y_7_i_i2 = select i1 %tmp_80, i29 %y_6_i_i2_cast, i29 %y_22
  %p_7_i_i2 = select i1 %tmp_80, i32 %p_6_i_i2, i32 %t_19
  %t_20 = add i32 %p_7_i_i2, -3973
  %tmp_82 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_20, i32 31)
  %tmp_83 = call i25 @_ssdm_op_PartSelect.i25.i29.i32.i32(i29 %y_7_i_i2, i32 4, i32 28)
  %tmp_89_cast_cast = sext i25 %tmp_83 to i29
  %y_23 = sub i29 %y_7_i_i2, %tmp_89_cast_cast
  %y_8_i_i2 = select i1 %tmp_82, i29 %y_7_i_i2, i29 %y_23
  %p_8_i_i2 = select i1 %tmp_82, i32 %p_7_i_i2, i32 %t_20
  %t_21 = add i32 %p_8_i_i2, -2017
  %tmp_84 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_21, i32 31)
  %tmp_85 = call i24 @_ssdm_op_PartSelect.i24.i29.i32.i32(i29 %y_8_i_i2, i32 5, i32 28)
  %tmp_91_cast_cast = sext i24 %tmp_85 to i29
  %y_24 = sub i29 %y_8_i_i2, %tmp_91_cast_cast
  %y_9_i_i2 = select i1 %tmp_84, i29 %y_8_i_i2, i29 %y_24
  %p_9_i_i2 = select i1 %tmp_84, i32 %p_8_i_i2, i32 %t_21
  %t_22 = add i32 %p_9_i_i2, -1016
  %tmp_86 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_22, i32 31)
  %tmp_87 = call i23 @_ssdm_op_PartSelect.i23.i29.i32.i32(i29 %y_9_i_i2, i32 6, i32 28)
  %tmp_93_cast_cast = sext i23 %tmp_87 to i29
  %y_25 = sub i29 %y_9_i_i2, %tmp_93_cast_cast
  %y_10_i_i2 = select i1 %tmp_86, i29 %y_9_i_i2, i29 %y_25
  %p_10_i_i2 = select i1 %tmp_86, i32 %p_9_i_i2, i32 %t_22
  %t_23 = add i32 %p_10_i_i2, -510
  %tmp_88 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_23, i32 31)
  %tmp_89 = call i22 @_ssdm_op_PartSelect.i22.i29.i32.i32(i29 %y_10_i_i2, i32 7, i32 28)
  %tmp_95_cast_cast = sext i22 %tmp_89 to i29
  %y_26 = sub i29 %y_10_i_i2, %tmp_95_cast_cast
  %y_11_i_i2 = select i1 %tmp_88, i29 %y_10_i_i2, i29 %y_26
  %p_11_i_i2 = select i1 %tmp_88, i32 %p_10_i_i2, i32 %t_23
  %tmp_90 = trunc i32 %p_11_i_i2 to i1
  %tmp_91 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 8)
  %tmp_92 = call i21 @_ssdm_op_PartSelect.i21.i29.i32.i32(i29 %y_11_i_i2, i32 8, i32 28)
  %tmp_98_cast_cast = sext i21 %tmp_92 to i29
  %y_27 = sub i29 %y_11_i_i2, %tmp_98_cast_cast
  %y_12_i_i2 = select i1 %tmp_91, i29 %y_27, i29 %y_11_i_i2
  %tmp_93 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 7)
  %tmp_94 = call i20 @_ssdm_op_PartSelect.i20.i29.i32.i32(i29 %y_12_i_i2, i32 9, i32 28)
  %tmp_101_cast_cast = sext i20 %tmp_94 to i29
  %y_28 = sub i29 %y_12_i_i2, %tmp_101_cast_cast
  %y_13_i_i2 = select i1 %tmp_93, i29 %y_28, i29 %y_12_i_i2
  %tmp_95 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 6)
  %tmp_96 = call i19 @_ssdm_op_PartSelect.i19.i29.i32.i32(i29 %y_13_i_i2, i32 10, i32 28)
  %tmp_104_cast_cast = sext i19 %tmp_96 to i29
  %y_29 = sub i29 %y_13_i_i2, %tmp_104_cast_cast
  %y_14_i_i2 = select i1 %tmp_95, i29 %y_29, i29 %y_13_i_i2
  %tmp_97 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 5)
  %tmp_98 = call i18 @_ssdm_op_PartSelect.i18.i29.i32.i32(i29 %y_14_i_i2, i32 11, i32 28)
  %tmp_107_cast_cast = sext i18 %tmp_98 to i29
  %y_30 = sub i29 %y_14_i_i2, %tmp_107_cast_cast
  %y_15_i_i2 = select i1 %tmp_97, i29 %y_30, i29 %y_14_i_i2
  %tmp_99 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 4)
  %tmp_100 = call i17 @_ssdm_op_PartSelect.i17.i29.i32.i32(i29 %y_15_i_i2, i32 12, i32 28)
  %tmp_110_cast_cast = sext i17 %tmp_100 to i29
  %y_31 = sub i29 %y_15_i_i2, %tmp_110_cast_cast
  %y_16_i_i2 = select i1 %tmp_99, i29 %y_31, i29 %y_15_i_i2
  %y_16_i_i2_cast = sext i29 %y_16_i_i2 to i30
  %tmp_101 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 3)
  %tmp_102 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %y_16_i_i2, i32 13, i32 28)
  %tmp_113_cast_cast = sext i16 %tmp_102 to i30
  %y_32 = sub i30 %y_16_i_i2_cast, %tmp_113_cast_cast
  %y_17_i_i2 = select i1 %tmp_101, i30 %y_32, i30 %y_16_i_i2_cast
  %tmp_103 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 2)
  %tmp_104 = call i16 @_ssdm_op_PartSelect.i16.i30.i32.i32(i30 %y_17_i_i2, i32 14, i32 29)
  %tmp_116_cast_cast = sext i16 %tmp_104 to i30
  %y_33 = sub i30 %y_17_i_i2, %tmp_116_cast_cast
  %y_18_i_i2 = select i1 %tmp_103, i30 %y_33, i30 %y_17_i_i2
  %tmp_105 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i2, i32 1)
  %tmp_106 = call i15 @_ssdm_op_PartSelect.i15.i30.i32.i32(i30 %y_18_i_i2, i32 15, i32 29)
  %tmp_107_cast = sext i15 %tmp_106 to i30
  %y_34 = sub i30 %y_18_i_i2, %tmp_107_cast
  %y_19_i_i2 = select i1 %tmp_105, i30 %y_34, i30 %y_18_i_i2
  %tmp_107 = call i14 @_ssdm_op_PartSelect.i14.i30.i32.i32(i30 %y_19_i_i2, i32 16, i32 29)
  %tmp_109_cast = sext i14 %tmp_107 to i30
  %y_35 = sub i30 %y_19_i_i2, %tmp_109_cast
  %ret_1 = select i1 %tmp_90, i30 %y_35, i30 %y_19_i_i2
  %tmp_108 = call i29 @_ssdm_op_PartSelect.i29.i30.i32.i32(i30 %ret, i32 1, i32 29)
  %tmp_109 = sext i29 %tmp_108 to i31
  %tmp_110 = zext i31 %tmp_109 to i32
  %tmp_111 = call i29 @_ssdm_op_PartSelect.i29.i30.i32.i32(i30 %ret_1, i32 1, i32 29)
  %tmp_112 = sext i29 %tmp_111 to i31
  %tmp_113 = zext i31 %tmp_112 to i32
  %tmp_114 = mul i32 %tmp_113, %tmp_110
  %tmp_115 = call i18 @_ssdm_op_PartSelect.i18.i32.i32.i32(i32 %tmp_114, i32 14, i32 31)
  %w_cast1 = zext i18 %tmp_115 to i19
  %w_cast = zext i18 %tmp_115 to i26
  %tmp_126_cast = zext i8 %neighbour_point to i26
  %tmp_116 = mul i26 %w_cast, %tmp_126_cast
  %tmp_127_cast = zext i26 %tmp_116 to i27
  %tmp_117 = call i4 @_ssdm_op_PartSelect.i4.i5.i32.i32(i5 %k, i32 1, i32 4)
  %tmp_118 = call i5 @_ssdm_op_BitConcatenate.i5.i4.i1(i4 %tmp_117, i1 true)
  %tmp_119 = zext i5 %tmp_118 to i64
  %neighbour_x_table_addr_1 = getelementptr [24 x i3]* @neighbour_x_table, i64 0, i64 %tmp_119
  %neighbour_x_1 = load i3* %neighbour_x_table_addr_1, align 1
  %neighbour_y_table_addr_1 = getelementptr [24 x i3]* @neighbour_y_table, i64 0, i64 %tmp_119
  %neighbour_y_1 = load i3* %neighbour_y_table_addr_1, align 1
  %tmp_131_trn_cast = zext i3 %neighbour_x_1 to i6
  %tmp_130_trn_cast = zext i3 %neighbour_y_1 to i6
  %tmp_120 = call i5 @_ssdm_op_BitConcatenate.i5.i3.i2(i3 %neighbour_x_1, i2 0)
  %p_shl_cast = zext i5 %tmp_120 to i6
  %p_addr2 = add i6 %p_shl_cast, %tmp_131_trn_cast
  %p_addr3 = add i6 %p_addr2, %tmp_130_trn_cast
  %tmp_121 = zext i6 %p_addr3 to i64
  %source2_addr = getelementptr [25 x i8]* %source2, i64 0, i64 %tmp_121
  %neighbour_point_1 = load i8* %source2_addr, align 1
  %tmp_132_cast = zext i8 %neighbour_point_1 to i9
  %diff_3 = sub i9 %tmp_132_cast, %tmp_2_cast
  %diff_5_cast = sext i9 %diff_3 to i16
  %tmp_122 = mul i16 %diff_5_cast, %diff_5_cast
  %tmp_123 = call i32 @_ssdm_op_BitConcatenate.i32.i16.i16(i16 %tmp_122, i16 0)
  %x_assign_8 = lshr i32 %tmp_123, %tmp_7
  %t_24 = add i32 %x_assign_8, -408835
  %tmp_124 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_24, i32 31)
  %tmp_125 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_24, i32 31)
  %tmp_126 = select i1 %tmp_125, i17 -65536, i17 128
  %p_x_i_i = select i1 %tmp_124, i32 %x_assign_8, i32 %t_24
  %t_25 = add i32 %p_x_i_i, -363409
  %tmp_127 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_25, i32 31)
  %y_44_cast_cast = select i1 %tmp_125, i17 256, i17 0
  %y_36 = select i1 %tmp_127, i17 %tmp_126, i17 %y_44_cast_cast
  %x_assign_2 = select i1 %tmp_127, i32 %p_x_i_i, i32 %t_25
  %t_26 = add i32 %x_assign_2, -181704
  %tmp_128 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_26, i32 31)
  %tmp_129 = call i13 @_ssdm_op_PartSelect.i13.i17.i32.i32(i17 %y_36, i32 4, i32 16)
  %tmp_130 = zext i13 %tmp_129 to i17
  %p_y_1_i_i = select i1 %tmp_128, i17 %y_36, i17 %tmp_130
  %p_1_i_i = select i1 %tmp_128, i32 %x_assign_2, i32 %t_26
  %t_27 = add i32 %p_1_i_i, -90852
  %tmp_131 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_27, i32 31)
  %tmp_132 = call i15 @_ssdm_op_PartSelect.i15.i17.i32.i32(i17 %p_y_1_i_i, i32 2, i32 16)
  %tmp_133 = zext i15 %tmp_132 to i17
  %y_37 = select i1 %tmp_131, i17 %p_y_1_i_i, i17 %tmp_133
  %x_assign_7 = select i1 %tmp_131, i32 %p_1_i_i, i32 %t_27
  %t_28 = add i32 %x_assign_7, -45426
  %tmp_134 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_28, i32 31)
  %tmp_135 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %y_37, i32 1, i32 16)
  %tmp_136 = zext i16 %tmp_135 to i17
  %p_y_3_i_i = select i1 %tmp_134, i17 %y_37, i17 %tmp_136
  %p_y_3_i_i_cast = zext i17 %p_y_3_i_i to i18
  %p_3_i_i = select i1 %tmp_134, i32 %x_assign_7, i32 %t_28
  %t_29 = add i32 %p_3_i_i, -26573
  %tmp_137 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_29, i32 31)
  %tmp_138 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %p_y_3_i_i, i32 1, i32 16)
  %tmp_326_cast = zext i16 %tmp_138 to i18
  %y_38 = sub i18 %p_y_3_i_i_cast, %tmp_326_cast
  %y_5_i_i = select i1 %tmp_137, i18 %p_y_3_i_i_cast, i18 %y_38
  %y_5_i_i_cast_cast = sext i18 %y_5_i_i to i19
  %p_5_i_i = select i1 %tmp_137, i32 %p_3_i_i, i32 %t_29
  %t_30 = add i32 %p_5_i_i, -14624
  %tmp_139 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_30, i32 31)
  %tmp_140 = call i16 @_ssdm_op_PartSelect.i16.i18.i32.i32(i18 %y_5_i_i, i32 2, i32 17)
  %tmp_147_cast_cast = sext i16 %tmp_140 to i19
  %y_39 = sub i19 %y_5_i_i_cast_cast, %tmp_147_cast_cast
  %y_6_i_i = select i1 %tmp_139, i19 %y_5_i_i_cast_cast, i19 %y_39
  %y_6_i_i_cast = sext i19 %y_6_i_i to i29
  %p_6_i_i = select i1 %tmp_139, i32 %p_5_i_i, i32 %t_30
  %t_31 = add i32 %p_6_i_i, -7719
  %tmp_141 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_31, i32 31)
  %tmp_142 = call i16 @_ssdm_op_PartSelect.i16.i19.i32.i32(i19 %y_6_i_i, i32 3, i32 18)
  %tmp_149_cast_cast = sext i16 %tmp_142 to i29
  %y_40 = sub i29 %y_6_i_i_cast, %tmp_149_cast_cast
  %y_7_i_i = select i1 %tmp_141, i29 %y_6_i_i_cast, i29 %y_40
  %p_7_i_i = select i1 %tmp_141, i32 %p_6_i_i, i32 %t_31
  %t_32 = add i32 %p_7_i_i, -3973
  %tmp_143 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_32, i32 31)
  %tmp_144 = call i25 @_ssdm_op_PartSelect.i25.i29.i32.i32(i29 %y_7_i_i, i32 4, i32 28)
  %tmp_151_cast_cast = sext i25 %tmp_144 to i29
  %y_41 = sub i29 %y_7_i_i, %tmp_151_cast_cast
  %y_8_i_i = select i1 %tmp_143, i29 %y_7_i_i, i29 %y_41
  %p_8_i_i = select i1 %tmp_143, i32 %p_7_i_i, i32 %t_32
  %t_33 = add i32 %p_8_i_i, -2017
  %tmp_145 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_33, i32 31)
  %tmp_146 = call i24 @_ssdm_op_PartSelect.i24.i29.i32.i32(i29 %y_8_i_i, i32 5, i32 28)
  %tmp_153_cast_cast = sext i24 %tmp_146 to i29
  %y_42 = sub i29 %y_8_i_i, %tmp_153_cast_cast
  %y_9_i_i = select i1 %tmp_145, i29 %y_8_i_i, i29 %y_42
  %p_9_i_i = select i1 %tmp_145, i32 %p_8_i_i, i32 %t_33
  %t_34 = add i32 %p_9_i_i, -1016
  %tmp_147 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_34, i32 31)
  %tmp_148 = call i23 @_ssdm_op_PartSelect.i23.i29.i32.i32(i29 %y_9_i_i, i32 6, i32 28)
  %tmp_155_cast_cast = sext i23 %tmp_148 to i29
  %y_43 = sub i29 %y_9_i_i, %tmp_155_cast_cast
  %y_10_i_i = select i1 %tmp_147, i29 %y_9_i_i, i29 %y_43
  %p_10_i_i = select i1 %tmp_147, i32 %p_9_i_i, i32 %t_34
  %t_35 = add i32 %p_10_i_i, -510
  %tmp_149 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_35, i32 31)
  %tmp_150 = call i22 @_ssdm_op_PartSelect.i22.i29.i32.i32(i29 %y_10_i_i, i32 7, i32 28)
  %tmp_157_cast_cast = sext i22 %tmp_150 to i29
  %y_44 = sub i29 %y_10_i_i, %tmp_157_cast_cast
  %y_11_i_i = select i1 %tmp_149, i29 %y_10_i_i, i29 %y_44
  %p_11_i_i = select i1 %tmp_149, i32 %p_10_i_i, i32 %t_35
  %tmp_151 = trunc i32 %p_11_i_i to i1
  %tmp_152 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 8)
  %tmp_153 = call i21 @_ssdm_op_PartSelect.i21.i29.i32.i32(i29 %y_11_i_i, i32 8, i32 28)
  %tmp_160_cast_cast = sext i21 %tmp_153 to i29
  %y_45 = sub i29 %y_11_i_i, %tmp_160_cast_cast
  %y_12_i_i = select i1 %tmp_152, i29 %y_45, i29 %y_11_i_i
  %tmp_154 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 7)
  %tmp_155 = call i20 @_ssdm_op_PartSelect.i20.i29.i32.i32(i29 %y_12_i_i, i32 9, i32 28)
  %tmp_163_cast_cast = sext i20 %tmp_155 to i29
  %y_46 = sub i29 %y_12_i_i, %tmp_163_cast_cast
  %y_13_i_i = select i1 %tmp_154, i29 %y_46, i29 %y_12_i_i
  %tmp_156 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 6)
  %tmp_157 = call i19 @_ssdm_op_PartSelect.i19.i29.i32.i32(i29 %y_13_i_i, i32 10, i32 28)
  %tmp_166_cast_cast = sext i19 %tmp_157 to i29
  %y_47 = sub i29 %y_13_i_i, %tmp_166_cast_cast
  %y_14_i_i = select i1 %tmp_156, i29 %y_47, i29 %y_13_i_i
  %tmp_158 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 5)
  %tmp_159 = call i18 @_ssdm_op_PartSelect.i18.i29.i32.i32(i29 %y_14_i_i, i32 11, i32 28)
  %tmp_169_cast_cast = sext i18 %tmp_159 to i29
  %y_48 = sub i29 %y_14_i_i, %tmp_169_cast_cast
  %y_15_i_i = select i1 %tmp_158, i29 %y_48, i29 %y_14_i_i
  %tmp_160 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 4)
  %tmp_161 = call i17 @_ssdm_op_PartSelect.i17.i29.i32.i32(i29 %y_15_i_i, i32 12, i32 28)
  %tmp_172_cast_cast = sext i17 %tmp_161 to i29
  %y_49 = sub i29 %y_15_i_i, %tmp_172_cast_cast
  %y_16_i_i = select i1 %tmp_160, i29 %y_49, i29 %y_15_i_i
  %y_16_i_i_cast = sext i29 %y_16_i_i to i30
  %tmp_162 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 3)
  %tmp_163 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %y_16_i_i, i32 13, i32 28)
  %tmp_175_cast_cast = sext i16 %tmp_163 to i30
  %y_50 = sub i30 %y_16_i_i_cast, %tmp_175_cast_cast
  %y_17_i_i = select i1 %tmp_162, i30 %y_50, i30 %y_16_i_i_cast
  %tmp_164 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 2)
  %tmp_165 = call i16 @_ssdm_op_PartSelect.i16.i30.i32.i32(i30 %y_17_i_i, i32 14, i32 29)
  %tmp_178_cast_cast = sext i16 %tmp_165 to i30
  %y_51 = sub i30 %y_17_i_i, %tmp_178_cast_cast
  %y_18_i_i = select i1 %tmp_164, i30 %y_51, i30 %y_17_i_i
  %tmp_166 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i, i32 1)
  %tmp_167 = call i15 @_ssdm_op_PartSelect.i15.i30.i32.i32(i30 %y_18_i_i, i32 15, i32 29)
  %tmp_168_cast = sext i15 %tmp_167 to i30
  %y_52 = sub i30 %y_18_i_i, %tmp_168_cast
  %y_19_i_i = select i1 %tmp_166, i30 %y_52, i30 %y_18_i_i
  %tmp_168 = call i14 @_ssdm_op_PartSelect.i14.i30.i32.i32(i30 %y_19_i_i, i32 16, i32 29)
  %tmp_170_cast = sext i14 %tmp_168 to i30
  %y_53 = sub i30 %y_19_i_i, %tmp_170_cast
  %ret_2 = select i1 %tmp_151, i30 %y_53, i30 %y_19_i_i
  %tmp_169 = add i3 %neighbour_x_1, -2
  %tmp_170 = sext i3 %tmp_169 to i5
  %tmp_187_cast = mul i5 %tmp_170, %tmp_170
  %tmp_171 = add i3 %neighbour_y_1, -2
  %tmp_172 = sext i3 %tmp_171 to i5
  %tmp_190_cast = mul i5 %tmp_172, %tmp_172
  %tmp_i = add i5 %tmp_190_cast, %tmp_187_cast
  %tmp_173 = call i21 @_ssdm_op_BitConcatenate.i21.i5.i16(i5 %tmp_i, i16 0)
  %diff_2 = sext i21 %tmp_173 to i32
  %x_assign_9 = lshr i32 %diff_2, %tmp_5
  %t_36 = add i32 %x_assign_9, -408835
  %tmp_174 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_36, i32 31)
  %tmp_175 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_36, i32 31)
  %tmp_176 = select i1 %tmp_175, i17 -65536, i17 128
  %p_x_i_i3 = select i1 %tmp_174, i32 %x_assign_9, i32 %t_36
  %t_37 = add i32 %p_x_i_i3, -363409
  %tmp_177 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_37, i32 31)
  %y_66_cast_cast = select i1 %tmp_175, i17 256, i17 0
  %y_54 = select i1 %tmp_177, i17 %tmp_176, i17 %y_66_cast_cast
  %x_assign_10 = select i1 %tmp_177, i32 %p_x_i_i3, i32 %t_37
  %t_38 = add i32 %x_assign_10, -181704
  %tmp_178 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_38, i32 31)
  %tmp_179 = call i13 @_ssdm_op_PartSelect.i13.i17.i32.i32(i17 %y_54, i32 4, i32 16)
  %tmp_180 = zext i13 %tmp_179 to i17
  %p_y_1_i_i3 = select i1 %tmp_178, i17 %y_54, i17 %tmp_180
  %p_1_i_i3 = select i1 %tmp_178, i32 %x_assign_10, i32 %t_38
  %t_39 = add i32 %p_1_i_i3, -90852
  %tmp_181 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_39, i32 31)
  %tmp_182 = call i15 @_ssdm_op_PartSelect.i15.i17.i32.i32(i17 %p_y_1_i_i3, i32 2, i32 16)
  %tmp_183 = zext i15 %tmp_182 to i17
  %y_55 = select i1 %tmp_181, i17 %p_y_1_i_i3, i17 %tmp_183
  %x_assign_11 = select i1 %tmp_181, i32 %p_1_i_i3, i32 %t_39
  %t_40 = add i32 %x_assign_11, -45426
  %tmp_184 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_40, i32 31)
  %tmp_185 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %y_55, i32 1, i32 16)
  %tmp_186 = zext i16 %tmp_185 to i17
  %p_y_3_i_i3 = select i1 %tmp_184, i17 %y_55, i17 %tmp_186
  %p_y_3_i_i3_cast = zext i17 %p_y_3_i_i3 to i18
  %p_3_i_i3 = select i1 %tmp_184, i32 %x_assign_11, i32 %t_40
  %t_41 = add i32 %p_3_i_i3, -26573
  %tmp_187 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_41, i32 31)
  %tmp_188 = call i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17 %p_y_3_i_i3, i32 1, i32 16)
  %tmp_367_cast = zext i16 %tmp_188 to i18
  %y_56 = sub i18 %p_y_3_i_i3_cast, %tmp_367_cast
  %y_5_i_i3 = select i1 %tmp_187, i18 %p_y_3_i_i3_cast, i18 %y_56
  %y_5_i_i3_cast_cast = sext i18 %y_5_i_i3 to i19
  %p_5_i_i3 = select i1 %tmp_187, i32 %p_3_i_i3, i32 %t_41
  %t_42 = add i32 %p_5_i_i3, -14624
  %tmp_189 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_42, i32 31)
  %tmp_190 = call i16 @_ssdm_op_PartSelect.i16.i18.i32.i32(i18 %y_5_i_i3, i32 2, i32 17)
  %tmp_202_cast_cast = sext i16 %tmp_190 to i19
  %y_57 = sub i19 %y_5_i_i3_cast_cast, %tmp_202_cast_cast
  %y_6_i_i3 = select i1 %tmp_189, i19 %y_5_i_i3_cast_cast, i19 %y_57
  %y_6_i_i3_cast = sext i19 %y_6_i_i3 to i29
  %p_6_i_i3 = select i1 %tmp_189, i32 %p_5_i_i3, i32 %t_42
  %t_43 = add i32 %p_6_i_i3, -7719
  %tmp_191 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_43, i32 31)
  %tmp_192 = call i16 @_ssdm_op_PartSelect.i16.i19.i32.i32(i19 %y_6_i_i3, i32 3, i32 18)
  %tmp_204_cast_cast = sext i16 %tmp_192 to i29
  %y_58 = sub i29 %y_6_i_i3_cast, %tmp_204_cast_cast
  %y_7_i_i3 = select i1 %tmp_191, i29 %y_6_i_i3_cast, i29 %y_58
  %p_7_i_i3 = select i1 %tmp_191, i32 %p_6_i_i3, i32 %t_43
  %t_44 = add i32 %p_7_i_i3, -3973
  %tmp_193 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_44, i32 31)
  %tmp_194 = call i25 @_ssdm_op_PartSelect.i25.i29.i32.i32(i29 %y_7_i_i3, i32 4, i32 28)
  %tmp_206_cast_cast = sext i25 %tmp_194 to i29
  %y_59 = sub i29 %y_7_i_i3, %tmp_206_cast_cast
  %y_8_i_i3 = select i1 %tmp_193, i29 %y_7_i_i3, i29 %y_59
  %p_8_i_i3 = select i1 %tmp_193, i32 %p_7_i_i3, i32 %t_44
  %t_45 = add i32 %p_8_i_i3, -2017
  %tmp_195 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_45, i32 31)
  %tmp_196 = call i24 @_ssdm_op_PartSelect.i24.i29.i32.i32(i29 %y_8_i_i3, i32 5, i32 28)
  %tmp_208_cast_cast = sext i24 %tmp_196 to i29
  %y_60 = sub i29 %y_8_i_i3, %tmp_208_cast_cast
  %y_9_i_i3 = select i1 %tmp_195, i29 %y_8_i_i3, i29 %y_60
  %p_9_i_i3 = select i1 %tmp_195, i32 %p_8_i_i3, i32 %t_45
  %t_46 = add i32 %p_9_i_i3, -1016
  %tmp_197 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_46, i32 31)
  %tmp_198 = call i23 @_ssdm_op_PartSelect.i23.i29.i32.i32(i29 %y_9_i_i3, i32 6, i32 28)
  %tmp_210_cast_cast = sext i23 %tmp_198 to i29
  %y_61 = sub i29 %y_9_i_i3, %tmp_210_cast_cast
  %y_10_i_i3 = select i1 %tmp_197, i29 %y_9_i_i3, i29 %y_61
  %p_10_i_i3 = select i1 %tmp_197, i32 %p_9_i_i3, i32 %t_46
  %t_47 = add i32 %p_10_i_i3, -510
  %tmp_199 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %t_47, i32 31)
  %tmp_200 = call i22 @_ssdm_op_PartSelect.i22.i29.i32.i32(i29 %y_10_i_i3, i32 7, i32 28)
  %tmp_212_cast_cast = sext i22 %tmp_200 to i29
  %y_62 = sub i29 %y_10_i_i3, %tmp_212_cast_cast
  %y_11_i_i3 = select i1 %tmp_199, i29 %y_10_i_i3, i29 %y_62
  %p_11_i_i3 = select i1 %tmp_199, i32 %p_10_i_i3, i32 %t_47
  %tmp_201 = trunc i32 %p_11_i_i3 to i1
  %tmp_202 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 8)
  %tmp_203 = call i21 @_ssdm_op_PartSelect.i21.i29.i32.i32(i29 %y_11_i_i3, i32 8, i32 28)
  %tmp_215_cast_cast = sext i21 %tmp_203 to i29
  %y_63 = sub i29 %y_11_i_i3, %tmp_215_cast_cast
  %y_12_i_i3 = select i1 %tmp_202, i29 %y_63, i29 %y_11_i_i3
  %tmp_204 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 7)
  %tmp_205 = call i20 @_ssdm_op_PartSelect.i20.i29.i32.i32(i29 %y_12_i_i3, i32 9, i32 28)
  %tmp_218_cast_cast = sext i20 %tmp_205 to i29
  %y_64 = sub i29 %y_12_i_i3, %tmp_218_cast_cast
  %y_13_i_i3 = select i1 %tmp_204, i29 %y_64, i29 %y_12_i_i3
  %tmp_206 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 6)
  %tmp_207 = call i19 @_ssdm_op_PartSelect.i19.i29.i32.i32(i29 %y_13_i_i3, i32 10, i32 28)
  %tmp_221_cast_cast = sext i19 %tmp_207 to i29
  %y_65 = sub i29 %y_13_i_i3, %tmp_221_cast_cast
  %y_14_i_i3 = select i1 %tmp_206, i29 %y_65, i29 %y_13_i_i3
  %tmp_208 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 5)
  %tmp_209 = call i18 @_ssdm_op_PartSelect.i18.i29.i32.i32(i29 %y_14_i_i3, i32 11, i32 28)
  %tmp_224_cast_cast = sext i18 %tmp_209 to i29
  %y_66 = sub i29 %y_14_i_i3, %tmp_224_cast_cast
  %y_15_i_i3 = select i1 %tmp_208, i29 %y_66, i29 %y_14_i_i3
  %tmp_210 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 4)
  %tmp_211 = call i17 @_ssdm_op_PartSelect.i17.i29.i32.i32(i29 %y_15_i_i3, i32 12, i32 28)
  %tmp_227_cast_cast = sext i17 %tmp_211 to i29
  %y_67 = sub i29 %y_15_i_i3, %tmp_227_cast_cast
  %y_16_i_i3 = select i1 %tmp_210, i29 %y_67, i29 %y_15_i_i3
  %y_16_i_i3_cast = sext i29 %y_16_i_i3 to i30
  %tmp_212 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 3)
  %tmp_213 = call i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29 %y_16_i_i3, i32 13, i32 28)
  %tmp_230_cast_cast = sext i16 %tmp_213 to i30
  %y_68 = sub i30 %y_16_i_i3_cast, %tmp_230_cast_cast
  %y_17_i_i3 = select i1 %tmp_212, i30 %y_68, i30 %y_16_i_i3_cast
  %tmp_214 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 2)
  %tmp_215 = call i16 @_ssdm_op_PartSelect.i16.i30.i32.i32(i30 %y_17_i_i3, i32 14, i32 29)
  %tmp_233_cast_cast = sext i16 %tmp_215 to i30
  %y_69 = sub i30 %y_17_i_i3, %tmp_233_cast_cast
  %y_18_i_i3 = select i1 %tmp_214, i30 %y_69, i30 %y_17_i_i3
  %tmp_216 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %p_11_i_i3, i32 1)
  %tmp_217 = call i15 @_ssdm_op_PartSelect.i15.i30.i32.i32(i30 %y_18_i_i3, i32 15, i32 29)
  %tmp_219_cast = sext i15 %tmp_217 to i30
  %y_70 = sub i30 %y_18_i_i3, %tmp_219_cast
  %y_19_i_i3 = select i1 %tmp_216, i30 %y_70, i30 %y_18_i_i3
  %tmp_218 = call i14 @_ssdm_op_PartSelect.i14.i30.i32.i32(i30 %y_19_i_i3, i32 16, i32 29)
  %tmp_221_cast5 = sext i14 %tmp_218 to i30
  %y_71 = sub i30 %y_19_i_i3, %tmp_221_cast5
  %ret_3 = select i1 %tmp_201, i30 %y_71, i30 %y_19_i_i3
  %tmp_219 = call i29 @_ssdm_op_PartSelect.i29.i30.i32.i32(i30 %ret_2, i32 1, i32 29)
  %tmp_220 = sext i29 %tmp_219 to i31
  %tmp_221 = zext i31 %tmp_220 to i32
  %tmp_222 = call i29 @_ssdm_op_PartSelect.i29.i30.i32.i32(i30 %ret_3, i32 1, i32 29)
  %tmp_223 = sext i29 %tmp_222 to i31
  %tmp_224 = zext i31 %tmp_223 to i32
  %tmp_225 = mul i32 %tmp_224, %tmp_221
  %tmp_226 = call i18 @_ssdm_op_PartSelect.i18.i32.i32.i32(i32 %tmp_225, i32 14, i32 31)
  %w_1_cast2 = zext i18 %tmp_226 to i19
  %w_1_cast = zext i18 %tmp_226 to i26
  %tmp_243_cast = zext i8 %neighbour_point_1 to i26
  %tmp_227 = mul i26 %w_1_cast, %tmp_243_cast
  %tmp_244_cast = zext i26 %tmp_227 to i27
  %tmp_228 = add i27 %tmp_244_cast, %tmp_127_cast
  %p_cast1 = zext i27 %tmp_228 to i31
  %i_filtered_1 = add i31 %i_filtered1, %p_cast1
  %tmp_229 = add i19 %w_1_cast2, %w_cast1
  %p_cast = zext i19 %tmp_229 to i23
  %Wp_1 = add i23 %Wp, %p_cast
  %k_1 = add i5 %k, 2
  br label %1

; <label>:2                                       ; preds = %1
  %tmp_230 = call i19 @_ssdm_op_PartSelect.i19.i31.i32.i32(i31 %i_filtered1, i32 12, i32 30)
  %tmp_20_cast = zext i19 %tmp_230 to i28
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
  %empty_44 = zext i1 %1 to i32
  %empty_45 = trunc i32 %empty to i31
  %empty_46 = call i31 @_ssdm_op_PartSelect.i31.i32.i32.i32(i32 %empty_44, i32 1, i32 31)
  %empty_47 = or i31 %empty_45, %empty_46
  %empty_48 = call i32 @_ssdm_op_PartSet.i32.i32.i31.i32.i32(i32 %empty_44, i31 %empty_47, i32 1, i32 31)
  ret i32 %empty_48
}

; Function Attrs: nounwind readnone
define weak i24 @_ssdm_op_BitConcatenate.i24.i8.i16(i8, i16) #2 {
entry:
  %empty = zext i8 %0 to i24
  %empty_49 = zext i16 %1 to i24
  %empty_50 = trunc i24 %empty to i8
  %empty_51 = call i8 @_ssdm_op_PartSelect.i8.i24.i32.i32(i24 %empty_49, i32 16, i32 23)
  %empty_52 = or i8 %empty_50, %empty_51
  %empty_53 = call i24 @_ssdm_op_PartSet.i24.i24.i8.i32.i32(i24 %empty_49, i8 %empty_52, i32 16, i32 23)
  ret i24 %empty_53
}

; Function Attrs: nounwind readnone
define weak i19 @_ssdm_op_PartSelect.i19.i31.i32.i32(i31, i32, i32) #2 {
entry:
  %empty = call i31 @llvm.part.select.i31(i31 %0, i32 %1, i32 %2)
  %empty_54 = trunc i31 %empty to i19
  ret i19 %empty_54
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i18.i32.i32(i18, i32, i32) #2 {
entry:
  %empty = call i18 @llvm.part.select.i18(i18 %0, i32 %1, i32 %2)
  %empty_55 = trunc i18 %empty to i16
  ret i16 %empty_55
}

; Function Attrs: nounwind readnone
define weak i32 @_ssdm_op_BitConcatenate.i32.i16.i16(i16, i16) #2 {
entry:
  %empty = zext i16 %0 to i32
  %empty_56 = zext i16 %1 to i32
  %empty_57 = trunc i32 %empty to i16
  %empty_58 = call i16 @_ssdm_op_PartSelect.i16.i32.i32.i32(i32 %empty_56, i32 16, i32 31)
  %empty_59 = or i16 %empty_57, %empty_58
  %empty_60 = call i32 @_ssdm_op_PartSet.i32.i32.i16.i32.i32(i32 %empty_56, i16 %empty_59, i32 16, i32 31)
  ret i32 %empty_60
}

; Function Attrs: nounwind readnone
define weak i4 @_ssdm_op_PartSelect.i4.i5.i32.i32(i5, i32, i32) #2 {
entry:
  %empty = call i5 @llvm.part.select.i5(i5 %0, i32 %1, i32 %2)
  %empty_61 = trunc i5 %empty to i4
  ret i4 %empty_61
}

; Function Attrs: nounwind readnone
define weak i5 @_ssdm_op_BitConcatenate.i5.i4.i1(i4, i1) #2 {
entry:
  %empty = zext i4 %0 to i5
  %empty_62 = zext i1 %1 to i5
  %empty_63 = trunc i5 %empty to i4
  %empty_64 = call i4 @_ssdm_op_PartSelect.i4.i5.i32.i32(i5 %empty_62, i32 1, i32 4)
  %empty_65 = or i4 %empty_63, %empty_64
  %empty_66 = call i5 @_ssdm_op_PartSet.i5.i5.i4.i32.i32(i5 %empty_62, i4 %empty_65, i32 1, i32 4)
  ret i5 %empty_66
}

; Function Attrs: nounwind readnone
define weak i18 @_ssdm_op_PartSelect.i18.i32.i32.i32(i32, i32, i32) #2 {
entry:
  %empty = call i32 @llvm.part.select.i32(i32 %0, i32 %1, i32 %2)
  %empty_67 = trunc i32 %empty to i18
  ret i18 %empty_67
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i17.i32.i32(i17, i32, i32) #2 {
entry:
  %empty = call i17 @llvm.part.select.i17(i17 %0, i32 %1, i32 %2)
  %empty_68 = trunc i17 %empty to i16
  ret i16 %empty_68
}

; Function Attrs: nounwind readnone
define weak i15 @_ssdm_op_PartSelect.i15.i17.i32.i32(i17, i32, i32) #2 {
entry:
  %empty = call i17 @llvm.part.select.i17(i17 %0, i32 %1, i32 %2)
  %empty_69 = trunc i17 %empty to i15
  ret i15 %empty_69
}

; Function Attrs: nounwind readnone
define weak i13 @_ssdm_op_PartSelect.i13.i17.i32.i32(i17, i32, i32) #2 {
entry:
  %empty = call i17 @llvm.part.select.i17(i17 %0, i32 %1, i32 %2)
  %empty_70 = trunc i17 %empty to i13
  ret i13 %empty_70
}

; Function Attrs: nounwind readnone
define weak i21 @_ssdm_op_BitConcatenate.i21.i5.i16(i5, i16) #2 {
entry:
  %empty = zext i5 %0 to i21
  %empty_71 = zext i16 %1 to i21
  %empty_72 = trunc i21 %empty to i5
  %empty_73 = call i5 @_ssdm_op_PartSelect.i5.i21.i32.i32(i21 %empty_71, i32 16, i32 20)
  %empty_74 = or i5 %empty_72, %empty_73
  %empty_75 = call i21 @_ssdm_op_PartSet.i21.i21.i5.i32.i32(i21 %empty_71, i5 %empty_74, i32 16, i32 20)
  ret i21 %empty_75
}

; Function Attrs: nounwind readnone
define weak i5 @_ssdm_op_BitConcatenate.i5.i3.i2(i3, i2) #2 {
entry:
  %empty = zext i3 %0 to i5
  %empty_76 = zext i2 %1 to i5
  %empty_77 = trunc i5 %empty to i3
  %empty_78 = call i3 @_ssdm_op_PartSelect.i3.i5.i32.i32(i5 %empty_76, i32 2, i32 4)
  %empty_79 = or i3 %empty_77, %empty_78
  %empty_80 = call i5 @_ssdm_op_PartSet.i5.i5.i3.i32.i32(i5 %empty_76, i3 %empty_79, i32 2, i32 4)
  ret i5 %empty_80
}

; Function Attrs: nounwind readnone
define weak i8 @_ssdm_op_PartSelect.i8.i28.i32.i32(i28, i32, i32) #2 {
entry:
  %empty = call i28 @llvm.part.select.i28(i28 %0, i32 %1, i32 %2)
  %empty_81 = trunc i28 %empty to i8
  ret i8 %empty_81
}

; Function Attrs: nounwind readnone
define weak i11 @_ssdm_op_PartSelect.i11.i23.i32.i32(i23, i32, i32) #2 {
entry:
  %empty = call i23 @llvm.part.select.i23(i23 %0, i32 %1, i32 %2)
  %empty_82 = trunc i23 %empty to i11
  ret i11 %empty_82
}

; Function Attrs: nounwind readnone
define weak i29 @_ssdm_op_PartSelect.i29.i30.i32.i32(i30, i32, i32) #2 {
entry:
  %empty = call i30 @llvm.part.select.i30(i30 %0, i32 %1, i32 %2)
  %empty_83 = trunc i30 %empty to i29
  ret i29 %empty_83
}

; Function Attrs: nounwind readnone
define weak i14 @_ssdm_op_PartSelect.i14.i30.i32.i32(i30, i32, i32) #2 {
entry:
  %empty = call i30 @llvm.part.select.i30(i30 %0, i32 %1, i32 %2)
  %empty_84 = trunc i30 %empty to i14
  ret i14 %empty_84
}

; Function Attrs: nounwind readnone
define weak i15 @_ssdm_op_PartSelect.i15.i30.i32.i32(i30, i32, i32) #2 {
entry:
  %empty = call i30 @llvm.part.select.i30(i30 %0, i32 %1, i32 %2)
  %empty_85 = trunc i30 %empty to i15
  ret i15 %empty_85
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i30.i32.i32(i30, i32, i32) #2 {
entry:
  %empty = call i30 @llvm.part.select.i30(i30 %0, i32 %1, i32 %2)
  %empty_86 = trunc i30 %empty to i16
  ret i16 %empty_86
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_87 = trunc i29 %empty to i16
  ret i16 %empty_87
}

; Function Attrs: nounwind readnone
define weak i17 @_ssdm_op_PartSelect.i17.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_88 = trunc i29 %empty to i17
  ret i17 %empty_88
}

; Function Attrs: nounwind readnone
define weak i18 @_ssdm_op_PartSelect.i18.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_89 = trunc i29 %empty to i18
  ret i18 %empty_89
}

; Function Attrs: nounwind readnone
define weak i19 @_ssdm_op_PartSelect.i19.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_90 = trunc i29 %empty to i19
  ret i19 %empty_90
}

; Function Attrs: nounwind readnone
define weak i20 @_ssdm_op_PartSelect.i20.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_91 = trunc i29 %empty to i20
  ret i20 %empty_91
}

; Function Attrs: nounwind readnone
define weak i21 @_ssdm_op_PartSelect.i21.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_92 = trunc i29 %empty to i21
  ret i21 %empty_92
}

; Function Attrs: nounwind readnone
define weak i22 @_ssdm_op_PartSelect.i22.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_93 = trunc i29 %empty to i22
  ret i22 %empty_93
}

; Function Attrs: nounwind readnone
define weak i23 @_ssdm_op_PartSelect.i23.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_94 = trunc i29 %empty to i23
  ret i23 %empty_94
}

; Function Attrs: nounwind readnone
define weak i24 @_ssdm_op_PartSelect.i24.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_95 = trunc i29 %empty to i24
  ret i24 %empty_95
}

; Function Attrs: nounwind readnone
define weak i25 @_ssdm_op_PartSelect.i25.i29.i32.i32(i29, i32, i32) #2 {
entry:
  %empty = call i29 @llvm.part.select.i29(i29 %0, i32 %1, i32 %2)
  %empty_96 = trunc i29 %empty to i25
  ret i25 %empty_96
}

; Function Attrs: nounwind readnone
define weak i16 @_ssdm_op_PartSelect.i16.i19.i32.i32(i19, i32, i32) #2 {
entry:
  %empty = call i19 @llvm.part.select.i19(i19 %0, i32 %1, i32 %2)
  %empty_97 = trunc i19 %empty to i16
  ret i16 %empty_97
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
  %empty_98 = and i32 %0, %empty
  %empty_99 = icmp ne i32 %empty_98, 0
  ret i1 %empty_99
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i9.i32(i9, i32) #2 {
entry:
  %empty = trunc i32 %1 to i9
  %empty_100 = shl i9 1, %empty
  %empty_101 = and i9 %0, %empty_100
  %empty_102 = icmp ne i9 %empty_101, 0
  ret i1 %empty_102
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i8.i32(i8, i32) #2 {
entry:
  %empty = trunc i32 %1 to i8
  %empty_103 = shl i8 1, %empty
  %empty_104 = and i8 %0, %empty_103
  %empty_105 = icmp ne i8 %empty_104, 0
  ret i1 %empty_105
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i7.i32(i7, i32) #2 {
entry:
  %empty = trunc i32 %1 to i7
  %empty_106 = shl i7 1, %empty
  %empty_107 = and i7 %0, %empty_106
  %empty_108 = icmp ne i7 %empty_107, 0
  ret i1 %empty_108
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i6.i32(i6, i32) #2 {
entry:
  %empty = trunc i32 %1 to i6
  %empty_109 = shl i6 1, %empty
  %empty_110 = and i6 %0, %empty_109
  %empty_111 = icmp ne i6 %empty_110, 0
  ret i1 %empty_111
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i5.i32(i5, i32) #2 {
entry:
  %empty = trunc i32 %1 to i5
  %empty_112 = shl i5 1, %empty
  %empty_113 = and i5 %0, %empty_112
  %empty_114 = icmp ne i5 %empty_113, 0
  ret i1 %empty_114
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i4.i32(i4, i32) #2 {
entry:
  %empty = trunc i32 %1 to i4
  %empty_115 = shl i4 1, %empty
  %empty_116 = and i4 %0, %empty_115
  %empty_117 = icmp ne i4 %empty_116, 0
  ret i1 %empty_117
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i3.i32(i3, i32) #2 {
entry:
  %empty = trunc i32 %1 to i3
  %empty_118 = shl i3 1, %empty
  %empty_119 = and i3 %0, %empty_118
  %empty_120 = icmp ne i3 %empty_119, 0
  ret i1 %empty_120
}

; Function Attrs: nounwind readnone
define weak i1 @_ssdm_op_BitSelect.i1.i2.i32(i2, i32) #2 {
entry:
  %empty = trunc i32 %1 to i2
  %empty_121 = shl i2 1, %empty
  %empty_122 = and i2 %0, %empty_121
  %empty_123 = icmp ne i2 %empty_122, 0
  ret i1 %empty_123
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
  %empty_124 = trunc i32 %empty to i31
  ret i31 %empty_124
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
  %empty_125 = trunc i24 %empty to i8
  ret i8 %empty_125
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
  %empty_126 = trunc i32 %empty to i16
  ret i16 %empty_126
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
  %empty_127 = trunc i21 %empty to i5
  ret i5 %empty_127
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
  %empty_128 = trunc i5 %empty to i3
  ret i3 %empty_128
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


!6 = metadata !{i32 0, i32 0, i32 1}
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
