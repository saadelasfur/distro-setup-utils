# Distro Environment Setup

Shell-based automation for configuring development environments on various Linux platforms.


## Features

Android Development Tools included:

- **Magiskboot** – Boot image patching
- **Avbtool** – Android Verified Boot tool
- **Samfirm** – Samsung firmware downloader
- **Gitconfig setup** – Auto-configure your gitconfig
- **Android tools setup** – Installs a collection of Android modding and development utilities


## Supported Platforms

- Termux (native Android)
- Termux-proot (chrooted Termux)
- Ubuntu
- Additional distributions (e.g., Arch Linux, Fedora, MacOS) are planned for future support.


## Installation

You can install the setup using a one-liner that clones the repo automatically, or clone it manually for full control.

### Option 1: Quick Install (One-liner)

Automatically clones the repository and starts the setup with default options:

```bash
bash <(curl -s https://raw.githubusercontent.com/saadelasfur/distro-setup-utils/refs/heads/script/main.sh)
```

> This method clones the repo and runs the setup in one step, great for quick installations.


### Option 2: Manual Clone (For Customization)

Clone the repository yourself for full control:

```bash
git clone https://github.com/saadelasfur/distro-setup-utils.git
cd distro-setup-utils
bash setup_distro.sh
```

> Recommended if you plan to modify configuration files or reuse the setup multiple times.


## Configuration

Customize your setup by editing the following files:

### Main Configuration

- `configs/setup.sh` – Enable or disable components like:

  ```sh
  MAGISKBOOT=true
  MAGISKBOOT=false
  ```

### Platform-Specific Configs

- `configs/<platform>/config.sh` – Platform-specific settings
- `configs/<platform>/packages.sh` – Package list of the platform


## Project Structure

```
.
├── setup_distro.sh             # Main entry point for setup
├── configs/                    # Platform-specific configurations
│   ├── setup.sh                # Global feature toggles
│   └── <platform>/             # Each platform has its own config + package list
├── scripts/
│   ├── distro/                 # Platform-specific custom setup
│   ├── tools/                  # Tool-specific installers (e.g., Magiskboot, Avbtool)
│   └── utils/                  # Reusable utilities (logging, detection, etc.)
```


## Scripts Breakdown

### Distro Setup Scripts (`scripts/distro/`)
- `setup_<distro>.sh` – Initialize and configure distro-specific settings

### Tool Installers (`scripts/tools/`)
- `setup_android_tools.sh` – Installs common Android tools
- `setup_avbtool.sh` – Installs Avbtool
- `setup_gitconfig.sh` – Applies custom gitconfig
- `setup_magiskboot.sh` – Installs Magiskboot
- `setup_samfirm.sh` – Installs Samfirm downloader

### Utilities (`scripts/utils/`)
- `common_utils.sh` – Generic reusable helper functions
- `distro_utils.sh` – OS/platform detection and logic
- `log_utils.sh` – Color-coded logging functions


## Contributing

Contributions are welcome! Feel free to fork the repo, improve it, and open a pull request.


## License

This project is licensed under the **GNU General Public License v3.0**.
See the [LICENSE](LICENSE) file for more details.
