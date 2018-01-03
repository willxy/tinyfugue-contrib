; $Id: pairlist.tf,v 1.1 1996/11/20 15:01:15 asm21 Exp $

;;; Note that this means you can't have multiple-word keys or values.

/~loaded pairlist.tf

;; get the associated data for a particular index.

;; all the following functions assume that the given key name is unique, and
;; their behaviour is undefined if this is not the case. :P

;; /getpair [-i] <index> <data-list-var>
;;     where <index> is the start of the key you want the value of, and 
;;     <data-list-var> is the name of the variable containing the list.
;;    
;;     If you specify the -i flag, the search will be case-insensitive.
;;    
;;     returns (using /echo) ERR on an error, or the data value otherwise.

;; /addpair <data-list-var> <index> <data>
;;     Adds a pair to the list

;; /listpairs <data-list-var>
;;     Lists the pairs contained in the list

;; /removepair <data-list-var> <key>
;;     Removes the specified pair from the list. This function requires the
;;     *exact* keyname, both in length and in case.

/def -i getpair= \
  /if (%1 =~ "-i") \
    /let case=no%; \
    /shift%; \
  /else \
    /let case=yes%; \
  /endif%; \
  /if (%# == 2) \
    /let idx=%1%; \
    /if (case =~ "no") /let idx=$[tolower(idx)]%; /endif%; \
    /let data=%2%; \
    /let data=$(/eval /eval /echo %%{%{data}})%; \
    /let rv=%; \
    /while (data !~ "") \
      /let sp=$[strchr(data, " ")]%; \
      /let key=$[substr(data, 0, sp)]%; \
      /if (case =~ "no") /let key=$[tolower(key)]%; /endif%; \
      /let data=$[substr(data, sp + 1)]%; \
      /let sp=$[strchr(data, " ")]%; \
      /if (sp == -1) /let sp=$[strlen(data)]%; /endif%; \
      /let dat=$[substr(data, 0, sp)]%; \
      /let data=$[substr(data, sp + 1)]%; \
;     if this is an exact match, stop.
      /if (key =~ idx) \
        /let rv=%{dat}%; \
	/let data=%; \
      /endif%; \
;     if it is a perfix match, record it, but carry on anyway.
      /if (substr(key, 0, strlen(idx)) =~ idx) \
        /let rv=%{dat}%; \
      /endif%; \
    /done%; \
    /eval /echo - %{rv-ERR}%; \
  /else \
    /echo ERR%; \
  /endif

/def -i addpair= \
  /if (%# == 3) \
    /eval /eval /set %1=%%{%1} %2 %3%; \
  /else \
    /echo % Incorrect Parameters.%; \
  /endif

/def -i getfullkeyname = \
  /if (%1 =~ "-i") \
    /let case=no%; \
    /shift%; \
  /else \
    /let case=yes%; \
  /endif%; \
  /if (%# == 2) \
    /let idx=%2%; \
    /if (case =~ "no") /let idx=$[tolower(idx)]%; /endif%; \
    /let data=%1%; \
    /let data=$(/eval /eval /echo %%{%{data}})%; \
    /let rv=%; \
    /while (data !~ "") \
      /let sp=$[strchr(data, " ")]%; \
      /let key=$[substr(data, 0, sp)]%; \
      /let prettykey=%{key}%; \
      /if (case =~ "no") /let key=$[tolower(key)]%; /endif%; \
      /let data=$[substr(data, sp + 1)]%; \
      /let sp=$[strchr(data, " ")]%; \
      /if (sp == -1) /let sp=$[strlen(data)]%; /endif%; \
      /let data=$[substr(data, sp + 1)]%; \
;     if this is an exact match, stop.
      /if (key =~ idx) \
        /let rv=%{prettykey}%; \
	/let data=%; \
      /endif%; \
;     if it is a prefix match, record it, but carry on anyway.
      /if (substr(key, 0, strlen(idx)) =~ idx) \
        /let rv=%{prettykey}%; \
      /endif%; \
    /done%; \
    /eval /echo %{rv}%; \
  /endif

/def -i removepair = \
  /if (%# == 2) \
    /let idx=%2%; \
    /let data=%1%; \
    /let data=$(/eval /eval /echo %%{%{data}})%; \
    /let newdata=%; \
    /let removed=0%; \
    /while (data !~ "") \
      /let sp=$[strchr(data, " ")]%; \
      /let key=$[substr(data, 0, sp)]%; \
      /let data=$[substr(data, sp + 1)]%; \
      /let sp=$[strchr(data, " ")]%; \
      /if (sp == -1) /let sp=$[strlen(data)]%; /endif%; \
      /let dat=$[substr(data, 0, sp)]%; \
      /let data=$[substr(data, sp + 1)]%; \
      /if (key !~ idx) \
        /let newdata=%{newdata} %{key} %{dat}%; \
      /else \
        /let removed=1%; \
      /endif%; \
    /done%; \
    /if (removed) \
;     we get a leading space, so...
      /if (newdata !~ "") /let newdata=$[substr(newdata, 1)]%; /endif%; \
      /set %1=%{newdata}%; \
    /else \
      /eval /echo %% Keyname %2 not found!%; \
    /endif%; \
  /else \
    /echo % Incorrect number of arguments.%; \
  /endif

/def -i listpairs = \
  /let data=%1%; \
  /let data=$(/eval /eval /echo %%{%{data}})%; \
  /let max=0%; \
  /while (data !~ "") \
    /let sp=$[strchr(data, " ")]%; \
    /if (sp > max) /let max=%{sp}%; /endif%; \
    /let data=$[substr(data, sp + 1)]%; \
    /let sp=$[strchr(data, " ")]%; \
    /if (sp == -1) /let sp=$[strlen(data)]%; /endif%; \
    /let data=$[substr(data, sp + 1)]%; \
  /done%; \
  /foreachpair %1 /echo - %%{key}$$[strrep(" ", max - strlen(key))]  -->  %%{dat}

;; ========== Helper macros

;; /foreachpair <list-var> <command>
;;         calls <command> once for each pair, with the key in %{key} and
;;	   the data in %{dat}.
;;     *** REMEMBER to double all symbols like % and $ ***
;;         Note that /let, being scoped, doesn't work that well within this
;;	   construct.

/def -i foreachpair = \
  /let data=%1%; \
  /shift%; \
  /let data=$(/eval /eval /echo %%{%{data}})%; \
  /while (data !~ "") \
    /let sp=$[strchr(data, " ")]%; \
    /let key=$[substr(data, 0, sp)]%; \
    /let data=$[substr(data, sp + 1)]%; \
    /let sp=$[strchr(data, " ")]%; \
    /if (sp == -1) /let sp=$[strlen(data)]%; /endif%; \
    /let dat=$[substr(data, 0, sp)]%; \
    /let data=$[substr(data, sp + 1)]%; \
    /eval %*%; \
  /done
