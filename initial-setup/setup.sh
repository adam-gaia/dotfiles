#!/usr/bin/env bash
set -Eeuo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "This script may only be ran as root (use sudo)."
  exit 1
fi

THIS_PROGRAM_NAME="$(basename "$0")"

function print_help_message() {
  fmt <<EOF
Usage: ${THIS_PROGRAM_NAME} [--help] [--debug] DISK

Format and partition DISK for NixOS with LUKS encryption and btrfs as popularized by Graham Christensen's post [Erase your darlings](https://grahamc.com/blog/erase-your-darlings) and expanded on by mt-caret in [Encrypted Btrfs Root with Opt-in State on NixOS](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html).
EOF
}

DEBUG=1
while [[ $# -gt 0 ]]; do
  arg="$1"
  case "${arg}" in
  '--help' | '-h')
    print_help_message
    exit 0
    ;;

  '--debug' | '-d')
    set -x
    DEBUG=1
    ;;

  '--git' | '-g')
    if [[ $# -lt 2 ]]; then
      echo "Error '--git' option requires a username and email"
      exit 1
    fi
    shift # Move off of '--git'
    git_username="$1"
    shift # Move off of git_username
    git_email="$1"
    git config --global user.name "${git_username}"
    git config --global user.email "${git_email}"
    git config --global --add safe.directory "${PWD}"
    ;;

  *)
    # Any args without a prefix '-' ends option parsing
    break
    ;;
  esac
  shift # Move onto next arg
done

if [[ $# -ne 2 ]]; then
  echo "Hostname and device must be specified. Run '${THIS_PROGRAM_NAME} --help' for more info"
  exit 1
fi

HOSTNAME="$1"
DISK="$2"

RED='\033[0;31m'
YELLOW='\033[0;93m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
END_COLOR='\033[0m'
INDENT='  - '

pprint() {
  local final_char='\n'
  local color="${END_COLOR}"
  local message=("$@")
  local indent=''
  local fd=1
  local this_function_name="$0"

  while [[ $# -gt 0 ]]; do
    local arg="$1"
    case "${arg}" in
    '--help' | '-h')
      echo "TODO: help message for pprint function"
      return 1
      ;;

    '--color' | '-c')
      # The next argument is the color choice
      if [[ $# -eq 1 ]]; then
        echo "${this_function_name} error: color choice required after the '--color/-c' option"
        return 1
      fi
      shift
      color="$1"
      ;;

    '--no-newline' | '-n')
      final_char=''
      ;;

    '--indent' | '-i')
      # The next argument is the indentation
      if [[ $# -eq 1 ]]; then
        echo "${this_function_name} error: indent character(s) required after the '--indent/-i' option"
      fi
      shift
      indent="$1"
      ;;

    '--stdout')
      fd='2'
      ;;

    '--')
      # Any args following '--' are considered part of the message
      shift
      message="$*"
      break # Breaking here will stop us from hitting the '*' case with any other args. This way, we can print arguments that start with '-' without trying to parse as a registered option
      ;;

    *)
      if [[ ${arg::1} == '-' ]]; then
        echo "${this_function_name} error: unknown option '${arg}'. If your string starts with '-', then run 'pprint -- <your string>'"
        return 1
      else
        # We can assume we've hit the first of our message to print (no more option args to parse)
        break
      fi
      ;;
    esac
    shift # Move onto next arg

  done

  eval "printf '${color}${indent}%s${END_COLOR}${final_char}' '$*' >&${fd}"
}

function print_red() {
  pprint --color "${RED}" "${@}"
}

function print_yellow() {
  pprint --color "${YELLOW}" "${@}"
}

function print_green() {
  pprint --color "${GREEN}" "${@}"
}

function print_blue() {
  pprint --color "${BLUE}" "${@}"
}

function status() {
  print_blue "> ${*}"
}

function substatus() {
  pprint --indent "${INDENT}" "${@}"
}

# Commands to test pprint by visually inspecting output
#pprint --stdout this message printed to stdout
#print_red asdf
#print_yellow asdf
#print_green asdf
#print_blue asdf
#echo ''
#status asdf
#substatus -n asdf1
#echo x
#substatus -n asdf2
#echo x
#echo ''
#pprint -- --indent asdf --color asdf
#pprint --color "${BLUE}" -- --indent asdf
#pprint --asdf # will fail
#exit 0

status "Setting hostname to '${HOSTNAME}'"
hostname "${HOSTNAME}"

function assert_installed() {
  local dep="$1"
  substatus -n "${dep} "
  dep_path="$(command -v "${dep}")" # This can't be a local var, otherwise our $dep_found becomes the return code of the 'local' call which is probably always 0
  local dep_found="$?"
  if [[ ${dep_found} -eq '0' ]]; then
    echo "${dep_path}"
  else
    echo "not found"
  fi
  unset dep_path # Unset the global var since we couldn't set it as a local var
  return "${dep_found}"
}

dependencies=(sudo hostname btrfs fdisk mount parted)
status "Checking for dependencies"
missing_dep=0
for dep in "${dependencies[@]}"; do
  if ! assert_installed "${dep}"; then
    missing_dep=1
  fi
done

if [[ ${missing_dep} -eq 1 ]]; then
  print_red "One or more missing dependencies"
  exit 1
fi

status "Confirm continuation"
PS3='Enter choice number: '
status "Are you sure you want to continue with format ${DISK}?"
select user_selection in 'Yes' 'No'; do
  case "${user_selection}" in
  'Yes')
    # Continue on to the next step
    break
    ;;
  'No')
    print_yellow "Aborting at user request"
    exit 1
    ;;
  esac
