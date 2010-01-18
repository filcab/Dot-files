# Function to load FScript into a running Application
define loadfs
  attach $arg0
  p (char)[[NSBundle \
    bundleWithPath:@"/Applications/Dev/F-Script/FScript.framework"] load]
  p (void)[FScriptMenuItem insertInMainMenu]
  continue
end


# Objective-C debugging utility functions (x86_64)
# Calling convention (from: http://www.x86-64.org/documentation/abi.pdf )
# 2. If the class is INTEGER, the next available register of the sequence
#    %rdi, %rsi, %rdx, %rcx, %r8 and %r9 is used.
define receiver
  po $rdi
end

define selector
  p (char*)$rsi
end

define arg1
  po $rdx
end
define arg2
  po $rcx
end
define arg3
  po $r8
end
define arg4
  po $r9
end



