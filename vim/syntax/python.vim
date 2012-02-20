" Vim syntax file
" Language:	Python
" Maintainer:	Dmitry Vasiliev <dima@hlabs.spb.ru>
" URL:		http://www.hlabs.spb.ru/vim/python.vim
" Last Change:	2009-07-24
" Filenames:	*.py
" Version:	2.6.5
"
" Based on python.vim (from Vim 6.1 distribution)
" by Neil Schemenauer <nas@python.ca>
"
" Thanks:
"
"    Jeroen Ruigrok van der Werven
"        for the idea to highlight erroneous operators
"    Pedro Algarvio
"        for the patch to enable spell checking only for the right spots
"        (strings and comments)
"    John Eikenberry
"        for the patch fixing small typo
"    Caleb Adamantine
"        for the patch fixing highlighting for decorators

"
" Options:
"
"    For set option do: let OPTION_NAME = 1
"    For clear option do: let OPTION_NAME = 0
"
" Option names:
"
"    For highlight builtin functions:
"       python_highlight_builtins
"
"    For highlight standard exceptions:
"       python_highlight_exceptions
"
"    For highlight string formatting:
"       python_highlight_string_formatting
"
"    For highlight str.format syntax:
"       python_highlight_string_format
"
"    For highlight string.Template syntax:
"       python_highlight_string_templates
"
"    For highlight indentation errors:
"       python_highlight_indent_errors
"
"    For highlight trailing spaces:
"       python_highlight_space_errors
"
"    For highlight doc-tests:
"       python_highlight_doctests
"
"    If you want all Python highlightings above:
"       python_highlight_all
"    (This option not override previously set options)
"
"    For fast machines:
"       python_slow_sync
"
"    For "print" builtin as function:
"       python_print_as_function

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if exists("python_highlight_all") && python_highlight_all != 0
  " Not override previously set options
  if !exists("python_highlight_builtins")
    let python_highlight_builtins = 1
  endif
  if !exists("python_highlight_exceptions")
    let python_highlight_exceptions = 1
  endif
  if !exists("python_highlight_string_formatting")
    let python_highlight_string_formatting = 1
  endif
  if !exists("python_highlight_string_format")
    let python_highlight_string_format = 1
  endif
  if !exists("python_highlight_string_templates")
    let python_highlight_string_templates = 1
  endif
  if !exists("python_highlight_indent_errors")
    let python_highlight_indent_errors = 1
  endif
  if !exists("python_highlight_space_errors")
    let python_highlight_space_errors = 1
  endif
  if !exists("python_highlight_doctests")
    let python_highlight_doctests = 1
  endif
endif

" Keywords
syn keyword pythonStatement	break continue del
syn keyword pythonStatement	exec return
syn keyword pythonStatement	pass raise
syn keyword pythonStatement	global nonlocal assert
syn keyword pythonStatement	lambda yield
syn keyword pythonStatement	with
syn keyword pythonStatement	def class nextgroup=pythonFunction skipwhite
syn match   pythonFunction	"[a-zA-Z_][a-zA-Z0-9_]*" display contained
syn keyword pythonRepeat	for while
syn keyword pythonConditional	if elif else
syn keyword pythonPreCondit	import from as
syn keyword pythonException	try except finally
syn keyword pythonOperator	and in is not or

if !exists("python_print_as_function") || python_print_as_function == 0
  syn keyword pythonStatement print
endif

" Decorators (new in Python 2.4)
syn match   pythonDecorator	"@" display nextgroup=pythonDottedName skipwhite
syn match   pythonDottedName "[a-zA-Z_][a-zA-Z0-9_]*\(\.[a-zA-Z_][a-zA-Z0-9_]*\)*" display contained
syn match   pythonDot        "\." display containedin=pythonDottedName

" Comments
syn match   pythonComment	"#.*$" display contains=pythonTodo,@Spell
syn match   pythonRun		"\%^#!.*$"
syn match   pythonCoding	"\%^.*\(\n.*\)\?#.*coding[:=]\s*[0-9A-Za-z-_.]\+.*$"
syn keyword pythonTodo		TODO FIXME XXX contained

