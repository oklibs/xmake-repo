package("oklibs", function()
    set_kind("library")
    set_homepage("https://github.com/oklibs/oklibs/tree/main/libs/oktest")
    set_description("")
    set_license("BSL-1.0")

    add_urls("https://github.com/oklibs/oklibs.git")
    add_deps("fmt >=12.0.0")

    local libraries = {"okutils", "okbitflag", "okassert", "oktest"}
    for _, name in ipairs(libraries) do
        add_configs(name, {description = "Enable " .. name .. ".", default = nil, type = "boolean"})
    end

    add_configs("with_exceptions", {description = "Allow exception usage.", default = true, type = "boolean"})
    add_configs("use_modules", {description = "Build libraries as c++ modules.", default = true, type = "boolean"})
    add_configs("use_std_module", {description = "Use std module instead of includes (requires `use_modules`).", default = true, type = "boolean"})
    add_configs("test_link_main", {description = "Provide a main function in a separate source file.", default = true, type = "boolean"})
    add_configs("test_max_nested", {description = "Maximum nesting level for test cases and sections.", default = "8", type = "string"})
    add_configs("assert_color_mode", {description = "Color output mode for assertion messages.", default = "auto", values = {"auto", "always", "never"}, type = "string"})

    on_install("windows", "linux", "macosx", "android", "iphoneos", "wasm", "cross", function(package)
        local configs = {
            dev = false,
            with_exceptions = package:config("with_exceptions"),
            use_modules = package:config("use_modules"),
            use_std_module = package:config("use_std_module"),
            link_main = package:config("test_link_main"),
            max_nested = package:config("test_max_nested"),
            assert_color_mode = package:config("assert_color_mode")
        }

        local targets = {}
        for name, _ in pairs(libraries) do
            if package:config(name) then
                configs[name] = true
                table.insert(targets, name)
            end
        end
        if #targets == 0 then
            table.join2(targets, libraries)
        end

        import("package.tools.xmake").install(package, configs, {targets = targets})
    end)

    on_test(function(package)
        assert(package:check_cxxsnippets({test = [[
            #include <okutils/defines.hpp>
            OKL_EMPTY()
        ]]}, {configs = {languages = "c++20"}}))
    end)
end)
