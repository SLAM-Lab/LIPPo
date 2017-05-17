cmake_minimum_required(VERSION 2.8.10)
project(blackbox_script)

SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -O3 -fPIC -std=c++11 ")
find_package(Boost 1.50.0 REQUIRED COMPONENTS regex)
if(Boost_FOUND)
  message(STATUS "Found BOOST")
  include_directories(${Boost_INCLUDE_DIRS})
endif()
include_directories(${BLACKBOX_INCLUDE_DIRS} ${REGRESSOR_INCLUDE_DIR})


function(create_blackbox_act_model
  model 
  copfile
  annotated_bc 
  compile_flag
  )
  set(compile_flag "${compile_flag} -D_ACTIVITY_MODEL_ -D_INV_MODEL_")
  SET_SOURCE_FILES_PROPERTIES( ${annotated_bc}.o PROPERTIES EXTERNAL_OBJECT true)
  add_executable(${model} ${CPP_FILES} ${annotated_bc}.o ${BLACKBOX_TRACE_CPP})
  separate_arguments(compile_flag)
  target_compile_options(${model} PUBLIC ${compile_flag})
  target_link_libraries(${model} ${Boost_LIBRARIES})
  set(activity ${model}.act)
  add_custom_command(OUTPUT ${activity}
    COMMAND ./${model} ${copfile} ${activity}
    DEPENDS ${model} 
    VERBATIM
    )
endfunction(create_blackbox_act_model)

function(create_blackbox_power_model
    model
    annotated_bc
    train_activity_file
    train_power_file
    valid_activity_file
    valid_power_file
    regressor_type
    threshold
    cycles_per_invoc
    compile_flag
  )
  set(regressor_filename   ${model}_ai)
  blackbox_learn(
      ${train_activity_file}
      ${train_power_file}
      ${valid_activity_file}
      ${valid_power_file}
      ${cycles_per_invoc}
      ${regressor_filename}
      ${regressor_type}
      ${threshold}
    )
  set(compile_flag "${compile_flag} -D_AI_FILE_=${CMAKE_CURRENT_BINARY_DIR}/${regressor_filename}.hpp -D_INV_MODEL_ -fopenmp")
  SET_SOURCE_FILES_PROPERTIES( ${annotated_bc}.o PROPERTIES EXTERNAL_OBJECT true)
  add_executable(${model} ${CPP_FILES} ${annotated_bc}.o ${BLACKBOX_TRACE_CPP} ${regressor_filename})
  separate_arguments(compile_flag)
  target_compile_options(${model} PUBLIC  ${compile_flag})
  target_link_libraries(${model} ${Boost_LIBRARIES} -fopenmp)
  add_test(test_${model} ${model} ${model}.out)
  add_test(test_${model}_no ${model} "")
endfunction(create_blackbox_power_model)



function(synth_blackbox
  target_bc
  train_prefix
  valid_prefix
  train_compile_flag
  valid_compile_flag
  train_power_file
  valid_power_file
  regressor_type
  threshold
  cycles_per_invoc
)
  set(model_type "ie")
  set(train_act_model ${PROJECT_NAME}_${train_prefix}_act)
  set(valid_act_model ${PROJECT_NAME}_${valid_prefix}_act)
  set(bbfile "bbInfo.txt")
  set(copfile "cop.txt")
  set(ropfile "rop.txt")
  set(mode "0")
  set(annotated_bc ${PROJECT_NAME})
# extract info 
  extract_opinfo( ${DESIGN} ${CDFG} ${DFG} ${RSC} ${bbfile} ${copfile} ${ropfile} ${mode})
# create activity annotation model
  io_annotation(${target_bc} ${copfile} ${ropfile} ${bbfile} ${annotated_bc})
# create activity model 
  create_blackbox_act_model (
      ${train_act_model} 
      ${copfile}
      ${annotated_bc}
      ${train_compile_flag}
      )
  # for validation
  create_blackbox_act_model(
      ${valid_act_model}
      ${copfile}
      ${annotated_bc}
      ${valid_compile_flag}
      )
# create power model
  set(valid_pwr_model 
      ${PROJECT_NAME}_${model_type}_${regressor_type}_${valid_prefix}_pwr)
  create_blackbox_power_model(
      ${valid_pwr_model}
      ${annotated_bc}
      ${train_act_model}.act
      ${train_power_file}
      ${valid_act_model}.act
      ${valid_power_file}
      ${regressor_type}
      ${threshold}
      ${cycles_per_invoc}
      ${valid_compile_flag}
  )
endfunction(synth_blackbox)
