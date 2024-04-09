# From https://jonasdevlieghere.com/a-better-youcompleteme-config/
# Got version in https://github.com/JDevlieghere/dotfiles on 2018/May/03

import logging
import os
import os.path
import shutil
import ycm_core

BASE_FLAGS = [
        '-Wall',
        '-Wextra',
        '-ferror-limit=10000',
        '-std=c++1z',
        '-xc++'#,
        #'-I/usr/lib/',
        #'-I/usr/include/'
        ]

SOURCE_EXTENSIONS = [
        '.cpp',
        '.cxx',
        '.cc',
        '.c',
        '.m',
        '.mm'
        ]

SOURCE_DIRECTORIES = [
        'src',
        'lib'
        ]

HEADER_EXTENSIONS = [
        '.h',
        '.hxx',
        '.hpp',
        '.hh'
        ]

HEADER_DIRECTORIES = [
        'include'
        ]

BUILD_DIRECTORY = 'build';

def IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in HEADER_EXTENSIONS

def GetCompilationInfoForFile(database, filename):
    if IsHeaderFile(filename):
        basename = os.path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            # Get info from the source files by replacing the extension.
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                compilation_info = database.GetCompilationInfoForFile(replacement_file)
                if compilation_info.compiler_flags_:
                    return compilation_info
            # If that wasn't successful, try replacing possible header directory with possible source directories.
            for header_dir in HEADER_DIRECTORIES:
                for source_dir in SOURCE_DIRECTORIES:
                    src_file = replacement_file.replace(header_dir, source_dir)
                    if os.path.exists(src_file):
                        compilation_info = database.GetCompilationInfoForFile(src_file)
                        if compilation_info.compiler_flags_:
                            return compilation_info
        return None
    return database.GetCompilationInfoForFile(filename)

def FindNearest(path, target, build_folder=None):
    candidate = os.path.join(path, target)
    if(os.path.isfile(candidate) or os.path.isdir(candidate)):
        logging.info("Found nearest " + target + " at " + candidate)
        return candidate;

    parent = os.path.dirname(os.path.abspath(path));
    if(parent == path):
        raise RuntimeError("Could not find " + target);

    if(build_folder):
        candidate = os.path.join(parent, build_folder, target)
        if(os.path.isfile(candidate) or os.path.isdir(candidate)):
            logging.info("Found nearest " + target + " in build folder at " + candidate)
            return candidate;

    return FindNearest(parent, target, build_folder)

def MakeRelativePathsInFlagsAbsolute(flags, working_directory):
    if not working_directory:
        return list(flags)
    new_flags = []
    make_next_absolute = False
    path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[ len(path_flag): ]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)
    return new_flags


def FlagsForClangComplete(root):
    try:
        clang_complete_path = FindNearest(root, '.clang_complete')
        clang_complete_flags = open(clang_complete_path, 'r').read().splitlines()
        return clang_complete_flags
    except:
        return None

def FlagsForInclude(root):
    try:
        include_path = FindNearest(root, 'include')
        flags = []
        for dirroot, dirnames, filenames in os.walk(include_path):
            for dir_path in dirnames:
                real_path = os.path.join(dirroot, dir_path)
                flags = flags + ["-I" + real_path]
        return flags
    except:
        return None

def FlagsForCompilationDatabase(root, filename):
    try:
        # Last argument of next function is the name of the build folder for
        # out of source projects
        compilation_db_path = FindNearest(root, 'compile_commands.json', BUILD_DIRECTORY)
        compilation_db_dir = os.path.dirname(compilation_db_path)
        logging.info("Set compilation database directory to " + compilation_db_dir)
        compilation_db =  ycm_core.CompilationDatabase(compilation_db_dir)
        if not compilation_db:
            logging.info("Compilation database file found but unable to load")
            return None
        compilation_info = GetCompilationInfoForFile(compilation_db, filename)
        if not compilation_info:
            logging.info("No compilation info for " + filename + " in compilation database")
            return None
        return MakeRelativePathsInFlagsAbsolute(
                compilation_info.compiler_flags_,
                compilation_info.compiler_working_dir_)
    except:
        return None

def FlagsForTarget(root, client_data):
    # might need to be a global? It's going to be weird managing the state, for now
    # setting the variable and then restarting ycm should be enough
    return client_data.get("YcmTargetFlags()", [])

def FlagsForFile(filename, **kwargs):
    root = os.path.realpath(filename)
    compilation_db_flags = FlagsForCompilationDatabase(root, filename)
    if compilation_db_flags:
        final_flags = compilation_db_flags
    else:
        final_flags = BASE_FLAGS
        clang_flags = FlagsForClangComplete(root)
        if clang_flags:
            final_flags = final_flags + clang_flags
        include_flags = FlagsForInclude(root)
        if include_flags:
            final_flags = final_flags + include_flags

        target_flags = FlagsForTarget(root, kwargs.get("client_data", {}))
        final_flags.extend(target_flags)

    return {
            'flags': final_flags,
            'do_cache': True
            }

def Settings(**kwargs):
    if kwargs['language'] == 'python':
        # FIXME: Get line length from vim/default and set it up for black and ruff
        line_length = 88  # same as python's black
        # vimsupport isn't available on ycmd, just on the python side of ycm
        # unsure how to best propagate this information to the lsp
        # line_length = vimsupport.GetIntValue('&textwidth')

        plugin_configs = {}
        # default-enabled plugins:
        # mypy for typing, configs: https://github.com/python-lsp/pylsp-mypy?tab=readme-ov-file#configuration
        # black for indenting (if ruff is not available, check further down), configs: https://github.com/python-lsp/python-lsp-black?tab=readme-ov-file#configuration
        # is there an easy way to find out if these plugins have been installed?
        plugin_configs['pylsp_mypy'] = {
            'enabled': True,
            'dmypy': True,
            'report_progress': True,
        }
        plugin_configs['black'] = {
            'enabled': True,
            'line_length': line_length,
        }

        # remove other formatters, assume we always have black or ruff
        ALWAYS_DISABLED = ['autopep8', 'yapf']
        for plugin in ALWAYS_DISABLED:
            plugin_configs[plugin] = {'enabled': False}

        # maybe check if:
        # ruff-lsp path is configured vim-side, if so, set to use that executable
        # check if the executable (automatically found or via search) is there. If so,
        # use ruff-lsp, otherwise use whatever was default
        if shutil.which('ruff-lsp'):
            # we found ruff, disable other plugins that do the same thing, including
            # 'black', which we've setup earlier
            for plugin in ['pycodestyle', 'pyflakes', 'mccabe', 'black']:
                plugin_configs[plugin] = {'enabled': False}
            plugin_configs['ruff'] = dict(
                # https://github.com/python-lsp/python-lsp-ruff?tab=readme-ov-file#configuration
                # defaults: https://docs.astral.sh/ruff/configuration/
                enabled=True,
                formatEnabled=True,
                lineLength=line_length,
            )

        return {
            'ls': {
                'pylsp.plugins': plugin_configs,
            },
        }
