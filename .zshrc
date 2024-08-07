HISTFILE=~/.histfile
HISTSIZE=1024
SAVEHIST=65536

# self-added everything after extendedglob
setopt autocd bang_hist bare_glob_qual bash_auto_list case_glob
setopt case_match case_paths correct_all equals extendedglob
setopt extended_history glob_assign globstarshort glob_subst hash_cmds
setopt hash_list_all hist_expire_dups_first hist_lex_words
setopt hist_save_by_copy hist_subst_pattern inc_append_history
setopt interactivecomments magic_equal_subst multios notify null_glob
setopt path_script rcquotes rematch_pcre share_history unset

# unsetopt entirely self-added
unsetopt brace_ccl nomatch
bindkey -v

typeset -gx GCM_CREDENTIAL_STORE=gpg
typeset -gx GPG_TTY=`tty`

# Everything from here out self-added
typeset -gx -TU ORIG_PATH=$PATH orig_path
typeset -gx -TU OUTSIDE_PATH outside_path=(${(u)${(ku)~path:#~/**}%%/##}) :
typeset -gx -TU HOME_PATH home_path=(~/.*/([^0-9. ]##/)#bin(#q/rx)) :
typeset -gx -TU ALT_PATH=${HOME_PATH}:${OUTSIDE_PATH} alt_path :
typeset -gx -TU OLD_PATH=$HOME/.ghcup/bin:$HOME/.cabal/bin:$HOME/.local/bin:$PATH old_path :
typeset -gx -TU PATH=${ALT_PATH} path :

typeset -gx -TU OLD_PKG_CONFIG_PATH=$PKG_CONFIG_PATH old_pkg_config_path :
typeset -gx -TU MANPATH manpath :
typeset -gx -TU PKG_CONFIG_PATH pkg_config_path :
grep -El '(lib(sodium-vrf|blst|secp256k1))|systemd' \
	/nix/store/[[:alnum:]](#c32)-\
{libsodium-vrf-[0-9a-f](#c7)-dev,blst(-<0-99>(.<0-99>)#)#,secp256k1-[0-9a-f](#c7),systemd(-<0-999>(.<0-99>)#)#-dev}\
/**.pc \
	| xargs -i dirname \{\} \
	| xargs echo \
	| read -A pkg_config_path
pkg_config_path+=(${old_pkg_config_path[@]})

typeset -gx PS1='%D{%H:%M} %y $ '
typeset -gx EDITOR==vi
typeset -gx GCM_CREDENTIAL_STORE=gpg
typeset -gx GPG_TTY=$(tty)

typeset -gx LUA_BINDIR=$(dirname =luajit)
typeset -gx LUA_BINDIR_SET=yes

manupdate ()
{
        # zsh isn't intelligent enough not to break when matching this pattern:
        # (/(nix|run|share|usr|var)/**/man(-/))
        local -TU __MANDIRS __mandirs :

	__mandirs+=( /run/(booted|current)-system/sw/(bin|sbin|share)/man(/:P) /var/cache/man )
	__mandirs+=( $(find /nix/store/ -type d -name man 2>/dev/null) )
        while read -A input_array
        do
                case ${input_array[1]} in
                        MANPATH_MAP)
                                __mandirs+=( ${input_array[3]} );;
                        MANDB_MAP)
                                __mandirs+=( ${input_array[2]} );;
                        MANDATORY_MANPATH)
                                __mandirs+=( ${input_array[2]} );;
                esac
        done < /etc/man_db.conf
        sudo mandb "$__MANDIRS"
        for dir in ${__mandirs[@]}
        do
                sudo catman -d -M "$dir"
        done
        manpath+=(${(~@)__mandirs})
}

# Eliminate duplicates from a colon-separated path
cleanup_path ()
{
        # Why was the (u) modifier failing?
        # Something like test -n ${(P)1::=${(u)${(j,:,)local_path}%%:##}}
        # failed to clean up duplicates.
        # When deleting from an indexed array and using an associative
        # array to detect duplicates, there were many colons at the end
        # as if the array length wasn't properly shortened or otherwise
        # the index-to-value mapping wasn't made properly sparse.
        local -TU LOCAL_PATH=${(P)1} local_path :
        test -n ${(P)1::=${LOCAL_PATH}}
}

eval "$(ssh-agent)"
eval "$(direnv hook zsh)"
