;;
;; Rebind CapsLock-modified keys to be like Emacs.
;; Rebind CapsLock to be Ctrl in Emacs.
;;

#NoEnv  ; performance & compatibility w/ future releases
SendMode Input
SetCapsLockState, AlwaysOff

;;;;;;;;;;;;;;;;;;;;;;;
;; Tray Menus
;;;;;;;;;;;;;;;;;;;;;;;
Menu, tray, NoStandard
Menu, tray, add, Suspend Hotkeys, MenuSuspend
Menu, tray, add
Menu, tray, add, About, MenuAbout
Menu, tray, add, Exit, MenuExit
return

MenuSuspend:
Menu, tray, ToggleCheck, Suspend Hotkeys
Suspend
return

MenuAbout:
Gui, Font,, Lucida Console

;; use ( LTrim ...) to ignore spaces, tabs, etc.
Gui, Add, Text, ,
(
+---------------------+
|  capslock_nav v0.2  |
+---------------------+

Denote C as CapsLock, M as Alt, S as Shift.


The following keys send along held Shift/Ctrl/Alt.

 Key   |  Effect
-------+----------
 C-p   |  Up
 C-M-p |  PgUp
 C-n   |  Down
 C-M-n |  PgDn
 C-f   |  Right
 C-b   |  Left
 C-a   |  Home
 C-e   |  End
 C-d   |  Del
 C-M-d |  Ctrl+Del
 C-h   |  Backspace
 C-M-h |  Ctrl+Backspace
 C-Esc |  CapsLock OFF

The following keys ignore held Shift/Ctrl/Alt.

 Key   |  Effect
-------+----------
 C-s   |  Ctrl-f
 C-w   |  Ctrl-x
 C-M-w |  Ctrl-c
 C-y   |  Ctrl-v
 C-/   |  Ctrl-z
 C-S-/ |  Ctrl-y
 C-g   |  Esc
 C-m   |  Menu


In Emacs, CapsLock acts only as Ctrl.
)
Gui, Show, Center
return

MenuExit:
ExitApp
return


;;;;;;;;;;;;;;;;;;;;;;;
;; Functions
;;;;;;;;;;;;;;;;;;;;;;;

;; Sends "input", or "altinput" if Alt is held.
;; Ignores additional modifiers.
;;
;; input/altinput must be given as a string: ex. "{Home}"
;;
SendAlt(input, altinput) {
  if(GetKeyState("Alt")) {
    outstr = %altinput%
  } else {
    outstr = %input%
  }
  
  Send %outstr%
}

;; Similarly for Shift.
SendShift(input, shiftinput) {
  if(GetKeyState("Shift")) {
    outstr = %shiftinput%
  } else {
    outstr = %input%
  }
  
  Send %outstr%
}

;; Sends "input" together w/ any held modifiers (excluding Alt),
;; or "altinput" w/ held modifiers if Alt is held.
;;
SendAlt_Modifiers(input, altinput) {
  if(GetKeyState("Alt")) {
    outstr = %altinput%
  } else {
    outstr = %input%
  }
  
  if(GetKeyState("Shift")) {
    outstr = +%outstr%
  }
  if(GetKeyState("Control")) {
    outstr = ^%outstr%
  }
  
  Send %outstr%
}

;; Sends "input" together with any held modifiers (incl. Alt).
;;
Send_Modifiers(input) {
  altinput = !%input%
  SendAlt_Modifiers(input, altinput)
}

;; Note that prefix "$" is needed if sending key itself.
;; Prefix "~" needed to send keystrokes as hotkey; needed if some keys are suppressed by program.
;; {blind} passes along any held modifiers.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key Rebindings
;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; Bindings to use outside of Emacs
#IfWinNotActive ahk_class Emacs
; NOTE: auto-repeat won't work if {Backspace} is used here. Use CapsLock+h instead.
CapsLock::return

;; Navigation
; Alt modifier gives PgUp/PgDn rather than Up/Down
CapsLock & p::SendAlt_Modifiers("{Up}", "{PgUp}")  
CapsLock & n::SendAlt_Modifiers("{Down}", "{PgDn}")

CapsLock & f::Send_Modifiers("{Right}")
CapsLock & b::Send_Modifiers("{Left}")
CapsLock & a::Send_Modifiers("{Home}")
CapsLock & e::Send_Modifiers("{End}")

;; Deletion
CapsLock & d::SendAlt_Modifiers("{Del}", "^{Del}")
CapsLock & h::SendAlt_Modifiers("{Backspace}", "^{Backspace}")

;; Misc
CapsLock & s::Send ^{f}
CapsLock & w::SendAlt("^{x}", "^{c}")
CapsLock & y::Send ^{v}
CapsLock & /::SendShift("^{z}", "^{y}")
CapsLock & g::Send {ESC}
CapsLock & m::Send {Appskey}

;; Fix CapsLocks sticking
CapsLock & ESC::SetCapsLockState, AlwaysOff
#IfWinNotActive

;;;; Otherwise, rebind CapsLock to Ctrl for emacs
#IfWinActive ahk_class Emacs
CapsLock::Ctrl
#IfWinActive