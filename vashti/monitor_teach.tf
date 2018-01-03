
; This trigger monitors how much xp you need to learn your next level of
; a skill, and tells you when you have enough xp.
;
; This package will use the persistent_variables package to save your
; teaching status if it's available, but doesn't require it.
;
; This only works for teaching from yourself or from other players.
; It doesn't work for in-guild advancement, and obviously if you TM
; the skill you're saving up for it will throw off the count.
;
; Use /teach to see how much xp you have to go before you can learn.
; The package adds a status field to tell you when you can learn, in
; case you miss the message.
;
; Vashti vashti@dream.org.uk 21st August 2005.
;
; 26th October 2005 - Made persistent_variables optional.

/set var_teach_total 0
/set var_teach_skill 0
/set var_teach_levels 0
/set var_teach_diff 0
/set var_teach_teacher 0
/set var_stat_teach_flag NO

/set var_teach_flag_caption Teaching:
/set status_attr_var_var_teach_flag_caption B
/status_add -A -s2 -x var_teach_flag_caption:9
/status_add -Avar_teach_flag_caption -s0 -x var_stat_teach_flag:3

/def reset_teaching = \
    /set var_stat_teach_flag NO %; \
    /set status_attr_var_var_stat_teach_flag n %; \
    /if ( has_persistent_variables ) /save_status %; /endif

/def -F -mregexp \
  -t'^([^ ]+) offers to teach you ([0-9]+) (levels?) of (.*) for ([0-9]+) xp\.$' \
  trigger_teaching_tracker_1 = \
    /set var_teach_teacher %{P1} %; \
    /set var_teach_levels %{P2} %; \
    /set var_teach_level_name %{P3} %; \
    /set var_teach_skill %{P4} %; \
    /set var_teach_total %{P5}

/def -F -mregexp \
  -t'^It would have cost ([0-9]+) xp to teach ([0-9]+) (levels?) of (.*) to (yourself|you from (.*))\.$' \
  trigger_teaching_tracker_2 = \
    /set var_teach_total %{P1} %; \
    /set var_teach_levels %{P2} %; \
    /set var_teach_level_name %{P3} %; \
    /set var_teach_skill %{P4} %; \
    /if ( {P5} =~ "yourself" ) \
      /set var_teach_teacher %{P5} %; \
    /else \
      /set var_teach_teacher %{P6} %; \
    /endif %; \
    /reset_teaching

/def -F -E'var_teach_total' -mregexp \
  -t'^Hp: [0-9]+ ?\([0-9]+\) +Gp: [0-9]+ ?\([0-9]+\) +Xp: ([0-9]+)$' \
  trigger_teaching_report = \
    /set var_teach_xp %{P1} %; \
    /calc_teach_diff %; \
    /if ( {var_teach_diff} > 0 ) \
      /return %; \
    /endif %; \
    /echo -aBCcyan You can now learn %{var_teach_levels} %{var_teach_level_name} of %{var_teach_skill} from %{var_teach_teacher} for %{var_teach_total} xp. %; \
    /set var_teach_total 0 %; \
    /set var_teach_diff 0 %; \
    /set var_stat_teach_flag YES %; \
    /set status_attr_var_var_stat_teach_flag BCred %; \
    /if ( has_persistent_variables ) /save_status %; /endif

/def calc_teach_diff = \
  /if ( {var_teach_xp} == 0 ) \
    /set var_teach_xp %{var_xp} %; \
  /endif %; \
  /set var_teach_diff $[{var_teach_total} - {var_teach_xp}]

/def teach = \
  /if ( {var_teach_total} == 0 & {var_teach_diff} == 0 ) \
    /echo -aBCcyan You are not learning anything at the moment. %; \
    /return %; \
  /endif %; \
  /calc_teach_diff %; \
  /if ( {var_teach_total} <= 0 ) \
    /echo -aBCcyan You can now learn %{var_teach_levels} %{var_teach_level_name} of %{var_teach_skill} from %{var_teach_teacher} for %{var_teach_total} xp. %; \
    /return %; \
  /endif %; \
  /echo -aBCcyan You need another %{var_teach_diff} xp before you can learn %{var_teach_levels} %{var_teach_level_name} of %{var_teach_skill} from %{var_teach_teacher}.

/def -F -mregexp -t'^(You|[^ ]+) starts? to teach you(rself)? [0-9]+ levels? (in|of) ' \
  trigger_teaching_reset_1 = /reset_teaching

