; $Id: eattr.tf,v 1.2 1996/12/02 14:35:28 asm21 Exp $

;; brings up the specified attribute in the buffer, for editing
;; uses TinyMUSH attribute-specification syntax, ie:
;;
;; /eattr [[<object>/]<attribute>]
;;
;; If <object> is omitted, `me' is assumed; if both are omitted, /eattr will
;; fetch `me/desc' (ie, your description).

;; This file also defines /edef to call /reedit, for aesthetic reasons only.

/~loaded eattr.tf

/def -i eattr = \
; this changes the order of evaluation, so it works. There must be a neater
; way, though...
  /let parms=%1%; \
  /let slp=$[strchr(%{parms}, "/")]%; \
  /if /test slp != -1%; /then \
;   if we have an object/attribute pair, then take it
    /let obj=$[substr(%{parms}, 0, %{slp})]%; \
    /let attr=$[substr(%{parms}, %{slp} + 1, 999)]%; \
  /else \
;   otherwise, take the parameter (if there is one) to be the attribute
    /let attr=%1%; \
  /endif%; \
; default values
  /let attr=%{attr-desc}%; \
  /let obj=%{obj-me}%; \
  /eval /echo %% Fetching %{obj}/%{attr} for editing...%; \
; define a one-shot trigger, this world only, to catch the output of this attr
  /def -mglob -n1 -t'{%{attr}:*|%{attr}(#*):*}*' -w${world_name} -F -ag = \
;   this uses the same trick as above.
    /let parms=%%*%%; \
    /let clp=$$[strchr(parms, ":")]%%; \
    /let txt=$$[substr(parms, clp + 1)]%%; \
;   insert the text into the keyboard buffer
    /grab &%{attr} %{obj}=%%{txt}%; \
; and finally, ask the MUSH for the value of the attribute
  /send ex %{obj}/%{attr}

/def -i edef = /reedit %*
