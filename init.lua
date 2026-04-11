local M = {}

-- ANSI foreground escape helper: "\27[38;2;R;G;Bm"
local function hex_to_ansi(hex)
    hex = hex:gsub("^#", "")
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    return string.format("\27[38;2;%d;%d;%dm", r, g, b)
end

-- Default fallback colors
local DEFAULT_FILE_COLOR = "#6d8086"
local DEFAULT_DIR_COLOR = "#8caaee"

-- Icon mappings: { glyph, hex_color }
-- Extension-based rules
local ext_map = {
    ["lua"]    = { "", "#51a0cf" },
    ["rs"]     = { "", "#dea584" },
    ["toml"]   = { "", "#6d8086" },
    ["yaml"]   = { "", "#6d8086" },
    ["yml"]    = { "", "#6d8086" },
    ["json"]   = { "", "#cbcb41" },
    ["md"]     = { "", "#519aba" },
    ["txt"]    = { "󰈙", "#89e051" },
    ["sh"]     = { "", "#4d5a5e" },
    ["bash"]   = { "", "#4d5a5e" },
    ["zsh"]    = { "", "#4d5a5e" },
    ["fish"]   = { "", "#4d5a5e" },
    ["py"]     = { "", "#ffbc03" },
    ["js"]     = { "", "#cbcb41" },
    ["mjs"]    = { "", "#cbcb41" },
    ["cjs"]    = { "", "#cbcb41" },
    ["ts"]     = { "", "#519aba" },
    ["tsx"]    = { "", "#1354bf" },
    ["jsx"]    = { "", "#20c2e3" },
    ["html"]   = { "", "#e44d26" },
    ["htm"]    = { "", "#e44d26" },
    ["css"]    = { "", "#42a5f5" },
    ["scss"]   = { "", "#f55385" },
    ["sass"]   = { "", "#f55385" },
    ["less"]   = { "", "#563d7c" },
    ["vue"]    = { "", "#8dc149" },
    ["svelte"] = { "", "#ff3e00" },
    ["go"]     = { "", "#519aba" },
    ["rb"]     = { "", "#701516" },
    ["php"]    = { "", "#a074c4" },
    ["java"]   = { "", "#cc3e44" },
    ["kt"]     = { "", "#7f52ff" },
    ["kts"]    = { "", "#7f52ff" },
    ["swift"]  = { "", "#e37933" },
    ["c"]      = { "", "#599eff" },
    ["h"]      = { "", "#a074c4" },
    ["cpp"]    = { "", "#f34b7d" },
    ["hpp"]    = { "", "#a074c4" },
    ["cc"]     = { "", "#f34b7d" },
    ["hh"]     = { "", "#a074c4" },
    ["cs"]     = { "󰌛", "#596706" },
    ["fs"]     = { "", "#519aba" },
    ["fsx"]    = { "", "#519aba" },
    ["ex"]     = { "", "#a074c4" },
    ["exs"]    = { "", "#a074c4" },
    ["erl"]    = { "", "#b83998" },
    ["hs"]     = { "", "#a074c4" },
    ["ml"]     = { "", "#e37933" },
    ["mli"]    = { "", "#e37933" },
    ["clj"]    = { "", "#8dc149" },
    ["cljs"]   = { "", "#8dc149" },
    ["scala"]  = { "", "#cc3e44" },
    ["r"]      = { "󰟔", "#2266ba" },
    ["jl"]     = { "", "#a270ba" },
    ["nim"]    = { "", "#f3d400" },
    ["zig"]    = { "", "#f69a1b" },
    ["dart"]   = { "", "#03589c" },
    ["sql"]    = { "", "#dad8d8" },
    ["graphql"]= { "", "#e10098" },
    ["gql"]    = { "", "#e10098" },
    ["proto"]  = { "", "#6d8086" },
    ["xml"]    = { "󰗀", "#e44d26" },
    ["svg"]    = { "󰜡", "#ffb13b" },
    ["png"]    = { "", "#a074c4" },
    ["jpg"]    = { "", "#a074c4" },
    ["jpeg"]   = { "", "#a074c4" },
    ["gif"]    = { "", "#a074c4" },
    ["ico"]    = { "", "#cbcb41" },
    ["webp"]   = { "", "#a074c4" },
    ["bmp"]    = { "", "#a074c4" },
    ["mp3"]    = { "", "#d39ede" },
    ["flac"]   = { "", "#d39ede" },
    ["wav"]    = { "", "#d39ede" },
    ["ogg"]    = { "", "#d39ede" },
    ["mp4"]    = { "", "#fd971f" },
    ["mkv"]    = { "", "#fd971f" },
    ["avi"]    = { "", "#fd971f" },
    ["mov"]    = { "", "#fd971f" },
    ["webm"]   = { "", "#fd971f" },
    ["pdf"]    = { "", "#b30b00" },
    ["doc"]    = { "󰈬", "#185abd" },
    ["docx"]   = { "󰈬", "#185abd" },
    ["xls"]    = { "󰈛", "#207245" },
    ["xlsx"]   = { "󰈛", "#207245" },
    ["ppt"]    = { "󰈧", "#cb4a32" },
    ["pptx"]   = { "󰈧", "#cb4a32" },
    ["zip"]    = { "", "#eca517" },
    ["tar"]    = { "", "#eca517" },
    ["gz"]     = { "", "#eca517" },
    ["bz2"]    = { "", "#eca517" },
    ["xz"]     = { "", "#eca517" },
    ["7z"]     = { "", "#eca517" },
    ["rar"]    = { "", "#eca517" },
    ["deb"]    = { "", "#eca517" },
    ["rpm"]    = { "", "#eca517" },
    ["nix"]    = { "", "#7ebae4" },
    ["lock"]   = { "", "#6d8086" },
    ["conf"]   = { "", "#6d8086" },
    ["cfg"]    = { "", "#6d8086" },
    ["ini"]    = { "", "#6d8086" },
    ["env"]    = { "", "#faf743" },
    ["log"]    = { "󰌱", "#6d8086" },
    ["diff"]   = { "", "#41535b" },
    ["patch"]  = { "", "#41535b" },
    ["vim"]    = { "", "#019833" },
    ["org"]    = { "", "#77aa99" },
    ["tf"]     = { "", "#5f43e9" },
    ["hcl"]    = { "", "#5f43e9" },
    ["sol"]    = { "", "#519aba" },
    ["wasm"]   = { "", "#654ff0" },
    ["asm"]    = { "", "#6d8086" },
    ["s"]      = { "", "#6d8086" },
    ["ttf"]    = { "", "#ececec" },
    ["otf"]    = { "", "#ececec" },
    ["woff"]   = { "", "#ececec" },
    ["woff2"]  = { "", "#ececec" },
    ["eot"]    = { "", "#ececec" },
}

