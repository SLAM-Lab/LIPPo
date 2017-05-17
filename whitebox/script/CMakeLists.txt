cmake_minimum_required(VERSION 2.8.10)
project(whitebox_script)

SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -O3  -fPIC -std=c++11 ")
find_package(Boost 1.50.0 REQUIRED COMPONENTS regex)
if(Boost_FOUND)
  message(STATUS "Found BOOST")
  include_directories(${Boost_INCLUDE_DIRS})
endif()
include_directories(${WHITEBOX_INCLUDE_DIRS} ${REGRESSOR_INCLUDE_DIR})



function(create_act_model 
  model 
  copfile
  annotated_bc 
  compile_flag
  )
  set(compile_flag "${compile_flag} -D_ACTIVITY_MODEL_")
  SET_SOURCE_FILES_PROPERTIES( ${annotated_bc}.o PROPERTIES EXTERNAL_OBJECT true)
  add_executable(${model} ${CPP_FILES} ${annotated_bc}.o ${WHITEBOX_TRACE_CPP})
  separate_arguments(compile_flag)
  target_compile_options(${model} PUBLIC ${compile_flag})
  target_link_libraries(${model} ${Boost_LIBRARIES})
  set(activity ${model}.act)
  add_custom_command(OUTPUT ${activity}
    COMMAND ./${model} ${copfile} ${activity}
    DEPENDS ${model} 
    VERBATIM
    )
endfunction(create_act_model)


function(create_whitebox_power_model
    model
    annotated_bc
    train_activity_file
    train_power_file
    valid_activity_file
    valid_power_file
    model_type
    regressor_type
    threshold
    compile_flag
    copfile
)
    set(regressor_filename   ${model}_ai)
    whitebox_model_gen(
      ${train_activity_file}
      ${train_power_file}
      ${valid_activity_file}
      ${valid_power_file}
      ${regressor_type}
      ${regressor_filename}
      "0.0"
      "None"
    )
  set(compile_flag "${compile_flag} -fopenmp -D_AI_FILE_=${CMAKE_CURRENT_BINARY_DIR}/${regressor_filename}.hpp")
  add_executable(${model} ${CPP_FILES} ${annotated_bc}.o ${WHITEBOX_TRACE_CPP} ${regressor_filename}.hpp)
    separate_arguments(compile_flag)
    target_compile_options(${model} PUBLIC ${compile_flag})
    target_link_libraries(${model} ${Boost_LIBRARIES} -fopenmp)
  add_test(test_${model} ${model} ${copfile} ${model}.out)
endfunction(create_whitebox_power_model)
    
function(synth_whitebox
  target_bc
  train_prefix
  valid_prefix
  train_compile_flag
  valid_compile_flag
  train_power_file
  valid_power_file
  regressor_type
  threshold
)
  set(train_act_model ${PROJECT_NAME}_${train_prefix}_act)
  set(valid_act_model ${PROJECT_NAME}_${valid_prefix}_act)
  set(bbfile "bbInfo.txt")
  set(copfile "cop.txt")
  set(ropfile "rop.txt")
  set(mode "1")
  set(annotated_bc ${PROJECT_NAME})
# extract info 
  extract_opinfo( ${DESIGN} ${CDFG} ${DFG} ${RSC} ${bbfile} ${copfile} ${ropfile} ${mode})
# create activity annotation model
  rsc_annotation(${target_bc} ${copfile} ${ropfile} ${bbfile} ${annotated_bc})
# create activity model 
  create_act_model (
      ${train_act_model} 
      ${copfile}
      ${annotated_bc}
      ${train_compile_flag}
      )
# set prefix for model_type
  set(model_type "cd")
# feature selection 
  set(opt_copfile "${model_type}_opt_cop.txt")
  set(opt_ropfile "${model_type}_opt_rop.txt")
  set(opt_annotated_bc ${PROJECT_NAME}_${model_type})
  set(train_activity_file "${train_act_model}.act")
  whitebox_feature_selection(
      ${train_activity_file}
      ${train_power_file}
      ${copfile}
      ${ropfile}
      ${opt_copfile}
      ${opt_ropfile}
      ${threshold}
    )
# optimized annotation
  rsc_annotation(${target_bc} ${opt_copfile} ${opt_ropfile} ${bbfile} ${opt_annotated_bc})
# create opt activity model
  set(train_opt_act_model ${PROJECT_NAME}_${model_type}_${train_prefix}_opt_act)
  set(valid_opt_act_model ${PROJECT_NAME}_${model_type}_${valid_prefix}_opt_act)
  # for train
  create_act_model(
      ${train_opt_act_model}
      ${opt_copfile}
      ${opt_annotated_bc}
      ${train_compile_flag}
      )
  # for validation
  create_act_model(
      ${valid_opt_act_model}
      ${opt_copfile}
      ${opt_annotated_bc}
      ${valid_compile_flag}
      )
# create power model
  set(train_opt_activity_file "${train_opt_act_model}.act")
  set(valid_opt_activity_file "${valid_opt_act_model}.act")
  set(valid_opt_pwr_model 
      ${PROJECT_NAME}_${model_type}_${regressor_type}_${valid_prefix}_opt_pwr)
  create_whitebox_power_model(
      ${valid_opt_pwr_model}
      ${opt_annotated_bc}
      ${train_opt_act_model}.act
      ${train_power_file}
      ${valid_opt_act_model}.act
      ${valid_power_file}
      ${model_type}
      ${regressor_type}
      ${threshold}
      ${valid_compile_flag}
      "${model_type}_opt_cop.txt"
  )
endfunction(synth_whitebox)

