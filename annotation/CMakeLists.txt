cmake_minimum_required(VERSION 2.8.10)
project(code_gen)
add_subdirectory(llvm)


set(CDFG_READER ${PROJECT_SOURCE_DIR}/python/cdfg_main.py CACHE INTERNAL "CDFG READER" FORCE)

function (extract_opinfo  design cdfg dfg rsc bbfile copfile ropfile mode)
  add_custom_command(OUTPUT ${copfile} ${ropfile} ${bbfile}
    COMMAND ${PYTHON_EXECUTABLE} ${CDFG_READER}
    ${design}
    --cdfg     ${cdfg}
    --dfg      ${dfg}
    --resource ${rsc}
    --bb       ${bbfile}
    --pipeline pipeline.txt
    --copfile  ${copfile}
    --ropfile  ${ropfile}
    --mode  ${mode}
    DEPENDS  ${cdfg} ${dfg} ${rsc}
    VERBATIM
    )
endfunction(extract_opinfo)


function (rsc_annotation target_bc copfile ropfile bbfile annotated_output)
  add_custom_command(OUTPUT ${annotated_output}.o ${annotated_output}.bc
    COMMAND simple-tool --noopt     ${target_bc} ${annotated_output}.bc ${copfile} ${ropfile} ${bbfile}
    COMMAND clang++  -c ${annotated_output}.bc 
    DEPENDS ${target_bc} ${copfile} ${ropfile}
    VERBATIM
    )
endfunction(rsc_annotation)

function (bb_annotation target_bc copfile ropfile bbfile annotated_output)
  add_custom_command(OUTPUT ${annotated_output}.o ${annotated_output}.bc
    COMMAND simple-tool --bb     ${target_bc} ${annotated_output}.bc ${copfile} ${ropfile} ${bbfile}
    COMMAND clang++  -c ${annotated_output}.bc 
    DEPENDS ${target_bc} ${copfile} ${ropfile}
    VERBATIM
    )
endfunction(bb_annotation)

function (io_annotation target_bc copfile ropfile bbfile annotated_output)
  add_custom_command(OUTPUT ${annotated_output}.o ${annotated_output}.bc
    COMMAND simple-tool --inv     ${target_bc} ${annotated_output}.bc ${copfile} ${ropfile} ${bbfile}
    COMMAND clang++  -c ${annotated_output}.bc 
    DEPENDS ${target_bc} ${copfile} ${ropfile}
    VERBATIM
    )
endfunction(io_annotation)
