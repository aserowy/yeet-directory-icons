local M = {}

-- ANSI foreground escape helper: "\27[38;2;R;G;Bm"
local function hex_to_ansi(hex)
    hex = hex:gsub("^#", "")
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    return string.format("\27[38;2;%d;%d;%dm", r, g, b)
end

local ANSI_RESET = "\27[0m"

local DEFAULT_FILE_ICON = "󰈔"
local DEFAULT_DIR_ICON = "󰉋"

-- Token name constants for default fallback colors
local TOKEN_DEFAULT_FILE = "DirectoryIconsColorDefaultFile"
local TOKEN_DEFAULT_DIR  = "DirectoryIconsColorDefaultDirectory"

-- Theme token defaults: token_name -> hex_color
-- Registered during setup() only if not already set by a theme plugin.
local token_defaults = {
    [TOKEN_DEFAULT_FILE]                        = "#6d8086",
    [TOKEN_DEFAULT_DIR]                         = "#8caaee",
    DirectoryIconsColorLua                      = "#51a0cf",
    DirectoryIconsColorRs                       = "#dea584",
    DirectoryIconsColorToml                     = "#6d8086",
    DirectoryIconsColorYaml                     = "#6d8086",
    DirectoryIconsColorJson                     = "#cbcb41",
    DirectoryIconsColorMd                       = "#519aba",
    DirectoryIconsColorTxt                      = "#89e051",
    DirectoryIconsColorSh                       = "#4d5a5e",
    DirectoryIconsColorPy                       = "#ffbc03",
    DirectoryIconsColorJs                       = "#cbcb41",
    DirectoryIconsColorTs                       = "#519aba",
    DirectoryIconsColorTsx                      = "#1354bf",
    DirectoryIconsColorJsx                      = "#20c2e3",
    DirectoryIconsColorHtml                     = "#e44d26",
    DirectoryIconsColorCss                      = "#42a5f5",
    DirectoryIconsColorScss                     = "#f55385",
    DirectoryIconsColorLess                     = "#563d7c",
    DirectoryIconsColorVue                      = "#8dc149",
    DirectoryIconsColorSvelte                   = "#ff3e00",
    DirectoryIconsColorGo                       = "#519aba",
    DirectoryIconsColorRb                       = "#701516",
    DirectoryIconsColorPhp                      = "#a074c4",
    DirectoryIconsColorJava                     = "#cc3e44",
    DirectoryIconsColorKt                       = "#7f52ff",
    DirectoryIconsColorSwift                    = "#e37933",
    DirectoryIconsColorC                        = "#599eff",
    DirectoryIconsColorH                        = "#a074c4",
    DirectoryIconsColorCpp                      = "#f34b7d",
    DirectoryIconsColorCs                       = "#596706",
    DirectoryIconsColorFs                       = "#519aba",
    DirectoryIconsColorEx                       = "#a074c4",
    DirectoryIconsColorErl                      = "#b83998",
    DirectoryIconsColorHs                       = "#a074c4",
    DirectoryIconsColorMl                       = "#e37933",
    DirectoryIconsColorClj                      = "#8dc149",
    DirectoryIconsColorScala                    = "#cc3e44",
    DirectoryIconsColorR                        = "#2266ba",
    DirectoryIconsColorJl                       = "#a270ba",
    DirectoryIconsColorNim                      = "#f3d400",
    DirectoryIconsColorZig                      = "#f69a1b",
    DirectoryIconsColorDart                     = "#03589c",
    DirectoryIconsColorSql                      = "#dad8d8",
    DirectoryIconsColorGraphql                  = "#e10098",
    DirectoryIconsColorProto                    = "#6d8086",
    DirectoryIconsColorXml                      = "#e44d26",
    DirectoryIconsColorSvg                      = "#ffb13b",
    DirectoryIconsColorImage                    = "#a074c4",
    DirectoryIconsColorIco                      = "#cbcb41",
    DirectoryIconsColorAudio                    = "#d39ede",
    DirectoryIconsColorVideo                    = "#fd971f",
    DirectoryIconsColorPdf                      = "#b30b00",
    DirectoryIconsColorDoc                      = "#185abd",
    DirectoryIconsColorXls                      = "#207245",
    DirectoryIconsColorPpt                      = "#cb4a32",
    DirectoryIconsColorArchive                  = "#eca517",
    DirectoryIconsColorNix                      = "#7ebae4",
    DirectoryIconsColorLock                     = "#6d8086",
    DirectoryIconsColorConf                     = "#6d8086",
    DirectoryIconsColorEnv                      = "#faf743",
    DirectoryIconsColorLog                      = "#6d8086",
    DirectoryIconsColorDiff                     = "#41535b",
    DirectoryIconsColorVim                      = "#019833",
    DirectoryIconsColorOrg                      = "#77aa99",
    DirectoryIconsColorTerraform                = "#5f43e9",
    DirectoryIconsColorSol                      = "#519aba",
    DirectoryIconsColorWasm                     = "#654ff0",
    DirectoryIconsColorAsm                      = "#6d8086",
    DirectoryIconsColorFont                     = "#ececec",
    DirectoryIconsColorMakefile                 = "#6d8086",
    DirectoryIconsColorCmake                    = "#6d8086",
    DirectoryIconsColorDockerfile               = "#384d54",
    DirectoryIconsColorGitignore                = "#f14c28",
    DirectoryIconsColorEditorconfig             = "#fff2f0",
    DirectoryIconsColorDotEnv                   = "#faf743",
    DirectoryIconsColorPackageJson              = "#e8274b",
    DirectoryIconsColorPackageLockJson          = "#7a0d21",
    DirectoryIconsColorTsconfig                 = "#519aba",
    DirectoryIconsColorCargoToml                = "#dea584",
    DirectoryIconsColorGemfile                  = "#701516",
    DirectoryIconsColorGoMod                    = "#519aba",
    DirectoryIconsColorFlakeNix                 = "#7ebae4",
    DirectoryIconsColorLicense                  = "#d0bf41",
    DirectoryIconsColorChangelog                = "#6d8086",
    DirectoryIconsColorReadme                   = "#519aba",
    DirectoryIconsColorPrettier                 = "#56b3b4",
    DirectoryIconsColorEslint                   = "#4b32c3",
    DirectoryIconsColorWebpack                  = "#519aba",
    DirectoryIconsColorVite                     = "#ffab00",
    DirectoryIconsColorTailwind                 = "#38bdf8",
    DirectoryIconsColorJest                     = "#99425b",
    DirectoryIconsColorRustfmt                  = "#dea584",
    DirectoryIconsColorDirGit                   = "#f14c28",
    DirectoryIconsColorDirGithub                = "#6d8086",
    DirectoryIconsColorDirVscode                = "#007acc",
    DirectoryIconsColorDirIdea                  = "#cc3e44",
    DirectoryIconsColorDirNodeModules           = "#e8274b",
    DirectoryIconsColorDirGeneric               = "#6d8086",
    DirectoryIconsColorDirTarget                = "#dea584",
    DirectoryIconsColorDirCargo                 = "#dea584",
    DirectoryIconsColorDirNix                   = "#7ebae4",
}

