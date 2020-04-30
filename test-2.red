Red [ 
    Needs: 'View 
    File: %test-window.red
]

git: https://raw.githubusercontent.com/ralfwenske/window/master/window.red 
either (true = (exists? %window.red)) [
    #include %window.red
][   
    #include load git
]

page1: 
{                below 
                text "Click 'Page 2' to find sources" 
                area-1: my-area 600x300} 

page2:  ; just some Faces (see View Engine / 6. Face types)
{                across
                button "1. Show Source" [thesource/text: read %test-2.red]
                button "2. Show Generated VID" [
                    thesource/text: win/source
                ]
                button "Quit" [
                    f: face           
                    while [f/type <> 'window] [f: f/parent] ;;; ???
                    if f/extra/confirm-quit [unview]
                ]
                return
                thesource: my-area 300x300 ""
                    react [face/size: face/parent/size - 42x110 ]}

win: window/make-window 
    'win        ;;; must equal receiving word
    "test-window" 
    650x700 
    ["File" [       
        "Load" File-Load [f/extra/log "Load menu"]
        "Save" File-Save [f/extra/log "Save menu"]
        --- -- --
        "Quit" File-Quit [if f/extra/confirm-quit [unview]]
        ]
        "About" [
            "Author" About-Author [f/extra/log "written by Ralf Wenske April 2020"]
        ]
    ] 
    reduce [
        "Page 1" page1      ;string here creates panel        
        "Page 2" page2      ;string here creates panel        
        "Page 3" ["Source" "Generated" "What"] 
                            ;block creates tab-panel with head and area
    ] ; returns win/source, win/window and win/show-it

Source-head/text: "The source from %test.red"
Source-area/text:  read %test-2.red

Generated-head/text: "The generated code"
Generated-area/text:  win/source

What-head/text: "     word            type          Summary"
What-area/text: what/buffer

win/window/extra/log "here we can show progress"
view/flags win/window ['resize]