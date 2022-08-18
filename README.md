# ProTanki Client Chainloader

[![Discord](https://img.shields.io/discord/1001791048651120692?label=Discord)](https://discord.gg/Jk8TFZpeZE)

The chainloader is a small SWF file that loads the ProTanki's `library.swf`.
It skips the loading of `StandaloneLoader.swf`, `Prelauncher.swf` and `Loader.swf`.

## Usage

Various game options can be set in the query string.

| Key         | Description                 | Available options                                                                                              |
|-------------|-----------------------------|----------------------------------------------------------------------------------------------------------------|
| `library`   | The `library.swf` game file | Absolute local or remote URL.<br />Example:  _`D:/ProTanki/library.swf`_, _`https://example.org/library.swf`_. |
| `locale`    | Game language               | _`ru`_, _`en`_, _`pt_BR`_.<br />**Note**: _`pt_BR`_ is not supported by `protanki-server`.                     |
| `server`    | Game server endpoint        | TCP endpoint with port.<br />Example: _`127.0.0.1:1337`_, _`game.example.org:1337`_.                           |
| `resources` | Resource server base URL    | HTTP(S) URL.<br />Example: _`http://127.0.0.1:8080/resource`_, _`https://resources.example.org`_.              |

Example query string: `library=D:/ProTanki/library.swf&locale=en&server=127.0.0.1:1337&resources=http://127.0.0.1:8080/resource`.

## Download

Prebuilt binaries are available at [GitHub Releases](https://github.com/protanki-re/client-chainloader/releases).

## Building

#### Dependencies:

* [PowerShell](https://github.com/PowerShell/PowerShell)
* [Java](https://java.com/)
* [Adobe AIR SDK](https://archive.org/details/adobe-air-sdk-archived-older-versions)

### Using command line

```powershell
# Build to default location (without debug information)
./scripts/build.ps1 -SdkPath 'Path/to/Adobe/AIR/SDK'

# Build to default location (with debug information)
./scripts/build.ps1 -SdkPath 'Path/to/Adobe/AIR/SDK' -DebugBuild $true

# Build to custom location (without debug information)
./scripts/build.ps1 -SdkPath 'Path/to/Adobe/AIR/SDK' -OutputFile './build/custom-chainloader.swf'
```
