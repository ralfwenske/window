Red [
    Title: "generated 30-Apr-2020/17:43:38+10:00"
]
mywin: layout compose [ backdrop yellow
    title "generated 30-Apr-2020/17:43:38+10:00"
    size 700x700 below at 8x5 
    style my-head: text "" 100x25 font-name "Courier" font-size 12 
    style my-area: area wrap "" font-name "Courier" font-size 12          
    tab-Window-Test-1: tab-panel  [
        "A panel" [ at 0x0 
            A-panel-panel: panel 220.220.220 [

            button "Save Source to %generated.red" [write %generated.red GENERATED-VID-area/text]
            button "Test logging" [mywin/extra/log " Tested logging" ]
            return
            area-1: my-area 650x500
            ] react [face/size: face/parent/parent/size]
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
    log: func [txt /local lines][append log-area/text rejoin [newline now/time " " txt] lines: length? split head log-area/text newline 
        if (lines >= 3) [log-area/text: find/tail log-area/text newline]
    ]
]
view/flags mywin ['resize]