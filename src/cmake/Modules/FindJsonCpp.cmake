find_package(jsoncpp CONFIG QUIET)

if(JsonCpp_FOUND)
    message(STATUS "Found jsoncpp via config file: ${JsonCpp_DIR}")
    if(NOT JsonCpp_LIBRARY)
        if(TARGET JsonCpp)
            set(JsonCpp_LIBRARY JsonCpp)
        elseif(TARGET JsonCpp::jsoncpp)
            set(JsonCpp_LIBRARY JsonCpp::jsoncpp)
        endif()
    endif()
else()
    find_package(PkgConfig)
    pkg_check_modules(PC_JSONCPP jsoncpp)

    find_path(JsonCpp_INCLUDE_DIR
              NAMES json/json.h
              HINTS ${PC_JSONCPP_INCLUDEDIR} ${PC_JSONCPP_INCLUDE_DIRS})
    find_library(JsonCpp_LIBRARY
                 NAMES jsoncpp
                 HINTS ${PC_JSONCPP_LIBDIR} ${PC_JSONCPP_LIBRARY_DIRS})

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(JsonCpp DEFAULT_MSG JsonCpp_LIBRARY JsonCpp_INCLUDE_DIR)

    mark_as_advanced(JsonCpp_INCLUDE_DIR JsonCpp_LIBRARY)
endif()

if (JsonCpp_FOUND)
    if(NOT TARGET JsonCpp::jsoncpp)
        add_library(JsonCpp::jsoncpp INTERFACE IMPORTED)
    endif()
    set_target_properties(JsonCpp::jsoncpp PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${JsonCpp_INCLUDE_DIR}"
        INTERFACE_LINK_LIBRARIES "${JsonCpp_LIBRARY}")
    if(NOT JsonCpp_LIBRARY)
        unset(JsonCpp_LIBRARY CACHE)
    endif()
    if(NOT JsonCpp_INCLUDE_DIR)
        unset(JsonCpp_INCLUDE_DIR CACHE)
    endif()
endif()
