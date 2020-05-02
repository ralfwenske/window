Red []
git: https://raw.githubusercontent.com/ralfwenske/window/master/ 
pull: function [f [file!] /bin][ 
    unless exists? f [
        unless exists? p: first split-path f [make-dir p]
        either bin [
            save f load rejoin [git f]
        ][
            write f read rejoin [git f]
        ] 
    ]
]
pull %window.red 
pull %test-1.red 
pull/bin %images/test-1-source.jpg
do load %window.red
src: [
    mywin: window/make-window  
        'mywin      ;;; must equal receiving word (here mywin: ...)
        "test-1"
        900x750 
        []          ;menu will be default (Quit Author)
        reduce [
        "A 1. panel" 
{            base %images/test-1-source.jpg
                react [
                    face/parent/size ;triggers this react
                    attempt [mywin/window/extra/fit face] ;triggered before mywin exists
                ]}
        "A 2. panel"  
{                button "Save generated source to %generated.red" [
                    write %generated.red GENERATED-VID-area/text ]
                button "Test logging" [mywin/window/extra/log "Tested logging" ]
                return  area-1: my-area 850x500
                    react [face/size: face/parent/size - 20x70] } 
        "A tab-panel" [ "SOURCE" "GENERATED VID" ]
        ]        
    ;;; Note: extra/log belongs to 'window face! (is replaced accordingly)

    area-1/text: rejoin ["just some text at " now/date]

    SOURCE-head/text: "This source"
    SOURCE-area/text: read %test-1.red

    GENERATED-VID-head/text: "The generated VID"
    GENERATED-VID-area/text: mywin/source    
]
do reduce src
view/flags mywin/window ['resize]