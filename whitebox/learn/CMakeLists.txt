cmake_minimum_required(VERSION 2.8.10)
project(white_learn)

# You can tweak some common (for all subprojects) stuff here. For example:

set(WHITE_MODEL_GEN ${PROJECT_SOURCE_DIR}/python/model_gen.py CACHE INTERNAL "${PROJECT_NAME}" FORCE)
set(WHITE_FEATURE_SEL ${PROJECT_SOURCE_DIR}/python/feature_sel.py CACHE INTERNAL "${PROJECT_NAME}" FORCE)
set(WHITE_AI_WRITER ${PROJECT_SOURCE_DIR}/python/ai_writer.py CACHE INTERNAL "${PROJECT_SOURCE_DIR}" FORCE)


function(whitebox_feature_selection
    train_activity_file 
    train_power_file 
    cop_file
    rop_file
    opt_cop_file
    opt_rop_file
    threshold
    )
    add_custom_command(OUTPUT ${opt_rop_file} ${opt_cop_file}
      COMMAND ${PYTHON_EXECUTABLE} 
      ${WHITE_FEATURE_SEL}
        -t ${train_activity_file}
        -p ${train_power_file}
        -c ${cop_file}
        -r ${rop_file}
        -d ${opt_cop_file}
        -s ${opt_rop_file}
        -q ${threshold}
      DEPENDS ${train_activity_file} ${train_power_file} 
              ${cop_file} ${rop_file}
      VERBATIM
    )
endfunction(whitebox_feature_selection)


function(whitebox_model_gen
    train_activity_file 
    train_power_file 
    valid_activity_file
    valid_power_file
    regressor_type
    regressor_filename
    threshold
    list_train_length
    )
    message(${regressor_filename} "hahah")
    add_custom_command(OUTPUT ${regressor_filename}.hpp
      COMMAND ${PYTHON_EXECUTABLE} 
      ${WHITE_MODEL_GEN}
        -t ${train_activity_file}
        -p ${train_power_file}
        -v ${valid_activity_file}
        -w ${valid_power_file}
        -a ${regressor_filename}.pkl
        -q ${threshold}
        -l ${regressor_type}
        -k ${list_train_length}
      COMMAND ${PYTHON_EXECUTABLE}
        ${WHITE_AI_WRITER}
        ${regressor_filename}.pkl
        ${regressor_filename}.hpp
      DEPENDS ${train_activity_file} ${train_power_file} 
              ${valid_activity_file} ${valid_power_file}
      VERBATIM
    )
endfunction(whitebox_model_gen)

