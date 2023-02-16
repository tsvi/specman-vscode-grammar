#!//usr/bin/python3
import argparse
import filecmp
import shlex
import shutil
import subprocess
from pathlib import Path

SRC_DIR = Path("syntaxes")
TMP_DIR = Path("tmp")
TEMPLATE_FILE = SRC_DIR / "specman.tmLanguage.json.j2"
VARIABLES_FILE = SRC_DIR / "variables.yaml"
FINAL_FILE = Path("specman.tmLanguage.json")
JINJA_CMD = "jinja"


def check_for_variables(filepath):
    contents = filepath.read_text()
    if "{{" in contents:
        return True
    return False


def generate():
    print("Generating language files... Initial run.", end=" ")
    TMP_DIR.mkdir(parents=True, exist_ok=True)
    outfile = TMP_DIR / FINAL_FILE
    cmd = f"{JINJA_CMD} -d {VARIABLES_FILE} {TEMPLATE_FILE} -o {outfile}"
    subprocess.run(shlex.split(cmd), stderr=subprocess.STDOUT, check=True)
    counter = 1

    while check_for_variables(outfile) is True and counter < 10:
        print(f"{counter},", end=" ")
        tmpfile = TMP_DIR / f"{FINAL_FILE.name}.{counter}"
        shutil.copyfile(outfile, tmpfile)
        cmd = f"{JINJA_CMD} -d {VARIABLES_FILE} {tmpfile} -o {outfile}"
        subprocess.run(shlex.split(cmd), stderr=subprocess.STDOUT, check=True)
        counter += 1

    print("Generation completed")


def main():
    parser = argparse.ArgumentParser("Build script")
    parser.add_argument(
        "--validate",
        action="store_true",
        default=False,
        help="Generate a temporary file and validate its result",
    )
    args = parser.parse_args()
    generate()
    if args.validate:
        comp = filecmp.cmp(TMP_DIR / FINAL_FILE, SRC_DIR / FINAL_FILE)
        comp_string = " " if comp else " not "
        print(f"Files are{comp_string}the same")
        exit(not comp)
    # If not validating
    shutil.copyfile(TMP_DIR / FINAL_FILE, SRC_DIR / FINAL_FILE)


if __name__ == "__main__":
    main()
