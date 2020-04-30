## window
 
 window/make-window creates a resizable view with tab-panels and areas.

 It is grown out of the need to quickly present data without spending much time with figuring out the details of VID. 

 Here an example created by the included %test-1.red

 ![View showing it's own source code](./images/test-1.jpg)

The same run on Mint (GTK branch)

 ![Alignments are a bit out ](./images/test-1GTK.jpg)

```
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
```

%test-2.red shows a bit more involvement:
* the menu is user defined
* preloading of areas
* loading of areas triggered by button clicks

The generated code can be saved to a file which should show the view
(you may have to deactivate some actors - it is just the VID layout )


Note:
    When playing with these or your own you will find a few little things that still need to be resolved - eg.
    on macOS: text wrapping
    on GTK: alignment issues, text wrapping, 'Cancel' on dialog shuts the app down
    
    The code is not the most elegant and I welcome suggestions for improvement.
    And of course bugs that might lure in there