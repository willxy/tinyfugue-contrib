
; packages/talker_one_convert.tf:
;   Pure self-indulgence, this one makes channel one look like the rest of
;   the talker channels.
;
;   Set var_talker_one_attr to be whatever attribute set matches your
;   colour for talker one.  "/help attributes" for more on this, but in
;   short, the B makes it bold, the Cmagenta makes it magenta.  You're
;   bright people, you can work the rest of it out.
;
;   The reason this is so complicated is that it matches the colour of
;   the line, to make sure it really only matches talker chats.  If you
;    don't use colours, you can just make the body of the macro
;   /substitute (One) %{*}

/set var_talker_one_attr BCmagenta

/def -mregexp -t'^[A-Za-z]+ wisps[: ]' trigger_talker_one_convert = \
  /if ( regmatch( \
          strcat("@{", {var_talker_one_attr}, "}"), encode_attr({*})) > 0 ) \
    /substitute -a%{var_talker_one_attr} (One) %{*} %; \
  /endif

