<hr>

<div align="center"> 
    <img src="https://raw.githubusercontent.com/saucer/saucer.github.io/master/static/img/logo.png" height="312" />
</div>

<p align="center"> 
    Polyfill utility for <a href="https://github.com/saucer/saucer">saucer</a>
</p>

---

## 📦 Installation

* Using [CPM](https://github.com/cpm-cmake/CPM.cmake)
  ```cmake
  CPMFindPackage(
    NAME           saucer-fill
    VERSION        1.0.0
    GIT_REPOSITORY "https://github.com/saucer/fill"
  )
  ```

* Using FetchContent
  ```cmake
  include(FetchContent)

  FetchContent_Declare(saucer-fill GIT_REPOSITORY "https://github.com/saucer/fill" GIT_TAG v1.0.0)
  FetchContent_MakeAvailable(saucer-fill)
  ```

Finally, link against target:

```cmake
target_link_libraries(<target> saucer::fill)
```
