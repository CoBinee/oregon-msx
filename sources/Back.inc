; Back.inc : 背景
;


; マクロの定義
;

; 背景
BACK_PROC_L                     =   0x00
BACK_PROC_H                     =   0x01
BACK_STATE                      =   0x02
BACK_FLAG                       =   0x03
BACK_FRAME                      =   0x04
BACK_COUNT                      =   0x05
BACK_PATTERN_NAME_L             =   0x06
BACK_PATTERN_NAME_H             =   0x07
BACK_LENGTH                     =   0x08

; 処理
BACK_PROC_NULL                  =   0x00

; 状態
BACK_STATE_NULL                 =   0x00

; フラグ
BACK_FLAG_NULL                  =   0x00

; フレーム
BACK_FRAME_NULL                 =   0x00

; カウント
BACK_COUNT_NULL                 =   0x00

; パターンネーム
BACK_PATTERN_NAME_NULL          =   0x00

; 外部関数宣言
;

    ; 背景
    .globl  _BackInitialize
    .globl  _BackUpdate
    .globl  _BackClear
    .globl  _BackLogo
    .globl  _BackTrail
    .globl  _BackFort
    .globl  _BackYard
    .globl  _BackOregon

; 外部変数宣言
;

    .globl  _back
