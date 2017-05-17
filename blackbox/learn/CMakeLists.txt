cmake_minimum_required(VERSION 2.8.10)
project(learn)

# You can tweak some common (for all subprojects) stuff here. For example:

set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
set(CMAKE_DISABLE_SOURCE_CHANGES  ON)

if ("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
  message(SEND_ERROR "In-source builds are not allowed.")
endif ()
set(LEARN_PY ${PROJECT_SOURCE_DIR}/python/blackbox_learn.py CACHE INTERNAL "${PROJECT_NAME}" FORCE)
set(AI_WRITER ${PROJECT_SOURCE_DIR}/python/ai_writer.py CACHE INTERNAL "${PROJECT_SOURCE_DIR}" FORCE)
function(blackbox_learn 
    train_activity_file 
    train_power_file 
    valid_activity_file
    valid_power_file
    cycles_per_invocation
    regressor_file_name
    regressor_type
    threshold
    )
    add_custom_command(OUTPUT ${regressor_file_name}.pkl
      COMMAND ${PYTHON_EXECUTABLE} 
          ${LEARN_PY}
        -t ${train_activity_file}
        -p ${train_power_file}
        -v ${valid_activity_file}
        -w ${valid_power_file}
        -c ${cycles_per_invocation}
        -a ${regressor_file_name}
        -l ${regressor_type}
      DEPENDS ${train_activity_file} ${train_power_file} 
              ${valid_activity_file} ${valid_power_file} 
    )
    add_custom_command(OUTPUT ${regressor_file_name}.hpp
      COMMAND ${PYTHON_EXECUTABLE}
      ${AI_WRITER}
      ${regressor_file_name}.pkl
      ${regressor_file_name}.hpp
      DEPENDS ${regressor_file_name}.pkl
    )
endfunction(blackbox_learn)


