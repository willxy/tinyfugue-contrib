;; from:
;;   http://www.etheridge.ca:80/source/database.tf
;; retrieved from:
;;   https://web.archive.org/web/20090420175010/http://www.etheridge.ca:80/source/database.tf

;; database.tf - A lousy database implementation
;; by Karen Etheridge, com.tcp@ether reversed, 1998.

;; This works with tf5.

;; Comments are spare as I didn't originally intend to publish this.



;; I'll have to look and see what is needed in these files
;/require -q strings.tf
;/require -q functions.tf

/loaded database.tf

;;; Externally-defined stuff:
;;;
; Dereferences a string pointer.
/def -i dereference=\
 /result %{1}

; (OJ's) Convert a player name into a unique id with no strange characters.
/test str2id_str := " !@#$%^&*()_-+=|\\~`{[}]:;\"'<,>.?/"

; doesn't encode ascii values; instead position in str2id_str. (2 digits).
/def -i str2id=\
    /let left=%; /let i=%;\
    /let right=%; /test right := tolower({*})%;\
    /while /test i := strchr(right, str2id_str) %; /test i >= 0%; /do \
        /test left := strcat(left, substr(right, 0, i), "A", \
          padnum(strchr(str2id_str, substr(right, i, 1)), 2), "Z")%;\
        /test right := substr(right, i + 1)%;\
    /done%;\
    /result strcat(left, right)




;; No spaces are permitted in key names.
;; Database names should be alphanumeric only. NO UNDERSCORE.

;; Reserved: all DB_cache_* names.

;; STILL NEED A RANDOMIZER
;; AND COUNTERS

;; /DB_set whois Miyu Miyu's a vampire!
;; /DB_get whois Miyu --> Miyu's a vampire!
;; /DB_get("whois", "Miyu") --> "Miyu's a vampire!"

;; /DB_set2 quote Miyu 3 Miyu smiles knowingly...
;; /DB_get2 quote Miyu 3 --> Miyu smiles knowingly...
;; /DB_get2("quote", "Miyu", 3) --> "Miyu smiles knowingly... "



;; for databases with one key

; /DB_set database-name key-name [value]
/def -i DB_set=\
  /let key=%; /test key := DB_cache_major_key({2}) %;\
  /set DB_%{1}_%{key}=%; /return (DB_%{1}_%{key} := {-2-1})

; /DB_get database-name key-name
/def -i DB_get=\
  /let key=%; /test key := DB_cache_major_key({2}) %;\
;/_echo $[strcat("DB_", {1}, "_", key)] %;\
  /result dereference(strcat("DB_", {1}, "_", key))
;  /eval /result {DB_%{1}_%{key}}

; /DB_inc database-name key-name [value]
/def -i DB_inc=\
  /let key=%; /test key := DB_cache_major_key({2}) %;\
  /if ({3} !~ "") \
    /return (DB_%{1}_%{key} ? DB_%{1}_%{key} := DB_%{1}_%{key} + {3} : \
      $$(/set DB_%{1}_%{key}=%{3})) %;\
  /else \
    /return (DB_%{1}_%{key} ? ++DB_%{1}_%{key} : $$(/set DB_%{1}_%{key}=1)) %;\
  /endif

; /DB_dec database-name key-name [value]
/def -i DB_dec=\
  /let key=%; /test key := DB_cache_major_key({2}) %;\
  /if ({3} !~ "") \
    /return (DB_%{1}_%{key} := DB_%{1}_%{key} - {3}) %;\
  /else \
    /return (--DB_%{1}_%{key}) %;\
  /endif

; /DB_clear database-name key-name
/def -i DB_clear=\
  /let key=%; /test key := DB_cache_major_key({2}) %;\
  /unset DB_%{1}_%{key}

; /DB_clearall database-name
/def -i DB_clearall=\
  /quote -S /unset `/listvar -gs -mregexp ^DB_%{1}_[a-zA-Z0-9]*$$$


;; For databases with a major and minor key

; /DB_set2 database-name major-key-name minor-key-name [value]
/def -i DB_set2=\
  /let major_key=%; /test major_key := DB_cache_major_key({2}) %;\
  /let minor_key=%; /test minor_key := DB_cache_minor_key({3}) %;\
  /set DB_%{1}_%{major_key}_%{minor_key}=%;\
  /return DB_%{1}_%{major_key}_%{minor_key} := {-3-1}

; /DB_get2 database-name major-key-name minor-key-name
/def -i DB_get2=\
  /let major_key=%; /test major_key := DB_cache_major_key({2}) %;\
  /let minor_key=%; /test minor_key := DB_cache_minor_key({3}) %;\
  /result dereference(strcat("DB_", {1}, "_", major_key, "_", minor_key))
;  /eval /result {DB_%{1}_%{major_key}_%{minor_key}}

; /DB_inc2 database-name major-key-name minor-key-name [value]
/def -i DB_inc2=\
  /let major_key=%; /test major_key := DB_cache_major_key({2}) %;\
  /let minor_key=%; /test minor_key := DB_cache_minor_key({3}) %;\
  /if ({4} !~ "") \
    /return (DB_%{1}_%{major_key}_%{minor_key} ? \
             DB_%{1}_%{major_key}_%{minor_key} := \
               DB_%{1}_%{major_key}_%{minor_key} + {4} : \
             $$(/set DB_%{1}_%{major_key}_%{minor_key}=%{4})) %;\
  /else \
    /return (DB_%{1}_%{major_key}_%{minor_key} ? \
             ++DB_%{1}_%{major_key}_%{minor_key} : \
             $$(/set DB_%{1}_%{major_key}_%{minor_key}=1)) %;\
  /endif

; /DB_dec2 database-name major-key-name minor-key-name [value]
/def -i DB_dec2=\
  /let major_key=%; /test major_key := DB_cache_major_key({2}) %;\
  /let minor_key=%; /test minor_key := DB_cache_minor_key({3}) %;\
  /if ({4} !~ "") \
    /return (DB_%{1}_%{major_key}_%{minor_key} ? \
             DB_%{1}_%{major_key}_%{minor_key} := \
               DB_%{1}_%{major_key}_%{minor_key} - {4} : \
             $$(/set DB_%{1}_%{major_key}_%{minor_key}= $[ -1 * {4} ])) %;\
  /else \
    /return (DB_%{1}_%{major_key}_%{minor_key} ? \
             --DB_%{1}_%{major_key}_%{minor_key} : \
             $$(/set DB_%{1}_%{major_key}_%{minor_key}=0)) %;\
  /endif

; /DB_clear2 database-name major-key-name minor-key-name
/def -i DB_clear2=\
  /let major_key=%; /test major_key := DB_cache_major_key({2}) %;\
  /let minor_key=%; /test minor_key := DB_cache_minor_key({3}) %;\
  /unset DB_%{1}_%{major_key}_%{minor_key}

; /DB_clear_major database-name major-key-name
; Clears all entries matching that major key.
/def -i DB_clear_major=\
  /let major_key=%; /test major_key := DB_cache_major_key({2}) %;\
  /quote -S /unset `/listvar -gs -mregexp \
    ^DB_%{1}_%{major_key}_[a-zA-Z0-9]*$$$

; /DB_clearall2 database-name
/def -i DB_clearall2=\
  /quote -S /unset `/listvar -gs -mregexp ^DB_%{1}_[a-zA-Z0-9]*_[a-zA-Z0-9]*$$$

; DB_rand_minor database-name glob-for-minor-key
; Does a random lookup on the entire database, which matches the minor key
; e.g. DB_rand_minor quote [1-9]*  returns a random VALUE
/def -i DB_rand_minor=\
  /let key=%; /test key := {2} %;\
  /result $(/listvar -gs -mglob DB_%{1}_*_%{key} %| /random_line)


; DB_count database-name glob-for-minor-key
/def -i DB_count=\
  /let minor_key=%; /test minor_key := DB_cache_minor_key({2}) %;\
  /result $(/listvar -gs -mglob DB_%{1}_*_%{minor_key} %| /echo %?)


;;; Internal routines

; Internal: cache the key for faster processing.
/def -i DB_cache_major_key=\
  /if (DB_cache_majorkey_raw !~ {1}) \
    /set DB_cache_majorkey_raw=%; /test DB_cache_majorkey_raw := {1} %;\
    /set DB_cache_majorkey_encoded=%;\
    /test DB_cache_majorkey_encoded := str2id({1}) %;\
  /endif %;\
  /result DB_cache_majorkey_encoded

/def -i DB_cache_minor_key=\
  /if (DB_cache_minorkey_raw !~ {1}) \
    /set DB_cache_minorkey_raw=%; /test DB_cache_minorkey_raw := {1} %;\
    /set DB_cache_minorkey_encoded=%;\
    /test DB_cache_minorkey_encoded := str2id({1}) %;\
  /endif %;\
  /result DB_cache_minorkey_encoded


;;; New routine!

; load a file into a database, one line at a time.
; Allows for later random access.

/def -i DB_load_file=\
  /let key=%1 %; /let file=%2 %;\
  /let i=0 %;\
  /def -i _store=\
    /test DB_set(key, i, {*}) %%;\
     /test i := i + 1 %;\
  /quote -S /_store '%file %;\
;  /quote -S /_echo '%file %;\
  /test DB_set(key, 'count', i) %;\
  /undef _store