-- Icon mappings: { glyph, token_name }
-- Extension-based rules
local ext_map = {
    ["lua"]    = { "󰢱", "DirectoryIconsColorLua" },
    ["rs"]     = { "󱘗", "DirectoryIconsColorRs" },
    ["toml"]   = { "", "DirectoryIconsColorToml" },
    ["yaml"]   = { "", "DirectoryIconsColorYaml" },
    ["yml"]    = { "", "DirectoryIconsColorYaml" },
    ["json"]   = { "", "DirectoryIconsColorJson" },
    ["md"]     = { "", "DirectoryIconsColorMd" },
    ["txt"]    = { "", "DirectoryIconsColorTxt" },
    ["sh"]     = { "󰯂", "DirectoryIconsColorSh" },
    ["bash"]   = { "󱆃", "DirectoryIconsColorSh" },
    ["zsh"]    = { "󰯂", "DirectoryIconsColorSh" },
    ["fish"]   = { "󰈺", "DirectoryIconsColorSh" },
    ["py"]     = { "", "DirectoryIconsColorPy" },
    ["js"]     = { "", "DirectoryIconsColorJs" },
    ["mjs"]    = { "", "DirectoryIconsColorJs" },
    ["cjs"]    = { "", "DirectoryIconsColorJs" },
    ["ts"]     = { "", "DirectoryIconsColorTs" },
    ["tsx"]    = { "", "DirectoryIconsColorTsx" },
    ["jsx"]    = { "", "DirectoryIconsColorJsx" },
    ["html"]   = { "", "DirectoryIconsColorHtml" },
    ["htm"]    = { "", "DirectoryIconsColorHtml" },
    ["css"]    = { "", "DirectoryIconsColorCss" },
    ["scss"]   = { "", "DirectoryIconsColorScss" },
    ["sass"]   = { "", "DirectoryIconsColorScss" },
    ["less"]   = { "", "DirectoryIconsColorLess" },
    ["vue"]    = { "", "DirectoryIconsColorVue" },
    ["svelte"] = { "", "DirectoryIconsColorSvelte" },
    ["go"]     = { "󰟓", "DirectoryIconsColorGo" },
    ["rb"]     = { "󰴭", "DirectoryIconsColorRb" },
    ["php"]    = { "󰌟", "DirectoryIconsColorPhp" },
    ["java"]   = { "󰬷", "DirectoryIconsColorJava" },
    -- ["kt"]     = { "", "DirectoryIconsColorKt" },
    -- ["kts"]    = { "", "DirectoryIconsColorKt" },
    -- ["swift"]  = { "", "DirectoryIconsColorSwift" },
    -- ["c"]      = { "", "DirectoryIconsColorC" },
    -- ["h"]      = { "", "DirectoryIconsColorH" },
    -- ["cpp"]    = { "", "DirectoryIconsColorCpp" },
    -- ["hpp"]    = { "", "DirectoryIconsColorH" },
    -- ["cc"]     = { "", "DirectoryIconsColorCpp" },
    -- ["hh"]     = { "", "DirectoryIconsColorH" },
    ["cs"]     = { "󰌛", "DirectoryIconsColorCs" },
    -- ["fs"]     = { "", "DirectoryIconsColorFs" },
    -- ["fsx"]    = { "", "DirectoryIconsColorFs" },
    -- ["ex"]     = { "", "DirectoryIconsColorEx" },
    -- ["exs"]    = { "", "DirectoryIconsColorEx" },
    -- ["erl"]    = { "", "DirectoryIconsColorErl" },
    -- ["hs"]     = { "", "DirectoryIconsColorHs" },
    -- ["ml"]     = { "", "DirectoryIconsColorMl" },
    -- ["mli"]    = { "", "DirectoryIconsColorMl" },
    -- ["clj"]    = { "", "DirectoryIconsColorClj" },
    -- ["cljs"]   = { "", "DirectoryIconsColorClj" },
    -- ["scala"]  = { "", "DirectoryIconsColorScala" },
    ["r"]      = { "󰟔", "DirectoryIconsColorR" },
    -- ["jl"]     = { "", "DirectoryIconsColorJl" },
    -- ["nim"]    = { "", "DirectoryIconsColorNim" },
    ["zig"]    = { "", "DirectoryIconsColorZig" },
    -- ["dart"]   = { "", "DirectoryIconsColorDart" },
    -- ["sql"]    = { "", "DirectoryIconsColorSql" },
    -- ["graphql"]= { "", "DirectoryIconsColorGraphql" },
    -- ["gql"]    = { "", "DirectoryIconsColorGraphql" },
    -- ["proto"]  = { "", "DirectoryIconsColorProto" },
    ["xml"]    = { "󰗀", "DirectoryIconsColorXml" },
    ["svg"]    = { "󰜡", "DirectoryIconsColorSvg" },
    ["png"]    = { "󰸭", "DirectoryIconsColorImage" },
    ["jpg"]    = { "󰈥", "DirectoryIconsColorImage" },
    ["jpeg"]   = { "󰈥", "DirectoryIconsColorImage" },
    ["gif"]    = { "󰵸", "DirectoryIconsColorImage" },
    -- ["ico"]    = { "", "DirectoryIconsColorIco" },
    -- ["webp"]   = { "", "DirectoryIconsColorImage" },
    -- ["bmp"]    = { "", "DirectoryIconsColorImage" },
    -- ["mp3"]    = { "", "DirectoryIconsColorAudio" },
    -- ["flac"]   = { "", "DirectoryIconsColorAudio" },
    -- ["wav"]    = { "", "DirectoryIconsColorAudio" },
    -- ["ogg"]    = { "", "DirectoryIconsColorAudio" },
    -- ["mp4"]    = { "", "DirectoryIconsColorVideo" },
    -- ["mkv"]    = { "", "DirectoryIconsColorVideo" },
    -- ["avi"]    = { "", "DirectoryIconsColorVideo" },
    -- ["mov"]    = { "", "DirectoryIconsColorVideo" },
    -- ["webm"]   = { "", "DirectoryIconsColorVideo" },
    ["pdf"]    = { "󰈦", "DirectoryIconsColorPdf" },
    ["doc"]    = { "󰈬", "DirectoryIconsColorDoc" },
    ["docx"]   = { "󰈬", "DirectoryIconsColorDoc" },
    ["xls"]    = { "󰈛", "DirectoryIconsColorXls" },
    ["xlsx"]   = { "󰈛", "DirectoryIconsColorXls" },
    ["ppt"]    = { "󰈧", "DirectoryIconsColorPpt" },
    ["pptx"]   = { "󰈧", "DirectoryIconsColorPpt" },
    ["zip"]    = { "󰛫", "DirectoryIconsColorArchive" },
    ["tar"]    = { "󰛫", "DirectoryIconsColorArchive" },
    ["gz"]     = { "󰛫", "DirectoryIconsColorArchive" },
    ["bz2"]    = { "󰛫", "DirectoryIconsColorArchive" },
    ["xz"]     = { "󰛫", "DirectoryIconsColorArchive" },
    ["7z"]     = { "󰛫", "DirectoryIconsColorArchive" },
    ["rar"]    = { "󰛫", "DirectoryIconsColorArchive" },
    -- ["deb"]    = { "", "DirectoryIconsColorArchive" },
    -- ["rpm"]    = { "", "DirectoryIconsColorArchive" },
    ["nix"]    = { "󱄅", "DirectoryIconsColorNix" },
    -- ["lock"]   = { "", "DirectoryIconsColorLock" },
    -- ["conf"]   = { "", "DirectoryIconsColorConf" },
    -- ["cfg"]    = { "", "DirectoryIconsColorConf" },
    -- ["ini"]    = { "", "DirectoryIconsColorConf" },
    -- ["env"]    = { "", "DirectoryIconsColorEnv" },
    ["log"]    = { "󰌱", "DirectoryIconsColorLog" },
    -- ["diff"]   = { "", "DirectoryIconsColorDiff" },
    -- ["patch"]  = { "", "DirectoryIconsColorDiff" },
    -- ["vim"]    = { "", "DirectoryIconsColorVim" },
    -- ["org"]    = { "", "DirectoryIconsColorOrg" },
    ["tf"]     = { "󱁢", "DirectoryIconsColorTerraform" },
    -- ["hcl"]    = { "", "DirectoryIconsColorTerraform" },
    -- ["sol"]    = { "", "DirectoryIconsColorSol" },
    -- ["wasm"]   = { "", "DirectoryIconsColorWasm" },
    -- ["asm"]    = { "", "DirectoryIconsColorAsm" },
    -- ["s"]      = { "", "DirectoryIconsColorAsm" },
    -- ["ttf"]    = { "", "DirectoryIconsColorFont" },
    -- ["otf"]    = { "", "DirectoryIconsColorFont" },
    -- ["woff"]   = { "", "DirectoryIconsColorFont" },
    -- ["woff2"]  = { "", "DirectoryIconsColorFont" },
    -- ["eot"]    = { "", "DirectoryIconsColorFont" },
}

