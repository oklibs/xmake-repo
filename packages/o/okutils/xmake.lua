package("okutils", function()
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/oklibs/oklibs/tree/main/libs/okutils")
    set_description("A lightweight, header-only C++20 utility library.")
    set_license("BSL-1.0")

    add_urls("https://github.com/oklibs/oklibs.git")

    on_install("windows", "linux", "macosx", "android", "iphoneos", "wasm", "cross", function(package)
        local configs = {
            dev = false
        }
        import("package.tools.xmake").install(package, configs, {targets = "okutils"})
    end)

    on_test(function(package)
        assert(package:check_cxxsnippets({test = [[
            #include <okutils/defines.hpp>
            OKL_EMPTY()
        ]]}, {configs = {languages = "c++20"}}))
    end)
end)
