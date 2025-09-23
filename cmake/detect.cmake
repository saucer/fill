function(fill_check_cxx_compiles OUTPUT CODE)
    set(FILE_PATH "${CMAKE_BINARY_DIR}")
    cmake_path(APPEND FILE_PATH "fill" "${OUTPUT}.cpp")

    file(WRITE "${FILE_PATH}" "${CODE}")
    try_compile(${OUTPUT} "${CMAKE_BINARY_DIR}" "${FILE_PATH}" CXX_STANDARD 23 CXX_STANDARD_REQUIRED ON)
    file(REMOVE "${FILE_PATH}")

    return(PROPAGATE ${OUTPUT})
endfunction()

function(fill_detect OUTPUT)
    set(MISSING "")

    fill_check_cxx_compiles(has_jthread [=[
    #include <thread>

    int main()
    {
      std::jthread{[]{}};
      return 0;
    }
    ]=])

    if (NOT has_jthread)
        list(APPEND MISSING "jthread")
    endif()

    fill_check_cxx_compiles(has_move_only_function [=[
    #include <functional>

    int main()
    {
      std::move_only_function<void()>{[]{}};
      return 0;
    }
    ]=])

    if (NOT has_move_only_function)
        list(APPEND MISSING "functional")
    endif()

    fill_check_cxx_compiles(has_join_with [=[
    #include <ranges>

    int main()
    {
      std::views::join_with(' ');
      return 0;
    }
    ]=])

    if (NOT has_join_with)
        list(APPEND MISSING "join_with")
    endif()

    set(${OUTPUT} "${MISSING}" PARENT_SCOPE)
endfunction()
