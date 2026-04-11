# Directory Icons

The `yeet-directory-icons` plugin adds file-type icons and color coding to directory buffers. Each file and directory entry gets a Nerd Font icon with a color derived from theme tokens.

## Setup

Register the plugin and call `setup()`:

```lua
y.plugin.register({ url = "https://github.com/aserowy/yeet-directory-icons" })
require('yeet-directory-icons').setup()
```

The plugin registers an `on_window_create` hook to set icon column width to `1` for directory windows, and an `on_bufferline_mutate` hook to assign icons and colors to each entry.

## How It Works

During `setup()`, the plugin:

1. Registers default values for all `DirectoryIconsColor*` theme tokens (only if not already set by a theme plugin).
2. Registers an `on_window_create` hook that sets `icon_column_width = 1` for directory panes.
3. Registers an `on_bufferline_mutate` hook that resolves icons and colors for directory entries.

During bufferline mutation, the plugin:

1. Checks `ctx.buffer.type` and only processes `"directory"` buffers.
2. Detects directories by trailing slash (`/`) in `ctx.content`.
3. Strips trailing slash and ANSI sequences to get a clean filename.
4. Resolves icon glyph and color token by checking filename rules, extension rules, and directory name rules.
5. Reads the color from `y.theme[token_name]`.
6. Sets `ctx.icon` to the colored icon glyph and `ctx.content` to the colored entry text.

## Theme Tokens

The plugin defines `DirectoryIconsColor*` theme tokens for every file extension, filename, and directory name in its rule set. Override any token via `y.theme` to customize colors.

### Token Naming Convention

Token names follow the pattern `DirectoryIconsColor<Identifier>`:

- Extensions: `DirectoryIconsColor<Ext>` (e.g., `DirectoryIconsColorRs`, `DirectoryIconsColorLua`)
- Filenames: `DirectoryIconsColor<Name>` (e.g., `DirectoryIconsColorCargoToml`, `DirectoryIconsColorDockerfile`)
- Directories: `DirectoryIconsColorDir<Name>` (e.g., `DirectoryIconsColorDirGit`, `DirectoryIconsColorDirGeneric`)
- Defaults: `DirectoryIconsColorDefaultFile`, `DirectoryIconsColorDefaultDirectory`

### Token Reference