-- Exact filename rules (checked before extension)
local name_map = {
    ["Makefile"]       = { "", "#6d8086" },
    ["CMakeLists.txt"] = { "", "#6d8086" },
    ["Dockerfile"]     = { "󰡨", "#384d54" },
    ["Containerfile"]  = { "󰡨", "#384d54" },
    [".dockerignore"]  = { "󰡨", "#384d54" },
    [".gitignore"]     = { "", "#f14c28" },
    [".gitmodules"]    = { "", "#f14c28" },
    [".gitattributes"] = { "", "#f14c28" },
    [".editorconfig"]  = { "", "#fff2f0" },
    [".env"]           = { "", "#faf743" },
    [".env.local"]     = { "", "#faf743" },
    [".env.example"]   = { "", "#faf743" },
    ["package.json"]   = { "", "#e8274b" },
    ["package-lock.json"] = { "", "#7a0d21" },
    ["tsconfig.json"]  = { "", "#519aba" },
    ["Cargo.toml"]     = { "", "#dea584" },
    ["Cargo.lock"]     = { "", "#dea584" },
    ["Gemfile"]        = { "", "#701516" },
    ["Gemfile.lock"]   = { "", "#701516" },
    ["Rakefile"]       = { "", "#701516" },
    ["go.mod"]         = { "", "#519aba" },
    ["go.sum"]         = { "", "#519aba" },
    ["flake.nix"]      = { "", "#7ebae4" },
    ["flake.lock"]     = { "", "#7ebae4" },
    ["default.nix"]    = { "", "#7ebae4" },
    ["shell.nix"]      = { "", "#7ebae4" },
    ["LICENSE"]        = { "", "#d0bf41" },
    ["LICENSE.md"]     = { "", "#d0bf41" },
    ["LICENSE.txt"]    = { "", "#d0bf41" },
    ["CHANGELOG.md"]   = { "", "#6d8086" },
    ["README.md"]      = { "", "#519aba" },
    ["README"]         = { "", "#519aba" },
    [".prettierrc"]    = { "", "#56b3b4" },
    [".prettierignore"]= { "", "#56b3b4" },
    [".eslintrc"]      = { "", "#4b32c3" },
    [".eslintrc.js"]   = { "", "#4b32c3" },
    [".eslintrc.json"] = { "", "#4b32c3" },
    ["webpack.config.js"]  = { "󰜫", "#519aba" },
    ["vite.config.js"]     = { "", "#ffab00" },
    ["vite.config.ts"]     = { "", "#ffab00" },
    ["tailwind.config.js"] = { "󱏿", "#38bdf8" },
    ["tailwind.config.ts"] = { "󱏿", "#38bdf8" },
    ["jest.config.js"]     = { "", "#99425b" },
    ["jest.config.ts"]     = { "", "#99425b" },
    ["docker-compose.yml"]      = { "󰡨", "#384d54" },
    ["docker-compose.yaml"]     = { "󰡨", "#384d54" },
    ["compose.yml"]             = { "󰡨", "#384d54" },
    ["compose.yaml"]            = { "󰡨", "#384d54" },
    [".rustfmt.toml"]           = { "", "#dea584" },
    ["rustfmt.toml"]            = { "", "#dea584" },
    ["clippy.toml"]             = { "", "#dea584" },
    [".clippy.toml"]            = { "", "#dea584" },
    ["deny.toml"]               = { "", "#dea584" },
}

