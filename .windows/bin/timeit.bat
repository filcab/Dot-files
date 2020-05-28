@setlocal enableextensions enabledelayedexpansion
@echo off
@rem set start=%time%
@rem
@rem call %*
@rem echo Start: %start% 1>&2
@rem echo End:   %time% 1>&2
@rem endlocal

@rem new version: just rely on python
python -c "import subprocess;import sys;import time;start=time.time();ret=subprocess.run(sys.argv[1:]).returncode;taken=time.time()-start;mins=int(taken//60);secs=taken%%60;print(f'\nreal:\t{mins}m{secs:.3}s');sys.exit(ret)" %*
