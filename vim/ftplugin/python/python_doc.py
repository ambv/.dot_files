from subprocess import Popen

def PyDocSearch(keyword=None, current_buffer=False):
    if keyword:
        search = 'search.html?q=%s' % keyword
    elif current_buffer:
        import vim
        isk = vim.eval('&isk')
        vim.command('set isk+=.')
        print vim.eval('&isk')
        search = 'search.html?q=%s' % vim.eval('expand("<cword>")')
        vim.command('set isk=%s' % isk)
    else:
        search = ''
    Popen(['open',  'http://docs.python.org/%s' % search])