-- Exact filename rules (checked before extension)
local name_map = {
    -- ["Makefile"]       = { "", "DirectoryIconsColorMakefile" },
    -- ["CMakeLists.txt"] = { "", "DirectoryIconsColorCmake" },
    ["Dockerfile"]     = { "󰡨", "DirectoryIconsColorDockerfile" },
    ["Containerfile"]  = { "󰡨", "DirectoryIconsColorDockerfile" },
    [".dockerignore"]  = { "󰡨", "DirectoryIconsColorDockerfile" },
    -- [".gitignore"]     = { "", "DirectoryIconsColorGitignore" },
    -- [".gitmodules"]    = { "", "DirectoryIconsColorGitignore" },
    -- [".gitattributes"] = { "", "DirectoryIconsColorGitignore" },
    -- [".editorconfig"]  = { "", "DirectoryIconsColorEditorconfig" },
    -- [".env"]           = { "", "DirectoryIconsColorDotEnv" },
    -- [".env.local"]     = { "", "DirectoryIconsColorDotEnv" },
    -- [".env.example"]   = { "", "DirectoryIconsColorDotEnv" },
    -- ["package.json"]   = { "", "DirectoryIconsColorPackageJson" },
    -- ["package-lock.json"] = { "", "DirectoryIconsColorPackageLockJson" },
    -- ["tsconfig.json"]  = { "", "DirectoryIconsColorTsconfig" },
    -- ["Cargo.toml"]     = { "", "DirectoryIconsColorCargoToml" },
    -- ["Cargo.lock"]     = { "", "DirectoryIconsColorCargoToml" },
    -- ["Gemfile"]        = { "", "DirectoryIconsColorGemfile" },
    -- ["Gemfile.lock"]   = { "", "DirectoryIconsColorGemfile" },
    -- ["Rakefile"]       = { "", "DirectoryIconsColorGemfile" },
    -- ["go.mod"]         = { "", "DirectoryIconsColorGoMod" },
    -- ["go.sum"]         = { "", "DirectoryIconsColorGoMod" },
    -- ["flake.nix"]      = { "", "DirectoryIconsColorFlakeNix" },
    -- ["flake.lock"]     = { "", "DirectoryIconsColorFlakeNix" },
    -- ["default.nix"]    = { "", "DirectoryIconsColorFlakeNix" },
    -- ["shell.nix"]      = { "", "DirectoryIconsColorFlakeNix" },
    -- ["LICENSE"]        = { "", "DirectoryIconsColorLicense" },
    -- ["LICENSE.md"]     = { "", "DirectoryIconsColorLicense" },
    -- ["LICENSE.txt"]    = { "", "DirectoryIconsColorLicense" },
    -- ["CHANGELOG.md"]   = { "", "DirectoryIconsColorChangelog" },
    -- ["README.md"]      = { "", "DirectoryIconsColorReadme" },
    -- ["README"]         = { "", "DirectoryIconsColorReadme" },
    -- [".prettierrc"]    = { "", "DirectoryIconsColorPrettier" },
    -- [".prettierignore"]= { "", "DirectoryIconsColorPrettier" },
    -- [".eslintrc"]      = { "", "DirectoryIconsColorEslint" },
    -- [".eslintrc.js"]   = { "", "DirectoryIconsColorEslint" },
    -- [".eslintrc.json"] = { "", "DirectoryIconsColorEslint" },
    ["webpack.config.js"]  = { "󰜫", "DirectoryIconsColorWebpack" },
    -- ["vite.config.js"]     = { "", "DirectoryIconsColorVite" },
    -- ["vite.config.ts"]     = { "", "DirectoryIconsColorVite" },
    ["tailwind.config.js"] = { "󱏿", "DirectoryIconsColorTailwind" },
    ["tailwind.config.ts"] = { "󱏿", "DirectoryIconsColorTailwind" },
    -- ["jest.config.js"]     = { "", "DirectoryIconsColorJest" },
    -- ["jest.config.ts"]     = { "", "DirectoryIconsColorJest" },
    ["docker-compose.yml"]      = { "󰡨", "DirectoryIconsColorDockerfile" },
    ["docker-compose.yaml"]     = { "󰡨", "DirectoryIconsColorDockerfile" },
    ["compose.yml"]             = { "󰡨", "DirectoryIconsColorDockerfile" },
    ["compose.yaml"]            = { "󰡨", "DirectoryIconsColorDockerfile" },
    -- [".rustfmt.toml"]           = { "", "DirectoryIconsColorRustfmt" },
    -- ["rustfmt.toml"]            = { "", "DirectoryIconsColorRustfmt" },
    -- ["clippy.toml"]             = { "", "DirectoryIconsColorRustfmt" },
    -- [".clippy.toml"]            = { "", "DirectoryIconsColorRustfmt" },
    -- ["deny.toml"]               = { "", "DirectoryIconsColorRustfmt" },
}

