#!/usr/bin/env python3
from pathlib import Path
from datetime import datetime
import yaml
import os
import logging
# TODO: determine scope. Where does the initial setup script end and this begin?
# TODO: only use OSX keychain cred helper on mac. Figure out how to use something else on linux


# -------------- Global vars --------------
HOME = Path(os.environ["HOME"])
DOTFILE_DIR = Path('.').resolve()
MANIFEST = DOTFILE_DIR/"manifest.yaml"
CONFIG_DIR = HOME/".config"
CONFIG_DIR.mkdir(exist_ok=True, parents=True)
BACKUP_DIR = HOME/".dotfile-backup"
BACKUP_DIR.mkdir(exist_ok=True, parents=True)


# -------------- Logging setup --------------
logging.basicConfig(format='%(levelname)s:  %(message)s', level=logging.DEBUG)
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)


# -------------- Functions --------------
def mv(src: Path, dest: Path):
    contents = src.read_text()
    dest.write_text(contents)
    src.unlink()


def link(source_path: Path, target_path: Path):
    try:
        if not source_path.is_file():
            logger.error(f"Source file '{source_path}' does not exist")
            return

        name = source_path.name
        # Create a time stamp for backing up the old file
        time_stamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        backup_file = BACKUP_DIR/f"{name}_{time_stamp}.backup"

        # Check if target already exists (implicitly checks if symlinks are valid)
        if target_path.exists():

            # Check if target is a link
            if target_path.is_symlink():

                # If the link points to source_path we don't need to do any work
                if target_path.resolve() == source_path.resolve():
                    logging.info(f"'{target_path}' is already linked to '{source_path}'")
                    return

                # Otherwise we need to back up by moving whatever the link points to and remove the link itself
                mv(target_path.resolve(), backup_file)
                target_path.unlink()

            else:
                # Otherwise we need to back up the file
                mv(target_path, backup_file)

            logging.info(f"Backed up '{target_path}' to '{backup_file}'")

        elif target_path.is_symlink():
            # Remove any invalid symlinks
            target_path.unlink(missing_ok=True)

        # Create the directory for our target if needed
        target_path.parent.mkdir(exist_ok=True, parents=True)

        # Make a link to our source_path
        target_path.symlink_to(source_path)
        logging.info(f"Linked '{source_path}' to '{target_path}'")

    except Exception as e:
        logging.error(f"Error linking '{source_path}' to '{target_path}'\n    Error message: {e}")


def main():
    # Read manifest
    with open(MANIFEST, 'r') as f:
        contents = yaml.safe_load(f)

        # Loop over sub directories and their contents defined in the manifest
        for group_name, links_to_make in contents.items():
            directory = MANIFEST.parent / group_name
            if not directory.is_dir():
                logger.error(f"Dotfile sub directory '{directory}' does not exist")
                continue

            # Loop over files to link
            for files in links_to_make:
                source = files["src"]
                targets = files["links"]
                if not isinstance(targets, list) or not isinstance(targets[0], str):
                    raise Exception(f"Invalid manifest syntax at {group_name}:{source}")
                for target in targets:
                    # TODO: create a function to process paths with variable replace
                    var_replaced_source = source.replace("${HOME}", HOME.as_posix()).replace("${CONFIG_DIR}", CONFIG_DIR.as_posix())
                    source_path: Path = DOTFILE_DIR / group_name / var_replaced_source

                    var_replaced_target = target.replace("${HOME}", HOME.as_posix()).replace("${CONFIG_DIR}", CONFIG_DIR.as_posix())
                    target_path: Path = Path(var_replaced_target)

                    link(source_path, target_path)


# -------------- Main --------------
if __name__ == "__main__":
    main()
