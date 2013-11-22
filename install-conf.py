#!/usr/bin/env python

'''Run from home dir to (re)install conf files.

NB: this install script will check out a copy of the conf repo
containing it, so the easiest way to do an initial install is to copy
this file (install-conf.py) from an existing install into the new home
dir and run the copy.

The directory v(ersioned) contains working copies.'''
from subprocess import call
from os import chdir, getenv
from os.path import exists, realpath

def c(cmd):
    call(cmd,shell=True)

def main():
    """Set up home dir.

    Creates directories, downloads conf, and creates appropriate
    symlinks.  It's idempotent, meaning you can rerun it to update an
    existing install.
    """

    home = realpath(getenv('HOME')) 
    chdir(home)

    for d in ('v', 'tmp', 'local', 'local/opt', '.subversion', '.ghc', '.emacs.d',
              '.xmonad', '.local/share/applications', '.config/gnome-session/sessions'):
        if not exists(d): c('mkdir -p %s' % d)
    chdir('v')

    if not exists('conf'):
        c('svn co https://nathan-collins--conf.googlecode.com/svn conf --username nathan.collins')

    # {ln -T} mean treat destination as a normal file, i.e. don't
    # create file *in* target if target is a dir.  this is needed for
    # the idempotence of {ln ~/v/conf/dot.zsh ~/.zsh}.
    for f in ('.emacs', '.pythonrc', '.screenrc', '.subversion/config',
              '.zsh', '.zshrc', '.zshenv', '.zprofile',
              '.ghc/ghci.conf', '.ghc/ghci-prompt.conf', '.haskeline',
              '.vimperatorrc',
              '.gitconfig', '.gitattributes',
              '.xmonad/xmonad.hs', '.Xresources', '.xsession',
              '.config/gnome-session/sessions/local-xmonad-session.session',
              '.local/share/applications/local-xmonad-windowmanager-provider.desktop',
              '.gdbinit'
              ):
        from_ = '%(home)s/v/conf/dot%(f)s' % locals()
        to = '%(home)s/%(f)s' % locals()
#         if exists(to):
#             c('mv %(to)s %(to)s.backup' % locals())
        c('ln -Tfs %(from_)s %(to)s'  % locals())
    # for f in ('.zshrc', '.zshenv'):
    #     from_ = '%(home)s/.zsh/dot%(f)s' % locals()
    #     to = '%(home)s/%(f)s' % locals()
    #     c('ln -Tfs %(from_)s %(to)s'  % locals())

    # emacs extensions.
    c('ln -fs %(home)s/v/conf/dot.emacs.d/extensions %(home)s/.emacs.d/'
      % locals())
    # haskell-mode via darcs
    to = '%(home)s/local/opt/haskellmode-emacs' % locals()
    if not exists(to):
        print 'Downloading haskell-mode ...'
        # tags are listed on the main page
        # http://projects.haskell.org/haskellmode-emacs/, or use
        # 'darcs list tags'.
        if c('darcs get --lazy --tag 2.8.0 \
                http://code.haskell.org/haskellmode-emacs %(to)s'
             % locals()):
            print 'Error downloading haskellmode-emacs.  Do you have darcs installed?'
        c('cd %(to)s && make' % locals())
    # misc programs.
    c('ln -fs %(home)s/v/conf/scripts %(home)s/local/' % locals())

    # if not exists('%(home)s/local/more-scripts' % locals()):
    #     print """You may need to download v/docs and create a link from v/docs/scripts to ~/local/more-scripts."""

    # use zsh?
    shell = getenv('SHELL')
    if 'zsh' not in shell:
        print '''You are using "%(shell)s" but this conf is for zsh.  Changing shell to zsh ...'''
        c('chsh -s /bin/zsh')

if __name__ == '__main__': main()
