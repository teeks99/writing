[[ -d .venv ]] || virtualenv -p python3 .venv
if [ -z ${VIRTUAL_ENV+x} ]; then source .venv/bin/activate; fi
pip install -Ur requirements.txt