| Token | Description | Default |
| --- | --- | --- |
| `DirectoryIconsColorDefaultFile` | Fallback color for unrecognized files | `#6d8086` |
| `DirectoryIconsColorDefaultDirectory` | Fallback color for unrecognized directories | `#8caaee` |
| `DirectoryIconsColorLua` | Lua source files (`.lua`) | `#51a0cf` |
| `DirectoryIconsColorRs` | Rust source files (`.rs`) | `#dea584` |
| `DirectoryIconsColorToml` | TOML files (`.toml`) | `#6d8086` |
| `DirectoryIconsColorYaml` | YAML files (`.yaml`, `.yml`) | `#6d8086` |
| `DirectoryIconsColorJson` | JSON files (`.json`) | `#cbcb41` |
| `DirectoryIconsColorMd` | Markdown files (`.md`) | `#519aba` |
| `DirectoryIconsColorTxt` | Text files (`.txt`) | `#89e051` |
| `DirectoryIconsColorSh` | Shell scripts (`.sh`, `.bash`, `.zsh`, `.fish`) | `#4d5a5e` |
| `DirectoryIconsColorPy` | Python files (`.py`) | `#ffbc03` |
| `DirectoryIconsColorJs` | JavaScript files (`.js`, `.mjs`, `.cjs`) | `#cbcb41` |
| `DirectoryIconsColorTs` | TypeScript files (`.ts`) | `#519aba` |
| `DirectoryIconsColorTsx` | TSX files (`.tsx`) | `#1354bf` |
| `DirectoryIconsColorJsx` | JSX files (`.jsx`) | `#20c2e3` |
| `DirectoryIconsColorHtml` | HTML files (`.html`, `.htm`) | `#e44d26` |
| `DirectoryIconsColorCss` | CSS files (`.css`) | `#42a5f5` |
| `DirectoryIconsColorScss` | SCSS/Sass files (`.scss`, `.sass`) | `#f55385` |
| `DirectoryIconsColorLess` | Less files (`.less`) | `#563d7c` |
| `DirectoryIconsColorVue` | Vue files (`.vue`) | `#8dc149` |
| `DirectoryIconsColorSvelte` | Svelte files (`.svelte`) | `#ff3e00` |
| `DirectoryIconsColorGo` | Go files (`.go`) | `#519aba` |
| `DirectoryIconsColorRb` | Ruby files (`.rb`) | `#701516` |
| `DirectoryIconsColorPhp` | PHP files (`.php`) | `#a074c4` |
| `DirectoryIconsColorJava` | Java files (`.java`) | `#cc3e44` |
| `DirectoryIconsColorKt` | Kotlin files (`.kt`, `.kts`) | `#7f52ff` |
| `DirectoryIconsColorSwift` | Swift files (`.swift`) | `#e37933` |
| `DirectoryIconsColorC` | C source files (`.c`) | `#599eff` |
| `DirectoryIconsColorH` | Header files (`.h`, `.hpp`, `.hh`) | `#a074c4` |
| `DirectoryIconsColorCpp` | C++ files (`.cpp`, `.cc`) | `#f34b7d` |
| `DirectoryIconsColorCs` | C# files (`.cs`) | `#596706` |
| `DirectoryIconsColorFs` | F# files (`.fs`, `.fsx`) | `#519aba` |
| `DirectoryIconsColorEx` | Elixir files (`.ex`, `.exs`) | `#a074c4` |
| `DirectoryIconsColorErl` | Erlang files (`.erl`) | `#b83998` |
| `DirectoryIconsColorHs` | Haskell files (`.hs`) | `#a074c4` |
| `DirectoryIconsColorMl` | OCaml files (`.ml`, `.mli`) | `#e37933` |
| `DirectoryIconsColorClj` | Clojure files (`.clj`, `.cljs`) | `#8dc149` |
| `DirectoryIconsColorScala` | Scala files (`.scala`) | `#cc3e44` |
| `DirectoryIconsColorR` | R files (`.r`) | `#2266ba` |
| `DirectoryIconsColorJl` | Julia files (`.jl`) | `#a270ba` |
| `DirectoryIconsColorNim` | Nim files (`.nim`) | `#f3d400` |
| `DirectoryIconsColorZig` | Zig files (`.zig`) | `#f69a1b` |
| `DirectoryIconsColorDart` | Dart files (`.dart`) | `#03589c` |
| `DirectoryIconsColorSql` | SQL files (`.sql`) | `#dad8d8` |
| `DirectoryIconsColorGraphql` | GraphQL files (`.graphql`, `.gql`) | `#e10098` |
| `DirectoryIconsColorProto` | Protocol Buffer files (`.proto`) | `#6d8086` |
| `DirectoryIconsColorXml` | XML files (`.xml`) | `#e44d26` |
| `DirectoryIconsColorSvg` | SVG files (`.svg`) | `#ffb13b` |
| `DirectoryIconsColorImage` | Image files (`.png`, `.jpg`, `.gif`, `.webp`, `.bmp`) | `#a074c4` |
| `DirectoryIconsColorIco` | Icon files (`.ico`) | `#cbcb41` |
| `DirectoryIconsColorAudio` | Audio files (`.mp3`, `.flac`, `.wav`, `.ogg`) | `#d39ede` |
| `DirectoryIconsColorVideo` | Video files (`.mp4`, `.mkv`, `.avi`, `.mov`, `.webm`) | `#fd971f` |
| `DirectoryIconsColorPdf` | PDF files (`.pdf`) | `#b30b00` |
| `DirectoryIconsColorDoc` | Word documents (`.doc`, `.docx`) | `#185abd` |
| `DirectoryIconsColorXls` | Excel files (`.xls`, `.xlsx`) | `#207245` |
| `DirectoryIconsColorPpt` | PowerPoint files (`.ppt`, `.pptx`) | `#cb4a32` |
| `DirectoryIconsColorArchive` | Archive files (`.zip`, `.tar`, `.gz`, `.7z`, `.rar`, etc.) | `#eca517` |
| `DirectoryIconsColorNix` | Nix files (`.nix`) | `#7ebae4` |
| `DirectoryIconsColorLock` | Lock files (`.lock`) | `#6d8086` |
| `DirectoryIconsColorConf` | Config files (`.conf`, `.cfg`, `.ini`) | `#6d8086` |
| `DirectoryIconsColorEnv` | Environment files (`.env`) | `#faf743` |
| `DirectoryIconsColorLog` | Log files (`.log`) | `#6d8086` |
| `DirectoryIconsColorDiff` | Diff/patch files (`.diff`, `.patch`) | `#41535b` |
| `DirectoryIconsColorVim` | Vim files (`.vim`) | `#019833` |
| `DirectoryIconsColorOrg` | Org files (`.org`) | `#77aa99` |
| `DirectoryIconsColorTerraform` | Terraform files (`.tf`, `.hcl`) | `#5f43e9` |
| `DirectoryIconsColorSol` | Solidity files (`.sol`) | `#519aba` |
| `DirectoryIconsColorWasm` | WebAssembly files (`.wasm`) | `#654ff0` |
| `DirectoryIconsColorAsm` | Assembly files (`.asm`, `.s`) | `#6d8086` |
| `DirectoryIconsColorFont` | Font files (`.ttf`, `.otf`, `.woff`, `.woff2`, `.eot`) | `#ececec` |
| `DirectoryIconsColorMakefile` | Makefiles | `#6d8086` |
| `DirectoryIconsColorCmake` | CMake files | `#6d8086` |
| `DirectoryIconsColorDockerfile` | Dockerfiles and compose files | `#384d54` |
| `DirectoryIconsColorGitignore` | Git config files (`.gitignore`, `.gitmodules`, `.gitattributes`) | `#f14c28` |
| `DirectoryIconsColorEditorconfig` | EditorConfig files | `#fff2f0` |
| `DirectoryIconsColorDotEnv` | Dotenv files (`.env`, `.env.local`, `.env.example`) | `#faf743` |
| `DirectoryIconsColorPackageJson` | `package.json` | `#e8274b` |
| `DirectoryIconsColorPackageLockJson` | `package-lock.json` | `#7a0d21` |
| `DirectoryIconsColorTsconfig` | `tsconfig.json` | `#519aba` |
| `DirectoryIconsColorCargoToml` | `Cargo.toml`, `Cargo.lock` | `#dea584` |
| `DirectoryIconsColorGemfile` | Ruby Gemfiles | `#701516` |
| `DirectoryIconsColorGoMod` | Go module files (`go.mod`, `go.sum`) | `#519aba` |
| `DirectoryIconsColorFlakeNix` | Nix flake files (`flake.nix`, `flake.lock`, `default.nix`, `shell.nix`) | `#7ebae4` |
| `DirectoryIconsColorLicense` | License files | `#d0bf41` |
| `DirectoryIconsColorChangelog` | Changelog files | `#6d8086` |
| `DirectoryIconsColorReadme` | README files | `#519aba` |
| `DirectoryIconsColorPrettier` | Prettier config files | `#56b3b4` |
| `DirectoryIconsColorEslint` | ESLint config files | `#4b32c3` |
| `DirectoryIconsColorWebpack` | Webpack config files | `#519aba` |
| `DirectoryIconsColorVite` | Vite config files | `#ffab00` |
| `DirectoryIconsColorTailwind` | Tailwind CSS config files | `#38bdf8` |
| `DirectoryIconsColorJest` | Jest config files | `#99425b` |
| `DirectoryIconsColorRustfmt` | Rust format/lint config files (`.rustfmt.toml`, `clippy.toml`, `deny.toml`) | `#dea584` |
| `DirectoryIconsColorDirGit` | `.git` directory | `#f14c28` |
| `DirectoryIconsColorDirGithub` | `.github` directory | `#6d8086` |
| `DirectoryIconsColorDirVscode` | `.vscode` directory | `#007acc` |
| `DirectoryIconsColorDirIdea` | `.idea` directory | `#cc3e44` |
| `DirectoryIconsColorDirNodeModules` | `node_modules` directory | `#e8274b` |
| `DirectoryIconsColorDirGeneric` | Common directories (`src`, `lib`, `test`, `docs`, `bin`, etc.) | `#6d8086` |
| `DirectoryIconsColorDirTarget` | `target` directory | `#dea584` |
| `DirectoryIconsColorDirCargo` | `.cargo`, `.rustup` directories | `#dea584` |
| `DirectoryIconsColorDirNix` | `nix`, `.nix-defexpr` directories | `#7ebae4` |

## Theme Plugin Priority

When a theme plugin (e.g., `yeet-bluloco-theme`) sets `DirectoryIconsColor*` tokens before this plugin runs `setup()`, the theme-provided values are preserved. This plugin only uses its own defaults when the theme has not set these tokens.

Load order determines priority: theme plugins loaded before `yeet-directory-icons` take precedence for all `DirectoryIconsColor*` tokens.

## Fallback Colors

When a file or directory does not match any specific icon rule, the plugin falls back to:

- `DirectoryIconsColorDefaultFile` for unrecognized files
- `DirectoryIconsColorDefaultDirectory` for unrecognized directories

Override these tokens to change the fallback colors:

```lua
y.theme.DirectoryIconsColorDefaultFile = "#abb2bf"
y.theme.DirectoryIconsColorDefaultDirectory = "#3691ff"
```

## Customizing Colors

Override individual file type colors in your `init.lua`:

```lua
y.theme.DirectoryIconsColorRs = "#ff6480"
y.theme.DirectoryIconsColorPy = "#f9c859"
y.theme.DirectoryIconsColorDirGit = "#ff936a"
```

## Without This Plugin

Without `yeet-directory-icons`, directory entries are plain unstyled text with no icons. The icon column width remains `0` (no space reserved).
