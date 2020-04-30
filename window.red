Red [
  Title: "Generate window for View"
  File: %window.red
  Author: "Ralf Wenske"
  Date: 25-Apr-2020
  Purpose: { 
      generate a fully working view with menu
        tab-panel and simple content
        tabs containing another tab-panel containing areas
        resizable
    }
  Usage: {  
      see %test1.red and %test2.red
    }
]

window: context [
    as-label: function [str [string!]][
        s: copy str
        replace/all s " " "-"
        return s
    ]

    _make-subpanel: function [panel-name [string!] titles [block!]][
        res: copy ""
        pnl: {
                    "*title*" [
                        below            
                        at 4x0 *title*-head: my-head 
                            react [face/size/x: face/parent/parent/size/x - 27 ]
                        at 0x20 *title*-area: my-area 
                            react [face/size: face/parent/parent/size - 27x81 ]
                            on-detect [if event/type = 'key [return 'stop]]
                    ]}
        foreach title titles [
            p: copy pnl
            replace p "*title*" title
            replace/all p "*title*" as-label title
            append res p
        ]
        return rejoin [{ at 0x0 
                tab-} as-label panel-name {: tab-panel [} res {                
                ] react [face/size: face/parent/parent/size - 0x15 ]}
        ]
    ]; make-subpamel

    _make-panel: function [
        title [string!]
        content [block! string!]
    ][
        return rejoin [{
        "} title {" [}
            either (string? content) [
                    rejoin [{ at 0x0 
            } as-label title {-panel: panel 220.220.220 [
} content {
            ] react [face/size: face/parent/parent/size]}]           
            ][
                _make-subpanel  as-label title content
            ]
            {
        ]
    }   ]
    ]; _make-panel


    make-window: function ["returns map/source and map/window"
        awin [word!]    "the 'word this f'ion is assigned to"
        atitle [string!]
        size [pair!]
        menu [block!]   "VID menu + actor (see %test2.red)"
        tabs [block!]   "[{txt1} {} ..] or [{txt1} [{txt2} {txt3}]]"
    ][
        ;awin-log: to-path reduce [awin 'log]
        if empty? tabs [
            tabs: ["Main" {}]
        ]
        if empty? menu [
            menu: reduce compose/deep [
                "File" ["Quit" do-quit [if f/extra/confirm-quit [unview]]]
                "About" ["Author" do-about [f/extra/log "Author: Ralf Wenske April 2020"]]
            ]
        ]
        src: none
        src: rejoin [
    {layout compose [ backdrop yellow
    title "} atitle {"
    size } size { below at 8x5 
    style my-head: text "" 100x25 font-name "Courier" font-size 12 
    style my-area: area wrap "" font-name "Courier" font-size 12          
    tab-} as-label atitle {: tab-panel  [}
        ]
        foreach [title content] tabs [
            append src _make-panel title content
        ]
        append src 
    {] react [face/size: face/parent/size - 0x60]
    log-area: my-area react [
        face/size: to-pair reduce [(face/parent/size/x - 20) 40]
        face/offset: to-pair reduce [12 (face/parent/size/y - 55)]
    ]
    do  [system/view/capturing?: yes] 
]}   

        the-menu: copy []
        the-actors: copy []

        foreach [main sub] menu [
            append the-menu main 
            ;append the-menu newline
            blk-a: copy []
            blk-m: copy []
            foreach [nm lb fc] sub [
                either nm = '--- [
                    append blk-m '---
                ][
                    append blk-m reduce [nm lb]
                    append blk-a reduce [lb fc]
                ]
            ]
            append/only the-menu blk-m
            append the-actors blk-a

        ]
        w: do src
        w/menu: the-menu
        w/extra:  context [
            confirm-quit: function [][ 
                res: none
                view/flags [
                    title "test-window.red"
                    text "Quit?" return 
                    button "OK" [res: true unview] 
                    button "Cancel" [res: false unview]
                ][no-buttons  modal popup]
                res
            ]
            log: function [txt][
                append log-area/text rejoin [newline now/time " " txt]
                lines: length? split head log-area/text newline
                if (lines >= 3) [log-area/text: find/tail log-area/text newline ]
            ]
        ]
        w/actors: context compose/deep [
            on-menu: func [f e][
                switch e/picked [(the-actors)]
            ]
            on-close: func [f e][
                unless f/extra/confirm-quit ['continue]
            ]
       ]

        m: context [
            source: none
            window: none
        ]
        topath: function [lb /win][
            either win [
                res: form to-path reduce [awin 'window lb]
            ][
                res: form to-path reduce [awin lb] 
            ]
            append res  ": " 
            res
        ]
        replace src atitle rejoin [{generated } now ]
        replace/all src to-path reduce [awin 'window 'extra] to-path reduce [awin 'extra]
;        print [atitle rejoin [{generated } now  ]]
        m/source: rejoin [
            {Red [
    Title: "generated } now {"
]} newline
            awin ": " src newline 
            topath 'menu mold w/menu newline 
            topath 'actors mold w/actors newline
            topath 'extra mold w/extra newline
            "view/flags " awin " ['resize]"
            ]

        m/window: w
        return m
    ]; make-window
]; window

