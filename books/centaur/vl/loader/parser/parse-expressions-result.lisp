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
(include-book "parse-expressions-def")
(include-book "parse-expressions-tokenlist") ;; sucky
;; (include-book "parse-expressions-error")     ;; sucky
(local (include-book "../../util/arithmetic"))
(local (non-parallel-book))

(defun vl-expression-claim-fn (name extra-args type)
  (let ((full-args (append extra-args '(tokens warnings))))
    `'(,name (implies (and (force (vl-tokenlist-p tokens))
                           (force (not (mv-nth 0 (,name . ,full-args)))))
                      ,(cond ((eq type :expr)
                              `(vl-expr-p (mv-nth 1 (,name . ,full-args))))
                             ((eq type :exprlist)
                              `(vl-exprlist-p (mv-nth 1 (,name . ,full-args))))
                             ((eq type :atts)
                              `(vl-atts-p (mv-nth 1 (,name . ,full-args))))
                             ((eq type :erange)
                              `(vl-erange-p (mv-nth 1 (,name . ,full-args))))
                             ((eq type :mixed)
                              `(vl-mixed-binop-list-p (mv-nth 1 (,name . ,full-args))))
                             (t
                              (er hard? 'vl-expression-claim-fn
                                  "Bad type: ~x0." type)))))))

(defmacro vl-expression-claim (name type &key extra-args)
  (vl-expression-claim-fn name extra-args type))

(local (in-theory (disable acl2::consp-under-iff-when-true-listp
                           member-equal-when-member-equal-of-cdr-under-iff
                           default-car
                           default-cdr
                           vl-atom-p-by-tag-when-vl-expr-p
                           acl2-count-positive-when-consp
                           (:type-prescription acl2-count)

                           ;consp-when-vl-atomguts-p
                           ;tag-when-vl-ifstmt-p
                           ;tag-when-vl-seqblockstmt-p
                           )))


(with-output
 :off prove :gag-mode :goals
 (encapsulate
  ()
  (local (in-theory (enable vl-maybe-expr-p)))
  ;(local (in-theory (disable stringp-when-maybe-stringp)))
  (make-event
   `(defthm-parse-expressions-flag vl-parse-expression-value
      (vl-parse-attr-spec
       (implies (and (force (vl-tokenlist-p tokens))
                     (force (not (mv-nth 0 (vl-parse-attr-spec)))))
                (and (consp (mv-nth 1 (vl-parse-attr-spec)))
                     (stringp (car (mv-nth 1 (vl-parse-attr-spec))))
                     (vl-maybe-expr-p (cdr (mv-nth 1 (vl-parse-attr-spec)))))))
      ,(vl-expression-claim vl-parse-attribute-instance-aux :atts)
      ,(vl-expression-claim vl-parse-attribute-instance :atts)
      ,(vl-expression-claim vl-parse-0+-attribute-instances :atts)
      ,(vl-expression-claim vl-parse-1+-expressions-separated-by-commas :exprlist)
      ,(vl-expression-claim vl-parse-system-function-call :expr)
      ,(vl-expression-claim vl-parse-mintypmax-expression :expr)
      ,(vl-expression-claim vl-parse-range-expression :erange)
      ,(vl-expression-claim vl-parse-concatenation :expr)
      ,(vl-expression-claim vl-parse-concatenation-or-multiple-concatenation :expr)
      ,(vl-expression-claim vl-parse-hierarchial-identifier :expr :extra-args (recursivep))
      ,(vl-expression-claim vl-parse-function-call :expr)
      ,(vl-expression-claim vl-parse-0+-bracketed-expressions :exprlist)
      ,(vl-expression-claim vl-parse-indexed-id :expr)
      ,(vl-expression-claim vl-parse-primary :expr)
      ,(vl-expression-claim vl-parse-unary-expression :expr)
      ,(vl-expression-claim vl-parse-power-expression-aux :mixed)
      ,(vl-expression-claim vl-parse-power-expression :expr)
      ,(vl-expression-claim vl-parse-mult-expression-aux :mixed)
      ,(vl-expression-claim vl-parse-mult-expression :expr)
      ,(vl-expression-claim vl-parse-add-expression-aux :mixed)
      ,(vl-expression-claim vl-parse-add-expression :expr)
      ,(vl-expression-claim vl-parse-shift-expression-aux :mixed)
      ,(vl-expression-claim vl-parse-shift-expression :expr)
      ,(vl-expression-claim vl-parse-compare-expression-aux :mixed)
      ,(vl-expression-claim vl-parse-compare-expression :expr)
      ,(vl-expression-claim vl-parse-equality-expression-aux :mixed)
      ,(vl-expression-claim vl-parse-equality-expression :expr)
      ,(vl-expression-claim vl-parse-bitand-expression-aux :mixed)
      ,(vl-expression-claim vl-parse-bitand-expression :expr)
      ,(vl-expression-claim vl-parse-bitxor-expression-aux :mixed)
      ,(vl-expression-claim vl-parse-bitxor-expression :expr)
      ,(vl-expression-claim vl-parse-bitor-expression-aux :mixed)
      ,(vl-expression-claim vl-parse-bitor-expression :expr)
      ,(vl-expression-claim vl-parse-logand-expression-aux :mixed)
      ,(vl-expression-claim vl-parse-logand-expression :expr)
      ,(vl-expression-claim vl-parse-logor-expression-aux :mixed)
      ,(vl-expression-claim vl-parse-logor-expression :expr)
      ,(vl-expression-claim vl-parse-expression :expr)
      :hints(("Goal"
              :do-not '(generalize fertilize))
             (and acl2::stable-under-simplificationp
                  (flag::expand-calls-computed-hint
                   acl2::clause
                   ',(flag::get-clique-members 'vl-parse-expression-fn (w state)))))))))

