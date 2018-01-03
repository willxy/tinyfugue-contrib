; $Id: vieworld.tf,v 1.1 1996/11/20 15:01:15 asm21 Exp $

/~loaded vieworld.tf

;;; ========== Introduction
;;; this set of tf macros enables you to redirect selected parts of the
;;; output from one world into a specially created read-only world.

;;; Please note that, although they can be, these commands are not designed
;;; for use with knot chat or similar --- see the commands in sepchat.tf
;;; instead.

;;; ========== New world-type for separated chat
;; override default hooks
/def -i -p99 -hLOGIN -T"vieworld"
/def -i -p99 -hCONNECT -T"vieworld" = \
  /eval /echo %% Opened view world ${world_name}.

;; send hook --- redirect to the parent world, using %{<world>_ccomm} as a
;; template.
/def -i -hSEND -T"vieworld" -p9999 -ag = \
  /echo % This is a read-only viewing world!

;;; /open_vworld <name> <trigger-regexp>

/def -i open_vworld = \
  /if /test "%2" =~ ""%; /then \
    /echo % Parameter error.%; \
  /else \
    /eval /def -i -ag -p1 -mregexp -F -t"%-1" -w${world_name} viewcomm_%1 = /send -w"%1" %%%*%; \
    /eval /addworld -T"vieworld" %1 localhost echo%; \
    /connect %1%; \
;; squelch the `% Trigger in world blah.' message
    /def -i -ag -hBACKGROUND -w"%1"%; \
  /endif

;;; /close_vworld <name>

/def -i close_vworld = \
  /if /test "%1" =~ ""%; /then \
    /echo % Parameter error.%; \
  /else \
    /dc %1%; \
    /undef viewcomm_%1%; \
    /unworld %1%; \
  /endif

;;; /defer_vworld <host-world> <name> <trigger-regexp>
;;; opens a vieworld when the trigger comes up for the first time. This macro
;;; has a higher priority than the viewcomm_* macro, and runs first. I hope.
;;; designed for inclusion in .tfrc

/def -i defer_vworld = \
  /if /test "%2" =~ ""%; /then \
    /echo % Parameter error.%; \
  /else \
    /eval /def -i -ag -p3 -mregexp -t"%-2" -w"%1" -F -1 defer_vworld_%2 = \
      /echo %%% Opening deferred vieworld...%%%; \
      /open_vworld %2 %-2%; \
  /endif
