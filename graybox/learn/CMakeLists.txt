cmake_minimum_required(VERSION 2.8.10)
project(gray_learn)

# You can tweak some common (for all subprojects) stuff here. For example:

set(GRAY_MODEL_GEN ${PROJECT_SOURCE_DIR}/python/model_gen.py CACHE INTERNAL "${PROJECT_NAME}" FORCE)
set(GRAY_AI_WRITER ${PROJECT_SOURCE_DIR}/python/ai_writer.py CACHE INTERNAL "${PROJECT_SOURCE_DIR}" FORCE)
set(GRAY_PK_DATA ${PROJECT_SOURCE_DIR}/python/DataParser.py CACHE INTERNAL "${PROJECT_SOURCE_DIR}" FORCE)


function(graybox_model_gen
    train_activity_file 
    train_power_file 
    valid_activity_file
    valid_power_file
    regressor_type
    regressor_filename
    threshold
    )
    add_custom_command(OUTPUT ${regressor_filename}.hpp
      COMMAND ${PYTHON_EXECUTABLE} 
      ${GRAY_MODEL_GEN}
        -t ${train_activity_file}
        -p ${train_power_file}
        -v ${valid_activity_file}
        -w ${valid_power_file}
        -a ${regressor_filename}.pkl
        -q ${threshold}
        -l ${regressor_type}
      COMMAND ${PYTHON_EXECUTABLE}
        ${GRAY_AI_WRITER}
        ${regressor_filename}.pkl
        ${regressor_filename}.hpp
      DEPENDS ${train_activity_file} ${train_power_file} 
              ${valid_activity_file} ${valid_activity_file}
      VERBATIM
    )
endfunction(graybox_model_gen)

