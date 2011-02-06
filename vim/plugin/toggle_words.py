import vim

toggle_words_dict = {
    '*': [
        ['==', '!='],
        ['>', '<'],
        ['[', ']'],
        ['[', ']'],
        ['{', '}'],
        ['+', '-'],
        ['allow', 'deny'],
        ['before', 'after'],
        ['block', 'inline', 'none'],
        ['define', 'undef'],
        ['good', 'bad'],
        ['if', 'elseif', 'else', 'endif'],
        ['in', 'out'],
        ['left', 'right'],
        ['min', 'max'],
        ['on', 'off'],
        ['start', 'stop'],
        ['success', 'failure'],
        ['true', 'false'],
        ['up', 'down'],
        ['left', 'right'],
        ['yes', 'no'],
        ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'],
        ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december'],
        ['1', '0'],
        ['top', 'bottom'],
        ['even', 'odd'],
    ],
    'python': [
        ['if', 'elif', 'else'],
        ['in'],
        ['def', 'class'],
        ['null', 'None'],
        ['this', 'self'],
        ['True', 'False'],
        ['true', 'True'],
        ['false', 'False'],
    ],
    'javascript': [
        ['true', 'false'],
        ['True', 'true'],
        ['False', 'false'],
        ['None', 'null'],
    ],
    }


def ToggleWord():
    toggle_words_list = toggle_words_dict['*']

    cur_filetype = vim.eval("&filetype")
    if cur_filetype in toggle_words_dict:
        toggle_words_list = toggle_words_dict[cur_filetype] + toggle_words_list

    cur_word = vim.eval('expand("<cword>")')
    cur_word_lower = cur_word.lower()

    next_word = None
    for toggles in toggle_words_list:
        if cur_word in toggles:
            index = (toggles.index(cur_word) + 1) % len(toggles)
            next_word = toggles[index]
            break

    if next_word:
        vim.command('norm ciw' + next_word)
        return

    for toggles in toggle_words_list:
        if cur_word_lower in toggles:
            index = (toggles.index(cur_word_lower) + 1) % len(toggles)
            next_word = toggles[index]
            if next_word == next_word.lower(): # we do smart-casing on lower case values
                try:
                    if cur_word == cur_word.upper():
                        next_word = next_word.upper()
                    elif cur_word[0].upper() + cur_word[1:] == cur_word:
                        next_word = next_word[0].upper() + next_word[1:]
                except IndexRange, e:
                    pass
            break

    if next_word:
        vim.command('norm ciw' + next_word)
