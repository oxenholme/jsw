; Jet Set Willy disassembly
; http://skoolkit.ca/
;
; Copyright 1984 Software Projects Ltd (Jet Set Willy)
; Copyright 2012-2017 Richard Dymond (this disassembly)

  ORG $8000

; Room layout
;
; Initialised upon entry to a room and then used by the routine at INITROOM,
; and also used by the routine at ROOMATTRS.
ROOMLAYOUT:
  DEFS $80

; Room name
;
; Initialised upon entry to a room and then used by the routine at INITROOM.
ROOMNAME:
  DEFS $20

; Room tiles
;
; Initialised upon entry to a room by the routine at INITROOM.
BACKGROUND:
  DEFS $09                ; Background tile (used by the routines at DRAWROOM,
                          ; ROOMATTR, MOVEWILLY and WILLYATTR, and also by the
                          ; unused routine at U_SETATTRS)
FLOOR:
  DEFS $09                ; Floor tile (used by the routines at DRAWROOM and
                          ; ROOMATTR)
WALL:
  DEFS $09                ; Wall tile (used by the routines at DRAWROOM,
                          ; ROOMATTR, MOVEWILLY and MOVEWILLY3)
NASTY:
  DEFS $09                ; Nasty tile (used by the routines at DRAWROOM,
                          ; ROOMATTR, MOVEWILLY and WILLYATTR)
RAMP:
  DEFS $09                ; Ramp tile (used by the routines at DRAWROOM,
                          ; ROOMATTRS, MOVEWILLY3 and WILLYATTRS)
CONVEYOR:
  DEFS $09                ; Conveyor tile (used by the routines at DRAWROOM,
                          ; ROOMATTRS and MOVEWILLY2)

; Conveyor definition
;
; Initialised upon entry to a room by the routine at INITROOM.
CONVDIR:
  DEFB $00                ; Direction (0=left, 1=right; used by the routines at
                          ; MOVEWILLY2 and MVCONVEYOR)
CONVLOC:
  DEFW $0000              ; Address of the conveyor's location in the attribute
                          ; buffer at 24064 (used by the routines at ROOMATTRS
                          ; and MVCONVEYOR)
CONVLEN:
  DEFB $00                ; Length (used by the routines at ROOMATTRS and
                          ; MVCONVEYOR)

; Ramp definition
;
; Initialised upon entry to a room by the routine at INITROOM.
RAMPDIR:
  DEFB $00                ; Direction (0=up to the left, 1=up to the right;
                          ; used by the routines at ROOMATTRS, MOVEWILLY3 and
                          ; WILLYATTRS)
RAMPLOC:
  DEFW $0000              ; Address of the location of the bottom of the ramp
                          ; in the attribute buffer at 24064 (used by the
                          ; routine at ROOMATTRS)
RAMPLEN:
  DEFB $00                ; Length (used by the routine at ROOMATTRS)

; Border colour
;
; Initialised upon entry to a room and then used by the routine at INITROOM,
; and also used by the routines at ENDPAUSE, MOVEWILLY, DRAWTHINGS and
; DRAWITEMS.
BORDER:
  DEFB $00

; Unused
;
; These bytes are overwritten upon entry to a room by the routine at INITROOM,
; but not used.
XROOM223:
  DEFS $02

; Item graphic
;
; Initialised upon entry to a room by the routine at INITROOM, and used by the
; routine at DRAWITEMS.
ITEM:
  DEFS $08

; Room exits
;
; Initialised upon entry to a room by the routine at INITROOM.
LEFT:
  DEFB $00                ; Room to the left (used by the routine at ROOMLEFT)
RIGHT:
  DEFB $00                ; Room to the right (used by the routine at
                          ; ROOMRIGHT)
ABOVE:
  DEFB $00                ; Room above (used by the routines at DRAWTHINGS and
                          ; ROOMABOVE)
BELOW:
  DEFB $00                ; Room below (used by the routine at ROOMBELOW)

; Unused
;
; These bytes are overwritten upon entry to a room by the routine at INITROOM,
; but not used.
XROOM237:
  DEFS $03

; Entity specifications
;
; Initialised upon entry to a room and then used by the routine at INITROOM.
;
; There are eight pairs of bytes here that hold the entity specifications for
; the current room. The first byte in each pair identifies one of the entity
; definitions at ENTITYDEFS. The meaning of the second byte depends on the
; entity type: it determines the base sprite index and x-coordinate of a
; guardian, the y-coordinate of an arrow, or the x-coordinate of the top of a
; rope.
ENTITIES:
  DEFS $02                ; Entity 1
  DEFS $02                ; Entity 2
  DEFS $02                ; Entity 3
  DEFS $02                ; Entity 4
  DEFS $02                ; Entity 5
  DEFS $02                ; Entity 6
  DEFS $02                ; Entity 7
  DEFS $02                ; Entity 8

; Entity buffers
;
; Initialised by the routine at INITROOM, and used by the routines at
; MOVETHINGS and DRAWTHINGS. There are eight buffers here, each one eight bytes
; long, used to hold the state of the entities (rope, arrows and guardians) in
; the current room.
;
; For a horizontal guardian, the eight bytes are used as follows:
;
; +------+-----------------------------------------------------------+
; | Byte | Contents                                                  |
; +------+-----------------------------------------------------------+
; | 0    | Bit 7: direction (0=left, 1=right)                        |
; |      | Bits 5-6: animation frame index                           |
; |      | Bits 3-4: unused                                          |
; |      | Bits 0-2: entity type (001)                               |
; | 1    | Bits 5-7: animation frame index mask                      |
; |      | Bit 4: unused                                             |
; |      | Bit 3: BRIGHT value                                       |
; |      | Bits 0-2: INK colour                                      |
; | 2    | Bits 5-7: base sprite index                               |
; |      | Bits 0-4: x-coordinate                                    |
; | 3    | Pixel y-coordinate x2 (index into the table at SBUFADDRS) |
; | 4    | Unused                                                    |
; | 5    | Page containing the sprite graphic data (see GUARDIANS)   |
; | 6    | Minimum x-coordinate                                      |
; | 7    | Maximum x-coordinate                                      |
; +------+-----------------------------------------------------------+
;
; For a vertical guardian, the eight bytes are used as follows:
;
; +------+-----------------------------------------------------------+
; | Byte | Contents                                                  |
; +------+-----------------------------------------------------------+
; | 0    | Bits 5-7: animation frame index                           |
; |      | Bits 3-4: animation frame update flags (see MOVETHINGS_9) |
; |      | Bits 0-2: entity type (010)                               |
; | 1    | Bits 5-7: animation frame index mask                      |
; |      | Bit 4: unused                                             |
; |      | Bit 3: BRIGHT value                                       |
; |      | Bits 0-2: INK colour                                      |
; | 2    | Bits 5-7: base sprite index                               |
; |      | Bits 0-4: x-coordinate                                    |
; | 3    | Pixel y-coordinate x2 (index into the table at SBUFADDRS) |
; | 4    | Pixel y-coordinate increment                              |
; | 5    | Page containing the sprite graphic data (see GUARDIANS)   |
; | 6    | Minimum y-coordinate                                      |
; | 7    | Maximum y-coordinate                                      |
; +------+-----------------------------------------------------------+
;
; For an arrow, the eight bytes are used as follows:
;
; +------+-----------------------------------------------------------+
; | Byte | Contents                                                  |
; +------+-----------------------------------------------------------+
; | 0    | Bit 7: direction (0=left, 1=right)                        |
; |      | Bits 3-6: unused                                          |
; |      | Bits 0-2: entity type (100)                               |
; | 1    | Unused                                                    |
; | 2    | Pixel y-coordinate x2 (index into the table at SBUFADDRS) |
; | 3    | Unused                                                    |
; | 4    | x-coordinate                                              |
; | 5    | Collision detection byte (0x00=off, 0xFF=on)              |
; | 6    | Top/bottom pixel row (drawn either side of the shaft)     |
; | 7    | Unused                                                    |
; +------+-----------------------------------------------------------+
;
; The rope uses the second and fourth bytes of the following buffer in addition
; to its own; these ten bytes are used as follows:
;
; +------+------------------------------------------------------------+
; | Byte | Contents                                                   |
; +------+------------------------------------------------------------+
; | 0    | Bit 7: direction (0=left, 1=right)                         |
; |      | Bits 3-6: unused                                           |
; |      | Bits 0-2: entity type (011)                                |
; | 1    | Animation frame index                                      |
; | 2    | x-coordinate of the top of the rope                        |
; | 3    | x-coordinate of the segment of rope being drawn            |
; | 4    | Length (0x20)                                              |
; | 5    | Segment drawing byte                                       |
; | 6    | Unused                                                     |
; | 7    | Animation frame at which the rope changes direction (0x36) |
; | 9    | Index of the segment of rope being drawn (0x00-0x20)       |
; | 11   | Bits 1-7: unused                                           |
; |      | Bit 0: Willy is on the rope (set), or not (reset)          |
; +------+------------------------------------------------------------+
;
; Note that if a rope were the eighth entity specified in a room, its buffer
; would use the first and third bytes in the otherwise unused area at
; EBOVERFLOW.
ENTITYBUF:
  DEFS $08                ; Entity 1
  DEFS $08                ; Entity 2
  DEFS $08                ; Entity 3
  DEFS $08                ; Entity 4
  DEFS $08                ; Entity 5
  DEFS $08                ; Entity 6
  DEFS $08                ; Entity 7
  DEFS $08                ; Entity 8
  DEFB $FF                ; Terminator

; Unused
;
; This area is not used, but if a rope were the eighth entity specified in a
; room, its buffer would spill over from the eighth slot at ENTITYBUF and use
; the first and third bytes here.
EBOVERFLOW:
  DEFS $BF

; Screen buffer address lookup table
;
; Used by the routines at GAMEOVER, DRAWTHINGS and DRAWWILLY. The value of the
; Nth entry (0<=N<=127) in this lookup table is the screen buffer address for
; the point with pixel coordinates (x,y)=(0,N), with the origin (0,0) at the
; top-left corner.
SBUFADDRS:
  DEFW $6000              ; y=0
  DEFW $6100              ; y=1
  DEFW $6200              ; y=2
  DEFW $6300              ; y=3
  DEFW $6400              ; y=4
  DEFW $6500              ; y=5
  DEFW $6600              ; y=6
  DEFW $6700              ; y=7
  DEFW $6020              ; y=8
  DEFW $6120              ; y=9
  DEFW $6220              ; y=10
  DEFW $6320              ; y=11
  DEFW $6420              ; y=12
  DEFW $6520              ; y=13
  DEFW $6620              ; y=14
  DEFW $6720              ; y=15
  DEFW $6040              ; y=16
  DEFW $6140              ; y=17
  DEFW $6240              ; y=18
  DEFW $6340              ; y=19
  DEFW $6440              ; y=20
  DEFW $6540              ; y=21
  DEFW $6640              ; y=22
  DEFW $6740              ; y=23
  DEFW $6060              ; y=24
  DEFW $6160              ; y=25
  DEFW $6260              ; y=26
  DEFW $6360              ; y=27
  DEFW $6460              ; y=28
  DEFW $6560              ; y=29
  DEFW $6660              ; y=30
  DEFW $6760              ; y=31
  DEFW $6080              ; y=32
  DEFW $6180              ; y=33
  DEFW $6280              ; y=34
  DEFW $6380              ; y=35
  DEFW $6480              ; y=36
  DEFW $6580              ; y=37
  DEFW $6680              ; y=38
  DEFW $6780              ; y=39
  DEFW $60A0              ; y=40
  DEFW $61A0              ; y=41
  DEFW $62A0              ; y=42
  DEFW $63A0              ; y=43
  DEFW $64A0              ; y=44
  DEFW $65A0              ; y=45
  DEFW $66A0              ; y=46
  DEFW $67A0              ; y=47
  DEFW $60C0              ; y=48
  DEFW $61C0              ; y=49
  DEFW $62C0              ; y=50
  DEFW $63C0              ; y=51
  DEFW $64C0              ; y=52
  DEFW $65C0              ; y=53
  DEFW $66C0              ; y=54
  DEFW $67C0              ; y=55
  DEFW $60E0              ; y=56
  DEFW $61E0              ; y=57
  DEFW $62E0              ; y=58
  DEFW $63E0              ; y=59
  DEFW $64E0              ; y=60
  DEFW $65E0              ; y=61
  DEFW $66E0              ; y=62
  DEFW $67E0              ; y=63
  DEFW $6800              ; y=64
  DEFW $6900              ; y=65
  DEFW $6A00              ; y=66
  DEFW $6B00              ; y=67
  DEFW $6C00              ; y=68
  DEFW $6D00              ; y=69
  DEFW $6E00              ; y=70
  DEFW $6F00              ; y=71
  DEFW $6820              ; y=72
  DEFW $6920              ; y=73
  DEFW $6A20              ; y=74
  DEFW $6B20              ; y=75
  DEFW $6C20              ; y=76
  DEFW $6D20              ; y=77
  DEFW $6E20              ; y=78
  DEFW $6F20              ; y=79
  DEFW $6840              ; y=80
  DEFW $6940              ; y=81
  DEFW $6A40              ; y=82
  DEFW $6B40              ; y=83
  DEFW $6C40              ; y=84
  DEFW $6D40              ; y=85
  DEFW $6E40              ; y=86
  DEFW $6F40              ; y=87
  DEFW $6860              ; y=88
  DEFW $6960              ; y=89
  DEFW $6A60              ; y=90
  DEFW $6B60              ; y=91
  DEFW $6C60              ; y=92
  DEFW $6D60              ; y=93
  DEFW $6E60              ; y=94
  DEFW $6F60              ; y=95
  DEFW $6880              ; y=96
  DEFW $6980              ; y=97
  DEFW $6A80              ; y=98
  DEFW $6B80              ; y=99
  DEFW $6C80              ; y=100
  DEFW $6D80              ; y=101
  DEFW $6E80              ; y=102
  DEFW $6F80              ; y=103
  DEFW $68A0              ; y=104
  DEFW $69A0              ; y=105
  DEFW $6AA0              ; y=106
  DEFW $6BA0              ; y=107
  DEFW $6CA0              ; y=108
  DEFW $6DA0              ; y=109
  DEFW $6EA0              ; y=110
  DEFW $6FA0              ; y=111
  DEFW $68C0              ; y=112
  DEFW $69C0              ; y=113
  DEFW $6AC0              ; y=114
  DEFW $6BC0              ; y=115
  DEFW $6CC0              ; y=116
  DEFW $6DC0              ; y=117
  DEFW $6EC0              ; y=118
  DEFW $6FC0              ; y=119
  DEFW $68E0              ; y=120
  DEFW $69E0              ; y=121
  DEFW $6AE0              ; y=122
  DEFW $6BE0              ; y=123
  DEFW $6CE0              ; y=124
  DEFW $6DE0              ; y=125
  DEFW $6EE0              ; y=126
  DEFW $6FE0              ; y=127

; Rope animation table
;
; Used by the routine at DRAWTHINGS. The first half of this table controls the
; x-coordinates at which the segments of rope are drawn, and the second half
; controls the y-coordinates. For a given rope animation frame F
; (0x00<=F<=0x36), the 32 entries from F to F+31 inclusive (one for each of the
; 32 segments of rope below the topmost one) in each half of the table are
; used; thus the batch of entries used 'slides' up and down the table as F
; increases and decreases.
ROPEANIM:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; These values determine how much to
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; rotate the rope drawing byte (which in
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; turn determines the x-coordinate at
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; which each segment of rope is drawn)
  DEFB $01,$01,$01,$01,$01,$01,$01,$01
  DEFB $01,$01,$01,$01,$02,$02,$02,$02
  DEFB $02,$02,$02,$02,$02,$02,$02,$02
  DEFB $02,$02,$02,$02,$02,$02,$02,$02
  DEFB $02,$02,$01,$02,$02,$01,$01,$02
  DEFB $01,$01,$02,$02,$03,$02,$03,$02
  DEFB $03,$03,$03,$03,$03,$03
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Unused
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00
  DEFB $06,$06,$06,$06,$06,$06,$06,$06 ; These values determine the
  DEFB $06,$06,$06,$06,$06,$06,$06,$06 ; y-coordinate of each segment of rope
  DEFB $06,$06,$06,$06,$06,$06,$06,$06 ; relative to the one above it
  DEFB $06,$06,$06,$06,$06,$06,$06,$06
  DEFB $06,$06,$06,$06,$06,$06,$06,$06
  DEFB $06,$06,$06,$06,$06,$06,$06,$06
  DEFB $04,$06,$06,$04,$06,$04,$06,$04
  DEFB $06,$04,$04,$04,$06,$04,$04,$04
  DEFB $04,$04,$04,$04,$04,$04,$04,$04
  DEFB $04,$04,$04,$04,$04,$04,$04,$04
  DEFB $04,$04,$04,$04,$04,$04
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Unused
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00

; Current room number
;
; Initialised to 0x21 (The Bathroom) by the routine at TITLESCREEN, checked by
; the routines at INITROOM, DRAWTHINGS, DRAWITEMS, BEDANDBATH, CHKTOILET,
; DRAWTOILET and DRAWWILLY, and updated by the routines at ENDPAUSE, ROOMLEFT,
; ROOMRIGHT, ROOMABOVE and ROOMBELOW.
ROOM:
  DEFB $00

; Left-right movement table
;
; Used by the routine at MOVEWILLY2. The entries in this table are used to map
; the existing value (V) of Willy's direction and movement flags at DMFLAGS to
; a new value (V'), depending on the direction Willy is facing and how he is
; moving or being moved (by 'left' and 'right' keypresses and joystick input,
; or by a conveyor, or by an urge to visit the toilet).
;
; One of the first four entries is used when Willy is not moving.
LRMOVEMENT:
  DEFB $00                ; V=0 (facing right, no movement) + no movement: V'=0
                          ; (no change)
  DEFB $01                ; V=1 (facing left, no movement) + no movement: V'=1
                          ; (no change)
  DEFB $00                ; V=2 (facing right, moving) + no movement: V'=0
                          ; (facing right, no movement) (i.e. stop)
  DEFB $01                ; V=3 (facing left, moving) + no movement: V'=1
                          ; (facing left, no movement) (i.e. stop)
; One of the next four entries is used when Willy is moving left.
  DEFB $01                ; V=0 (facing right, no movement) + move left: V'=1
                          ; (facing left, no movement) (i.e. turn around)
  DEFB $03                ; V=1 (facing left, no movement) + move left: V'=3
                          ; (facing left, moving)
  DEFB $01                ; V=2 (facing right, moving) + move left: V'=1
                          ; (facing left, no movement) (i.e. turn around)
  DEFB $03                ; V=3 (facing left, moving) + move left: V'=3 (no
                          ; change)
; One of the next four entries is used when Willy is moving right.
  DEFB $02                ; V=0 (facing right, no movement) + move right: V'=2
                          ; (facing right, moving)
  DEFB $00                ; V=1 (facing left, no movement) + move right: V'=0
                          ; (facing right, no movement) (i.e. turn around)
  DEFB $02                ; V=2 (facing right, moving) + move right: V'=2 (no
                          ; change)
  DEFB $00                ; V=3 (facing left, moving) + move right: V'=0
                          ; (facing right, no movement) (i.e. turn around)
; One of the final four entries is used when Willy is being pulled both left
; and right; each entry leaves the flags at DMFLAGS unchanged (so Willy carries
; on moving in the direction he's already moving, or remains stationary).
  DEFB $00                ; V=V'=0 (facing right, no movement)
  DEFB $01                ; V=V'=1 (facing left, no movement)
  DEFB $02                ; V=V'=2 (facing right, moving)
  DEFB $03                ; V=V'=3 (facing left, moving)

; Triangle UDGs
;
; Used by the routine at TITLESCREEN.
TRIANGLE0:
  DEFB $C0,$F0,$FC,$FF,$FF,$FF,$FF,$FF
TRIANGLE1:
  DEFB $00,$00,$00,$00,$C0,$F0,$FC,$FF
TRIANGLE2:
  DEFB $FF,$FF,$FF,$FF,$FC,$F0,$C0,$00
TRIANGLE3:
  DEFB $FC,$F0,$C0,$00,$00,$00,$00,$00

; 'AIR'
;
; This message is not used.
  DEFM "AIR"

; '+++++ Press ENTER to Start +++++...'
;
; Used by the routine at TITLESCREEN.
MSG_INTRO:
  DEFM "+++++ Press ENTER to Start +++++"
  DEFM "  JET-SET WILLY by Matthew Smith  "
  DEFM $7F," 1984 SOFTWARE PROJECTS Ltd . . . . ."
  DEFM "Guide Willy to collect all the items around "
  DEFM "the house before Midnight "
  DEFM "so Maria will let you get to your bed. . . . . . ."
  DEFM "+++++ Press ENTER to Start +++++"

; 'Items collected 000 Time 00:00 m'
;
; Used by the routine at INITROOM.
MSG_STATUS:
  DEFM "Items collected 000 Time 00:00 m"

; 'Game'
;
; Used by the routine at GAMEOVER.
MSG_GAME:
  DEFM "Game"

; 'Over'
;
; Used by the routine at GAMEOVER.
MSG_OVER:
  DEFM "Over"

; Number of items collected
;
; Initialised by the routine at TITLESCREEN, printed by the routine at
; MAINLOOP, and updated by the routine at DRAWITEMS.
MSG_ITEMS:
  DEFM "000"

; Current time
;
; Initialised by the routine at STARTGAME, and printed and updated by the
; routine at MAINLOOP.
MSG_CURTIME:
  DEFM " 7:00a"

; ' 7:00a'
;
; Copied by the routine at STARTGAME to MSG_CURTIME.
MSG_7AM:
  DEFM " 7:00a"

; Minute counter
;
; Initialised by the routine at TITLESCREEN; incremented on each pass through
; the main loop by the routine at MAINLOOP (which moves the game clock forward
; by a minute when the counter reaches 0); reset to zero by the routine at
; CHKTOILET when Willy sticks his head down the toilet; and used by the
; routines at DRAWITEMS (to cycle the colours of the items in the room),
; BEDANDBATH (to determine Maria's animation frame in Master Bedroom) and
; DRAWTOILET (to determine the animation frame for the toilet in The Bathroom).
TICKS:
  DEFB $00

; Lives remaining
;
; Initialised to 7 by the routine at TITLESCREEN, decremented by the routine at
; LOSELIFE, and used by the routines at DRAWLIVES (when drawing the remaining
; lives) and ENDPAUSE (to adjust the speed and pitch of the in-game music).
LIVES:
  DEFB $00

; Screen flash counter
;
; Initialised to zero by the routine at TITLESCREEN, but never used; the code
; at SCRFLASH makes the screen flash in Manic Miner fashion if this address
; holds a non-zero value.
FLASH:
  DEFB $00

; Kempston joystick indicator
;
; Initialised by the routine at TITLESCREEN, and checked by the routines at
; MOVEWILLY2 and CHECKENTER. Holds 1 if a joystick is present, 0 otherwise.
JOYSTICK:
  DEFB $00

; Willy's pixel y-coordinate (x2)
;
; Initialised to 208 by the routine at TITLESCREEN, and used by the routines at
; MAINLOOP, ENDPAUSE, MOVEWILLY, MOVEWILLY2, MOVEWILLY3, DRAWTHINGS, ROOMABOVE,
; ROOMBELOW, BEDANDBATH, WILLYATTRS and DRAWWILLY. Holds the LSB of the address
; of the entry in the screen buffer address lookup table at SBUFADDRS that
; corresponds to Willy's pixel y-coordinate; in practice, this is twice Willy's
; actual pixel y-coordinate. Note that when Willy is standing on a ramp, this
; holds his pixel y-coordinate rounded down to the nearest value of 16 (8x2).
PIXEL_Y:
  DEFB $00

; Willy's direction and movement flags
;
; +--------+---------------------------+-------------------------+
; | Bit(s) | Meaning                   | Used by                 |
; +--------+---------------------------+-------------------------+
; | 0      | Direction Willy is facing | MOVEWILLY2, MOVEWILLY3, |
; |        | (reset=right, set=left)   | DRAWWILLY               |
; | 1      | Willy's movement flag     | MOVEWILLY, MOVEWILLY2,  |
; |        | (set=moving)              | MOVEWILLY3, DRAWTHINGS  |
; | 2-7    | Unused (always reset)     |                         |
; +--------+---------------------------+-------------------------+
DMFLAGS:
  DEFB $00

; Airborne status indicator
;
; Initialised by the routine at TITLESCREEN, checked by the routines at
; ENDPAUSE and WILLYATTRS, updated by the routines at KILLWILLY, DRAWTHINGS and
; ROOMABOVE, and checked and updated by the routines at MOVEWILLY, MOVEWILLY2
; and ROOMBELOW. Possible values are:
;
; +-----------+-----------------------------------------------------------+
; | Value     | Meaning                                                   |
; +-----------+-----------------------------------------------------------+
; | 0x00      | Willy is neither falling nor jumping                      |
; | 0x01      | Willy is jumping                                          |
; | 0x02-0x0B | Willy is falling, and can land safely                     |
; | 0x0C-0x0F | Willy is falling, and has fallen too far to land safely   |
; | 0xFF      | Willy has collided with a nasty, an arrow, a guardian, or |
; |           | Maria (see KILLWILLY)                                     |
; +-----------+-----------------------------------------------------------+
AIRBORNE:
  DEFB $00

; Willy's animation frame
;
; Used by the routines at WILLYATTRS and DRAWWILLY, and updated by the routines
; at MAINLOOP, MOVEWILLY3 and DRAWTHINGS. Possible values are 0, 1, 2 and 3.
FRAME:
  DEFB $00

; Address of Willy's location in the attribute buffer at 5C00
;
; Initialised by the routine at TITLESCREEN, and used by the routines at
; MOVEWILLY, MOVEWILLY3, DRAWTHINGS, ROOMLEFT, ROOMRIGHT, ROOMABOVE, ROOMBELOW,
; BEDANDBATH, CHKTOILET, WILLYATTRS and DRAWWILLY.
LOCATION:
  DEFW $0000

; Jumping animation counter
;
; Used by the routines at MOVEWILLY and MOVEWILLY2.
JUMPING:
  DEFB $00

; Rope status indicator
;
; Initialised by the routine at INITROOM, checked by the routine at MOVEWILLY,
; and checked and updated by the routines at MOVEWILLY2 and DRAWTHINGS.
; Possible values are:
;
; +-----------+--------------------------------------------------------------+
; | Value     | Meaning                                                      |
; +-----------+--------------------------------------------------------------+
; | 0x00      | Willy is not on the rope                                     |
; | 0x02-0x20 | Willy is on the rope, with the centre of his sprite anchored |
; |           | at this segment                                              |
; | 0xF0-0xFF | Willy has just jumped or fallen off the rope                 |
; +-----------+--------------------------------------------------------------+
ROPE:
  DEFB $00

; Willy's state on entry to the room
;
; Initialised by the routine at INITROOM, and copied back into 85CF-85D5 by the
; routine at LOSELIFE.
INITSTATE:
  DEFB $00                ; Willy's pixel y-coordinate (copied from PIXEL_Y)
  DEFB $00                ; Willy's direction and movement flags (copied from
                          ; DMFLAGS)
  DEFB $00                ; Airborne status indicator (copied from AIRBORNE)
  DEFB $00                ; Willy's animation frame (copied from FRAME)
  DEFW $0000              ; Address of Willy's location in the attribute buffer
                          ; at 23552 (copied from LOCATION)
  DEFB $00                ; Jumping animation counter (copied from JUMPING)

; 256 minus the number of items remaining
;
; Initialised by the routine at TITLESCREEN, and updated by the routine at
; DRAWITEMS when an item is collected.
ITEMS:
  DEFB $00

; Game mode indicator
;
; Initialised by the routine at TITLESCREEN, checked by the routines at
; MAINLOOP, MOVEWILLY2 and DRAWTOILET, and updated by the routines at
; DRAWITEMS, BEDANDBATH and CHKTOILET.
;
; +-------+---------------------------------+
; | Value | Meaning                         |
; +-------+---------------------------------+
; | 0     | Normal                          |
; | 1     | All items collected             |
; | 2     | Willy is running to the toilet  |
; | 3     | Willy's head is down the toilet |
; +-------+---------------------------------+
MODE:
  DEFB $00

; Inactivity timer
;
; Initialised by the routine at TITLESCREEN, and updated by the routines at
; MAINLOOP, ENDPAUSE and MOVEWILLY2.
INACTIVE:
  DEFB $00

; In-game music note index
;
; Initialised by the routine at TITLESCREEN, used by the routine at DRAWLIVES,
; and used and updated by the routine at ENDPAUSE.
NOTEINDEX:
  DEFB $00

; Music flags
;
; The keypress flag in bit 0 is initialised by the routine at TITLESCREEN; bits
; 0 and 1 are checked and updated by the routine at ENDPAUSE.
;
; +--------+-----------------------------------------------------------------+
; | Bit(s) | Meaning                                                         |
; +--------+-----------------------------------------------------------------+
; | 0      | Keypress flag (set=H-ENTER being pressed, reset=no key pressed) |
; | 1      | In-game music flag (set=music off, reset=music on)              |
; | 2-7    | Unused                                                          |
; +--------+-----------------------------------------------------------------+
MUSICFLAGS:
  DEFB $00

; WRITETYPER key counter
;
; Checked by the routine at MAINLOOP, and updated by the routine at ENDPAUSE.
TELEPORT:
  DEFB $00

; Temporary variable
;
; Used by the routines at CODESCREEN and READCODE to hold the entry code, by
; the routine at TITLESCREEN to hold the index into the message scrolled across
; the screen after the theme tune has finished playing, and by the routine at
; GAMEOVER to hold the distance of the foot from the top of the screen as it
; descends onto Willy.
TEMPVAR:
  DEFB $00

; WRITETYPER
;
; Used by the routine at ENDPAUSE. In each pair of bytes here, bits 0-4 of the
; first byte correspond to keys Q-W-E-R-T, and bits 0-4 of the second byte
; correspond to keys P-O-I-U-Y; among those bits, a zero indicates a key being
; pressed.
  DEFB %00011111,%00011111 ; (no keys pressed)
WRITETYPER:
  DEFB %00011101,%00011111 ; W
  DEFB %00010111,%00011111 ; R
  DEFB %00011111,%00011011 ; I
  DEFB %00001111,%00011111 ; T
  DEFB %00011011,%00011111 ; E
  DEFB %00001111,%00011111 ; T
  DEFB %00011111,%00001111 ; Y
  DEFB %00011111,%00011110 ; P
  DEFB %00011011,%00011111 ; E
  DEFB %00010111,%00011111 ; R

; Title screen tune data (Moonlight Sonata)
;
; Used by the routine at PLAYTUNE.
THEMETUNE:
  DEFB $51,$3C,$33,$51,$3C,$33,$51,$3C,$33,$51,$3C,$33,$51,$3C,$33,$51
  DEFB $3C,$33,$51,$3C,$33,$51,$3C,$33,$4C,$3C,$33,$4C,$3C,$33,$4C,$39
  DEFB $2D,$4C,$39,$2D,$51,$40,$2D,$51,$3C,$33,$51,$3C,$36,$5B,$40,$36
  DEFB $66,$51,$3C,$51,$3C,$33,$51,$3C,$33,$28,$3C,$28,$28,$36,$2D,$51
  DEFB $36,$2D,$51,$36,$2D,$28,$36,$28,$28,$3C,$33,$51,$3C,$33,$26,$3C
  DEFB $2D,$4C,$3C,$2D,$28,$40,$33,$51,$40,$33,$2D,$40,$36,$20,$40,$36
  DEFB $3D,$79,$3D,$FF

; In-game tune data (If I Were a Rich Man)
;
; Used by the routine at ENDPAUSE.
GAMETUNE:
  DEFB $56,$60,$56,$60,$66,$66,$80,$80,$80,$80,$66,$60,$56,$60,$56,$60
  DEFB $66,$60,$56,$4C,$48,$4C,$48,$4C,$56,$56,$56,$56,$56,$56,$56,$56
  DEFB $40,$40,$40,$40,$44,$44,$4C,$4C,$56,$60,$66,$60,$56,$56,$66,$66
  DEFB $51,$56,$60,$56,$51,$51,$60,$60,$40,$40,$40,$40,$40,$40,$40,$40

; The game has just loaded
;
; After the game has loaded, this is where it all starts.
BEGIN:
  DI                      ; Disable interrupts
  LD SP,$5C00             ; Initialise stack and drop into TITLESCREEN below

; Display the title screen and play the theme tune
;
; Used by the routines at BEGIN, MAINLOOP and GAMEOVER.
;
; The first thing this routine does is initialise some game status buffer
; variables in preparation for the next game.
TITLESCREEN:
  XOR A                   ; A=0
  LD (JOYSTICK),A         ; Initialise the Kempston joystick indicator at
                          ; JOYSTICK
  LD (NOTEINDEX),A        ; Initialise the in-game music note index at
                          ; NOTEINDEX
  LD (FLASH),A            ; Initialise the (unused) screen flash counter at
                          ; FLASH
  LD (AIRBORNE),A         ; Initialise the airborne status indicator at
                          ; AIRBORNE
  LD (TICKS),A            ; Initialise the minute counter at TICKS
  LD (INACTIVE),A         ; Initialise the inactivity timer at INACTIVE
  LD (MODE),A             ; Initialise the game mode indicator at MODE
  LD A,$07                ; Initialise the number of lives remaining at LIVES
  LD (LIVES),A
  LD A,$D0                ; Initialise Willy's pixel y-coordinate at PIXEL_Y
  LD (PIXEL_Y),A
  LD A,$21                ; Initialise the current room number at ROOM to 0x21
  LD (ROOM),A             ; (The Bathroom)
  LD HL,$5DB4             ; Initialise Willy's coordinates at LOCATION to
  LD (LOCATION),HL        ; (13,20)
  LD HL,MSG_ITEMS         ; Initialise the number of items collected at
  LD (HL),$30             ; MSG_ITEMS to "000"
  INC HL
  LD (HL),$30
  INC HL
  LD (HL),$30
  LD H,ITEMTABLE1/256     ; Page 0xA4 holds the first byte of each entry in the
                          ; item table
  LD A,(FIRSTITEM)        ; Pick up the index of the first item from FIRSTITEM
  LD L,A                  ; Point HL at the entry for the first item
  LD (ITEMS),A            ; Initialise the counter of items remaining at ITEMS
TITLESCREEN_0:
  SET 6,(HL)              ; Set the collection flag for every item in the item
  INC L                   ; table at ITEMTABLE1
  JR NZ,TITLESCREEN_0
  LD HL,MUSICFLAGS        ; Initialise the keypress flag in bit 0 at MUSICFLAGS
  SET 0,(HL)
; Next, prepare the screen.
TITLESCREEN_1:
  LD HL,$4000             ; Clear the entire display file
  LD DE,$4001
  LD BC,$17FF
  LD (HL),$00
  LDIR
  LD HL,ATTRSUPPER        ; Copy the attribute bytes for the title screen from
  LD BC,$0300             ; ATTRSUPPER and ATTRSLOWER to the attribute file
  LDIR
  LD HL,$5A60             ; Copy the attribute value 0x46 (INK 6: PAPER 0:
  LD DE,$5A61             ; BRIGHT 1) into the row of 32 cells from (19,0) to
  LD BC,$001F             ; (19,31) on the screen
  LD (HL),$46
  LDIR
  LD IX,MSG_INTRO         ; Print "+++++ Press ENTER to Start +++++" (see
  LD DE,$5060             ; MSG_INTRO) at (19,0)
  LD C,$20
  CALL PRINTMSG
  LD DE,$5800             ; Point DE at the first byte of the attribute file
; The following loop scans the top two-thirds of the attribute file, which
; contains values 0x00, 0x04, 0x05, 0x08, 0x09, 0x24, 0x25, 0x28, 0x29, 0x2C,
; 0x2D and 0xD3 (copied from ATTRSUPPER). Whenever a value other than 0x00,
; 0x09, 0x24, 0x2D or 0xD3 is found, a triangle UDG is drawn at the
; corresponding location in the display file.
TITLESCREEN_2:
  LD A,(DE)               ; Pick up a byte from the attribute file
  OR A                    ; Is it 0x00 (INK 0: PAPER 0)?
  JR Z,TITLESCREEN_6      ; If so, jump to consider the next byte in the
                          ; attribute file
  CP $D3                  ; Is it 0xD3 (INK 3: PAPER 2: BRIGHT 1: FLASH 1)?
  JR Z,TITLESCREEN_6      ; If so, jump to consider the next byte in the
                          ; attribute file
  CP $09                  ; Is it 0x09 (INK 1: PAPER 1)?
  JR Z,TITLESCREEN_6      ; If so, jump to consider the next byte in the
                          ; attribute file
  CP $2D                  ; Is it 0x2D (INK 5: PAPER 5)?
  JR Z,TITLESCREEN_6      ; If so, jump to consider the next byte in the
                          ; attribute file
  CP $24                  ; Is it 0x24 (INK 4: PAPER 4)?
  JR Z,TITLESCREEN_6      ; If so, jump to consider the next byte in the
                          ; attribute file
  LD C,$00                ; C=0; this will be used as an offset from the
                          ; triangle UDG base address (TRIANGLE0)
  CP $08                  ; Is the attribute value 0x08 (INK 0: PAPER 1)?
  JR Z,TITLESCREEN_4      ; Jump if so
  CP $29                  ; Is it 0x29 (INK 1: PAPER 5)?
  JR Z,TITLESCREEN_4      ; Jump if so
  CP $2C                  ; Is it 0x2C (INK 4: PAPER 5)?
  JR Z,TITLESCREEN_3      ; Jump if so
  CP $05                  ; Is it 0x05 (INK 5: PAPER 0)?
  JR Z,TITLESCREEN_4      ; Jump if so
  LD C,$10                ; Set the triangle UDG offset to 0x10
  JR TITLESCREEN_4
TITLESCREEN_3:
  LD A,$25                ; Change the attribute byte here from 0x2C (INK 4:
  LD (DE),A               ; PAPER 5) to 0x25 (INK 5: PAPER 4)
TITLESCREEN_4:
  LD A,E                  ; Point HL at the triangle UDG to draw (TRIANGLE0,
  AND $01                 ; TRIANGLE1, TRIANGLE2 or TRIANGLE3)
  RLCA
  RLCA
  RLCA
  OR C
  LD C,A
  LD B,$00
  LD HL,TRIANGLE0
  ADD HL,BC
  PUSH DE                 ; Save the attribute file address briefly
  BIT 0,D                 ; Set the zero flag if we're still in the top third
                          ; of the attribute file
  LD D,$40                ; Point DE at the top third of the display file
  JR Z,TITLESCREEN_5      ; Jump if we're still in the top third of the
                          ; attribute file
  LD D,$48                ; Point DE at the middle third of the display file
TITLESCREEN_5:
  LD B,$08                ; There are eight pixel rows in a triangle UDG
  CALL PRINTCHAR_0        ; Draw a triangle UDG on the screen
  POP DE                  ; Restore the attribute file address to DE
TITLESCREEN_6:
  INC DE                  ; Point DE at the next byte in the attribute file
  LD A,D                  ; Have we finished scanning the top two-thirds of the
  CP $5A                  ; attribute file yet?
  JP NZ,TITLESCREEN_2     ; If not, jump back to examine the next byte
; Now check whether there is a joystick connected.
  LD BC,$001F             ; This is the joystick port
  DI                      ; Disable interrupts (which are already disabled)
  XOR A                   ; A=0
TITLESCREEN_7:
  IN E,(C)                ; Combine 256 readings of the joystick port in A; if
  OR E                    ; no joystick is connected, some of these readings
  DJNZ TITLESCREEN_7      ; will have bit 5 set
  AND $20                 ; Is a joystick connected (bit 5 reset)?
  JR NZ,TITLESCREEN_8     ; Jump if not
  LD A,$01                ; Set the Kempston joystick indicator at JOYSTICK to
  LD (JOYSTICK),A         ; 1
; And finally, play the theme tune and check for keypresses.
TITLESCREEN_8:
  LD HL,THEMETUNE         ; Point HL at the theme tune data at THEMETUNE
  CALL PLAYTUNE           ; Play the theme tune
  JP NZ,STARTGAME         ; Start the game if ENTER, 0 or the fire button was
                          ; pressed
  XOR A                   ; Initialise the temporary game status buffer
  LD (TEMPVAR),A          ; variable at TEMPVAR to 0; this will be used as an
                          ; index for the message scrolled across the screen
                          ; (see MSG_INTRO)
TITLESCREEN_9:
  CALL CYCLEATTRS         ; Cycle the INK and PAPER colours
  LD HL,$5A60             ; Copy the attribute value 0x4F (INK 7: PAPER 1:
  LD DE,$5A61             ; BRIGHT 1) into the row of 32 cells from (19,0) to
  LD BC,$001F             ; (19,31) on the screen
  LD (HL),$4F
  LDIR
  LD A,(TEMPVAR)          ; Pick up the message index from TEMPVAR
  LD IX,MSG_INTRO         ; Point IX at the corresponding location in the
  LD E,A                  ; message at MSG_INTRO
  LD D,$00
  ADD IX,DE
  LD DE,$5060             ; Print 32 characters of the message at (19,0)
  LD C,$20
  CALL PRINTMSG
  LD A,(TEMPVAR)          ; Prepare a value between 0x32 and 0x51 in A (for the
  AND $1F                 ; routine at INTROSOUND)
  ADD A,$32
  CALL INTROSOUND         ; Make a sound effect
  LD BC,$AFFE             ; Read keys H-J-K-L-ENTER and 6-7-8-9-0
  IN A,(C)
  AND $01                 ; Keep only bit 0 of the result (ENTER, 0)
  CP $01                  ; Was ENTER or 0 pressed?
  JR NZ,STARTGAME         ; Jump if so to start the game
  LD A,(TEMPVAR)          ; Pick up the message index from TEMPVAR
  INC A                   ; Increment it
  CP $E0                  ; Set the zero flag if we've reached the end of the
                          ; message
  LD (TEMPVAR),A          ; Store the new message index at TEMPVAR
  JR NZ,TITLESCREEN_9     ; Jump back unless we've finished scrolling the
                          ; message across the screen
  JP TITLESCREEN_1        ; Jump back to prepare the screen and play the theme
                          ; tune again

; Start the game
;
; Used by the routine at TITLESCREEN.
STARTGAME:
  LD HL,MSG_7AM           ; Initialise the time by copying the text at MSG_7AM
  LD DE,MSG_CURTIME       ; (" 7:00a") to MSG_CURTIME
  LD BC,$0006
  LDIR
  LD HL,ATTRSLOWER        ; Copy the attribute bytes from ATTRSLOWER to the
  LD DE,$5A00             ; bottom third of the screen
  LD BC,$0100
  LDIR
; This routine continues into the one at INITROOM.

; Initialise the current room
;
; Used by the routines at ENDPAUSE (to teleport into a room), LOSELIFE (to
; reinitialise the room after Willy has lost a life), ROOMLEFT (when Willy has
; entered the room from the right), ROOMRIGHT (when Willy has entered the room
; from the left), ROOMABOVE (when Willy has entered the room from below) and
; ROOMBELOW (when Willy has entered the room from above). The routine at
; STARTGAME also continues here.
INITROOM:
  LD A,(ROOM)             ; Pick up the current room number from ROOM
  OR $C0                  ; Point HL at the first byte of the room definition
  LD H,A
  LD L,$00
  LD DE,ROOMLAYOUT        ; Copy the room definition into the game status
  LD BC,$0100             ; buffer at 8000
  LDIR
  LD IX,ENTITIES          ; Point IX at the first byte of the first entity
                          ; specification for the current room at ENTITIES
  LD DE,ENTITYBUF         ; Point DE at the first byte of the first entity
                          ; buffer at ENTITYBUF; this instruction is redundant,
                          ; since DE already holds 8100
  LD A,$08                ; There are at most eight entities in a room
INITROOM_0:
  LD L,(IX+$00)           ; Pick up the first byte of the entity specification
  RES 7,L                 ; Point HL at the corresponding entry in the table of
  LD H,$14                ; entity definitions at ENTITYDEFS
  ADD HL,HL
  ADD HL,HL
  ADD HL,HL
  LD BC,$0002             ; Copy the first two bytes of the entity definition
  LDIR                    ; into the entity buffer
  LD C,(IX+$01)           ; Copy the second byte of the entity specification
  LD (HL),C               ; into the third byte of the entity definition
  LD BC,$0006             ; Copy the remaining six bytes of the entity
  LDIR                    ; definition into the entity buffer
  INC IX                  ; Point IX at the first byte of the next entity
  INC IX                  ; specification
  DEC A                   ; Have we copied all eight entity definitions into
                          ; the entity buffers yet?
  JR NZ,INITROOM_0        ; If not, jump back to copy the next one
  LD HL,PIXEL_Y           ; Copy the seven bytes that define Willy's state
  LD DE,INITSTATE         ; (position, animation frame etc.) on entry to this
  LD BC,$0007             ; room from 85CF-85D5 to INITSTATE
  LDIR
  CALL DRAWROOM           ; Draw the current room to the screen buffer at 28672
                          ; and the attribute buffer at 24064
  LD HL,$5000             ; Clear the bottom third of the display file
  LD DE,$5001
  LD BC,$07FF
  LD (HL),$00
  LDIR
  LD IX,ROOMNAME          ; Print the room name (see ROOMNAME) at (16,0)
  LD C,$20
  LD DE,$5000
  CALL PRINTMSG
  LD IX,MSG_STATUS        ; Print "Items collected 000 Time 00:00 m" (see
  LD DE,$5060             ; MSG_STATUS) at (19,0)
  LD C,$20
  CALL PRINTMSG
  LD A,(BORDER)           ; Pick up the border colour for the current room from
                          ; BORDER
  LD C,$FE                ; Set the border colour
  OUT (C),A
  XOR A                   ; Initialise the rope status indicator at ROPE to 0
  LD (ROPE),A
  JP MAINLOOP             ; Enter the main loop

; Draw the remaining lives
;
; Used by the routine at MAINLOOP.
DRAWLIVES:
  LD A,(LIVES)            ; Pick up the number of lives remaining from LIVES
  LD HL,$50A0             ; Set HL to the display file address at which to draw
                          ; the first Willy sprite
  OR A                    ; Are there any lives remaining?
  RET Z                   ; Return if not
  LD B,A                  ; Initialise B to the number of lives remaining
; The sprite-drawing loop begins.
DRAWLIVES_0:
  LD C,$00                ; C=0; this tells the sprite-drawing routine at
                          ; DRAWSPRITE to overwrite any existing graphics
  PUSH HL                 ; Save HL and BC briefly
  PUSH BC
  LD A,(NOTEINDEX)        ; Pick up the in-game music note index from
                          ; NOTEINDEX; this will determine the animation frame
                          ; for the Willy sprites
  RLCA                    ; Now A=0x00 (frame 0), 0x20 (frame 1), 0x40 (frame
  RLCA                    ; 2) or 0x60 (frame 3)
  RLCA
  AND $60
  LD E,A                  ; Point DE at the corresponding Willy sprite (at
  LD D,MANDAT/256         ; MANDAT+A)
  CALL DRAWSPRITE         ; Draw the Willy sprite on the screen
  POP BC                  ; Restore HL and BC
  POP HL
  INC HL                  ; Move HL along to the location at which to draw the
  INC HL                  ; next Willy sprite
  DJNZ DRAWLIVES_0        ; Jump back to draw any remaining sprites
  RET

; Main loop (1)
;
; Used by the routines at INITROOM and ENDPAUSE.
MAINLOOP:
  CALL DRAWLIVES          ; Draw the remaining lives
  LD HL,$5E00             ; Copy the contents of the attribute buffer at 24064
  LD DE,$5C00             ; (the attributes for the empty room) into the
  LD BC,$0200             ; attribute buffer at 23552
  LDIR
  LD HL,$7000             ; Copy the contents of the screen buffer at 28672
  LD DE,$6000             ; (the tiles for the empty room) into the screen
  LD BC,$1000             ; buffer at 24576
  LDIR
  CALL MOVETHINGS         ; Move the rope and guardians in the current room
  LD A,(MODE)             ; Pick up the game mode indicator from MODE
  CP $03                  ; Is Willy's head down the toilet?
  CALL NZ,MOVEWILLY       ; If not, move Willy
AFTERMOVE1:
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate from PIXEL_Y
  CP $F0                  ; Has Willy just moved up a ramp or a rope past the
                          ; top of the screen?
  JP NC,ROOMABOVE         ; If so, move Willy into the room above
  CP $E0                  ; Has Willy just moved down a ramp or fallen past the
                          ; bottom of the screen?
  JP NC,ROOMBELOW         ; If so, move Willy into the room above
AFTERMOVE2:
  LD A,(MODE)             ; Pick up the game mode indicator from MODE
  CP $03                  ; Is Willy's head down the toilet?
  CALL NZ,WILLYATTRS      ; If not, check and set the attribute bytes for
                          ; Willy's sprite in the buffer at 23552, and draw
                          ; Willy to the screen buffer at 24576
  LD A,(MODE)             ; Pick up the game mode indicator from MODE
  CP $02                  ; Is Willy on his way to the toilet?
  CALL Z,CHKTOILET        ; If so, check whether he's reached it yet
  CALL BEDANDBATH         ; Deal with special rooms (Master Bedroom, The
                          ; Bathroom)
  CALL DRAWTHINGS         ; Draw the rope, arrows and guardians in the current
                          ; room
  CALL MVCONVEYOR         ; Move the conveyor in the current room (if there is
                          ; one)
  CALL DRAWITEMS          ; Draw the items in the current room (if there are
                          ; any) and collect any that Willy is touching
; This entry point is used by the routine at KILLWILLY.
MAINLOOP_0:
  LD HL,$6000             ; Copy the contents of the screen buffer at 24576 to
  LD DE,$4000             ; the display file
  LD BC,$1000
  LDIR
  LD A,(MODE)             ; Pick up the game mode indicator from MODE
  AND $02                 ; Now A=1 if Willy is running to the toilet or
  RRCA                    ; already has his head down it, 0 otherwise
  LD HL,FRAME             ; Set Willy's animation frame at FRAME to 1 or 3 if
  OR (HL)                 ; Willy is running to the toilet or already has his
  LD (HL),A               ; head down it; this has the effect of moving Willy
                          ; at twice his normal speed as he makes his way to
                          ; the toilet (using animation frames 2 and 0)
SCRFLASH:
  LD A,(FLASH)            ; Pick up the screen flash counter (unused and always
                          ; 0) from FLASH
  OR A                    ; Is it zero?
  JR Z,MAINLOOP_1         ; Jump if so (this jump is always made)
; The next section of code is never executed.
  DEC A                   ; Decrement the screen flash counter at FLASH
  LD (FLASH),A
  RLCA                    ; Move bits 0-2 into bits 3-5 and clear all the other
  RLCA                    ; bits
  RLCA
  AND $38
  LD HL,$5C00             ; Set every attribute byte in the buffer at 23552 to
  LD DE,$5C01             ; this value
  LD BC,$01FF
  LD (HL),A
  LDIR
; Normal service resumes here.
MAINLOOP_1:
  LD HL,$5C00             ; Copy the contents of the attribute buffer at 23552
  LD DE,$5800             ; to the attribute file
  LD BC,$0200
  LDIR
  LD IX,MSG_CURTIME       ; Print the current time (see MSG_CURTIME) at (19,25)
  LD DE,$5079
  LD C,$06
  CALL PRINTMSG
  LD IX,MSG_ITEMS         ; Print the number of items collected (see MSG_ITEMS)
  LD DE,$5070             ; at (19,16)
  LD C,$03
  CALL PRINTMSG
  LD A,(TICKS)            ; Increment the minute counter at TICKS
  INC A
  LD (TICKS),A
  JR NZ,MAINLOOP_3        ; Jump unless the minute counter has ticked over to 0
; A minute of game time has passed. Update the game clock accordingly.
  LD IX,MSG_CURTIME       ; Point IX at the current time at MSG_CURTIME
  INC (IX+$04)            ; Increment the units digit of the minute
  LD A,(IX+$04)           ; Pick up the new units digit
  CP $3A                  ; Was it '9' before?
  JR NZ,MAINLOOP_3        ; Jump if not
  LD (IX+$04),$30         ; Set the units digit of the minute to '0'
  INC (IX+$03)            ; Increment the tens digit of the minute
  LD A,(IX+$03)           ; Pick up the new tens digit
  CP $36                  ; Was it '5' before?
  JR NZ,MAINLOOP_3        ; Jump if not
  LD (IX+$03),$30         ; Set the tens digit of the minute to '0'
  LD A,(IX+$00)           ; Pick up the tens digit of the hour
  CP $31                  ; Is it currently '1'?
  JR NZ,MAINLOOP_2        ; Jump if not
  INC (IX+$01)            ; Increment the units digit of the hour
  LD A,(IX+$01)           ; Pick up the new units digit
  CP $33                  ; Was it '2' before?
  JR NZ,MAINLOOP_3        ; Jump if not
  LD A,(IX+$05)           ; Pick up the 'a' or 'p' of 'am/pm'
  CP $70                  ; Is it 'p'?
  JP Z,TITLESCREEN        ; If so, quit the game (it's 1am)
  LD (IX+$00),$20         ; Set the tens digit of the hour to ' ' (space)
  LD (IX+$01),$31         ; Set the units digit of the hour to '1'
  LD (IX+$05),$70         ; Change the 'a' of 'am' to 'p'
  JR MAINLOOP_3
MAINLOOP_2:
  INC (IX+$01)            ; Increment the units digit of the hour
  LD A,(IX+$01)           ; Pick up the new units digit
  CP $3A                  ; Was it '9' before?
  JR NZ,MAINLOOP_3        ; Jump if not
  LD (IX+$01),$30         ; Set the units digit of the hour to '0'
  LD (IX+$00),$31         ; Set the tens digit of the hour to '1'
; Now check whether any non-movement keys are being pressed.
MAINLOOP_3:
  LD BC,$FEFE             ; Read keys SHIFT-Z-X-C-V
  IN A,(C)
  LD E,A                  ; Save the result in E
  LD B,$7F                ; Read keys B-N-M-SS-SPACE
  IN A,(C)
  OR E                    ; Combine the results
  AND $01                 ; Are SHIFT and SPACE being pressed?
  JP Z,TITLESCREEN        ; If so, quit the game
  LD A,(INACTIVE)         ; Increment the inactivity timer at INACTIVE
  INC A
  LD (INACTIVE),A
  JR Z,PAUSE              ; Jump if the inactivity timer is now 0 (no keys have
                          ; been pressed for a while)
  LD B,$FD                ; Read keys A-S-D-F-G
  IN A,(C)
  AND $1F                 ; Are any of these keys being pressed?
  CP $1F
  JR Z,ENDPAUSE_0         ; Jump if not
  LD DE,$0000             ; Prepare the delay counters in D and E for the pause
                          ; loop that follows
; The following loop pauses the game until any key except A, S, D, F or G is
; pressed.
PAUSE:
  LD B,$02                ; Read every half-row of keys except A-S-D-F-G
  IN A,(C)
  AND $1F                 ; Are any of these keys being pressed?
  CP $1F
  JR NZ,ENDPAUSE          ; If so, resume the game
  INC E                   ; Increment the delay counter in E
  JR NZ,PAUSE             ; Jump back unless it's zero
  INC D                   ; Increment the delay counter in D
  JR NZ,PAUSE             ; Jump back unless it's zero
  LD A,(TELEPORT)         ; Pick up the WRITETYPER key counter from TELEPORT
  CP $0A                  ; Has WRITETYPER been keyed in yet?
  CALL NZ,CYCLEATTRS      ; If not, cycle the INK and PAPER colours
  JR PAUSE                ; Jump back to the beginning of the pause loop

; Cycle the INK and PAPER colours
;
; Used by the routines at TITLESCREEN (while scrolling the instructions across
; the screen) and MAINLOOP (while the game is paused).
CYCLEATTRS:
  LD HL,$5800             ; Point HL at the first byte of the attribute file
  LD A,(HL)               ; Pick up this byte
  AND $07                 ; Keep only bits 0-2 (the INK colour)
  OUT ($FE),A             ; Set the border colour to match
; Now we loop over every byte in the attribute file.
CYCLEATTRS_0:
  LD A,(HL)               ; Pick up an attribute file byte
  ADD A,$03               ; Cycle the INK colour forward by three
  AND $07
  LD D,A                  ; Save the new INK colour in D
  LD A,(HL)               ; Pick up the attribute file byte again
  ADD A,$18               ; Cycle the PAPER colour forward by three (and turn
  AND $B8                 ; off any BRIGHT colours)
  OR D                    ; Merge in the new INK colour
  LD (HL),A               ; Save the new attribute byte
  INC HL                  ; Point HL at the next byte in the attribute file
  LD A,H                  ; Have we reached the end of the attribute file yet?
  CP $5B
  JR NZ,CYCLEATTRS_0      ; If not, jump back to modify the next byte
  RET

; Main loop (2)
;
; Used by the routine at MAINLOOP. The main entry point is used when resuming
; the game after it has been paused.
ENDPAUSE:
  LD HL,ATTRSLOWER        ; Copy the attribute bytes from ATTRSLOWER to the
  LD DE,$5A00             ; bottom third of the screen
  LD BC,$0100
  LDIR
  LD A,(BORDER)           ; Pick up the border colour for the current room from
                          ; BORDER
  OUT ($FE),A             ; Restore the border colour
; This entry point is used by the routine at MAINLOOP.
ENDPAUSE_0:
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  CP $FF                  ; Has Willy landed after falling from too great a
                          ; height, or collided with a nasty, an arrow, a
                          ; guardian, or Maria?
  JP Z,LOSELIFE           ; If so, lose a life
; Now read the keys H, J, K, L and ENTER (which toggle the in-game music).
  LD B,$BF                ; Prepare B for reading keys H-J-K-L-ENTER
  LD HL,MUSICFLAGS        ; Point HL at the music flags at MUSICFLAGS
  IN A,(C)                ; Read keys H-J-K-L-ENTER; note that if the game has
                          ; just resumed after being paused, C holds 0x00
                          ; instead of 0xFE, which is a bug
  AND $1F                 ; Are any of these keys being pressed?
  CP $1F
  JR Z,ENDPAUSE_1         ; Jump if not
  BIT 0,(HL)              ; Were any of these keys being pressed the last time
                          ; we checked?
  JR NZ,ENDPAUSE_2        ; Jump if so
  LD A,(HL)               ; Set bit 0 (the keypress flag) and flip bit 1 (the
  XOR $03                 ; in-game music flag) at MUSICFLAGS
  LD (HL),A
  JR ENDPAUSE_2
ENDPAUSE_1:
  RES 0,(HL)              ; Reset bit 0 (the keypress flag) at MUSICFLAGS
ENDPAUSE_2:
  BIT 1,(HL)              ; Has the in-game music been switched off?
  JR NZ,ENDPAUSE_5        ; Jump if so
; The next section of code plays a note of the in-game music.
  XOR A                   ; Reset the inactivity timer at INACTIVE (the game
  LD (INACTIVE),A         ; does not automatically pause after a period of
                          ; inactivity if the in-game music is playing)
  LD A,(NOTEINDEX)        ; Increment the in-game music note index at NOTEINDEX
  INC A
  LD (NOTEINDEX),A
  AND $7E                 ; Point HL at the appropriate entry in the tune data
  RRCA                    ; table at GAMETUNE
  LD E,A
  LD D,$00
  LD HL,GAMETUNE
  ADD HL,DE
  LD A,(LIVES)            ; Pick up the number of lives remaining (0-7) from
                          ; LIVES
  RLCA                    ; A=28-4A; this value adjusts the pitch of the note
  RLCA                    ; that is played depending on how many lives are
  SUB $1C                 ; remaining (the more lives remaining, the higher the
  NEG                     ; pitch)
  ADD A,(HL)              ; Add the entry from the tune data table for the
                          ; current note
  LD D,A                  ; Copy this value to D (which determines the pitch of
                          ; the note)
  LD A,(BORDER)           ; Pick up the border colour for the current room from
                          ; BORDER
  LD E,D                  ; Initialise the pitch delay counter in E
  LD BC,$0003             ; Initialise the duration delay counters in B (0) and
                          ; C (3)
ENDPAUSE_3:
  OUT ($FE),A             ; Produce a note of the in-game music
  DEC E
  JR NZ,ENDPAUSE_4
  LD E,D
  XOR $18
ENDPAUSE_4:
  DJNZ ENDPAUSE_3
  DEC C
  JR NZ,ENDPAUSE_3
; Here we check the teleport keys.
ENDPAUSE_5:
  LD BC,$EFFE             ; Read keys 6-7-8-9-0
  IN A,(C)
  BIT 1,A                 ; Is '9' (the activator key) being pressed?
  JP NZ,ENDPAUSE_6        ; Jump if not
  AND $10                 ; Keep only bit 4 (corresponding to the '6' key),
  XOR $10                 ; flip it, and move it into bit 5
  RLCA
  LD D,A                  ; Now bit 5 of D is set if '6' is being pressed
  LD A,(TELEPORT)         ; Pick up the WRITETYPER key counter from TELEPORT
  CP $0A                  ; Has WRITETYPER been keyed in yet?
  JP NZ,ENDPAUSE_6        ; Jump if not
  LD BC,$F7FE             ; Read keys 1-2-3-4-5
  IN A,(C)
  CPL                     ; Keep only bits 0-4 and flip them
  AND $1F
  OR D                    ; Copy bit 5 of D into A; now A holds the number of
                          ; the room to teleport to
  LD (ROOM),A             ; Store the room number at ROOM
  JP INITROOM             ; Teleport into the room
; Finally, check the WRITETYPER keys.
ENDPAUSE_6:
  LD A,(TELEPORT)         ; Pick up the WRITETYPER key counter from TELEPORT
  CP $0A                  ; Has WRITETYPER been keyed in yet?
  JP Z,MAINLOOP           ; If so, jump back to the start of the main loop
  LD A,(ROOM)             ; Pick up the current room number from ROOM
  CP $1C                  ; Are we in First Landing?
  JP NZ,MAINLOOP          ; If not, jump back to the start of the main loop
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate from PIXEL_Y
  CP $D0                  ; Is Willy on the floor at the bottom of the
                          ; staircase?
  JP NZ,MAINLOOP          ; If not, jump back to the start of the main loop
  LD A,(TELEPORT)         ; Pick up the WRITETYPER key counter (0-9) from
                          ; TELEPORT
  RLCA                    ; Point IX at the corresponding entry in the
  LD E,A                  ; WRITETYPER table at WRITETYPER
  LD D,$00
  LD IX,WRITETYPER
  ADD IX,DE
  LD BC,$FBFE             ; Read keys Q-W-E-R-T
  IN A,(C)
  AND $1F                 ; Keep only bits 0-4
  CP (IX+$00)             ; Does this match the first byte of the entry in the
                          ; WRITETYPER table?
  JR Z,ENDPAUSE_7         ; Jump if so
  CP $1F                  ; Are any of the keys Q-W-E-R-T being pressed?
  JP Z,MAINLOOP           ; If not, jump back to the start of the main loop
  CP (IX-$02)             ; Does the keyboard reading match the first byte of
                          ; the previous entry in the WRITETYPER table?
  JP Z,MAINLOOP           ; If so, jump back to the start of the main loop
  XOR A                   ; Reset the WRITETYPER key counter at TELEPORT to 0
  LD (TELEPORT),A         ; (an incorrect key was pressed)
  JP MAINLOOP             ; Jump back to the start of the main loop
ENDPAUSE_7:
  LD B,$DF                ; Read keys Y-U-I-O-P
  IN A,(C)
  AND $1F                 ; Keep only bits 0-4
  CP (IX+$01)             ; Does this match the second byte of the entry in the
                          ; WRITETYPER table?
  JR Z,ENDPAUSE_8         ; If so, jump to increment the WRITETYPER key counter
  CP $1F                  ; Are any of the keys Y-U-I-O-P being pressed?
  JP Z,MAINLOOP           ; If not, jump back to the start of the main loop
  CP (IX-$01)             ; Does the keyboard reading match the second byte of
                          ; the previous entry in the WRITETYPER table?
  JP Z,MAINLOOP           ; If so, jump back to the start of the main loop
  XOR A                   ; Reset the WRITETYPER key counter at TELEPORT to 0
  LD (TELEPORT),A         ; (an incorrect key was pressed)
  JP MAINLOOP             ; Jump back to the start of the main loop
ENDPAUSE_8:
  LD A,(TELEPORT)         ; Increment the WRITETYPER key counter at TELEPORT
  INC A
  LD (TELEPORT),A
  JP MAINLOOP             ; Jump back to the start of the main loop

; Lose a life
;
; Used by the routine at ENDPAUSE.
LOSELIFE:
  LD A,$47                ; A=0x47 (INK 7: PAPER 0: BRIGHT 1)
; The following loop fills the top two thirds of the attribute file with a
; single value (0x47, 0x46, 0x45, 0x44, 0x43, 0x42, 0x41 or 0x40) and makes a
; sound effect.
LOSELIFE_0:
  LD HL,$5800             ; Fill the top two thirds of the attribute file with
  LD DE,$5801             ; the value in A
  LD BC,$01FF
  LD (HL),A
  LDIR
  LD E,A                  ; Save the attribute byte (0x40-0x47) in E for later
                          ; retrieval
  CPL                     ; D=63-8*(E AND 7); this value determines the pitch
  AND $07                 ; of the short note that will be played
  RLCA
  RLCA
  RLCA
  OR $07
  LD D,A
  LD C,E                  ; C=8+32*(E AND 7); this value determines the
  RRC C                   ; duration of the short note that will be played
  RRC C
  RRC C
  OR $10                  ; Set bit 4 of A (for no apparent reason)
  XOR A                   ; Set A=0 (this will make the border black)
LOSELIFE_1:
  OUT ($FE),A             ; Produce a short note whose pitch is determined by D
  XOR $18                 ; and whose duration is determined by C
  LD B,D
LOSELIFE_2:
  DJNZ LOSELIFE_2
  DEC C
  JR NZ,LOSELIFE_1
  LD A,E                  ; Restore the attribute byte (originally 0x47) to A
  DEC A                   ; Decrement it (effectively decrementing the INK
                          ; colour)
  CP $3F                  ; Have we used attribute value 0x40 (INK 0) yet?
  JR NZ,LOSELIFE_0        ; If not, jump back to update the INK colour in the
                          ; top two thirds of the screen and make another sound
                          ; effect
; Now check whether any lives remain.
  LD HL,LIVES             ; Pick up the number of lives remaining from LIVES
  LD A,(HL)
  OR A                    ; Are there any lives remaining?
  JP Z,GAMEOVER           ; If not, display the game over sequence
  DEC (HL)                ; Decrease the number of lives remaining by one
  LD HL,INITSTATE         ; Restore Willy's state upon entry to the room by
  LD DE,PIXEL_Y           ; copying the seven bytes at INITSTATE back into
  LD BC,$0007             ; 85CF-85D5
  LDIR
  JP INITROOM             ; Reinitialise the room and resume the game

; Display the game over sequence
;
; Used by the routine at LOSELIFE.
GAMEOVER:
  LD HL,$4000             ; Clear the top two-thirds of the display file
  LD DE,$4001
  LD BC,$0FFF
  LD (HL),$00
  LDIR
  XOR A                   ; Initialise the temporary game status buffer
  LD (TEMPVAR),A          ; variable at TEMPVAR; this variable will determine
                          ; the distance of the foot from the top of the screen
  LD DE,WILLYR2           ; Draw Willy at (12,15)
  LD HL,$488F
  LD C,$00
  CALL DRAWSPRITE
  LD DE,BARREL            ; Draw the barrel underneath Willy at (14,15)
  LD HL,$48CF
  LD C,$00
  CALL DRAWSPRITE
; The following loop draws the foot's descent onto the barrel that supports
; Willy.
GAMEOVER_0:
  LD A,(TEMPVAR)          ; Pick up the distance variable from TEMPVAR
  LD C,A                  ; Point BC at the corresponding entry in the screen
  LD B,SBUFADDRS/256      ; buffer address lookup table at SBUFADDRS
  LD A,(BC)               ; Point HL at the corresponding location in the
  OR $0F                  ; display file
  LD L,A
  INC BC
  LD A,(BC)
  SUB $20
  LD H,A
  LD DE,FOOT              ; Draw the foot at this location, without erasing the
  LD C,$00                ; foot at the previous location; this leaves the
  CALL DRAWSPRITE         ; portion of the foot sprite that's above the ankle
                          ; in place, and makes the foot appear as if it's at
                          ; the end of a long, extending leg
  LD A,(TEMPVAR)          ; Pick up the distance variable from TEMPVAR
  CPL                     ; A=0xFF-A
  LD E,A                  ; Store this value (0x3F-0xFF) in E; it determines
                          ; the (rising) pitch of the sound effect that will be
                          ; made
  XOR A                   ; A=0 (black border)
  LD BC,$0040             ; C=0x40; this value determines the duration of the
                          ; sound effect
GAMEOVER_1:
  OUT ($FE),A             ; Produce a short note whose pitch is determined by E
  XOR $18
  LD B,E
GAMEOVER_2:
  DJNZ GAMEOVER_2
  DEC C
  JR NZ,GAMEOVER_1
  LD HL,$5800             ; Prepare BC, DE and HL for setting the attribute
  LD DE,$5801             ; bytes in the top two-thirds of the screen
  LD BC,$01FF
  LD A,(TEMPVAR)          ; Pick up the distance variable from TEMPVAR
  AND $0C                 ; Keep only bits 2 and 3
  RLCA                    ; Shift bits 2 and 3 into bits 3 and 4; these bits
                          ; determine the PAPER colour: 0, 1, 2 or 3
  OR $47                  ; Set bits 0-2 (INK 7) and 6 (BRIGHT 1)
  LD (HL),A               ; Copy this attribute value into the top two-thirds
  LDIR                    ; of the screen
  AND $FA                 ; Reset bits 0 and 2, and retain all other bits
  OR $02                  ; Set bit 1 (INK 2)
  LD ($59CF),A            ; Copy this attribute value to the cells at (14,15),
  LD ($59D0),A            ; (14,16), (15, 15) and (15, 16) (where the barrel
  LD ($59EF),A            ; is, so that it remains red)
  LD ($59F0),A
  LD A,(TEMPVAR)          ; Add 4 to the distance variable at TEMPVAR; this
  ADD A,$04               ; will move the foot sprite down two pixel rows
  LD (TEMPVAR),A
  CP $C4                  ; Has the foot met the barrel yet?
  JR NZ,GAMEOVER_0        ; Jump back if not
; Now print the "Game Over" message, just to drive the point home.
  LD IX,MSG_GAME          ; Print "Game" (see MSG_GAME) at (6,10)
  LD C,$04
  LD DE,$40CA
  CALL PRINTMSG
  LD IX,MSG_OVER          ; Print "Over" (see MSG_OVER) at (6,18)
  LD C,$04
  LD DE,$40D2
  CALL PRINTMSG
  LD BC,$0000             ; Prepare the delay counters for the following loop;
  LD D,$06                ; the counter in C will also determine the INK
                          ; colours to use for the "Game Over" message
; The following loop makes the "Game Over" message glisten for about 1.57s.
GAMEOVER_3:
  DJNZ GAMEOVER_3         ; Delay for about a millisecond
  LD A,C                  ; Change the INK colour of the "G" in "Game" at
  AND $07                 ; (6,10)
  OR $40
  LD ($58CA),A
  INC A                   ; Change the INK colour of the "a" in "Game" at
  AND $07                 ; (6,11)
  OR $40
  LD ($58CB),A
  INC A                   ; Change the INK colour of the "m" in "Game" at
  AND $07                 ; (6,12)
  OR $40
  LD ($58CC),A
  INC A                   ; Change the INK colour of the "e" in "Game" at
  AND $07                 ; (6,13)
  OR $40
  LD ($58CD),A
  INC A                   ; Change the INK colour of the "O" in "Over" at
  AND $07                 ; (6,18)
  OR $40
  LD ($58D2),A
  INC A                   ; Change the INK colour of the "v" in "Over" at
  AND $07                 ; (6,19)
  OR $40
  LD ($58D3),A
  INC A                   ; Change the INK colour of the "e" in "Over" at
  AND $07                 ; (6,20)
  OR $40
  LD ($58D4),A
  INC A                   ; Change the INK colour of the "r" in "Over" at
  AND $07                 ; (6,21)
  OR $40
  LD ($58D5),A
  DEC C                   ; Decrement the counter in C
  JR NZ,GAMEOVER_3        ; Jump back unless it's zero
  DEC D                   ; Decrement the counter in D (initially 6)
  JR NZ,GAMEOVER_3        ; Jump back unless it's zero
  JP TITLESCREEN          ; Display the title screen and play the theme tune

; Draw the current room to the screen buffer at 7000
;
; Used by the routine at INITROOM.
DRAWROOM:
  CALL ROOMATTRS          ; Fill the buffer at 24064 with attribute bytes for
                          ; the current room
  LD IX,$5E00             ; Point IX at the first byte of the attribute buffer
                          ; at 24064
  LD A,$70                ; Set the operand of the 'LD D,n' instruction at
  LD (BUFMSB+1),A         ; BUFMSB (below) to $70
  CALL DRAWROOM_0         ; Draw the tiles for the top half of the room to the
                          ; screen buffer at 28672
  LD IX,$5F00             ; Point IX at the 256th byte of the attribute buffer
                          ; at 24064 in preparation for drawing the bottom half
                          ; of the room; this instruction is redundant, since
                          ; IX already holds 5F00
  LD A,$78                ; Set the operand of the 'LD D,n' instruction at
  LD (BUFMSB+1),A         ; BUFMSB (below) to $78
DRAWROOM_0:
  LD C,$00                ; C will count 256 tiles
; The following loop draws 256 tiles (for either the top half or the bottom
; half of the room) to the screen buffer at 28672.
DRAWROOM_1:
  LD E,C                  ; E holds the LSB of the screen buffer address
  LD A,(IX+$00)           ; Pick up an attribute byte from the buffer at 24064;
                          ; this identifies the type of tile (background,
                          ; floor, wall, nasty, ramp or conveyor) to be drawn
  LD HL,BACKGROUND        ; Move HL through the attribute bytes and graphic
  LD BC,$0036             ; data of the background, floor, wall, nasty, ramp
  CPIR                    ; and conveyor tiles starting at BACKGROUND until we
                          ; find a byte that matches the attribute byte of the
                          ; tile to be drawn; note that if a graphic data byte
                          ; matches the attribute byte being searched for, the
                          ; CPIR instruction can exit early, which is a bug
  LD C,E                  ; Restore the value of the tile counter in C
  LD B,$08                ; There are eight bytes in the tile
BUFMSB:
  LD D,$00                ; This instruction is set to either 'LD D,$70' or 'LD
                          ; D,$78' above; now DE holds the appropriate address
                          ; in the screen buffer at 28672
DRAWROOM_2:
  LD A,(HL)               ; Copy the tile graphic data to the screen buffer at
  LD (DE),A               ; 28672
  INC HL
  INC D
  DJNZ DRAWROOM_2
  INC IX                  ; Move IX along to the next byte in the attribute
                          ; buffer
  INC C                   ; Have we drawn 256 tiles yet?
  JP NZ,DRAWROOM_1        ; If not, jump back to draw the next one
  RET

; Fill the buffer at 5E00 with attribute bytes for the current room
;
; Used by the routine at DRAWROOM. Fills the buffer at 24064 with attribute
; bytes for the background, floor, wall, nasty, conveyor and ramp tiles in the
; current room.
ROOMATTRS:
  LD HL,ROOMLAYOUT        ; Point HL at the first room layout byte at
                          ; ROOMLAYOUT
  LD IX,$5E00             ; Point IX at the first byte of the attribute buffer
                          ; at 24064
; The following loop copies the attribute bytes for the background, floor, wall
; and nasty tiles into the buffer at 24064.
ROOMATTRS_0:
  LD A,(HL)               ; Pick up a room layout byte
  RLCA                    ; Move bits 6 and 7 into bits 0 and 1
  RLCA
  CALL ROOMATTR           ; Copy the attribute byte for this tile into the
                          ; buffer at 24064
  LD A,(HL)               ; Pick up the room layout byte again
  RRCA                    ; Move bits 4 and 5 into bits 0 and 1
  RRCA
  RRCA
  RRCA
  CALL ROOMATTR           ; Copy the attribute byte for this tile into the
                          ; buffer at 24064
  LD A,(HL)               ; Pick up the room layout byte again
  RRCA                    ; Move bits 2 and 3 into bits 0 and 1
  RRCA
  CALL ROOMATTR           ; Copy the attribute byte for this tile into the
                          ; buffer at 24064
  LD A,(HL)               ; Pick up the room layout byte again; this time the
                          ; required bit-pair is already in bits 0 and 1
  CALL ROOMATTR           ; Copy the attribute byte for this tile into the
                          ; buffer at 24064
  INC HL                  ; Point HL at the next room layout byte
  LD A,L                  ; Have we processed all 128 room layout bytes yet?
  AND $80
  JR Z,ROOMATTRS_0        ; If not, jump back to process the next one
; Next consider the conveyor tiles (if any).
  LD A,(CONVLEN)          ; Pick up the length of the conveyor from CONVLEN
  OR A                    ; Is there a conveyor in the room?
  JR Z,ROOMATTRS_2        ; Jump if not
  LD HL,(CONVLOC)         ; Pick up the address of the conveyor's location in
                          ; the attribute buffer at 24064 from CONVLOC
  LD B,A                  ; B will count the conveyor tiles
  LD A,(CONVEYOR)         ; Pick up the attribute byte for the conveyor tile
                          ; from CONVEYOR
ROOMATTRS_1:
  LD (HL),A               ; Copy the attribute bytes for the conveyor tiles
  INC HL                  ; into the buffer at 24064
  DJNZ ROOMATTRS_1
; And finally consider the ramp tiles (if any).
ROOMATTRS_2:
  LD A,(RAMPLEN)          ; Pick up the length of the ramp from RAMPLEN
  OR A                    ; Is there a ramp in the room?
  RET Z                   ; Return if not
  LD HL,(RAMPLOC)         ; Pick up the address of the ramp's location in the
                          ; attribute buffer at 24064 from RAMPLOC
  LD A,(RAMPDIR)          ; Pick up the ramp direction from RAMPDIR; A=0 (ramp
  AND $01                 ; goes up to the left) or 1 (ramp goes up to the
                          ; right)
  RLCA                    ; Now DE=-33 (ramp goes up to the left) or -31 (ramp
  ADD A,$DF               ; goes up to the right)
  LD E,A
  LD D,$FF
  LD A,(RAMPLEN)          ; Pick up the length of the ramp from RAMPLEN
  LD B,A                  ; B will count the ramp tiles
  LD A,(RAMP)             ; Pick up the attribute byte for the ramp tile from
                          ; RAMP
ROOMATTRS_3:
  LD (HL),A               ; Copy the attribute bytes for the ramp tiles into
  ADD HL,DE               ; the buffer at 24064
  DJNZ ROOMATTRS_3
  RET

; Copy a room attribute byte into the buffer at 5E00
;
; Used by the routine at ROOMATTRS. On entry, A holds a room layout byte,
; rotated such that the bit-pair corresponding to the tile of interest is in
; bits 0 and 1.
;
; A Room layout byte (rotated)
; IX Attribute buffer address (5E00-5FFF)
ROOMATTR:
  AND $03                 ; Keep only bits 0 and 1; A=0 (background), 1
                          ; (floor), 2 (wall) or 3 (nasty)
  LD C,A                  ; Multiply by 9 and add 0xA0; now A=0xA0
  RLCA                    ; (background), 0xA9 (floor), 0xB2 (wall) or 0xBB
  RLCA                    ; (nasty)
  RLCA
  ADD A,C
  ADD A,$A0
  LD E,A                  ; Point DE at the attribute byte for the background,
  LD D,ROOMLAYOUT/256     ; floor, wall or nasty tile (see BACKGROUND)
  LD A,(DE)               ; Copy the attribute byte into the buffer at 24064
  LD (IX+$00),A
  INC IX                  ; Move IX along to the next byte in the attribute
                          ; buffer
  RET

; Move Willy (1)
;
; Used by the routine at MAINLOOP. This routine deals with Willy if he's
; jumping or falling.
MOVEWILLY:
  LD A,(ROPE)             ; Pick up the rope status indicator from ROPE
  DEC A                   ; Is Willy on a rope?
  BIT 7,A
  JP Z,MOVEWILLY2         ; Jump if so
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  CP $01                  ; Is Willy jumping?
  JR NZ,MOVEWILLY_3       ; Jump if not
; Willy is currently jumping.
  LD A,(JUMPING)          ; Pick up the jumping animation counter (0-17) from
                          ; JUMPING
  AND $FE                 ; Discard bit 0
  SUB $08                 ; Now -8<=A<=8 (and A is even)
  LD HL,PIXEL_Y           ; Adjust Willy's pixel y-coordinate at PIXEL_Y
  ADD A,(HL)              ; depending on where Willy is in the jump
  LD (HL),A
  CP $F0                  ; Is the new value negative (above the top of the
                          ; screen)?
  RET NC                  ; Return if so
  CALL MOVEWILLY_8        ; Adjust Willy's attribute buffer location at
                          ; LOCATION depending on his pixel y-coordinate
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current room from WALL
  CP (HL)                 ; Is the top-left cell of Willy's sprite overlapping
                          ; a wall tile?
  JP Z,MOVEWILLY_11       ; Jump if so
  INC HL                  ; Point HL at the top-right cell occupied by Willy's
                          ; sprite
  CP (HL)                 ; Is the top-right cell of Willy's sprite overlapping
                          ; a wall tile?
  JP Z,MOVEWILLY_11       ; Jump if so
  LD A,(JUMPING)          ; Increment the jumping animation counter at JUMPING
  INC A
  LD (JUMPING),A
  SUB $08                 ; A=J-8, where J (1-18) is the new value of the
                          ; jumping animation counter
  JP P,MOVEWILLY_0        ; Jump if J>=8
  NEG                     ; A=8-J (1<=J<=7, 1<=A<=7)
MOVEWILLY_0:
  INC A                   ; A=1+ABS(J-8)
  RLCA                    ; D=8*(1+ABS(J-8)); this value determines the pitch
  RLCA                    ; of the jumping sound effect (rising as Willy rises,
  RLCA                    ; falling as Willy falls)
  LD D,A
  LD C,$20                ; This value determines the duration of the jumping
                          ; sound effect
  LD A,(BORDER)           ; Pick up the border colour for the current room from
                          ; BORDER
MOVEWILLY_1:
  OUT ($FE),A             ; Make a jumping sound effect
  XOR $18
  LD B,D
MOVEWILLY_2:
  DJNZ MOVEWILLY_2
  DEC C
  JR NZ,MOVEWILLY_1
  LD A,(JUMPING)          ; Pick up the jumping animation counter (1-18) from
                          ; JUMPING
  CP $12                  ; Has Willy reached the end of the jump?
  JP Z,MOVEWILLY_9        ; Jump if so
  CP $10                  ; Is the jumping animation counter now 16?
  JR Z,MOVEWILLY_3        ; Jump if so
  CP $0D                  ; Is the jumping animation counter now 13?
  JP NZ,MOVEWILLY3        ; Jump if not
; If we get here, then Willy is standing on the floor or a ramp, or he's
; falling, or his jumping animation counter is 13 (at which point Willy is on
; his way down and is exactly two cell-heights above where he started the jump)
; or 16 (at which point Willy is on his way down and is exactly one cell-height
; above where he started the jump).
MOVEWILLY_3:
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate from PIXEL_Y
  AND $0E                 ; Is Willy either on a ramp, or occupying only four
                          ; cells?
  JR NZ,MOVEWILLY_4       ; Jump if not
  LD HL,(LOCATION)        ; Pick up Willy's attribute buffer coordinates from
                          ; LOCATION
  LD DE,$0040             ; Point HL at the left-hand cell below Willy's sprite
  ADD HL,DE
  LD A,(NASTY)            ; Pick up the attribute byte of the nasty tile for
                          ; the current room from NASTY
  CP (HL)                 ; Does the left-hand cell below Willy's sprite
                          ; contain a nasty?
  JR Z,MOVEWILLY_4        ; Jump if so
  INC HL                  ; Point HL at the right-hand cell below Willy's
                          ; sprite
  LD A,(NASTY)            ; Pick up the attribute byte of the nasty tile for
                          ; the current room from NASTY (again, redundantly)
  CP (HL)                 ; Does the right-hand cell below Willy's sprite
                          ; contain a nasty?
  JR Z,MOVEWILLY_4        ; Jump if so
  LD A,(BACKGROUND)       ; Pick up the attribute byte of the background tile
                          ; for the current room from BACKGROUND
  CP (HL)                 ; Set the zero flag if the right-hand cell below
                          ; Willy's sprite is empty
  DEC HL                  ; Point HL at the left-hand cell below Willy's sprite
  JP NZ,MOVEWILLY2        ; Jump if the right-hand cell below Willy's sprite is
                          ; not empty
  CP (HL)                 ; Is the left-hand cell below Willy's sprite empty?
  JP NZ,MOVEWILLY2        ; Jump if not
MOVEWILLY_4:
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  CP $01                  ; Is Willy jumping?
  JP Z,MOVEWILLY3         ; Jump if so
; If we get here, then Willy is either in the process of falling or just about
; to start falling.
  LD HL,DMFLAGS           ; Reset bit 1 at DMFLAGS: Willy is not moving left or
  RES 1,(HL)              ; right
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  OR A                    ; Is Willy already falling?
  JP Z,MOVEWILLY_10       ; Jump if not
  INC A                   ; Increment the airborne status indicator
  CP $10                  ; Is it 16 now?
  JR NZ,MOVEWILLY_5       ; Jump if not
  LD A,$0C                ; Decrease the airborne status indicator from 0x10 to
                          ; 0x0C
MOVEWILLY_5:
  LD (AIRBORNE),A         ; Update the airborne status indicator at AIRBORNE
  RLCA                    ; D=16*A; this value determines the pitch of the
  RLCA                    ; falling sound effect
  RLCA
  RLCA
  LD D,A
  LD C,$20                ; This value determines the duration of the falling
                          ; sound effect
  LD A,(BORDER)           ; Pick up the border colour for the current room from
                          ; BORDER
MOVEWILLY_6:
  OUT ($FE),A             ; Make a falling sound effect
  XOR $18
  LD B,D
MOVEWILLY_7:
  DJNZ MOVEWILLY_7
  DEC C
  JR NZ,MOVEWILLY_6
  LD A,(PIXEL_Y)          ; Add 8 to Willy's pixel y-coordinate at PIXEL_Y;
  ADD A,$08               ; this moves Willy downwards by 4 pixels
  LD (PIXEL_Y),A
; This entry point is used by the routine at DRAWTHINGS to update Willy's
; attribute buffer location when he's on a rope.
MOVEWILLY_8:
  AND $F0                 ; L=16*Y, where Y is Willy's screen y-coordinate
  LD L,A                  ; (0-14)
  XOR A                   ; Clear A and the carry flag
  RL L                    ; Now L=32*(Y-8*INT(Y/8)), and the carry flag is set
                          ; if Willy is in the lower half of the room (Y>=8)
  ADC A,$5C               ; H=0x5C or 0x5D (MSB of the address of Willy's
  LD H,A                  ; location in the attribute buffer)
  LD A,(LOCATION)         ; Pick up Willy's screen x-coordinate (0-30) from
  AND $1F                 ; bits 0-4 at LOCATION
  OR L                    ; Now L holds the LSB of Willy's attribute buffer
  LD L,A                  ; address
  LD (LOCATION),HL        ; Store Willy's updated attribute buffer location at
                          ; LOCATION
  RET
; Willy has just finished a jump.
MOVEWILLY_9:
  LD A,$06                ; Set the airborne status indicator at AIRBORNE to
  LD (AIRBORNE),A         ; 0x06: Willy will continue to fall unless he's
                          ; landed on a wall or floor block
  RET
; Willy has just started falling.
MOVEWILLY_10:
  LD A,$02                ; Set the airborne status indicator at AIRBORNE to
  LD (AIRBORNE),A         ; 0x02
  RET
; The top-left or top-right cell of Willy's sprite is overlapping a wall tile.
MOVEWILLY_11:
  LD A,(PIXEL_Y)          ; Adjust Willy's pixel y-coordinate at PIXEL_Y so
  ADD A,$10               ; that the top row of cells of his sprite is just
  AND $F0                 ; below the wall tile
  LD (PIXEL_Y),A
  CALL MOVEWILLY_8        ; Adjust Willy's attribute buffer location at
                          ; LOCATION to account for this new pixel y-coordinate
  LD A,$02                ; Set the airborne status indicator at AIRBORNE to
  LD (AIRBORNE),A         ; 0x02: Willy has started falling
  LD HL,DMFLAGS           ; Reset bit 1 at DMFLAGS: Willy is not moving left or
  RES 1,(HL)              ; right
  RET

; Move Willy (2)
;
; Used by the routine at MOVEWILLY. This routine checks the keyboard and
; joystick.
;
; HL Attribute buffer address of the left-hand cell below Willy's sprite (if
;    Willy is not on a rope)
MOVEWILLY2:
  LD E,$FF                ; Initialise E to 0xFF (all bits set); it will be
                          ; used to hold keyboard and joystick readings
  LD A,(ROPE)             ; Pick up the rope status indicator from ROPE
  DEC A                   ; Is Willy on a rope?
  BIT 7,A
  JR Z,MOVEWILLY2_1       ; Jump if so
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  CP $0C                  ; Has Willy just landed after falling from too great
                          ; a height?
  JP NC,KILLWILLY_0       ; If so, kill him
  XOR A                   ; Reset the airborne status indicator at AIRBORNE
  LD (AIRBORNE),A         ; (Willy has landed safely)
  LD A,(CONVEYOR)         ; Pick up the attribute byte of the conveyor tile for
                          ; the current room from CONVEYOR
  CP (HL)                 ; Does the attribute byte of the left-hand cell below
                          ; Willy's sprite match that of the conveyor tile?
  JR Z,MOVEWILLY2_0       ; Jump if so
  INC HL                  ; Point HL at the right-hand cell below Willy's
                          ; sprite
  CP (HL)                 ; Does the attribute byte of the right-hand cell
                          ; below Willy's sprite match that of the conveyor
                          ; tile?
  JR NZ,MOVEWILLY2_1      ; Jump if not
MOVEWILLY2_0:
  LD A,(CONVDIR)          ; Pick up the direction byte of the conveyor
                          ; definition from CONVDIR (0=left, 1=right)
  SUB $03                 ; Now E=0xFD (bit 1 reset) if the conveyor is moving
  LD E,A                  ; left, or 0xFE (bit 0 reset) if it's moving right
MOVEWILLY2_1:
  LD BC,$DFFE             ; Read keys P-O-I-U-Y (right, left, right, left,
  IN A,(C)                ; right) into bits 0-4 of A
  AND $1F                 ; Set bit 5 and reset bits 6 and 7
  OR $20
  AND E                   ; Reset bit 0 if the conveyor is moving right, or bit
                          ; 1 if it's moving left
  LD E,A                  ; Save the result in E
  LD A,(MODE)             ; Pick up the game mode indicator (0, 1 or 2) from
                          ; MODE
  AND $02                 ; Now A=1 if Willy is running to the toilet, 0
  RRCA                    ; otherwise
  XOR E                   ; Flip bit 0 of E if Willy is running to the toilet,
  LD E,A                  ; forcing him to move right (unless he's jumped onto
                          ; the bed, in which case bit 0 of E is now set,
                          ; meaning that the conveyor does not move him, and
                          ; the 'P' key has no effect; this is a bug)
  LD BC,$FBFE             ; Read keys Q-W-E-R-T (left, right, left, right,
  IN A,(C)                ; left) into bits 0-4 of A
  AND $1F                 ; Keep only bits 0-4, shift them into bits 1-5, and
  RLC A                   ; set bit 0
  OR $01
  AND E                   ; Merge this keyboard reading into bits 1-5 of E
  LD E,A
  LD B,$E7                ; Read keys 1-2-3-4-5 ('5' is left) and 0-9-8-7-6
  IN A,(C)                ; (jump, nothing, right, right, left) into bits 0-4
                          ; of A
  RRCA                    ; Rotate the result right and set bits 0-2 and 4-7;
  OR $F7                  ; this ignores every key except '5' and '6' (left)
  AND E                   ; Merge this reading of the '5' and '6' keys into bit
  LD E,A                  ; 3 of E
  LD B,$EF                ; Read keys 0-9-8-7-6 (jump, nothing, right, right,
  IN A,(C)                ; left) into bits 0-4 of A
  OR $FB                  ; Set bits 0, 1 and 3-7; this ignores every key
                          ; except '8' (right)
  AND E                   ; Merge this reading of the '8' key into bit 2 of E
  LD E,A
  IN A,(C)                ; Read keys 0-9-8-7-6 (jump, nothing, right, right,
                          ; left) into bits 0-4 of A
  RRCA                    ; Rotate the result right and set bits 0, 1 and 3-7;
  OR $FB                  ; this ignores every key except '7' (right)
  AND E                   ; Merge this reading of the '7' key into bit 2 of E
  LD E,A
  LD A,(JOYSTICK)         ; Collect the Kempston joystick indicator from
                          ; JOYSTICK
  OR A                    ; Is the joystick connected?
  JR Z,MOVEWILLY2_2       ; Jump if not
  LD BC,$001F             ; Collect input from the joystick
  IN A,(C)
  AND $03                 ; Keep only bits 0 (right) and 1 (left) and flip them
  CPL
  AND E                   ; Merge this reading of the joystick right and left
  LD E,A                  ; buttons into bits 0 and 1 of E
; At this point, bits 0-5 in E indicate the direction in which Willy is being
; moved or trying to move. If bit 0, 2 or 4 is reset, Willy is being moved or
; trying to move right; if bit 1, 3 or 5 is reset, Willy is being moved or
; trying to move left.
MOVEWILLY2_2:
  LD C,$00                ; Initialise C to 0 (no movement)
  LD A,E                  ; Copy the movement bits into A
  AND $2A                 ; Keep only bits 1, 3 and 5 (the 'left' bits)
  CP $2A                  ; Are any of these bits reset?
  JR Z,MOVEWILLY2_3       ; Jump if not
  LD C,$04                ; Set bit 2 of C: Willy is moving left
  XOR A                   ; Reset the inactivity timer at INACTIVE
  LD (INACTIVE),A
MOVEWILLY2_3:
  LD A,E                  ; Copy the movement bits into A
  AND $15                 ; Keep only bits 0, 2 and 4 (the 'right' bits)
  CP $15                  ; Are any of these bits reset?
  JR Z,MOVEWILLY2_4       ; Jump if not
  SET 3,C                 ; Set bit 3 of C: Willy is moving right
  XOR A                   ; Reset the inactivity timer at INACTIVE
  LD (INACTIVE),A
MOVEWILLY2_4:
  LD A,(DMFLAGS)          ; Pick up Willy's direction and movement flags from
                          ; DMFLAGS
  ADD A,C                 ; Point HL at the entry in the left-right movement
  LD C,A                  ; table at LRMOVEMENT that corresponds to the
  LD B,$00                ; direction Willy is facing, and the direction in
  LD HL,LRMOVEMENT        ; which he is being moved or trying to move
  ADD HL,BC
  LD A,(HL)               ; Update Willy's direction and movement flags at
  LD (DMFLAGS),A          ; DMFLAGS with the entry from the left-right movement
                          ; table
; That is left-right movement taken care of. Now check the jump keys.
  LD BC,$7EFE             ; Read keys SHIFT-Z-X-C-V and B-N-M-SS-SPACE
  IN A,(C)
  AND $1F                 ; Are any of these keys being pressed?
  CP $1F
  JR NZ,MOVEWILLY2_5      ; Jump if so
  LD B,$EF                ; Read keys 6-7-8-9-0
  IN A,(C)
  BIT 0,A                 ; Is '0' being pressed?
  JR Z,MOVEWILLY2_5       ; Jump if so
  LD A,(JOYSTICK)         ; Collect the Kempston joystick indicator from
                          ; JOYSTICK
  OR A                    ; Is the joystick connected?
  JR Z,MOVEWILLY3         ; Jump if not
  LD BC,$001F             ; Collect input from the joystick
  IN A,(C)
  BIT 4,A                 ; Is the fire button being pressed?
  JR Z,MOVEWILLY3         ; Jump if not
; A jump key or the fire button is being pressed. Time to make Willy jump.
MOVEWILLY2_5:
  LD A,(MODE)             ; Pick up the game mode indicator from MODE
  BIT 1,A                 ; Is Willy running to the toilet?
  JR NZ,MOVEWILLY3        ; Jump if so
  XOR A                   ; Initialise the jumping animation counter at JUMPING
  LD (JUMPING),A          ; to 0
  LD (INACTIVE),A         ; Reset the inactivity timer at INACTIVE
  INC A                   ; Set the airborne status indicator at AIRBORNE to
  LD (AIRBORNE),A         ; 0x01: Willy is jumping
  LD A,(ROPE)             ; Pick up the rope status indicator from ROPE
  DEC A                   ; Is Willy on a rope?
  BIT 7,A
  JR NZ,MOVEWILLY3        ; Jump if not
  LD A,$F0                ; Set the rope status indicator at ROPE to 0xF0
  LD (ROPE),A
  LD A,(PIXEL_Y)          ; Round down Willy's pixel y-coordinate at PIXEL_Y to
  AND $F0                 ; the nearest multiple of 16; this might move him
  LD (PIXEL_Y),A          ; upwards a little, but ensures that his actual pixel
                          ; y-coordinate is a multiple of 8 (making his sprite
                          ; cell-aligned) before he begins the jump off the
                          ; rope
  LD HL,DMFLAGS           ; Set bit 1 at DMFLAGS: during this jump off the
  SET 1,(HL)              ; rope, Willy will move in the direction he's facing
  RET

; Move Willy (3)
;
; Used by the routines at MOVEWILLY and MOVEWILLY2. This routine moves Willy
; left or right if necessary.
MOVEWILLY3:
  LD A,(DMFLAGS)          ; Pick up Willy's direction and movement flags from
                          ; DMFLAGS
  AND $02                 ; Is Willy moving?
  RET Z                   ; Return if not
  LD A,(ROPE)             ; Pick up the rope status indicator from ROPE
  DEC A                   ; Is Willy on a rope?
  BIT 7,A
  RET Z                   ; Return if so (Willy's movement along a rope is
                          ; handled at DRAWTHINGS_19)
  LD A,(DMFLAGS)          ; Pick up Willy's direction and movement flags from
                          ; DMFLAGS
  AND $01                 ; Is Willy facing right?
  JP Z,MOVEWILLY3_3       ; Jump if so
; Willy is moving left.
  LD A,(FRAME)            ; Pick up Willy's animation frame from FRAME
  OR A                    ; Is it 0?
  JR Z,MOVEWILLY3_0       ; If so, jump to move Willy's sprite left across a
                          ; cell boundary
  DEC A                   ; Decrement Willy's animation frame at FRAME
  LD (FRAME),A
  RET
; Willy's sprite is moving left across a cell boundary. In the comments that
; follow, (x,y) refers to the coordinates of the top-left cell currently
; occupied by Willy's sprite.
MOVEWILLY3_0:
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  LD BC,$0000             ; Prepare BC for later addition
  CP $00                  ; Is Willy jumping?
  JR NZ,MOVEWILLY3_1      ; Jump if so
  LD HL,(LOCATION)        ; Collect Willy's attribute buffer coordinates from
                          ; LOCATION
  LD BC,$0000             ; Prepare BC for later addition (again, redundantly)
  LD A,(RAMPDIR)          ; Pick up the direction byte of the ramp definition
                          ; for the current room from RAMPDIR
  DEC A                   ; Now A=0x1F if the ramp goes up to the left, or 0x41
  OR $A1                  ; if it goes up to the right
  XOR $E0
  LD E,A                  ; Point HL at the cell at (x-1,y+1) if the ramp goes
  LD D,$00                ; up to the left, or at the cell at (x+1,y+2) if the
  ADD HL,DE               ; ramp goes up to the right
  LD A,(RAMP)             ; Pick up the attribute byte of the ramp tile for the
                          ; current room from RAMP
  CP (HL)                 ; Is there a ramp tile in the cell pointed to by HL?
  JR NZ,MOVEWILLY3_1      ; Jump if not
  LD BC,$0020             ; Prepare BC for later addition
  LD A,(RAMPDIR)          ; Pick up the direction byte of the ramp definition
                          ; for the current room from RAMPDIR
  OR A                    ; Does the ramp go up to the right?
  JR NZ,MOVEWILLY3_1      ; Jump if so
  LD BC,$FFE0             ; BC=-32 (the ramp goes up to the left)
MOVEWILLY3_1:
  LD HL,(LOCATION)        ; Collect Willy's attribute buffer coordinates from
                          ; LOCATION
  LD A,L                  ; Is Willy's screen x-coordinate 0 (on the far left)?
  AND $1F
  JP Z,ROOMLEFT           ; If so, move Willy into the room to the left
  ADD HL,BC               ; Point HL at the cell at (x-1,y+1), or at the cell
  DEC HL                  ; at (x-1,y) if Willy is on or about to step onto a
  LD DE,$0020             ; ramp that goes up to the left, or at the cell at
  ADD HL,DE               ; (x-1,y+2) if Willy is walking down a ramp
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current room from WALL
  CP (HL)                 ; Is there a wall tile in the cell pointed to by HL?
  RET Z                   ; Return if so without moving Willy (his path is
                          ; blocked)
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate (Y) from PIXEL_Y
  SRA C                   ; Now B=Y (if Willy is neither on nor about to step
  ADD A,C                 ; onto a ramp), or Y+16 (if Willy is walking down a
  LD B,A                  ; ramp), or Y-16 (if Willy is on or about to step
                          ; onto a ramp that goes up to the left); this will be
                          ; Willy's new pixel y-coordinate
  AND $0F                 ; Is Willy jumping (left)?
  JR Z,MOVEWILLY3_2       ; Jump if not
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current room from WALL
  ADD HL,DE               ; Point HL at the cell at (x-1,y+2)
  CP (HL)                 ; Is there a wall tile there?
  RET Z                   ; Return if so without moving Willy (his path is
                          ; blocked)
  OR A                    ; Point HL at the cell at (x-1,y+1)
  SBC HL,DE
MOVEWILLY3_2:
  OR A                    ; Point HL at the cell at (x-1,y), or at the cell at
  SBC HL,DE               ; (x-1,y-1) if Willy is on or about to step onto a
                          ; ramp that goes up to the left, or at the cell at
                          ; (x-1,y+1) if Willy is walking down a ramp
  LD (LOCATION),HL        ; Save Willy's new attribute buffer coordinates (in
                          ; HL) at LOCATION
  LD A,B                  ; Save Willy's new pixel y-coordinate at PIXEL_Y
  LD (PIXEL_Y),A
  LD A,$03                ; Change Willy's animation frame at FRAME from 0 to 3
  LD (FRAME),A
  RET
; Willy is moving right.
MOVEWILLY3_3:
  LD A,(FRAME)            ; Pick up Willy's animation frame from FRAME
  CP $03                  ; Is it 3?
  JR Z,MOVEWILLY3_4       ; If so, jump to move Willy's sprite right across a
                          ; cell boundary
  INC A                   ; Increment Willy's animation frame at FRAME
  LD (FRAME),A
  RET
; Willy's sprite is moving right across a cell boundary. In the comments that
; follow, (x,y) refers to the coordinates of the top-left cell currently
; occupied by Willy's sprite.
MOVEWILLY3_4:
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  LD BC,$0000             ; Prepare BC for later addition
  OR A                    ; Is Willy jumping?
  JR NZ,MOVEWILLY3_5      ; Jump if so
  LD HL,(LOCATION)        ; Collect Willy's attribute buffer coordinates from
                          ; LOCATION
  LD A,(RAMPDIR)          ; Pick up the direction byte of the ramp definition
                          ; for the current room from RAMPDIR
  DEC A                   ; Now A=0x40 if the ramp goes up to the left, or 0x22
  OR $9D                  ; if it goes up to the right
  XOR $BF
  LD E,A                  ; Point HL at the cell at (x,y+2) if the ramp goes up
  LD D,$00                ; to the left, or at the cell at (x+2,y+1) if the
  ADD HL,DE               ; ramp goes up to the right
  LD A,(RAMP)             ; Pick up the attribute byte of the ramp tile for the
                          ; current room from RAMP
  CP (HL)                 ; Is there a ramp tile in the cell pointed to by HL?
  JR NZ,MOVEWILLY3_5      ; Jump if not
  LD BC,$0020             ; Prepare BC for later addition
  LD A,(RAMPDIR)          ; Pick up the direction byte of the ramp definition
                          ; for the current room from RAMPDIR
  OR A                    ; Does the ramp go up to the left?
  JR Z,MOVEWILLY3_5       ; Jump if so
  LD BC,$FFE0             ; BC=-32 (the ramp goes up to the right)
MOVEWILLY3_5:
  LD HL,(LOCATION)        ; Collect Willy's attribute buffer coordinates from
                          ; LOCATION
  ADD HL,BC               ; Point HL at the cell at (x+2,y), or at the cell at
  INC HL                  ; (x+2,y+1) if Willy is walking down a ramp, or at
  INC HL                  ; the cell at (x+2,y-1) if Willy is on or about to
                          ; step onto a ramp that goes up to the right
  LD A,L                  ; Is Willy's screen x-coordinate 30 (on the far
  AND $1F                 ; right)?
  JP Z,ROOMRIGHT          ; If so, move Willy into the room on the right
  LD DE,$0020             ; Prepare DE for addition
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current room from WALL
  ADD HL,DE               ; Point HL at the cell at (x+2,y+1), or at the cell
                          ; at (x+2,y+2) if Willy is walking down a ramp, or at
                          ; the cell at (x+2,y) if Willy is on or about to step
                          ; onto a ramp that goes up to the right
  CP (HL)                 ; Is there a wall tile in the cell pointed to by HL?
  RET Z                   ; Return if so without moving Willy (his path is
                          ; blocked)
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate (Y) from PIXEL_Y
  SRA C                   ; Now B=Y (if Willy is neither on nor about to step
  ADD A,C                 ; onto a ramp), or Y+16 (if Willy is walking down a
  LD B,A                  ; ramp), or Y-16 (if Willy is on or about to step
                          ; onto a ramp that goes up to the right); this will
                          ; be Willy's new pixel y-coordinate
  AND $0F                 ; Is Willy jumping (right)?
  JR Z,MOVEWILLY3_6       ; Jump if not
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current room from WALL
  ADD HL,DE               ; Point HL at the cell at (x+2,y+2)
  CP (HL)                 ; Is there a wall tile there?
  RET Z                   ; Return if so without moving Willy (his path is
                          ; blocked)
  OR A                    ; Point HL at the cell at (x+2,y+1)
  SBC HL,DE
MOVEWILLY3_6:
  LD A,(WALL)             ; Pick up the attribute byte of the wall tile for the
                          ; current room from WALL
  OR A                    ; Point HL at the cell at (x+2,y), or at the cell at
  SBC HL,DE               ; (x+2,y+1) if Willy is walking down a ramp, or at
                          ; the cell at (x+2,y-1) if Willy is on or about to
                          ; step onto a ramp that goes up to the right
  CP (HL)                 ; Is there a wall tile in the cell pointed to by HL?
  RET Z                   ; Return if so without moving Willy (his path is
                          ; blocked)
  DEC HL                  ; Point HL at the cell at (x+1,y), or at the cell at
                          ; (x+1,y+1) if Willy is walking down a ramp, or at
                          ; the cell at (x+1,y-1) if Willy is on or about to
                          ; step onto a ramp that goes up to the right
  LD (LOCATION),HL        ; Save Willy's new attribute buffer coordinates (in
                          ; HL) at LOCATION
  XOR A                   ; Change Willy's animation frame at FRAME from 3 to 0
  LD (FRAME),A
  LD A,B                  ; Save Willy's new pixel y-coordinate at PIXEL_Y
  LD (PIXEL_Y),A
  RET

; Kill Willy
;
; Used by the routine at WILLYATTR when Willy hits a nasty.
KILLWILLY:
  POP HL                  ; Drop the return address from the stack
; This entry point is used by the routines at MOVEWILLY2 (when Willy lands
; after falling from too great a height), DRAWTHINGS (when an arrow or guardian
; hits Willy) and BEDANDBATH (when Willy gets too close to Maria).
KILLWILLY_0:
  POP HL                  ; Drop the return address from the stack
  LD A,$FF                ; Set the airborne status indicator at AIRBORNE to
  LD (AIRBORNE),A         ; 0xFF (meaning Willy has had a fatal accident)
  JP MAINLOOP_0           ; Jump back into the main loop

; Move the rope and guardians in the current room
;
; Used by the routine at MAINLOOP.
MOVETHINGS:
  LD IX,ENTITYBUF         ; Point IX at the first byte of the first entity
                          ; buffer at ENTITYBUF
; The entity-moving loop begins here.
MOVETHINGS_0:
  LD A,(IX+$00)           ; Pick up the first byte of the current entity's
                          ; buffer
  CP $FF                  ; Have we already dealt with every entity?
  RET Z                   ; Return if so
  AND $03                 ; Keep only bits 0 and 1 (which determine the type of
                          ; entity)
  JP Z,MOVETHINGS_13      ; Jump to consider the next entity buffer if this one
                          ; belongs to an arrow or is unused
  CP $01                  ; Is this a horizontal guardian?
  JP Z,MOVETHINGS_5       ; Jump if so
  CP $02                  ; Is this a vertical guardian?
  JP Z,MOVETHINGS_9       ; Jump if so
; We are dealing with a rope.
  BIT 7,(IX+$00)          ; Is the rope currently swinging right to left?
  JR Z,MOVETHINGS_2       ; Jump if so
; The rope is swinging left to right.
  LD A,(IX+$01)           ; Pick up the animation frame index
  BIT 7,A                 ; Is the rope currently swinging away from the
                          ; centre?
  JR Z,MOVETHINGS_1       ; Jump if so
; The rope is swinging left to right, towards the centre (0x84<=A<=0xB6).
  SUB $02                 ; Subtract 2 from the animation frame index in A
  CP $94                  ; Is it still 0x94 or greater?
  JR NC,MOVETHINGS_4      ; If so, use it as the next animation frame index
  SUB $02                 ; Subtract 2 from the animation frame index again
  CP $80                  ; Is it 0x80 now?
  JR NZ,MOVETHINGS_4      ; If not, use it as the next animation frame index
  XOR A                   ; The rope has reached the centre, so the next
                          ; animation frame index is 0
  JR MOVETHINGS_4         ; Jump to set it
; The rope is swinging left to right, away from the centre (0x00<=A<=0x34).
MOVETHINGS_1:
  ADD A,$02               ; Add 2 to the animation frame index in A
  CP $12                  ; Is it now 0x12 or greater?
  JR NC,MOVETHINGS_4      ; If so, use it as the next animation frame index
  ADD A,$02               ; Add 2 to the animation frame index again
  JR MOVETHINGS_4         ; Use this value as the next animation frame index
; The rope is swinging right to left.
MOVETHINGS_2:
  LD A,(IX+$01)           ; Pick up the animation frame index
  BIT 7,A                 ; Is the rope currently swinging away from the
                          ; centre?
  JR NZ,MOVETHINGS_3      ; Jump if so
; The rope is swinging right to left, towards the centre (0x04<=A<=0x36).
  SUB $02                 ; Subtract 2 from the animation frame index in A
  CP $14                  ; Is it still 0x14 or greater?
  JR NC,MOVETHINGS_4      ; If so, use it as the next animation frame index
  SUB $02                 ; Subtract 2 from the animation frame index again
  OR A                    ; Is it 0 now?
  JR NZ,MOVETHINGS_4      ; If not, use it as the next animation frame index
  LD A,$80                ; The rope has reached the centre, so the next
                          ; animation frame index is 0x80
  JR MOVETHINGS_4         ; Jump to set it
; The rope is swinging right to left, away from the centre (0x80<=A<=0xB4).
MOVETHINGS_3:
  ADD A,$02               ; Add 2 to the animation frame index in A
  CP $92                  ; Is it now 0x92 or greater?
  JR NC,MOVETHINGS_4      ; If so, use it as the next animation frame index
  ADD A,$02               ; Add 2 to the animation frame index again
; Now A holds the rope's next animation frame index.
MOVETHINGS_4:
  LD (IX+$01),A           ; Update the animation frame index
  AND $7F                 ; Reset bit 7
  CP (IX+$07)             ; Does A match the eighth byte of the rope's buffer
                          ; (0x36)?
  JP NZ,MOVETHINGS_13     ; If not, jump to consider the next entity
  LD A,(IX+$00)           ; Flip bit 7 of the first byte of the rope's buffer:
  XOR $80                 ; the rope has just changed direction and will now
  LD (IX+$00),A           ; swing back towards the centre
  JP MOVETHINGS_13        ; Jump to consider the next entity
; We are dealing with a horizontal guardian.
MOVETHINGS_5:
  BIT 7,(IX+$00)          ; Is the guardian currently moving left to right?
  JR NZ,MOVETHINGS_7      ; Jump if so
; This guardian is moving right to left.
  LD A,(IX+$00)           ; Update the guardian's animation frame (in bits 5
  SUB $20                 ; and 6 of the first byte of its buffer)
  AND $7F
  LD (IX+$00),A
  CP $60                  ; Is it time to update the x-coordinate of the
                          ; guardian sprite?
  JR C,MOVETHINGS_13      ; If not, jump to consider the next entity
  LD A,(IX+$02)           ; Pick up the sprite's current screen x-coordinate
  AND $1F                 ; (0-31)
  CP (IX+$06)             ; Has the guardian reached the leftmost point of its
                          ; path?
  JR Z,MOVETHINGS_6       ; Jump if so
  DEC (IX+$02)            ; Decrement the sprite's x-coordinate
  JR MOVETHINGS_13        ; Jump to consider the next entity
MOVETHINGS_6:
  LD (IX+$00),$81         ; The guardian will now start moving left to right
  JR MOVETHINGS_13        ; Jump to consider the next entity
; This guardian is moving left to right.
MOVETHINGS_7:
  LD A,(IX+$00)           ; Update the guardian's animation frame (in bits 5
  ADD A,$20               ; and 6 of the first byte of its buffer)
  OR $80
  LD (IX+$00),A
  CP $A0                  ; Is it time to update the x-coordinate of the
                          ; guardian sprite?
  JR NC,MOVETHINGS_13     ; If not, jump to consider the next entity
  LD A,(IX+$02)           ; Pick up the sprite's current screen x-coordinate
  AND $1F                 ; (0-31)
  CP (IX+$07)             ; Has the guardian reached the rightmost point of its
                          ; path?
  JR Z,MOVETHINGS_8       ; Jump if so
  INC (IX+$02)            ; Increment the sprite's x-coordinate
  JR MOVETHINGS_13        ; Jump to consider the next entity
MOVETHINGS_8:
  LD (IX+$00),$61         ; The guardian will now start moving right to left
  JR MOVETHINGS_13        ; Jump to consider the next entity
; We are dealing with a vertical guardian.
MOVETHINGS_9:
  LD A,(IX+$00)           ; Flip bit 3 of the first byte of the guardian's
  XOR $08                 ; buffer (if bit 4 is set, the guardian's animation
  LD (IX+$00),A           ; frame is updated on every pass through this
                          ; routine; otherwise, it is updated on every second
                          ; pass when bit 3 is set)
  AND $18                 ; Are bits 3 and 4 both reset now?
  JR Z,MOVETHINGS_10      ; Jump if so
  LD A,(IX+$00)           ; Update the guardian's animation frame (in bits 5-7
  ADD A,$20               ; of the first byte of its buffer)
  LD (IX+$00),A
MOVETHINGS_10:
  LD A,(IX+$03)           ; Update the guardian's y-coordinate
  ADD A,(IX+$04)
  LD (IX+$03),A
  CP (IX+$07)             ; Has the guardian reached the lowest point of its
                          ; path (maximum y-coordinate)?
  JR NC,MOVETHINGS_12     ; If so, jump to change its direction of movement
  CP (IX+$06)             ; Compare the new y-coordinate with the minimum value
                          ; (the highest point of its path)
  JR Z,MOVETHINGS_11      ; If they match, jump to change the guardian's
                          ; direction of movement
  JR NC,MOVETHINGS_13     ; If the new y-coordinate is above the minimum value,
                          ; jump to consider the next entity
MOVETHINGS_11:
  LD A,(IX+$06)           ; Make sure that the guardian's y-coordinate is set
  LD (IX+$03),A           ; to its minimum value
MOVETHINGS_12:
  LD A,(IX+$04)           ; Negate the y-coordinate increment; this changes the
  NEG                     ; guardian's direction of movement
  LD (IX+$04),A
; The current entity has been dealt with. Time for the next one.
MOVETHINGS_13:
  LD DE,$0008             ; Point IX at the first byte of the next entity's
  ADD IX,DE               ; buffer
  JP MOVETHINGS_0         ; Jump back to deal with it

; Draw the rope, arrows and guardians in the current room
;
; Used by the routine at MAINLOOP. Draws the rope, arrows and guardians in the
; current room to the screen buffer at 24576.
DRAWTHINGS:
  LD IX,ENTITYBUF         ; Point IX at the first byte of the first entity
                          ; buffer at ENTITYBUF
; The drawing loop begins here.
DRAWTHINGS_0:
  LD A,(IX+$00)           ; Pick up the first byte of the current entity's
                          ; buffer
  CP $FF                  ; Have we already dealt with every entity?
  RET Z                   ; Return if so
  AND $07                 ; Keep only bits 0-2 (which determine the type of
                          ; entity)
  JP Z,DRAWTHINGS_22      ; Jump to consider the next entity buffer if this one
                          ; is not being used
  CP $03                  ; Is this a rope?
  JP Z,DRAWTHINGS_9       ; Jump if so
  CP $04                  ; Is this an arrow?
  JR Z,DRAWTHINGS_2       ; Jump if so
; We are dealing with a horizontal or vertical guardian.
  LD E,(IX+$03)           ; Point DE at the entry in the screen buffer address
  LD D,SBUFADDRS/256      ; lookup table at SBUFADDRS that corresponds to the
                          ; guardian's y-coordinate
  LD A,(DE)               ; Copy the LSB of the screen buffer address to L
  LD L,A
  LD A,(IX+$02)           ; Pick up the guardian's x-coordinate from bits 0-4
  AND $1F                 ; of the third byte of its buffer
  ADD A,L                 ; Adjust the LSB of the screen buffer address in L
  LD L,A                  ; for the guardian's x-coordinate
  LD A,E                  ; Copy the fourth byte of the guardian's buffer to A
  RLCA                    ; H=0x5C or 0x5D; now HL holds the address of the
  AND $01                 ; guardian's current location in the attribute buffer
  OR $5C                  ; at 23552
  LD H,A
  LD DE,$001F             ; Prepare DE for later addition
  LD A,(IX+$01)           ; Pick up the second byte of the guardian's buffer
  AND $0F                 ; Keep only bits 0-2 (INK colour) and 3 (BRIGHT
                          ; value)
  ADD A,$38               ; Push bit 3 up to bit 6
  AND $47                 ; Keep only bits 0-2 (INK colour) and 6 (BRIGHT
                          ; value)
  LD C,A                  ; Save this value in C temporarily
  LD A,(HL)               ; Pick up the room attribute byte at the guardian's
                          ; location from the buffer at 23552
  AND $38                 ; Keep only bits 3-5 (PAPER colour)
  XOR C                   ; Merge the INK colour and BRIGHT value from C
  LD C,A                  ; Copy this attribute value to C
  LD (HL),C               ; Set the attribute bytes in the buffer at 23552 for
  INC HL                  ; the top two rows of cells occupied by the
  LD (HL),C               ; guardian's sprite
  ADD HL,DE
  LD (HL),C
  INC HL
  LD (HL),C
  LD A,(IX+$03)           ; Pick up the fourth byte of the guardian's buffer
  AND $0E                 ; Does the guardian's sprite occupy only two rows of
                          ; cells at the moment?
  JR Z,DRAWTHINGS_1       ; Jump if so
  ADD HL,DE               ; Set the attribute bytes in the buffer at 23552 for
  LD (HL),C               ; the third row of cells occupied by the guardian's
  INC HL                  ; sprite
  LD (HL),C
DRAWTHINGS_1:
  LD C,$01                ; Prepare C for the call to DRAWSPRITE later on
  LD A,(IX+$01)           ; Now bits 5-7 of A hold the animation frame mask
  AND (IX+$00)            ; 'AND' on the current animation frame (bits 5-7)
  OR (IX+$02)             ; 'OR' on the base sprite index (bits 5-7)
  AND $E0                 ; Keep only bits 5-7
  LD E,A                  ; Point DE at the graphic data for the guardian's
  LD D,(IX+$05)           ; current animation frame (see GUARDIANS)
  LD H,SBUFADDRS/256      ; Point HL at the guardian's current location in the
  LD L,(IX+$03)           ; screen buffer at 24576
  LD A,(IX+$02)
  AND $1F
  OR (HL)
  INC HL
  LD H,(HL)
  LD L,A
  CALL DRAWSPRITE         ; Draw the guardian
  JP NZ,KILLWILLY_0       ; Kill Willy if the guardian collided with him
  JP DRAWTHINGS_22        ; Jump to consider the next entity
; We are dealing with an arrow.
DRAWTHINGS_2:
  BIT 7,(IX+$00)          ; Is the arrow travelling left to right?
  JR NZ,DRAWTHINGS_3      ; Jump if so
  DEC (IX+$04)            ; Decrement the arrow's x-coordinate
  LD C,$2C                ; The sound effect for an arrow travelling right to
                          ; left is made when the x-coordinate is 44
  JR DRAWTHINGS_4
DRAWTHINGS_3:
  INC (IX+$04)            ; Increment the arrow's x-coordinate
  LD C,$F4                ; The sound effect for an arrow travelling left to
                          ; right is made when the x-coordinate is 244
DRAWTHINGS_4:
  LD A,(IX+$04)           ; Pick up the arrow's x-coordinate (0-255)
  CP C                    ; Is it time to make the arrow sound effect?
  JR NZ,DRAWTHINGS_7      ; Jump if not
  LD BC,$0280             ; Prepare the delay counters (B=0x02, C=0x80) for the
                          ; arrow sound effect
  LD A,(BORDER)           ; Pick up the border colour for the current room from
                          ; BORDER
DRAWTHINGS_5:
  OUT ($FE),A             ; Produce the arrow sound effect
  XOR $18
DRAWTHINGS_6:
  DJNZ DRAWTHINGS_6
  LD B,C
  DEC C
  JR NZ,DRAWTHINGS_5
  JP DRAWTHINGS_22        ; Jump to consider the next entity
DRAWTHINGS_7:
  AND $E0                 ; Is the arrow's x-coordinate in the range 0-31 (i.e.
                          ; on-screen)?
  JP NZ,DRAWTHINGS_22     ; If not, jump to consider the next entity
  LD E,(IX+$02)           ; Point DE at the entry in the screen buffer address
  LD D,SBUFADDRS/256      ; lookup table at SBUFADDRS that corresponds to the
                          ; arrow's y-coordinate
  LD A,(DE)               ; Pick up the LSB of the screen buffer address
  ADD A,(IX+$04)          ; Adjust it for the arrow's x-coordinate
  LD L,A                  ; Point HL at the arrow's current location in the
  LD A,E                  ; attribute buffer at 23552
  AND $80
  RLCA
  OR $5C
  LD H,A
  LD (IX+$05),$00         ; Initialise the collision detection byte (0x00=off,
                          ; 0xFF=on)
  LD A,(HL)               ; Pick up the room attribute byte at the arrow's
                          ; location
  AND $07                 ; Keep only bits 0-2 (INK colour)
  CP $07                  ; Is the INK white?
  JR NZ,DRAWTHINGS_8      ; Jump if not
  DEC (IX+$05)            ; Activate collision detection
DRAWTHINGS_8:
  LD A,(HL)               ; Set the INK colour to white at the arrow's location
  OR $07
  LD (HL),A
  INC DE                  ; Pick up the MSB of the screen buffer address for
  LD A,(DE)               ; the arrow's location
  LD H,A                  ; Point HL at the top pixel row of the arrow's
  DEC H                   ; location in the screen buffer at 24576
  LD A,(IX+$06)           ; Draw the top pixel row of the arrow
  LD (HL),A
  INC H                   ; Point HL at the middle pixel row of the arrow's
                          ; location in the screen buffer at 24576
  LD A,(HL)               ; Pick up the graphic byte that's already here
  AND (IX+$05)            ; Has the arrow hit anything that has white INK (e.g.
                          ; Willy)?
  JP NZ,KILLWILLY_0       ; If so, kill Willy
  LD (HL),$FF             ; Draw the shaft of the arrow
  INC H                   ; Point HL at the bottom pixel row of the arrow's
                          ; location in the screen buffer at 24576
  LD A,(IX+$06)           ; Draw the bottom pixel row of the arrow
  LD (HL),A
  JP DRAWTHINGS_22        ; Jump to consider the next entity
; We are dealing with a rope.
DRAWTHINGS_9:
  LD IY,SBUFADDRS         ; Point IY at the first byte of the screen buffer
                          ; address lookup table at SBUFADDRS
  LD (IX+$09),$00         ; Initialise the second byte in the following entity
                          ; buffer to zero; this will count the segments of
                          ; rope to draw
  LD A,(IX+$02)           ; Initialise the fourth byte of the rope's buffer;
  LD (IX+$03),A           ; this holds the x-coordinate of the cell in which
                          ; the segment of rope under consideration will be
                          ; drawn
  LD (IX+$05),$80         ; Initialise the sixth byte of the rope's buffer to
                          ; 0x80 (bit 7 set); the value held here is used to
                          ; draw the segment of rope under consideration
; The following loop draws each segment of the rope from top to bottom.
DRAWTHINGS_10:
  LD A,(IY+$00)           ; Point HL at the location of the segment of rope
  ADD A,(IX+$03)          ; under consideration in the screen buffer at 24576
  LD L,A
  LD H,(IY+$01)
  LD A,(ROPE)             ; Pick up the rope status indicator at ROPE
  OR A                    ; Is Willy on the rope, or has he recently jumped or
                          ; dropped off it?
  JR NZ,DRAWTHINGS_11     ; Jump if so
  LD A,(IX+$05)           ; Pick up the drawing byte
  AND (HL)                ; Is this segment of rope touching anything else
                          ; that's been drawn so far (e.g. Willy)?
  JR Z,DRAWTHINGS_13      ; Jump if not
  LD A,(IX+$09)           ; Copy the segment counter into the rope status
  LD (ROPE),A             ; indicator at ROPE
  SET 0,(IX+$0B)          ; Signal: Willy is on the rope
DRAWTHINGS_11:
  CP (IX+$09)             ; Does the rope status indicator at ROPE match the
                          ; segment counter?
  JR NZ,DRAWTHINGS_13     ; Jump if not
  BIT 0,(IX+$0B)          ; Is Willy on the rope (and clinging to this
                          ; particular segment)?
  JR Z,DRAWTHINGS_13      ; Jump if not
  LD B,(IX+$03)           ; Copy the x-coordinate of the cell containing the
                          ; segment of rope under consideration to B
  LD A,(IX+$05)           ; Pick up the drawing byte in A
  LD C,$01                ; The value in C will specify Willy's next animation
                          ; frame; initialise it to 1
  CP $04                  ; Is the set bit of the drawing byte in bit 0 or 1?
  JR C,DRAWTHINGS_12      ; Jump if so
  LD C,$00                ; Assume that Willy's next animation frame will be 0
  CP $10                  ; Is the set bit of the drawing byte in bit 2 or 3?
  JR C,DRAWTHINGS_12      ; Jump if so
  DEC B                   ; Decrement the x-coordinate
  LD C,$03                ; Assume that Willy's next animation frame will be 3
  CP $40                  ; Is the set bit of the drawing byte in bit 4 or 5?
  JR C,DRAWTHINGS_12      ; Jump if so
  LD C,$02                ; Willy's next animation frame will be 2 (the set bit
                          ; of the drawing byte is in bit 6 or 7)
DRAWTHINGS_12:
  LD (FRAME),BC           ; Set Willy's animation frame at FRAME, and
                          ; temporarily store his x-coordinate at LOCATION
  LD A,IYl                ; Update Willy's pixel y-coordinate at PIXEL_Y to
  SUB $10                 ; account for his change of location as the rope
  LD (PIXEL_Y),A          ; moves
  PUSH HL                 ; Save HL briefly
  CALL MOVEWILLY_8        ; Update Willy's attribute buffer address at LOCATION
                          ; to account for his change of location as the rope
                          ; moves
  POP HL                  ; Restore the screen buffer address of the segment of
                          ; rope under consideration to HL
  JR DRAWTHINGS_13        ; Make a redundant jump to the next instruction
DRAWTHINGS_13:
  LD A,(IX+$05)           ; Draw a pixel of the rope to the screen buffer at
  OR (HL)                 ; 24576
  LD (HL),A
  LD A,(IX+$09)           ; Point HL at the relevant entry in the second half
  ADD A,(IX+$01)          ; of the rope animation table at ROPEANIM
  LD L,A
  SET 7,L
  LD H,ROPEANIM/256
  LD E,(HL)               ; Add its value to IY; now IY points at the entry in
  LD D,$00                ; the screen buffer address lookup table at SBUFADDRS
  ADD IY,DE               ; that corresponds to the next segment of rope to
                          ; consider
  RES 7,L                 ; Point HL at the relevant entry in the first half of
                          ; the rope animation table at ROPEANIM
  LD A,(HL)               ; Pick up its value
  OR A                    ; Is it zero?
  JR Z,DRAWTHINGS_18      ; Jump if so
  LD B,A                  ; Copy the rope animation table entry value to B;
                          ; this will count the rotations of the drawing byte
  BIT 7,(IX+$01)          ; Is the rope currently right of centre?
  JR Z,DRAWTHINGS_16      ; Jump if so
DRAWTHINGS_14:
  RLC (IX+$05)            ; Rotate the drawing byte left once
  BIT 0,(IX+$05)          ; Did that push the set bit from bit 7 into bit 0?
  JR Z,DRAWTHINGS_15      ; Jump if not
  DEC (IX+$03)            ; Decrement the x-coordinate for the cell containing
                          ; this segment of rope
DRAWTHINGS_15:
  DJNZ DRAWTHINGS_14      ; Jump back until the drawing byte has been rotated
                          ; as required
  JR DRAWTHINGS_18        ; Jump to consider the next segment of rope
DRAWTHINGS_16:
  RRC (IX+$05)            ; Rotate the drawing byte right once
  BIT 7,(IX+$05)          ; Did that push the set bit from bit 0 into bit 7?
  JR Z,DRAWTHINGS_17      ; Jump if not
  INC (IX+$03)            ; Increment the x-coordinate for the cell containing
                          ; this segment of rope
DRAWTHINGS_17:
  DJNZ DRAWTHINGS_16      ; Jump back until the drawing byte has been rotated
                          ; as required
DRAWTHINGS_18:
  LD A,(IX+$09)           ; Pick up the segment counter
  CP (IX+$04)             ; Have we drawn every segment of the rope yet?
  JR Z,DRAWTHINGS_19      ; Jump if so
  INC (IX+$09)            ; Increment the segment counter
  JP DRAWTHINGS_10        ; Jump back to draw the next segment of rope
; Now that the entire rope has been drawn, deal with Willy's movement along it.
DRAWTHINGS_19:
  LD A,(ROPE)             ; Pick up the rope status indicator at ROPE
  BIT 7,A                 ; Has Willy recently jumped off the rope or dropped
                          ; off the bottom of it (A>=0xF0)?
  JR Z,DRAWTHINGS_20      ; Jump if not
  INC A                   ; Update the rope status indicator at ROPE
  LD (ROPE),A
  RES 0,(IX+$0B)          ; Signal: Willy is not on the rope
  JR DRAWTHINGS_22        ; Jump to consider the next entity
DRAWTHINGS_20:
  BIT 0,(IX+$0B)          ; Is Willy on the rope?
  JR Z,DRAWTHINGS_22      ; If not, jump to consider the next entity
  LD A,(DMFLAGS)          ; Pick up Willy's direction and movement flags from
                          ; DMFLAGS
  BIT 1,A                 ; Is Willy moving up or down the rope?
  JR Z,DRAWTHINGS_22      ; If not, jump to consider the next entity
  RRCA                    ; XOR Willy's direction bit (0=facing right, 1=facing
  XOR (IX+$00)            ; left) with the rope's direction bit (0=swinging
  RLCA                    ; right to left, 1=swinging left to right)
  RLCA                    ; Now A=1 if Willy is facing the same direction as
  AND $02                 ; the rope is swinging (he will move down the rope),
  DEC A                   ; or -1 otherwise (he will move up the rope)
  LD HL,ROPE              ; Increment or decrement the rope status indicator at
  ADD A,(HL)              ; ROPE
  LD (HL),A
  LD A,(ABOVE)            ; Pick up the number of the room above from ABOVE and
  LD C,A                  ; copy it to C
  LD A,(ROOM)             ; Pick up the number of the current room from ROOM
  CP C                    ; Is there a room above this one?
  JR NZ,DRAWTHINGS_21     ; Jump if so
  LD A,(HL)               ; Pick up the rope status indicator at ROPE
  CP $0C                  ; Is it 0x0C or greater?
  JR NC,DRAWTHINGS_21     ; Jump if so
  LD (HL),$0C             ; Set the rope status indicator at ROPE to 0x0C
                          ; (there is nowhere to go above this rope)
DRAWTHINGS_21:
  LD A,(HL)               ; Pick up the rope status indicator at ROPE
  CP (IX+$04)             ; Compare it with the length of the rope
  JR C,DRAWTHINGS_22      ; If Willy is at or above the bottom of the rope,
  JR Z,DRAWTHINGS_22      ; jump to consider the next entity
  LD (HL),$F0             ; Set the rope status indicator at ROPE to 0xF0
                          ; (Willy has just dropped off the bottom of the rope)
  LD A,(PIXEL_Y)          ; Round down Willy's pixel y-coordinate at PIXEL_Y to
  AND $F8                 ; the nearest multiple of 8; this might move him
  LD (PIXEL_Y),A          ; upwards a little, but ensures that his actual pixel
                          ; y-coordinate is a multiple of 4 before he starts
                          ; falling
  XOR A                   ; Initialise the airborne status indicator at
  LD (AIRBORNE),A         ; AIRBORNE
  JR DRAWTHINGS_22        ; Make a redundant jump to the next instruction
; The current entity has been dealt with. Time for the next one.
DRAWTHINGS_22:
  LD DE,$0008             ; Point IX at the first byte of the next entity's
  ADD IX,DE               ; buffer
  JP DRAWTHINGS_0         ; Jump back to deal with it

; Unused routine
;
; This routine is not used, but if it were, it would set the INK colour for a
; 3x2 block of cells, maintaining the PAPER, BRIGHT and FLASH attributes of the
; current room background. It is identical to the code at 8E5F in Manic Miner
; that is used to set the attributes for a vertical guardian.
;
; A INK colour (0-7)
; HL Attribute buffer address
U_SETATTRS:
  LD (HL),A               ; Store the INK colour (bits 0-2)
  LD A,(BACKGROUND)       ; Collect the current room's background tile
                          ; attribute from BACKGROUND
  AND $F8                 ; Keep only bits 3-7 (PAPER, BRIGHT, FLASH)
  OR (HL)                 ; Merge the INK bits
  LD (HL),A               ; Store the resultant attribute byte
  LD DE,$001F             ; Prepare DE for later addition
  INC HL                  ; Move right one cell and store the attribute byte
  LD (HL),A               ; there
  ADD HL,DE               ; Move left one cell and down a row and store the
  LD (HL),A               ; attribute byte there
  INC HL                  ; Move right one cell and store the attribute byte
  LD (HL),A               ; there
  ADD HL,DE               ; Move left one cell and down a row and store the
  LD (HL),A               ; attribute byte there
  INC HL                  ; Move right one cell and store the attribute byte
  LD (HL),A               ; there
  RET

; Draw the items in the current room and collect any that Willy is touching
;
; Used by the routine at MAINLOOP.
DRAWITEMS:
  LD H,ITEMTABLE1/256     ; Page 0xA4 holds the first byte of each entry in the
                          ; item table
  LD A,(FIRSTITEM)        ; Pick up the index of the first item from FIRSTITEM
  LD L,A                  ; Point HL at the first byte of the first entry in
                          ; the item table
; The item-drawing loop begins here.
DRAWITEMS_0:
  LD C,(HL)               ; Pick up the first byte of the current entry in the
                          ; item table
  RES 7,C                 ; Reset bit 7; bit 6 holds the collection flag, and
                          ; bits 0-5 hold the room number
  LD A,(ROOM)             ; Pick up the number of the current room from ROOM
  OR $40                  ; Set bit 6 (corresponding to the collection flag)
  CP C                    ; Is the item in the current room and still
                          ; uncollected?
  JR NZ,DRAWITEMS_7       ; If not, jump to consider the next entry in the item
                          ; table
; This item is in the current room and has not been collected yet.
  LD A,(HL)               ; Pick up the first byte of the current entry in the
                          ; item table
  RLCA                    ; Point DE at the location of the item in the
  AND $01                 ; attribute buffer at 23552
  ADD A,$5C
  LD D,A
  INC H
  LD E,(HL)
  DEC H
  LD A,(DE)               ; Pick up the current attribute byte at the item's
                          ; location
  AND $07                 ; Is the INK white (which happens if Willy is
  CP $07                  ; touching the item, or the room's background tile
                          ; has white INK, as in Swimming Pool)?
  JR NZ,DRAWITEMS_6       ; Jump if not
; Willy is touching this item (or the room's background tile has white INK), so
; add it to his collection.
  LD IX,MSG_ITEMS         ; Point IX at the number of items collected at
                          ; MSG_ITEMS
DRAWITEMS_1:
  INC (IX+$02)            ; Increment a digit of the number of items collected
  LD A,(IX+$02)           ; Was the digit originally '9'?
  CP $3A
  JR NZ,DRAWITEMS_2       ; Jump if not
  LD (IX+$02),$30         ; Set the digit to '0'
  DEC IX                  ; Move back to the digit on the left
  JR DRAWITEMS_1          ; Jump back to increment this digit
DRAWITEMS_2:
  LD A,(BORDER)           ; Pick up the border colour for the current room from
                          ; BORDER
  LD C,$80                ; Produce the sound effect for collecting an item
DRAWITEMS_3:
  OUT ($FE),A
  XOR $18
  LD E,A
  LD A,$90
  SUB C
  LD B,A
  LD A,E
DRAWITEMS_4:
  DJNZ DRAWITEMS_4
  DEC C
  DEC C
  JR NZ,DRAWITEMS_3
  LD A,(ITEMS)            ; Update the counter of items remaining at ITEMS, and
  INC A                   ; set the zero flag if there are no more items to
  LD (ITEMS),A            ; collect
  JR NZ,DRAWITEMS_5       ; Jump if there are any items still to be collected
  LD A,$01                ; Update the game mode indicator at MODE to 1 (all
  LD (MODE),A             ; items collected)
DRAWITEMS_5:
  RES 6,(HL)              ; Reset bit 6 of the first byte of the entry in the
                          ; item table: the item has been collected
  JR DRAWITEMS_7          ; Jump to consider the next entry in the item table
; Willy is not touching this item, so draw it and cycle its INK colour.
DRAWITEMS_6:
  LD A,(TICKS)            ; Generate the INK colour for the item from the value
  ADD A,L                 ; of the minute counter at TICKS (0x00-0xFF) and the
  AND $03                 ; index of the item in the item table (0xAD-0xFF)
  ADD A,$03
  LD C,A
  LD A,(DE)               ; Change the INK colour of the item in the attribute
  AND $F8                 ; buffer at 23552
  OR C
  LD (DE),A
  LD A,(HL)               ; Point DE at the location of the item in the screen
  RLCA                    ; buffer at 24576
  RLCA
  RLCA
  RLCA
  AND $08
  ADD A,$60
  LD D,A
  PUSH HL                 ; Save HL briefly
  LD HL,ITEM              ; Point HL at the item graphic for the current room
                          ; (at ITEM)
  LD B,$08                ; There are eight pixel rows to copy
  CALL PRINTCHAR_0        ; Draw the item to the screen buffer at 24576
  POP HL                  ; Restore the item table pointer to HL
; The current item has been dealt with (skipped, collected or drawn) as
; appropriate. Time to consider the next one.
DRAWITEMS_7:
  INC L                   ; Point HL at the first byte of the next entry in the
                          ; item table
  JR NZ,DRAWITEMS_0       ; Jump back unless we've examined every entry
  RET

; Draw a sprite
;
; Used by the routines at CODESCREEN (to draw the number key graphics on the
; code entry screen), DRAWLIVES (to draw the remaining lives), GAMEOVER (to
; draw Willy, the foot and the barrel during the game over sequence),
; DRAWTHINGS (to draw guardians in the current room) and BEDANDBATH (to draw
; Maria in Master Bedroom). If C=1 on entry, this routine returns with the zero
; flag reset if any of the set bits in the sprite being drawn collides with a
; set bit in the background.
;
; C Drawing mode: 0 (overwrite) or 1 (blend)
; DE Address of sprite graphic data
; HL Address to draw at
DRAWSPRITE:
  LD B,$10                ; There are 16 rows of pixels to draw
DRAWSPRITE_0:
  BIT 0,C                 ; Set the zero flag if we're in overwrite mode
  LD A,(DE)               ; Pick up a sprite graphic byte
  JR Z,DRAWSPRITE_1       ; Jump if we're in overwrite mode
  AND (HL)                ; Return with the zero flag reset if any of the set
  RET NZ                  ; bits in the sprite graphic byte collide with a set
                          ; bit in the background (e.g. in Willy's sprite)
  LD A,(DE)               ; Pick up the sprite graphic byte again
  OR (HL)                 ; Blend it with the background byte
DRAWSPRITE_1:
  LD (HL),A               ; Copy the graphic byte to its destination cell
  INC L                   ; Move HL along to the next cell on the right
  INC DE                  ; Point DE at the next sprite graphic byte
  BIT 0,C                 ; Set the zero flag if we're in overwrite mode
  LD A,(DE)               ; Pick up a sprite graphic byte
  JR Z,DRAWSPRITE_2       ; Jump if we're in overwrite mode
  AND (HL)                ; Return with the zero flag reset if any of the set
  RET NZ                  ; bits in the sprite graphic byte collide with a set
                          ; bit in the background (e.g. in Willy's sprite)
  LD A,(DE)               ; Pick up the sprite graphic byte again
  OR (HL)                 ; Blend it with the background byte
DRAWSPRITE_2:
  LD (HL),A               ; Copy the graphic byte to its destination cell
  DEC L                   ; Move HL to the next pixel row down in the cell on
  INC H                   ; the left
  INC DE                  ; Point DE at the next sprite graphic byte
  LD A,H                  ; Have we drawn the bottom pixel row in this pair of
  AND $07                 ; cells yet?
  JR NZ,DRAWSPRITE_3      ; Jump if not
  LD A,H                  ; Otherwise move HL to the top pixel row in the cell
  SUB $08                 ; below
  LD H,A
  LD A,L
  ADD A,$20
  LD L,A
  AND $E0                 ; Was the last pair of cells at y-coordinate 7 or 15?
  JR NZ,DRAWSPRITE_3      ; Jump if not
  LD A,H                  ; Otherwise adjust HL to account for the movement
  ADD A,$08               ; from the top or middle third of the screen to the
  LD H,A                  ; next one down
DRAWSPRITE_3:
  DJNZ DRAWSPRITE_0       ; Jump back until all 16 rows of pixels have been
                          ; drawn
  XOR A                   ; Set the zero flag (to indicate no collision)
  RET

; Move Willy into the room to the left
;
; Used by the routine at MOVEWILLY3.
ROOMLEFT:
  LD A,(LEFT)             ; Pick up the number of the room to the left from
                          ; LEFT
  LD (ROOM),A             ; Make it the current room number by copying it to
                          ; ROOM
  LD A,(LOCATION)         ; Adjust Willy's screen x-coordinate (at LOCATION) to
  OR $1F                  ; 30 (on the far right)
  AND $FE
  LD (LOCATION),A
  POP HL                  ; Drop the return address (AFTERMOVE1, in the main
                          ; loop) from the stack
  JP INITROOM             ; Draw the room and re-enter the main loop

; Move Willy into the room to the right
;
; Used by the routine at MOVEWILLY3.
ROOMRIGHT:
  LD A,(RIGHT)            ; Pick up the number of the room to the right from
                          ; RIGHT
  LD (ROOM),A             ; Make it the current room number by copying it to
                          ; ROOM
  LD A,(LOCATION)         ; Adjust Willy's screen x-coordinate (at LOCATION) to
  AND $E0                 ; 0 (on the far left)
  LD (LOCATION),A
  POP HL                  ; Drop the return address (AFTERMOVE1, in the main
                          ; loop) from the stack
  JP INITROOM             ; Draw the room and re-enter the main loop

; Move Willy into the room above
;
; Used by the routines at MAINLOOP and MOVEWILLY.
ROOMABOVE:
  LD A,(ABOVE)            ; Pick up the number of the room above from ABOVE
  LD (ROOM),A             ; Make it the current room number by copying it to
                          ; ROOM
  LD A,(LOCATION)         ; Willy should now appear on the bottom floor of the
  AND $1F                 ; room, so adjust his attribute buffer coordinates
  ADD A,$A0               ; (at LOCATION) accordingly
  LD (LOCATION),A
  LD A,$5D
  LD (LOCATION+1),A
  LD A,$D0                ; Adjust Willy's pixel y-coordinate (at PIXEL_Y) as
  LD (PIXEL_Y),A          ; well
  XOR A                   ; Reset the airborne status indicator at AIRBORNE
  LD (AIRBORNE),A
  JP INITROOM             ; Draw the room and re-enter the main loop

; Move Willy into the room below
;
; Used by the routine at MOVEWILLY.
ROOMBELOW:
  LD A,(BELOW)            ; Pick up the number of the room below from BELOW
  LD (ROOM),A             ; Make it the current room number by copying it to
                          ; ROOM
  XOR A                   ; Set Willy's pixel y-coordinate (at PIXEL_Y) to 0
  LD (PIXEL_Y),A
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  CP $0B                  ; Is it 0x0B or greater (meaning Willy has already
                          ; been falling for a while)?
  JR NC,ROOMBELOW_0       ; Jump if so
  LD A,$02                ; Otherwise set the airborne status indicator to 2
  LD (AIRBORNE),A         ; (Willy will start falling here if there's no floor
                          ; beneath him)
ROOMBELOW_0:
  LD A,(LOCATION)         ; Willy should now appear at the top of the room, so
  AND $1F                 ; adjust his attribute buffer coordinates (at
  LD (LOCATION),A         ; LOCATION) accordingly
  LD A,$5C
  LD (LOCATION+1),A
  JP INITROOM             ; Draw the room and re-enter the main loop

; Move the conveyor in the current room
;
; Used by the routine at MAINLOOP.
MVCONVEYOR:
  LD HL,(CONVLOC)         ; Pick up the address of the conveyor's location in
                          ; the attribute buffer at 24064 from CONVLOC
  LD A,H                  ; Point DE and HL at the location of the left end of
  AND $01                 ; the conveyor in the screen buffer at 28672
  RLCA
  RLCA
  RLCA
  ADD A,$70
  LD H,A
  LD E,L
  LD D,H
  LD A,(CONVLEN)          ; Pick up the length of the conveyor from CONVLEN
  OR A                    ; Is there a conveyor in the room?
  RET Z                   ; Return if not
  LD B,A                  ; B will count the conveyor tiles
  LD A,(CONVDIR)          ; Pick up the direction of the conveyor from CONVDIR
                          ; (0=left, 1=right)
  OR A                    ; Is the conveyor moving right?
  JR NZ,MVCONVEYOR_1      ; Jump if so
; The conveyor is moving left.
  LD A,(HL)               ; Copy the first pixel row of the conveyor tile to A
  RLC A                   ; Rotate it left twice
  RLC A
  INC H                   ; Point HL at the third pixel row of the conveyor
  INC H                   ; tile
  LD C,(HL)               ; Copy this pixel row to C
  RRC C                   ; Rotate it right twice
  RRC C
MVCONVEYOR_0:
  LD (DE),A               ; Update the first and third pixel rows of every
  LD (HL),C               ; conveyor tile in the screen buffer at 28672
  INC L
  INC E
  DJNZ MVCONVEYOR_0
  RET
; The conveyor is moving right.
MVCONVEYOR_1:
  LD A,(HL)               ; Copy the first pixel row of the conveyor tile to A
  RRC A                   ; Rotate it right twice
  RRC A
  INC H                   ; Point HL at the third pixel row of the conveyor
  INC H                   ; tile
  LD C,(HL)               ; Copy this pixel row to C
  RLC C                   ; Rotate it left twice
  RLC C
  JR MVCONVEYOR_0         ; Jump back to update the first and third pixel rows
                          ; of every conveyor tile

; Deal with special rooms (Master Bedroom, The Bathroom)
;
; Used by the routine at MAINLOOP.
BEDANDBATH:
  LD A,(ROOM)             ; Pick up the number of the current room from ROOM
  CP $23                  ; Are we in Master Bedroom?
  JR NZ,DRAWTOILET        ; Jump if not
  LD A,(MODE)             ; Pick up the game mode indicator from MODE
  OR A                    ; Has Willy collected all the items?
  JR NZ,BEDANDBATH_1      ; Jump if so
; Willy hasn't collected all the items yet, so Maria is on guard.
  LD A,(TICKS)            ; Pick up the minute counter from TICKS; this will
                          ; determine Maria's animation frame
  AND $02                 ; Keep only bit 1, move it to bit 5, and set bit 7
  RRCA
  RRCA
  RRCA
  RRCA
  OR $80
  LD E,A                  ; Now E=0x80 (foot down) or 0xA0 (foot raised)
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate from PIXEL_Y
  CP $D0                  ; Is Willy on the floor below the ramp?
  JR Z,BEDANDBATH_0       ; Jump if so
  LD E,$C0                ; E=0xC0 (raising arm)
  CP $C0                  ; Is Willy 8 or fewer pixels above floor level?
  JR NC,BEDANDBATH_0      ; Jump if so
  LD E,$E0                ; E=0xE0 (arm raised)
BEDANDBATH_0:
  LD D,MARIA0/256         ; Point DE at the sprite graphic data for Maria
                          ; (MARIA0, MARIA1, MARIA2 or MARIA3)
  LD HL,$686E             ; Draw Maria at (11,14) in the screen buffer at 24576
  LD C,$01
  CALL DRAWSPRITE
  JP NZ,KILLWILLY_0       ; Kill Willy if Maria collided with him
  LD HL,$4545             ; H=L=0x45 (INK 5: PAPER 0: BRIGHT 1)
  LD ($5D6E),HL           ; Set the attribute bytes for the top half of Maria's
                          ; sprite in the buffer at 23552
  LD HL,$0707             ; H=L=0x07 (INK 7: PAPER 0: BRIGHT 0)
  LD ($5D8E),HL           ; Set the attribute bytes for the bottom half of
                          ; Maria's sprite in the buffer at 23552
  RET
; Willy has collected all the items, so Maria is gone.
BEDANDBATH_1:
  LD A,(LOCATION)         ; Pick up Willy's screen x-coordinate from LOCATION
  AND $1F
  CP $06                  ; Has Willy reached the bed (at x=5) yet?
  RET NC                  ; Return if not
  LD A,$02                ; Update the game mode indicator at MODE to 2 (Willy
  LD (MODE),A             ; is running to the toilet)
  RET

; Check whether Willy has reached the toilet
;
; Called by the routine at MAINLOOP when Willy is on his way to the toilet.
CHKTOILET:
  LD A,(ROOM)             ; Pick up the number of the current room from ROOM
  CP $21                  ; Are we in The Bathroom?
  RET NZ                  ; Return if not
  LD A,(LOCATION)         ; Pick up the LSB of Willy's attribute buffer
                          ; location from LOCATION
  CP $BC                  ; Is Willy's screen x-coordinate 28 (where the toilet
                          ; is)?
  RET NZ                  ; Return if not
; Willy has reached the toilet.
  XOR A                   ; Reset the minute counter at TICKS to 0 (so that we
  LD (TICKS),A            ; get to see Willy's head down the toilet for at
                          ; least a whole game minute)
  LD A,$03                ; Update the game mode indicator at MODE to 3
  LD (MODE),A             ; (Willy's head is down the toilet)
  RET

; Animate the toilet in The Bathroom
;
; Used by the routine at BEDANDBATH.
DRAWTOILET:
  LD A,(ROOM)             ; Pick up the number of the current room from ROOM
  CP $21                  ; Are we in The Bathroom?
  RET NZ                  ; Return if not
  LD A,(TICKS)            ; Pick up the minute counter from TICKS; this will
                          ; determine the animation frame to use for the toilet
  AND $01                 ; Keep only bit 0 and move it to bit 5
  RRCA
  RRCA
  RRCA
  LD E,A                  ; Now E=0x00 or 0x20
  LD A,(MODE)             ; Pick up the game mode indicator from MODE
  CP $03                  ; Is Willy's head down the toilet?
  JR NZ,DRAWTOILET_0      ; Jump if not
  SET 6,E                 ; Now E=0x40 or 0x60
DRAWTOILET_0:
  LD D,TOILET0/256        ; Point DE at the toilet sprite to use (TOILET0,
                          ; TOILET1, TOILET2 or TOILET3)
  LD IX,SBUFADDRS+208     ; Draw the toilet at (13,28) in the screen buffer at
  LD BC,$101C             ; 24576
  CALL DRAWWILLY_1
  LD HL,$0707             ; H=L=0x07 (INK 7: PAPER 0)
  LD ($5DBC),HL           ; Set the attribute bytes for the toilet in the
  LD ($5DDC),HL           ; buffer at 23552
  RET

; Check and set the attribute bytes for Willy's sprite in the buffer at 5C00
;
; Used by the routine at MAINLOOP. Sets the attribute bytes in the buffer at
; 23552 for the six cells (in three rows of two) occupied by or under Willy's
; sprite, or kills Willy if any of the cells contains a nasty.
WILLYATTRS:
  LD HL,(LOCATION)        ; Pick up Willy's attribute buffer coordinates from
                          ; LOCATION
  LD B,$00                ; Initialise B to 0 (in case Willy is not standing on
                          ; a ramp)
  LD A,(RAMPDIR)          ; Pick up the direction byte of the ramp definition
                          ; for the current room from RAMPDIR
  AND $01                 ; Point HL at one of the cells under Willy's feet
  ADD A,$40               ; (the one on the left if the ramp goes up to the
  LD E,A                  ; left, the one on the right if the ramp goes up to
  LD D,$00                ; the right)
  ADD HL,DE
  LD A,(RAMP)             ; Pick up the ramp's attribute byte from RAMP
  CP (HL)                 ; Is Willy on or just above the ramp?
  JR NZ,WILLYATTRS_0      ; Jump if not
  LD A,(AIRBORNE)         ; Pick up the airborne status indicator from AIRBORNE
  OR A                    ; Is Willy airborne?
  JR NZ,WILLYATTRS_0      ; Jump if so
; Willy is standing on a ramp. Calculate the offset that needs to be added to
; the y-coordinate stored at PIXEL_Y to obtain Willy's true pixel y-coordinate.
  LD A,(FRAME)            ; Pick up Willy's current animation frame (0-3) from
                          ; FRAME
  AND $03                 ; B=0, 4, 8 or 12
  RLCA
  RLCA
  LD B,A
  LD A,(RAMPDIR)          ; Pick up the direction byte of the ramp definition
                          ; for the current room from RAMPDIR
  AND $01                 ; A=B (if the ramp goes up to the left) or 12-B (if
  DEC A                   ; the ramp goes up to the right)
  XOR $0C
  XOR B
  AND $0C
  LD B,A                  ; Copy this value to B
; Now B holds a y-coordinate offset of 0, 4, 8 or 12 if Willy is standing on a
; ramp, or 0 otherwise.
WILLYATTRS_0:
  LD HL,(LOCATION)        ; Pick up Willy's attribute buffer coordinates from
                          ; LOCATION
  LD DE,$001F             ; Prepare DE for later addition
  LD C,$0F                ; Set C=0x0F for the top two rows of cells (to make
                          ; the routine at WILLYATTR force white INK)
  CALL WILLYATTR          ; Check and set the attribute byte for the top-left
                          ; cell
  INC HL                  ; Move HL to the next cell to the right
  CALL WILLYATTR          ; Check and set the attribute byte for the top-right
                          ; cell
  ADD HL,DE               ; Move HL down a row and back one cell to the left
  CALL WILLYATTR          ; Check and set the attribute byte for the mid-left
                          ; cell
  INC HL                  ; Move HL to the next cell to the right
  CALL WILLYATTR          ; Check and set the attribute byte for the mid-right
                          ; cell
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate from PIXEL_Y
  ADD A,B                 ; Add the y-coordinate offset calculated earlier (to
  LD C,A                  ; get Willy's true pixel y-coordinate if he's
                          ; standing on a ramp) and transfer the result to C
  ADD HL,DE               ; Move HL down a row and back one cell to the left;
                          ; at this point HL may be pointing at one of the
                          ; cells in the top row of the buffer at 24064, which
                          ; is a bug
  CALL WILLYATTR          ; Check and set the attribute byte for the
                          ; bottom-left cell
  INC HL                  ; Move HL to the next cell to the right
  CALL WILLYATTR          ; Check and set the attribute byte for the
                          ; bottom-right cell
  JR DRAWWILLY            ; Draw Willy to the screen buffer at 24576

; Check and set the attribute byte for a cell occupied by Willy's sprite
;
; Used by the routine at WILLYATTRS. Sets the attribute byte in the buffer at
; 23552 for one of the six cells (in three rows of two) occupied by or under
; Willy's sprite, or kills Willy if the cell contains a nasty. On entry, C
; holds either 0x0F if the cell is in the top two rows, or Willy's pixel
; y-coordinate if the cell is in the bottom row.
;
; C 0x0F or Willy's pixel y-coordinate
; HL Address of the attribute byte in the buffer at 23552
WILLYATTR:
  LD A,(BACKGROUND)       ; Pick up the attribute byte of the background tile
                          ; in the current room from BACKGROUND
  CP (HL)                 ; Does this cell contain a background tile?
  JR NZ,WILLYATTR_0       ; Jump if not
  LD A,C                  ; Set the zero flag if we are going to retain the INK
  AND $0F                 ; colour in this cell; this happens only if the cell
                          ; is in the bottom row and Willy's sprite is confined
                          ; to the top two rows
  JR Z,WILLYATTR_0        ; Jump if we are going to retain the current INK
                          ; colour in this cell
  LD A,(BACKGROUND)       ; Pick up the attribute byte of the background tile
                          ; in the current room from BACKGROUND
  OR $07                  ; Set bits 0-2, making the INK white
  LD (HL),A               ; Set the attribute byte for this cell in the buffer
                          ; at 23552
WILLYATTR_0:
  LD A,(NASTY)            ; Pick up the attribute byte of the nasty tile in the
                          ; current room from NASTY
  CP (HL)                 ; Has Willy hit a nasty?
  JP Z,KILLWILLY          ; Kill Willy if so
  RET

; Draw Willy to the screen buffer at 6000
;
; Used by the routine at WILLYATTRS.
;
; B y-coordinate offset (0, 4, 8 or 12)
DRAWWILLY:
  LD A,(PIXEL_Y)          ; Pick up Willy's pixel y-coordinate from PIXEL_Y
  ADD A,B                 ; Add the y-coordinate offset (to get Willy's true
                          ; pixel y-coordinate if he's standing on a ramp)
  LD IXh,SBUFADDRS/256    ; Point IX at the entry in the screen buffer address
  LD IXl,A                ; lookup table at SBUFADDRS that corresponds to
                          ; Willy's y-coordinate
  LD A,(DMFLAGS)          ; Pick up Willy's direction and movement flags from
                          ; DMFLAGS
  AND $01                 ; Now E=0x00 if Willy is facing right, or 0x80 if
  RRCA                    ; he's facing left
  LD E,A
  LD A,(FRAME)            ; Pick up Willy's animation frame (0-3) from FRAME
  AND $03                 ; Point DE at the sprite graphic data for Willy's
  RRCA                    ; current animation frame (see MANDAT)
  RRCA
  RRCA
  OR E
  LD E,A
  LD D,MANDAT/256
  LD A,(ROOM)             ; Pick up the number of the current room from ROOM
  CP $1D                  ; Are we in the The Nightmare Room?
  JR NZ,DRAWWILLY_0       ; Jump if not
  LD D,FLYINGPIG0/256     ; Point DE at the graphic data for the flying pig
  LD A,E                  ; sprite (FLYINGPIG0+E)
  XOR $80
  LD E,A
DRAWWILLY_0:
  LD B,$10                ; There are 16 rows of pixels to copy
  LD A,(LOCATION)         ; Pick up Willy's screen x-coordinate (0-31) from
  AND $1F                 ; LOCATION
  LD C,A                  ; Copy it to C
; This entry point is used by the routine at DRAWTOILET to draw the toilet in
; The Bathroom.
DRAWWILLY_1:
  LD A,(IX+$00)           ; Set HL to the address in the screen buffer at 24576
  LD H,(IX+$01)           ; that corresponds to where we are going to draw the
  OR C                    ; next pixel row of the sprite graphic
  LD L,A
  LD A,(DE)               ; Pick up a sprite graphic byte
  OR (HL)                 ; Merge it with the background
  LD (HL),A               ; Save the resultant byte to the screen buffer
  INC HL                  ; Move HL along to the next cell to the right
  INC DE                  ; Point DE at the next sprite graphic byte
  LD A,(DE)               ; Pick it up in A
  OR (HL)                 ; Merge it with the background
  LD (HL),A               ; Save the resultant byte to the screen buffer
  INC IX                  ; Point IX at the next entry in the screen buffer
  INC IX                  ; address lookup table at SBUFADDRS
  INC DE                  ; Point DE at the next sprite graphic byte
  DJNZ DRAWWILLY_1        ; Jump back until all 16 rows of pixels have been
                          ; drawn
  RET

; Print a message
;
; Used by the routines at TITLESCREEN, INITROOM, MAINLOOP and
; GAMEOVER.
;
; IX Address of the message
; C Length of the message
; DE Display file address
PRINTMSG:
  LD A,(IX+$00)           ; Collect a character from the message
  CALL PRINTCHAR          ; Print it
  INC IX                  ; Point IX at the next character in the message
  INC E                   ; Point DE at the next character cell (subtracting 8
  LD A,D                  ; from D compensates for the operations performed by
  SUB $08                 ; the routine at PRINTCHAR)
  LD D,A
  DEC C                   ; Have we printed the entire message yet?
  JR NZ,PRINTMSG          ; If not, jump back to print the next character
  RET

; Print a single character
;
; Used by the routines at PRINTMSG.
;
; A ASCII code of the character
; DE Display file address
PRINTCHAR:
  LD H,$07                ; Point HL at the bitmap for the character (in the
  LD L,A                  ; ROM)
  SET 7,L
  ADD HL,HL
  ADD HL,HL
  ADD HL,HL
  LD B,$08                ; There are eight pixel rows in a character bitmap
; This entry point is used by the routine at TITLESCREEN to draw a triangle UDG
; on the title screen, and by the routine at DRAWITEMS to draw an item in the
; current room.
PRINTCHAR_0:
  LD A,(HL)               ; Copy the character bitmap (or triangle UDG, or item
  LD (DE),A               ; graphic) to the screen (or screen buffer)
  INC HL
  INC D
  DJNZ PRINTCHAR_0
  RET

; Play the theme tune (Moonlight Sonata)
;
; Used by the routine at TITLESCREEN. For each of the 99 bytes in the tune data
; table at THEMETUNE, this routine produces two notes, each lasting
; approximately 0.15s; the second note is played at half the frequency of the
; first. Returns with the zero flag reset if ENTER, 0 or the fire button is
; pressed while the tune is being played.
;
; HL THEMETUNE
PLAYTUNE:
  LD A,(HL)               ; Pick up the next byte of tune data from the table
                          ; at THEMETUNE
  CP $FF                  ; Has the tune finished?
  RET Z                   ; Return (with the zero flag set) if so
  LD BC,$0064             ; B=0 (short note duration counter), C=100 (short
                          ; note counter)
  XOR A                   ; A=0 (border colour and speaker state)
  LD E,(HL)               ; Save the byte of tune data in E for retrieval
                          ; during the short note loop
  LD D,E                  ; Initialise D (pitch delay counter)
PLAYTUNE_0:
  OUT ($FE),A             ; Produce a short note (approximately 0.003s) whose
  DEC D                   ; pitch is determined by the value in E
  JR NZ,PLAYTUNE_1
  LD D,E
  XOR $18
PLAYTUNE_1:
  DJNZ PLAYTUNE_0
  EX AF,AF'               ; Save A briefly
  LD A,C                  ; Is the short note counter in C (which starts off at
  CP $32                  ; 100) down to 50 yet?
  JR NZ,PLAYTUNE_2        ; Jump if not
  RL E                    ; Otherwise double the value in E (which halves the
                          ; note frequency)
PLAYTUNE_2:
  EX AF,AF'               ; Restore the value of A
  DEC C                   ; Decrement the short note counter in C
  JR NZ,PLAYTUNE_0        ; Jump back unless we've finished playing 50 short
                          ; notes at the lower frequency
  CALL CHECKENTER         ; Check whether ENTER, 0 or the fire button is being
                          ; pressed
  RET NZ                  ; Return (with the zero flag reset) if it is
  INC HL                  ; Move HL along to the next byte of tune data
  JR PLAYTUNE             ; Jump back to play the next batch of 100 short notes

; Check whether ENTER, 0 or the fire button is being pressed
;
; Used by the routine at PLAYTUNE. Returns with the zero flag reset if ENTER, 0
; or the fire button on the joystick is being pressed.
CHECKENTER:
  LD A,(JOYSTICK)         ; Collect the Kempston joystick indicator from
                          ; JOYSTICK
  OR A                    ; Is the joystick connected?
  JR Z,CHECKENTER_0       ; Jump if not
  IN A,($1F)              ; Collect input from the joystick
  BIT 4,A                 ; Is the fire button being pressed?
  RET NZ                  ; Return (with the zero flag reset) if so
CHECKENTER_0:
  LD BC,$AFFE             ; Read keys H-J-K-L-ENTER and 6-7-8-9-0
  IN A,(C)
  AND $01                 ; Keep only bit 0 of the result (ENTER, 0)
  CP $01                  ; Reset the zero flag if ENTER or 0 is being pressed
  RET

; Play an intro message sound effect
;
; Used by the routine at TITLESCREEN.
;
; A Value between 0x32 and 0x51
INTROSOUND:
  LD E,A                  ; Save the value of A in E for later retrieval
  LD C,$FE                ; We will output to port 0xFE
INTROSOUND_0:
  LD D,A                  ; Copy A into D; bits 0-2 of D determine the initial
                          ; border colour
  RES 4,D                 ; Reset bit 4 of D (initial speaker state)
  RES 3,D                 ; Reset bit 3 of D (initial MIC state)
  LD B,E                  ; Initialise B (delay counter for the inner loop)
INTROSOUND_1:
  CP B                    ; Is it time to flip the MIC and speaker and make the
                          ; border black?
  JR NZ,INTROSOUND_2      ; Jump if not
  LD D,$18                ; Set bits 3 (MIC) and 4 (speaker) of D, and reset
                          ; bits 0-2 (black border)
INTROSOUND_2:
  OUT (C),D               ; Set the MIC state, speaker state and border colour
  DJNZ INTROSOUND_1       ; Jump back until the inner loop is finished
  DEC A                   ; Is the outer loop finished too?
  JR NZ,INTROSOUND_0      ; Jump back if not
  RET

; Unused
  DEFS $0397

; Attributes for the top two-thirds of the title screen
;
; Used by the routine at TITLESCREEN.
ATTRSUPPER:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$28,$28,$05,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$D3,$D3,$D3,$00,$D3,$D3,$D3,$00,$D3,$D3,$D3,$00
  DEFB $28,$D3,$D3,$D3,$25,$D3,$D3,$D3,$00,$D3,$D3,$D3,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$D3,$00,$00,$D3,$00,$00,$00,$00,$D3,$28,$28
  DEFB $2D,$D3,$25,$25,$24,$D3,$00,$00,$00,$00,$D3,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$D3,$00,$00,$D3,$D3,$D3,$00,$28,$D3,$2D,$2D
  DEFB $25,$D3,$D3,$D3,$24,$D3,$D3,$D3,$00,$00,$D3,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$D3,$00,$00,$D3,$00,$28,$28,$2D,$D3,$25,$25
  DEFB $24,$24,$04,$D3,$24,$D3,$00,$00,$00,$00,$D3,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$D3,$D3,$00,$00,$D3,$D3,$D3,$2D,$25,$D3,$24,$24
  DEFB $04,$D3,$D3,$D3,$24,$D3,$D3,$D3,$00,$00,$D3,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$29,$29,$2D,$2D,$2C,$2C,$04,$04
  DEFB $00,$00,$09,$09,$24,$24,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$09,$09,$29,$29,$2D,$2D,$05,$05
  DEFB $00,$00,$09,$09,$24,$24,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$D3,$00,$08,$08,$D3,$09,$D3,$29,$D3,$2D
  DEFB $05,$05,$D3,$09,$24,$D3,$00,$00,$00,$D3,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$D3,$00,$00,$00,$D3,$08,$D3,$09,$D3,$29
  DEFB $2D,$2D,$D3,$09,$24,$D3,$00,$00,$00,$D3,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$D3,$00,$D3,$00,$D3,$00,$D3,$08,$D3,$09
  DEFB $29,$29,$D3,$09,$24,$D3,$D3,$D3,$D3,$D3,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$D3,$00,$D3,$00,$D3,$00,$D3,$00,$D3,$08
  DEFB $09,$09,$D3,$09,$24,$24,$00,$D3,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$D3,$D3,$D3,$D3,$D3,$00,$D3,$00,$D3,$D3
  DEFB $D3,$08,$D3,$D3,$D3,$24,$00,$D3,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$08,$08,$04,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; Attributes for the bottom third of the screen
;
; Used by the routines at TITLESCREEN, STARTGAME and ENDPAUSE.
ATTRSLOWER:
  DEFB $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  DEFB $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $01,$02,$03,$04,$05,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
  DEFB $07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$06,$05,$04,$03,$02,$01
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $45,$45,$06,$06,$04,$04,$41,$41,$05,$05,$43,$43,$44,$44,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $45,$45,$06,$06,$04,$04,$41,$41,$05,$05,$43,$43,$44,$44,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  DEFS $40

; Foot/barrel graphic data
;
; Used by the routine at GAMEOVER to display the game over sequence.
;
; The foot also appears as a guardian in The Nightmare Room.
FOOT:
  DEFB $10,$80,$10,$80,$10,$80,$10,$80,$10,$80,$10,$80,$10,$80,$20,$80
  DEFB $20,$80,$48,$42,$88,$35,$84,$09,$80,$01,$80,$02,$43,$8D,$3C,$76
; The barrel also appears as a guardian in Ballroom East and Top Landing.
BARREL:
  DEFB $37,$EC,$77,$EE,$00,$00,$6F,$F6,$EF,$F7,$EF,$F7,$D5,$5B,$DB,$BB
  DEFB $D5,$5B,$DF,$FB,$ED,$77,$EE,$F7,$6D,$76,$00,$00,$77,$EE,$37,$EC

; Maria sprite graphic data
;
; Used by the routine at BEDANDBATH to draw Maria in Master Bedroom.
;
; Maria also appears as a guardian in The Nightmare Room.
MARIA0:
  DEFB $03,$00,$03,$C0,$01,$E0,$01,$40,$01,$E0,$07,$80,$1F,$F8,$3F,$FC
  DEFB $37,$6C,$14,$98,$0F,$F0,$0F,$F0,$0F,$F0,$02,$40,$02,$40,$06,$60
MARIA1:
  DEFB $03,$00,$03,$C0,$01,$E0,$01,$40,$01,$E0,$07,$80,$1F,$F8,$3F,$FC
  DEFB $37,$6C,$14,$98,$0F,$F0,$0F,$F0,$0F,$F0,$02,$40,$06,$40,$02,$60
MARIA2:
  DEFB $03,$00,$03,$C0,$01,$E0,$01,$40,$01,$E0,$07,$80,$1F,$FC,$3F,$FE
  DEFB $37,$66,$14,$92,$0F,$F0,$0F,$F0,$0F,$F0,$02,$40,$02,$40,$06,$60
MARIA3:
  DEFB $03,$00,$03,$C0,$01,$E0,$01,$40,$01,$E0,$07,$80,$1F,$FF,$3F,$FE
  DEFB $37,$60,$14,$90,$0F,$F0,$0F,$F0,$0F,$F0,$02,$40,$02,$40,$06,$60

; Willy sprite graphic data
;
; Used by the routines at DRAWLIVES, GAMEOVER and DRAWWILLY.
MANDAT:
  DEFB $3C,$00,$3C,$00,$7E,$00,$34,$00,$3E,$00,$3C,$00,$18,$00,$3C,$00
  DEFB $7E,$00,$7E,$00,$F7,$00,$FB,$00,$3C,$00,$76,$00,$6E,$00,$77,$00
  DEFB $0F,$00,$0F,$00,$1F,$80,$0D,$00,$0F,$80,$0F,$00,$06,$00,$0F,$00
  DEFB $1B,$80,$1B,$80,$1B,$80,$1D,$80,$0F,$00,$06,$00,$06,$00,$07,$00
WILLYR2:
  DEFB $03,$C0,$03,$C0,$07,$E0,$03,$40,$03,$E0,$03,$C0,$01,$80,$03,$C0
  DEFB $07,$E0,$07,$E0,$0F,$70,$0F,$B0,$03,$C0,$07,$60,$06,$E0,$07,$70
  DEFB $00,$F0,$00,$F0,$01,$F8,$00,$D0,$00,$F8,$00,$F0,$00,$60,$00,$F0
  DEFB $01,$F8,$03,$FC,$07,$FE,$06,$F6,$00,$F8,$01,$DA,$03,$0E,$03,$8C
  DEFB $0F,$00,$0F,$00,$1F,$80,$0B,$00,$1F,$00,$0F,$00,$06,$00,$0F,$00
  DEFB $1F,$80,$3F,$C0,$7F,$E0,$6F,$60,$1F,$00,$5B,$80,$70,$C0,$31,$C0
  DEFB $03,$C0,$03,$C0,$07,$E0,$02,$C0,$07,$C0,$03,$C0,$01,$80,$03,$C0
  DEFB $07,$E0,$07,$E0,$0E,$F0,$0D,$F0,$03,$C0,$06,$E0,$07,$60,$0E,$E0
  DEFB $00,$F0,$00,$F0,$01,$F8,$00,$B0,$01,$F0,$00,$F0,$00,$60,$00,$F0
  DEFB $01,$D8,$01,$D8,$01,$D8,$01,$B8,$00,$F0,$00,$60,$00,$60,$00,$E0
  DEFB $00,$3C,$00,$3C,$00,$7E,$00,$2C,$00,$7C,$00,$3C,$00,$18,$00,$3C
  DEFB $00,$7E,$00,$7E,$00,$EF,$00,$DF,$00,$3C,$00,$6E,$00,$76,$00,$EE

  DEFS $0200

; Entity definitions
;
; Used by the routine at INITROOM.
;
; The following (empty) entity definition (0x00) is copied into one of the
; entity buffers at ENTITYBUF for any entity specification whose first byte is
; zero.
ENTITYDEFS:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
; The following entity definition (0x01) is used in We must perform a
; Quirkafleeg, On the Roof, Cold Store, Swimming Pool and The Beach.
ENTITY1:
  DEFB %00000011          ; Rope (bits 0-2), initially swinging right to left
                          ; (bit 7)
  DEFB $22                ; Initial animation frame index
  DEFB $00                ; Replaced by the x-coordinate of the top of the rope
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $00                ; Unused
  DEFB $20                ; Length
  DEFB $00                ; Unused
  DEFB $83                ; Unused
  DEFB $36                ; Animation frame at which the rope changes direction
; The following entity definition (0x02) is used in The Security Guard, Rescue
; Esmerelda, I'm sure I've seen this before.. and Up on the Battlements.
ENTITY2:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $80                ; Initial pixel y-coordinate: 64
  DEFB $02                ; Initial pixel y-coordinate increment: 1 (moving
                          ; down)
  DEFB $BF                ; Page containing the sprite graphic data: 0xBF
  DEFB $50                ; Minimum pixel y-coordinate: 40
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x03) is used in The Security Guard, I'm
; sure I've seen this before.. and Up on the Battlements.
ENTITY3:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00101010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $A0                ; Initial pixel y-coordinate: 80
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $BF                ; Page containing the sprite graphic data: 0xBF
  DEFB $58                ; Minimum pixel y-coordinate: 44
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x04) is used in The Security Guard, Rescue
; Esmerelda, I'm sure I've seen this before.. and Up on the Battlements.
ENTITY4:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %00100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $60                ; Initial pixel y-coordinate: 48
  DEFB $08                ; Initial pixel y-coordinate increment: 4 (moving
                          ; down)
  DEFB $BF                ; Page containing the sprite graphic data: 0xBF
  DEFB $60                ; Minimum pixel y-coordinate: 48
  DEFB $C0                ; Maximum pixel y-coordinate: 96
; The following entity definition (0x05) is used in I'm sure I've seen this
; before.. and Up on the Battlements.
ENTITY5:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $40                ; Initial pixel y-coordinate: 32
  DEFB $0C                ; Initial pixel y-coordinate increment: 6 (moving
                          ; down)
  DEFB $BF                ; Page containing the sprite graphic data: 0xBF
  DEFB $40                ; Minimum pixel y-coordinate: 32
  DEFB $C0                ; Maximum pixel y-coordinate: 96
; The following entity definition (0x06) is used in At the Foot of the
; MegaTree.
ENTITY6:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $40                ; Initial pixel y-coordinate: 32
  DEFB $0A                ; Initial pixel y-coordinate increment: 5 (moving
                          ; down)
  DEFB $BF                ; Page containing the sprite graphic data: 0xBF
  DEFB $40                ; Minimum pixel y-coordinate: 32
  DEFB $B0                ; Maximum pixel y-coordinate: 88
; The following entity definition (0x07) is used in At the Foot of the MegaTree
; and Above the West Bedroom.
ENTITY7:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %01100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $64                ; Initial pixel y-coordinate: 50
  DEFB $F4                ; Initial pixel y-coordinate increment: -6 (moving
                          ; up)
  DEFB $BF                ; Page containing the sprite graphic data: 0xBF
  DEFB $20                ; Minimum pixel y-coordinate: 16
  DEFB $A0                ; Maximum pixel y-coordinate: 80
; The following entity definition (0x08) is used in At the Foot of the
; MegaTree.
ENTITY8:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %01101010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $80                ; Initial pixel y-coordinate: 64
  DEFB $06                ; Initial pixel y-coordinate increment: 3 (moving
                          ; down)
  DEFB $BF                ; Page containing the sprite graphic data: 0xBF
  DEFB $26                ; Minimum pixel y-coordinate: 19
  DEFB $B0                ; Maximum pixel y-coordinate: 88
; The following entity definition (0x09) is used in Inside the MegaTrunk and On
; a Branch Over the Drive.
ENTITY9:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00101011          ; INK 3 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $A0                ; Initial pixel y-coordinate: 80
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $BF                ; Page containing the sprite graphic data: 0xBF
  DEFB $80                ; Minimum pixel y-coordinate: 64
  DEFB $E0                ; Maximum pixel y-coordinate: 112
; The following entity definition (0x0A) is used in The Off Licence.
ENTITY10:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01101101          ; INK 5 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $60                ; Initial pixel y-coordinate: 48
  DEFB $08                ; Initial pixel y-coordinate increment: 4 (moving
                          ; down)
  DEFB $BE                ; Page containing the sprite graphic data: 0xBE
  DEFB $10                ; Minimum pixel y-coordinate: 8
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x0B) is used in Dr Jones will never believe
; this and Nomen Luni.
ENTITY11:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $C0                ; Initial pixel y-coordinate: 96
  DEFB $F6                ; Initial pixel y-coordinate increment: -5 (moving
                          ; up)
  DEFB $BF                ; Page containing the sprite graphic data: 0xBF
  DEFB $70                ; Minimum pixel y-coordinate: 56
  DEFB $C0                ; Maximum pixel y-coordinate: 96
; The following entity definition (0x0C) is used in The Off Licence.
ENTITY12:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $70                ; Pixel y-coordinate: 56
  DEFB $01                ; Unused
  DEFB $BE                ; Page containing the sprite graphic data: 0xBE
  DEFB $13                ; Minimum x-coordinate: 19
  DEFB $1D                ; Maximum x-coordinate: 29
; The following entity definition (0x0D) is used in Rescue Esmerelda, I'm sure
; I've seen this before.. and We must perform a Quirkafleeg.
ENTITY13:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $40                ; Pixel y-coordinate: 32
  DEFB $00                ; Unused
  DEFB $BC                ; Page containing the sprite graphic data: 0xBC
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $09                ; Maximum x-coordinate: 9
; The following entity definition (0x0E) is used in The Bridge.
ENTITY14:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01101100          ; INK 4 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $30                ; Initial pixel y-coordinate: 24
  DEFB $0C                ; Initial pixel y-coordinate increment: 6 (moving
                          ; down)
  DEFB $B9                ; Page containing the sprite graphic data: 0xB9
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $C0                ; Maximum pixel y-coordinate: 96
; The following entity definition (0x0F) is used in Rescue Esmerelda.
ENTITY15:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %00100111          ; INK 7 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $10                ; Initial pixel y-coordinate: 8
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $B0                ; Page containing the sprite graphic data: 0xB0
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $20                ; Maximum pixel y-coordinate: 16
; The following entity definition (0x10) is used in Entrance to Hades, The
; Chapel and Priests' Hole.
ENTITY16:
  DEFB %00000010          ; Vertical guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %00000100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 000 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $60                ; Initial pixel y-coordinate: 48
  DEFB $02                ; Initial pixel y-coordinate increment: 1 (moving
                          ; down)
  DEFB $BA                ; Page containing the sprite graphic data: 0xBA
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $B0                ; Maximum pixel y-coordinate: 88
; The following entity definition (0x11) is used in Entrance to Hades, The
; Chapel and Priests' Hole.
ENTITY17:
  DEFB %00000010          ; Vertical guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %00000100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 000 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $60                ; Initial pixel y-coordinate: 48
  DEFB $02                ; Initial pixel y-coordinate increment: 1 (moving
                          ; down)
  DEFB $BA                ; Page containing the sprite graphic data: 0xBA
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $B0                ; Maximum pixel y-coordinate: 88
; The following entity definition (0x12) is used in Entrance to Hades, The
; Chapel and Priests' Hole.
ENTITY18:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %00100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $80                ; Initial pixel y-coordinate: 64
  DEFB $02                ; Initial pixel y-coordinate increment: 1 (moving
                          ; down)
  DEFB $BA                ; Page containing the sprite graphic data: 0xBA
  DEFB $20                ; Minimum pixel y-coordinate: 16
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x13) is used in Ballroom East and Top
; Landing.
ENTITY19:
  DEFB %00000010          ; Vertical guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %00001010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 000 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $20                ; Initial pixel y-coordinate: 16
  DEFB $02                ; Initial pixel y-coordinate increment: 1 (moving
                          ; down)
  DEFB $9C                ; Page containing the sprite graphic data: 0x9C
  DEFB $20                ; Minimum pixel y-coordinate: 16
  DEFB $60                ; Maximum pixel y-coordinate: 48
; The following entity definition (0x14) is used in The Bridge and West  Wing.
ENTITY20:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11101010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $A0                ; Pixel y-coordinate: 80
  DEFB $00                ; Unused
  DEFB $BC                ; Page containing the sprite graphic data: 0xBC
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $0A                ; Maximum x-coordinate: 10
; The following entity definition (0x15) is used in The Bridge, The Drive and
; Ballroom East.
ENTITY21:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %11100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $A0                ; Pixel y-coordinate: 80
  DEFB $00                ; Unused
  DEFB $BC                ; Page containing the sprite graphic data: 0xBC
  DEFB $0E                ; Minimum x-coordinate: 14
  DEFB $1D                ; Maximum x-coordinate: 29
; The following entity definition (0x16) is used in The Drive and Inside the
; MegaTrunk.
ENTITY22:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $B0                ; Pixel y-coordinate: 88
  DEFB $01                ; Unused
  DEFB $BC                ; Page containing the sprite graphic data: 0xBC
  DEFB $10                ; Minimum x-coordinate: 16
  DEFB $1D                ; Maximum x-coordinate: 29
; The following entity definition (0x17) is used in The Drive.
ENTITY23:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $80                ; Pixel y-coordinate: 64
  DEFB $00                ; Unused
  DEFB $BC                ; Page containing the sprite graphic data: 0xBC
  DEFB $05                ; Minimum x-coordinate: 5
  DEFB $1D                ; Maximum x-coordinate: 29
; The following entity definition (0x18) is used in The Drive, Inside the
; MegaTrunk and Tree Top.
ENTITY24:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11101101          ; INK 5 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $50                ; Pixel y-coordinate: 40
  DEFB $00                ; Unused
  DEFB $BC                ; Page containing the sprite graphic data: 0xBC
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $0A                ; Maximum x-coordinate: 10
; The following entity definition (0x19) is used in Out on a limb.
ENTITY25:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11101011          ; INK 3 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $70                ; Pixel y-coordinate: 56
  DEFB $00                ; Unused
  DEFB $BC                ; Page containing the sprite graphic data: 0xBC
  DEFB $0E                ; Minimum x-coordinate: 14
  DEFB $17                ; Maximum x-coordinate: 23
; The following entity definition (0x1A) is used in Under the MegaTree, The
; Hall, Tree Top and Emergency Generator.
ENTITY26:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11101010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $30                ; Pixel y-coordinate: 24
  DEFB $00                ; Unused
  DEFB $B6                ; Page containing the sprite graphic data: 0xB6
  DEFB $05                ; Minimum x-coordinate: 5
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x1B) is used in On a Branch Over the Drive,
; Orangery, Dr Jones will never believe this and The Yacht.
ENTITY27:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01101010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $90                ; Initial pixel y-coordinate: 72
  DEFB $FC                ; Initial pixel y-coordinate increment: -2 (moving
                          ; up)
  DEFB $B2                ; Page containing the sprite graphic data: 0xB2
  DEFB $80                ; Minimum pixel y-coordinate: 64
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x1C) is used in Under the Drive and West
; Wing Roof.
ENTITY28:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $B0                ; Pixel y-coordinate: 88
  DEFB $00                ; Unused
  DEFB $BC                ; Page containing the sprite graphic data: 0xBC
  DEFB $0C                ; Minimum x-coordinate: 12
  DEFB $1D                ; Maximum x-coordinate: 29
; The following entity definition (0x1D) is used in On top of the house, Under
; the Drive, Nomen Luni and Back Stairway.
ENTITY29:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $30                ; Initial pixel y-coordinate: 24
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $B2                ; Page containing the sprite graphic data: 0xB2
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $80                ; Maximum pixel y-coordinate: 64
; The following entity definition (0x1E) is used in Tree Root and West Bedroom.
ENTITY30:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %11100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $40                ; Initial pixel y-coordinate: 32
  DEFB $FC                ; Initial pixel y-coordinate increment: -2 (moving
                          ; up)
  DEFB $AD                ; Page containing the sprite graphic data: 0xAD
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $80                ; Maximum pixel y-coordinate: 64
; The following entity definition (0x1F) is used in Tree Root.
ENTITY31:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %00100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $90                ; Initial pixel y-coordinate: 72
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $B7                ; Page containing the sprite graphic data: 0xB7
  DEFB $40                ; Minimum pixel y-coordinate: 32
  DEFB $A0                ; Maximum pixel y-coordinate: 80
; The following entity definition (0x20) is used in Under the MegaTree.
ENTITY32:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $D0                ; Pixel y-coordinate: 104
  DEFB $01                ; Unused
  DEFB $B8                ; Page containing the sprite graphic data: 0xB8
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x21) is used in Ballroom West.
ENTITY33:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $B0                ; Pixel y-coordinate: 88
  DEFB $00                ; Unused
  DEFB $B8                ; Page containing the sprite graphic data: 0xB8
  DEFB $10                ; Minimum x-coordinate: 16
  DEFB $1A                ; Maximum x-coordinate: 26
; The following entity definition (0x22) is used in On the Roof.
ENTITY34:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %11100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $D0                ; Pixel y-coordinate: 104
  DEFB $01                ; Unused
  DEFB $B8                ; Page containing the sprite graphic data: 0xB8
  DEFB $0E                ; Minimum x-coordinate: 14
  DEFB $18                ; Maximum x-coordinate: 24
; The following entity definition (0x23) is used in Tree Root.
ENTITY35:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %11101010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $90                ; Pixel y-coordinate: 72
  DEFB $00                ; Unused
  DEFB $B8                ; Page containing the sprite graphic data: 0xB8
  DEFB $0F                ; Minimum x-coordinate: 15
  DEFB $17                ; Maximum x-coordinate: 23
; The following entity definition (0x24) is used in The Drive, Top Landing and
; Back Stairway.
ENTITY36:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %01100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $D0                ; Pixel y-coordinate: 104
  DEFB $00                ; Unused
  DEFB $AF                ; Page containing the sprite graphic data: 0xAF
  DEFB $0A                ; Minimum x-coordinate: 10
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x25) is used in Priests' Hole.
ENTITY37:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11101010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $A0                ; Pixel y-coordinate: 80
  DEFB $00                ; Unused
  DEFB $BC                ; Page containing the sprite graphic data: 0xBC
  DEFB $08                ; Minimum x-coordinate: 8
  DEFB $18                ; Maximum x-coordinate: 24
; The following entity definition (0x26) is used in Halfway up the East Wall.
ENTITY38:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01101110          ; INK 6 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $60                ; Pixel y-coordinate: 48
  DEFB $00                ; Unused
  DEFB $AE                ; Page containing the sprite graphic data: 0xAE
  DEFB $02                ; Minimum x-coordinate: 2
  DEFB $07                ; Maximum x-coordinate: 7
; The following entity definition (0x27) is used in Cuckoo's Nest and Under the
; Roof.
ENTITY39:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $80                ; Pixel y-coordinate: 64
  DEFB $00                ; Unused
  DEFB $AF                ; Page containing the sprite graphic data: 0xAF
  DEFB $0C                ; Minimum x-coordinate: 12
  DEFB $12                ; Maximum x-coordinate: 18
; The following entity definition (0x28) is used in Ballroom East, Ballroom
; West and Tree Root.
ENTITY40:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01000101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 010 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $70                ; Initial pixel y-coordinate: 56
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $BA                ; Page containing the sprite graphic data: 0xBA
  DEFB $60                ; Minimum pixel y-coordinate: 48
  DEFB $C0                ; Maximum pixel y-coordinate: 96
; The following entity definition (0x29) is used in Ballroom East.
ENTITY41:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $96                ; Initial pixel y-coordinate: 75
  DEFB $02                ; Initial pixel y-coordinate increment: 1 (moving
                          ; down)
  DEFB $BA                ; Page containing the sprite graphic data: 0xBA
  DEFB $90                ; Minimum pixel y-coordinate: 72
  DEFB $C0                ; Maximum pixel y-coordinate: 96
; The following entity definition (0x2A) is used in Under the MegaTree,
; Ballroom East and Ballroom West.
ENTITY42:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01001011          ; INK 3 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 010 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $90                ; Initial pixel y-coordinate: 72
  DEFB $FA                ; Initial pixel y-coordinate increment: -3 (moving
                          ; up)
  DEFB $BA                ; Page containing the sprite graphic data: 0xBA
  DEFB $60                ; Minimum pixel y-coordinate: 48
  DEFB $AE                ; Maximum pixel y-coordinate: 87
; The following entity definition (0x2B) is not used.
ENTITY43:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %01001010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 010 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $B0                ; Initial pixel y-coordinate: 88
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $BA                ; Page containing the sprite graphic data: 0xBA
  DEFB $90                ; Minimum pixel y-coordinate: 72
  DEFB $B8                ; Maximum pixel y-coordinate: 92
; The following entity definition (0x2C) is used in The Off Licence and Inside
; the MegaTrunk.
ENTITY44:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01001010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 010 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $40                ; Initial pixel y-coordinate: 32
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $BA                ; Page containing the sprite graphic data: 0xBA
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x2D) is used in Out on a limb and East Wall
; Base.
ENTITY45:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01000101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 010 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $B0                ; Initial pixel y-coordinate: 88
  DEFB $08                ; Initial pixel y-coordinate increment: 4 (moving
                          ; down)
  DEFB $BA                ; Page containing the sprite graphic data: 0xBA
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x2E) is used in Tree Top.
ENTITY46:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $A0                ; Pixel y-coordinate: 80
  DEFB $00                ; Unused
  DEFB $BB                ; Page containing the sprite graphic data: 0xBB
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $13                ; Maximum x-coordinate: 19
; The following entity definition (0x2F) is used in Inside the MegaTrunk.
ENTITY47:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01101110          ; INK 6 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $30                ; Pixel y-coordinate: 24
  DEFB $00                ; Unused
  DEFB $BB                ; Page containing the sprite graphic data: 0xBB
  DEFB $11                ; Minimum x-coordinate: 17
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x30) is used in The Kitchen and West of
; Kitchen.
ENTITY48:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00101011          ; INK 3 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $40                ; Initial pixel y-coordinate: 32
  DEFB $06                ; Initial pixel y-coordinate increment: 3 (moving
                          ; down)
  DEFB $B7                ; Page containing the sprite graphic data: 0xB7
  DEFB $10                ; Minimum pixel y-coordinate: 8
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x31) is used in The Kitchen and West of
; Kitchen.
ENTITY49:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %00100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $C0                ; Initial pixel y-coordinate: 96
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $B7                ; Page containing the sprite graphic data: 0xB7
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x32) is used in The Kitchen and West of
; Kitchen.
ENTITY50:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %00100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $80                ; Initial pixel y-coordinate: 64
  DEFB $F8                ; Initial pixel y-coordinate increment: -4 (moving
                          ; up)
  DEFB $B7                ; Page containing the sprite graphic data: 0xB7
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x33) is used in West Bedroom and Above the
; West Bedroom.
ENTITY51:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %00101010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $30                ; Initial pixel y-coordinate: 24
  DEFB $02                ; Initial pixel y-coordinate increment: 1 (moving
                          ; down)
  DEFB $B7                ; Page containing the sprite graphic data: 0xB7
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $A0                ; Maximum pixel y-coordinate: 80
; The following entity definition (0x34) is used in The Wine Cellar, Tool  Shed
; and West Wing Roof.
ENTITY52:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $D0                ; Pixel y-coordinate: 104
  DEFB $00                ; Unused
  DEFB $B5                ; Page containing the sprite graphic data: 0xB5
  DEFB $07                ; Minimum x-coordinate: 7
  DEFB $16                ; Maximum x-coordinate: 22
; The following entity definition (0x35) is used in At the Foot of the MegaTree
; and The Yacht.
ENTITY53:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11101011          ; INK 3 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $D0                ; Pixel y-coordinate: 104
  DEFB $00                ; Unused
  DEFB $B5                ; Page containing the sprite graphic data: 0xB5
  DEFB $04                ; Minimum x-coordinate: 4
  DEFB $0E                ; Maximum x-coordinate: 14
; The following entity definition (0x36) is used in Cold Store.
ENTITY54:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $D0                ; Pixel y-coordinate: 104
  DEFB $00                ; Unused
  DEFB $BD                ; Page containing the sprite graphic data: 0xBD
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $18                ; Maximum x-coordinate: 24
; The following entity definition (0x37) is used in Cold Store and Under the
; Roof.
ENTITY55:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %01100111          ; INK 7 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $90                ; Pixel y-coordinate: 72
  DEFB $00                ; Unused
  DEFB $BB                ; Page containing the sprite graphic data: 0xBB
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $05                ; Maximum x-coordinate: 5
; The following entity definition (0x38) is used in Cold Store.
ENTITY56:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %11100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $60                ; Pixel y-coordinate: 48
  DEFB $00                ; Unused
  DEFB $BD                ; Page containing the sprite graphic data: 0xBD
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $06                ; Maximum x-coordinate: 6
; The following entity definition (0x39) is used in Cold Store.
ENTITY57:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %01100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $30                ; Pixel y-coordinate: 24
  DEFB $00                ; Unused
  DEFB $BB                ; Page containing the sprite graphic data: 0xBB
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $09                ; Maximum x-coordinate: 9
; The following entity definition (0x3A) is used in Top Landing.
ENTITY58:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01100111          ; INK 7 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $40                ; Initial pixel y-coordinate: 32
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $AD                ; Page containing the sprite graphic data: 0xAD
  DEFB $20                ; Minimum pixel y-coordinate: 16
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x3B) is used in The Bathroom.
ENTITY59:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $30                ; Pixel y-coordinate: 24
  DEFB $00                ; Unused
  DEFB $B9                ; Page containing the sprite graphic data: 0xB9
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $1B                ; Maximum x-coordinate: 27
; The following entity definition (0x3C) is used in Cuckoo's Nest, On a Branch
; Over the Drive, The Hall, I'm sure I've seen this before.., We must perform a
; Quirkafleeg, Orangery, The Attic, Under the Roof, West Wing Roof and The
; Beach.
ENTITY60:
  DEFB %10000100          ; Arrow (bits 0-2), flying left to right (bit 7)
  DEFB $06                ; Unused
  DEFB $00                ; Replaced by the pixel y-coordinate (copied from the
                          ; second byte of the entity specification in the room
                          ; definition)
  DEFB $00                ; Unused
  DEFB $D0                ; Initial x-coordinate: 208
  DEFB $00                ; Unused
  DEFB %10000010          ; Top/bottom pixel row (drawn either side of the
                          ; shaft)
  DEFB $00                ; Unused
; The following entity definition (0x3D) is used in On a Branch Over the Drive
; and Conservatory Roof.
ENTITY61:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %01100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $50                ; Pixel y-coordinate: 40
  DEFB $00                ; Unused
  DEFB $AD                ; Page containing the sprite graphic data: 0xAD
  DEFB $10                ; Minimum x-coordinate: 16
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x3E) is used in On a Branch Over the Drive.
ENTITY62:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %01100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $60                ; Initial pixel y-coordinate: 48
  DEFB $02                ; Initial pixel y-coordinate increment: 1 (moving
                          ; down)
  DEFB $B9                ; Page containing the sprite graphic data: 0xB9
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $70                ; Maximum pixel y-coordinate: 56
; The following entity definition (0x3F) is not used.
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00
; The following entity definition (0x40) is used in The Wine Cellar.
ENTITY64:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $30                ; Pixel y-coordinate: 24
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $1B                ; Maximum x-coordinate: 27
; The following entity definition (0x41) is used in The Wine Cellar.
ENTITY65:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %11100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $60                ; Pixel y-coordinate: 48
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $04                ; Minimum x-coordinate: 4
  DEFB $1B                ; Maximum x-coordinate: 27
; The following entity definition (0x42) is used in The Wine Cellar.
ENTITY66:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $90                ; Pixel y-coordinate: 72
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $02                ; Minimum x-coordinate: 2
  DEFB $1B                ; Maximum x-coordinate: 27
; The following entity definition (0x43) is used in First Landing.
ENTITY67:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %11100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $C0                ; Pixel y-coordinate: 96
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $18                ; Minimum x-coordinate: 24
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x44) is used in Under the Drive.
ENTITY68:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $80                ; Pixel y-coordinate: 64
  DEFB $00                ; Unused
  DEFB $AE                ; Page containing the sprite graphic data: 0xAE
  DEFB $15                ; Minimum x-coordinate: 21
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x45) is used in The Hall, Tree Top, I'm
; sure I've seen this before.., Up on the Battlements, A bit of tree and The
; Attic.
ENTITY69:
  DEFB %00000100          ; Arrow (bits 0-2), flying right to left (bit 7)
  DEFB $06                ; Unused
  DEFB $00                ; Replaced by the pixel y-coordinate (copied from the
                          ; second byte of the entity specification in the room
                          ; definition)
  DEFB $00                ; Unused
  DEFB $1C                ; Initial x-coordinate: 28
  DEFB $00                ; Unused
  DEFB %01000001          ; Top/bottom pixel row (drawn either side of the
                          ; shaft)
  DEFB $00                ; Unused
; The following entity definition (0x46) is used in The Nightmare Room.
ENTITY70:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $40                ; Initial pixel y-coordinate: 32
  DEFB $FC                ; Initial pixel y-coordinate increment: -2 (moving
                          ; up)
  DEFB $9C                ; Page containing the sprite graphic data: 0x9C
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $A0                ; Maximum pixel y-coordinate: 80
; The following entity definition (0x47) is used in The Nightmare Room.
ENTITY71:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %00100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $20                ; Initial pixel y-coordinate: 16
  DEFB $02                ; Initial pixel y-coordinate increment: 1 (moving
                          ; down)
  DEFB $9C                ; Page containing the sprite graphic data: 0x9C
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x48) is used in The Nightmare Room.
ENTITY72:
  DEFB %00010010          ; Vertical guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %00000110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 000 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $90                ; Initial pixel y-coordinate: 72
  DEFB $06                ; Initial pixel y-coordinate increment: 3 (moving
                          ; down)
  DEFB $9C                ; Page containing the sprite graphic data: 0x9C
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $C0                ; Maximum pixel y-coordinate: 96
; The following entity definition (0x49) is used in The Nightmare Room.
ENTITY73:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01101010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $80                ; Initial pixel y-coordinate: 64
  DEFB $F8                ; Initial pixel y-coordinate increment: -4 (moving
                          ; up)
  DEFB $9C                ; Page containing the sprite graphic data: 0x9C
  DEFB $10                ; Minimum pixel y-coordinate: 8
  DEFB $D0                ; Maximum pixel y-coordinate: 104
; The following entity definition (0x4A) is used in The Forgotten Abbey.
ENTITY74:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %11100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $50                ; Pixel y-coordinate: 40
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $04                ; Minimum x-coordinate: 4
  DEFB $14                ; Maximum x-coordinate: 20
; The following entity definition (0x4B) is used in The Forgotten Abbey.
ENTITY75:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %11100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $50                ; Pixel y-coordinate: 40
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $0C                ; Minimum x-coordinate: 12
  DEFB $1C                ; Maximum x-coordinate: 28
; The following entity definition (0x4C) is used in The Forgotten Abbey.
ENTITY76:
  DEFB %00100001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 1 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11101010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $90                ; Pixel y-coordinate: 72
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $09                ; Minimum x-coordinate: 9
  DEFB $14                ; Maximum x-coordinate: 20
; The following entity definition (0x4D) is used in The Forgotten Abbey.
ENTITY77:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %11100111          ; INK 7 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $90                ; Pixel y-coordinate: 72
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $16                ; Minimum x-coordinate: 22
  DEFB $1B                ; Maximum x-coordinate: 27
; The following entity definition (0x4E) is used in The Forgotten Abbey and
; Swimming Pool.
ENTITY78:
  DEFB %00100001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 1 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $D0                ; Pixel y-coordinate: 104
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $05                ; Minimum x-coordinate: 5
  DEFB $0C                ; Maximum x-coordinate: 12
; The following entity definition (0x4F) is used in The Forgotten Abbey.
ENTITY79:
  DEFB %01000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 2 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11101001          ; INK 1 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $D0                ; Pixel y-coordinate: 104
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $0B                ; Minimum x-coordinate: 11
  DEFB $12                ; Maximum x-coordinate: 18
; The following entity definition (0x50) is used in The Forgotten Abbey.
ENTITY80:
  DEFB %01100001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 3 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $D0                ; Pixel y-coordinate: 104
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $10                ; Minimum x-coordinate: 16
  DEFB $17                ; Maximum x-coordinate: 23
; The following entity definition (0x51) is used in The Forgotten Abbey.
ENTITY81:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100010          ; INK 2 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $D0                ; Pixel y-coordinate: 104
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $17                ; Minimum x-coordinate: 23
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x52) is used in The Attic.
ENTITY82:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $84                ; Initial pixel y-coordinate: 66
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $B0                ; Page containing the sprite graphic data: 0xB0
  DEFB $70                ; Minimum pixel y-coordinate: 56
  DEFB $B0                ; Maximum pixel y-coordinate: 88
; The following entity definition (0x53) is used in The Attic.
ENTITY83:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $8C                ; Initial pixel y-coordinate: 70
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $B0                ; Page containing the sprite graphic data: 0xB0
  DEFB $70                ; Minimum pixel y-coordinate: 56
  DEFB $B0                ; Maximum pixel y-coordinate: 88
; The following entity definition (0x54) is used in The Attic.
ENTITY84:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00101001          ; INK 1 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $94                ; Initial pixel y-coordinate: 74
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $B0                ; Page containing the sprite graphic data: 0xB0
  DEFB $70                ; Minimum pixel y-coordinate: 56
  DEFB $B0                ; Maximum pixel y-coordinate: 88
; The following entity definition (0x55) is used in The Attic.
ENTITY85:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $9C                ; Initial pixel y-coordinate: 78
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $B0                ; Page containing the sprite graphic data: 0xB0
  DEFB $70                ; Minimum pixel y-coordinate: 56
  DEFB $B0                ; Maximum pixel y-coordinate: 88
; The following entity definition (0x56) is used in The Attic.
ENTITY86:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00100010          ; INK 2 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $A4                ; Initial pixel y-coordinate: 82
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $B0                ; Page containing the sprite graphic data: 0xB0
  DEFB $70                ; Minimum pixel y-coordinate: 56
  DEFB $B0                ; Maximum pixel y-coordinate: 88
; The following entity definition (0x57) is used in The Attic.
ENTITY87:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $AC                ; Initial pixel y-coordinate: 86
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $B0                ; Page containing the sprite graphic data: 0xB0
  DEFB $70                ; Minimum pixel y-coordinate: 56
  DEFB $B0                ; Maximum pixel y-coordinate: 88
; The following entity definition (0x58) is used in Out on a limb and The
; Banyan Tree.
ENTITY88:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $A0                ; Pixel y-coordinate: 80
  DEFB $00                ; Unused
  DEFB $B5                ; Page containing the sprite graphic data: 0xB5
  DEFB $13                ; Minimum x-coordinate: 19
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x59) is used in The Hall and West  Wing.
ENTITY89:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %00100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 001 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $60                ; Initial pixel y-coordinate: 48
  DEFB $00                ; Initial pixel y-coordinate increment: 0 (not
                          ; moving)
  DEFB $B0                ; Page containing the sprite graphic data: 0xB0
  DEFB $50                ; Minimum pixel y-coordinate: 40
  DEFB $70                ; Maximum pixel y-coordinate: 56
; The following entity definition (0x5A) is used in To the Kitchens    Main
; Stairway.
ENTITY90:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %01100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $30                ; Pixel y-coordinate: 24
  DEFB $00                ; Unused
  DEFB $AE                ; Page containing the sprite graphic data: 0xAE
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $0B                ; Maximum x-coordinate: 11
; The following entity definition (0x5B) is used in To the Kitchens    Main
; Stairway.
ENTITY91:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $30                ; Pixel y-coordinate: 24
  DEFB $00                ; Unused
  DEFB $BE                ; Page containing the sprite graphic data: 0xBE
  DEFB $0D                ; Minimum x-coordinate: 13
  DEFB $15                ; Maximum x-coordinate: 21
; The following entity definition (0x5C) is used in To the Kitchens    Main
; Stairway and Back Stairway.
ENTITY92:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01100111          ; INK 7 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $01                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $60                ; Pixel y-coordinate: 48
  DEFB $00                ; Unused
  DEFB $B7                ; Page containing the sprite graphic data: 0xB7
  DEFB $0C                ; Minimum x-coordinate: 12
  DEFB $18                ; Maximum x-coordinate: 24
; The following entity definition (0x5D) is used in To the Kitchens    Main
; Stairway.
ENTITY93:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %01100010          ; INK 2 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $90                ; Pixel y-coordinate: 72
  DEFB $00                ; Unused
  DEFB $B9                ; Page containing the sprite graphic data: 0xB9
  DEFB $02                ; Minimum x-coordinate: 2
  DEFB $06                ; Maximum x-coordinate: 6
; The following entity definition (0x5E) is used in To the Kitchens    Main
; Stairway.
ENTITY94:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $C0                ; Pixel y-coordinate: 96
  DEFB $00                ; Unused
  DEFB $AF                ; Page containing the sprite graphic data: 0xAF
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x5F) is used in The Hall and To the
; Kitchens    Main Stairway.
ENTITY95:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $A0                ; Pixel y-coordinate: 80
  DEFB $00                ; Unused
  DEFB $BC                ; Page containing the sprite graphic data: 0xBC
  DEFB $09                ; Minimum x-coordinate: 9
  DEFB $11                ; Maximum x-coordinate: 17
; The following entity definition (0x60) is used in East Wall Base.
ENTITY96:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %01101010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $90                ; Initial pixel y-coordinate: 72
  DEFB $FC                ; Initial pixel y-coordinate increment: -2 (moving
                          ; up)
  DEFB $AC                ; Page containing the sprite graphic data: 0xAC
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $C0                ; Maximum pixel y-coordinate: 96
; The following entity definition (0x61) is used in Orangery and West  Wing.
ENTITY97:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $40                ; Initial pixel y-coordinate: 32
  DEFB $08                ; Initial pixel y-coordinate increment: 4 (moving
                          ; down)
  DEFB $AC                ; Page containing the sprite graphic data: 0xAC
  DEFB $00                ; Minimum pixel y-coordinate: 0
  DEFB $C0                ; Maximum pixel y-coordinate: 96
; The following entity definition (0x62) is used in Tool  Shed.
ENTITY98:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %01100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $90                ; Pixel y-coordinate: 72
  DEFB $00                ; Unused
  DEFB $AF                ; Page containing the sprite graphic data: 0xAF
  DEFB $07                ; Minimum x-coordinate: 7
  DEFB $14                ; Maximum x-coordinate: 20
; The following entity definition (0x63) is used in Tool  Shed.
ENTITY99:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $60                ; Pixel y-coordinate: 48
  DEFB $00                ; Unused
  DEFB $AD                ; Page containing the sprite graphic data: 0xAD
  DEFB $07                ; Minimum x-coordinate: 7
  DEFB $11                ; Maximum x-coordinate: 17
; The following entity definition (0x64) is used in The Chapel and The Banyan
; Tree.
ENTITY100:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $80                ; Initial pixel y-coordinate: 64
  DEFB $FE                ; Initial pixel y-coordinate increment: -1 (moving
                          ; up)
  DEFB $AC                ; Page containing the sprite graphic data: 0xAC
  DEFB $70                ; Minimum pixel y-coordinate: 56
  DEFB $A0                ; Maximum pixel y-coordinate: 80
; The following entity definition (0x65) is used in The Banyan Tree and A bit
; of tree.
ENTITY101:
  DEFB %00000010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every second pass (bit 4), initial
                          ; animation frame 0 (bits 5 and 6)
  DEFB %01101011          ; INK 3 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $60                ; Initial pixel y-coordinate: 48
  DEFB $04                ; Initial pixel y-coordinate increment: 2 (moving
                          ; down)
  DEFB $AB                ; Page containing the sprite graphic data: 0xAB
  DEFB $50                ; Minimum pixel y-coordinate: 40
  DEFB $A0                ; Maximum pixel y-coordinate: 80
; The following entity definition (0x66) is used in The Chapel and The Banyan
; Tree.
ENTITY102:
  DEFB %00010010          ; Vertical guardian (bits 0-2), animation frame
                          ; updated on every pass (bit 4), initial animation
                          ; frame 0 (bits 5 and 6)
  DEFB %01100101          ; INK 5 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and x-coordinate
                          ; (copied from the second byte of the entity
                          ; specification in the room definition)
  DEFB $98                ; Initial pixel y-coordinate: 76
  DEFB $02                ; Initial pixel y-coordinate increment: 1 (moving
                          ; down)
  DEFB $AB                ; Page containing the sprite graphic data: 0xAB
  DEFB $50                ; Minimum pixel y-coordinate: 40
  DEFB $A0                ; Maximum pixel y-coordinate: 80
; The following entity definition (0x67) is used in The Chapel.
ENTITY103:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $C0                ; Pixel y-coordinate: 96
  DEFB $00                ; Unused
  DEFB $B4                ; Page containing the sprite graphic data: 0xB4
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $0F                ; Maximum x-coordinate: 15
; The following entity definition (0x68) is used in A bit of tree and Nomen
; Luni.
ENTITY104:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $20                ; Pixel y-coordinate: 16
  DEFB $00                ; Unused
  DEFB $BC                ; Page containing the sprite graphic data: 0xBC
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $0A                ; Maximum x-coordinate: 10
; The following entity definition (0x69) is used in The Bow.
ENTITY105:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $30                ; Pixel y-coordinate: 24
  DEFB $00                ; Unused
  DEFB $BE                ; Page containing the sprite graphic data: 0xBE
  DEFB $16                ; Minimum x-coordinate: 22
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x6A) is used in Conservatory Roof.
ENTITY106:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01101010          ; INK 2 (bits 0-2), BRIGHT 1 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $B0                ; Pixel y-coordinate: 88
  DEFB $00                ; Unused
  DEFB $AE                ; Page containing the sprite graphic data: 0xAE
  DEFB $11                ; Minimum x-coordinate: 17
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x6B) is used in Nomen Luni.
ENTITY107:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %01100100          ; INK 4 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $30                ; Pixel y-coordinate: 24
  DEFB $00                ; Unused
  DEFB $BE                ; Page containing the sprite graphic data: 0xBE
  DEFB $12                ; Minimum x-coordinate: 18
  DEFB $16                ; Maximum x-coordinate: 22
; The following entity definition (0x6C) is used in Watch Tower.
ENTITY108:
  DEFB %10000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving left to
                          ; right (bit 7)
  DEFB %01100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $90                ; Pixel y-coordinate: 72
  DEFB $00                ; Unused
  DEFB $BB                ; Page containing the sprite graphic data: 0xBB
  DEFB $0B                ; Minimum x-coordinate: 11
  DEFB $12                ; Maximum x-coordinate: 18
; The following entity definition (0x6D) is used in Watch Tower.
ENTITY109:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %11100110          ; INK 6 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 111 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $70                ; Pixel y-coordinate: 56
  DEFB $00                ; Unused
  DEFB $BC                ; Page containing the sprite graphic data: 0xBC
  DEFB $09                ; Minimum x-coordinate: 9
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x6E) is used in The Bow.
ENTITY110:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $D0                ; Pixel y-coordinate: 104
  DEFB $00                ; Unused
  DEFB $AE                ; Page containing the sprite graphic data: 0xAE
  DEFB $11                ; Minimum x-coordinate: 17
  DEFB $1E                ; Maximum x-coordinate: 30
; The following entity definition (0x6F) is used in Cuckoo's Nest.
ENTITY111:
  DEFB %00000001          ; Horizontal guardian (bits 0-2), initial animation
                          ; frame 0 (bits 5 and 6), initially moving right to
                          ; left (bit 7)
  DEFB %01100011          ; INK 3 (bits 0-2), BRIGHT 0 (bit 3), animation frame
                          ; mask 011 (bits 5-7)
  DEFB $00                ; Replaced by the base sprite index and initial
                          ; x-coordinate (copied from the second byte of the
                          ; entity specification in the room definition)
  DEFB $B0                ; Pixel y-coordinate: 88
  DEFB $00                ; Unused
  DEFB $B5                ; Page containing the sprite graphic data: 0xB5
  DEFB $00                ; Minimum x-coordinate: 0
  DEFB $0B                ; Maximum x-coordinate: 11
; The next 15 entity definitions (0x70-0x7E) are unused.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
; The following entity definition (0x7F) - whose eighth byte is at FIRSTITEM -
; is copied into one of the entity buffers at ENTITYBUF for any entity
; specification whose first byte is 0x7F or 0xFF; the first byte of the
; definition (0xFF) serves to terminate the entity buffers.
ENTITY127:
  DEFB $FF,$00,$00,$00,$00,$00,$00

; Index of the first item
;
; Used by the routines at TITLESCREEN and DRAWITEMS.
FIRSTITEM:
  DEFB $AD

; Item table
;
; Used by the routines at TITLESCREEN and DRAWITEMS.
;
; The location of item N (0xAD<=N<=0xFF) is defined by the pair of bytes at
; addresses ITEMTABLE1+N and ITEMTABLE2+N. The meaning of the bits in each
; byte-pair is as follows:
;
; +--------+----------------------------------------------------+
; | Bit(s) | Meaning                                            |
; +--------+----------------------------------------------------+
; | 15     | Most significant bit of the y-coordinate           |
; | 14     | Collection flag (reset=collected, set=uncollected) |
; | 8-13   | Room number                                        |
; | 5-7    | Least significant bits of the y-coordinate         |
; | 0-4    | x-coordinate                                       |
; +--------+----------------------------------------------------+
ITEMTABLE1:
  DEFS $AD                ; Unused
  DEFB $B2                ; Item 0xAD at (8,25) in Watch Tower
  DEFB $B2                ; Item 0xAE at (9,10) in Watch Tower
  DEFB $B2                ; Item 0xAF at (9,20) in Watch Tower
  DEFB $B2                ; Item 0xB0 at (9,24) in Watch Tower
  DEFB $B8                ; Item 0xB1 at (14,9) in West Wing Roof
  DEFB $B8                ; Item 0xB2 at (13,19) in West Wing Roof
  DEFB $B8                ; Item 0xB3 at (11,27) in West Wing Roof
  DEFB $B8                ; Item 0xB4 at (10,6) in West Wing Roof
  DEFB $AB                ; Item 0xB5 at (8,31) in Conservatory Roof
  DEFB $AB                ; Item 0xB6 at (8,25) in Conservatory Roof
  DEFB $AB                ; Item 0xB7 at (8,28) in Conservatory Roof
  DEFB $AB                ; Item 0xB8 at (8,22) in Conservatory Roof
  DEFB $9F                ; Item 0xB9 at (11,4) in Swimming Pool
  DEFB $92                ; Item 0xBA at (12,25) in On the Roof
  DEFB $0F                ; Item 0xBB at (4,31) in I'm sure I've seen this
                          ; before..
  DEFB $10                ; Item 0xBC at (4,31) in We must perform a
                          ; Quirkafleeg
  DEFB $11                ; Item 0xBD at (4,31) in Up on the Battlements
  DEFB $BC                ; Item 0xBE at (8,26) in The Bow
  DEFB $BB                ; Item 0xBF at (14,13) in The Yacht
  DEFB $BA                ; Item 0xC0 at (13,22) in The Beach
  DEFB $25                ; Item 0xC1 at (1,28) in Orangery
  DEFB $25                ; Item 0xC2 at (6,16) in Orangery
  DEFB $A5                ; Item 0xC3 at (13,6) in Orangery
  DEFB $1B                ; Item 0xC4 at (6,29) in The Chapel
  DEFB $B9                ; Item 0xC5 at (9,23) in Above the West Bedroom
  DEFB $BA                ; Item 0xC6 at (13,22) in The Beach
  DEFB $1C                ; Item 0xC7 at (3,26) in First Landing
  DEFB $A2                ; Item 0xC8 at (9,2) in Top Landing
  DEFB $19                ; Item 0xC9 at (2,3) in Cold Store
  DEFB $19                ; Item 0xCA at (5,8) in Cold Store
  DEFB $99                ; Item 0xCB at (8,6) in Cold Store
  DEFB $99                ; Item 0xCC at (11,6) in Cold Store
  DEFB $B3                ; Item 0xCD at (14,7) in Tool  Shed
  DEFB $16                ; Item 0xCE at (6,9) in To the Kitchens    Main
                          ; Stairway
  DEFB $96                ; Item 0xCF at (9,2) in To the Kitchens    Main
                          ; Stairway
  DEFB $28                ; Item 0xD0 at (7,19) in Dr Jones will never believe
                          ; this
  DEFB $8C                ; Item 0xD1 at (13,19) in Tree Top
  DEFB $0C                ; Item 0xD2 at (3,16) in Tree Top
  DEFB $0C                ; Item 0xD3 at (4,22) in Tree Top
  DEFB $89                ; Item 0xD4 at (11,5) in On a Branch Over the Drive
  DEFB $07                ; Item 0xD5 at (7,15) in Cuckoo's Nest
  DEFB $2E                ; Item 0xD6 at (3,10) in Tree Root
  DEFB $2E                ; Item 0xD7 at (4,29) in Tree Root
  DEFB $26                ; Item 0xD8 at (2,9) in Priests' Hole
  DEFB $95                ; Item 0xD9 at (12,17) in Ballroom West
  DEFB $95                ; Item 0xDA at (12,18) in Ballroom West
  DEFB $95                ; Item 0xDB at (12,20) in Ballroom West
  DEFB $95                ; Item 0xDC at (12,22) in Ballroom West
  DEFB $95                ; Item 0xDD at (12,23) in Ballroom West
  DEFB $0E                ; Item 0xDE at (2,26) in Rescue Esmerelda
  DEFB $0A                ; Item 0xDF at (4,11) in The Front Door
  DEFB $95                ; Item 0xE0 at (12,25) in Ballroom West
  DEFB $95                ; Item 0xE1 at (12,27) in Ballroom West
  DEFB $0E                ; Item 0xE2 at (3,26) in Rescue Esmerelda
  DEFB $0D                ; Item 0xE3 at (6,2) in Out on a limb
  DEFB $0D                ; Item 0xE4 at (1,5) in Out on a limb
  DEFB $2C                ; Item 0xE5 at (4,18) in On top of the house
  DEFB $13                ; Item 0xE6 at (3,2) in The Forgotten Abbey
  DEFB $83                ; Item 0xE7 at (11,1) in At the Foot of the MegaTree
  DEFB $83                ; Item 0xE8 at (10,4) in At the Foot of the MegaTree
  DEFB $83                ; Item 0xE9 at (11,7) in At the Foot of the MegaTree
  DEFB $31                ; Item 0xEA at (4,28) in The Wine Cellar
  DEFB $31                ; Item 0xEB at (7,4) in The Wine Cellar
  DEFB $31                ; Item 0xEC at (7,28) in The Wine Cellar
  DEFB $B1                ; Item 0xED at (10,2) in The Wine Cellar
  DEFB $B1                ; Item 0xEE at (10,28) in The Wine Cellar
  DEFB $B1                ; Item 0xEF at (13,4) in The Wine Cellar
  DEFB $00                ; Item 0xF0 at (4,19) in The Off Licence
  DEFB $00                ; Item 0xF1 at (4,20) in The Off Licence
  DEFB $00                ; Item 0xF2 at (4,21) in The Off Licence
  DEFB $00                ; Item 0xF3 at (4,22) in The Off Licence
  DEFB $00                ; Item 0xF4 at (4,23) in The Off Licence
  DEFB $00                ; Item 0xF5 at (4,24) in The Off Licence
  DEFB $00                ; Item 0xF6 at (4,25) in The Off Licence
  DEFB $00                ; Item 0xF7 at (4,26) in The Off Licence
  DEFB $00                ; Item 0xF8 at (4,27) in The Off Licence
  DEFB $00                ; Item 0xF9 at (4,28) in The Off Licence
  DEFB $00                ; Item 0xFA at (4,29) in The Off Licence
  DEFB $00                ; Item 0xFB at (4,30) in The Off Licence
  DEFB $02                ; Item 0xFC at (0,22) in Under the MegaTree
  DEFB $9D                ; Item 0xFD at (9,26) in The Nightmare Room
  DEFB $9E                ; Item 0xFE at (14,8) in The Banyan Tree
  DEFB $A1                ; Item 0xFF at (13,23) in The Bathroom
ITEMTABLE2:
  DEFS $AD                ; Unused
  DEFB $19                ; Item 0xAD at (8,25) in Watch Tower
  DEFB $2A                ; Item 0xAE at (9,10) in Watch Tower
  DEFB $34                ; Item 0xAF at (9,20) in Watch Tower
  DEFB $38                ; Item 0xB0 at (9,24) in Watch Tower
  DEFB $C9                ; Item 0xB1 at (14,9) in West Wing Roof
  DEFB $B3                ; Item 0xB2 at (13,19) in West Wing Roof
  DEFB $7B                ; Item 0xB3 at (11,27) in West Wing Roof
  DEFB $46                ; Item 0xB4 at (10,6) in West Wing Roof
  DEFB $1F                ; Item 0xB5 at (8,31) in Conservatory Roof
  DEFB $19                ; Item 0xB6 at (8,25) in Conservatory Roof
  DEFB $1C                ; Item 0xB7 at (8,28) in Conservatory Roof
  DEFB $16                ; Item 0xB8 at (8,22) in Conservatory Roof
  DEFB $64                ; Item 0xB9 at (11,4) in Swimming Pool
  DEFB $99                ; Item 0xBA at (12,25) in On the Roof
  DEFB $9F                ; Item 0xBB at (4,31) in I'm sure I've seen this
                          ; before..
  DEFB $9F                ; Item 0xBC at (4,31) in We must perform a
                          ; Quirkafleeg
  DEFB $9F                ; Item 0xBD at (4,31) in Up on the Battlements
  DEFB $1A                ; Item 0xBE at (8,26) in The Bow
  DEFB $CD                ; Item 0xBF at (14,13) in The Yacht
  DEFB $B6                ; Item 0xC0 at (13,22) in The Beach
  DEFB $3C                ; Item 0xC1 at (1,28) in Orangery
  DEFB $D0                ; Item 0xC2 at (6,16) in Orangery
  DEFB $A6                ; Item 0xC3 at (13,6) in Orangery
  DEFB $DD                ; Item 0xC4 at (6,29) in The Chapel
  DEFB $37                ; Item 0xC5 at (9,23) in Above the West Bedroom
  DEFB $B6                ; Item 0xC6 at (13,22) in The Beach
  DEFB $7A                ; Item 0xC7 at (3,26) in First Landing
  DEFB $22                ; Item 0xC8 at (9,2) in Top Landing
  DEFB $43                ; Item 0xC9 at (2,3) in Cold Store
  DEFB $A8                ; Item 0xCA at (5,8) in Cold Store
  DEFB $06                ; Item 0xCB at (8,6) in Cold Store
  DEFB $66                ; Item 0xCC at (11,6) in Cold Store
  DEFB $C7                ; Item 0xCD at (14,7) in Tool  Shed
  DEFB $C9                ; Item 0xCE at (6,9) in To the Kitchens    Main
                          ; Stairway
  DEFB $22                ; Item 0xCF at (9,2) in To the Kitchens    Main
                          ; Stairway
  DEFB $F3                ; Item 0xD0 at (7,19) in Dr Jones will never believe
                          ; this
  DEFB $B3                ; Item 0xD1 at (13,19) in Tree Top
  DEFB $70                ; Item 0xD2 at (3,16) in Tree Top
  DEFB $96                ; Item 0xD3 at (4,22) in Tree Top
  DEFB $65                ; Item 0xD4 at (11,5) in On a Branch Over the Drive
  DEFB $EF                ; Item 0xD5 at (7,15) in Cuckoo's Nest
  DEFB $6A                ; Item 0xD6 at (3,10) in Tree Root
  DEFB $9D                ; Item 0xD7 at (4,29) in Tree Root
  DEFB $49                ; Item 0xD8 at (2,9) in Priests' Hole
  DEFB $91                ; Item 0xD9 at (12,17) in Ballroom West
  DEFB $92                ; Item 0xDA at (12,18) in Ballroom West
  DEFB $94                ; Item 0xDB at (12,20) in Ballroom West
  DEFB $96                ; Item 0xDC at (12,22) in Ballroom West
  DEFB $97                ; Item 0xDD at (12,23) in Ballroom West
  DEFB $5A                ; Item 0xDE at (2,26) in Rescue Esmerelda
  DEFB $8B                ; Item 0xDF at (4,11) in The Front Door
  DEFB $99                ; Item 0xE0 at (12,25) in Ballroom West
  DEFB $9B                ; Item 0xE1 at (12,27) in Ballroom West
  DEFB $7A                ; Item 0xE2 at (3,26) in Rescue Esmerelda
  DEFB $C2                ; Item 0xE3 at (6,2) in Out on a limb
  DEFB $25                ; Item 0xE4 at (1,5) in Out on a limb
  DEFB $92                ; Item 0xE5 at (4,18) in On top of the house
  DEFB $62                ; Item 0xE6 at (3,2) in The Forgotten Abbey
  DEFB $61                ; Item 0xE7 at (11,1) in At the Foot of the MegaTree
  DEFB $44                ; Item 0xE8 at (10,4) in At the Foot of the MegaTree
  DEFB $67                ; Item 0xE9 at (11,7) in At the Foot of the MegaTree
  DEFB $9C                ; Item 0xEA at (4,28) in The Wine Cellar
  DEFB $E4                ; Item 0xEB at (7,4) in The Wine Cellar
  DEFB $FC                ; Item 0xEC at (7,28) in The Wine Cellar
  DEFB $42                ; Item 0xED at (10,2) in The Wine Cellar
  DEFB $5C                ; Item 0xEE at (10,28) in The Wine Cellar
  DEFB $A4                ; Item 0xEF at (13,4) in The Wine Cellar
  DEFB $93                ; Item 0xF0 at (4,19) in The Off Licence
  DEFB $94                ; Item 0xF1 at (4,20) in The Off Licence
  DEFB $95                ; Item 0xF2 at (4,21) in The Off Licence
  DEFB $96                ; Item 0xF3 at (4,22) in The Off Licence
  DEFB $97                ; Item 0xF4 at (4,23) in The Off Licence
  DEFB $98                ; Item 0xF5 at (4,24) in The Off Licence
  DEFB $99                ; Item 0xF6 at (4,25) in The Off Licence
  DEFB $9A                ; Item 0xF7 at (4,26) in The Off Licence
  DEFB $9B                ; Item 0xF8 at (4,27) in The Off Licence
  DEFB $9C                ; Item 0xF9 at (4,28) in The Off Licence
  DEFB $9D                ; Item 0xFA at (4,29) in The Off Licence
  DEFB $9E                ; Item 0xFB at (4,30) in The Off Licence
  DEFB $16                ; Item 0xFC at (0,22) in Under the MegaTree
  DEFB $3A                ; Item 0xFD at (9,26) in The Nightmare Room
  DEFB $C8                ; Item 0xFE at (14,8) in The Banyan Tree
  DEFB $B7                ; Item 0xFF at (13,23) in The Bathroom

; Toilet graphics
;
; Used by the routine at DRAWTOILET.
TOILET0:
  DEFB $00,$0F,$00,$3F,$00,$0F,$30,$0F,$0C,$0F,$03,$0F,$00,$CF,$00,$2F
  DEFB $00,$08,$3F,$F8,$3F,$F0,$3F,$EE,$1F,$DF,$1F,$DB,$0F,$FB,$0F,$FB
TOILET1:
  DEFB $00,$0F,$00,$3F,$00,$0F,$00,$0F,$00,$0F,$00,$0F,$00,$0F,$3F,$EF
  DEFB $00,$08,$3F,$F8,$3F,$F0,$3F,$EE,$1F,$DF,$1F,$DB,$0F,$FB,$0F,$FB
TOILET2:
  DEFB $03,$AF,$01,$BF,$01,$8F,$01,$8F,$7F,$8F,$7F,$8F,$47,$CF,$0F,$CF
  DEFB $00,$08,$3F,$F8,$3F,$F0,$3F,$EE,$1F,$DF,$1F,$DB,$0F,$FB,$0F,$FB
TOILET3:
  DEFB $00,$0F,$04,$3F,$1E,$2F,$3B,$2F,$5D,$8F,$0E,$8F,$07,$CF,$0F,$CF
  DEFB $00,$08,$3F,$F8,$3F,$F0,$3F,$EE,$1F,$DF,$1F,$DB,$0F,$FB,$0F,$FB

; Unused
  DEFB $80,$80,$80,$80,$8C,$8F,$8F,$8F,$8F,$8F,$80,$80,$BF,$8F,$8F,$8F
  DEFB $85,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
  DEFB $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
  DEFB $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
  DEFB $80,$80,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$BF,$8F,$B3,$B0,$B0,$80
  DEFB $85,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
  DEFB $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
  DEFB $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
  DEFS $0400

; Guardian graphics
;
; Used by the routine at DRAWTHINGS.
;
; This guardian (page 0xAB, sprites 0-3) appears in The Banyan Tree and A bit
; of tree.
GUARDIANS:
  DEFB $00,$00,$00,$00,$2A,$AA,$7F,$FF,$7F,$FF,$7C,$3F,$7C,$3F,$7F,$FF
  DEFB $7F,$FF,$7F,$FF,$00,$00,$2A,$AA,$00,$00,$2A,$AA,$00,$00,$00,$00
  DEFB $00,$48,$01,$2C,$04,$BC,$12,$FE,$4B,$FE,$2E,$7F,$BC,$3F,$FE,$7C
  DEFB $FF,$F2,$7F,$C9,$7F,$25,$3C,$94,$32,$50,$09,$40,$05,$00,$04,$00
  DEFB $00,$00,$07,$E0,$0F,$F0,$17,$E8,$0F,$F0,$16,$68,$0E,$70,$16,$68
  DEFB $0F,$F0,$17,$E8,$0F,$F0,$17,$E8,$08,$10,$17,$E8,$10,$08,$00,$00
  DEFB $12,$00,$34,$80,$3D,$20,$7F,$48,$7F,$D2,$FE,$74,$FC,$3D,$3E,$7F
  DEFB $4F,$FF,$93,$FE,$A4,$FE,$29,$3C,$0A,$4C,$02,$90,$00,$A0,$00,$20
; This guardian (page 0xAB, sprites 4-7) appears in The Chapel and The Banyan
; Tree.
  DEFB $00,$00,$00,$00,$00,$00,$02,$02,$22,$02,$A9,$54,$A8,$D8,$71,$74
  DEFB $22,$DA,$3B,$AE,$2E,$AB,$24,$F9,$20,$DB,$20,$D8,$01,$54,$02,$8A
  DEFB $00,$00,$02,$02,$02,$02,$01,$74,$00,$D8,$51,$54,$52,$FA,$23,$DE
  DEFB $E7,$AB,$1E,$F9,$18,$D9,$08,$D9,$09,$54,$06,$8A,$04,$00,$00,$00
  DEFB $02,$02,$03,$8E,$00,$F8,$01,$54,$02,$DA,$03,$FE,$11,$8B,$4B,$A9
  DEFB $2B,$FB,$96,$F8,$6C,$D8,$05,$54,$02,$8A,$01,$00,$00,$80,$00,$40
  DEFB $00,$00,$02,$02,$02,$02,$01,$74,$00,$D8,$51,$54,$52,$FA,$23,$DE
  DEFB $E7,$AB,$1E,$F9,$18,$D9,$08,$D9,$09,$54,$06,$8A,$04,$00,$00,$00
; This guardian (page 0xAC, sprites 0-3) appears in East Wall Base, The Chapel
; and West  Wing.
  DEFB $20,$04,$AE,$EC,$BB,$7D,$E0,$07,$BD,$B5,$A0,$04,$3B,$7C,$00,$00
  DEFB $1D,$B0,$20,$04,$3B,$7C,$A2,$44,$FD,$B7,$A0,$04,$3B,$DC,$20,$04
  DEFB $20,$04,$37,$B4,$A0,$04,$FB,$7F,$A0,$04,$3D,$B4,$20,$04,$1B,$78
  DEFB $00,$00,$3D,$B4,$A2,$44,$BB,$7D,$E0,$07,$BD,$B5,$B7,$EC,$20,$04
  DEFB $20,$04,$3A,$DC,$3D,$BD,$E0,$07,$3B,$75,$20,$04,$3D,$BC,$00,$00
  DEFB $1B,$70,$20,$04,$3D,$BD,$A2,$45,$FB,$77,$A0,$05,$3D,$ED,$20,$04
  DEFB $20,$04,$3B,$75,$A0,$05,$FD,$BF,$A0,$05,$3B,$75,$20,$04,$1D,$B8
  DEFB $00,$00,$3B,$74,$24,$84,$3D,$BD,$E0,$07,$3B,$75,$2E,$EC,$20,$04
; This guardian (page 0xAC, sprites 4-7) appears in The Banyan Tree and
; Orangery.
  DEFB $0F,$F0,$17,$E8,$18,$18,$37,$CC,$28,$24,$53,$92,$64,$4A,$A9,$2B
  DEFB $AA,$2B,$6A,$4A,$69,$92,$24,$24,$33,$CC,$18,$18,$17,$E8,$0F,$F0
  DEFB $00,$E0,$07,$F0,$38,$18,$73,$CC,$64,$26,$49,$93,$52,$4B,$D4,$2B
  DEFB $D5,$2A,$D4,$CA,$D2,$12,$49,$E4,$24,$0C,$13,$F4,$08,$78,$07,$80
  DEFB $01,$80,$07,$E0,$18,$18,$73,$CE,$A4,$25,$C9,$95,$D2,$55,$D4,$55
  DEFB $D4,$95,$D2,$25,$C9,$C9,$E4,$13,$73,$E6,$18,$18,$07,$E0,$01,$80
  DEFB $07,$00,$08,$E0,$1F,$DC,$30,$26,$67,$92,$C8,$4A,$D3,$2A,$D4,$AB
  DEFB $54,$2B,$52,$4B,$49,$93,$24,$26,$33,$CC,$28,$18,$1F,$F0,$01,$E0
; This guardian (page 0xAD, sprites 0-3) appears in On a Branch Over the Drive,
; Conservatory Roof and Tool  Shed.
  DEFB $0C,$00,$0C,$00,$0C,$00,$0C,$00,$0C,$00,$1E,$00,$12,$00,$33,$00
  DEFB $3F,$00,$73,$80,$61,$80,$61,$80,$C0,$C0,$C0,$C0,$80,$40,$80,$40
  DEFB $08,$40,$08,$40,$0C,$C0,$04,$80,$07,$80,$07,$80,$0C,$C0,$1C,$E0
  DEFB $3B,$70,$30,$30,$60,$18,$60,$18,$40,$08,$C0,$0C,$80,$04,$80,$04
  DEFB $02,$10,$02,$10,$03,$30,$01,$20,$01,$E0,$01,$E0,$03,$30,$07,$38
  DEFB $0E,$DC,$0C,$0C,$18,$06,$18,$06,$10,$02,$30,$03,$20,$01,$20,$01
  DEFB $00,$30,$00,$30,$00,$30,$00,$30,$00,$30,$00,$78,$00,$48,$00,$CC
  DEFB $00,$FC,$01,$CE,$01,$86,$01,$86,$03,$03,$03,$03,$02,$01,$02,$01
; This guardian (page 0xAD, sprites 4-7) appears in Top Landing, Tree Root and
; West Bedroom.
  DEFB $00,$00,$00,$00,$00,$00,$7F,$FE,$40,$02,$FF,$FF,$DE,$7B,$C0,$03
  DEFB $C0,$03,$DE,$7B,$FF,$FF,$40,$02,$7F,$FE,$00,$00,$00,$00,$00,$00
  DEFB $0A,$00,$1D,$00,$36,$80,$67,$40,$C3,$A0,$71,$D0,$B8,$68,$5C,$34
  DEFB $2C,$3A,$16,$1D,$0B,$8E,$05,$C3,$02,$E6,$01,$6C,$00,$B8,$00,$50
  DEFB $07,$E0,$1F,$F8,$14,$28,$16,$68,$16,$68,$16,$68,$16,$68,$14,$28
  DEFB $14,$28,$16,$68,$16,$68,$16,$68,$16,$68,$14,$28,$1F,$F8,$07,$E0
  DEFB $00,$50,$00,$B8,$01,$6C,$02,$E6,$05,$C3,$0B,$8E,$16,$1D,$2C,$3A
  DEFB $5C,$34,$B8,$68,$71,$D0,$C3,$A0,$67,$40,$36,$80,$1D,$00,$0A,$00
; This guardian (page 0xAE, sprites 0-3) appears in To the Kitchens    Main
; Stairway, Halfway up the East Wall, Conservatory Roof and The Bow.
  DEFB $7E,$00,$99,$00,$FF,$00,$81,$00,$7E,$00,$18,$00,$24,$00,$24,$00
  DEFB $42,$00,$42,$00,$81,$00,$E7,$00,$A5,$00,$C3,$00,$A5,$00,$E7,$00
  DEFB $00,$00,$1F,$80,$26,$40,$39,$C0,$30,$C0,$1F,$80,$09,$00,$10,$80
  DEFB $20,$40,$40,$20,$80,$10,$E0,$70,$A0,$50,$C0,$30,$A0,$50,$E0,$70
  DEFB $00,$00,$00,$00,$00,$00,$07,$E0,$09,$90,$0E,$70,$0E,$70,$06,$60
  DEFB $1B,$D8,$60,$06,$80,$01,$E0,$07,$A0,$05,$C0,$03,$A0,$05,$E0,$07
  DEFB $00,$00,$01,$F8,$02,$64,$03,$9C,$03,$0C,$01,$F8,$00,$90,$01,$08
  DEFB $02,$04,$04,$02,$08,$01,$0E,$07,$0A,$05,$0C,$03,$0A,$05,$0E,$07
; This guardian (page 0xAE, sprites 4-7) appears in Under the Drive.
  DEFB $0C,$00,$12,$00,$21,$10,$12,$20,$8C,$40,$52,$80,$2F,$00,$2F,$00
  DEFB $5F,$80,$5F,$80,$5F,$80,$00,$00,$FF,$C0,$5D,$80,$5D,$80,$FF,$C0
  DEFB $00,$01,$00,$02,$83,$04,$4C,$C8,$23,$10,$14,$A0,$0B,$C0,$0B,$C0
  DEFB $17,$E0,$17,$E0,$17,$E0,$00,$00,$3F,$F0,$1B,$B0,$1B,$B0,$3F,$F0
  DEFB $80,$00,$40,$00,$20,$01,$11,$E2,$08,$C4,$05,$28,$02,$F0,$02,$F0
  DEFB $05,$F8,$05,$F8,$05,$F8,$00,$00,$0F,$FC,$0B,$74,$0B,$74,$0F,$FC
  DEFB $00,$00,$00,$00,$08,$30,$04,$CC,$02,$31,$01,$4A,$00,$BC,$00,$BC
  DEFB $01,$7E,$01,$7E,$01,$7E,$00,$00,$03,$FF,$02,$ED,$02,$ED,$03,$FF
; This guardian (page 0xAF, sprites 0-3) appears in Top Landing, Under the Roof
; and Tool  Shed.
  DEFB $38,$00,$7C,$00,$7E,$00,$6D,$80,$44,$40,$6C,$40,$7C,$20,$7C,$00
  DEFB $7C,$0C,$7C,$32,$FC,$CC,$FF,$30,$FC,$C0,$7F,$00,$6C,$00,$38,$00
  DEFB $0E,$60,$1F,$94,$1F,$08,$1B,$20,$11,$50,$1B,$50,$1F,$A0,$1F,$A0
  DEFB $7F,$40,$DF,$40,$DF,$80,$9F,$80,$7F,$00,$1F,$00,$1B,$00,$0E,$00
  DEFB $03,$80,$07,$C0,$07,$E0,$06,$D8,$04,$44,$0E,$C4,$7F,$C2,$EF,$C0
  DEFB $EF,$C0,$8F,$C0,$77,$C0,$07,$C0,$07,$C0,$07,$C0,$06,$C0,$03,$80
  DEFB $00,$E0,$01,$F0,$01,$F0,$01,$B2,$01,$15,$01,$B5,$01,$FA,$01,$FA
  DEFB $07,$F4,$0D,$F4,$0D,$F8,$09,$F8,$07,$F0,$01,$F0,$01,$B0,$00,$E0
; This guardian (page 0xAF, sprites 4-7) appears in The Drive, Cuckoo's Nest,
; To the Kitchens    Main Stairway and Back Stairway.
  DEFB $0C,$00,$16,$00,$2F,$00,$2F,$00,$4F,$80,$5F,$80,$5F,$80,$9F,$C0
  DEFB $BF,$C0,$BD,$C0,$BA,$C0,$BD,$40,$5A,$80,$5D,$80,$3F,$00,$0C,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$70,$03,$98,$0C,$78,$33,$F8,$47,$F0
  DEFB $5F,$F0,$BF,$F0,$BE,$A0,$BD,$60,$5A,$C0,$5D,$40,$3F,$80,$0E,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$03,$C0,$1C,$78,$21,$FC,$4F,$FE
  DEFB $5F,$FE,$9F,$FF,$BF,$EF,$5F,$56,$5F,$AE,$23,$54,$1F,$F8,$03,$C0
  DEFB $00,$00,$00,$00,$00,$00,$0E,$00,$17,$C0,$17,$F0,$13,$FC,$0B,$FE
  DEFB $0B,$FE,$0B,$D7,$05,$EB,$05,$D7,$02,$EA,$02,$7E,$01,$8C,$00,$70
; This guardian (page 0xB0, sprites 0-3) appears in The Attic.
  DEFB $07,$C0,$18,$30,$23,$88,$44,$44,$88,$22,$90,$13,$90,$13,$88,$22
  DEFB $44,$44,$23,$88,$18,$30,$07,$C0,$03,$00,$03,$00,$03,$00,$03,$80
  DEFB $07,$C0,$18,$30,$20,$08,$43,$84,$84,$42,$88,$23,$88,$23,$84,$42
  DEFB $43,$84,$20,$08,$18,$30,$07,$C0,$0F,$80,$1D,$D0,$08,$E0,$04,$40
  DEFB $07,$C0,$1F,$F0,$3E,$78,$7C,$3C,$7E,$7C,$FF,$FE,$FF,$FE,$F0,$00
  DEFB $FF,$80,$7F,$F0,$7F,$FC,$3F,$F8,$1F,$F0,$07,$C0,$00,$00,$00,$00
  DEFB $07,$C0,$1F,$F0,$3C,$F8,$78,$7C,$7C,$FC,$FF,$80,$FC,$00,$F0,$00
  DEFB $F8,$00,$7E,$00,$7F,$80,$3F,$E0,$1F,$F0,$07,$C0,$00,$00,$00,$00
; This guardian (page 0xB0, sprites 4-5) appears in Rescue Esmerelda.
  DEFB $07,$C0,$08,$20,$0A,$A0,$08,$20,$0B,$A0,$10,$10,$25,$48,$0A,$A0
  DEFB $3D,$78,$46,$C4,$07,$C0,$02,$80,$05,$40,$0F,$E0,$14,$80,$08,$C0
  DEFB $07,$C0,$08,$20,$0A,$A0,$08,$20,$39,$38,$00,$00,$05,$40,$0A,$A0
  DEFB $1D,$70,$16,$D0,$17,$D0,$0A,$A0,$05,$40,$0F,$E0,$02,$50,$06,$20
; This guardian (page 0xB0, sprites 6-7) appears in The Hall and West  Wing.
  DEFB $01,$80,$00,$00,$01,$80,$45,$91,$01,$80,$89,$A2,$45,$91,$01,$80
  DEFB $CD,$B3,$CD,$B3,$CD,$B3,$CD,$B3,$23,$C4,$12,$48,$0D,$B0,$00,$00
  DEFB $01,$80,$00,$00,$01,$80,$89,$A2,$01,$80,$45,$91,$89,$A2,$01,$80
  DEFB $CD,$B3,$CD,$B3,$CD,$B3,$CD,$B3,$23,$C4,$12,$48,$0D,$B0,$00,$00
; This guardian (page 0xB1, sprites 0-7) is not used.
  DEFB $16,$00,$16,$00,$16,$00,$16,$00,$16,$00,$16,$00,$16,$00,$16,$00
  DEFB $FF,$C0,$00,$00,$52,$80,$C0,$C0,$33,$00,$B3,$40,$08,$00,$2D,$00
  DEFB $05,$80,$05,$80,$05,$80,$05,$80,$05,$80,$05,$80,$05,$80,$05,$80
  DEFB $3F,$F0,$00,$00,$0D,$20,$24,$00,$0C,$D0,$0C,$F0,$28,$00,$0D,$20
  DEFB $01,$60,$01,$60,$01,$60,$01,$60,$01,$60,$01,$60,$01,$60,$01,$60
  DEFB $0F,$FC,$00,$00,$02,$D0,$00,$40,$0B,$34,$03,$30,$0C,$0C,$05,$28
  DEFB $00,$58,$00,$58,$00,$58,$00,$58,$00,$58,$00,$58,$00,$58,$00,$58
  DEFB $03,$FF,$00,$00,$01,$2C,$00,$05,$03,$CC,$02,$CC,$00,$09,$01,$2C
  DEFB $00,$40,$01,$80,$02,$40,$05,$C0,$0B,$C0,$0B,$C0,$17,$C0,$17,$C0
  DEFB $16,$40,$16,$00,$16,$00,$16,$00,$16,$00,$16,$00,$16,$00,$16,$00
  DEFB $03,$00,$0F,$C0,$08,$40,$13,$20,$13,$20,$08,$40,$0F,$C0,$07,$80
  DEFB $05,$80,$05,$80,$05,$80,$05,$80,$05,$80,$05,$80,$05,$80,$05,$80
  DEFB $08,$00,$0E,$00,$0B,$00,$0B,$80,$0B,$C0,$0B,$C0,$0B,$E0,$0F,$E0
  DEFB $09,$60,$01,$60,$01,$60,$01,$60,$01,$60,$01,$60,$01,$60,$01,$60
  DEFB $00,$30,$00,$DC,$00,$BC,$01,$7E,$01,$7E,$00,$BC,$00,$BC,$00,$58
  DEFB $00,$58,$00,$58,$00,$58,$00,$58,$00,$58,$00,$58,$00,$58,$00,$58
; This guardian (page 0xB2, sprites 0-3) appears in On top of the house and The
; Yacht.
  DEFB $00,$03,$00,$0F,$00,$1F,$80,$3F,$C0,$7F,$D1,$FF,$5F,$FF,$9F,$FF
  DEFB $CF,$FF,$D3,$FF,$DF,$FC,$FF,$F0,$FF,$E0,$7F,$C0,$3F,$80,$0E,$00
  DEFB $00,$00,$00,$00,$50,$01,$D8,$03,$9C,$07,$4F,$1F,$D7,$FF,$DB,$FF
  DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$8F,$FE,$07,$FC,$03,$F8,$00,$E0
  DEFB $00,$00,$03,$80,$07,$C0,$8F,$C0,$DF,$E0,$DB,$F1,$57,$FF,$8F,$FF
  DEFB $DF,$FF,$DF,$FF,$FF,$FF,$FC,$7F,$F8,$3F,$70,$3F,$00,$1F,$00,$0E
  DEFB $00,$38,$00,$FE,$01,$FF,$83,$FF,$C7,$FF,$DF,$FF,$5F,$FF,$9B,$FF
  DEFB $C7,$FF,$DF,$FF,$DF,$C7,$FF,$01,$FE,$00,$7C,$00,$38,$00,$00,$00
; This guardian (page 0xB2, sprites 4-7) appears in On a Branch Over the Drive,
; Orangery, Dr Jones will never believe this, Under the Drive, Nomen Luni and
; Back Stairway.
  DEFB $03,$C0,$0E,$F0,$1D,$F8,$3E,$FC,$53,$CE,$65,$A6,$A4,$27,$71,$8F
  DEFB $BF,$F7,$55,$EF,$6E,$76,$53,$CA,$38,$1C,$16,$78,$0B,$F0,$02,$C0
  DEFB $03,$C0,$0D,$F0,$1A,$F8,$3F,$FC,$51,$8C,$64,$26,$C5,$A7,$B3,$CF
  DEFB $5D,$BB,$AA,$77,$5F,$FA,$72,$4E,$38,$1C,$1C,$38,$0B,$F0,$02,$C0
  DEFB $03,$C0,$0B,$F0,$15,$78,$3F,$FC,$50,$0C,$65,$A6,$C7,$E7,$F1,$8F
  DEFB $BE,$7F,$DD,$F7,$2C,$3A,$5A,$5E,$2C,$3C,$16,$78,$0B,$F0,$03,$C0
  DEFB $03,$C0,$0D,$F0,$1A,$F8,$3F,$FC,$51,$8C,$64,$26,$C5,$A7,$B3,$CF
  DEFB $5D,$BB,$AA,$77,$5F,$FA,$72,$4E,$38,$1C,$1C,$38,$0B,$F0,$02,$C0
; The next 256 bytes are unused.
  DEFS $0100
; This guardian (page 0xB4, sprites 0-7) appears in The Forgotten Abbey, The
; Chapel, First Landing, Swimming Pool and The Wine Cellar.
  DEFB $0E,$00,$15,$00,$2A,$80,$17,$00,$FF,$00,$16,$00,$0C,$00,$1F,$80
  DEFB $3F,$80,$7F,$00,$2A,$00,$7F,$00,$6F,$00,$7F,$00,$18,$00,$38,$00
  DEFB $03,$80,$05,$40,$0A,$A0,$05,$C0,$7F,$C0,$05,$80,$03,$00,$07,$E0
  DEFB $0F,$E0,$1F,$C0,$0A,$80,$1F,$C0,$1B,$C0,$1F,$C0,$18,$80,$38,$00
  DEFB $00,$E0,$01,$50,$02,$A8,$01,$70,$0F,$F0,$01,$60,$00,$C0,$01,$F8
  DEFB $03,$F8,$07,$F0,$02,$A0,$07,$F0,$06,$F0,$07,$F0,$06,$30,$00,$60
  DEFB $00,$38,$00,$54,$00,$AA,$00,$5C,$01,$FC,$00,$58,$00,$30,$00,$7E
  DEFB $00,$FE,$01,$FC,$00,$A8,$01,$FC,$01,$BC,$01,$FC,$01,$18,$00,$38
  DEFB $1C,$00,$2A,$00,$55,$00,$3A,$00,$3F,$80,$1A,$00,$0C,$00,$7E,$00
  DEFB $7F,$00,$3F,$80,$15,$00,$3F,$80,$3D,$80,$3F,$80,$18,$80,$1C,$00
  DEFB $07,$00,$0A,$80,$15,$40,$0E,$80,$0F,$F0,$06,$80,$03,$00,$1F,$80
  DEFB $1F,$C0,$0F,$E0,$05,$40,$0F,$E0,$0F,$60,$0F,$E0,$0C,$60,$06,$00
  DEFB $01,$C0,$02,$A0,$05,$50,$03,$A0,$03,$FE,$01,$A0,$00,$C0,$07,$E0
  DEFB $07,$F0,$03,$F8,$01,$50,$03,$F8,$03,$D8,$03,$F8,$01,$18,$00,$1C
  DEFB $00,$70,$00,$A8,$01,$54,$00,$E8,$00,$FF,$00,$68,$00,$30,$01,$F8
  DEFB $01,$FC,$00,$FE,$00,$54,$00,$FE,$00,$F6,$00,$FE,$00,$18,$00,$1C
; This guardian (page 0xB5, sprites 0-7) appears in At the Foot of the
; MegaTree, Cuckoo's Nest, Out on a limb, The Banyan Tree, The Wine Cellar,
; Tool  Shed, West Wing Roof and The Yacht.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$06,$00,$3F,$00,$1F,$00,$0D,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$80
  DEFB $0F,$C0,$07,$40,$03,$40,$4F,$40,$07,$40,$03,$20,$0F,$20,$87,$20
  DEFB $00,$60,$03,$F0,$01,$D0,$00,$D0,$03,$D0,$01,$D0,$00,$C8,$03,$C8
  DEFB $01,$C8,$00,$C8,$0B,$C8,$21,$C8,$00,$C8,$0B,$C4,$01,$C4,$20,$C4
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$00,$FC,$00,$74
  DEFB $00,$34,$00,$F4,$00,$74,$01,$36,$00,$FA,$02,$7A,$00,$3A,$04,$FA
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$30,$00,$7E,$00,$7C,$00,$58,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0C,$00
  DEFB $1F,$80,$17,$00,$16,$00,$17,$80,$17,$00,$26,$10,$27,$80,$27,$08
  DEFB $03,$00,$07,$E0,$05,$C0,$05,$80,$05,$E0,$05,$C0,$09,$80,$09,$E0
  DEFB $09,$D0,$09,$80,$09,$E8,$09,$C2,$09,$80,$11,$E8,$11,$C0,$11,$82
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C0,$01,$F8,$01,$70
  DEFB $01,$60,$01,$78,$01,$70,$02,$60,$02,$78,$02,$70,$02,$61,$02,$78
; This guardian (page 0xB6, sprites 0-7) appears in Under the MegaTree, The
; Hall, Tree Top and Emergency Generator.
FLYINGPIG0:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$13,$40,$17,$80,$3F,$C0
  DEFB $55,$40,$FA,$A0,$FD,$40,$1F,$A0,$08,$80,$05,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$D0,$05,$E0,$0F,$F0
  DEFB $16,$B0,$3D,$50,$3E,$A8,$07,$50,$02,$A8,$02,$54,$00,$28,$00,$14
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$34,$01,$78,$03,$FC
  DEFB $05,$54,$0F,$AA,$0F,$D4,$01,$FA,$00,$88,$01,$04,$00,$00,$00,$00
  DEFB $00,$03,$00,$0A,$00,$15,$00,$0A,$00,$15,$00,$AB,$00,$56,$00,$EB
  DEFB $01,$55,$03,$EB,$03,$FF,$00,$7E,$00,$22,$00,$22,$00,$00,$00,$00
  DEFB $80,$00,$50,$00,$A8,$00,$50,$00,$A8,$00,$D5,$00,$6A,$00,$D7,$00
  DEFB $AA,$80,$D7,$C0,$FF,$C0,$7E,$00,$44,$00,$44,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2C,$40,$1E,$80,$3F,$C0
  DEFB $2A,$A0,$55,$F0,$2B,$F0,$5F,$80,$11,$00,$20,$80,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0B,$10,$07,$A0,$0F,$F0
  DEFB $0D,$68,$0A,$BC,$15,$7C,$0A,$E0,$15,$40,$2A,$40,$14,$00,$28,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$C8,$01,$E8,$03,$FC
  DEFB $02,$AA,$05,$5F,$02,$BF,$05,$F8,$01,$10,$00,$A0,$00,$00,$00,$00
; This guardian (page 0xB7, sprites 0-1) appears in The Kitchen and West of
; Kitchen.
  DEFB $0A,$A0,$15,$50,$0A,$A0,$05,$42,$05,$45,$05,$45,$07,$C2,$0D,$62
  DEFB $0F,$E3,$3C,$7F,$7B,$BF,$EF,$E3,$AE,$E2,$47,$C2,$CE,$C0,$C0,$E0
  DEFB $C0,$00,$CA,$A0,$D5,$50,$CA,$A0,$45,$40,$45,$42,$A7,$C5,$CD,$65
  DEFB $6F,$E2,$7C,$7A,$3A,$BF,$0F,$EF,$0E,$E3,$07,$C2,$06,$E2,$0E,$02
; This guardian (page 0xB7, sprites 2-3) appears in Tree Root, West Bedroom and
; Above the West Bedroom.
  DEFB $03,$00,$04,$80,$05,$C0,$0B,$A0,$15,$40,$17,$60,$17,$60,$1F,$E0
  DEFB $13,$90,$2D,$68,$2F,$78,$2F,$78,$2F,$78,$2F,$78,$AF,$79,$7F,$FE
  DEFB $00,$C0,$01,$20,$01,$70,$02,$E8,$05,$50,$05,$D8,$05,$D8,$07,$F8
  DEFB $09,$C8,$16,$B4,$17,$BC,$17,$BC,$17,$BC,$17,$BC,$97,$BD,$7F,$FE
; This guardian (page 0xB7, sprites 4-7) appears in To the Kitchens    Main
; Stairway and Back Stairway.
  DEFB $76,$00,$00,$00,$6E,$00,$76,$00,$6E,$00,$00,$00,$76,$00,$6E,$00
  DEFB $00,$00,$76,$00,$00,$00,$00,$00,$6E,$00,$76,$00,$00,$00,$6E,$00
  DEFB $1D,$80,$2A,$00,$27,$60,$51,$B0,$4B,$D0,$90,$80,$AA,$E8,$94,$B8
  DEFB $91,$80,$AA,$D8,$91,$00,$55,$00,$4B,$B0,$2B,$60,$24,$00,$1D,$80
  DEFB $03,$C0,$0C,$30,$10,$98,$32,$14,$68,$82,$40,$2A,$B5,$11,$C8,$45
  DEFB $A4,$91,$9A,$05,$48,$42,$55,$0A,$28,$54,$12,$88,$0D,$70,$03,$C0
  DEFB $01,$B8,$00,$54,$06,$E4,$0D,$8A,$0B,$D2,$01,$09,$17,$55,$1D,$29
  DEFB $01,$89,$1B,$55,$00,$89,$00,$AA,$0D,$D2,$06,$D4,$00,$24,$01,$B8
; This guardian (page 0xB8, sprites 0-7) appears in Under the MegaTree, On the
; Roof, Ballroom West and Tree Root.
  DEFB $00,$00,$06,$00,$08,$00,$38,$00,$50,$00,$F0,$00,$F8,$00,$3C,$00
  DEFB $3E,$00,$7E,$00,$9F,$00,$1F,$00,$1F,$C0,$0E,$C0,$18,$00,$60,$00
  DEFB $00,$00,$00,$00,$0F,$00,$14,$80,$3C,$00,$0E,$00,$3F,$00,$0F,$80
  DEFB $1F,$80,$2F,$C0,$0F,$C0,$07,$F0,$03,$B0,$01,$00,$02,$00,$04,$00
  DEFB $00,$00,$00,$60,$00,$80,$03,$80,$0D,$00,$07,$00,$03,$80,$07,$C0
  DEFB $0B,$E0,$07,$E0,$09,$F0,$01,$F0,$01,$FC,$00,$EC,$01,$80,$06,$00
  DEFB $00,$00,$00,$00,$00,$04,$00,$08,$00,$70,$00,$A0,$01,$E0,$00,$70
  DEFB $01,$F8,$00,$78,$01,$FC,$00,$7C,$00,$7C,$00,$7F,$00,$3B,$00,$F0
  DEFB $04,$00,$04,$00,$0C,$00,$0C,$00,$16,$00,$1E,$00,$3E,$00,$6C,$00
  DEFB $9E,$00,$3F,$00,$3F,$00,$3F,$00,$7F,$00,$56,$00,$1C,$00,$06,$00
  DEFB $04,$80,$08,$40,$13,$20,$13,$20,$17,$A0,$13,$20,$1F,$E0,$1B,$60
  DEFB $27,$90,$0F,$C0,$0F,$C0,$0F,$C0,$0F,$C0,$1D,$80,$03,$80,$01,$00
  DEFB $00,$80,$00,$80,$00,$C0,$00,$C0,$01,$A0,$01,$E0,$01,$F0,$00,$D8
  DEFB $01,$E4,$03,$F0,$03,$F0,$03,$F0,$03,$F8,$01,$A8,$00,$E0,$01,$80
  DEFB $00,$48,$00,$84,$01,$32,$01,$02,$01,$7A,$01,$7A,$01,$FE,$01,$B6
  DEFB $02,$79,$00,$FC,$00,$FC,$00,$FC,$00,$FC,$00,$6E,$00,$70,$00,$20
; This guardian (page 0xB9, sprites 0-3) appears in On a Branch Over the Drive,
; To the Kitchens    Main Stairway and The Bathroom.
  DEFB $3C,$00,$6E,$00,$A7,$00,$A5,$00,$77,$00,$A3,$00,$62,$00,$2C,$00
  DEFB $34,$00,$46,$00,$C5,$00,$EE,$00,$A5,$00,$E5,$00,$76,$00,$3C,$00
  DEFB $00,$00,$00,$00,$00,$B0,$01,$48,$03,$FC,$00,$44,$02,$0C,$02,$7C
  DEFB $35,$D8,$46,$F0,$C5,$00,$EE,$00,$A5,$00,$E5,$00,$76,$00,$3C,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $34,$34,$46,$46,$C5,$C5,$EE,$EE,$A5,$A5,$E5,$E5,$76,$76,$3C,$3C
  DEFB $00,$00,$00,$00,$0F,$00,$1B,$80,$3E,$40,$30,$40,$22,$00,$3F,$C0
  DEFB $12,$B4,$0D,$46,$00,$C5,$00,$EE,$00,$A5,$00,$E5,$00,$76,$00,$3C
; This guardian (page 0xB9, sprites 4-7) appears in The Bridge.
  DEFB $03,$C0,$06,$60,$0D,$F0,$1A,$D8,$35,$5C,$20,$04,$7F,$FE,$D7,$75
  DEFB $B2,$27,$D7,$75,$7F,$FE,$15,$78,$25,$A4,$02,$40,$11,$88,$00,$00
  DEFB $03,$C0,$06,$60,$0D,$F0,$1A,$B8,$35,$5C,$20,$04,$7F,$FE,$AE,$EB
  DEFB $E4,$4D,$AE,$EB,$7F,$FE,$15,$78,$0A,$50,$01,$80,$04,$20,$01,$00
  DEFB $03,$C0,$06,$60,$0D,$F0,$1A,$D8,$35,$5C,$20,$04,$7F,$FE,$ED,$DB
  DEFB $A8,$93,$ED,$DB,$7F,$FE,$15,$78,$25,$A4,$02,$40,$11,$88,$04,$20
  DEFB $03,$C0,$06,$60,$0D,$F0,$1A,$E8,$35,$5C,$20,$04,$7F,$FE,$DB,$B7
  DEFB $C9,$15,$DB,$B7,$7F,$FE,$15,$78,$0A,$42,$41,$90,$04,$00,$11,$44
; This guardian (page 0xBA, sprites 0-3) appears in The Off Licence, Under the
; MegaTree, Inside the MegaTrunk, Out on a limb, Ballroom East, Ballroom West,
; East Wall Base and Tree Root.
  DEFB $07,$E0,$0F,$F0,$DF,$FB,$3F,$FC,$1F,$F8,$1F,$F8,$31,$8C,$6A,$56
  DEFB $B1,$8D,$9E,$F9,$0D,$F0,$1D,$B8,$36,$6C,$59,$9A,$8C,$31,$07,$E0
  DEFB $07,$E0,$0F,$F0,$1F,$F8,$FF,$FF,$1F,$F8,$1F,$F8,$31,$8C,$2A,$54
  DEFB $71,$8E,$9E,$F9,$8D,$F1,$1D,$B8,$32,$4C,$58,$1A,$4C,$32,$07,$E0
  DEFB $07,$E0,$0F,$F0,$1F,$F8,$DF,$FB,$3F,$FC,$1F,$F8,$31,$8C,$2A,$54
  DEFB $30,$8C,$5D,$FA,$8D,$B1,$9A,$59,$12,$48,$18,$18,$2C,$34,$C7,$E3
  DEFB $07,$E0,$8F,$F1,$5F,$FA,$3F,$FC,$1F,$F8,$11,$88,$2E,$74,$2A,$54
  DEFB $71,$8E,$5E,$FA,$8D,$F1,$1D,$B8,$12,$48,$78,$1E,$8C,$31,$07,$E0
; This guardian (page 0xBA, sprites 4-7) appears in Entrance to Hades, The
; Chapel and Priests' Hole.
  DEFB $15,$03,$2A,$BE,$15,$5E,$4A,$A8,$35,$5C,$8A,$AE,$6D,$5C,$99,$F9
  DEFB $6E,$BF,$DD,$63,$2E,$49,$59,$81,$04,$82,$2B,$C6,$12,$FC,$0C,$FD
  DEFB $40,$A8,$FD,$54,$7A,$A8,$15,$52,$3A,$AC,$75,$51,$3A,$B6,$9F,$99
  DEFB $FD,$76,$C6,$BB,$92,$74,$81,$9A,$41,$20,$63,$D4,$3F,$48,$BF,$30
  DEFB $FD,$BF,$BF,$EF,$EA,$D7,$AA,$45,$68,$D4,$48,$84,$40,$04,$40,$01
  DEFB $50,$00,$12,$0A,$40,$0C,$2A,$22,$14,$A8,$20,$84,$14,$28,$05,$20
  DEFB $FD,$BF,$FF,$FB,$AC,$D7,$AA,$D1,$2A,$54,$82,$44,$42,$01,$08,$04
  DEFB $4A,$10,$22,$82,$08,$A8,$14,$04,$0A,$90,$01,$40,$00,$00,$00,$00
; This guardian (page 0xBB, sprites 0-3) appears in Cold Store and Under the
; Roof.
  DEFB $0C,$00,$36,$80,$7F,$40,$7E,$80,$FD,$00,$FE,$80,$FF,$80,$FF,$00
  DEFB $55,$00,$2A,$00,$14,$00,$2A,$00,$14,$00,$08,$00,$14,$00,$08,$00
  DEFB $03,$00,$0D,$A0,$1F,$D0,$1F,$A0,$3F,$40,$3F,$A0,$3F,$E0,$3F,$C0
  DEFB $35,$40,$2A,$80,$05,$00,$0A,$80,$05,$00,$02,$00,$05,$00,$02,$00
  DEFB $00,$C0,$03,$68,$07,$F4,$07,$E8,$0F,$D0,$0F,$E8,$0F,$F8,$0F,$F0
  DEFB $05,$50,$0A,$A0,$01,$40,$02,$A0,$09,$40,$00,$80,$01,$40,$00,$80
  DEFB $00,$30,$00,$DA,$01,$FD,$01,$FA,$03,$F4,$03,$FA,$03,$FE,$03,$FC
  DEFB $03,$54,$02,$A8,$00,$50,$00,$A8,$00,$50,$00,$20,$00,$50,$00,$20
; This guardian (page 0xBB, sprites 4-7) appears in Inside the MegaTrunk, Tree
; Top and Watch Tower.
  DEFB $04,$00,$2A,$80,$55,$40,$2B,$80,$44,$40,$AF,$A0,$5F,$40,$20,$80
  DEFB $55,$40,$2A,$80,$04,$00,$04,$00,$08,$00,$3E,$00,$41,$00,$81,$00
  DEFB $02,$00,$15,$40,$2A,$A0,$15,$C0,$22,$20,$5F,$50,$2A,$A0,$10,$40
  DEFB $2A,$A0,$15,$40,$02,$00,$02,$00,$0E,$00,$11,$80,$20,$40,$00,$00
  DEFB $00,$40,$02,$A8,$05,$54,$03,$A8,$04,$44,$0B,$EA,$05,$F4,$02,$08
  DEFB $05,$54,$02,$A8,$00,$40,$00,$40,$00,$70,$01,$88,$02,$04,$00,$00
  DEFB $00,$20,$01,$54,$02,$AA,$01,$D4,$02,$22,$05,$7D,$02,$FA,$01,$54
  DEFB $02,$AA,$01,$54,$00,$20,$00,$20,$00,$10,$00,$7C,$00,$82,$00,$81
; This guardian (page 0xBC, sprites 0-7) appears in The Bridge, The Drive,
; Inside the MegaTrunk, The Hall, Tree Top, Out on a limb, Rescue Esmerelda,
; I'm sure I've seen this before.., We must perform a Quirkafleeg, Ballroom
; East, To the Kitchens    Main Stairway, A bit of tree, Priests' Hole, Under
; the Drive, Nomen Luni, Watch Tower, West  Wing and West Wing Roof.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$6F,$40,$BB,$80,$75,$40
  DEFB $1A,$80,$05,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$A0,$01,$40,$02,$80,$01,$50,$36,$A0,$5D,$70
  DEFB $37,$E0,$03,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$F4,$19,$B8,$2F,$54
  DEFB $19,$A8,$00,$50,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$3D,$03,$7E,$05,$D7
  DEFB $03,$6A,$00,$14,$00,$28,$00,$14,$00,$0A,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$BC,$00,$7E,$C0,$EB,$A0
  DEFB $56,$C0,$28,$00,$14,$00,$28,$00,$50,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2F,$00,$1D,$98,$2A,$F4
  DEFB $15,$98,$0A,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$05,$00,$02,$80,$01,$40,$0A,$80,$05,$6C,$0E,$BA
  DEFB $07,$EC,$03,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$F6,$01,$DD,$02,$AE
  DEFB $01,$58,$00,$A0,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
; This guardian (page 0xBD, sprites 0-7) appears in Cold Store.
  DEFB $18,$00,$3C,$00,$D4,$00,$2E,$00,$3A,$00,$3A,$00,$5A,$00,$5D,$00
  DEFB $4F,$00,$43,$00,$21,$80,$22,$00,$1E,$00,$14,$00,$13,$00,$3C,$00
  DEFB $06,$00,$0F,$00,$3F,$00,$0B,$80,$0E,$80,$0E,$80,$1F,$00,$17,$80
  DEFB $11,$C0,$10,$60,$08,$40,$08,$80,$07,$80,$02,$00,$02,$00,$07,$00
  DEFB $01,$80,$0B,$C0,$05,$40,$0A,$E0,$03,$A0,$03,$A0,$05,$A0,$05,$D0
  DEFB $04,$F0,$04,$30,$02,$18,$02,$20,$01,$E0,$01,$40,$06,$30,$01,$40
  DEFB $00,$60,$00,$B0,$03,$50,$00,$B8,$00,$E8,$00,$E8,$01,$68,$01,$74
  DEFB $01,$3C,$01,$0C,$00,$86,$00,$88,$00,$78,$00,$25,$00,$22,$00,$74
  DEFB $06,$00,$0D,$00,$0A,$C0,$1D,$00,$17,$00,$17,$00,$16,$80,$2E,$80
  DEFB $3C,$80,$30,$80,$61,$00,$11,$00,$1E,$00,$A4,$00,$44,$00,$2E,$00
  DEFB $01,$80,$03,$D0,$02,$A0,$07,$50,$05,$C0,$05,$C0,$05,$A0,$0B,$A0
  DEFB $0F,$20,$0C,$20,$18,$40,$04,$40,$07,$80,$02,$80,$0C,$60,$02,$80
  DEFB $00,$60,$00,$F0,$00,$FC,$01,$D0,$01,$70,$01,$70,$00,$F8,$01,$E8
  DEFB $03,$88,$06,$08,$02,$10,$01,$10,$01,$E0,$00,$40,$00,$40,$00,$E0
  DEFB $00,$18,$00,$3C,$00,$2B,$00,$74,$00,$5C,$00,$5C,$00,$5A,$00,$BA
  DEFB $00,$F2,$00,$C2,$01,$84,$00,$44,$00,$78,$00,$50,$01,$90,$00,$78
; This guardian (page 0xBE, sprites 0-3) appears in The Off Licence, To the
; Kitchens    Main Stairway, Nomen Luni and The Bow.
  DEFB $0C,$00,$12,$00,$21,$00,$2D,$00,$21,$00,$12,$00,$0C,$00,$0C,$00
  DEFB $1E,$00,$00,$00,$37,$00,$40,$00,$0D,$40,$AC,$40,$40,$80,$2E,$00
  DEFB $0E,$C0,$1D,$A0,$1F,$00,$1F,$E0,$1F,$00,$1D,$A0,$0E,$C0,$03,$00
  DEFB $07,$80,$00,$00,$0E,$C0,$00,$20,$2B,$00,$23,$50,$10,$60,$07,$00
  DEFB $04,$08,$06,$18,$07,$38,$0F,$FC,$07,$38,$06,$D8,$04,$C8,$00,$C0
  DEFB $01,$E0,$00,$00,$01,$D0,$04,$08,$08,$D4,$0A,$C0,$00,$08,$03,$B0
  DEFB $00,$DC,$01,$6E,$00,$3E,$01,$FE,$00,$3E,$01,$6E,$00,$DC,$00,$30
  DEFB $00,$78,$00,$00,$00,$B8,$01,$02,$02,$B1,$00,$35,$01,$00,$00,$DC
; This guardian (page 0xBE, sprites 4-7) appears in The Off Licence.
  DEFB $00,$00,$00,$00,$07,$E0,$1F,$B8,$3D,$EC,$7F,$FE,$7D,$F6,$FB,$F7
  DEFB $FB,$F7,$7F,$EE,$7F,$DE,$3F,$FC,$1F,$F8,$07,$E0,$00,$00,$00,$00
  DEFB $00,$00,$01,$80,$07,$E0,$0D,$70,$1F,$F8,$3F,$FC,$3F,$F4,$7D,$FE
  DEFB $7B,$F6,$3B,$EC,$3F,$DC,$1F,$38,$0F,$F0,$07,$E0,$01,$80,$00,$00
  DEFB $01,$80,$07,$E0,$0F,$F0,$1E,$F8,$1F,$78,$3F,$7C,$3B,$FC,$37,$F4
  DEFB $37,$FC,$3F,$EC,$3F,$EC,$1F,$D8,$1F,$38,$0F,$F0,$07,$E0,$01,$80
  DEFB $00,$00,$01,$80,$07,$E0,$0F,$F0,$1E,$B8,$3F,$FC,$3F,$F4,$7B,$FE
  DEFB $77,$F6,$37,$EC,$3F,$DC,$1F,$38,$0F,$F0,$07,$E0,$01,$80,$00,$00
; This guardian (page 0xBF, sprites 0-3) appears in At the Foot of the
; MegaTree, Inside the MegaTrunk, On a Branch Over the Drive, Dr Jones will
; never believe this and Nomen Luni.
  DEFB $80,$00,$40,$00,$A3,$60,$53,$60,$29,$C0,$16,$A0,$0B,$E0,$07,$70
  DEFB $02,$A8,$05,$D4,$02,$2A,$03,$E5,$03,$E2,$03,$61,$03,$62,$07,$70
  DEFB $00,$00,$00,$00,$06,$30,$56,$30,$A9,$C0,$56,$A0,$0B,$E0,$06,$30
  DEFB $03,$E8,$05,$D4,$02,$2A,$03,$E4,$03,$EA,$17,$64,$0E,$60,$04,$70
  DEFB $00,$00,$00,$00,$03,$60,$03,$60,$01,$C0,$1E,$A0,$2B,$E0,$56,$B4
  DEFB $A3,$6A,$45,$D5,$82,$22,$03,$E1,$03,$E2,$03,$60,$03,$60,$07,$70
  DEFB $00,$00,$00,$00,$06,$30,$56,$30,$A9,$C0,$56,$A0,$0B,$E0,$07,$F4
  DEFB $02,$2A,$05,$D5,$02,$22,$03,$E1,$03,$E0,$03,$74,$03,$38,$07,$10
; This guardian (page 0xBF, sprites 4-5) appears in The Security Guard, I'm
; sure I've seen this before.. and Up on the Battlements.
  DEFB $02,$04,$05,$0E,$0A,$84,$15,$C4,$17,$44,$2B,$E4,$2F,$E0,$12,$44
  DEFB $08,$82,$07,$2C,$15,$50,$2A,$A4,$55,$44,$AA,$84,$45,$00,$1D,$C0
  DEFB $02,$00,$05,$00,$0A,$84,$15,$CE,$17,$44,$2B,$E4,$2F,$E4,$12,$44
  DEFB $08,$80,$07,$04,$15,$52,$2A,$AC,$55,$40,$AA,$84,$45,$04,$1D,$C4
; This guardian (page 0xBF, sprites 6-7) appears in Rescue Esmerelda and Above
; the West Bedroom.
  DEFB $00,$04,$07,$06,$2F,$A4,$5F,$D4,$30,$64,$42,$14,$32,$60,$1F,$C4
  DEFB $08,$82,$07,$2C,$15,$50,$2A,$A4,$55,$44,$AA,$84,$45,$00,$0C,$C0
  DEFB $00,$00,$07,$00,$2F,$A4,$50,$56,$22,$24,$52,$54,$3F,$E4,$17,$44
  DEFB $08,$80,$07,$04,$15,$52,$2A,$AC,$55,$40,$AA,$84,$45,$04,$19,$84

; Room 0x00: The Off Licence (teleport: 9)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$AA,$AA,$AA,$AA,$AA
  DEFB $00,$00,$00,$80,$00,$00,$00,$02
  DEFB $00,$00,$00,$80,$00,$00,$00,$02
  DEFB $00,$00,$00,$8C,$00,$00,$00,$02
  DEFB $00,$00,$00,$80,$00,$00,$00,$02
  DEFB $00,$00,$00,$80,$00,$00,$00,$02
  DEFB $00,$00,$00,$80,$00,$00,$00,$02
  DEFB $00,$00,$00,$80,$00,$00,$00,$02
  DEFB $00,$00,$00,$AA,$00,$00,$02,$AA
  DEFB $00,$00,$00,$00,$00,$00,$00,$02
  DEFB $00,$00,$00,$00,$00,$00,$00,$02
  DEFB $00,$00,$00,$00,$00,$00,$00,$02
  DEFB $55,$55,$55,$55,$55,$55,$55,$55
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         The Off Licence        " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $44,$FF,$DE,$6C,$88,$12,$40,$04,$00 ; Floor
  DEFB $16,$22,$FF,$88,$FF,$22,$FF,$88,$FF ; Wall
  DEFB $05,$F8,$88,$9E,$BD,$BD,$9E,$88,$F8 ; Nasty
  DEFB $07,$03,$00,$0C,$00,$30,$00,$C0,$00 ; Ramp
  DEFB $43,$33,$FF,$33,$00,$FF,$00,$AA,$00 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5F33              ; Location in the attribute buffer at 24064: (9,19)
  DEFB $0C                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FD7              ; Location in the attribute buffer at 24064: (14,23)
  DEFB $04                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $05                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$A0            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $18,$18,$3C,$7E,$62,$62,$62,$7E ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $01                ; Room to the left (The Bridge)
  DEFB $00                ; Room to the right (The Off Licence)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $0A,$8A            ; Guardian no. 0x0A (vertical), base sprite 4, x=10
                          ; (ENTITY10)
  DEFB $0C,$1D            ; Guardian no. 0x0C (horizontal), base sprite 0,
                          ; initial x=29 (ENTITY12)
  DEFB $2C,$27            ; Guardian no. 0x2C (vertical), base sprite 1, x=7
                          ; (ENTITY44)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x01: The Bridge (teleport: 19)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$0A,$00,$2A,$00,$00,$00
  DEFB $00,$00,$2A,$00,$2A,$80,$00,$00
  DEFB $00,$00,$AA,$FF,$EA,$A0,$00,$00
  DEFB $55,$55,$AA,$FF,$EA,$A5,$55,$55
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         The Bridge             " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $44,$FF,$FF,$FD,$BB,$D6,$72,$60,$40 ; Floor
  DEFB $46,$22,$77,$22,$88,$22,$77,$22,$88 ; Wall
  DEFB $2F,$03,$84,$48,$30,$03,$84,$48,$30 ; Nasty
  DEFB $07,$03,$03,$0C,$0D,$32,$37,$C2,$C8 ; Ramp
  DEFB $2C,$01,$40,$04,$46,$4F,$79,$F0,$F9 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5FEC              ; Location in the attribute buffer at 24064: (15,12)
  DEFB $05                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FC7              ; Location in the attribute buffer at 24064: (14,7)
  DEFB $03                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $04                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $40,$A0            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $02                ; Room to the left (Under the MegaTree)
  DEFB $00                ; Room to the right (The Off Licence)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $14,$08            ; Guardian no. 0x14 (horizontal), base sprite 0,
                          ; initial x=8 (ENTITY20)
  DEFB $15,$14            ; Guardian no. 0x15 (horizontal), base sprite 0,
                          ; initial x=20 (ENTITY21)
  DEFB $0E,$8C            ; Guardian no. 0x0E (vertical), base sprite 4, x=12
                          ; (ENTITY14)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x02: Under the MegaTree (teleport: 29)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$03,$FF,$CF,$FC,$00,$00,$00 ; Room layout
  DEFB $AA,$AA,$AF,$FF,$3F,$00,$00,$00
  DEFB $00,$00,$3F,$D0,$5C,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$80,$00,$00,$00,$00,$00,$00
  DEFB $00,$01,$40,$04,$00,$04,$00,$00
  DEFB $00,$00,$01,$00,$04,$00,$00,$00
  DEFB $AA,$A8,$00,$00,$00,$01,$00,$00
  DEFB $00,$00,$14,$10,$10,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $55,$55,$55,$55,$55,$55,$55,$55
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "       Under the MegaTree       " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $44,$D7,$B3,$75,$6D,$5C,$18,$08,$04 ; Floor
  DEFB $42,$BD,$AA,$5D,$A2,$F3,$0A,$06,$01 ; Wall
  DEFB $46,$49,$6A,$3B,$3A,$FC,$1E,$6B,$E8 ; Nasty
  DEFB $FF,$00,$00,$00,$FF,$00,$00,$00,$00 ; Ramp (unused)
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $06                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $80,$A0            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $81,$42,$24,$18,$3C,$18,$3C,$C3 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $03                ; Room to the left (At the Foot of the MegaTree)
  DEFB $01                ; Room to the right (The Bridge)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $20,$10            ; Guardian no. 0x20 (horizontal), base sprite 0,
                          ; initial x=16 (ENTITY32)
  DEFB $2A,$0E            ; Guardian no. 0x2A (vertical), base sprite 0, x=14
                          ; (ENTITY42)
  DEFB $1A,$1B            ; Guardian no. 0x1A (horizontal), base sprite 0,
                          ; initial x=27 (ENTITY26)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x03: At the Foot of the MegaTree (teleport: 129)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $30,$C3,$08,$00,$08,$00,$00,$00 ; Room layout
  DEFB $30,$C3,$08,$00,$0A,$AA,$AA,$AA
  DEFB $30,$C3,$08,$00,$08,$00,$00,$00
  DEFB $30,$C3,$08,$01,$58,$00,$00,$00
  DEFB $30,$C3,$09,$00,$0A,$AA,$AA,$AA
  DEFB $30,$C3,$08,$14,$00,$00,$00,$00
  DEFB $30,$C3,$08,$00,$00,$00,$00,$00
  DEFB $30,$C3,$09,$00,$1A,$AA,$AA,$AA
  DEFB $30,$C3,$08,$00,$08,$00,$00,$00
  DEFB $30,$C3,$08,$00,$58,$00,$00,$00
  DEFB $30,$03,$09,$40,$08,$00,$00,$00
  DEFB $00,$00,$08,$00,$08,$00,$00,$00
  DEFB $00,$00,$08,$00,$08,$00,$00,$00
  DEFB $00,$00,$00,$00,$50,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $55,$55,$55,$55,$55,$55,$55,$55
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "  At the Foot of the MegaTree   " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$F0,$F9,$BF,$1F,$0C,$10,$28,$44 ; Floor
  DEFB $16,$AB,$AB,$AD,$AA,$AA,$AE,$55,$55 ; Wall
  DEFB $06,$6E,$74,$38,$1E,$6E,$74,$38,$1E ; Nasty
  DEFB $07,$C0,$00,$30,$00,$0C,$00,$03,$00 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5F8F              ; Location in the attribute buffer at 24064: (12,15)
  DEFB $03                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $C0,$A0            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $40,$A0,$5C,$22,$21,$22,$14,$08 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $04                ; Room to the left (The Drive)
  DEFB $02                ; Room to the right (Under the MegaTree)
  DEFB $08                ; Room above (Inside the MegaTrunk)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $06,$02            ; Guardian no. 0x06 (vertical), base sprite 0, x=2
                          ; (ENTITY6)
  DEFB $07,$05            ; Guardian no. 0x07 (vertical), base sprite 0, x=5
                          ; (ENTITY7)
  DEFB $08,$08            ; Guardian no. 0x08 (vertical), base sprite 0, x=8
                          ; (ENTITY8)
  DEFB $35,$09            ; Guardian no. 0x35 (horizontal), base sprite 0,
                          ; initial x=9 (ENTITY53)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x04: The Drive (teleport: 39)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $54,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$80,$00,$00,$00,$00,$00,$00
  DEFB $00,$A0,$00,$00,$00,$00,$00,$00
  DEFB $00,$A8,$00,$00,$00,$00,$00,$00
  DEFB $00,$AA,$00,$00,$00,$00,$00,$00
  DEFB $A0,$AA,$80,$00,$00,$00,$00,$00
  DEFB $A0,$AA,$A5,$55,$55,$5A,$55,$55
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "            The Drive           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $06,$AA,$55,$AA,$FF,$FF,$55,$AA,$55 ; Floor
  DEFB $0D,$70,$07,$77,$77,$00,$3B,$0B,$7D ; Wall
  DEFB $44,$14,$2A,$14,$09,$6A,$9C,$08,$08 ; Nasty (unused)
  DEFB $05,$C0,$40,$70,$70,$0C,$74,$77,$05 ; Ramp
  DEFB $42,$7B,$00,$ED,$00,$AA,$55,$AA,$55 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5FA0              ; Location in the attribute buffer at 24064: (13,0)
  DEFB $02                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5FC9              ; Location in the attribute buffer at 24064: (14,9)
  DEFB $07                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $03                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $C0,$A0            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $05                ; Room to the left (The Security Guard)
  DEFB $03                ; Room to the right (At the Foot of the MegaTree)
  DEFB $06                ; Room above (Entrance to Hades)
  DEFB $2D                ; Room below (Under the Drive)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $15,$12            ; Guardian no. 0x15 (horizontal), base sprite 0,
                          ; initial x=18 (ENTITY21)
  DEFB $16,$15            ; Guardian no. 0x16 (horizontal), base sprite 0,
                          ; initial x=21 (ENTITY22)
  DEFB $17,$08            ; Guardian no. 0x17 (horizontal), base sprite 0,
                          ; initial x=8 (ENTITY23)
  DEFB $18,$14            ; Guardian no. 0x18 (horizontal), base sprite 0,
                          ; initial x=20 (ENTITY24)
  DEFB $24,$8F            ; Guardian no. 0x24 (horizontal), base sprite 4,
                          ; initial x=15 (ENTITY36)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x05: The Security Guard (teleport: 139)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $80,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
  DEFB $A8,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$80,$00,$00,$00,$00,$00,$00
  DEFB $AA,$A0,$00,$00,$00,$00,$00,$00
  DEFB $A8,$00,$00,$00,$00,$00,$00,$00
  DEFB $A8,$00,$00,$00,$00,$00,$00,$00
  DEFB $A8,$15,$54,$10,$41,$54,$15,$55
  DEFB $A8,$2A,$A8,$20,$82,$A8,$2A,$AA
  DEFB $00,$00,$A8,$20,$82,$A8,$2A,$AA
  DEFB $00,$00,$A8,$20,$82,$A8,$28,$00
  DEFB $00,$00,$A8,$20,$82,$A8,$28,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$2A
  DEFB $A0,$0A,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "       The Security Guard       " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$FF,$FF,$AA,$55,$AA,$55,$AA,$55 ; Floor
  DEFB $0D,$0E,$C6,$95,$B0,$36,$86,$C0,$ED ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $07,$E0,$40,$20,$10,$0E,$04,$02,$01 ; Ramp
  DEFB $42,$6F,$00,$B7,$00,$AA,$55,$AA,$55 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5FBD              ; Location in the attribute buffer at 24064: (13,29)
  DEFB $03                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5EE8              ; Location in the attribute buffer at 24064: (7,8)
  DEFB $08                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $13                ; Room to the left (The Forgotten Abbey)
  DEFB $04                ; Room to the right (The Drive)
  DEFB $0A                ; Room above (The Front Door)
  DEFB $06                ; Room below (Entrance to Hades)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $02,$8E            ; Guardian no. 0x02 (vertical), base sprite 4, x=14
                          ; (ENTITY2)
  DEFB $03,$8B            ; Guardian no. 0x03 (vertical), base sprite 4, x=11
                          ; (ENTITY3)
  DEFB $03,$97            ; Guardian no. 0x03 (vertical), base sprite 4, x=23
                          ; (ENTITY3)
  DEFB $04,$91            ; Guardian no. 0x04 (vertical), base sprite 4, x=17
                          ; (ENTITY4)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x06: Entrance to Hades (teleport: 239)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
  DEFB $A0,$00,$00,$15,$04,$55,$00,$00
  DEFB $A0,$00,$00,$10,$44,$43,$00,$00
  DEFB $A0,$00,$00,$10,$44,$54,$00,$00
  DEFB $A0,$00,$00,$10,$44,$40,$00,$00
  DEFB $A0,$00,$00,$15,$04,$55,$00,$00
  DEFB $A0,$00,$00,$0C,$0C,$30,$00,$00
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
  DEFB $A0,$01,$01,$04,$14,$15,$04,$10
  DEFB $A0,$01,$45,$11,$11,$04,$11,$10
  DEFB $A0,$01,$11,$11,$14,$04,$11,$10
  DEFB $A0,$01,$31,$11,$11,$04,$15,$10
  DEFB $A0,$01,$01,$04,$11,$04,$11,$15
  DEFB $A0,$03,$03,$0C,$33,$0C,$33,$0C
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "        Entrance to Hades       " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $34,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $A3,$A0,$14,$82,$50,$0A,$41,$28,$05 ; Floor
  DEFB $63,$BB,$BB,$38,$BB,$BB,$BB,$83,$BB ; Wall
  DEFB $32,$BF,$5C,$58,$30,$28,$58,$48,$30 ; Nasty
  DEFB $07,$40,$40,$10,$10,$04,$04,$01,$01 ; Ramp (unused)
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5FC7              ; Location in the attribute buffer at 24064: (14,7)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $0E                ; Room to the left (Rescue Esmerelda)
  DEFB $05                ; Room to the right (The Security Guard)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $10,$82            ; Guardian no. 0x10 (vertical), base sprite 4, x=2
                          ; (ENTITY16)
  DEFB $11,$A4            ; Guardian no. 0x11 (vertical), base sprite 5, x=4
                          ; (ENTITY17)
  DEFB $12,$C3            ; Guardian no. 0x12 (vertical), base sprite 6, x=3
                          ; (ENTITY18)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x07: Cuckoo's Nest (teleport: 1239)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$F0,$00,$00,$00
  DEFB $00,$00,$00,$01,$54,$00,$00,$00
  DEFB $00,$00,$00,$05,$54,$00,$00,$00
  DEFB $AA,$AA,$AA,$A9,$54,$00,$00,$00
  DEFB $00,$00,$00,$05,$50,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         Cuckoo's Nest          " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$04,$03,$C9,$D8,$30,$36,$23,$01 ; Floor
  DEFB $16,$FF,$60,$0E,$F0,$03,$3C,$C7,$38 ; Wall
  DEFB $06,$C2,$34,$0B,$44,$88,$0B,$30,$08 ; Nasty
  DEFB $07,$03,$00,$0C,$00,$30,$00,$C0,$00 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5F8D              ; Location in the attribute buffer at 24064: (12,13)
  DEFB $02                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $20,$18,$A9,$DB,$7E,$7E,$3C,$5A ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $08                ; Room to the left (Inside the MegaTrunk)
  DEFB $00                ; Room to the right (The Off Licence)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $02                ; Room below (Under the MegaTree)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $27,$90            ; Guardian no. 0x27 (horizontal), base sprite 4,
                          ; initial x=16 (ENTITY39)
  DEFB $6F,$05            ; Guardian no. 0x6F (horizontal), base sprite 0,
                          ; initial x=5 (ENTITY111)
  DEFB $3C,$A4            ; Arrow flying left to right at pixel y-coordinate 82
                          ; (ENTITY60)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x08: Inside the MegaTrunk (teleport: 49)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$08,$00,$08,$00,$00,$00 ; Room layout
  DEFB $00,$00,$08,$00,$08,$00,$00,$00
  DEFB $00,$00,$08,$00,$08,$00,$00,$00
  DEFB $00,$00,$08,$01,$40,$00,$00,$00
  DEFB $00,$00,$09,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$1A,$AA,$80,$00
  DEFB $00,$00,$00,$05,$08,$00,$00,$00
  DEFB $AA,$AA,$A8,$00,$08,$00,$00,$00
  DEFB $30,$C3,$09,$00,$08,$00,$00,$00
  DEFB $30,$C3,$08,$00,$58,$00,$00,$00
  DEFB $30,$C3,$08,$00,$08,$00,$00,$00
  DEFB $30,$C3,$08,$05,$00,$00,$00,$00
  DEFB $30,$C3,$08,$00,$00,$00,$00,$00
  DEFB $30,$C3,$09,$00,$0A,$AA,$AA,$AA
  DEFB $30,$C3,$08,$00,$08,$00,$00,$00
  DEFB $30,$C3,$08,$00,$58,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "      Inside the MegaTrunk      " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$F5,$FA,$BF,$1F,$26,$14,$22,$10 ; Floor
  DEFB $16,$AB,$AB,$AD,$AA,$AA,$AE,$55,$55 ; Wall
  DEFB $06,$6E,$74,$38,$1E,$6E,$74,$38,$1E ; Nasty
  DEFB $07,$40,$00,$10,$00,$04,$00,$01,$00 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5EFB              ; Location in the attribute buffer at 24064: (7,27)
  DEFB $03                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $04                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $09                ; Room to the left (On a Branch Over the Drive)
  DEFB $07                ; Room to the right (Cuckoo's Nest)
  DEFB $0C                ; Room above (Tree Top)
  DEFB $03                ; Room below (At the Foot of the MegaTree)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $09,$02            ; Guardian no. 0x09 (vertical), base sprite 0, x=2
                          ; (ENTITY9)
  DEFB $09,$05            ; Guardian no. 0x09 (vertical), base sprite 0, x=5
                          ; (ENTITY9)
  DEFB $09,$08            ; Guardian no. 0x09 (vertical), base sprite 0, x=8
                          ; (ENTITY9)
  DEFB $18,$06            ; Guardian no. 0x18 (horizontal), base sprite 0,
                          ; initial x=6 (ENTITY24)
  DEFB $2C,$2C            ; Guardian no. 0x2C (vertical), base sprite 1, x=12
                          ; (ENTITY44)
  DEFB $16,$1B            ; Guardian no. 0x16 (horizontal), base sprite 0,
                          ; initial x=27 (ENTITY22)
  DEFB $2F,$93            ; Guardian no. 0x2F (horizontal), base sprite 4,
                          ; initial x=19 (ENTITY47)
  DEFB $FF,$00            ; Terminator (ENTITY127)

; Room 0x09: On a Branch Over the Drive (teleport: 149)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$3C,$00,$00,$00,$00,$00
  DEFB $00,$00,$FD,$50,$00,$00,$00,$00
  DEFB $00,$00,$3F,$C0,$05,$55,$55,$55
  DEFB $00,$00,$00,$00,$0F,$BF,$3B,$C0
  DEFB $00,$00,$00,$00,$03,$F0,$3B,$00
  DEFB $00,$00,$00,$00,$00,$00,$0F,$00
  DEFB $00,$00,$00,$50,$00,$00,$00,$00
  DEFB $00,$50,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$05,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "   On a Branch Over the Drive   " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $08,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $0A,$1F,$F3,$E1,$60,$30,$2C,$40,$80 ; Floor
  DEFB $4A,$09,$12,$0A,$1F,$E4,$08,$08,$08 ; Wall
  DEFB $0C,$42,$29,$54,$26,$87,$23,$2A,$04 ; Nasty
  DEFB $0F,$05,$02,$04,$08,$50,$20,$40,$80 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5F4E              ; Location in the attribute buffer at 24064: (10,14)
  DEFB $04                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $30,$3C,$4F,$43,$82,$86,$E4,$FC ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $0A                ; Room to the left (The Front Door)
  DEFB $08                ; Room to the right (Inside the MegaTrunk)
  DEFB $0D                ; Room above (Out on a limb)
  DEFB $04                ; Room below (The Drive)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $09,$1E            ; Guardian no. 0x09 (vertical), base sprite 0, x=30
                          ; (ENTITY9)
  DEFB $1B,$87            ; Guardian no. 0x1B (vertical), base sprite 4, x=7
                          ; (ENTITY27)
  DEFB $3D,$13            ; Guardian no. 0x3D (horizontal), base sprite 0,
                          ; initial x=19 (ENTITY61)
  DEFB $3E,$0E            ; Guardian no. 0x3E (vertical), base sprite 0, x=14
                          ; (ENTITY62)
  DEFB $3C,$44            ; Arrow flying left to right at pixel y-coordinate 34
                          ; (ENTITY60)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x0A: The Front Door (teleport: 249)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$AA,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $40,$00,$00,$00,$00,$00,$00,$00
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         The Front Door         " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $28,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $47,$FF,$AA,$77,$AA,$77,$AA,$55,$AA ; Floor
  DEFB $3A,$20,$10,$0E,$C1,$30,$09,$C6,$20 ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $2F,$C0,$40,$B0,$50,$AC,$54,$AB,$55 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5FE2              ; Location in the attribute buffer at 24064: (15,2)
  DEFB $02                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $0C,$1C,$1C,$1E,$1B,$3F,$78,$FF ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $0B                ; Room to the left (The Hall)
  DEFB $09                ; Room to the right (On a Branch Over the Drive)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $05                ; Room below (The Security Guard)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x0B: The Hall (teleport: 1249)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  DEFB $00,$00,$00,$00,$00,$28,$00,$00
  DEFB $00,$00,$00,$00,$00,$28,$00,$00
  DEFB $00,$00,$00,$00,$00,$28,$00,$00
  DEFB $00,$00,$00,$00,$00,$28,$00,$00
  DEFB $00,$00,$00,$00,$00,$28,$00,$00
  DEFB $00,$00,$00,$00,$00,$28,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$C0,$C0,$30,$00,$00,$00
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "            The Hall            " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $47,$FF,$AA,$77,$AA,$77,$AA,$55,$AA ; Floor (unused)
  DEFB $3A,$20,$10,$0E,$C1,$30,$09,$C6,$20 ; Wall
  DEFB $44,$88,$A9,$A9,$BB,$BF,$BF,$BF,$5E ; Nasty
  DEFB $07,$C0,$C0,$30,$30,$0C,$0C,$03,$03 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5FA5              ; Location in the attribute buffer at 24064: (13,5)
  DEFB $06                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $04                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $14                ; Room to the left (Ballroom East)
  DEFB $0A                ; Room to the right (The Front Door)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $59,$CA            ; Guardian no. 0x59 (vertical), base sprite 6, x=10
                          ; (ENTITY89)
  DEFB $1A,$13            ; Guardian no. 0x1A (horizontal), base sprite 0,
                          ; initial x=19 (ENTITY26)
  DEFB $5F,$13            ; Guardian no. 0x5F (horizontal), base sprite 0,
                          ; initial x=19 (ENTITY95)
  DEFB $45,$44            ; Arrow flying right to left at pixel y-coordinate 34
                          ; (ENTITY69)
  DEFB $3C,$16            ; Arrow flying left to right at pixel y-coordinate 11
                          ; (ENTITY60)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $59,$00            ; Guardian no. 0x59 (vertical), base sprite 0, x=0
                          ; (ENTITY89) (unused)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x0C: Tree Top (teleport: 349)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$40,$00,$00,$00
  DEFB $00,$00,$54,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$14,$00,$04,$00,$00
  DEFB $01,$50,$00,$00,$14,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$14,$00,$00
  DEFB $55,$55,$54,$00,$08,$00,$00,$00
  DEFB $0C,$F3,$C8,$10,$08,$00,$50,$00
  DEFB $CF,$3F,$08,$00,$08,$50,$00,$00
  DEFB $30,$30,$08,$00,$58,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "            Tree Top            " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$AA,$55,$AA,$58,$30,$10,$10,$08 ; Floor
  DEFB $16,$A5,$28,$52,$55,$55,$49,$A2,$B5 ; Wall
  DEFB $42,$89,$4A,$12,$34,$18,$34,$52,$91 ; Nasty
  DEFB $07,$40,$00,$10,$00,$04,$00,$01,$00 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5FCF              ; Location in the attribute buffer at 24064: (14,15)
  DEFB $02                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $06                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $1E,$2D,$37,$7B,$6D,$5E,$B8,$C0 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $0D                ; Room to the left (Out on a limb)
  DEFB $00                ; Room to the right (The Off Licence)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $08                ; Room below (Inside the MegaTrunk)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $18,$07            ; Guardian no. 0x18 (horizontal), base sprite 0,
                          ; initial x=7 (ENTITY24)
  DEFB $2E,$88            ; Guardian no. 0x2E (horizontal), base sprite 4,
                          ; initial x=8 (ENTITY46)
  DEFB $1A,$18            ; Guardian no. 0x1A (horizontal), base sprite 0,
                          ; initial x=24 (ENTITY26)
  DEFB $45,$84            ; Arrow flying right to left at pixel y-coordinate 66
                          ; (ENTITY69)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x0D: Out on a limb (teleport: 1349)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$04,$00,$00,$00,$00
  DEFB $00,$10,$00,$00,$04,$01,$00,$00
  DEFB $00,$00,$04,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$10,$00
  DEFB $00,$00,$00,$01,$00,$40,$00,$00
  DEFB $04,$00,$00,$04,$40,$00,$00,$00
  DEFB $00,$04,$00,$01,$10,$00,$00,$00
  DEFB $00,$00,$01,$00,$4A,$AA,$AA,$AA
  DEFB $01,$00,$00,$00,$00,$7F,$FF,$00
  DEFB $00,$00,$40,$00,$40,$1F,$FC,$00
  DEFB $00,$00,$00,$40,$00,$01,$50,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "        Out on a limb           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$01,$1E,$06,$7A,$1A,$E8,$68,$A0 ; Floor
  DEFB $42,$07,$FF,$FC,$38,$18,$10,$20,$00 ; Wall
  DEFB $02,$01,$81,$06,$58,$20,$40,$88,$82 ; Nasty
  DEFB $04,$00,$00,$00,$00,$00,$00,$00,$00 ; Ramp (unused)
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $05                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $60,$B8,$BE,$5D,$5A,$35,$2A,$15 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $0A                ; Room to the left (The Front Door)
  DEFB $0C                ; Room to the right (Tree Top)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $09                ; Room below (On a Branch Over the Drive)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $2D,$4C            ; Guardian no. 0x2D (vertical), base sprite 2, x=12
                          ; (ENTITY45)
  DEFB $19,$13            ; Guardian no. 0x19 (horizontal), base sprite 0,
                          ; initial x=19 (ENTITY25)
  DEFB $58,$14            ; Guardian no. 0x58 (horizontal), base sprite 0,
                          ; initial x=20 (ENTITY88)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x0E: Rescue Esmerelda (teleport: 2349)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$08,$02 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$08,$02
  DEFB $00,$00,$00,$00,$00,$00,$00,$02
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$AA,$00
  DEFB $00,$00,$00,$00,$00,$00,$08,$06
  DEFB $00,$00,$00,$00,$00,$00,$00,$12
  DEFB $00,$00,$00,$00,$00,$00,$00,$42
  DEFB $00,$00,$00,$00,$00,$00,$01,$02
  DEFB $AA,$06,$AA,$06,$AA,$0A,$AA,$06
  DEFB $AA,$0E,$AA,$0E,$AA,$00,$00,$06
  DEFB $AA,$0E,$AA,$0E,$AA,$00,$00,$06
  DEFB $AA,$0E,$AA,$0E,$AA,$80,$00,$12
  DEFB $AA,$0E,$AA,$0E,$AA,$A0,$00,$40
  DEFB $AA,$0E,$AA,$0E,$AA,$A8,$01,$00
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$04,$0A
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "        Rescue Esmerelda        " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $10,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $17,$03,$03,$0C,$0C,$31,$32,$C4,$C8 ; Floor
  DEFB $04,$EE,$00,$BB,$00,$EE,$00,$BB,$00 ; Wall
  DEFB $55,$D1,$E2,$C4,$C8,$D1,$E2,$C4,$C8 ; Nasty
  DEFB $17,$00,$00,$00,$00,$00,$00,$00,$00 ; Ramp (unused)
  DEFB $16,$F1,$AA,$F8,$AA,$00,$EE,$00,$BB ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5E98              ; Location in the attribute buffer at 24064: (4,24)
  DEFB $04                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $FF,$49,$49,$49,$49,$49,$49,$FF ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $0F                ; Room to the left (I'm sure I've seen this before..)
  DEFB $2C                ; Room to the right (On top of the house)
  DEFB $14                ; Room above (Ballroom East)
  DEFB $27                ; Room below (Emergency Generator)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $04,$C4            ; Guardian no. 0x04 (vertical), base sprite 6, x=4
                          ; (ENTITY4)
  DEFB $02,$CC            ; Guardian no. 0x02 (vertical), base sprite 6, x=12
                          ; (ENTITY2)
  DEFB $0D,$05            ; Guardian no. 0x0D (horizontal), base sprite 0,
                          ; initial x=5 (ENTITY13)
  DEFB $0F,$98            ; Guardian no. 0x0F (vertical), base sprite 4, x=24
                          ; (ENTITY15)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x0F: I'm sure I've seen this before.. (teleport: 12349)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$42,$A4,$2A,$A4,$2A,$42,$AA
  DEFB $AA,$C2,$AC,$2A,$AC,$2A,$C2,$AA
  DEFB $AA,$C2,$AC,$2A,$AC,$2A,$C2,$AA
  DEFB $AA,$C2,$AC,$2A,$AC,$2A,$C2,$AA
  DEFB $AA,$C2,$AC,$2A,$AC,$2A,$C2,$AA
  DEFB $AA,$C2,$AC,$2A,$AC,$2A,$C2,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "I'm sure I've seen this before.." ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $08,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $0C,$80,$40,$20,$50,$48,$54,$52,$55 ; Floor
  DEFB $53,$66,$66,$66,$00,$66,$66,$66,$66 ; Wall
  DEFB $4C,$51,$55,$54,$55,$15,$55,$45,$55 ; Nasty
  DEFB $0C,$00,$00,$00,$00,$00,$00,$00,$00 ; Ramp (unused)
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $03                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $18,$24,$18,$2C,$5E,$5E,$E7,$66 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $10                ; Room to the left (We must perform a Quirkafleeg)
  DEFB $0E                ; Room to the right (Rescue Esmerelda)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $04,$85            ; Guardian no. 0x04 (vertical), base sprite 4, x=5
                          ; (ENTITY4)
  DEFB $03,$8B            ; Guardian no. 0x03 (vertical), base sprite 4, x=11
                          ; (ENTITY3)
  DEFB $05,$93            ; Guardian no. 0x05 (vertical), base sprite 4, x=19
                          ; (ENTITY5)
  DEFB $02,$99            ; Guardian no. 0x02 (vertical), base sprite 4, x=25
                          ; (ENTITY2)
  DEFB $0D,$06            ; Guardian no. 0x0D (horizontal), base sprite 0,
                          ; initial x=6 (ENTITY13)
  DEFB $45,$64            ; Arrow flying right to left at pixel y-coordinate 50
                          ; (ENTITY69)
  DEFB $3C,$54            ; Arrow flying left to right at pixel y-coordinate 42
                          ; (ENTITY60)
  DEFB $FF,$00            ; Terminator (ENTITY127)

; Room 0x10: We must perform a Quirkafleeg (teleport: 59)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$00,$00,$00,$00,$00,$02,$AA
  DEFB $AA,$40,$00,$00,$00,$00,$02,$AA
  DEFB $AA,$40,$00,$00,$00,$00,$02,$AA
  DEFB $AA,$40,$00,$00,$00,$00,$02,$AA
  DEFB $AA,$40,$00,$00,$00,$00,$02,$AA
  DEFB $AA,$40,$00,$00,$00,$00,$02,$AA
  DEFB $AA,$7F,$FF,$FF,$FF,$FF,$FE,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "  We must perform a Quirkafleeg " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $06,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $38,$33,$BB,$DD,$CC,$55,$99,$DD,$EE ; Floor
  DEFB $0D,$27,$F6,$00,$DC,$D1,$04,$77,$80 ; Wall
  DEFB $45,$40,$E4,$4E,$44,$44,$44,$EE,$FF ; Nasty
  DEFB $07,$80,$40,$20,$30,$A8,$64,$22,$11 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5F24              ; Location in the attribute buffer at 24064: (9,4)
  DEFB $01                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $18,$24,$18,$2C,$5E,$5E,$E7,$66 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $11                ; Room to the left (Up on the Battlements)
  DEFB $0F                ; Room to the right (I'm sure I've seen this
                          ; before..)
  DEFB $32                ; Room above (Watch Tower)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $0D,$08            ; Guardian no. 0x0D (horizontal), base sprite 0,
                          ; initial x=8 (ENTITY13)
  DEFB $01,$10            ; Rope at x=16 (ENTITY1)
  DEFB $3C,$84            ; Arrow flying left to right at pixel y-coordinate 66
                          ; (ENTITY60)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x11: Up on the Battlements (teleport: 159)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$42,$A4,$2A,$A4,$2A,$42,$AA
  DEFB $AA,$C2,$AC,$2A,$AC,$2A,$C2,$AA
  DEFB $AA,$C2,$AC,$2A,$AC,$2A,$C2,$AA
  DEFB $AA,$C2,$AC,$2A,$AC,$2A,$C2,$AA
  DEFB $AA,$C2,$AC,$2A,$AC,$2A,$C2,$AA
  DEFB $AA,$C2,$AC,$2A,$AC,$2A,$C2,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "      Up on the Battlements     " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$80,$C0,$E0,$B0,$90,$94,$D6,$77 ; Floor
  DEFB $0E,$00,$7F,$7F,$63,$6B,$63,$7F,$7F ; Wall
  DEFB $20,$4A,$2A,$1A,$48,$6C,$6A,$29,$88 ; Nasty
  DEFB $04,$00,$00,$00,$00,$00,$00,$00,$00 ; Ramp (unused)
  DEFB $42,$28,$AA,$0A,$00,$55,$55,$55,$FF ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5F2D              ; Location in the attribute buffer at 24064: (9,13)
  DEFB $05                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $18,$24,$18,$2C,$5E,$5E,$E7,$66 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $12                ; Room to the left (On the Roof)
  DEFB $10                ; Room to the right (We must perform a Quirkafleeg)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $02,$85            ; Guardian no. 0x02 (vertical), base sprite 4, x=5
                          ; (ENTITY2)
  DEFB $03,$8B            ; Guardian no. 0x03 (vertical), base sprite 4, x=11
                          ; (ENTITY3)
  DEFB $04,$93            ; Guardian no. 0x04 (vertical), base sprite 4, x=19
                          ; (ENTITY4)
  DEFB $05,$99            ; Guardian no. 0x05 (vertical), base sprite 4, x=25
                          ; (ENTITY5)
  DEFB $45,$84            ; Arrow flying right to left at pixel y-coordinate 66
                          ; (ENTITY69)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x12: On the Roof (teleport: 259)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$0A,$40
  DEFB $00,$00,$00,$00,$00,$00,$0A,$D0
  DEFB $AA,$40,$00,$00,$00,$00,$0A,$AA
  DEFB $AA,$C0,$00,$00,$00,$00,$0A,$AA
  DEFB $AA,$C0,$00,$00,$00,$00,$0A,$AA
  DEFB $AA,$90,$00,$00,$00,$00,$0A,$AA
  DEFB $AA,$B0,$00,$00,$00,$00,$0A,$AA
  DEFB $AA,$B0,$0A,$40,$00,$00,$0A,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "          On the Roof           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $44,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $07,$80,$C0,$E0,$D0,$58,$9C,$DE,$CD ; Floor
  DEFB $26,$11,$F8,$07,$08,$F0,$0F,$D0,$3F ; Wall
  DEFB $46,$55,$99,$DD,$CC,$55,$99,$DD,$CC ; Nasty
  DEFB $07,$00,$00,$00,$00,$00,$00,$00,$00 ; Ramp (unused)
  DEFB $0A,$F0,$F0,$F0,$FF,$FF,$00,$00,$FF ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5FEE              ; Location in the attribute buffer at 24064: (15,14)
  DEFB $08                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $01,$02,$05,$0A,$54,$28,$30,$48 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $30                ; Room to the left (Nomen Luni)
  DEFB $11                ; Room to the right (Up on the Battlements)
  DEFB $12                ; Room above (On the Roof)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $22,$16            ; Guardian no. 0x22 (horizontal), base sprite 0,
                          ; initial x=22 (ENTITY34)
  DEFB $01,$10            ; Rope at x=16 (ENTITY1)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x13: The Forgotten Abbey (teleport: 1259)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; Room layout
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  DEFB $A0,$00,$30,$00,$C0,$00,$C0,$0A
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A8,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A0,$00,$00,$00,$30,$00,$00,$0A
  DEFB $A0,$00,$00,$00,$00,$00,$00,$1A
  DEFB $A5,$00,$00,$00,$00,$00,$00,$0A
  DEFB $50,$05,$55,$55,$55,$55,$55,$5A
  DEFB $50,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A8,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "      The Forgotten Abbey       " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$FF,$FF,$F2,$24,$40,$02,$00,$88 ; Floor
  DEFB $1D,$44,$AA,$11,$44,$11,$AA,$44,$11 ; Wall
  DEFB $42,$18,$3C,$7E,$99,$99,$7E,$42,$3C ; Nasty
  DEFB $07,$80,$40,$E0,$30,$A8,$D4,$22,$89 ; Ramp
  DEFB $0F,$70,$55,$00,$BB,$AA,$AA,$AA,$AA ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5EE4              ; Location in the attribute buffer at 24064: (7,4)
  DEFB $1A                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5FC4              ; Location in the attribute buffer at 24064: (14,4)
  DEFB $02                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $18,$24,$DB,$DB,$24,$18,$18,$18 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $31                ; Room to the left (The Wine Cellar)
  DEFB $05                ; Room to the right (The Security Guard)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $4A,$08            ; Guardian no. 0x4A (horizontal), base sprite 0,
                          ; initial x=8 (ENTITY74)
  DEFB $4B,$10            ; Guardian no. 0x4B (horizontal), base sprite 0,
                          ; initial x=16 (ENTITY75)
  DEFB $4C,$0B            ; Guardian no. 0x4C (horizontal), base sprite 0,
                          ; initial x=11 (ENTITY76)
  DEFB $4D,$18            ; Guardian no. 0x4D (horizontal), base sprite 0,
                          ; initial x=24 (ENTITY77)
  DEFB $4E,$07            ; Guardian no. 0x4E (horizontal), base sprite 0,
                          ; initial x=7 (ENTITY78)
  DEFB $4F,$0C            ; Guardian no. 0x4F (horizontal), base sprite 0,
                          ; initial x=12 (ENTITY79)
  DEFB $50,$12            ; Guardian no. 0x50 (horizontal), base sprite 0,
                          ; initial x=18 (ENTITY80)
  DEFB $51,$18            ; Guardian no. 0x51 (horizontal), base sprite 0,
                          ; initial x=24 (ENTITY81)

; Room 0x14: Ballroom East (teleport: 359)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $A0,$40,$0A,$00,$00,$00,$00,$00 ; Room layout
  DEFB $A0,$40,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$40,$0A,$00,$00,$00,$00,$00
  DEFB $00,$40,$00,$00,$00,$00,$00,$00
  DEFB $00,$40,$00,$00,$00,$00,$00,$00
  DEFB $55,$55,$5A,$0A,$AA,$AA,$AA,$AA
  DEFB $00,$00,$10,$00,$00,$00,$00,$00
  DEFB $00,$00,$10,$00,$00,$00,$00,$00
  DEFB $00,$00,$15,$55,$55,$55,$55,$55
  DEFB $00,$00,$10,$00,$00,$00,$00,$00
  DEFB $00,$00,$10,$00,$00,$00,$00,$00
  DEFB $00,$00,$10,$00,$00,$00,$00,$00
  DEFB $00,$00,$10,$00,$00,$00,$00,$00
  DEFB $00,$00,$10,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         Ballroom East          " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $06,$AA,$55,$22,$44,$22,$44,$22,$44 ; Floor
  DEFB $0F,$44,$44,$FF,$11,$11,$FF,$55,$AA ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Ramp (unused)
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $81,$81,$42,$24,$18,$18,$18,$E7 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $15                ; Room to the left (Ballroom West)
  DEFB $0B                ; Room to the right (The Hall)
  DEFB $1A                ; Room above (East Wall Base)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $13,$6C            ; Guardian no. 0x13 (vertical), base sprite 3, x=12
                          ; (ENTITY19)
  DEFB $2A,$05            ; Guardian no. 0x2A (vertical), base sprite 0, x=5
                          ; (ENTITY42)
  DEFB $28,$07            ; Guardian no. 0x28 (vertical), base sprite 0, x=7
                          ; (ENTITY40)
  DEFB $29,$2B            ; Guardian no. 0x29 (vertical), base sprite 1, x=11
                          ; (ENTITY41)
  DEFB $15,$18            ; Guardian no. 0x15 (horizontal), base sprite 0,
                          ; initial x=24 (ENTITY21)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x15: Ballroom West (teleport: 1359)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $55,$55,$55,$55,$55,$55,$55,$55
  DEFB $00,$00,$A0,$00,$00,$00,$00,$00
  DEFB $00,$00,$A0,$00,$00,$00,$00,$00
  DEFB $00,$00,$A0,$00,$00,$00,$55,$55
  DEFB $00,$00,$A0,$00,$00,$00,$00,$00
  DEFB $00,$00,$A0,$00,$00,$00,$00,$00
  DEFB $00,$00,$A0,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $55,$55,$55,$55,$55,$55,$55,$55
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         Ballroom West          " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $32,$AA,$A8,$AD,$AF,$20,$AA,$55,$55 ; Floor
  DEFB $23,$11,$22,$88,$11,$44,$88,$22,$44 ; Wall
  DEFB $42,$28,$54,$AA,$54,$A8,$54,$14,$2E ; Nasty (unused)
  DEFB $07,$C0,$C0,$30,$B0,$0C,$0C,$03,$0B ; Ramp
  DEFB $46,$FF,$FF,$FF,$AA,$55,$18,$18,$18 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5FB0              ; Location in the attribute buffer at 24064: (13,16)
  DEFB $0C                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5FA3              ; Location in the attribute buffer at 24064: (13,3)
  DEFB $04                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $04,$04,$AE,$AE,$A2,$42,$42,$EE ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $16                ; Room to the left (To the Kitchens    Main Stairway)
  DEFB $14                ; Room to the right (Ballroom East)
  DEFB $1B                ; Room above (The Chapel)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $21,$18            ; Guardian no. 0x21 (horizontal), base sprite 0,
                          ; initial x=24 (ENTITY33)
  DEFB $28,$0E            ; Guardian no. 0x28 (vertical), base sprite 0, x=14
                          ; (ENTITY40)
  DEFB $2A,$06            ; Guardian no. 0x2A (vertical), base sprite 0, x=6
                          ; (ENTITY42)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x16: To the Kitchens    Main Stairway (teleport: 2359)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$80,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$80,$00,$00,$00,$00,$00
  DEFB $00,$00,$80,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$03,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$01,$95,$55,$55,$50,$00,$55
  DEFB $00,$00,$80,$00,$00,$00,$00,$00
  DEFB $00,$00,$80,$00,$00,$00,$00,$00
  DEFB $A5,$55,$85,$00,$00,$00,$00,$00
  DEFB $A0,$00,$80,$00,$00,$00,$55,$40
  DEFB $A0,$00,$80,$00,$01,$40,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "To the Kitchens    Main Stairway" ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $08,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $0D,$FF,$FF,$00,$FF,$00,$00,$00,$00 ; Floor
  DEFB $3A,$00,$15,$BF,$15,$00,$51,$FB,$51 ; Wall
  DEFB $4D,$18,$5A,$BD,$19,$7E,$99,$24,$24 ; Nasty
  DEFB $0F,$C0,$80,$30,$20,$0C,$08,$03,$02 ; Ramp
  DEFB $6B,$F0,$AA,$78,$FF,$AA,$55,$AA,$55 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5F0E              ; Location in the attribute buffer at 24064: (8,14)
  DEFB $02                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5F7F              ; Location in the attribute buffer at 24064: (11,31)
  DEFB $0C                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $04                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $40,$A0,$F0,$F8,$FC,$7A,$25,$02 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $17                ; Room to the left (The Kitchen)
  DEFB $15                ; Room to the right (Ballroom West)
  DEFB $1C                ; Room above (First Landing)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $5A,$04            ; Guardian no. 0x5A (horizontal), base sprite 0,
                          ; initial x=4 (ENTITY90)
  DEFB $5B,$10            ; Guardian no. 0x5B (horizontal), base sprite 0,
                          ; initial x=16 (ENTITY91)
  DEFB $5C,$96            ; Guardian no. 0x5C (horizontal), base sprite 4,
                          ; initial x=22 (ENTITY92)
  DEFB $5D,$04            ; Guardian no. 0x5D (horizontal), base sprite 0,
                          ; initial x=4 (ENTITY93)
  DEFB $5E,$96            ; Guardian no. 0x5E (horizontal), base sprite 4,
                          ; initial x=22 (ENTITY94)
  DEFB $5F,$0B            ; Guardian no. 0x5F (horizontal), base sprite 0,
                          ; initial x=11 (ENTITY95)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x17: The Kitchen (teleport: 12359)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $54,$15,$41,$50,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$04,$00,$00,$00
  DEFB $54,$15,$40,$00,$00,$00,$00,$2A
  DEFB $00,$00,$01,$50,$00,$00,$00,$AA
  DEFB $00,$00,$00,$00,$00,$00,$02,$AA
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $54,$15,$41,$50,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$15,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$02,$AA,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "          The Kitchen           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$FE,$01,$7D,$85,$81,$81,$81,$01 ; Floor
  DEFB $4D,$42,$A5,$5A,$24,$24,$5A,$A5,$42 ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $47,$03,$00,$0C,$00,$30,$00,$C0,$00 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FD6              ; Location in the attribute buffer at 24064: (14,22)
  DEFB $07                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $04                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $20,$40,$A0,$18,$16,$09,$08,$04 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $18                ; Room to the left (West of Kitchen)
  DEFB $16                ; Room to the right (To the Kitchens    Main
                          ; Stairway)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $30,$03            ; Guardian no. 0x30 (vertical), base sprite 0, x=3
                          ; (ENTITY48)
  DEFB $31,$09            ; Guardian no. 0x31 (vertical), base sprite 0, x=9
                          ; (ENTITY49)
  DEFB $32,$0F            ; Guardian no. 0x32 (vertical), base sprite 0, x=15
                          ; (ENTITY50)
  DEFB $30,$14            ; Guardian no. 0x30 (vertical), base sprite 0, x=20
                          ; (ENTITY48)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x18: West of Kitchen (teleport: 459)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$01,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$01,$00,$00,$00,$00,$00
  DEFB $00,$00,$01,$00,$00,$00,$00,$00
  DEFB $00,$00,$01,$00,$00,$00,$00,$00
  DEFB $00,$00,$01,$00,$00,$00,$00,$00
  DEFB $00,$00,$01,$00,$10,$05,$54,$15
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $A0,$00,$00,$00,$00,$04,$00,$15
  DEFB $A8,$00,$00,$00,$15,$00,$50,$00
  DEFB $AA,$00,$00,$50,$00,$00,$00,$00
  DEFB $AA,$80,$00,$00,$00,$00,$00,$00
  DEFB $AA,$A0,$00,$00,$15,$05,$54,$15
  DEFB $AA,$A8,$00,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$00,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "    West of Kitchen             " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room. Note that because of a bug
; in the game engine, the conveyor tile is not drawn correctly (see the room
; image above).
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $05,$FF,$BD,$A5,$A5,$A5,$42,$00,$00 ; Floor
  DEFB $22,$09,$42,$90,$24,$09,$42,$90,$24 ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $47,$C0,$40,$B0,$50,$AC,$54,$AB,$55 ; Ramp
  DEFB $42,$F0,$55,$AA,$55,$55,$AA,$2A,$08 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5F96              ; Location in the attribute buffer at 24064: (12,22)
  DEFB $05                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5FC8              ; Location in the attribute buffer at 24064: (14,8)
  DEFB $07                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $19                ; Room to the left (Cold Store)
  DEFB $17                ; Room to the right (The Kitchen)
  DEFB $1E                ; Room above (The Banyan Tree)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $31,$09            ; Guardian no. 0x31 (vertical), base sprite 0, x=9
                          ; (ENTITY49)
  DEFB $32,$0E            ; Guardian no. 0x32 (vertical), base sprite 0, x=14
                          ; (ENTITY50)
  DEFB $31,$14            ; Guardian no. 0x31 (vertical), base sprite 0, x=20
                          ; (ENTITY49)
  DEFB $30,$1B            ; Guardian no. 0x30 (vertical), base sprite 0, x=27
                          ; (ENTITY48)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x19: Cold Store (teleport: 1459)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$03,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$30,$00,$00,$C0,$00
  DEFB $54,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$C0,$03,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $55,$55,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $55,$50,$00,$00,$00,$00,$0A,$AA
  DEFB $00,$00,$00,$00,$00,$00,$0A,$AA
  DEFB $00,$00,$00,$00,$00,$00,$0A,$AA
  DEFB $55,$50,$00,$00,$00,$00,$0A,$AA
  DEFB $00,$00,$30,$00,$00,$14,$0A,$AA
  DEFB $00,$00,$00,$00,$00,$00,$0A,$AA
  DEFB $00,$00,$00,$00,$00,$00,$0A,$AA
  DEFB $55,$55,$55,$55,$55,$55,$5A,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "           Cold Store           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $0E,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $0D,$FF,$FF,$55,$AA,$55,$AA,$00,$00 ; Floor
  DEFB $22,$92,$52,$4A,$49,$29,$25,$A4,$92 ; Wall
  DEFB $4F,$20,$22,$14,$D8,$1B,$28,$44,$04 ; Nasty
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Ramp (unused)
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $70,$8C,$72,$FA,$EF,$AD,$25,$21 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $34                ; Room to the left (Back Stairway)
  DEFB $18                ; Room to the right (West of Kitchen)
  DEFB $1F                ; Room above (Swimming Pool)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $36,$10            ; Guardian no. 0x36 (horizontal), base sprite 0,
                          ; initial x=16 (ENTITY54)
  DEFB $37,$04            ; Guardian no. 0x37 (horizontal), base sprite 0,
                          ; initial x=4 (ENTITY55)
  DEFB $38,$03            ; Guardian no. 0x38 (horizontal), base sprite 0,
                          ; initial x=3 (ENTITY56)
  DEFB $39,$08            ; Guardian no. 0x39 (horizontal), base sprite 0,
                          ; initial x=8 (ENTITY57)
  DEFB $01,$10            ; Rope at x=16 (ENTITY1)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x1A: East Wall Base (teleport: 2459)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00 ; Room layout
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$1A,$00,$00,$00,$00,$00
  DEFB $A0,$04,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A4,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$04,$00,$00,$00,$00,$00,$00
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
  DEFB $A0,$00,$1A,$00,$00,$00,$00,$00
  DEFB $A0,$10,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$04,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$1A,$00,$00,$00,$00,$00
  DEFB $A0,$40,$0A,$00,$00,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         East Wall Base         " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $05,$5B,$A4,$A4,$55,$0A,$00,$00,$00 ; Floor
  DEFB $26,$59,$25,$26,$D9,$29,$D6,$54,$96 ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Ramp (unused)
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $05                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $1B                ; Room to the left (The Chapel)
  DEFB $00                ; Room to the right (The Off Licence)
  DEFB $20                ; Room above (Halfway up the East Wall)
  DEFB $14                ; Room below (Ballroom East)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $60,$03            ; Guardian no. 0x60 (vertical), base sprite 0, x=3
                          ; (ENTITY96)
  DEFB $2D,$27            ; Guardian no. 0x2D (vertical), base sprite 1, x=7
                          ; (ENTITY45)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x1B: The Chapel (teleport: 12459)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$80,$1A
  DEFB $00,$00,$00,$00,$00,$02,$80,$1A
  DEFB $00,$00,$00,$00,$00,$0A,$80,$1A
  DEFB $00,$00,$00,$00,$00,$2A,$80,$1A
  DEFB $00,$00,$00,$00,$00,$AA,$80,$1A
  DEFB $00,$00,$00,$00,$00,$00,$00,$1A
  DEFB $00,$00,$00,$00,$00,$00,$00,$1A
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$A0,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$A0,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "           The Chapel           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $0D,$49,$49,$49,$49,$49,$49,$49,$49 ; Floor
  DEFB $16,$A8,$25,$00,$25,$A8,$40,$DD,$40 ; Wall
  DEFB $42,$28,$54,$AA,$55,$AA,$28,$28,$28 ; Nasty (unused)
  DEFB $07,$03,$00,$0C,$00,$30,$00,$C0,$00 ; Ramp
  DEFB $07,$00,$0A,$BD,$FF,$00,$AA,$55,$AA ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FB1              ; Location in the attribute buffer at 24064: (13,17)
  DEFB $07                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $10,$30,$38,$6C,$C6,$C6,$6C,$10 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $1C                ; Room to the left (First Landing)
  DEFB $1A                ; Room to the right (East Wall Base)
  DEFB $21                ; Room above (The Bathroom)
  DEFB $15                ; Room below (Ballroom West)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $10,$99            ; Guardian no. 0x10 (vertical), base sprite 4, x=25
                          ; (ENTITY16)
  DEFB $11,$BB            ; Guardian no. 0x11 (vertical), base sprite 5, x=27
                          ; (ENTITY17)
  DEFB $12,$DA            ; Guardian no. 0x12 (vertical), base sprite 6, x=26
                          ; (ENTITY18)
  DEFB $67,$0C            ; Guardian no. 0x67 (horizontal), base sprite 0,
                          ; initial x=12 (ENTITY103)
  DEFB $64,$06            ; Guardian no. 0x64 (vertical), base sprite 0, x=6
                          ; (ENTITY100)
  DEFB $66,$91            ; Guardian no. 0x66 (vertical), base sprite 4, x=17
                          ; (ENTITY102)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x1C: First Landing (teleport: 3459)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $A0,$00,$00,$00,$00,$00,$A0,$00 ; Room layout
  DEFB $A0,$00,$00,$00,$00,$00,$A0,$00
  DEFB $A0,$00,$00,$00,$00,$00,$A0,$00
  DEFB $A0,$00,$00,$00,$00,$00,$00,$30
  DEFB $A0,$00,$00,$00,$00,$00,$00,$FC
  DEFB $A0,$00,$00,$00,$00,$0A,$A0,$30
  DEFB $A0,$00,$00,$00,$00,$00,$A0,$30
  DEFB $A0,$00,$00,$00,$00,$00,$A0,$30
  DEFB $A0,$00,$00,$00,$00,$00,$A0,$00
  DEFB $A0,$00,$00,$00,$00,$00,$A0,$00
  DEFB $A0,$00,$00,$00,$00,$00,$A0,$00
  DEFB $A0,$00,$00,$00,$00,$00,$A0,$00
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$99,$99
  DEFB $55,$55,$55,$55,$55,$50,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "        First Landing           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$FF,$AA,$55,$80,$5D,$94,$5D,$80 ; Floor
  DEFB $0E,$22,$55,$00,$55,$88,$55,$00,$22 ; Wall
  DEFB $D6,$7E,$81,$A5,$99,$99,$A5,$81,$7E ; Nasty
  DEFB $07,$03,$03,$0C,$0C,$30,$30,$C0,$C0 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FC9              ; Location in the attribute buffer at 24064: (14,9)
  DEFB $0F                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $03                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$18,$3C,$3C,$18,$18,$18,$00 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $1D                ; Room to the left (The Nightmare Room)
  DEFB $1B                ; Room to the right (The Chapel)
  DEFB $22                ; Room above (Top Landing)
  DEFB $16                ; Room below (To the Kitchens    Main Stairway)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $43,$19            ; Guardian no. 0x43 (horizontal), base sprite 0,
                          ; initial x=25 (ENTITY67)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x1D: The Nightmare Room (teleport: 13459)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$04,$00,$40,$04,$00,$0A
  DEFB $00,$00,$00,$10,$00,$00,$00,$0A
  DEFB $00,$01,$00,$00,$01,$00,$00,$0A
  DEFB $00,$00,$04,$00,$00,$04,$00,$0A
  DEFB $00,$00,$00,$10,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$01,$00,$04,$0A
  DEFB $00,$00,$04,$00,$00,$04,$00,$0A
  DEFB $AA,$A8,$00,$10,$00,$00,$00,$0A
  DEFB $AA,$AA,$00,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$80,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "       The Nightmare Room       " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room. Note that because of a bug
; in the game engine, the conveyor tile is not drawn correctly (see the room
; image above).
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $44,$FF,$A5,$52,$24,$42,$22,$40,$04 ; Floor
  DEFB $33,$00,$2A,$54,$00,$00,$A2,$45,$00 ; Wall
  DEFB $45,$42,$99,$66,$A1,$9F,$81,$66,$5A ; Nasty (unused)
  DEFB $07,$80,$C0,$A0,$F0,$F8,$5C,$BA,$55 ; Ramp
  DEFB $02,$A5,$FF,$5A,$FF,$FF,$AA,$55,$AA ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5EFB              ; Location in the attribute buffer at 24064: (7,27)
  DEFB $01                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5FC9              ; Location in the attribute buffer at 24064: (14,9)
  DEFB $03                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $AC,$AE,$01,$AD,$AD,$02,$AC,$58 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $1E                ; Room to the left (The Banyan Tree)
  DEFB $1C                ; Room to the right (First Landing)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $46,$88            ; Guardian no. 0x46 (vertical), base sprite 4, x=8
                          ; (ENTITY70)
  DEFB $47,$CB            ; Guardian no. 0x47 (vertical), base sprite 6, x=11
                          ; (ENTITY71)
  DEFB $48,$4E            ; Guardian no. 0x48 (vertical), base sprite 2, x=14
                          ; (ENTITY72)
  DEFB $49,$D1            ; Guardian no. 0x49 (vertical), base sprite 6, x=17
                          ; (ENTITY73)
  DEFB $46,$94            ; Guardian no. 0x46 (vertical), base sprite 4, x=20
                          ; (ENTITY70)
  DEFB $47,$97            ; Guardian no. 0x47 (vertical), base sprite 4, x=23
                          ; (ENTITY71)
  DEFB $48,$9C            ; Guardian no. 0x48 (vertical), base sprite 4, x=28
                          ; (ENTITY72)
  DEFB $FF,$00            ; Terminator (ENTITY127)

; Room 0x1E: The Banyan Tree (teleport: 23459)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$A0,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$A0,$00,$00,$00,$00
  DEFB $00,$00,$00,$90,$00,$00,$00,$00
  DEFB $00,$00,$00,$94,$00,$00,$00,$00
  DEFB $00,$00,$00,$95,$50,$00,$00,$00
  DEFB $00,$00,$00,$81,$04,$00,$00,$00
  DEFB $00,$00,$00,$01,$04,$00,$00,$00
  DEFB $00,$00,$00,$00,$04,$00,$00,$00
  DEFB $00,$00,$00,$80,$00,$00,$00,$00
  DEFB $00,$00,$00,$82,$00,$00,$00,$00
  DEFB $00,$08,$20,$82,$08,$00,$00,$00
  DEFB $00,$08,$20,$82,$08,$00,$00,$00
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$5A,$AA
  DEFB $AA,$AA,$00,$00,$00,$00,$5A,$AA
  DEFB $AA,$AA,$00,$00,$00,$00,$5A,$AA
  DEFB $AA,$AA,$55,$55,$55,$55,$5A,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "       The Banyan Tree          " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $48,$00,$A2,$00,$00,$00,$46,$00,$93 ; Floor
  DEFB $16,$4A,$29,$25,$49,$92,$A4,$25,$94 ; Wall
  DEFB $0E,$A5,$5A,$A5,$5A,$A5,$5A,$A5,$5A ; Nasty (unused)
  DEFB $07,$03,$00,$0C,$00,$30,$00,$C0,$00 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5F64              ; Location in the attribute buffer at 24064: (11,4)
  DEFB $08                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $05,$38,$45,$82,$82,$82,$44,$38 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $1F                ; Room to the left (Swimming Pool)
  DEFB $1D                ; Room to the right (The Nightmare Room)
  DEFB $24                ; Room above (A bit of tree)
  DEFB $18                ; Room below (West of Kitchen)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $64,$8A            ; Guardian no. 0x64 (vertical), base sprite 4, x=10
                          ; (ENTITY100)
  DEFB $65,$8D            ; Guardian no. 0x65 (vertical), base sprite 4, x=13
                          ; (ENTITY101)
  DEFB $66,$10            ; Guardian no. 0x66 (vertical), base sprite 0, x=16
                          ; (ENTITY102)
  DEFB $58,$16            ; Guardian no. 0x58 (horizontal), base sprite 0,
                          ; initial x=22 (ENTITY88)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x1F: Swimming Pool (teleport: 123459)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$55,$55,$55,$55,$55,$54,$AA
  DEFB $AA,$55,$55,$55,$55,$55,$52,$AA
  DEFB $AA,$55,$55,$55,$55,$55,$4A,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "          Swimming Pool         " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $05,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $29,$00,$00,$00,$00,$00,$00,$00,$00 ; Floor
  DEFB $3A,$44,$44,$BB,$44,$44,$44,$BB,$44 ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $2F,$03,$03,$0F,$0F,$3F,$3F,$FF,$FF ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FD9              ; Location in the attribute buffer at 24064: (14,25)
  DEFB $03                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $70,$20,$20,$50,$50,$88,$88,$88 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $36                ; Room to the left (West  Wing)
  DEFB $1E                ; Room to the right (The Banyan Tree)
  DEFB $25                ; Room above (Orangery)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $4E,$0C            ; Guardian no. 0x4E (horizontal), base sprite 0,
                          ; initial x=12 (ENTITY78)
  DEFB $01,$10            ; Rope at x=16 (ENTITY1)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x20: Halfway up the East Wall (teleport: 69)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00 ; Room layout
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$08,$00,$00,$00,$00,$00,$00
  DEFB $80,$0A,$00,$00,$00,$00,$00,$00
  DEFB $80,$1A,$80,$00,$00,$00,$00,$00
  DEFB $A0,$00,$20,$00,$00,$00,$00,$00
  DEFB $A0,$00,$28,$00,$00,$00,$00,$00
  DEFB $A0,$4A,$AA,$00,$00,$00,$00,$00
  DEFB $A0,$0A,$AA,$00,$00,$00,$00,$00
  DEFB $A0,$10,$0A,$00,$00,$00,$00,$00
  DEFB $A4,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$04,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$1A,$00,$00,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "Halfway up the East Wall        " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $05,$FF,$FF,$5A,$99,$BD,$5A,$3C,$5A ; Floor
  DEFB $0F,$33,$11,$44,$CC,$33,$11,$44,$CC ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $07,$80,$C0,$E0,$70,$B8,$1C,$4E,$C7 ; Ramp
  DEFB $07,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5EEB              ; Location in the attribute buffer at 24064: (7,11)
  DEFB $06                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $21                ; Room to the left (The Bathroom)
  DEFB $00                ; Room to the right (The Off Licence)
  DEFB $26                ; Room above (Priests' Hole)
  DEFB $1A                ; Room below (East Wall Base)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $26,$04            ; Guardian no. 0x26 (horizontal), base sprite 0,
                          ; initial x=4 (ENTITY38)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x21: The Bathroom (teleport: 169)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A ; Room layout
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $55,$55,$55,$50,$25,$55,$55,$5A
  DEFB $80,$00,$00,$00,$20,$00,$00,$0A
  DEFB $80,$00,$00,$00,$20,$00,$00,$0A
  DEFB $80,$00,$00,$00,$20,$00,$00,$0A
  DEFB $80,$00,$00,$00,$20,$00,$00,$0A
  DEFB $80,$00,$00,$00,$20,$00,$00,$0A
  DEFB $80,$00,$00,$00,$20,$00,$00,$0A
  DEFB $80,$00,$00,$00,$20,$00,$00,$0A
  DEFB $00,$05,$40,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $55,$55,$55,$55,$55,$55,$55,$5A
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "          The Bathroom          " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $16,$00,$40,$09,$64,$92,$2D,$96,$FF ; Floor
  DEFB $0E,$1F,$AA,$00,$55,$F8,$55,$00,$AA ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $07,$03,$00,$0C,$00,$30,$00,$C0,$00 ; Ramp
  DEFB $3D,$A5,$00,$00,$00,$00,$00,$00,$FF ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5FD4              ; Location in the attribute buffer at 24064: (14,20)
  DEFB $04                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5F89              ; Location in the attribute buffer at 24064: (12,9)
  DEFB $08                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $1F,$04,$0A,$77,$87,$B1,$AA,$0A ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $22                ; Room to the left (Top Landing)
  DEFB $20                ; Room to the right (Halfway up the East Wall)
  DEFB $27                ; Room above (Emergency Generator)
  DEFB $1B                ; Room below (The Chapel)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $3B,$10            ; Guardian no. 0x3B (horizontal), base sprite 0,
                          ; initial x=16 (ENTITY59)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x22: Top Landing (teleport: 269)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; Room layout
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
  DEFB $A5,$50,$55,$05,$55,$55,$00,$00
  DEFB $A0,$00,$00,$00,$00,$00,$AA,$AA
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A5,$50,$55,$05,$55,$00,$00,$0A
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A0,$00,$00,$00,$00,$00,$00,$0A
  DEFB $A5,$50,$55,$05,$40,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $55,$55,$55,$55,$55,$05,$55,$55
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "          Top Landing           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $06,$FF,$AA,$55,$FF,$00,$00,$00,$00 ; Floor
  DEFB $1A,$69,$90,$90,$69,$96,$69,$69,$96 ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $07,$07,$02,$3C,$08,$70,$20,$C0,$80 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5F71              ; Location in the attribute buffer at 24064: (11,17)
  DEFB $07                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $18,$24,$A4,$CA,$95,$0A,$15,$0A ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $23                ; Room to the left (Master Bedroom)
  DEFB $21                ; Room to the right (The Bathroom)
  DEFB $28                ; Room above (Dr Jones will never believe this)
  DEFB $1C                ; Room below (First Landing)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $3A,$86            ; Guardian no. 0x3A (vertical), base sprite 4, x=6
                          ; (ENTITY58)
  DEFB $13,$6C            ; Guardian no. 0x13 (vertical), base sprite 3, x=12
                          ; (ENTITY19)
  DEFB $24,$10            ; Guardian no. 0x24 (horizontal), base sprite 0,
                          ; initial x=16 (ENTITY36)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x23: Master Bedroom (teleport: 1269)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; Room layout
  DEFB $A0,$00,$00,$0A,$00,$00,$00,$00
  DEFB $A0,$00,$00,$0A,$00,$00,$00,$00
  DEFB $A0,$00,$00,$0A,$00,$00,$00,$00
  DEFB $A0,$00,$00,$0A,$00,$00,$00,$00
  DEFB $A0,$00,$00,$0A,$00,$00,$00,$00
  DEFB $A0,$00,$00,$0A,$00,$00,$00,$00
  DEFB $A0,$00,$00,$0A,$00,$00,$00,$00
  DEFB $A0,$00,$00,$0A,$00,$00,$00,$00
  DEFB $A0,$00,$00,$0A,$00,$00,$00,$00
  DEFB $A0,$00,$00,$0A,$00,$00,$00,$00
  DEFB $AC,$00,$00,$00,$00,$00,$00,$00
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
  DEFB $95,$55,$55,$55,$40,$00,$00,$00
  DEFB $AA,$AA,$AA,$AA,$A0,$00,$00,$00
  DEFB $AA,$AA,$AA,$AA,$A9,$55,$55,$55
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         Master Bedroom         " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $06,$FF,$6B,$B5,$00,$AD,$00,$4A,$00 ; Floor
  DEFB $33,$00,$51,$FB,$51,$00,$AA,$BF,$AA ; Wall
  DEFB $47,$00,$00,$00,$00,$7C,$FE,$7F,$3E ; Nasty
  DEFB $07,$C0,$40,$B0,$00,$AC,$00,$53,$00 ; Ramp
  DEFB $29,$55,$55,$55,$55,$51,$5F,$40,$AA ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5F82              ; Location in the attribute buffer at 24064: (12,2)
  DEFB $04                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5FD2              ; Location in the attribute buffer at 24064: (14,18)
  DEFB $02                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $24                ; Room to the left (A bit of tree)
  DEFB $22                ; Room to the right (Top Landing)
  DEFB $29                ; Room above (The Attic)
  DEFB $1D                ; Room below (The Nightmare Room)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x24: A bit of tree (teleport: 369)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$A0,$00,$00,$00,$03 ; Room layout
  DEFB $00,$00,$00,$A0,$00,$00,$00,$03
  DEFB $00,$00,$00,$A0,$00,$00,$00,$03
  DEFB $00,$00,$00,$A0,$00,$00,$00,$03
  DEFB $00,$00,$10,$A0,$00,$40,$00,$03
  DEFB $00,$00,$00,$A0,$00,$00,$00,$03
  DEFB $00,$14,$00,$A0,$00,$01,$40,$03
  DEFB $00,$00,$10,$A0,$00,$00,$00,$03
  DEFB $00,$00,$00,$A0,$00,$00,$00,$03
  DEFB $00,$00,$14,$A0,$00,$00,$40,$03
  DEFB $55,$50,$00,$A5,$40,$00,$00,$03
  DEFB $00,$00,$00,$A0,$00,$00,$01,$03
  DEFB $00,$00,$00,$A0,$00,$00,$40,$03
  DEFB $00,$00,$00,$A0,$05,$00,$00,$03
  DEFB $00,$00,$00,$A0,$00,$00,$00,$03
  DEFB $00,$00,$01,$A4,$00,$00,$00,$03
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "    A bit of tree               " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$AD,$52,$29,$00,$01,$02,$00,$00 ; Floor
  DEFB $1E,$D6,$6B,$66,$DB,$69,$6B,$D9,$6D ; Wall
  DEFB $02,$15,$00,$AA,$55,$AA,$00,$15,$0A ; Nasty
  DEFB $44,$03,$08,$24,$10,$40,$20,$80,$80 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5F34              ; Location in the attribute buffer at 24064: (9,20)
  DEFB $02                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $05                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $25                ; Room to the left (Orangery)
  DEFB $23                ; Room to the right (Master Bedroom)
  DEFB $2A                ; Room above (Under the Roof)
  DEFB $1E                ; Room below (The Banyan Tree)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $68,$02            ; Guardian no. 0x68 (horizontal), base sprite 0,
                          ; initial x=2 (ENTITY104)
  DEFB $65,$07            ; Guardian no. 0x65 (vertical), base sprite 0, x=7
                          ; (ENTITY101)
  DEFB $45,$92            ; Arrow flying right to left at pixel y-coordinate 73
                          ; (ENTITY69)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x25: Orangery (teleport: 1369)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$01,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$40,$00,$10,$00
  DEFB $00,$00,$00,$00,$00,$04,$00,$40
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $A0,$00,$00,$04,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$01,$00,$00,$00
  DEFB $00,$20,$00,$40,$00,$00,$05,$00
  DEFB $00,$25,$00,$00,$40,$00,$00,$55
  DEFB $00,$20,$00,$00,$00,$00,$10,$00
  DEFB $00,$20,$01,$00,$00,$00,$00,$00
  DEFB $00,$20,$00,$00,$00,$40,$00,$00
  DEFB $AA,$AA,$00,$01,$40,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "            Orangery            " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$A5,$4A,$24,$02,$04,$00,$02,$00 ; Floor
  DEFB $16,$15,$55,$55,$24,$25,$55,$49,$22 ; Wall
  DEFB $06,$82,$41,$3E,$6A,$B7,$19,$25,$44 ; Nasty (unused)
  DEFB $05,$01,$02,$04,$00,$10,$20,$40,$80 ; Ramp
  DEFB $26,$C6,$AA,$A8,$2A,$59,$24,$00,$00 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5F5C              ; Location in the attribute buffer at 24064: (10,28)
  DEFB $04                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FA0              ; Location in the attribute buffer at 24064: (13,0)
  DEFB $0E                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $06                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $02,$14,$2E,$55,$2A,$45,$2A,$14 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $38                ; Room to the left (West Wing Roof)
  DEFB $24                ; Room to the right (A bit of tree)
  DEFB $2B                ; Room above (Conservatory Roof)
  DEFB $1F                ; Room below (Swimming Pool)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $61,$94            ; Guardian no. 0x61 (vertical), base sprite 4, x=20
                          ; (ENTITY97)
  DEFB $1B,$89            ; Guardian no. 0x1B (vertical), base sprite 4, x=9
                          ; (ENTITY27)
  DEFB $3C,$84            ; Arrow flying left to right at pixel y-coordinate 66
                          ; (ENTITY60)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x26: Priests' Hole (teleport: 2369)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00 ; Room layout
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $00,$00,$0A,$00,$00,$00,$00,$00
  DEFB $00,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A5,$00,$5A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A1,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$4A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A1,$00,$00,$00,$00,$00,$00,$00
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
  DEFB $A0,$00,$5A,$00,$00,$00,$00,$00
  DEFB $A0,$00,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$40,$0A,$00,$00,$00,$00,$00
  DEFB $A0,$01,$0A,$00,$00,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         Priests' Hole          " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $06,$55,$55,$5D,$D7,$70,$00,$00,$00 ; Floor
  DEFB $2A,$22,$11,$44,$88,$22,$11,$44,$88 ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Ramp (unused)
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $BF,$BF,$BB,$B1,$BB,$BB,$BF,$BF ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $27                ; Room to the left (Emergency Generator)
  DEFB $00                ; Room to the right (The Off Licence)
  DEFB $3C                ; Room above (The Bow)
  DEFB $20                ; Room below (Halfway up the East Wall)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $10,$84            ; Guardian no. 0x10 (vertical), base sprite 4, x=4
                          ; (ENTITY16)
  DEFB $11,$A6            ; Guardian no. 0x11 (vertical), base sprite 5, x=6
                          ; (ENTITY17)
  DEFB $12,$C5            ; Guardian no. 0x12 (vertical), base sprite 6, x=5
                          ; (ENTITY18)
  DEFB $25,$16            ; Guardian no. 0x25 (horizontal), base sprite 0,
                          ; initial x=22 (ENTITY37)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x27: Emergency Generator (teleport: 12369)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$05,$00,$00,$00,$00,$50,$0A
  DEFB $00,$05,$00,$00,$00,$00,$50,$03
  DEFB $00,$05,$00,$00,$00,$00,$50,$03
  DEFB $00,$05,$00,$00,$00,$00,$50,$03
  DEFB $00,$05,$00,$00,$00,$00,$50,$03
  DEFB $00,$2A,$80,$00,$00,$02,$A8,$03
  DEFB $00,$28,$80,$00,$00,$02,$28,$03
  DEFB $00,$AA,$AA,$AA,$AA,$AA,$AA,$03
  DEFB $00,$AA,$2A,$8A,$A2,$A8,$AA,$03
  DEFB $00,$AA,$AA,$AA,$AA,$AA,$AA,$03
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "       Emergency Generator      " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $08,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $2F,$66,$66,$66,$66,$66,$66,$66,$66 ; Floor
  DEFB $33,$BF,$15,$00,$51,$FB,$51,$00,$15 ; Wall
  DEFB $0D,$FF,$3F,$03,$1F,$7F,$1F,$03,$3F ; Nasty
  DEFB $0F,$03,$00,$0C,$00,$30,$00,$C0,$00 ; Ramp
  DEFB $16,$AA,$54,$AA,$54,$28,$10,$28,$10 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5F69              ; Location in the attribute buffer at 24064: (11,9)
  DEFB $0E                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5F52              ; Location in the attribute buffer at 24064: (10,18)
  DEFB $06                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $28                ; Room to the left (Dr Jones will never believe this)
  DEFB $26                ; Room to the right (Priests' Hole)
  DEFB $0E                ; Room above (Rescue Esmerelda)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $1A,$08            ; Guardian no. 0x1A (horizontal), base sprite 0,
                          ; initial x=8 (ENTITY26)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x28: Dr Jones will never believe this (teleport: 469)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$EA,$00,$00,$00,$00
  DEFB $00,$00,$00,$AA,$A0,$00,$00,$00
  DEFB $00,$00,$00,$95,$54,$00,$00,$00
  DEFB $00,$0E,$A8,$D5,$15,$00,$00,$00
  DEFB $00,$0A,$AA,$81,$AA,$00,$00,$00
  DEFB $00,$05,$50,$90,$A8,$20,$00,$00
  DEFB $50,$05,$50,$81,$A0,$00,$00,$00
  DEFB $00,$0A,$50,$90,$A0,$00,$00,$00
  DEFB $04,$0A,$50,$81,$80,$40,$00,$00
  DEFB $00,$12,$50,$90,$80,$00,$00,$00
  DEFB $00,$42,$50,$01,$80,$10,$00,$10
  DEFB $00,$02,$00,$01,$80,$00,$40,$00
  DEFB $00,$02,$94,$01,$90,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "Dr Jones will never believe this" ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $02,$FE,$55,$2A,$AA,$55,$AA,$AA,$FF ; Floor
  DEFB $1F,$11,$44,$22,$88,$11,$44,$22,$88 ; Wall
  DEFB $43,$01,$04,$22,$08,$11,$44,$22,$88 ; Nasty
  DEFB $05,$40,$90,$24,$48,$12,$24,$09,$02 ; Ramp
  DEFB $26,$A5,$00,$A5,$00,$AA,$FF,$FF,$55 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5FE0              ; Location in the attribute buffer at 24064: (15,0)
  DEFB $20                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5F58              ; Location in the attribute buffer at 24064: (10,24)
  DEFB $05                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $F0,$F0,$78,$B8,$4C,$32,$0D,$03 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $29                ; Room to the left (The Attic)
  DEFB $27                ; Room to the right (Emergency Generator)
  DEFB $10                ; Room above (We must perform a Quirkafleeg)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $1B,$92            ; Guardian no. 0x1B (vertical), base sprite 4, x=18
                          ; (ENTITY27)
  DEFB $0B,$0A            ; Guardian no. 0x0B (vertical), base sprite 0, x=10
                          ; (ENTITY11)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x29: The Attic (teleport: 1469)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$C0,$03,$00,$00,$00,$00,$00
  DEFB $55,$95,$56,$50,$00,$00,$00,$00
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
  DEFB $A4,$00,$00,$00,$05,$00,$00,$05
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
  DEFB $A4,$00,$00,$00,$00,$50,$00,$00
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
  DEFB $A4,$00,$00,$00,$00,$04,$00,$00
  DEFB $A0,$00,$00,$00,$00,$00,$00,$00
  DEFB $A4,$03,$00,$C0,$C0,$00,$00,$00
  DEFB $55,$65,$95,$96,$55,$95,$56,$59
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "          The Attic             " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $16,$CE,$FF,$00,$E7,$00,$7F,$00,$FB ; Floor
  DEFB $1E,$EE,$11,$6C,$92,$11,$C9,$22,$9C ; Wall
  DEFB $44,$24,$12,$44,$AA,$55,$AA,$5B,$FF ; Nasty
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Ramp (unused)
  DEFB $42,$F0,$AA,$3C,$AA,$55,$AA,$55,$AA ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5F18              ; Location in the attribute buffer at 24064: (8,24)
  DEFB $04                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $11,$22,$33,$44,$55,$66,$77,$88 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $2A                ; Room to the left (Under the Roof)
  DEFB $28                ; Room to the right (Dr Jones will never believe
                          ; this)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $22                ; Room below (Top Landing)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $52,$04            ; Guardian no. 0x52 (vertical), base sprite 0, x=4
                          ; (ENTITY82)
  DEFB $53,$06            ; Guardian no. 0x53 (vertical), base sprite 0, x=6
                          ; (ENTITY83)
  DEFB $54,$08            ; Guardian no. 0x54 (vertical), base sprite 0, x=8
                          ; (ENTITY84)
  DEFB $55,$0A            ; Guardian no. 0x55 (vertical), base sprite 0, x=10
                          ; (ENTITY85)
  DEFB $56,$0C            ; Guardian no. 0x56 (vertical), base sprite 0, x=12
                          ; (ENTITY86)
  DEFB $57,$4E            ; Guardian no. 0x57 (vertical), base sprite 2, x=14
                          ; (ENTITY87)
  DEFB $45,$52            ; Arrow flying right to left at pixel y-coordinate 41
                          ; (ENTITY69)
  DEFB $3C,$92            ; Arrow flying left to right at pixel y-coordinate 73
                          ; (ENTITY60)

; Room 0x2A: Under the Roof (teleport: 2469)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$FF,$FF,$FF,$FF,$F0 ; Room layout
  DEFB $00,$00,$00,$00,$C3,$FC,$30,$00
  DEFB $00,$00,$00,$03,$F3,$FC,$FC,$00
  DEFB $00,$00,$00,$00,$00,$F0,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$55,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$A0,$00,$01,$40,$00
  DEFB $00,$00,$50,$A0,$01,$00,$00,$00
  DEFB $55,$50,$00,$A0,$40,$00,$00,$00
  DEFB $54,$00,$01,$A0,$00,$00,$00,$00
  DEFB $00,$00,$00,$A0,$00,$40,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         Under the Roof         " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $08,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $0C,$B5,$AA,$55,$4A,$25,$42,$01,$02 ; Floor
  DEFB $1E,$66,$B6,$6D,$BB,$66,$B9,$6D,$B6 ; Wall
  DEFB $F5,$66,$AA,$5F,$BC,$63,$AC,$6B,$A4 ; Nasty
  DEFB $0F,$01,$02,$04,$28,$10,$28,$40,$80 ; Ramp
  DEFB $0E,$A5,$AA,$BD,$66,$66,$66,$66,$66 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5ECC              ; Location in the attribute buffer at 24064: (6,12)
  DEFB $14                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5EC4              ; Location in the attribute buffer at 24064: (6,4)
  DEFB $07                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $2B                ; Room to the left (Conservatory Roof)
  DEFB $29                ; Room to the right (The Attic)
  DEFB $30                ; Room above (Nomen Luni)
  DEFB $24                ; Room below (A bit of tree)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $37,$04            ; Guardian no. 0x37 (horizontal), base sprite 0,
                          ; initial x=4 (ENTITY55)
  DEFB $27,$10            ; Guardian no. 0x27 (horizontal), base sprite 0,
                          ; initial x=16 (ENTITY39)
  DEFB $3C,$C2            ; Arrow flying left to right at pixel y-coordinate 97
                          ; (ENTITY60)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x2B: Conservatory Roof (teleport: 12469)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$2A,$AA,$AA
  DEFB $00,$00,$00,$00,$00,$30,$C3,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$50,$00
  DEFB $00,$00,$00,$00,$00,$00,$05,$55
  DEFB $00,$00,$00,$00,$00,$04,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "        Conservatory Roof       " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$AC,$53,$2A,$D0,$8A,$24,$22,$04 ; Floor
  DEFB $05,$F7,$EF,$00,$00,$00,$66,$66,$00 ; Wall
  DEFB $43,$DA,$D5,$7F,$2E,$11,$1F,$0A,$1B ; Nasty
  DEFB $07,$01,$02,$04,$10,$08,$20,$40,$80 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5FBA              ; Location in the attribute buffer at 24064: (13,26)
  DEFB $06                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FEC              ; Location in the attribute buffer at 24064: (15,12)
  DEFB $09                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $05                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $18,$18,$F8,$3C,$7E,$60,$60,$7E ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $00                ; Room to the left (The Off Licence)
  DEFB $2A                ; Room to the right (Under the Roof)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $25                ; Room below (Orangery)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $6A,$14            ; Guardian no. 0x6A (horizontal), base sprite 0,
                          ; initial x=20 (ENTITY106)
  DEFB $3D,$18            ; Guardian no. 0x3D (horizontal), base sprite 0,
                          ; initial x=24 (ENTITY61)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x2C: On top of the house (teleport: 3469)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $92,$00,$00,$00,$04,$00,$00,$00
  DEFB $90,$00,$00,$00,$10,$00,$00,$00
  DEFB $90,$00,$00,$00,$40,$00,$00,$00
  DEFB $92,$00,$00,$01,$00,$00,$00,$00
  DEFB $92,$80,$00,$04,$00,$00,$00,$00
  DEFB $92,$A0,$82,$10,$00,$00,$00,$00
  DEFB $92,$AA,$AA,$40,$00,$00,$00,$00
  DEFB $92,$AA,$AA,$00,$00,$00,$00,$00
  DEFB $10,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$AA,$00,$00,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         On top of the house    " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $08,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $0E,$A0,$40,$80,$00,$00,$00,$00,$00 ; Floor
  DEFB $4B,$51,$AA,$00,$AA,$15,$AA,$00,$AA ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $0F,$01,$03,$06,$0D,$1A,$34,$68,$D0 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5F4C              ; Location in the attribute buffer at 24064: (10,12)
  DEFB $06                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $03                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$18,$14,$1A,$35,$6B,$D0 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $0E                ; Room to the left (Rescue Esmerelda)
  DEFB $00                ; Room to the right (The Off Licence)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $26                ; Room below (Priests' Hole)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $1D,$14            ; Guardian no. 0x1D (vertical), base sprite 0, x=20
                          ; (ENTITY29)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x2D: Under the Drive (teleport: 13469)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $A0,$00,$00,$00,$00,$00,$AA,$AA ; Room layout
  DEFB $A0,$00,$00,$00,$00,$00,$AA,$AA
  DEFB $A0,$00,$00,$00,$00,$00,$AA,$AA
  DEFB $A0,$00,$00,$00,$00,$05,$AA,$AA
  DEFB $A8,$00,$00,$00,$00,$00,$AA,$AA
  DEFB $AA,$00,$00,$00,$10,$00,$02,$AA
  DEFB $AA,$80,$00,$00,$00,$50,$00,$AA
  DEFB $AA,$A0,$00,$00,$00,$00,$00,$0A
  DEFB $AA,$A8,$00,$00,$50,$00,$00,$00
  DEFB $AA,$AA,$00,$00,$00,$C0,$00,$00
  DEFB $AA,$AA,$80,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$A0,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$A8,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$AA,$00,$00,$00,$00,$00
  DEFB $AA,$AA,$AA,$80,$30,$0C,$0C,$00
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "          Under the Drive       " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $06,$FF,$FF,$A5,$58,$24,$42,$20,$00 ; Floor
  DEFB $0C,$10,$2A,$55,$A0,$10,$20,$10,$08 ; Wall
  DEFB $04,$18,$18,$14,$22,$22,$55,$11,$28 ; Nasty
  DEFB $07,$80,$40,$A0,$50,$A8,$54,$AA,$55 ; Ramp
  DEFB $02,$E0,$AA,$F8,$00,$FF,$FF,$66,$66 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5F52              ; Location in the attribute buffer at 24064: (10,18)
  DEFB $0E                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5FCD              ; Location in the attribute buffer at 24064: (14,13)
  DEFB $0C                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $04                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $81,$64,$CD,$0F,$61,$DA,$33,$1A ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $06                ; Room to the left (Entrance to Hades)
  DEFB $2E                ; Room to the right (Tree Root)
  DEFB $04                ; Room above (The Drive)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $1C,$10            ; Guardian no. 0x1C (horizontal), base sprite 0,
                          ; initial x=16 (ENTITY28)
  DEFB $1D,$92            ; Guardian no. 0x1D (vertical), base sprite 4, x=18
                          ; (ENTITY29)
  DEFB $44,$96            ; Guardian no. 0x44 (horizontal), base sprite 4,
                          ; initial x=22 (ENTITY68)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x2E: Tree Root (teleport: 23469)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $AA,$0A,$AA,$AA,$AA,$AA,$AA,$AA ; Room layout
  DEFB $AA,$0A,$AA,$AA,$AA,$AA,$AA,$AA
  DEFB $AA,$0A,$AA,$AA,$AA,$AA,$AA,$AA
  DEFB $AA,$0A,$A0,$AA,$AA,$AA,$AA,$AA
  DEFB $AA,$0A,$A0,$AA,$00,$A0,$00,$0A
  DEFB $AA,$0A,$A0,$AA,$00,$A0,$00,$0A
  DEFB $AA,$0A,$A0,$00,$00,$A0,$00,$0A
  DEFB $AA,$0A,$A0,$00,$00,$A0,$00,$0A
  DEFB $00,$00,$05,$00,$00,$A0,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$00,$00,$00,$00,$00,$00,$2A
  DEFB $00,$00,$00,$01,$55,$55,$40,$AA
  DEFB $00,$00,$00,$00,$00,$00,$02,$AA
  DEFB $00,$00,$00,$00,$00,$00,$0A,$AA
  DEFB $00,$0C,$03,$03,$00,$30,$2A,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "           Tree Root            " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $06,$FF,$FF,$00,$00,$00,$00,$00,$00 ; Floor
  DEFB $0A,$66,$99,$24,$24,$77,$88,$8D,$72 ; Wall
  DEFB $02,$1C,$2A,$5F,$7D,$BE,$FE,$D2,$7C ; Nasty
  DEFB $43,$03,$02,$0D,$02,$31,$08,$D5,$22 ; Ramp
  DEFB $04,$EE,$AA,$38,$FF,$FF,$10,$10,$38 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5F40              ; Location in the attribute buffer at 24064: (10,0)
  DEFB $0D                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FD8              ; Location in the attribute buffer at 24064: (14,24)
  DEFB $06                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $02,$1D,$22,$5E,$BE,$7C,$38,$10 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $2D                ; Room to the left (Under the Drive)
  DEFB $2F                ; Room to the right ([)
  DEFB $03                ; Room above (At the Foot of the MegaTree)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $1E,$84            ; Guardian no. 0x1E (vertical), base sprite 4, x=4
                          ; (ENTITY30)
  DEFB $28,$0D            ; Guardian no. 0x28 (vertical), base sprite 0, x=13
                          ; (ENTITY40)
  DEFB $23,$13            ; Guardian no. 0x23 (horizontal), base sprite 0,
                          ; initial x=19 (ENTITY35)
  DEFB $1F,$59            ; Guardian no. 0x1F (vertical), base sprite 2, x=25
                          ; (ENTITY31)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x2F: [ (teleport: 123469)
;
; This room is not used.
;
; The first 128 bytes define the room layout. Each bit-pair (bits 7 and 6, 5
; and 4, 3 and 2, or 1 and 0 of each byte) determines the type of tile
; (background, floor, wall or nasty) that will be drawn at the corresponding
; location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout (completely empty)
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
; The next 32 bytes specify the room name.
  DEFM "         [                      " ; Room name
; In a working room definition, the next 80 bytes define the tiles, conveyor,
; ramp, border colour, item graphic, and exits. In this room, however, there
; are code remnants and unused data.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background tile
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  INC B
  LD (HL),$00
  JP NZ,$62E3
  INC (IX+$06)
  DEFB $10,$FF
  LD (IX+$0A),C
  LD (HL),B
  JP $5E56
  LD BC,$6007
  LD A,($408E)
  JR NZ,$EFE3
  PUSH HL
  PUSH BC
  PUSH AF
  LD DE,$5EE8
  PUSH DE
  PUSH BC
  RET
  POP AF
  POP BC
  DEC A
  DEFB $F2,$E0
  DEFB $00                ; Conveyor length (deliberately set to 0)
  POP HL
  RET
  POP BC
  DEFB $00                ; Ramp length (deliberately set to 0)
  LD A,(HL)
  CP $2C
  RET NZ
  RST $10
  PUSH BC
  LD A,(HL)
  CP $23
  CALL Z,$1D78
  CALL $2B1C
  EX (SP),HL
  PUSH HL
  DEFB $11
; The next eight pairs of bytes specify the entities (ropes, arrows, guardians)
; in this room.
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x30: Nomen Luni (teleport: 569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$0A,$AA,$00,$00
  DEFB $00,$00,$00,$01,$0A,$AA,$00,$50
  DEFB $00,$00,$00,$00,$00,$A0,$00,$00
  DEFB $00,$00,$01,$50,$00,$A0,$40,$00
  DEFB $00,$00,$00,$00,$04,$A0,$00,$0A
  DEFB $00,$00,$00,$00,$00,$A0,$00,$2A
  DEFB $00,$00,$00,$00,$40,$A0,$0A,$A2
  DEFB $00,$00,$00,$00,$01,$A0,$21,$42
  DEFB $00,$00,$00,$00,$00,$A0,$00,$0A
  DEFB $00,$00,$00,$AA,$AA,$AA,$AA,$A2
  DEFB $00,$00,$00,$AA,$AA,$AA,$AA,$A2
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "           Nomen Luni           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $0D,$FF,$22,$44,$88,$55,$22,$00,$00 ; Floor
  DEFB $F3,$AA,$70,$AA,$6C,$B1,$5F,$AA,$55 ; Wall
  DEFB $06,$55,$A2,$55,$98,$1C,$2A,$45,$8A ; Nasty (unused)
  DEFB $07,$03,$00,$0C,$00,$34,$0A,$C4,$00 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FE9              ; Location in the attribute buffer at 24064: (15,9)
  DEFB $05                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $12,$12,$12,$12,$12,$12,$12,$12 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $00                ; Room to the left (The Off Licence)
  DEFB $12                ; Room to the right (On the Roof)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $2A                ; Room below (Under the Roof)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $68,$05            ; Guardian no. 0x68 (horizontal), base sprite 0,
                          ; initial x=5 (ENTITY104)
  DEFB $6B,$14            ; Guardian no. 0x6B (horizontal), base sprite 0,
                          ; initial x=20 (ENTITY107)
  DEFB $1D,$90            ; Guardian no. 0x1D (vertical), base sprite 4, x=16
                          ; (ENTITY29)
  DEFB $0B,$16            ; Guardian no. 0x0B (vertical), base sprite 0, x=22
                          ; (ENTITY11)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x31: The Wine Cellar (teleport: 1569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$0C,$02,$AA ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$02,$AA
  DEFB $55,$40,$00,$00,$00,$00,$02,$AA
  DEFB $00,$00,$00,$00,$00,$00,$00,$2A
  DEFB $00,$00,$00,$00,$00,$00,$00,$2A
  DEFB $AA,$A8,$00,$41,$00,$15,$56,$AA
  DEFB $AA,$00,$00,$00,$00,$00,$00,$2A
  DEFB $AA,$00,$00,$00,$00,$00,$00,$2A
  DEFB $AA,$A8,$00,$41,$00,$55,$56,$AA
  DEFB $A0,$00,$00,$00,$00,$00,$00,$2A
  DEFB $A0,$00,$00,$00,$00,$00,$00,$2A
  DEFB $AA,$A8,$00,$41,$01,$55,$55,$55
  DEFB $AA,$00,$00,$C3,$03,$00,$00,$00
  DEFB $AA,$00,$00,$00,$00,$00,$0A,$AA
  DEFB $AA,$A8,$00,$00,$00,$00,$2A,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "        The Wine Cellar         " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room. Note that because of a bug
; in the game engine, the conveyor tile is not drawn correctly (see the room
; image above).
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $42,$FF,$18,$E7,$10,$C7,$38,$00,$00 ; Floor
  DEFB $29,$0A,$41,$28,$05,$A0,$14,$82,$50 ; Wall
  DEFB $46,$24,$24,$24,$5A,$DB,$BD,$C3,$7E ; Nasty
  DEFB $07,$03,$03,$0D,$0E,$35,$3A,$D5,$EA ; Ramp
  DEFB $0D,$AA,$55,$AA,$55,$AA,$55,$AA,$55 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5F9B              ; Location in the attribute buffer at 24064: (12,27)
  DEFB $05                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FD8              ; Location in the attribute buffer at 24064: (14,24)
  DEFB $03                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $04                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$19,$F9,$1F,$00,$19,$FF,$1F ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $33                ; Room to the left (Tool  Shed)
  DEFB $13                ; Room to the right (The Forgotten Abbey)
  DEFB $34                ; Room above (Back Stairway)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $34,$10            ; Guardian no. 0x34 (horizontal), base sprite 0,
                          ; initial x=16 (ENTITY52)
  DEFB $40,$19            ; Guardian no. 0x40 (horizontal), base sprite 0,
                          ; initial x=25 (ENTITY64)
  DEFB $41,$09            ; Guardian no. 0x41 (horizontal), base sprite 0,
                          ; initial x=9 (ENTITY65)
  DEFB $42,$13            ; Guardian no. 0x42 (horizontal), base sprite 0,
                          ; initial x=19 (ENTITY66)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x32: Watch Tower (teleport: 2569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$08,$00,$00,$00,$00,$20,$00
  DEFB $00,$08,$0C,$00,$00,$C0,$E0,$00
  DEFB $00,$0A,$AA,$A0,$1A,$AA,$A0,$00
  DEFB $00,$00,$00,$A0,$0A,$00,$00,$00
  DEFB $00,$00,$00,$A5,$0A,$00,$00,$00
  DEFB $00,$00,$00,$A0,$0A,$00,$00,$00
  DEFB $00,$00,$00,$A0,$5A,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "          Watch Tower           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $08,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $06,$FF,$FF,$AA,$55,$AA,$55,$00,$00 ; Floor
  DEFB $1D,$AA,$55,$55,$AA,$55,$AA,$AA,$55 ; Wall
  DEFB $0C,$46,$89,$89,$36,$48,$83,$84,$68 ; Nasty
  DEFB $0F,$01,$02,$04,$08,$10,$20,$40,$80 ; Ramp
  DEFB $0D,$F6,$FF,$E7,$00,$00,$00,$00,$00 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5E8C              ; Location in the attribute buffer at 24064: (4,12)
  DEFB $08                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5F07              ; Location in the attribute buffer at 24064: (8,7)
  DEFB $05                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $05                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $74,$38,$66,$BF,$BF,$9D,$42,$3C ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $00                ; Room to the left (The Off Licence)
  DEFB $00                ; Room to the right (The Off Licence)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $10                ; Room below (We must perform a Quirkafleeg)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $6C,$91            ; Guardian no. 0x6C (horizontal), base sprite 4,
                          ; initial x=17 (ENTITY108)
  DEFB $6D,$0B            ; Guardian no. 0x6D (horizontal), base sprite 0,
                          ; initial x=11 (ENTITY109)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x33: Tool  Shed (teleport: 12569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$02,$AA,$A0,$00,$00,$00 ; Room layout
  DEFB $00,$00,$0A,$AA,$A0,$00,$00,$00
  DEFB $00,$00,$2A,$AA,$AA,$AA,$AA,$AA
  DEFB $00,$00,$00,$00,$C0,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$AA
  DEFB $00,$00,$00,$00,$00,$00,$00,$AA
  DEFB $00,$00,$00,$00,$00,$00,$00,$AA
  DEFB $AA,$A8,$00,$41,$00,$40,$2A,$AA
  DEFB $AA,$A8,$00,$00,$00,$00,$2A,$AA
  DEFB $AA,$A8,$00,$00,$00,$00,$6A,$AA
  DEFB $AA,$A8,$11,$00,$10,$00,$2A,$AA
  DEFB $AA,$A8,$00,$00,$00,$40,$2A,$AA
  DEFB $AA,$A8,$00,$00,$00,$00,$6A,$AA
  DEFB $AA,$A8,$00,$00,$00,$00,$2A,$AA
  DEFB $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "           Tool  Shed           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room. Note that because of a bug
; in the game engine, the conveyor tile is not drawn correctly (see the room
; image above).
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $05,$5A,$FF,$22,$44,$22,$40,$00,$00 ; Floor
  DEFB $1E,$55,$AA,$44,$22,$55,$AA,$44,$22 ; Wall
  DEFB $06,$04,$04,$04,$88,$50,$20,$10,$08 ; Nasty
  DEFB $07,$03,$03,$0C,$0C,$30,$30,$C0,$C0 ; Ramp
  DEFB $44,$E0,$AA,$00,$66,$66,$66,$66,$66 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5FE7              ; Location in the attribute buffer at 24064: (15,7)
  DEFB $12                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5EE3              ; Location in the attribute buffer at 24064: (7,3)
  DEFB $08                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $05                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $18,$18,$18,$18,$18,$9B,$7F,$3B ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $3A                ; Room to the left (The Beach)
  DEFB $31                ; Room to the right (The Wine Cellar)
  DEFB $35                ; Room above (Back Door)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $34,$10            ; Guardian no. 0x34 (horizontal), base sprite 0,
                          ; initial x=16 (ENTITY52)
  DEFB $62,$09            ; Guardian no. 0x62 (horizontal), base sprite 0,
                          ; initial x=9 (ENTITY98)
  DEFB $63,$14            ; Guardian no. 0x63 (horizontal), base sprite 0,
                          ; initial x=20 (ENTITY99)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x34: Back Stairway (teleport: 3569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$0A,$AA,$AA,$AA ; Room layout
  DEFB $00,$00,$00,$00,$2A,$AA,$AA,$AA
  DEFB $00,$00,$00,$00,$55,$55,$55,$55
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$15,$55,$55,$55,$55
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$05,$55,$55,$55,$55,$55
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $55,$54,$55,$55,$55,$55,$55,$55
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $55,$55,$55,$55,$55,$55,$55,$55
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         Back Stairway          " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $43,$FF,$44,$44,$FF,$11,$11,$FF,$00 ; Floor
  DEFB $1E,$15,$F1,$8F,$A8,$8A,$F8,$1F,$15 ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $47,$03,$01,$0C,$04,$30,$10,$C0,$40 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FE2              ; Location in the attribute buffer at 24064: (15,2)
  DEFB $10                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $35                ; Room to the left (Back Door)
  DEFB $19                ; Room to the right (Cold Store)
  DEFB $36                ; Room above (West  Wing)
  DEFB $31                ; Room below (The Wine Cellar)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $24,$96            ; Guardian no. 0x24 (horizontal), base sprite 4,
                          ; initial x=22 (ENTITY36)
  DEFB $5C,$90            ; Guardian no. 0x5C (horizontal), base sprite 4,
                          ; initial x=16 (ENTITY92)
  DEFB $1D,$83            ; Guardian no. 0x1D (vertical), base sprite 4, x=3
                          ; (ENTITY29)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x35: Back Door (teleport: 13569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$A0,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$A0,$00,$00,$00
  DEFB $00,$00,$00,$00,$A0,$00,$00,$00
  DEFB $00,$00,$00,$00,$A0,$00,$00,$00
  DEFB $00,$00,$00,$00,$A0,$00,$00,$00
  DEFB $00,$00,$00,$00,$A0,$00,$00,$00
  DEFB $00,$00,$00,$00,$A0,$00,$00,$00
  DEFB $00,$00,$00,$00,$A0,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$05,$55,$55,$55,$55
  DEFB $00,$00,$00,$2A,$A0,$00,$00,$00
  DEFB $00,$00,$00,$AA,$A0,$00,$00,$00
  DEFB $00,$00,$02,$AA,$A0,$00,$00,$00
  DEFB $00,$00,$0A,$AA,$A0,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "            Back Door           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $03,$FF,$FF,$FF,$AA,$55,$AA,$55,$00 ; Floor
  DEFB $26,$69,$D2,$A5,$4B,$96,$2D,$5A,$B4 ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $07,$03,$03,$0D,$0F,$36,$3D,$DA,$F4 ; Ramp
  DEFB $22,$F0,$F0,$F0,$F0,$66,$66,$00,$00 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5FF2              ; Location in the attribute buffer at 24064: (15,18)
  DEFB $0E                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FE9              ; Location in the attribute buffer at 24064: (15,9)
  DEFB $05                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $00                ; Room to the left (The Off Licence)
  DEFB $34                ; Room to the right (Back Stairway)
  DEFB $37                ; Room above (West Bedroom)
  DEFB $33                ; Room below (Tool  Shed)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x36: West  Wing (teleport: 23569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$A0,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$A0,$00,$00,$00,$00,$00,$00
  DEFB $00,$A0,$00,$00,$00,$00,$00,$00
  DEFB $55,$A0,$00,$00,$00,$00,$00,$00
  DEFB $00,$A0,$00,$00,$00,$00,$00,$00
  DEFB $00,$A0,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $55,$55,$55,$50,$00,$55,$55,$55
  DEFB $00,$00,$00,$00,$02,$AA,$AA,$AA
  DEFB $00,$00,$00,$00,$0A,$AA,$AA,$AA
  DEFB $00,$00,$00,$00,$2A,$AA,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "           West  Wing           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $41,$F9,$FF,$3F,$D5,$AA,$15,$4A,$84 ; Floor
  DEFB $27,$AC,$AE,$01,$AD,$AD,$02,$AC,$E8 ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $07,$03,$03,$0C,$0C,$30,$30,$C0,$C0 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FF0              ; Location in the attribute buffer at 24064: (15,16)
  DEFB $10                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $37                ; Room to the left (West Bedroom)
  DEFB $1F                ; Room to the right (Swimming Pool)
  DEFB $38                ; Room above (West Wing Roof)
  DEFB $34                ; Room below (Back Stairway)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $61,$0E            ; Guardian no. 0x61 (vertical), base sprite 0, x=14
                          ; (ENTITY97)
  DEFB $59,$C4            ; Guardian no. 0x59 (vertical), base sprite 6, x=4
                          ; (ENTITY89)
  DEFB $14,$09            ; Guardian no. 0x14 (horizontal), base sprite 0,
                          ; initial x=9 (ENTITY20)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x37: West Bedroom (teleport: 123569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$04,$00,$A0,$40,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$A0,$40,$00,$00
  DEFB $00,$00,$10,$00,$A0,$40,$00,$00
  DEFB $00,$00,$00,$00,$A0,$40,$00,$15
  DEFB $00,$00,$04,$00,$A0,$40,$00,$00
  DEFB $00,$00,$00,$00,$A0,$40,$00,$00
  DEFB $00,$00,$00,$10,$A0,$40,$00,$00
  DEFB $00,$00,$00,$00,$A0,$40,$00,$00
  DEFB $00,$00,$04,$00,$00,$40,$00,$00
  DEFB $00,$00,$00,$00,$00,$40,$00,$00
  DEFB $00,$00,$10,$00,$00,$40,$00,$00
  DEFB $00,$00,$08,$00,$00,$40,$00,$00
  DEFB $00,$00,$09,$55,$55,$55,$55,$55
  DEFB $00,$00,$0A,$AA,$A0,$00,$00,$00
  DEFB $00,$00,$00,$00,$A0,$00,$00,$00
  DEFB $00,$00,$00,$00,$A0,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "    West Bedroom                " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $06,$AA,$55,$82,$41,$82,$41,$82,$41 ; Floor
  DEFB $0D,$A8,$55,$A8,$56,$CF,$2E,$26,$C1 ; Wall
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Nasty (unused)
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Ramp (unused)
  DEFB $42,$A5,$FF,$BD,$AA,$55,$BA,$45,$83 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5E7A              ; Location in the attribute buffer at 24064: (3,26)
  DEFB $03                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no ramp in this room)
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $05                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Item graphic (unused)
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $00                ; Room to the left (The Off Licence)
  DEFB $36                ; Room to the right (West  Wing)
  DEFB $39                ; Room above (Above the West Bedroom)
  DEFB $35                ; Room below (Back Door)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $1E,$8B            ; Guardian no. 0x1E (vertical), base sprite 4, x=11
                          ; (ENTITY30)
  DEFB $33,$4E            ; Guardian no. 0x33 (vertical), base sprite 2, x=14
                          ; (ENTITY51)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x38: West Wing Roof (teleport: 4569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $55,$A0,$00,$00,$00,$00,$00,$00
  DEFB $00,$A0,$30,$30,$0C,$0C,$03,$00
  DEFB $00,$A5,$55,$55,$55,$55,$55,$55
  DEFB $00,$A0,$00,$00,$00,$00,$00,$00
  DEFB $00,$A0,$00,$00,$00,$00,$00,$00
  DEFB $50,$A0,$00,$00,$00,$00,$00,$00
  DEFB $00,$A0,$00,$00,$00,$00,$00,$00
  DEFB $01,$A0,$00,$00,$00,$00,$00,$00
  DEFB $00,$A0,$00,$00,$00,$00,$00,$00
  DEFB $04,$A5,$55,$55,$55,$55,$55,$05
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "         West Wing Roof         " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $03,$FF,$AA,$FF,$A4,$A4,$A7,$E4,$3C ; Floor
  DEFB $25,$E1,$84,$1E,$48,$E1,$84,$1E,$48 ; Wall
  DEFB $42,$18,$3C,$7E,$FF,$AF,$55,$3A,$10 ; Nasty
  DEFB $07,$03,$00,$0C,$00,$30,$00,$C0,$00 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FFC              ; Location in the attribute buffer at 24064: (15,28)
  DEFB $04                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $01                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $00,$00,$00,$0A,$0D,$3C,$F2,$C0 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $39                ; Room to the left (Above the West Bedroom)
  DEFB $25                ; Room to the right (Orangery)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $36                ; Room below (West  Wing)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $34,$13            ; Guardian no. 0x34 (horizontal), base sprite 0,
                          ; initial x=19 (ENTITY52)
  DEFB $1C,$14            ; Guardian no. 0x1C (horizontal), base sprite 0,
                          ; initial x=20 (ENTITY28)
  DEFB $3C,$54            ; Arrow flying left to right at pixel y-coordinate 42
                          ; (ENTITY60)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x39: Above the West Bedroom (teleport: 14569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$15,$55
  DEFB $00,$00,$00,$00,$00,$00,$D0,$00
  DEFB $00,$00,$00,$00,$00,$03,$10,$00
  DEFB $00,$00,$00,$00,$00,$0C,$10,$00
  DEFB $00,$00,$00,$00,$00,$30,$10,$00
  DEFB $00,$00,$00,$00,$01,$55,$55,$55
  DEFB $00,$00,$00,$00,$03,$00,$00,$00
  DEFB $00,$00,$04,$00,$0C,$00,$00,$00
  DEFB $00,$00,$00,$00,$A0,$00,$00,$00
  DEFB $00,$00,$10,$00,$A0,$55,$55,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "   Above the West Bedroom       " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $04,$F7,$AA,$55,$EF,$00,$00,$00,$00 ; Floor
  DEFB $23,$AA,$55,$AA,$55,$AA,$55,$AA,$55 ; Wall
  DEFB $06,$30,$60,$C0,$80,$00,$00,$00,$00 ; Nasty
  DEFB $07,$01,$00,$06,$09,$13,$06,$6C,$98 ; Ramp
  DEFB $FF,$00,$00,$00,$00,$00,$00,$00,$00 ; Conveyor (unused)
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $0000              ; Location in the attribute buffer at 24064 (unused)
  DEFB $00                ; Length: 0 (there is no conveyor in this room)
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FB1              ; Location in the attribute buffer at 24064: (13,17)
  DEFB $08                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $08,$10,$20,$21,$12,$AC,$40,$20 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $00                ; Room to the left (The Off Licence)
  DEFB $38                ; Room to the right (West Wing Roof)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $37                ; Room below (West Bedroom)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $07,$CB            ; Guardian no. 0x07 (vertical), base sprite 6, x=11
                          ; (ENTITY7)
  DEFB $33,$4E            ; Guardian no. 0x33 (vertical), base sprite 2, x=14
                          ; (ENTITY51)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x3A: The Beach (teleport: 24569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$AA,$AA
  DEFB $00,$00,$00,$00,$00,$00,$AA,$AA
  DEFB $AA,$A0,$00,$00,$00,$00,$AA,$AA
  DEFB $00,$00,$00,$00,$00,$00,$AA,$AA
  DEFB $00,$00,$00,$00,$00,$00,$AA,$AA
  DEFB $00,$00,$00,$00,$00,$00,$AA,$AA
  DEFB $00,$05,$D5,$75,$5D,$75,$AA,$AA
  DEFB $00,$15,$55,$55,$55,$55,$AA,$AA
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "            The Beach           " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $0D,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $32,$00,$00,$40,$04,$00,$10,$00,$01 ; Floor
  DEFB $2A,$44,$00,$92,$24,$80,$28,$82,$50 ; Wall
  DEFB $30,$42,$81,$E7,$81,$5A,$7E,$3C,$42 ; Nasty
  DEFB $0E,$01,$03,$07,$0F,$1E,$37,$7F,$FB ; Ramp
  DEFB $2C,$4E,$AA,$00,$40,$40,$44,$AA,$FF ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5FE0              ; Location in the attribute buffer at 24064: (15,0)
  DEFB $05                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $01                ; Direction (up to the right)
  DEFW $5FC5              ; Location in the attribute buffer at 24064: (14,5)
  DEFB $01                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $02                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $04,$05,$0B,$0B,$17,$37,$6F,$EF ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $3B                ; Room to the left (The Yacht)
  DEFB $33                ; Room to the right (Tool  Shed)
  DEFB $3A                ; Room above (The Beach)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $01,$0E            ; Rope at x=14 (ENTITY1)
  DEFB $3C,$54            ; Arrow flying left to right at pixel y-coordinate 42
                          ; (ENTITY60)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x3B: The Yacht (teleport: 124569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $55,$60,$00,$00,$00,$00,$00,$00
  DEFB $00,$20,$00,$00,$00,$00,$00,$00
  DEFB $00,$20,$00,$00,$00,$00,$00,$00
  DEFB $00,$20,$00,$00,$00,$00,$00,$00
  DEFB $00,$20,$03,$03,$00,$C0,$00,$00
  DEFB $55,$6A,$AA,$AA,$AA,$81,$55,$55
  DEFB $01,$00,$00,$00,$02,$81,$00,$00
  DEFB $01,$00,$00,$00,$02,$81,$00,$00
  DEFB $01,$00,$00,$00,$02,$81,$00,$00
  DEFB $01,$00,$00,$00,$02,$80,$00,$00
  DEFB $AA,$AA,$AA,$AA,$AA,$80,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "           The Yacht            " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $06,$BB,$DD,$DD,$EE,$00,$00,$00,$00 ; Floor
  DEFB $3D,$BB,$77,$EE,$DD,$BB,$77,$EE,$DD ; Wall
  DEFB $42,$7E,$BF,$BF,$6E,$2C,$2C,$AD,$FF ; Nasty
  DEFB $07,$80,$40,$20,$10,$08,$04,$02,$01 ; Ramp
  DEFB $0D,$E0,$AA,$38,$01,$83,$C7,$7C,$10 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $00                ; Direction (left)
  DEFW $5FF5              ; Location in the attribute buffer at 24064: (15,21)
  DEFB $0B                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5F2A              ; Location in the attribute buffer at 24064: (9,10)
  DEFB $05                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $05                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $CE,$F1,$B9,$D5,$EF,$D7,$BB,$FF ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $3C                ; Room to the left (The Bow)
  DEFB $3A                ; Room to the right (The Beach)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $35,$08            ; Guardian no. 0x35 (horizontal), base sprite 0,
                          ; initial x=8 (ENTITY53)
  DEFB $1B,$15            ; Guardian no. 0x1B (vertical), base sprite 0, x=21
                          ; (ENTITY27)
  DEFB $FF,$11            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

; Room 0x3C: The Bow (teleport: 34569)
;
; Used by the routine at INITROOM.
;
; The first 128 bytes are copied to ROOMLAYOUT and define the room layout. Each
; bit-pair (bits 7 and 6, 5 and 4, 3 and 2, or 1 and 0 of each byte) determines
; the type of tile (background, floor, wall or nasty) that will be drawn at the
; corresponding location.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; Room layout
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$01,$55,$55
  DEFB $00,$00,$00,$00,$00,$00,$80,$00
  DEFB $00,$00,$00,$00,$04,$00,$80,$00
  DEFB $00,$00,$00,$00,$00,$00,$90,$00
  DEFB $00,$00,$00,$00,$00,$00,$80,$00
  DEFB $00,$00,$00,$15,$55,$55,$55,$55
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $FF,$FF,$FF,$FF,$C0,$00,$00,$00
; The next 32 bytes are copied to ROOMNAME and specify the room name.
  DEFM "             The Bow            " ; Room name
; The next 54 bytes are copied to BACKGROUND and contain the attributes and
; graphic data for the tiles used to build the room.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00 ; Background
  DEFB $44,$FF,$AA,$55,$FF,$00,$00,$00,$00 ; Floor
  DEFB $3D,$C9,$C9,$C9,$C9,$C9,$C9,$C9,$C9 ; Wall
  DEFB $4F,$40,$82,$52,$00,$00,$00,$00,$00 ; Nasty
  DEFB $07,$80,$40,$20,$10,$08,$04,$02,$01 ; Ramp
  DEFB $0E,$FF,$AA,$AA,$00,$AA,$FF,$00,$00 ; Conveyor
; The next four bytes are copied to CONVDIR and specify the direction, location
; and length of the conveyor.
  DEFB $01                ; Direction (right)
  DEFW $5FF1              ; Location in the attribute buffer at 24064: (15,17)
  DEFB $0F                ; Length
; The next four bytes are copied to RAMPDIR and specify the direction, location
; and length of the ramp.
  DEFB $00                ; Direction (up to the left)
  DEFW $5FD0              ; Location in the attribute buffer at 24064: (14,16)
  DEFB $06                ; Length
; The next byte is copied to BORDER and specifies the border colour.
  DEFB $05                ; Border colour
; The next two bytes are copied to XROOM223, but are not used.
  DEFB $00,$00            ; Unused
; The next eight bytes are copied to ITEM and define the item graphic.
  DEFB $48,$39,$26,$DA,$5B,$64,$9C,$12 ; Item graphic
; The next four bytes are copied to LEFT and specify the rooms to the left, to
; the right, above and below.
  DEFB $00                ; Room to the left (The Off Licence)
  DEFB $3B                ; Room to the right (The Yacht)
  DEFB $00                ; Room above (The Off Licence)
  DEFB $00                ; Room below (The Off Licence)
; The next three bytes are copied to XROOM237, but are not used.
  DEFB $00,$00,$00        ; Unused
; The next eight pairs of bytes are copied to ENTITIES and specify the entities
; (ropes, arrows, guardians) in this room.
  DEFB $69,$17            ; Guardian no. 0x69 (horizontal), base sprite 0,
                          ; initial x=23 (ENTITY105)
  DEFB $6E,$14            ; Guardian no. 0x6E (horizontal), base sprite 0,
                          ; initial x=20 (ENTITY110)
  DEFB $FF,$00            ; Terminator (ENTITY127)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)
  DEFB $00,$00            ; Nothing (ENTITYDEFS)

  END BEGIN

