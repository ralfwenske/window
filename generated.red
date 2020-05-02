Red [
    Title: "generated 2-May-2020/9:04:27+10:00"
]
mywin: layout compose [ backdrop yellow
    title "generated 2-May-2020/9:04:27+10:00"
    size 900x750 below at 8x5 
    style my-head: text "" 100x25 font-name "Courier" font-size 12 
    style my-area: area wrap "" font-name "Courier" font-size 12          
    tab-test-1: tab-panel  [
        "A 1. panel" [ at 0x0 
            A-1.-panel-panel: panel 220.220.220 [
            base %images/test-1-source.jpg
                react [
                    face/parent/size ;triggers this react
                    attempt [mywin/extra/fit face] ;triggered before mywin exists
                ]
            ] react [face/size: face/parent/parent/size - 25x50]
        ]
    
        "A 2. panel" [ at 0x0 
            A-2.-panel-panel: panel 220.220.220 [
                button "Save generated source to %generated.red" [
                    write %generated.red GENERATED-VID-area/text ]
                button "Test logging" [mywin/extra/log "Tested logging" ]
                return  area-1: my-area 850x500
                    react [face/size: face/parent/size - 20x70] 
            ] react [face/size: face/parent/parent/size - 25x50]
        ]
    
        "A tab-panel" [ at 0x0 
                tab-A-tab-panel: tab-panel [
                    "SOURCE" [
                        below            
                        at 4x0 SOURCE-head: my-head 
                            react [face/size/x: face/parent/parent/size/x - 27 ]
                        at 0x20 SOURCE-area: my-area 
                            react [face/size: face/parent/parent/size - 27x81 ]
                            on-detect [if event/type = 'key [return 'stop]]
                    ]
                    "GENERATED VID" [
                        below            
                        at 4x0 GENERATED-VID-head: my-head 
                            react [face/size/x: face/parent/parent/size/x - 27 ]
                        at 0x20 GENERATED-VID-area: my-area 
                            react [face/size: face/parent/parent/size - 27x81 ]
                            on-detect [if event/type = 'key [return 'stop]]
                    ]                
                ] react [face/size: face/parent/parent/size - 0x15 ]
        ]
    ] react [face/size: face/parent/size - 0x60]
    log-area: my-area react [
        face/size: to-pair reduce [(face/parent/size/x - 20) 40]
        face/offset: to-pair reduce [12 (face/parent/size/y - 55)]
    ]
    do  [system/view/capturing?: yes] 
]
mywin/menu: ["File" ["Quit" do-quit] "About" ["Author" do-about]]
mywin/actors: make object! [
    on-menu: func [f e][switch e/picked [do-quit [if f/extra/confirm-quit [unview]] do-about [f/extra/log "Author: Ralf Wenske April 2020"]]]
    on-close: func [f e][unless f/extra/confirm-quit ['continue]]
]
mywin/extra: make object! [
    confirm-quit: func [/local res][
        res: none 
        view/flags [
            title "test-window.red" 
            text "Quit?" return 
            button "OK" [res: true unview] button "Cancel" [res: false unview]
        ] [no-buttons modal popup] res
    ]
    fit: func [face [object!] /local fs ps ratio pratio][fs: face/size ps: face/parent/size - 20x20 
        if none? face/extra [
            print ["Creating extra"] 
            face/extra: copy context [ratio: none] face/extra/ratio: divide to-float fs/x fs/y
        ] 
        pratio: divide to-float ps/x ps/y 
        if ps/x <> ps/y [
            either pratio > face/extra/ratio [
                face/size: to-pair reduce [(to-integer (ps/y * face/extra/ratio)) ps/y]
            ] [
                face/size: to-pair reduce [ps/x (to-integer (ps/x / face/extra/ratio))]
            ]
        ]
    ]
    log: func [txt /local lines][append log-area/text rejoin [newline now/time " " txt] lines: length? split head log-area/text newline 
        if (lines >= 3) [log-area/text: find/tail log-area/text newline]
    ]
]
view/flags mywin ['resize]