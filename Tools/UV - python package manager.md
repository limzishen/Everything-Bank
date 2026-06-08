Python package management to replace venv, pip
Creates a tree of dependency to manage it 
pyproject.toml to define configurations for the project 
setup a uv.lock file for future configs 
allows multiple people to work on the project 

# Advantages over pip 
PIp requirements files are actually not fixed. Even if the packaging version on the requirements file might be the same but the in between dependency might be different 
Way faster not gapped by network speed 
Allows for python version management 
Auto update lock file 

# Key commands 

**Project Setup**
- `uv init my-project` — create a new project
- `uv init` — initialize in the current directory
- `uv venv` — create a virtual environment manually (usually automatic)

**Managing Dependencies**
- `uv add requests` — add a package
- `uv add "requests>=2.28"` — add with version constraint
- `uv add --dev pytest` — add a dev-only dependency
- `uv remove requests` — remove a package
- `uv sync` — install all dependencies from `pyproject.toml`

**Running Code**
- `uv run main.py` — run a script in the project environment
- `uv run pytest` — run a tool/command in the environment
- `uv run --with requests script.py` — run with an extra package without adding it

**Python Version Management**
- `uv python install 3.12` — install a Python version
- `uv python list` — list available/installed versions
- `uv python pin 3.12` — pin the project to a specific version

**Packages & Tools**
- `uv tool install ruff` — install a CLI tool globally
- `uvx ruff check .` — run a tool without installing it (one-off)

**Lock & Build**
- `uv lock` — generate/update `uv.lock`
- `uv build` — build a distributable package

**Info & Maintenance**
- `uv pip list` — list installed packages
- `uv cache clean` — clear the cache