-- Directory name rules
local dir_map = {
    [".git"]     = { "󰊢", "DirectoryIconsColorDirGit" },
    -- [".github"]  = { "", "DirectoryIconsColorDirGithub" },
    [".vscode"]  = { "󰨞", "DirectoryIconsColorDirVscode" },
    -- [".idea"]    = { "", "DirectoryIconsColorDirIdea" },
    ["node_modules"] = { "󰎙", "DirectoryIconsColorDirNodeModules" },
    -- [".direnv"]  = { "", "DirectoryIconsColorDirGeneric" },
    -- ["target"]   = { "", "DirectoryIconsColorDirTarget" },
    -- ["build"]    = { "", "DirectoryIconsColorDirGeneric" },
    -- ["dist"]     = { "", "DirectoryIconsColorDirGeneric" },
    -- ["out"]      = { "", "DirectoryIconsColorDirGeneric" },
    -- ["bin"]      = { "", "DirectoryIconsColorDirGeneric" },
    -- ["src"]      = { "", "DirectoryIconsColorDirGeneric" },
    -- ["lib"]      = { "", "DirectoryIconsColorDirGeneric" },
    -- ["test"]     = { "", "DirectoryIconsColorDirGeneric" },
    -- ["tests"]    = { "", "DirectoryIconsColorDirGeneric" },
    -- ["spec"]     = { "", "DirectoryIconsColorDirGeneric" },
    -- ["docs"]     = { "", "DirectoryIconsColorDirGeneric" },
    -- ["doc"]      = { "", "DirectoryIconsColorDirGeneric" },
    -- ["assets"]   = { "", "DirectoryIconsColorDirGeneric" },
    -- ["static"]   = { "", "DirectoryIconsColorDirGeneric" },
    -- ["public"]   = { "", "DirectoryIconsColorDirGeneric" },
    -- ["config"]   = { "", "DirectoryIconsColorDirGeneric" },
    -- ["scripts"]  = { "", "DirectoryIconsColorDirGeneric" },
    -- [".config"]  = { "", "DirectoryIconsColorDirGeneric" },
    -- ["vendor"]   = { "", "DirectoryIconsColorDirGeneric" },
    -- ["tmp"]      = { "", "DirectoryIconsColorDirGeneric" },
    -- [".cache"]   = { "", "DirectoryIconsColorDirGeneric" },
    -- [".local"]   = { "", "DirectoryIconsColorDirGeneric" },
    -- [".cargo"]   = { "", "DirectoryIconsColorDirCargo" },
    -- [".rustup"]  = { "", "DirectoryIconsColorDirCargo" },
    -- ["nix"]      = { "", "DirectoryIconsColorDirNix" },
    -- [".nix-defexpr"] = { "", "DirectoryIconsColorDirNix" },
}

