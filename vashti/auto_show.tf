
; If you have auto show turned off on the MUD, this package may be useful
; for helping you deal with it.  It adds an alert message for incoming
; show requests, and then sets up two simple aliases for dealing with them.
; "sha" will accept the show without your having to type in the entirety
; of the show accept command, and "shr" will likewise reject it - useful for
; annoying delude spammers.
;
; Vashti vashti@dream.org.uk 2005

/def -F -mregexp -t'^([A-Za-z]*) offers you (.*) for inspection\.  Use' \
  trigger_show_offered = \
  /set var_last_show %{P1} %; \
  /echo -aBCcyan %{P1} is offering to show you %{P2}.  Use "shr" to reject it or "sha" to accept.
/alias sha show accept $[tolower({var_last_show})] %; /unset var_last_show
/alias shr show reject $[tolower({var_last_show})] %; /unset var_last_show

