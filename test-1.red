Red []
git: https://raw.githubusercontent.com/ralfwenske/window/master/window.red 
unless (true = (exists? %window.red)) [
    write %window.red read git
]
#include %window.red
src: [
    mywin: window/make-window  
        'mywin      ;;; must equal receiving word (here mywin: ...)
        "test-1"
        700x700 
        []          ;default menu
        reduce [
        "A panel" {
            button "Save Source to %generated.red" [write %generated.red GENERATED-VID-area/text]
            button "Test logging" [mywin/window/extra/log " Tested logging" ]
            return
            area-1: my-area 650x500} 
        "A tab-panel" ["SOURCE" "GENERATED VID"]
        ]        
    ;;; Note: extra/log belongs to 'window face! is replace in src
    ;;; [mywin/...] must equal first parameter for window/make-window call (above)

    area-1/text: rejoin ["just some text at " now/date]
    SOURCE-head/text: "This source"
    SOURCE-area/text: mold src      ;;; <-- why we reduce after
    GENERATED-VID-head/text: "The generated VID"
    GENERATED-VID-area/text: mywin/source    
]
do reduce src
view/flags mywin/window ['resize]