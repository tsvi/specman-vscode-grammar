#!//usr/bin/python3
import shlex
import shutil
import subprocess
from pathlib import Path

SRC_DIR = Path("syntaxes")
TMP_DIR = Path("tmp")
TEMPLATE_FILE = SRC_DIR / "specman.tmLanguage.json.j2" 
VARIABLES_FILE = SRC_DIR / "variables.yaml"
FINAL_FILE = SRC_DIR / "specman.tmLanguage.json"
JINJA_CMD = "jinja"

def check_for_variables(filepath):
    contents = filepath.read_text()
    if "{{" in contents:
        return True
    return False

def generate():
    print("Generating language files... Initial run.", end=" ")
    TMP_DIR.mkdir(parents=True, exist_ok=True)
    cmd = f"{JINJA_CMD} -d {VARIABLES_FILE} {TEMPLATE_FILE} -o {FINAL_FILE}"
    subprocess.run(shlex.split(cmd), stderr=subprocess.STDOUT, check=True)
    counter = 1
    
    while check_for_variables(FINAL_FILE) is True and counter < 10:
        print(f"{counter},", end=" ")
        tmpfile = TMP_DIR / f"{FINAL_FILE.name}.{counter}"
        shutil.copyfile(FINAL_FILE, tmpfile)
        cmd = f"{JINJA_CMD} -d {VARIABLES_FILE} {tmpfile} -o {FINAL_FILE}"
        subprocess.run(shlex.split(cmd), stderr=subprocess.STDOUT, check=True)
        counter += 1

    print("Generation completed")

if __name__ == "__main__":
    generate()
