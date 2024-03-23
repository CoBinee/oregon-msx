; Game.inc : ゲーム
;


; マクロの定義
;

; スプライト
GAME_SPRITE_NULL                =   0x00
GAME_SPRITE_PLAYER              =   0x00
GAME_SPRITE_ENEMY               =   0x20

; ゲーム
GAME_PROC_L                     =   0x00
GAME_PROC_H                     =   0x01
GAME_STATE                      =   0x02
GAME_FLAG                       =   0x03
GAME_FRAME                      =   0x04
GAME_COUNT                      =   0x05
GAME_CURSOR                     =   0x06
GAME_CURSOR_UP                  =   0x07
GAME_CURSOR_DOWN                =   0x08
GAME_CURSOR_LEFT                =   0x09
GAME_CURSOR_RIGHT               =   0x0a
GAME_PRINT_LOCATE_L             =   0x0b
GAME_PRINT_LOCATE_H             =   0x0c
GAME_PRINT_STRING_L             =   0x0d
GAME_PRINT_STRING_H             =   0x0e
GAME_PRINT_SCROLL               =   0x0f
GAME_SELECT_L                   =   0x10
GAME_SELECT_H                   =   0x11
GAME_SELECT_ITEM                =   0x12
GAME_SELECT_SIZE                =   0x13
GAME_AMOUNT_L                   =   0x14
GAME_AMOUNT_H                   =   0x15
GAME_AMOUNT_MINIMUM_L           =   0x16
GAME_AMOUNT_MINIMUM_H           =   0x17
GAME_AMOUNT_MAXIMUM_L           =   0x18
GAME_AMOUNT_MAXIMUM_H           =   0x19
GAME_LENGTH                     =   0x1a

; 処理
GAME_PROC_NULL                  =   0x00

; 状態
GAME_STATE_NULL                 =   0x00

; フラグ
GAME_FLAG_NULL                  =   0x00
GAME_FLAG_SELECT_BIT            =   0x00
GAME_FLAG_SELECT                =   (1 << GAME_FLAG_SELECT_BIT)
GAME_FLAG_AMOUNT_BIT            =   0x01
GAME_FLAG_AMOUNT                =   (1 << GAME_FLAG_AMOUNT_BIT)
GAME_FLAG_FEED_BIT              =   0x02
GAME_FLAG_FEED                  =   (1 << GAME_FLAG_FEED_BIT)
GAME_FLAG_BANG_BIT              =   0x03
GAME_FLAG_BANG                  =   (1 << GAME_FLAG_BANG_BIT)

; フレーム
GAME_FRAME_NULL                 =   0x00

; カウント
GAME_COUNT_NULL                 =   0x00

; カーソル
GAME_CURSOR_NULL                =   0x00
GAME_CURSOR_INTERVAL_0          =   0x18
GAME_CURSOR_INTERVAL_1          =   0x02
GAME_CURSOR_UP_EDGE_BIT         =   0x00
GAME_CURSOR_UP_EDGE             =   (1 << GAME_CURSOR_UP_EDGE_BIT)
GAME_CURSOR_UP_REPEAT_BIT       =   0x01
GAME_CURSOR_UP_REPEAT           =   (1 << GAME_CURSOR_UP_REPEAT_BIT)
GAME_CURSOR_DOWN_EDGE_BIT       =   0x02
GAME_CURSOR_DOWN_EDGE           =   (1 << GAME_CURSOR_DOWN_EDGE_BIT)
GAME_CURSOR_DOWN_REPEAT_BIT     =   0x03
GAME_CURSOR_DOWN_REPEAT         =   (1 << GAME_CURSOR_DOWN_REPEAT_BIT)
GAME_CURSOR_LEFT_EDGE_BIT       =   0x04
GAME_CURSOR_LEFT_EDGE           =   (1 << GAME_CURSOR_LEFT_EDGE_BIT)
GAME_CURSOR_LEFT_REPEAT_BIT     =   0x05
GAME_CURSOR_LEFT_REPEAT         =   (1 << GAME_CURSOR_LEFT_REPEAT_BIT)
GAME_CURSOR_RIGHT_EDGE_BIT      =   0x06
GAME_CURSOR_RIGHT_EDGE          =   (1 << GAME_CURSOR_RIGHT_EDGE_BIT)
GAME_CURSOR_RIGHT_REPEAT_BIT    =   0x07
GAME_CURSOR_RIGHT_REPEAT        =   (1 << GAME_CURSOR_RIGHT_REPEAT_BIT)

; 出力
GAME_PRINT_NULL                 =   0x00

; 選択
GAME_SELECT_NULL                =   0x00

; 量
GAME_AMOUNT_NULL                =   0x00

; 文字列
GAME_STRING_NULL                =   0x0000
GAME_STRING_LENGTH              =   0x0100

; 数値
GAME_VALUE_NULL                 =   0x00
GAME_VALUE_LENGTH               =   0x05

; 外部関数宣言
;

    ; ゲーム
    .globl  _GameInitialize
    .globl  _GameUpdate
    .globl  _GameClearString
    .globl  _GameGetString
    .globl  _GameConcatString
    .globl  _GameConcatValue
    .globl  _GamePrint
    .globl  _GameIsPrint
    .globl  _GameScroll
    .globl  _GameSelect
    .globl  _GameGetSelectItem
    .globl  _GameAmount
    .globl  _GameGetAmountValue
    .globl  _GameFeed
    .globl  _GameIsFeed
    .globl  _GameBang
    .globl  _GameIsBang
    .globl  _GamePrintString
    .globl  _GamePrintValue
    .globl  _GameDiv

    ; 説明
    .globl  _Instruction

    ; 初期化
    .globl  _Initialize

    ; 日付
    .globl  _Date

    ; 開始
    .globl  _Begin

    ; 交易所
    .globl  _Fort

    ; 狩り
    .globl  _Hunt

    ; 食事
    .globl  _Eat

    ; ライダー
    .globl  _Rider

    ; イベント
    .globl  _Event

    ; 山
    .globl  _Mountain

    ; 病気
    .globl  _Illness

    ; ゴール
    .globl  _Final

    ; 死亡
    .globl  _Die
    .globl  _DiePrintNoDoctor
    .globl  _DiePrintNoMedicine
    .globl  _DiePrintStarvation

; 外部変数宣言
;

    .globl  _game