local function resolve(filename, is_directory)
    if is_directory then
        local entry = dir_map[filename]
        if entry then
            return entry[1], entry[2]
        end
        return DEFAULT_DIR_ICON, TOKEN_DEFAULT_DIR
    end

    local name_entry = name_map[filename]
    if name_entry then
        return name_entry[1], name_entry[2]
    end

    local ext = filename:match("%.([^%.]+)$")
    if ext then
        ext = ext:lower()
        local ext_entry = ext_map[ext]
        if ext_entry then
            return ext_entry[1], ext_entry[2]
        end
    end

    return DEFAULT_FILE_ICON, TOKEN_DEFAULT_FILE
end

local ansi_cache = {}
local function get_ansi(hex)
    local cached = ansi_cache[hex]
    if cached then
        return cached
    end
    local ansi = hex_to_ansi(hex)
    ansi_cache[hex] = ansi
    return ansi
end

function M.setup()
    -- Register token defaults (set only if not already present from a theme plugin)
    if y and y.theme then
        for token, default_hex in pairs(token_defaults) do
            if not y.theme[token] or y.theme[token] == "" then
                y.theme[token] = default_hex
            end
        end
    end

    y.hook.on_window_create:add(function(ctx)
        if ctx.type == "directory" then
            ctx.parent.prefix_column_width = 2
            ctx.current.prefix_column_width = 2
        end
    end)

    y.hook.on_window_change:add(function(ctx)
        if ctx.preview_is_directory then
            ctx.preview.prefix_column_width = 2
        else
            ctx.preview.prefix_column_width = 0
        end
    end)

    y.hook.on_bufferline_mutate:add(function(ctx)
        if ctx.buffer.type ~= "directory" then
            return
        end

        local content = ctx.content or ""
        local is_directory = content:sub(-1) == "/"

        local filename = content
        if is_directory then
            filename = content:sub(1, -2)
        end

        local stripped = filename:gsub("\27%[[%d;]*m", "")
        local icon, token = resolve(stripped, is_directory)

        -- Resolve color from theme token
        local color = y.theme[token] or token_defaults[token] or "#6d8086"
        local ansi_color = get_ansi(color)

        ctx.prefix = ansi_color .. icon .. ANSI_RESET
        ctx.content = ansi_color .. content .. ANSI_RESET
    end)
end

return M
