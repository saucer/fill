function(fill_check_cxx_compiles CODE OUTPUT)
  set(FILE_PATH "${CMAKE_BINARY_DIR}/fill/${OUTPUT}.cpp")
  file(WRITE "${FILE_PATH}" "${CODE}")

  try_compile(
     ${OUTPUT}
     "${CMAKE_BINARY_DIR}"
     "${FILE_PATH}"
     CXX_STANDARD 23 
     CXX_STANDARD_REQUIRED ON
  )

  file(REMOVE "${FILE_PATH}")
  return(PROPAGATE ${OUTPUT})
endfunction()
