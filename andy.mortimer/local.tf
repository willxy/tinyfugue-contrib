; $Id: local.tf,v 1.1 1996/11/20 15:01:15 asm21 Exp $
; $Log: local.tf,v $
; Revision 1.1  1996/11/20 15:01:15  asm21
; Initial revision
;
; Revision 1.7  1996/06/26 13:10:25  asm21
; Ooops! Bugfixed /load for files in personal library directory
;
; Revision 1.6  1996/06/26 12:57:37  asm21
; Redefinition of /load command to allow local and personal library directories,
; in addition to the standard one.
;
; Revision 1.5  1996/05/24 20:33:23  asm21
; *** empty log message ***
;
; Revision 1.4  1996/05/24 20:20:24  asm21
; *** empty log message ***
;
; Revision 1.3  1996/05/24 19:54:05  asm21
; *** empty log message ***
;
; Revision 1.2  1996/05/23 18:23:49  asm21
; Added /edit reedit= from nreedit.tf here.
;
; Revision 1.1  1996/05/17 13:26:21  asm21
; Initial revision
;

/~loaded local.tf

;;; ========== set up some system parameters
/edit -i COMPRESS_SUFFIX = .gz

;;; ========== Setup the local timezone
/set tzlocal GMT

;;; ========== hook to change X title when go to new world
/if (%{TERM} =~ "xterm") \
  /require tools.tf \
  /def -i -h"WORLD" x_fg_hook=/xtitle TinyFugue - ${world_name} (${world_character})%; \
/endif

;;; ========== Redefine the /reedit command
/require tools.tf
/edit -i reedit = \
  /let mac=$(/cddr $(/list -i - %{L-@}))%; \
  /let mac=$[strcat("/edit", substr(mac, strchr(mac, " ")))]%; \
  /grab %{mac} 

;;; ========== Allow the use of local libraries etc
;; this works by redefining the /load command to look in the local library
;; directory TFLOCALLIBDIR and then in a personal library directory
;; TFPERSONALLIBDIR whenever the internal /@load command fails and the
;; pathname is non-absolute. Also redefine /require to use plain /load,
;; without a directory.

; if the user hasn't set this, set it ourselves.
/if ( %{TFLOCALLIBDIR} =~ "" ) /set TFLOCALLIBDIR=/usr/local/lib/games/tf-local%; /endif

; Stop /require adding the library path, since /load does it anyhow.
/edit -i require = \
    /if /test _loaded_libs !/ "*{%{1}}*"%; /then \
        /load %{1}%;\
    /endif

; note that this *must* be reentrant, since /loaded files often load others.
; (If the given pathname is absolute, this is precisely /@load.)
; This could perhaps use one-shot hooks to make it a bit neater.

; squash the conflict with external command warning
/def -ag -hCONFLICT ~gagconflict

/def -i load = \
; if it's not an absolute path, add a LOADFAIL hook
  /if ( %{1} !/ "/*" & %{1} !/ "~*" ) \
    /if ( %{TFLOCALLIBDIR} !~ "" ) \
; ensure we check for %1 with a path before it, etc
      /eval /def -ag -h"LOADFAIL *%1 No such file or directory" ~ldrethk%1 = \
        /if ( %%%{TFPERSONALLIBDIR} !~ "" ) \
          /edit -ag ~ldrethk%1 = \
  	    /edit -ag ~ldrethk%1 = /echo %%%% %1: No such file or directory%%%%; \
            /@load %%%{TFPERSONALLIBDIR}/%1%%%; \
        /else \
          /edit -ag ~ldrethk%1 = /echo %%%% %1: No such file or directory%%%; \
        /endif%%%; \
        /@load %{TFLOCALLIBDIR}/%1%; \
    /elseif ( %{TFPERSONALLIBDIR} !~ "" ) \
      /eval /def -ag -h"LOADFAIL %1 No such file or directory" ~ldrethk%1 = /echo %%% %1: No such file or directory%; \
      /@load %{TFPERSONALLIBDIR}/%1%; \
    /else \
; if there are no other library paths, just make something we can /undef later.
      /def ~ldrethk%1%; \
    /endif%; \
  /endif%; \
; this will check the current directory and TFLIBDIR
  /@load %1%; \
  /if ( %{1} !/ "/*" & %{1} !/ "~*" ) /undef ~ldrethk%1%; /endif

/undef ~gagconflict

;;; ========== load the user-flag functions
;; I hope this'll become part of stdlib.tf at some point, but until then ...
/def -hload -ag ~gagload
/require usrflag.tf
/undef ~gagload
