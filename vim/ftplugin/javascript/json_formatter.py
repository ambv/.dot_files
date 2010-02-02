import re
position_regexp = re.compile(r'line (\d+) column (\d+)')
imports_ok = True

try:
    import simplejson as json
except ImportError:
    try:
        import json
    except ImportError:
        imports_ok = False
        print "JSON formatter requires simplejson or Python 2.6+."

if imports_ok:
    import vim

    def ReformatJSON():
        try:
            json_string = json.loads('\n'.join(vim.current.buffer))
            vim.current.buffer[:] = json.dumps(json_string, indent=2).split('\n')
        except ValueError, ve:
            message = str(ve)
            positions = position_regexp.search(message)
            if positions:
                vim.command('norm ' + positions.group(1) + 'G')
                vim.command('norm ' + str(int(positions.group(2)) + 1) + '|')
            print message