done

BOOT_PARTITION_NUMBER='1'
SWAP_PARTITION_NUMBER='2'
ROOT_PARTITION_NUMBER='3'
BOOT_PARTITION="${DISK}p${BOOT_PARTITION_NUMBER}"
SWAP_PARTITION="${DISK}p${SWAP_PARTITION_NUMBER}"
ROOT_PARTITION="${DISK}p${ROOT_PARTITION_NUMBER}"
ENCRYPTED_DEV_NAME='enc'

status "Unmounting and closing devices"
# Disable all swap files
swapoff -a

# Unmount all mountpoints
MOUNTS=($(find /mnt))
for mount_point in "${MOUNTS[@]}"; do
  umount "${mount_point}" || true # Ok to fail (not mounted)
done
umount /mnt || true # Ok to fail (not mounted)

# Close encrypted device
cryptsetup luksClose "${ENCRYPTED_DEV_NAME}" || true # Ok to fail if dev is not open

echo ''
status "Creating partitions"

# Create partitions by piping commands to fdisk
# Comments are removed by the sed command
# Blank lines send a newline (enter key) to fdisk
# Taken from https://superuser.com/a/984637
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' <<EOF | fdisk ${DISK}
  o # clear the in memory partition table
  g # GPT type
  n # new partition
  "${BOOT_PARTITION_NUMBER}" # partition number
    # default - start at beginning of disk
  +512M # 512 MB boot partition
  t # set type
  1 # Pick the first type (EFI)
  n # new partition
  "${SWAP_PARTITION_NUMBER}" # partition number
    # default, start immediately after last partition
  +8G # 8GB partition size 
  n # new partition
  "${ROOT_PARTITION_NUMBER}" # partition number
    # default - start immediately after last partition
    # default - extend partition to end of disk
  p # print the in-memory partition table
  w # write the partition table
  q # quit
EOF

status "Encrypting root partition"
cryptsetup --verify-passphrase -v luksFormat "${ROOT_PARTITION}"

status "Unlock root partition"
cryptsetup open "${ROOT_PARTITION}" ${ENCRYPTED_DEV_NAME}

status "Formatting partitions"
mkfs.fat -n boot "${BOOT_PARTITION}"
mkswap "${SWAP_PARTITION}"
swapon "${SWAP_PARTITION}"
mkfs.btrfs "/dev/mapper/${ENCRYPTED_DEV_NAME}"

status "Creating and mounting subvolumes"
mount -t btrfs "/dev/mapper/${ENCRYPTED_DEV_NAME}" /mnt

# We first create the subvolumes outlined above:
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log

# We then take an empty *readonly* snapshot of the root subvolume,
# which we'll eventually rollback to on every boot.
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount /mnt

mount -o subvol=root,compress=zstd,noatime /dev/mapper/enc /mnt

mkdir /mnt/home
mount -o subvol=home,compress=zstd,noatime /dev/mapper/enc /mnt/home

mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/enc /mnt/nix

mkdir /mnt/persist
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/enc /mnt/persist

mkdir -p /mnt/var/log
mount -o subvol=log,compress=zstd,noatime /dev/mapper/enc /mnt/var/log

mkdir /mnt/boot
mount "${BOOT_PARTITION}" /mnt/boot

status "Generating NixOS hardware config"
nixos-generate-config --root /mnt

status "Copying over system config"
cp ./initial-configuration.nix /mnt/etc/nixos/configuration.nix

status "Done"
