; $Id: info.tf,v 1.1 1996/11/20 15:01:15 asm21 Exp $

;;; A set of useful commands for getting various types of information about
;;; a world.

/~loaded info.tf

;; ========== Miscellanous

; /think <expr>
/def -i think=@pemit me=%0

;; ========== Other Players

; /idle <player>
; /conn <player>
/def -i idle=/think %1 has been idle for [cat([div(idle(%1),60)]m,[mod(idle(%1),60)]s)]
/def -i conn=/think %1 has been connected for [cat(\[div(conn(%1),60)]m,[mod(conn(%1),60)]s)]

;; ========== Your Location

; /loc
; /exits
/def -i loc=/think [name(here)]
/def -i exits=/think [parse(lexits(here),[name(##)];)]
