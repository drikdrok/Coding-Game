keymapping = {
  buffer = {
    ['up']                  = 'moveUp',
    ['down']                = 'moveDown',
    ['left']                = 'moveLeft',
    ['alt+up']              = 'moveJumpUp',
    ['alt+down']            = 'moveJumpDown',
    ['ctrl+left']           = 'moveJumpLeft',
    ['ctrl+right']          = 'moveJumpRight',
    ['right']               = 'moveRight',
    ['home']                = 'moveHome',
    ['end']                 = 'moveEnd',
    ['pageup']              = 'movePageUp',
    ['pagedown']            = 'movePageDown',
    ['ctrl+home']           = 'moveJumpHome',
    ['ctrl+end']            = 'moveJumpEnd',

    ['shift+up']            = 'selectUp',
    ['alt+shift+up']        = 'selectJumpUp',
    ['shift+down']          = 'selectDown',
    ['alt+shift+down']      = 'selectJumpDown',
    ['shift+left']          = 'selectLeft',
    ['ctrl+shift+left']     = 'selectJumpLeft',
    ['ctrl+shift+right']    = 'selectJumpRight',
    ['shift+right']         = 'selectRight',
    ['shift+home']          = 'selectHome',
    ['shift+end']           = 'selectEnd',
    ['shift+pageup']        = 'selectPageUp',
    ['shift+pagedown']      = 'selectPageDown',

    ['tab']                 = 'insertTab',
    ['return']              = 'breakLine',
    ['enter']               = 'breakLine',
    ['delete']              = 'deleteRight',
    ['backspace']           = 'deleteLeft',
    ['ctrl+backspace']      = 'deleteWord',
    ['ctrl+x']              = 'cutText',
    ['ctrl+c']              = 'copyText',
    ['ctrl+v']              = 'pasteText',
  },
  macros = {
  },
}

highlighting = { 
  background   = {0.8, 0.8, 0.8}, --editor background
  cursorline   = {1, 1, 1}, --cursor background
  caret        = {1, 1, 1}, --cursor
  whitespace   = {1, 1, 1}, --spaces, newlines, tabs, and carriage returns
  comment      = {0.5, 0.5, 0.5}, --either multi-line or single-line comments
  string_start = {231/255, 219/255, 116/255}, --starts and ends of a string. There will be no non-string tokens between these two.
  string_end   = {231/255, 219/255, 116/255},
  string       = {231/255, 219/255, 116/255}, --part of a string that isn't an escape
  escape       = {172/255, 128/255, 1}, --a string escape, like \n, only found inside strings
  keyword      = {249/255, 36/255, 110/255}, --keywords. Like "while", "end", "do", etc
  value        = {172/255, 128/255, 1}, --special values. Only true, false, and nil
  ident        = {1, 1, 1}, --identifier. Variables, function names, etc
  number       = {172/255, 128/255, 1}, --numbers, including both base 10 (and scientific notation) and hexadecimal
  symbol       = {1, 1, 1}, --symbols, like brackets, parenthesis, ., .., etc
  vararg       = {1, 1, 1}, --...
  operator     = {249/255, 36/255, 110/255}, --operators, like +, -, %, =, ==, >=, <=, ~=, etc
  label_start  = {1, 1, 1}, --the starts and ends of labels. Always equal to '::'. Between them there can only be whitespace and label tokens.
  label_end    = {1, 1, 1},
  label        = {1, 1, 1}, --basically an ident between a label_start and label_end.
  unidentified = {1, 1, 1}, --anything that isn't one of the above tokens. Consider them errors. Invalid escapes are also unidentified.
  selection    = {1, 1, 1, 0.5},
}


