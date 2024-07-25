cmake_minimum_required(VERSION 3.13)

project(myserver)

# Set the C++ standard to C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find vsomeip3 package
find_package(vsomeip3 3.4.10 REQUIRED)

# Find Boost libraries
find_package(Boost 1.55 COMPONENTS system thread log REQUIRED)

# Include directories
include_directories(
    ${Boost_INCLUDE_DIR}
    ${VSOMEIP_INCLUDE_DIRS}
)

# Check for filesystem support
include(CheckCXXSourceCompiles)
check_cxx_source_compiles("
    #include <filesystem>
    int main() {
        std::filesystem::path p{\".\"};
        return 0;
    }
" HAS_FILESYSTEM)

if (NOT HAS_FILESYSTEM)
    check_cxx_source_compiles("
        #include <experimental/filesystem>
        int main() {
            std::experimental::filesystem::path p{\".\"};
            return 0;
        }
    " HAS_EXPERIMENTAL_FILESYSTEM)

    if (HAS_EXPERIMENTAL_FILESYSTEM)
        add_definitions(-D_GLIBCXX_USE_CXX11_ABI=0)
    endif()
endif()

# Add definitions for experimental filesystem if necessary
if (HAS_EXPERIMENTAL_FILESYSTEM)
    add_definitions(-DUSE_EXPERIMENTAL_FILESYSTEM)
endif()

# Add executable for the server
add_executable(server_example src/server_example.cpp)

# Link libraries
target_link_libraries(server_example vsomeip3 ${Boost_LIBRARIES})
