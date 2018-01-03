
; This is what I use to keep track of what's happening to my hit points,
; guild points and xp.  It matches both score brief and the combat monitor
; (which have slightly different output).  It makes them both look like this:
;
; Hp: 1683 (1683) [0]  Gp: 59 (207) [2]  Xp: 91024 [3]
;
; The numbers in square brackets are the difference between the last
; reading and the current one - so since my last monitor flashed up,
; I gained 0hp, 2gp and 3xp.
;
; A lot of people do this with /echo, but I like this method better. :)
;
; 29th October 2004:
;   Fixed bug with bold colours not being detected.

/def -F -mregexp \
  -t'^(Hp: ([0-9]+) ?\([0-9]+\)) +(Gp: ([0-9]+) ?\(([0-9]+)\)) +(Xp: ([0-9]+))$' \
  trigger_hp_mon = \
    /set var_mon1 %{P1} %; /set var_mon2 %{P2} %; /set var_mon3 %{P3} %; \
    /set var_mon4 %{P4} %; /set var_mon5 %{P5} %; /set var_mon6 %{P6} %; \
    /set var_mon7 %{P7} %; \
    /test regmatch("@{(B?C[a-z]+)}", encode_attr({*})) %; \
    /substitute -ax%{P1} %{var_mon1} [$[{var_mon2} - {var_hp}]]  %{var_mon3} [$[{var_mon4} - {var_gp}]]  %{var_mon6} [$[{var_mon7} - {var_xp}]] %; \
    /set var_hp %{var_mon2} %; /set var_gp %{var_mon4} %; \
    /set var_max_gp %{var_mon5} %; /set var_xp %{var_mon7}

