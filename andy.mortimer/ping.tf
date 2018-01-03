;$Id: ping.tf,v 1.1 1996/11/20 15:01:15 asm21 Exp $

;; NOTE that this style of thing is frowned on by a lot of games, especially the more serious ones, so do check before
;; using it.

;;; ========== `Ping'
; make sure we stay connected to all worlds by forcing each player to 'do'
; a comment every 50 minutes or so - produces no output!
; use /ping_start [<interval>] to start this
/def -i do_ping = 
/def -i ping = /echo %% Pinging all worlds.%;/send -W @force me=@@
/def -i ping_keep_alive = /ping%; /repeat -0:48:30 1 /ping_keep_alive
/def -i ping_start = /echo %% Ping initialised.%;/repeat -%{1-0:50} 1 /ping_keep_alive

; Or, use /ping_world <world> for each world you want to ping.
/def -i ping_world = \
  /send -w%1 @force me=@@%; \
  /repeat -0:48:30 1 /ping_world %1
