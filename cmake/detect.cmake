include("cmake/compile.cmake")

function(fill_detect OUTPUT)
  set(${OUTPUT} "")

  fill_check_cxx_compiles(
    "#include <thread>

    int main()
    {
      std::jthread{[]{}};
      return 0;
    }"
    has_jthread
  )

  if (NOT has_jthread)
    list(APPEND ${OUTPUT} "jthread")
  endif()

  fill_check_cxx_compiles(
    "#include <functional>

    int main()
    {
      std::move_only_function<void()>{[]{}};
      return 0;
    }"
    has_move_only_function
  )

  if (NOT has_move_only_function)
    list(APPEND ${OUTPUT} "functional")
  endif()

  fill_check_cxx_compiles(
    "#include <ranges>

    int main()
    {
      std::views::join_with(' ');
      return 0;
    }"
    has_join_with
  )

  if (NOT has_join_with)
    list(APPEND ${OUTPUT} "join_with")
  endif()

  return(PROPAGATE ${OUTPUT})
endfunction()
