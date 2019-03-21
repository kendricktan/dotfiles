import           System.Exit
import           System.IO

import           Data.Default
import           XMonad
import           XMonad.Actions.NoBorders         (toggleBorder)
import           XMonad.Config.Desktop
import           XMonad.Core                      (io)
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers       (doFullFloat, isFullscreen)
import           XMonad.Layout                    (Full, Mirror, Tall)
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.IndependentScreens (countScreens)
import           XMonad.Layout.Minimize
import           XMonad.Layout.Named
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spiral             (spiral)
import           XMonad.Layout.Tabbed             (simpleTabbed)
import           XMonad.Operations                (kill, refresh, restart,
                                                   reveal, withFocused)
import           XMonad.Prompt                    (quit)
import           XMonad.Util.CustomKeys
import           XMonad.Util.Dmenu
import           XMonad.Util.Run                  (spawnPipe)
import           XMonad.Util.SpawnOnce

import           Control.Monad                    (when)


-- Settings
--
myWorkspaces = foldl (\b a -> b ++ [show (length b + 1) ++ ": " ++ a]) [] ["www", "dev", "term", "irc", "ops", "music", "leisure", "office", "misc"]
myTerminal = "xfce4-terminal"
myBorderWidth = 3
myFocusColor = "#2ecc71"

-- Dmenu confirmation bar
--
confirm :: String -> X () -> X ()
confirm m f = do
  result <- dmenu [m, "y", "n"]
  when (result == "y") f

-- What applications to run on startup
--
myStartupHook = do
  -- Kill any existing SSH Auths (see configuration's zshrc for more details)
  spawn "rm $HOME/.ssh/ssh_auth_sock"
  spawn "/bin/ssh_startup.sh"
  -- Spawn system tray
  spawn "kill -9 $(ps aux | grep -e \"trayer\" | awk ' { print $2 } ')"
  spawn "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --alpha 0 --tint 0x000000 --height 17 --monitor 'primary'"
  -- Swap Caps and ESC
  spawn "xmodmap -e \"keycode 9 = Caps_Lock NoSymbol Caps_Lock\""
  spawn "xmodmap -e \"keycode 66 = Escape NoSymbol Escape\""
  spawn "xmodmap -e \"clear Lock\""
  -- Reverse Scroll
  spawn "synclient VertScrollDelta=-100"
  -- Set wallpaper
  spawn "feh --bg-center $HOME/Pictures/Background/background.jpg"
  -- Kill duplicate process
  spawn "kill -9 $(ps aux | grep -e \"nm-applet\" | awk ' { print $2 } ')"
  spawn "kill -9 $(ps aux | grep -e \"dropbox\" | awk ' { print $2 } ')"
  spawn "kill -9 $(ps aux | grep -e \"redshift\" | awk ' { print $2 } ')"
  -- Spawn process
  spawn "dropbox start"
  spawn "nm-applet"
  spawn "redshift-gtk"
  -- spawn "pasystray"

-- Layout configuration
--
myLayoutHook =
  avoidStruts
  ( Tall 1 (3/100) (1/2)	  |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    simpleTabbed		  |||
    spiral (6/7)
  ) ||| noBorders (fullscreenFull Full)

-- Remove defined keys
--
delKeys :: XConfig l -> [(KeyMask, KeySym)]
delKeys XConfig{modMask = modMask} =
  [ (modMask, xK_p)
  , (modMask, xK_q)
  , (modMask .|. shiftMask, xK_q)
  , (modMask .|. shiftMask, xK_c)
  ]

-- Insert new hotkeys
--
insKeys :: XConfig l -> [((KeyMask, KeySym), X ())]
insKeys XConfig{modMask = modMask} =
  [ ((modMask, xK_d),      spawn "rofi -show run")
  , ((modMask, xK_Tab),    spawn "rofi -show window")
  , ((modMask, xK_Return), spawn "termite")
  , ((modMask, xK_r),	   refresh)
  , ((modMask, xK_b),	   sendMessage ToggleStruts) -- Toggles xmobar visibility
  , ((modMask, xK_m),	   withFocused toggleBorder) -- Toggles border display
  , ((modMask, xK_x),	   withFocused minimizeWindow)
  , ((modMask, xK_z),	   sendMessage RestoreNextMinimizedWin)
  , ((0, 0xff61),	   spawn "gnome-screenshot -f ~/Pictures/\"Screenshot-$(date '+%d-%m-%Y-%H:%M:%S').png\"")
  , ((0, 0x1008ff12),	   spawn "amixer -D pulse set Master 1+ toggle")
  , ((0, 0x1008ff13),	   spawn "amixer -q sset Master 8%+")
  , ((0, 0x1008ff11),	   spawn "amixer -q sset Master 8%-")
  , ((0, 0x1008ffb2),	   spawn "amixer set Capture toggle")
  , ((0, 0x1008ff02),	   spawn "xbacklight -inc 10")
  , ((0, 0x1008ff03),	   spawn "xbacklight -dec 10")
  , ((0 .|. shiftMask, 0xff61),	   spawn "gnome-screenshot -a -f ~/Pictures/\"Screenshot-$(date '+%Y-%m-%d-%H:%M:%S').png\"")
  , ((modMask .|. shiftMask, xK_q), kill)
  , ((modMask .|. shiftMask, xK_r), confirm "Restart" $ restart "xmonad" True)
  , ((modMask .|. shiftMask, xK_e), confirm "Exit" $ io exitSuccess)
  , ((modMask .|. controlMask, xK_l), spawn "i3lock-fancy")
  , ((modMask .|. shiftMask .|. controlMask, xK_h), spawn "xrandr --output DP2-1 --auto --rotate left --right-of DP2-3 --output DP2-3 --primary --output eDP-1 --off")
  , ((modMask .|. shiftMask .|. controlMask, xK_w), spawn "xrandr --output DP1 --auto --above eDP1 --output HDMI2 --rotate right --right-of DP1")
  ]

-- Main
--
main = do
  -- Manage xmobar's process
  xmproc <- spawnPipe "xmobar"

  xmonad $ desktopConfig
    { manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = myLayoutHook
    , logHook = dynamicLogWithPP xmobarPP
	{ ppOutput = hPutStrLn xmproc
	, ppTitle = xmobarColor "green" "" . shorten 42
	}
    , workspaces = myWorkspaces
    , terminal = myTerminal
    , borderWidth = myBorderWidth
    , focusedBorderColor = myFocusColor
    , startupHook = myStartupHook <+> startupHook defaultConfig
    , keys = customKeys delKeys insKeys
    }