-- Directory name rules
local dir_map = {
    [".git"]     = { "", "#f14c28" },
    [".github"]  = { "", "#6d8086" },
    [".vscode"]  = { "󰨞", "#007acc" },
    [".idea"]    = { "", "#cc3e44" },
    ["node_modules"] = { "", "#e8274b" },
    [".direnv"]  = { "", "#6d8086" },
    ["target"]   = { "", "#dea584" },
    ["build"]    = { "", "#6d8086" },
    ["dist"]     = { "", "#6d8086" },
    ["out"]      = { "", "#6d8086" },
    ["bin"]      = { "", "#6d8086" },
    ["src"]      = { "", "#6d8086" },
    ["lib"]      = { "", "#6d8086" },
    ["test"]     = { "", "#6d8086" },
    ["tests"]    = { "", "#6d8086" },
    ["spec"]     = { "", "#6d8086" },
    ["docs"]     = { "", "#6d8086" },
    ["doc"]      = { "", "#6d8086" },
    ["assets"]   = { "", "#6d8086" },
    ["static"]   = { "", "#6d8086" },
    ["public"]   = { "", "#6d8086" },
    ["config"]   = { "", "#6d8086" },
    ["scripts"]  = { "", "#6d8086" },
    [".config"]  = { "", "#6d8086" },
    ["vendor"]   = { "", "#6d8086" },
    ["tmp"]      = { "", "#6d8086" },
    [".cache"]   = { "", "#6d8086" },
    [".local"]   = { "", "#6d8086" },
    [".cargo"]   = { "", "#dea584" },
    [".rustup"]  = { "", "#dea584" },
    ["nix"]      = { "", "#7ebae4" },
    [".nix-defexpr"] = { "", "#7ebae4" },
}

-- Default icons
local DEFAULT_FILE_ICON = ""
local DEFAULT_DIR_ICON = ""

-- Resolve icon and color for a filename
local function resolve(filename, is_directory)
    if is_directory then
        local entry = dir_map[filename]
        if entry then
            return entry[1], entry[2]
        end
        return DEFAULT_DIR_ICON, DEFAULT_DIR_COLOR
    end

    -- Check exact filename first
    local name_entry = name_map[filename]
    if name_entry then
        return name_entry[1], name_entry[2]
    end

    -- Check extension
    local ext = filename:match("%.([^%.]+)$")
    if ext then
        ext = ext:lower()
        local ext_entry = ext_map[ext]
        if ext_entry then
            return ext_entry[1], ext_entry[2]
        end
    end

    return DEFAULT_FILE_ICON, DEFAULT_FILE_COLOR
end

-- Pre-compute ANSI cache for performance on large directories
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
    -- Set icon column width for directory windows
    y.hook.on_window_create:add(function(ctx)
        if ctx.type == "directory" then
            ctx.parent.icon_column_width = 1
            ctx.current.icon_column_width = 1
            ctx.preview.icon_column_width = 1
        end
    end)

    -- Mutate bufferlines with icon and color
    y.hook.on_bufferline_mutate:add(function(ctx)
        local icon, color = resolve(ctx.filename, ctx.is_directory)
        ctx.icon = icon
        ctx.icon_style = get_ansi(color)
    end)
end

M.setup()

return M
