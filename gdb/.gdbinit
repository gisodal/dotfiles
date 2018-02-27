define save-config_python
python
# get filename and clear the file
filename = str(gdb.parse_and_eval("$argument"))
filename = filename.replace("\"","")
open(filename, 'w').close()

# store breakpoints
command = "save breakpoints " + filename
gdb.execute(command,to_string=True)

# store command arguments
arguments = gdb.execute("show args",to_string=True).split("\"")[1]
with open(filename, "a") as configfile:
    command = "set args " + arguments
    configfile.write(command)

print " ".join(["Written config to:",filename])
end
end

define save-config
    if $argc != 1
        echo Usage: save-config <filename>\n
    else
        set $argument = "$arg0"
        save-config_python
    end
end


define skipdir_python
python
# get all sources loadable by gdb
def GetSources():
    sources = []
    for line in gdb.execute('info sources',to_string=True).splitlines():
        if line.startswith("/"):
            sources += [source.strip() for source in line.split(",")]
    return sources

# get a list of all sources already skipped
def GetSkipSources():
    sources = set();
    for line in gdb.execute('info skip',to_string=True).splitlines():
        sources.add(line.split()[3]);
    return sources

# skip source files of which the (absolute) path starts with 'dir'
def SkipDir(dir):
    sources = GetSources()
    skipsources = GetSkipSources()
    for source in sources:
        if source.startswith(dir):
            if source not in skipsources:
                gdb.execute('skip file %s' % source, to_string=True)

# time function
def Timed(timed, function, *args, **kwargs):
    if timed:
        import timeit
        t = timeit.Timer(lambda: function(*args, **kwargs))
        try:
            print t.timeit(1)," Seconds"
        except:
            t.print_exc()
    else:
        function(*args, **kwargs)

# apply only for c++
if 'c++' in gdb.execute('show language', to_string=True):
    dir = str(gdb.parse_and_eval("$skipdirargument"))
    dir = dir.replace("\"","");
    show_runtime = False
    Timed(show_runtime,SkipDir,dir)
end
end

# skip all files in provided directory
define skipdir
    if $argc != 1
        echo Usage: skipdir </absolute/path>\n
    else
        set $skipdirargument = "$arg0"
        skipdir_python
    end
end

document skipdir
    Prevent stepping into sources files in argument directory
end

# skip all STL source files and other libraries in '/usr'
define skipstl
    skipdir /usr/include
end

document skipstl
    Prevent stepping into STL source files
end

# hooks that run skipstl
define hookpost-run
    skipstl
end
define hookpost-start
    skipstl
end
define hookpost-attach
    skipstl
end

define lsof
  shell rm -f pidfile
  set logging file pidfile
  set logging on
  info proc
  set logging off
  shell lsof -p `cat pidfile | perl -n -e 'print $1 if /process (.+)/'`
end

document lsof
  List open files
end

handle SIG32 nostop

# stl printer
python
import sys
import os
sys.path.insert(0, os.environ['HOME'] + '/.gdb/printers/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end

alias sb = save breakpoint
alias ds = display
alias load-config = source
alias lc = load-config
alias sc = save-config
alias lb = load-config

set history save on
set history filename ~/.gdb_history
set width 0
set confirm off
set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style auto
set print sevenbit-strings off
set auto-solib-add off

set print address off
set print symbol off
set print entry-values no
set print type methods off
set print type typedefs off


define vgdb
    target remote | vgdb

