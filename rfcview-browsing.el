;;; rfcview-browsing.el -- easier RFC reading

;; Copyright (C) 2010 R.W van 't Veer

;; Author: R.W. van 't Veer
;; Created: 18 Aug 2010
;; Keywords: tools

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;; easier RFC reading with debian/ubuntu doc-rfc and emacs-goodies
;; installed

;;; Code:

(defcustom rfcview-browse-dir "/usr/share/doc/RFC"
  "Directory containing rfc-index.txt.gz and links directory."
  :type 'string
  :group 'rfcview-browse)

(defun rfcview-browse-rfc-index ()
  "Return the location of the rfc-index file."
  (concat rfcview-browse-dir "/rfc-index.txt.gz"))

(unless (fboundp 'rfcview-mode)
  (error "Can't find rfcview-mode" ))

(unless (file-exists-p (rfcview-browse-rfc-index))
  (error "Can't find %s" (rfcview-browse-rfc-index)))

(defun rfcview-file (arg)
  "Return filename of plain text version for given RFC number ARG or nil."
  (let ((num (if (integerp arg) arg (string-to-int arg))))
    (find-if 'file-exists-p
             (mapcar (lambda (f) (format f num))
                     (list (concat rfcview-browse-dir "/links/rfc%s.txt")
                           (concat rfcview-browse-dir "/links/rfc%s.txt.gz"))))))

(defun rfcview (num)
  "Open plain text RFC for given RFC number NUM."
  (interactive "nRFC number: ")
  (let ((file (rfcview-file num)))
    (if file
      (find-file file)
      (error "RFC %s not found" num))))

(defun rfcview-index ()
  "Open RFC index."
  (interactive)
  (find-file (rfcview-browse-rfc-index)))
  
(defadvice rfcview-find-location-of-rfc (around rfcview-browse-find-location-of-rfc-around activate)
  "Advice to use `rfc' method when original function does not find a location."
  (condition-case err
      ad-do-it
    (error
     (let ((word (thing-at-point 'word)))
       (if (string-match "^[0-9]+$" word)
         (rfcview word)
         (error (error-message-string err)))))))

;; Open rfc-index also in rfcview-mode.
(add-to-list 'auto-mode-alist
             '("/rfc-index\\.txt\\(\\.gz\\)?\\'" . rfcview-mode))

(provide 'rfcview-browsing)

(provide 'rfcview-browsing)

;;; rfcview-browsing.el ends here
