@setlocal enableextensions enabledelayedexpansion
@echo off
@rem set start=%time%
@rem
@rem call %*
@rem echo Start: %start% 1>&2
@rem echo End:   %time% 1>&2
@rem endlocal

@rem new version: just rely on python
@rem Use shell=yes to call the subprocess as that's what's expected. Otherwise we'd need to do some shell-related work
@rem TODO: Double-check if this means we expand stuff twice on Windows. IIRC, it's on the called process to expand the arguments, not on the shell
python -c "import subprocess;import sys;import time;start=time.time();ret=subprocess.run(sys.argv[1:], shell=True).returncode;taken=time.time()-start;mins=int(taken//60);secs=taken%%60;print(f'\nreal:\t{mins}m{secs:.3}s');sys.exit(ret)" %*