" Errors
syn match pythonError		"\<\d\+\D\+\>" display
syn match pythonError		"[$?]" display
syn match pythonError		"[&|]\{2,}" display
syn match pythonError		"[=]\{3,}" display

" Control flow :{[(,+-*/=
syn match  pythonControlFlow "[-+*/^:\(\)\{\}\[\],\.=<>!]" display

" TODO: Mixing spaces and tabs also may be used for pretty formatting multiline
" statements. For now I don't know how to work around this.
if exists("python_highlight_indent_errors") && python_highlight_indent_errors != 0
  syn match pythonIndentError	"^\s*\( \t\|\t \)\s*\S"me=e-1 display
endif

" Trailing space errors
if exists("python_highlight_space_errors") && python_highlight_space_errors != 0
  syn match pythonSpaceError	"\s\+$" display
endif

" Strings
syn region pythonString		start=+[bB]\='+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonEscape,pythonEscapeError,@Spell
syn region pythonString		start=+[bB]\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonEscape,pythonEscapeError,@Spell
syn region pythonString		start=+[bB]\="""+ end=+"""+ keepend contains=pythonEscape,pythonEscapeError,pythonDocTest2,pythonSpaceError,@Spell
syn region pythonString		start=+[bB]\='''+ end=+'''+ keepend contains=pythonEscape,pythonEscapeError,pythonDocTest,pythonSpaceError,@Spell

