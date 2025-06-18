#!/usr/bin/env bash
set -euo pipefail

# Usage check
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <env-name> [<python-version-or-path>]"
  echo "  <env-name>                 Directory name for the new virtual environment"
  echo "  <python-version-or-path>   (optional) Python version or path (e.g. 3.11 or /usr/local/bin/python3.11)"
  exit 1
fi

ENV_NAME="$1"
PYTHON=${2:-}

# 1. Create the venv with uv
#    --python is optional; if omitted, uv picks the current interpreter
echo "Creating virtual environment '$ENV_NAME' with uv..."
if [[ -n "$PYTHON" ]]; then
  uv venv "$ENV_NAME" --python "$PYTHON"
else
  uv venv "$ENV_NAME"
fi  
# :contentReference[oaicite:0]{index=0}

# 2. Activate it
#    This will set VIRTUAL_ENV so that subsequent uv commands target this env
source "$ENV_NAME/bin/activate"

 # 3. Upgrade pip and install ipykernel + JupyterLab
echo "Installing pip, ipykernel, and JupyterLab in '$ENV_NAME'..."
uv pip install --upgrade pip ipykernel jupyterlab
# :contentReference[oaicite:1]{index=1}

# 4. Register the new kernel with Jupyter
DISPLAY_NAME="Python (uv: $ENV_NAME)"
echo "Registering kernel '$DISPLAY_NAME' with Jupyter..."
uv run python -m ipykernel install --user --name "$ENV_NAME" --display-name "$DISPLAY_NAME"
# :contentReference[oaicite:2]{index=2}

# 5. Deactivate
deactivate

echo "Done!  Launch Jupyter Lab or Notebook and pick the “$DISPLAY_NAME” kernel."
