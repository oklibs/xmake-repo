package("oktest", function()
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/oklibs/oklibs/tree/main/libs/oktest")
    set_description("A C++20 testing framework designed with first-class support for compile-time testing.")
    set_license("BSL-1.0")

    add_urls("https://github.com/oklibs/oklibs.git")
    add_deps("okutils", "okbitflag")

    add_configs("max_nested", {description = "Maximum nesting level for test cases and sections.", default = "8", type = "string"})
    add_configs("with_exceptions", {description = "Allow exception usage.", default = true, type = "boolean"})

    on_install("windows", "linux", "macosx", "android", "iphoneos", "wasm", "cross", function(package)
        local configs = {
            dev = false,
            max_nested = package:config("max_nested"),
            with_exceptions = package:config("with_exceptions")
        }
        import("package.tools.xmake").install(package, configs, {targets = "oktest"})
    end)

    on_test(function(package)
        assert(package:check_cxxsnippets({test = [=[
            #define OKTEST_DEFINE_MAIN
            #include <oktest/test.hpp>
            TEST_CASE("test")
            {
                constexpr int value{1};
                CHECK(value == 1);
            };
        ]=]}, {configs = {languages = "c++20"}}))
    end)
end)