syn match  pythonEscape		+\\[abfnrtv'"\\]+ display contained
syn match  pythonEscape		"\\\o\o\=\o\=" display contained
syn match  pythonEscapeError	"\\\o\{,2}[89]" display contained
syn match  pythonEscape		"\\x\x\{2}" display contained
syn match  pythonEscapeError	"\\x\x\=\X" display contained
syn match  pythonEscape		"\\$"

" Unicode strings
syn region pythonUniString	start=+[uU]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError,@Spell
syn region pythonUniString	start=+[uU]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError,@Spell
syn region pythonUniString	start=+[uU]"""+ end=+"""+ keepend contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
syn region pythonUniString	start=+[uU]'''+ end=+'''+ keepend contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell

syn match  pythonUniEscape	"\\u\x\{4}" display contained
syn match  pythonUniEscapeError	"\\u\x\{,3}\X" display contained
syn match  pythonUniEscape	"\\U\x\{8}" display contained
syn match  pythonUniEscapeError	"\\U\x\{,7}\X" display contained
syn match  pythonUniEscape	"\\N{[A-Z ]\+}" display contained
syn match  pythonUniEscapeError	"\\N{[^A-Z ]\+}" display contained

" Raw strings
syn region pythonRawString	start=+[rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
syn region pythonRawString	start=+[rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
syn region pythonRawString	start=+[rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
syn region pythonRawString	start=+[rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell

syn match pythonRawEscape	+\\['"]+ display transparent contained

" Unicode raw strings
syn region pythonUniRawString	start=+[uU][rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError,@Spell
syn region pythonUniRawString	start=+[uU][rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError,@Spell
syn region pythonUniRawString	start=+[uU][rR]"""+ end=+"""+ keepend contains=pythonUniRawEscape,pythonUniRawEscapeError,pythonDocTest2,pythonSpaceError,@Spell
syn region pythonUniRawString	start=+[uU][rR]'''+ end=+'''+ keepend contains=pythonUniRawEscape,pythonUniRawEscapeError,pythonDocTest,pythonSpaceError,@Spell

syn match  pythonUniRawEscape		"\([^\\]\(\\\\\)*\)\@<=\\u\x\{4}" display contained
syn match  pythonUniRawEscapeError	"\([^\\]\(\\\\\)*\)\@<=\\u\x\{,3}\X" display contained

if exists("python_highlight_string_formatting") && python_highlight_string_formatting != 0
  " String formatting
  syn match pythonStrFormatting	"%\(([^)]\+)\)\=[-#0 +]*\d*\(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonUniString,pythonRawString,pythonUniRawString
  syn match pythonStrFormatting	"%[-#0 +]*\(\*\|\d\+\)\=\(\.\(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonUniString,pythonRawString,pythonUniRawString
endif

if exists("python_highlight_string_format") && python_highlight_string_format != 0
  " str.format syntax
  syn match pythonStrFormat "{\|}" contained containedin=pythonString,pythonUniString,pythonRawString,pythonUniRawString
  syn match pythonStrFormat "{{\|}}" contained containedin=pythonString,pythonUniString,pythonRawString,pythonUniRawString
  syn match pythonStrFormat	"{\([a-zA-Z_][a-zA-Z0-9_]*\|\d\+\)\(\.[a-zA-Z_][a-zA-Z0-9_]*\|\[\(\d\+\|[^!:\}]\+\)\]\)*\(![rs]\)\=\(:\({\([a-zA-Z_][a-zA-Z0-9_]*\|\d\+\)}\|\([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*\(\.\d\+\)\=[bcdeEfFgGnoxX%]\=\)\=\)\=}" contained containedin=pythonString,pythonUniString,pythonRawString,pythonUniRawString
endif

if exists("python_highlight_string_templates") && python_highlight_string_templates != 0
  " String templates
  syn match pythonStrTemplate	"\$\$" contained containedin=pythonString,pythonUniString,pythonRawString,pythonUniRawString
  syn match pythonStrTemplate	"\${[a-zA-Z_][a-zA-Z0-9_]*}" contained containedin=pythonString,pythonUniString,pythonRawString,pythonUniRawString
  syn match pythonStrTemplate	"\$[a-zA-Z_][a-zA-Z0-9_]*" contained containedin=pythonString,pythonUniString,pythonRawString,pythonUniRawString
endif

if exists("python_highlight_doctests") && python_highlight_doctests != 0
  " DocTests
  syn region pythonDocTest	start="^\s*>>>" end=+'''+he=s-1 end="^\s*$" contained
  syn region pythonDocTest2	start="^\s*>>>" end=+"""+he=s-1 end="^\s*$" contained
endif

" Numbers (ints, longs, floats, complex)
syn match   pythonHexError	"\<0[xX]\x*[g-zG-Z]\x*[lL]\=\>" display

syn match   pythonHexNumber	"\<0[xX]\x\+[lL]\=\>" display
syn match   pythonOctNumber "\<0[oO]\o\+[lL]\=\>" display
syn match   pythonBinNumber "\<0[bB][01]\+[lL]\=\>" display

syn match   pythonNumber	"\<\d\+[lLjJ]\=\>" display

syn match   pythonFloat		"\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>" display
syn match   pythonFloat		"\<\d\+[eE][+-]\=\d\+[jJ]\=\>" display
syn match   pythonFloat		"\<\d\+\.\d*\([eE][+-]\=\d\+\)\=[jJ]\=" display

syn match   pythonOctError	"\<0[oO]\=\o*[8-9]\d*[lL]\=\>" display
syn match   pythonBinError	"\<0[bB][01]*[2-9]\d*[lL]\=\>" display

if exists("python_highlight_builtins") && python_highlight_builtins != 0
  " Builtin functions, types and objects
  syn keyword pythonBuiltinObj	self True False Ellipsis None NotImplemented Null
  syn keyword pythonBuiltinObj	__future__ __debug__ __doc__ __file__ __name__ __package__

  syn match pythonBuiltinFunc /[^\.]\<__import__\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<abs\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<all\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<any\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<apply\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<basestring\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<bin\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<bool\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<buffer\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<bytearray\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<bytes\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<callable\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<chr\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<classmethod\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<cmp\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<coerce\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<compile\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<complex\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<delattr\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<dict\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<dir\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<divmod\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<enumerate\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<eval\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<execfile\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<file\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<filter\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<float\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<format\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<frozenset\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<getattr\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<globals\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<hasattr\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<hash\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<help\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<hex\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<id\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<input\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<int\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<intern\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<isinstance\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<issubclass\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<iter\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<len\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<list\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<locals\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<long\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<map\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<max\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<min\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<next\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<object\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<oct\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<open\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<ord\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<pow\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<property\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<range\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<raw_input\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<reduce\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<reload\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<repr\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<reversed\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<round\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<set\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<setattr\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<slice\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<sorted\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<staticmethod\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<str\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<sum\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<super\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<tuple\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<type\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<unichr\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<unicode\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<vars\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<xrange\>\s*[^= \t]/ms=s+1,me=e-1 display
  syn match pythonBuiltinFunc /[^\.]\<zip\>\s*[^= \t]/ms=s+1,me=e-1 display

  if exists("python_print_as_function") && python_print_as_function != 0
      syn keyword pythonBuiltinFunc	print
  endif
endif

if exists("python_highlight_exceptions") && python_highlight_exceptions != 0
  " Builtin exceptions and warnings
  syn keyword pythonExClass	BaseException
  syn keyword pythonExClass	Exception StandardError ArithmeticError
  syn keyword pythonExClass	LookupError EnvironmentError

  syn keyword pythonExClass	AssertionError AttributeError BufferError EOFError
  syn keyword pythonExClass	FloatingPointError GeneratorExit IOError
  syn keyword pythonExClass	ImportError IndexError KeyError
  syn keyword pythonExClass	KeyboardInterrupt MemoryError NameError
  syn keyword pythonExClass	NotImplementedError OSError OverflowError
  syn keyword pythonExClass	ReferenceError RuntimeError StopIteration
  syn keyword pythonExClass	SyntaxError IndentationError TabError
  syn keyword pythonExClass	SystemError SystemExit TypeError
  syn keyword pythonExClass	UnboundLocalError UnicodeError
  syn keyword pythonExClass	UnicodeEncodeError UnicodeDecodeError
  syn keyword pythonExClass	UnicodeTranslateError ValueError VMSError
  syn keyword pythonExClass	WindowsError ZeroDivisionError

  syn keyword pythonExClass	Warning UserWarning BytesWarning DeprecationWarning
  syn keyword pythonExClass	PendingDepricationWarning SyntaxWarning
  syn keyword pythonExClass	RuntimeWarning FutureWarning
  syn keyword pythonExClass	ImportWarning UnicodeWarning
endif

if exists("python_slow_sync") && python_slow_sync != 0
  syn sync minlines=2000
else
  " This is fast but code inside triple quoted strings screws it up. It
  " is impossible to fix because the only way to know if you are inside a
  " triple quoted string is to start from the beginning of the file.
  syn sync match pythonSync grouphere NONE "):$"
  syn sync maxlines=200
endif

if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink pythonStatement	Statement
  HiLink pythonPreCondit	Statement
  HiLink pythonFunction		Function
  HiLink pythonConditional	Conditional
  HiLink pythonRepeat		Repeat
  HiLink pythonException  Conditional 
  HiLink pythonOperator		Operator

  HiLink pythonDecorator	Define
  HiLink pythonDottedName	Function
  HiLink pythonDot          Normal

  HiLink pythonComment		Comment
  HiLink pythonControlFlow		Special
  HiLink pythonCoding		Special
  HiLink pythonRun		Special
  HiLink pythonTodo		Todo

  HiLink pythonError		Error
  HiLink pythonIndentError	Error
  HiLink pythonSpaceError	ExtraWhitespace

  HiLink pythonString		String
  HiLink pythonUniString	String
  HiLink pythonRawString	String
  HiLink pythonUniRawString	String

  HiLink pythonEscape			Special
  HiLink pythonEscapeError		Error
  HiLink pythonUniEscape		Special
  HiLink pythonUniEscapeError		Error
  HiLink pythonUniRawEscape		Special
  HiLink pythonUniRawEscapeError	Error

  HiLink pythonStrFormatting	Special
  HiLink pythonStrFormat    	Special
  HiLink pythonStrTemplate	    Special

  HiLink pythonDocTest		Special
  HiLink pythonDocTest2		Special

  HiLink pythonNumber		Number
  HiLink pythonHexNumber	Number
  HiLink pythonOctNumber	Number
  HiLink pythonBinNumber	Number
  HiLink pythonFloat		Float
  HiLink pythonOctError	    Error
  HiLink pythonHexError		Error
  HiLink pythonBinError		Error

  HiLink pythonBuiltinObj	Structure
  HiLink pythonBuiltinFunc	Function

  HiLink pythonExClass  Exception

  delcommand HiLink
endif

let b:current_syntax = "python"
