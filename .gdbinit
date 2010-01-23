# Function to load FScript into a running Application
define loadfs
  attach $arg0
  loadfs_private
  call (void)[FScriptMenuItem insertInMainMenu]
end
# Private function for effectivelly loading F-Script
define loadfs_private
  call (char)[[NSBundle \
    bundleWithPath:@"/Applications/Dev/F-Script/FScript.framework"] load]
end
define fsconsole
  attach $arg0
  loadfs_private
  call (void)[[[FScriptMenuItem alloc] init] showConsole:nil]
  continue
end
define fsbrowser
  attach $arg0
  loadfs_private
  call (void)[[[FScriptMenuItem alloc] init] openObjectBrowser:nil]
  continue
end

# Objective-C debugging utility functions (x86_64)
# Calling convention (from: http://www.x86-64.org/documentation/abi.pdf )
# 2. If the class is INTEGER, the next available register of the sequence
#    %rdi, %rsi, %rdx, %rcx, %r8 and %r9 is used.
define receiver
  po $rdi
end

# We print the two possibilitites:
# The first is for the beginning of an objc_msgSend()
# The second is for just before a call of objc_msgSend()
define selector
  p (char*)$rsi
  # %rsi is a SEL: struct objc_selector*
  # struct objc_selector has 2 fields: void*uid and char*name (or something)
  p *(char**)($rsi+8)
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



