; VL Verilog Toolkit
; Copyright (C) 2008-2014 Centaur Technology
;
; Contact:
;   Centaur Technology Formal Verification Group
;   7600-C N. Capital of Texas Highway, Suite 300, Austin, TX 78731, USA.
;   http://www.centtech.com/
;
; This program is free software; you can redistribute it and/or modify it under
; the terms of the GNU General Public License as published by the Free Software
; Foundation; either version 2 of the License, or (at your option) any later
; version.  This program is distributed in the hope that it will be useful but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
; more details.  You should have received a copy of the GNU General Public
; License along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA 02110-1335, USA.
;
; Original author: Jared Davis <jared@centtech.com>

(in-package "VL")
(include-book "parse-statements-def")
(local (include-book "../../util/arithmetic"))

(with-output
 :off prove :gag-mode :goals
 (make-event
  `(defthm-parse-statements-flag vl-parse-statement-warninglist
     ,(vl-warninglist-claim vl-parse-case-item)
     ,(vl-warninglist-claim vl-parse-1+-case-items)
     ,(vl-warninglist-claim vl-parse-case-statement
                         :extra-args (atts))
     ,(vl-warninglist-claim vl-parse-conditional-statement
                         :extra-args (atts))
     ,(vl-warninglist-claim vl-parse-loop-statement
                         :extra-args (atts))
     ,(vl-warninglist-claim vl-parse-par-block
                         :extra-args (atts))
     ,(vl-warninglist-claim vl-parse-seq-block
                         :extra-args (atts))
     ,(vl-warninglist-claim vl-parse-procedural-timing-control-statement
                         :extra-args (atts))
     ,(vl-warninglist-claim vl-parse-wait-statement
                         :extra-args (atts))
     ,(vl-warninglist-claim vl-parse-statement-aux
                         :extra-args (atts))
     ,(vl-warninglist-claim vl-parse-statement)
     ,(vl-warninglist-claim vl-parse-statement-or-null)
     ,(vl-warninglist-claim vl-parse-statements-until-end)
     ,(vl-warninglist-claim vl-parse-statements-until-join)
     :hints((and acl2::stable-under-simplificationp
                 (flag::expand-calls-computed-hint
                  acl2::clause
                  ',(flag::get-clique-members 'vl-parse-statement-fn (w state))))))))