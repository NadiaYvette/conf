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

typeset -x GCM_CREDENTIAL_STORE=gpg
typeset -x GPG_TTY=`tty`
# typeset -x HOME_PATH=(~/.*/bin(#q/))
# typeset -x HOME_PATH=(~/.*/((*~*[0-9]##(.[0-9]##)#*)/)#bin(#q/rx))
# typeset -x OUTSIDE_PATH=${(uj,:,)${(ku)~path:#~/**}%%/##}
# typeset -x ALT_PATH=${(zj,:,)HOME_PATH}:${OUTSIDE_PATH}
# typeset -x -T ORIG_PATH=$PATH orig_path :
# typeset -x -T OUTSIDE_PATH outside_path=(${(u)${(ku)~path:#~/**}%%/##}) :
# typeset -x -T HOME_PATH home_path=(~/.*/([^0-9.]##/)#bin(#q/rx)) :
# typeset -x -T ALT_PATH=${HOME_PATH}:${OUTSIDE_PATH} alt_path :
# typeset -x -T OLD_PATH=$HOME/.cabal/bin:$HOME/.ghcup/bin:$HOME/.local/bin:/usr/local/bin:$PATH old_path :
# typeset -x -T PATH=${ALT_PATH} path :
# typeset -x PS1='%D{%H:%M} %y $ '

# typeset -x EDITOR=/run/current-system/sw/bin/vi
# typeset -x EDITOR==vi

# Everything from here out self-added
typeset -x -TU ORIG_PATH=$PATH orig_path
# typeset -x HOME_PATH=(~/.*/bin(#q/))
# typeset -x HOME_PATH=(~/.*/((*~*[0-9]##(.[0-9]##)#*)/)#bin(#q/rx))
typeset -x -TU OUTSIDE_PATH outside_path=(${(u)${(ku)~path:#~/**}%%/##}) :
typeset -x -TU HOME_PATH home_path=(~/.*/([^0-9. ]##/)#bin(#q/rx)) :
# typeset -x ALT_PATH=${(zj,:,)HOME_PATH}:${OUTSIDE_PATH}
typeset -x -TU ALT_PATH=${HOME_PATH}:${OUTSIDE_PATH} alt_path :
typeset -x -TU OLD_PATH=$HOME/.ghcup/bin:$HOME/.cabal/bin:$HOME/.local/bin:$PATH old_path :
typeset -x -TU PATH=${ALT_PATH} path :

typeset -x -TU OLD_PKG_CONFIG_PATH=$PKG_CONFIG_PATH old_pkg_config_path :
# typeset -x -TU PKG_CONFIG_PATH pkg_config_path=(/nix/store/[[:alnum:]](#c32)-{libsodium-vrf-[[:xdigit:]](#c7)-dev,blst(-<0-99>(.<0-99>)#)#,secp256k1-[[:xdigit:]](#c7),systemd(-<0-999>(.<0-99>)#)#-dev}/**.pc(:h)) :
typeset -xTU PKG_CONFIG_PATH pkg_config_path :
grep -El '(lib(sodium-vrf|blst|secp256k1))|systemd' \
	/nix/store/[[:alnum:]](#c32)-\
{libsodium-vrf-[0-9a-f](#c7)-dev,blst(-<0-99>(.<0-99>)#)#,secp256k1-[0-9a-f](#c7),systemd(-<0-999>(.<0-99>)#)#-dev}\
/**.pc \
	| xargs -i dirname \{\} \
	| xargs echo \
	| read -A pkg_config_path

typeset -x PS1='%D{%H:%M} %y $ '
typeset -x EDITOR==vi
typeset -x GCM_CREDENTIAL_STORE=gpg
typeset -x GPG_TTY=$(tty)

typeset -x LUA_BINDIR=$(dirname =luajit)
typeset -x LUA_BINDIR_SET=yes

manupdate ()
{
	local -TU __MANDIRS __mandirs=(/(nix/store|run|share|usr|var)/**/man(-/))

	while read -A input_array
	do
		case ${input_array[1]} in
			MANPATH_MAP)
				__mandirs+=( ${input_array[3]}(-/) );;
			MANDB_MAP)
				__mandirs+=( ${input_array[2]}(-/) );;
			MANDATORY_MANPATH)
				__mandirs+=( ${input_array[2]}(-/) );;
		esac
	done < /etc/man_db.conf
	__mandirs+=${(-/)(/share/man /usr{/{local,X11R6},}{/share,}/man)}
	echo $__MANDIRS
	sudo mandb "$__MANDIRS"
	sudo catman -M "$__MANDIRS"
}

# Eliminate duplicates from a colon-separated path
cleanup_path ()
{
        # Why is the (u) modifier failing?
        # Why are there many colons just at the end?
        local -TU LOCAL_PATH=${(P)1} local_path :
        local -TU LOCAL_NEW_PATH local_new_path :
        # local -A local_table

        # for idx in {1..${#local_path[@]}}
        # do
                # if [[ ! -v local_table[${local_path[$idx]}] ]]
                # then
                        # local_table[${local_path[$idx]}]=$idx
			# local_new_path+=(${local_path[$idx]})
                # fi
        # done
        # test -n ${(P)1::=${(u)${(j,:,)local_path}%%:##}}
        test -n ${(P)1::=${LOCAL_PATH}}
}

eval "$(ssh-agent)"
eval "$(direnv hook zsh)"
