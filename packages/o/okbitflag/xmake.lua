package("okbitflag", function()
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/oklibs/oklibs/tree/main/libs/okbitflag")
    set_license("BSL-1.0")

    add_urls("https://github.com/oklibs/oklibs.git")
    add_deps("okutils")

    on_install("windows", "linux", "macosx", "android", "iphoneos", "wasm", "cross", function(package)
        local configs = {
            dev = false
        }
        import("package.tools.xmake").install(package, configs, {targets = "okbitflag"})
    end)

    on_test(function(package)
        assert(package:check_cxxsnippets({test = [=[
            #include <okbitflag/bitflag.hpp>
            #include <cstdlib>
            enum class OKL_FLAG_ENUM EEnum {
                first = 1 << 0,
            };
            int main(const int, char*[])
            {
                [[maybe_unused]] Okl::Bitflag<EEnum> flag;
                return EXIT_SUCCESS;
            }
        ]=]}, {configs = {languages = "c++20"}}))
    end)
end)
