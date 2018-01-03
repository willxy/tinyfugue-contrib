; $Id: tfrc.tf,v 1.19 1997/04/26 21:48:36 asm21 Exp $

/eattr.tf

/echo % $Id: tfrc.tf,v 1.19 1997/04/26 21:48:36 asm21 Exp $

; don't give any messages on loading anything in here, cos it looks ugly.
; NB: /undef'd at the end of the file.
/def -hload -ag ~gagload

;; ========== Setup Directories
/cd ~/mush
/set TFPERSONALLIBDIR=~/mush/tf
;/edit -i MACROFILE	= ~/mush/tf/macros.tf
;/edit -i HILITEFILE	= ~/mush/tf/hilite.tf
;/edit -i GAGFILE	= ~/mush/tf/gag.tf
;/edit -i TRIGFILE	= ~/mush/tf/trig.tf
;/edit -i BINDFILE	= ~/mush/tf/bind.tf
;/edit -i HOOKFILE	= ~/mush/tf/hook.tf
;/edit -i WORLDFILE	= ~/mush/tf/world.tf
/edit -i LOGFILE	= tiny.log
; for my auto-logging functions
/set LOGDIR=~/mush/logs

;; ========== General params
/set hiliteattr=B
; so we don't get the message about pressing TAB
/set more on
/set vis_style emacs
/quiet on
/set oldslash=off
/set quitdone=on
;/xtitle TinyFugue
/set wrapspace 2
/set clock=24-hour
; allow us to redefine macros using /def
/set redef on
; enable partial substitution on the commandline
/set sub on
; setup screen. This is not ideal.
;/set lines 40
;/set columns 132
; put all the TinyMUSH flags in normal case (tiny.tf)
/set tinyflags=on

;; ========== Misc Libraries
/echo % Loading extra required commands ...
; ESC-w to go to next active world
  /require world-q.tf
; ESC-DOWN to 'push' current command; ESC-UP to 'pop'
  /require kbstack.tf
; /sys, /xtitle, a few more
  /require tools.tf
; /eattr (Attribute editing capability)
  /require eattr.tf
; automatic logging
  /require autolog.tf
; various misc commands for getting info
  /require info.tf
; finger command
  /require finger.tf
; spell-checking of the input line etc
  /require ispell.tf
; slightly more user-friendly interface to the places code
  /require places.tf
; timezone support
;  /require time.tf
; local commands
  /require lcomm.tf
; separated chat worlds
;  /require sepchat.tf
; view worlds
;  /require vieworld.tf
; interesting menus etc (currently only /worldmenu)
;  /require menus.tf
; highlighting etc for TinyMUSH (tiny.mush and subtypes)
  /require tiny.tf

;;; ========== check hermes mail
/require tools.tf
/def -i hermail=/sys hermail %*

;; ========== Load all my stuff

/echo % Loading world definitions etc ...

;; define local commands---implemented in individual world files
; local who
/deflcomm lwho local who
; chat
/deflcomm c knot chat

; load all worlds
/require world.tf



/echo % Setting up ...

;; ========== Automatically ping tiny worlds
;/require ping.tf
;/def -mglob -T{tiny|tiny.*} -hCONNECT -iF = /eval /ping_world ${world_name}

;; ========== Make 'you say' into 'Andy says' or whatever
/def -p99 -mregexp -t'^You say ' -F -i yousay_trig=/substitute ${world_character} says %{PR}

;; ========== Functions to beep when idle
/def -i goidle=/def -i -t'*' -p1000 -F -ab idle_beep%; /echo % Idling ...
/def -i unidle=/undef idle_beep%; /echo % Unidled.

;;; ========== Logging of input history, a little like .bash_history
; ensure it doesn't get too big
/sys mv ~/.tf_history ~/.hist_tmp
/sys tail -n 500 < ~/.hist_tmp > ~/.tf_history
/sys rm ~/.hist_tmp
; read the original file into the input history
/quote -dexec -S /recordline -i '~/.tf_history
; start logging input onto the end of the original file, but don't tell anyone!
/def -h"LOG /home/asm21/.tf_history" -ag
/log -i ~/.tf_history

;;; ========== VGA Palette setting and other console functions
/require tools.tf
/def -i chvt=/sys chvt %1
/def -i vgapal=/sh /usr/local/bin/vgapalette /etc/vga-palette
/vgapal

;;; ========== Generic highlighting

/require tiny.tf
/hilite_page
/hilite_whisper

/def -i -p1 -abhCred -F -h"ACTIVITY"
/def -i -p1 -aCcyan -F -h"WORLD"
/set tinyworldattr=Ccyan

;;; ========== Local keybindings

; HOME for local WHO, END for global WHO
; local WHO relies on you having set the lwho_* variables
/def -i -b'^[[H' = /lwho
/def -i -b'^[Ow' = /send -w WHO
 
; ESC and left/right arrows cycle through worlds
/def -ib'^[^[[C' = /dokey socketf
/def -ib'^[^[0C' = /dokey socketf
/def -ib'^[^[[D' = /dokey socketb
/def -ib'^[^[0D' = /dokey socketb

; ESC-ENTER lists connected worlds
/def -ib'^[^M' = /listsockets

; ESC-c toggles between world and chat-world (was capitalise)
/unbind ^[c
/def -ib'^[c' = /tc

; ESC-l toggles saving of the log for the current world
/unbind ^[l
/def -i -b'^[l' =/togglesavelog

; ESC-r recalls the last 10 lines in the current world. Note that if you're
;	using chat worlds, any activity there will be taken off the 10 lines,
;	although they won't be shown in the recall. The upshot of this is that
;	you may very well get a blank response from this!
; ESC-a recalls the last 2 lines, as above.
/def -ib'^[r' = /recall 10
/def -ib'^[a' = /recall 2

/echo % Local setup complete.

/eval /echo %% Loaded libraries are: %{_loaded_libs}

; I usually end up doing this anyway, so ... pause to allow the login etc to go past
;/repeat -10 1 /goidle

/repeat -10 1 /def -i -t'*Baumina*' -wAndy -p1000 -F -ab andy_beep

; allow load messages again
/undef ~gagload
