
; This monitors the xp rate you are making, on average.
; It counts the xp you make every five minutes, and extrapolates to tell
; you how much you would have made at the end of an hour.
;
; Vashti vashti@dream.org.uk 24th October 2005.

/set var_avxp_five_min 300

/def avxp_set_base_time = \
  /if ( {var_avxp_base_time} =~ "" ) \
    /test regmatch("^([0-9]+)", time()) %; \
    /set var_avxp_base_time %{P1} %; \
  /endif %; \

/avxp_set_base_time

/if ( {var_avxp_five_total} =~ "" ) \
  /set var_avxp_five_total 0 %; \
/endif

/def -F -E'var_avxp_base_time' -mregexp \
  -t'^Hp: [0-9]+ ?\([0-9]+\) +Gp: [0-9]+ ?\([0-9]+\) +Xp: ([0-9]+)$' \
  trigger_avxp_monitor_check = \
    /if ( {var_avxp_xp_prev} =~ "" ) \
      /set var_avxp_xp_prev %{P1} %; \
      /return %; \
    /endif %; \
    /set var_avxp_xp_diff $[{P1} - {var_avxp_xp_prev}] %; \
    /set var_avxp_xp_prev %{P1} %; \
    /if ( {var_avxp_xp_diff} >= 0 ) \
      /test {var_avxp_five_total} += {var_avxp_xp_diff} %; \
    /endif %; \
    /test regmatch("^([0-9]+)", time()) %; \
    /set var_avxp_tmp %{P1} %; \
    /set var_avxp_diff $[{var_avxp_tmp} - {var_avxp_base_time}] %; \
    /if ( {var_avxp_diff} > {var_avxp_five_min} ) \
      /echo -aBCcyan In the last five minutes, you made %{var_avxp_five_total} xp. ($[{var_avxp_five_total} * 12] xp/hour) %; \
      /set var_avxp_base_time %{var_avxp_tmp} %; \
      /set var_avxp_five_total 0 %; \
    /endif

